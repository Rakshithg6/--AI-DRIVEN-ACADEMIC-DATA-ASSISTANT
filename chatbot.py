import streamlit as st
import mysql.connector
from sentence_transformers import SentenceTransformer
import faiss
import numpy as np
import re
import google.generativeai as genai

# Gemini API key
GEMINI_API_KEY = "AIzaSyDwlS39w8DpJDCNiLX2QAkxRLekBLVXS-8"
genai.configure(api_key=GEMINI_API_KEY)

db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'Rakshith@61103kg',
    'database': 'school_data'
}

# Initialize RAGSystem globally
class RAGSystem:
    def __init__(self):
        self.encoder = SentenceTransformer('all-MiniLM-L6-v2')
        self.index = faiss.IndexFlatL2(384)
        self.texts = []
        self.setup_rag_data()

    def setup_rag_data(self):
        self.texts = [
            "School data includes student records, grades, and admission details.",
            "SQL manages educational databases efficiently.",
            "RAG helps answer questions beyond the database.",
            "Python is a popular programming language used for many applications."
        ]
        embeddings = self.encoder.encode(self.texts)
        self.index.add(np.array(embeddings, dtype='float32'))

    def retrieve_similar(self, query, k=1):
        query_embedding = self.encoder.encode([query])
        distances, indices = self.index.search(np.array(query_embedding, dtype='float32'), k)
        return [self.texts[idx] for idx in indices[0]]

rag_system = RAGSystem()

def query_gemini(prompt):
    try:
        model = genai.GenerativeModel('gemini-1.5-flash')
        response = model.generate_content(prompt)
        return response.text
    except Exception as e:
        return f"Error querying Gemini: {e}"

