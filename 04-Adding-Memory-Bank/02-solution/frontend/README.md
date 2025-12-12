# Workshop Step 4: Adding Memory Bank (Solution)

This is the **Completed Solution** for the "Adding Memory Bank" workshop step.

It features the full "Grand Luxury Interactive Christmas Tree" with memory capabilities.

## 🚀 How to Run

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

## ✨ Key Integrations

-   **Memory Bank**: The Agent now remembers your name, preferences, and generated patterns.
-   **Session Context**: Conversations are maintained across different interactions.
-   **Full UX**: The complete 3D and Chat experience working in harmony.

## Credits

Frontend UI is credit to [https://github.com/blackboxo/christmas-tree](https://github.com/blackboxo/christmas-tree).

> **Note**: You don't need this complex UI to understand the Memory Bank concepts. It is included to make the project look cooler and demonstrate a rich interaction model.
