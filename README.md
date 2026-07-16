# dotagents

One home for my agent plugins.

## Install

```
/plugin marketplace add zhide915/dotagents
/plugin install zee-kit@zhide915
```

Skills load namespaced: `zee-kit:<skill-name>`.

To auto-enable zee-kit for a project (anyone who clones it gets the
plugin), check this into the project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "zhide915": {
      "source": {
        "source": "github",
        "repo": "zhide915/dotagents"
      }
    }
  },
  "enabledPlugins": {
    "zee-kit@zhide915": true
  }
}
```

## What's in zee-kit

Nothing yet.

## Layout

```
.claude-plugin/marketplace.json    the marketplace ("zhide915")
plugins/zee-kit/
  .claude-plugin/plugin.json       the plugin manifest
  skills/                          one directory per skill
```

## Updating

Add or edit skills under `plugins/zee-kit/skills/` and push. Claude Code
treats each commit as a new plugin version (update via `/plugin`).