def query_sql_database(user_input):
    try:
        conn = mysql.connector.connect(**db_config)
        c = conn.cursor()
        user_input_lower = user_input.lower()

        # Check for parent name query first
        parent_pattern = r'parent\s*(?:name\s*)?(?:is|=)?\s*([\w\s]+)'
        parent_match = re.search(parent_pattern, user_input_lower)
        
        if parent_match:
            parent_name = parent_match.group(1).strip()
            query = """
                SELECT Student_ID, Student_Name, Student_Address, Parent_Name, DOB 
                FROM student_master 
                WHERE Parent_Name LIKE %s
            """
            c.execute(query, (f"%{parent_name}%",))
            results = c.fetchall()
            if results:
                return [dict(zip(["Student_ID", "Student_Name", "Student_Address", "Parent_Name", "DOB"], row)) for row in results]
            return "No students found with that parent name."

        tables = {
            "student_master": ["Student_ID", "Student_Name", "Student_Address", "Parent_Name", "DOB"],
            "assessment_entry": ["Student_ID", "Student_Name", "Academic_Year", "Class", "Section", "Subject", "Exam_Type", "Marks", "Grade"],
            "admission_form": ["Admission_No", "Admission_Date", "Student_ID", "Student_Name", "Academic_Year", "Class", "Section"]
        }

        string_columns = {
            "student_master": ["Student_ID", "Student_Name", "Student_Address", "Parent_Name"],
            "assessment_entry": ["Student_ID", "Student_Name", "Class", "Section", "Subject", "Exam_Type", "Grade"],
            "admission_form": ["Admission_No", "Student_ID", "Student_Name", "Class", "Section"]
        }
        numeric_columns = {
            "assessment_entry": ["Academic_Year", "Marks"],
            "admission_form": ["Academic_Year"]
        }
        date_columns = {
            "student_master": ["DOB"],
            "admission_form": ["Admission_Date"]
        }

        keyword_to_column = {
            "id": ("student_master", "Student_ID"), "student id": ("student_master", "Student_ID"),
            "name": ("student_master", "Student_Name"), "student name": ("student_master", "Student_Name"),
            "address": ("student_master", "Student_Address"), "location": ("student_master", "Student_Address"),
            "from": ("student_master", "Student_Address"), "parent": ("student_master", "Parent_Name"),
            "parent name": ("student_master", "Parent_Name"), "parents name": ("student_master", "Parent_Name"),
            "father": ("student_master", "Parent_Name"), "father name": ("student_master", "Parent_Name"),
            "dob": ("student_master", "DOB"), "birth": ("student_master", "DOB"), "born": ("student_master", "DOB"),
            "marks": ("assessment_entry", "Marks"), "score": ("assessment_entry", "Marks"),
            "scored": ("assessment_entry", "Marks"), "grade": ("assessment_entry", "Grade"),
            "subject": ("assessment_entry", "Subject"), "exam": ("assessment_entry", "Exam_Type"),
            "exam type": ("assessment_entry", "Exam_Type"), "class": ("assessment_entry", "Class"),
            "section": ("assessment_entry", "Section"), "year": ("assessment_entry", "Academic_Year"),
            "academic year": ("assessment_entry", "Academic_Year"), "admission": ("admission_form", "Admission_No"),
            "admission no": ("admission_form", "Admission_No"), "admission number": ("admission_form", "Admission_No"),
            "date": ("admission_form", "Admission_Date"), "admission date": ("admission_form", "Admission_Date")
        }

        operators = {
            "greater than": ">", "more than": ">", "above": ">", "less than": "<", "below": "<",
            "equals": "=", "is": "=", "are": "=", "whose": "="
        }

        conditions = []
        selected_tables = set()
        involves_marks = False
        involves_admission = False

        # Subject detection
        subject_map = {
            "math": "Math Marks", "maths": "Math Marks", "science": "Science Marks",
            "social": "Social Marks", "social science": "Social Marks", "english": "English Marks",
            "hindi": "Hindi Marks", "telugu": "Telugu Marks"
        }
        subject_detected = None
        for subject_key, subject_value in subject_map.items():
            if subject_key in user_input_lower or f"{subject_key} marks" in user_input_lower:
                subject_detected = subject_value
                involves_marks = True
                selected_tables.add("assessment_entry")
                conditions.append(f"LOWER(TRIM(a.Subject)) = LOWER('{subject_detected}')")
                break

        # Address detection
        from_match = re.search(r'(?:from|who are from)\s+([\w\s]+?)(?=\s*(?:from|whose|with|in|$))', user_input_lower)
        if from_match:
            location = from_match.group(1).strip()
            conditions.append(f"LOWER(TRIM(s.Student_Address)) = LOWER('{location}')")
            selected_tables.add("student_master")

        # Grade detection
        grade_match = re.search(r'(?:grade|has grade)\s*(?:is|=)?\s*([a-zA-Z][+-]?)', user_input_lower)
        if grade_match:
            grade_value = grade_match.group(1).strip().upper()
            involves_marks = True
            selected_tables.add("assessment_entry")
            conditions.append(f"LOWER(TRIM(a.Grade)) = LOWER('{grade_value}')")

        # Process keywords
        for keyword, (table, column) in keyword_to_column.items():
            if keyword in user_input_lower and keyword != "from":
                selected_tables.add(table)
                if table == "assessment_entry" and column in ["Marks", "Grade", "Subject", "Exam_Type", "Class", "Section", "Academic_Year"]:
                    involves_marks = True
                if table == "admission_form":
                    involves_admission = True

                if column in string_columns.get(table, []):
                    # Specific fix for parent name
                    if column == "Parent_Name":
                        parent_match = re.search(r'parent\s*(?:name\s*)?(?:is|=|whose)?\s*([\w\s]+?)(?:\s*$|\s+(?:and|or|from|whose|with|in))', user_input_lower)
                        if parent_match:
                            value = parent_match.group(1).strip()
                            selected_tables.add("student_master")
                            conditions.append(f"TRIM(s.Parent_Name) LIKE '%{value}%'")
                    else:
                        exact_match = re.search(rf'(?:{keyword}\s*(?:is|equals|=|are|whose)|whose\s*{keyword}\s*(?:is|=)|details\s*of\s*{keyword}\s*|where\s*their\s*{keyword}\s*(?:is|=))\s*([\w\s]+?)(?=\s*(?:from|whose|with|in|$))', user_input_lower)
                        if exact_match:
                            value = exact_match.group(1).strip()
                            prefix = "a." if involves_marks else "s." if table == "student_master" else "af."
                            conditions.append(f"LOWER(TRIM({prefix}{column})) = LOWER('{value}')")

                elif column in numeric_columns.get(table, []):
                    for op_name, op_symbol in operators.items():
                        pattern = rf'(?:{keyword}\s*{op_name}|{op_name})\s*(\d+)'
                        match = re.search(pattern, user_input_lower)
                        if match and involves_marks:
                            value = match.group(1)
                            conditions.append(f"a.{column} {op_symbol} {value}")

                elif column in date_columns.get(table, []):
                    year_pattern = rf'{keyword}\s*(?:in|is|equals|=|are|whose)\s*(\d{{4}})'
                    match = re.search(year_pattern, user_input_lower)
                    if match:
                        value = match.group(1)
                        prefix = "s." if table == "student_master" else "af."
                        conditions.append(f"YEAR({prefix}{column}) = {value}")

        # Handle "all students" query only if no specific conditions are present and explicitly requested
        if "student" in user_input_lower and ("list" in user_input_lower or "all" in user_input_lower) and not conditions and "where" not in user_input_lower:
            query = """
                SELECT DISTINCT s.Student_ID, s.Student_Name, s.Student_Address, s.Parent_Name, s.DOB
                FROM student_master s
            """
            c.execute(query)
            results = c.fetchall()
            if results:
                return [dict(zip(tables["student_master"], row)) for row in results]
            else:
                return "No students found in the database."

        if conditions:
            base_query = """
                SELECT DISTINCT s.Student_ID, s.Student_Name, s.Student_Address, s.Parent_Name, s.DOB
                FROM student_master s
            """
            
            if involves_marks:
                query = f"""
                    SELECT DISTINCT s.*, 
                           a.Academic_Year, a.Class, a.Section, a.Subject, a.Exam_Type, a.Marks, a.Grade
                    FROM student_master s
                    LEFT JOIN assessment_entry a ON s.Student_ID = a.Student_ID
                    WHERE {' AND '.join(conditions)}
                """
                columns = tables["student_master"] + ["Academic_Year", "Class", "Section", "Subject", "Exam_Type", "Marks", "Grade"]
            else:
                query = f"""
                    {base_query}
                    WHERE {' AND '.join(conditions)}
                """
                columns = tables["student_master"]

            c.execute(query)
            results = c.fetchall()
            if results:
                return [dict(zip(columns, row)) for row in results]
            else:
                suggestions = []
                if "marks" in user_input_lower or "score" in user_input_lower or "scored" in user_input_lower:
                    subject_match = re.search(r'(math|maths|science|social|social science|english|hindi|telugu)', user_input_lower)
                    if subject_match:
                        subject = subject_match.group(1)
                        subject_name = subject_map.get(subject, "Math Marks")
                        c.execute(f"SELECT DISTINCT Marks FROM assessment_entry WHERE LOWER(TRIM(Subject)) = LOWER('{subject_name}') ORDER BY Marks")
                        marks = [row[0] for row in c.fetchall()]
                        if marks:
                            suggestions.append(f"Try a different mark threshold (e.g., '{subject} marks greater than {max(marks)}' or 'less than {min(marks)}').")
                if "address" in user_input_lower or "from" in user_input_lower:
                    c.execute("SELECT DISTINCT Student_Address FROM student_master")
                    addresses = [row[0] for row in c.fetchall()]
                    if addresses:
                        suggestions.append(f"Try another location (e.g., 'from {addresses[0]}').")
                if "parent" in user_input_lower or "father" in user_input_lower:
                    c.execute("SELECT DISTINCT Parent_Name FROM student_master")
                    parents = [row[0] for row in c.fetchall()]
                    if parents:
                        suggestions.append(f"Try another parent name (e.g., 'parent name is {parents[0]}').")
                if "born" in user_input_lower or "dob" in user_input_lower or "birth" in user_input_lower:
                    c.execute("SELECT DISTINCT YEAR(DOB) FROM student_master ORDER BY DOB")
                    years = [row[0] for row in c.fetchall()]
                    if years:
                        suggestions.append(f"Try another year (e.g., 'born in {years[0]}').")
                if "grade" in user_input_lower:
                    c.execute("SELECT DISTINCT Grade FROM assessment_entry")
                    grades = [row[0] for row in c.fetchall()]
                    if grades:
                        suggestions.append(f"Try another grade (e.g., 'grade is {grades[0]}').")
                return f"No data found matching your query. Suggestions: {' '.join(suggestions)}" if suggestions else "No data found matching your query."

        conn.close()
        return None

    except mysql.connector.Error as e:
        st.error(f"Database error: {e}")
        return None

