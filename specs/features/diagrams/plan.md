# Plan: diagrams

> Status: Draft — pending architect review.
> Depends on: `spec.md` of this feature (must be approved).

## Review summary

- **Decisions needing approval**: the style guide below (palette, arrow
  convention, gate-vs-automated coloring) is a new proposal, not derived
  from any existing repo convention.
- **Deviations from the baseline/original exercise**: none — new
  documentation, no infra/code touched.
- **Key risks**: none blocking. PNG export/README embedding is Phase 5's
  job, not this feature's.

## Technical approach

Both files are hand-assembled valid Excalidraw documents (top-level
`{"type": "excalidraw", "version": 2, "source": "...", "elements": [...],
"appState": {...}, "files": {}}`), written directly to
`docs/diagrams/*.excalidraw`. Element authoring uses the
`mcp__claude_ai_Excalidraw` tools available in this session:
`create_view` to iteratively draw and visually check layout/spacing
before finalizing, then the same element JSON (with any Excalidraw fields
`create_view` omits by default, like `strokeStyle`, `groupIds`, `seed`)
is assembled into the final `.excalidraw` file. `export_to_excalidraw` is
used at the end of each diagram to get a shareable excalidraw.com link,
included as a code comment / note during implementation for convenience
(not a file requirement).

## Style guide (shared by both diagrams)

- **Font**: Excalidraw's default hand-drawn font (`fontFamily = 1`,
  Virgil), set identically on every text element in both diagrams — no
  per-diagram override.
- **Arrows**: solid, default stroke (`#1e1e1e`), always labeled with the
  event/action/step name; no dashed arrows except (in diagram 2 only) the
  swimlane divider.
- **Layer/swimlane zones**: large background rectangles, `opacity: 30`,
  one color per zone, per Excalidraw's documented "Background Zones"
  palette (`#dbe4ff` blue, `#e5dbff` purple, `#d3f9d8` green) plus a
  fourth zone using the light-pink pastel (`#eebefa`) for the fourth
  category diagram 1 needs (persistence/notification split beyond the
  three built-in zone colors).
- **Component boxes**: pastel fills from Excalidraw's documented palette,
  assigned by role, reused identically in both diagrams wherever the same
  concept appears (e.g. any "human decision" box/diamond uses the same
  amber `#f59e0b`/`#ffd8a8` combination in both files if it ever recurs).
- **Gates vs. automated steps** (diagram 2 specific): decision gates are
  diamonds in amber (`#f59e0b` stroke, `#ffd8a8` fill); automated agent
  steps are blue (`#4a9eed`/`#a5d8ff`); human-only steps (setup, manual
  apply/verify/destroy) are green (`#22c55e`/`#b2f2bb`) — a legend box
  spells this out.

## Files and responsibilities

- `docs/diagrams/architecture.excalidraw` — solution architecture: 4
  layer zones (ingestion/processing/persistence/notification), 8 labeled
  component boxes, labeled arrows, legend (region + IAM note).
- `docs/diagrams/sdd-terraform-workflow.excalidraw` — 2 swimlanes
  (Architect/Coding agent), one-time setup, per-feature cycle with an
  approval-gate diamond, the manual apply/verify/destroy sequence pulled
  visually outside the agent loop, legend distinguishing gates from
  automated steps.

## Variables and configuration

None — documentation-only feature, no Terraform/Python changes.

## Validation

- Both files parse as valid JSON (`python3 -m json.tool
  docs/diagrams/*.excalidraw > /dev/null`).
- Both files have the top-level keys Excalidraw's format requires
  (`type`, `version`, `elements`, `appState`) — checked by inspection.
- Manual open in excalidraw.com (or the VS Code Excalidraw extension) to
  confirm both render without errors — noted as a manual step in
  `tasks.md` since it can't be scripted from this environment.
- No `terraform fmt`/`validate`/`plan` applies to this feature — it
  touches no `.tf` files.

## Risks / trade-offs

- Hand-assembling the full Excalidraw file structure (beyond what
  `create_view`'s element format documents) carries some risk of a
  subtly malformed field; mitigated by the JSON-parse + manual-open
  validation steps in `tasks.md`.
- The style guide above is this feature's own proposal — if rejected or
  amended, both diagrams need re-authoring since colors are meant to
  match exactly across files.
