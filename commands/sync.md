---
description: Sync session transcripts to cloud storage
argument-hint: <path to session file or directory>
---

Sync the session transcript(s) to Sessions cloud storage using the sync tool.

If no path is provided, sync ALL session files from ALL projects in ~/.claude/projects/ (recursively find all .jsonl files).

1. Find all .jsonl files to sync from: $ARGUMENTS (or ~/.claude/projects/ if not specified)
2. For each file, extract metadata by parsing the JSONL:
   - `size`: file size in bytes (use `stat -c %s <file>` on Linux or `stat -f %z <file>` on macOS)
   - `title`: from the "summary" type message, or full first user message
   - `excerpt`: first user message content, truncated to 200 chars
   - `tool`: "claude-code"
   - `session_date`: timestamp from first message (RFC3339 format)
   - `message_count`: count of "user" and "assistant" type messages
   - `input_tokens`/`output_tokens`: sum from all "usage" objects
   - `duration_minutes`: difference between first and last timestamp in minutes

   Use jq to extract metadata:
   ```bash
   # Get summary title or first user message
   title=$(jq -rs '[.[] | select(.type == "summary") | .summary] | first // empty' "$file")
   if [ -z "$title" ]; then
     title=$(jq -rs '[.[] | select(.type == "user") | .message.content | if type == "string" then . elif type == "array" then [.[] | select(.type == "text") | .text] | first else empty end] | first // "Untitled"' "$file")
   fi

   # Get first user message as excerpt
   excerpt=$(jq -rs '[.[] | select(.type == "user") | .message.content | if type == "string" then . elif type == "array" then [.[] | select(.type == "text") | .text] | first else empty end] | first // "" | .[0:200]' "$file")

   # Get timestamps for session_date and duration
   first_ts=$(jq -rs '[.[] | .timestamp // empty] | first' "$file")
   last_ts=$(jq -rs '[.[] | .timestamp // empty] | last' "$file")

   # Count messages
   message_count=$(jq -s '[.[] | select(.type == "user" or .type == "assistant")] | length' "$file")

   # Sum tokens
   input_tokens=$(jq -s '[.[] | .usage.input_tokens // 0] | add' "$file")
   output_tokens=$(jq -s '[.[] | .usage.output_tokens // 0] | add' "$file")
   ```

3. Call the sync tool with files including metadata:
   ```json
   {"files": [{
     "path": "/full/path/file.jsonl",
     "size": 12345,
     "title": "Session title here",
     "excerpt": "First user message...",
     "tool": "claude-code",
     "session_date": "2025-01-06T12:00:00Z",
     "message_count": 42,
     "input_tokens": 5000,
     "output_tokens": 3000
   }, ...]}
   ```

4. The sync tool will check which files already exist with the same size and skip them
5. For files that need uploading (not skipped), upload using curl:
   ```bash
   curl -X PUT -T <file_path> "<presigned_url>"
   ```
6. Report summary: how many files were uploaded, how many were skipped (already synced)
