# Obsidian

This package is a scaffold. There's no Obsidian vault to track yet — when you create one, follow the steps below to bring its `.obsidian/` config under version control.

## Why a scaffold and not a config

Obsidian config is per-vault, stored in `<vault>/.obsidian/`. Tracking it via Stow only makes sense once you've decided on a vault location and where it'll live (iCloud Drive, `~/Documents/`, somewhere else). Different vaults can also have different community-plugin sets, so a one-size-fits-all `obsidian/` package is the wrong shape.

## What to track when the vault exists

Once a vault is set up:

```
obsidian/<vault-name>/.obsidian/
├── app.json              # Editor settings (line wrap, default font, etc.)
├── appearance.json       # Theme name, CSS variables, font sizes
├── community-plugins.json  # Enabled community plugins (so a fresh install reinstalls them)
├── core-plugins.json     # Built-in plugins on/off (Daily Notes, Templates, Graph, etc.)
├── hotkeys.json          # Custom keyboard shortcuts
├── snippets/             # Custom CSS snippets (style your vault)
└── templates/            # Templater / Daily Notes template files
```

## What NOT to track

These rewrite constantly or contain per-machine state — pollute git diff with noise:

```
.obsidian/workspace.json       # Layout state, rewrites on every focus change
.obsidian/workspaces.json      # Saved workspaces (per-machine)
.obsidian/cache/                # Plugin caches
.obsidian/plugins/*/data.json  # Plugin runtime state
.obsidian/plugins/*/main.js    # Plugin code (downloaded by Obsidian on plugin install)
.obsidian/themes/*.css         # Theme code (downloaded by Obsidian)
```

A `.stow-local-ignore` regex set to handle this:

```
^/<vault>/.obsidian/(workspace|workspaces|cache)\.json
^/<vault>/.obsidian/plugins/.*/(data\.json|main\.js)
^/<vault>/.obsidian/themes/.*\.css
```

## Setup steps (when the time comes)

1. Create your vault wherever you want it (e.g. `~/Documents/Obsidian/Notes/`).
2. Install community plugins via Obsidian → Settings → Community plugins. Get them working the way you like.
3. Move the vault's `.obsidian/` into this package: `mv ~/Documents/Obsidian/Notes/.obsidian obsidian/Notes/.obsidian` and `cd obsidian && ln -s Notes/.obsidian ~/Documents/Obsidian/Notes/.obsidian` — or restructure so the vault's parent dir matches a Stow target.
4. Add the obsidian package to `install.sh`'s stow line.
5. Add the `OBSIDIAN_VAULT` export to `~/.zshenv` so the `obs` shell function (defined in [zsh/notes.zsh](../zsh/notes.zsh)) targets the right vault.

## Related shell helpers

[zsh/notes.zsh](../zsh/notes.zsh) defines three commands you can use today, vault or no vault:

- `note <text>` — appends a timestamped line to `~/Documents/journal.md` (always works).
- `obs <text>` — appends to today's vault daily note (requires `$OBSIDIAN_VAULT`).
- `daily` — opens today's daily note in Obsidian via the `obsidian://daily` URL scheme.
