# AI-DRIVEN-ACADEMIC-DATA-ASSISTANT

This is a Streamlit-based chatbot that allows users to query a school database and retrieve information about students, their marks, and admission details. It leverages SQL, Sentence Transformers, FAISS for retrieval-augmented generation (RAG), and Google's Gemini API for natural language understanding and generation.
![image](https://github.com/user-attachments/assets/cd3bd804-e3e7-48c7-a7a8-1a04036e62a2)

## Features

-   **SQL Database Interaction:**
    -      Retrieves student information based on various criteria (name, ID, address, parent name, DOB, marks, grades, etc.).
    -      Supports queries related to admission details.
    -      Handles numeric and date-based queries.
-   **Natural Language Understanding:**
    -      Uses Sentence Transformers to encode user queries and retrieve relevant information using FAISS.
    -      Leverages Google's Gemini API for generating natural language responses.
-   **Retrieval-Augmented Generation (RAG):**
    -      Enhances responses by retrieving relevant context from predefined texts.
-   **Guardrails:**
    -      Implements guardrails to prevent the display of sensitive information and offensive content.
    -   Handles long inputs and outputs.
-   **Streamlit Interface:**
    -      Provides a user-friendly chat interface for interacting with the chatbot.
    -   Displays SQL query results as tables.

## Requirements

-   Python 3.7+
-   Streamlit
-   MySQL Connector
-   Sentence Transformers
-   FAISS
-   NumPy
-   Google Generative AI (Gemini API)

## Installation

1.  **Clone the repository:**

    ```bash
    git clone [repository URL]
    cd [repository directory]
    ```

2.  **Create a virtual environment (recommended):**

    ```bash
    python -m venv venv
    ```

3.  **Activate the virtual environment:**

    -   On Windows:

        ```bash
        venv\Scripts\activate
        ```

    -   On macOS and Linux:

        ```bash
        source venv/bin/activate
        ```

4.  **Install the required packages:**

    ```bash
    pip install streamlit mysql-connector-python sentence-transformers faiss-cpu numpy google-generativeai
    ```

5.  **Set up your MySQL database:**
    -   Create a database named `school_data`.
    -   Create tables `student_master`, `assessment_entry`, and `admission_form` with the necessary columns.
    -   Populate the tables with your school data.
6.  **Configure the database connection:**
    -   Update the `db_config` dictionary in `chatbot.py` with your MySQL database credentials.
7.  **Configure the Gemini API key:**
    -   Replace `"AIzaSyDwlS39w8DpJDCNiLX2QAkxRLekBLVXS-8"` with your actual Gemini API key.

## Usage

1.  **Run the Streamlit app:**

    ```bash
    streamlit run chatbot.py
    ```

2.  **Open the app in your browser:**
    -   The app will open in your default browser at `http://localhost:8501`.

3.  **Start chatting:**
    -   Type your questions in the chat input and press Enter.

## Code Structure

-   `chatbot.py`: Contains the main Streamlit app code, including database interaction, RAG, and Gemini API integration.
-   RAGSystem class: Handles the RAG functionality using Sentence Transformers and FAISS.
-   query\_sql\_database function: Processes SQL queries based on user input.
-   query\_gemini function: Sends prompts to the Gemini API and retrieves responses.
-   apply\_guardrails function: Implements guardrails to filter sensitive and offensive content.
-   get\_response function: Orchestrates the response generation process.
-   main function: Sets up the Streamlit interface and handles user interactions.

## Database Schema (Example)

```sql
-- student_master table
CREATE TABLE student_master (
    Student_ID VARCHAR(255) PRIMARY KEY,
    Student_Name VARCHAR(255),
    Student_Address VARCHAR(255),
    Parent_Name VARCHAR(255),
    DOB DATE
);

-- assessment_entry table
CREATE TABLE assessment_entry (
    Student_ID VARCHAR(255),
    Student_Name VARCHAR(255),
    Academic_Year INT,
    Class VARCHAR(255),
    Section VARCHAR(255),
    Subject VARCHAR(255),
    Exam_Type VARCHAR(255),
    Marks INT,
    Grade VARCHAR(255),
    FOREIGN KEY (Student_ID) REFERENCES student_master(Student_ID)
);

-- admission_form table
CREATE TABLE admission_form (
    Admission_No VARCHAR(255) PRIMARY KEY,
    Admission_Date DATE,
    Student_ID VARCHAR(255),
    Student_Name VARCHAR(255),
    Academic_Year INT,
    Class VARCHAR(255),
    Section VARCHAR(255),
    FOREIGN KEY (Student_ID) REFERENCES student_master(Student_ID)
);