def apply_guardrails(user_input, response):
    def contains_sensitive_info(text):
        sensitive_patterns = [r'password', r'api[_-]?key', r'secret', r'token', r'credential']
        return any(re.search(pattern, text.lower()) for pattern in sensitive_patterns)

    def contains_toxic_or_offensive(text):
        toxic_patterns = [r'suicide', r'kill', r'hate', r'die', r'harm', r'violent', r'abuse', r'racist', r'offensive']
        return any(re.search(pattern, text.lower()) for pattern in toxic_patterns)
    
    if not user_input or not isinstance(user_input, str):
        return "Invalid input. Please provide a valid text query."
    if len(user_input) > 500:
        return "Input too long. Please keep your query under 500 characters."
    if contains_toxic_or_offensive(user_input):
        return "I can't assist with that request due to offensive or inappropriate language."
    if contains_sensitive_info(user_input):
        return "For security reasons, I cannot process requests containing sensitive information."
    if isinstance(response, list) or response is None:
        return response
    
    response_str = str(response)
    if len(response_str) > 2000:
        return response_str[:1997] + "..."
    if contains_toxic_or_offensive(response_str):
        return "I can't assist with that request due to offensive or inappropriate language."
    if contains_sensitive_info(response_str):
        st.write(f"Debug: Response filtered as sensitive: {response_str}")
        return "Response contained sensitive information and was filtered."
    return response

