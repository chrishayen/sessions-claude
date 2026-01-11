---
description: Add a memory/annotation for the current project
argument-hint: <what to remember>
---

Store a memory for the current project. Use this when the LLM makes a mistake and you want to record the correction.

1. First, check if a `.sessions` file exists in the current working directory
   - If it doesn't exist, inform the user they need to run `/session:include <project name>` first to link this directory to a project

2. Read the `.sessions` file to get the `project_id`

3. Call the `add_memory` MCP tool with:
   - `project_id`: the UUID from the `.sessions` file
   - `content`: $ARGUMENTS

4. Confirm to the user that the memory has been stored and will be available in future sessions.
