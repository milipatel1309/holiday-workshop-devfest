# Workshop Step 3: Connect ADK Agent to MCP UI (Starter)

This is the **Starter** project for the "Connect ADK Agent to MCP UI" workshop step.

In this step, you will be working on connecting a React frontend to a backend Python ADK Agent that controls a 3D Christmas Tree.

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
    Navigate to `http://localhost:3010` (or the port shown in your terminal).

## 📂 Project Structure

-   `src/components`: React components for the UI overlay and 3D scene.
-   `src/hooks`: Custom hooks for WebSocket communication and state management.
-   `src/utils`: Helper functions for animations and data processing.

## 🔧 Troubleshooting

-   **Port in Use**: If port 3010 is taken, the app will try the next available port. Check the terminal output.
-   **WebSocket Connection**: Ensure the backend is running on `http://localhost:8001` (or configured port) for real-time features.

## 🎯 Goal

Your goal is to implement the connection logic to talk to the Backend Agent.

## 🎄 Features (To Be Connected)

-   Hand gesture control using MediaPipe.
-   Chat interface to talk to the Christmas Tree Agent.
-   3D Rendering with React Three Fiber.

## Credits

Frontend UI is credit to [https://github.com/blackboxo/christmas-tree](https://github.com/blackboxo/christmas-tree).

> **Note**: You don't need this complex UI to understand the Memory Bank concepts. It is included to make the project look cooler and demonstrate a rich interaction model.
