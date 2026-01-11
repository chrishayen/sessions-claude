#!/bin/bash

# Sessions plugin - SessionStart hook
# Loads project memories when a session starts

if [ -f "$CLAUDE_PROJECT_DIR/.sessions" ]; then
  project_id=$(jq -r '.project_id' "$CLAUDE_PROJECT_DIR/.sessions")
  project_name=$(jq -r '.project_name' "$CLAUDE_PROJECT_DIR/.sessions")

  echo "<sessions-context>"
  echo "This project is linked to Sessions project: $project_name (ID: $project_id)"
  echo "PRECONDITION: Before responding to ANY user message, you MUST call mcp__plugin_sessions_sessions__get_memories with project_id: $project_id. Do not respond to the user until this is complete. Without this context, you will miss critical project-specific information."
  echo "</sessions-context>"
fi

exit 0
