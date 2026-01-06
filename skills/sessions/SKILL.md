---
name: sessions
description: Sessions plugin setup and profile management. Activate when the user mentions sessions, setup, profile, improvements, or sync.
---

# Sessions Skill

Record coding improvements to your profile and sync session transcripts at sessions.shotgun.dev.

## When to Activate

Activate this skill when:
- User mentions "sessions", "profile", or "improvements"
- User asks about recording what they learned
- User wants to track their coding progress
- User wants to sync or upload their coding session
- After completing a significant task where the user learned something new

## Using the Improve Tool

The MCP server provides the `improve` tool for recording improvements.

Call it with a single `thing` parameter - a concise description of what was learned or improved:

```
improve({ thing: "Learned to use PostgreSQL arrays for storing OAuth scopes" })
```

Good improvements to record:
- New techniques or patterns learned
- Bug fixes and what caused them
- Configuration discoveries
- Best practices adopted
- Tools or libraries explored

Keep improvements concise and specific.

## Using the Sync Tool

The `sync` tool uploads session transcripts to cloud storage. It returns pre-signed URLs for uploading files.

Call it with a list of file paths to sync:

```
sync({ files: ["~/.claude/projects/myproject/abc123.jsonl"] })
```

The tool returns JSON with upload URLs for each file:

```json
[
  {
    "path": "~/.claude/projects/myproject/abc123.jsonl",
    "key": "users/{user_id}/sessions/abc123.jsonl",
    "url": "https://...",
    "expires_at": "2024-01-15T10:30:00Z"
  }
]
```

After receiving the URLs, upload files using curl:

```bash
curl -X PUT -T ~/.claude/projects/myproject/abc123.jsonl "PRESIGNED_URL"
```

Session files are stored under the user's namespace and can be used to create blog posts at sessions.shotgun.dev.
