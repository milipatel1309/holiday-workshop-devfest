# Workshop Step 4: Adding Memory Bank (Starter)

This is the **Starter** project for the "Adding Memory Bank" workshop step.

In this step, you will enhance the agent with a "Memory Bank" to persist context and enable smarter interactions.

## 🚀 Getting Started

1.  **Install Dependencies:**
    ```bash
    npm install
    ```

2.  **Run Development Server:**
    ```bash
    npm run dev
    ```

3.  **Open in Browser:**
    Navigate to `http://localhost:3010`.

## 📂 Project Structure

-   `src/components`: React components for the UI overlay and 3D scene.
-   `src/hooks`: Custom hooks for WebSocket communication and state management.
-   `src/utils`: Helper functions for animations and data processing.

## 🔧 Troubleshooting

-   **Port in Use**: If port 3010 is taken, the app will try the next available port. Check the terminal output.
-   **WebSocket Connection**: Ensure the backend is running on `http://localhost:8001` (or configured port) for real-time features.

## 🎯 Goal

Your goal is to complete the frontend changes required to support the new Memory Bank features in the backend.

## 🧠 Memory Bank Features

-   **Session Management**: Tracking user conversations.
-   **Context Persistance**: Remembering user preferences (like sweater patterns).

## Credits

Frontend UI is credit to [https://github.com/blackboxo/christmas-tree](https://github.com/blackboxo/christmas-tree).

> **Note**: You don't need this complex UI to understand the Memory Bank concepts. It is included to make the project look cooler and demonstrate a rich interaction model.
