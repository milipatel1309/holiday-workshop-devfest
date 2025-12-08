---
id: adk-mcp-memory-codelab
title: Building Personalized Agents with ADK, MCP, and Memory Bank
summary: Learn to build a context-aware AI agent that connects to external tools via MCP and remembers user preferences with Vertex AI Memory Bank.
authors: Qingyue(Annie) Wang
keywords: docType:Codelab, skill:Intermediate, language:Python, category:Cloud, category:AiAndMachineLearning, product:ADK, product:GoogleCloud
award_behavior: AWARD_BEHAVIOR_ENABLE
layout: paginated
duration: 20
---

# Building Personalized Agents with ADK, MCP, and Memory Bank

## Overview
**Duration: 2 min**

### The "USB-C" Moment for AI
Imagine if every time you bought a new mouse, you had to solder it to your motherboard. That was the state of AI tools until recently. Developers had to write custom "glue code" to connect LLMs to databases, filesystems, or APIs.

Enter the **Model Context Protocol (MCP)**. Think of MCP as the **USB-C port for AI applications**. It provides a standardized way to connect AI models to data sources and tools.

### What You Will Build
In this codelab, you will build a **Personal Research Assistant** that:
1.  **Connects to your local environment** (like your filesystem) using **MCP**.
2.  **Manages conversation context** reliably using the **Agent Development Kit (ADK)**.
3.  **Remembers your preferences** (e.g., "I prefer Python code") across different sessions using **Vertex AI Memory Bank**.

> aside positive
> **Why this matters**
> By the end of this lab, you will move beyond simple chatbots to building **agentic workflows** that can interact with the real world and learn from you over time.

## Prerequisites
**Duration: 3 min**

Before we dive in, ensure you have the following:

1.  **Google Cloud Project**: With billing enabled.
2.  **Python 3.10+**: Installed in your environment.
3.  **Vertex AI API**: Enabled in your Google Cloud project.

### Environment Setup
We will use a standard Python environment.

```bash
# Create a virtual environment
python3 -m venv venv
source venv/bin/activate

# Install necessary libraries (conceptual command)
pip install google-cloud-aiplatform vertexai-adk mcp-server-sdk
```

> aside negative
> **Warning**
> Ensure you have authenticated your Google Cloud CLI (`gcloud auth login`) before running the code samples.

## Concept 1: The "USB-C" for AI (MCP)
**Duration: 5 min**

### What is MCP?
The **Model Context Protocol (MCP)** is an open standard that enables AI models to interact with external data and tools safely and uniformly.

Without MCP, if you wanted your agent to read a file, you'd write a specific function `read_file()`. If you wanted it to check GitHub, you'd write `check_github()`. The agent would need to know the specific implementation details of each.

With MCP, you simply plug in an **MCP Server**. The agent (the **MCP Client**) asks, "What tools do you have?" and the server replies, "I can read files and list directories." The protocol handles the communication.

### Why it Matters
*   **Standardization**: Write a tool once, use it with any MCP-compliant agent (Claude, Gemini, ChatGPT).
*   **Security**: The protocol enforces strict boundaries. The agent only sees what the server explicitly exposes.
*   **Modularity**: You can swap out tools (e.g., switch from a local file server to a Google Drive server) without rewriting your agent's core logic.

## Concept 2: Context Engineering with ADK
**Duration: 5 min**

### The Agent Development Kit (ADK)
Building a reliable agent requires more than just a prompt. You need to manage:
*   **State**: What happened in the conversation so far?
*   **Routing**: Which tool should be called next?
*   **Context**: What information is currently relevant?

The **Agent Development Kit (ADK)** is a framework designed to handle this "Context Engineering." It ensures your agent behaves deterministically.

### Initializing the Agent
Let's create the skeleton of our agent using ADK.

```python
import vertexai
from vertexai.preview import agent_engines

# Initialize Vertex AI
vertexai.init(project="your-project-id", location="us-central1")

# Define the Agent
# In ADK, an agent is defined by its model and its instructions.
model = "gemini-1.5-pro-001"

instruction = """
You are a helpful Personal Research Assistant.
You have access to external tools via MCP.
Always check the user's long-term memory for preferences before answering.
"""

# We will attach tools and memory in the next steps.
```

