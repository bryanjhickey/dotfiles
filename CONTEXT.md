# Dotfiles Context

Domain vocabulary for this personal macOS provisioning repo. Defined so that
docs, commit messages, and future refactors name the same thing the same way.

## Language

### Journal capture

**Journal**:
The single plain-text file at `~/Documents/journal.md`. The canonical quick-capture target — always available, independent of any app.
_Avoid_: log, diary, notes file.

**Note** (entry):
A timestamped line appended to the **Journal** — `YYYY-MM-DD HH:MM — text`. Also the name of the shell function and Raycast command that create one.
_Avoid_: entry, jot.

**Stamp**:
The day header appended to the **Journal** each morning — `## Friday 29 May 2026`. Gives the day a clean section to write under. Created by the 6am LaunchAgent.
_Avoid_: header, heading, divider.

**journal module**:
`scripts/journal.sh` — the one implementation of journal capture, exposing `note` and `stamp` subcommands. Every caller (the zsh `note` function, the Raycast `journal` command, the daily-journal LaunchAgent) is a thin **adapter** over it.
_Avoid_: journal script (when you mean the module specifically), helper.

**Obsidian daily note**:
A *separate* capture target inside an Obsidian vault (`$OBSIDIAN_VAULT`), reached by the `obs` and `daily` functions. NOT the **Journal** — different file, different tool, deliberately decoupled so the **Journal** works with no vault configured.
_Avoid_: daily note (unqualified — ambiguous with the Journal's daily Stamp).

## Flagged ambiguities

- **"daily note" vs "daily stamp"** — *daily note* means the **Obsidian daily note** (the `obs`/`daily` target); the Journal's morning header is the **Stamp**. Don't call the Stamp a "daily note".
- **"journal" the file vs the command vs the module** — *the Journal* is the file; *`note`/`journal`* are the commands that write to it; *the journal module* is `scripts/journal.sh` behind them.

## Example

> **Dev:** Should the 6am agent call `note`?
> **Bryan:** No — it adds a **Stamp**, not a **Note**. Both go through the **journal module** (`journal.sh stamp` vs `journal.sh note`), so the format stays consistent, but they're different subcommands.
> **Dev:** And `obs` writes there too?
> **Bryan:** No, `obs` hits the **Obsidian daily note** — a separate target. The **Journal** is plain text and works even with no vault set.
