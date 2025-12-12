# Workshop Step 4: Adding Memory Bank (Solution Backend)

This is the **Completed Solution Backend** for the "Adding Memory Bank" workshop step.

It runs a Python Agents Development Kit (ADK) Agent that uses an MCP Server to interact with the frontend and a "Memory Bank" to persist context.

## 🛠️ Prerequisites

-   Python 3.10+
-   `uv` (recommended for dependency management)
-   Gemini API Key

## 🚀 How to Run

1.  **Install Dependencies:**
    ```bash
    uv sync
    ```

2.  **Environment Setup:**
    Ensure you have a `.env` file with your `GOOGLE_API_KEY`.

3.  **Run the App:**
    Use the provided script to start both the MCP Server and the Agent.
    ```bash
    ./start_app.sh
    ```
    *(Or `python main.py` if running manually)*

## 🧠 Architecture

-   **`agent.py`**: Defines the ADK Agent logic, including tools and model configuration.
-   **`mcp_server.py`**: A FastMCP server that exposes tools to the Agent (Pattern Generation, Photo Taking).
-   **`main.py`**: connect the agent and the mcp server.
-   **Memory Bank**: Implements the context storage and retrieval mechanism.

## 🔧 Troubleshooting

-   **Google Cloud Auth**: If you see auth errors, try running `gcloud auth application-default login`.
-   **Port Conflicts**: Ensure port 8001 is free. You can change it in the run command if needed.
-   **Env Helper**: If `deploy_agent.py` fails to save env vars, verify file permissions.