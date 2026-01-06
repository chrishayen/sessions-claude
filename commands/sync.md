---
description: Sync session transcripts to cloud storage
argument-hint: <path to session file or directory>
---

Sync the session transcript(s) to Sessions cloud storage using the sync tool.

If no path is provided, sync ALL session files from ALL projects in ~/.claude/projects/ (recursively find all .jsonl files).

1. Find all .jsonl files to sync from: $ARGUMENTS (or ~/.claude/projects/ if not specified)
2. Get the file size for each file (use `stat -c %s <file>` on Linux or `stat -f %z <file>` on macOS)
3. Call the sync tool with files as array of objects: `{"files": [{"path": "/full/path/file.jsonl", "size": 12345}, ...]}`
4. The sync tool will check which files already exist with the same size and skip them
5. For files that need uploading (not skipped), upload using curl:
   ```bash
   curl -X PUT -T <file_path> "<presigned_url>"
   ```
6. Report summary: how many files were uploaded, how many were skipped (already synced)
