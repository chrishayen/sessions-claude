---
description: Link this local project to a Sessions project for memory persistence
argument-hint: <project name>
---

Link this local directory to a Sessions project. This enables memory persistence across sessions.

1. Call the `create_project` MCP tool with the project name: $ARGUMENTS
   - This creates the project on the server if it doesn't exist, or returns the existing project

2. After receiving the project response (which includes the project UUID), create a `.sessions` file in the current working directory with the following JSON content:
   ```json
   {
     "project_id": "<the project UUID from the response>",
     "project_name": "<the project name>"
   }
   ```

3. Confirm to the user that the project has been linked and explain:
   - Memories stored for this project will persist across sessions
   - The Sessions plugin will automatically prompt to load memories at the start of each session

4. Suggest adding `.sessions` to `.gitignore` if it's not already there, since this file contains user-specific configuration.
