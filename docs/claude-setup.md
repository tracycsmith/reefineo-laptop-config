# Claude setup — new machine checklist

## Already transferred (script 07 bundle -> ~/.claude)
CLAUDE.md, settings.json, statusline-command.sh, skills/, commands/

## Claude Code global MCP servers (re-add on new Mac)

    # Render (token in 1Password)
    claude mcp add --transport http render https://mcp.render.com/mcp \
      --header "Authorization: Bearer <RENDER_MCP_TOKEN>"

    # Linear (OAuth in browser on first use)
    claude mcp add --transport sse linear https://mcp.linear.app/sse

    # Grafana — requires: (1) Grafana desktop extension installed,
    # (2) ~/.claude/mcp-env/grafana.env copied over (uses op run / 1Password refs),
    # (3) binary path updated to this machine's Claude Extensions dir
    claude mcp add grafana -- /opt/homebrew/bin/op run \
      --env-file="$HOME/.claude/mcp-env/grafana.env" -- \
      "$HOME/Library/Application Support/Claude/Claude Extensions/ant.dir.gh.grafana.grafana-mcp/server/darwin-arm64/mcp-grafana"

## Claude Desktop extensions (reinstall via app Settings > Extensions)
- Desktop Commander
- Control your Mac (osascript)
- Chrome control
- Filesystem
- Context7
- AWS API MCP
- Grafana

claude.ai account-level connectors (Gmail, Calendar, Linear cloud, etc.) sync
with your account — nothing to do.

## Not transferred (deliberate)
~/.claude.json (machine state + tokens), session history, plans, project
transcripts. Continuity lives in each repo's AGENT.md instead.