> aside positive
> **Context Engineering Tip**
> In ADK, "Context" isn't just the chat history. It includes the **active tools**, the **user's profile**, and the **current task state**. ADK manages this context window for you, optimizing what gets sent to the model.

## Concept 3: Connecting ADK to MCP Tools
**Duration: 8 min**

Now, let's give our agent hands. We will connect it to a simple MCP server. For this example, imagine we have a local MCP server running that provides filesystem access.

### The MCP Client
Your ADK agent acts as the **MCP Client**. It connects to the server and "discovers" the available tools.

### Implementation
We will use the ADK's `MCPToolset` to bridge the gap.

```python
from vertexai.preview.agent_engines import Toolset, MCPToolset

# Define the connection to the MCP Server
# This could be a local process or a remote URL
mcp_server_config = {
    "command": "python",
    "args": ["mcp_server_fs.py"] # Assuming a local filesystem MCP server script
}

# Create the Toolset
# ADK automatically queries the server for available tools (e.g., read_file, list_dir)
mcp_tools = MCPToolset.from_local_script(
    name="filesystem_tools",
    script_path="mcp_server_fs.py"
)

# Attach the tools to the agent
agent = agent_engines.Agent(
    model=model,
    instruction=instruction,
    tools=[mcp_tools] # The agent now has "hands"!
)
```

### How it Works
1.  **Discovery**: When you initialize `MCPToolset`, it starts the MCP server and asks for a list of tools (`tools/list`).
2.  **Translation**: ADK translates these MCP tool definitions into function declarations that the Gemini model understands.
3.  **Execution**: When the model decides to call `read_file`, ADK sends the request to the MCP server, gets the result, and feeds it back to the model.

> aside positive
> **The Power of Abstraction**
> Notice we didn't write a `read_file` function in our agent code. The MCP server provides it. If we wanted to add a "Weather" tool, we'd just add another `MCPToolset` configuration.

## Concept 4: Vertex AI Memory Bank
**Duration: 7 min**

### Short-term vs. Long-term Memory
*   **Short-term Context**: "What did I just say?" (Session history). This is lost when the chat window closes.
*   **Long-term Memory**: "What is my favorite programming language?" (User preferences). This should persist forever.

**Vertex AI Memory Bank** provides this long-term storage. It allows the agent to store and retrieve personalized information about the user.

### Configuring Memory
We will configure the agent to use a Memory Bank. This involves two parts: **storage** (saving facts) and **retrieval** (remembering facts).

```python
from vertexai.preview.agent_engines import MemoryBank, Memory

# 1. Create or Load a Memory Bank
# This is a persistent store in Vertex AI
memory_bank = MemoryBank(
    display_name="user_preferences_bank",
    project="your-project-id",
    location="us-central1"
)

# 2. Configure the Memory Plugin
# We tell the agent to use this bank.
memory_config = Memory(
    memory_bank=memory_bank,
    # "read_only=False" allows the agent to learn new things
    read_only=False
)

# 3. Update the Agent with Memory
agent = agent_engines.Agent(
    model=model,
    instruction=instruction,
    tools=[mcp_tools],
    memory=memory_config # The agent now has a "brain"!
)
```

### Seeing it in Action
Now, if you tell the agent:
> "I only write code in Python."

The agent will identify this as a preference and store it in the Memory Bank.

Next week, if you ask:
> "Write a script to list files."

The agent will query the Memory Bank, see your preference, and generate **Python** code without being asked.

> aside positive
> **Personalization**
> This is the key to "Vibe Coding." The agent adapts to *your* style. It's not just a generic coding bot; it's *your* coding bot.

## Conclusion
**Duration: 2 min**

### What You've Achieved
You have built a sophisticated AI agent that is:
1.  **Connected**: Using **MCP** to access external tools like a filesystem.
2.  **Robust**: Using **ADK** to manage context and state.
3.  **Personalized**: Using **Memory Bank** to remember your preferences.

### Next Steps
*   **Build your own MCP Server**: Create a server for your internal API or database.
*   **Explore ADK Patterns**: Learn about "Reasoning Loops" and "Orchestration" in the ADK documentation.
*   **Deploy**: Take your agent from a local script to a production service on Cloud Run.

> aside positive
> **Keep Building**
> The combination of MCP for connectivity and Memory Bank for personalization creates endless possibilities. What will you build next?
