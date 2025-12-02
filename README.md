# LabelingIR

Shared IR structs for the North Shore labeling stack (Forge / Anvil / Ingot / external clients).

## Contents
- `LabelingIR.Artifact` / `LabelingIR.ArtifactRef`
- `LabelingIR.Sample`
- `LabelingIR.Dataset`
- `LabelingIR.Schema` / `LabelingIR.Schema.Field`
- `LabelingIR.Assignment`
- `LabelingIR.Label`
- `LabelingIR.EvalRun`

These structs mirror the contracts described in `ingot/docs/20251202/refactor/*`.

## Usage
Add to `mix.exs` in a client project:
```elixir
def deps do
  [
    {:labeling_ir, git: "https://github.com/North-Shore-AI/labeling_ir.git"}
  ]
end
```

Construct structs with enforced keys; optional fields default to sensible values:
```elixir
%LabelingIR.Sample{
  id: "s1",
  tenant_id: "tenant_a",
  pipeline_id: "pipeline_x",
  payload: %{"text" => "Hello"},
  artifacts: [],
  metadata: %{},
  created_at: DateTime.utc_now()
}
```

See `test/` for examples.