def get_response(user_input):
    guard_response = apply_guardrails(user_input, None)
    if guard_response != None and isinstance(guard_response, str):
        return guard_response

    sql_answer = query_sql_database(user_input)
    if sql_answer is not None:
        if isinstance(sql_answer, list):
            return {"type": "table", "data": sql_answer}
        return apply_guardrails(user_input, sql_answer)
    
    rag_result = rag_system.retrieve_similar(user_input)[0]
    prompt = f"""Based on the context: '{rag_result}', provide a helpful and informative response to: {user_input}.
    If this is a technical question, give a clear explanation.
    If this is about programming, include brief examples if relevant.
    Keep the response professional and avoid inappropriate content."""
    
    gemini_response = query_gemini(prompt)
    return apply_guardrails(user_input, gemini_response)

def main():
    st.title("School Data Chatbot")
    st.write("Ask me anything about students, marks, admissions, or anything else!")

    if "messages" not in st.session_state:
        st.session_state.messages = []

    for message in st.session_state.messages:
        with st.chat_message(message["role"]):
            if isinstance(message["content"], dict) and message["content"].get("type") == "table":
                st.table(message["content"]["data"])
            else:
                st.markdown(message["content"])

    if user_input := st.chat_input("Type your question here"):
        st.session_state.messages.append({"role": "user", "content": user_input})
        with st.chat_message("user"):
            st.markdown(user_input)

        with st.chat_message("assistant"):
            response = get_response(user_input)
            if isinstance(response, dict) and response.get("type") == "table":
                st.table(response["data"])
            elif response:
                st.markdown(response)
            st.session_state.messages.append({"role": "assistant", "content": response})

if __name__ == "__main__":
    main()