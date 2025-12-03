# LabelingIR

<p align="center"><img src="assets/labeling_ir.svg" alt="LabelingIR Logo" width="392" /></p>

[![Hex.pm](https://img.shields.io/hexpm/v/labeling_ir.svg)](https://hex.pm/packages/labeling_ir)
[![Documentation](https://img.shields.io/badge/docs-hexpm-blue.svg)](https://hexdocs.pm/labeling_ir)
[![Downloads](https://img.shields.io/hexpm/dt/labeling_ir.svg)](https://hex.pm/packages/labeling_ir)
[![License](https://img.shields.io/github/license/North-Shore-AI/labeling_ir.svg)](LICENSE)
[![GitHub](https://img.shields.io/badge/github-North--Shore--AI%2Flabeling__ir-blue?logo=github)](https://github.com/North-Shore-AI/labeling_ir)

Shared intermediate representation (IR) structs for the North Shore labeling stack. LabelingIR provides typed, JSON-serializable data structures used across Forge, Anvil, Ingot, and external clients for human-in-the-loop ML workflows.

## Highlights

- **Typed structs** with enforced keys and sensible defaults
- **JSON-serializable** via Jason for API transport and storage
- **Multi-tenant** support with `tenant_id` and optional `namespace` on all entities
- **Lineage tracking** via optional `lineage_ref` for provenance
- **Zero dependencies** beyond Jason

## Installation

Add to your `mix.exs`:

```elixir
def deps do
  [
    {:labeling_ir, "~> 0.1.0"}
  ]
end
```

Or from GitHub:

```elixir
def deps do
  [
    {:labeling_ir, git: "https://github.com/North-Shore-AI/labeling_ir.git"}
  ]
end
```

## Structs

### Core Entities

| Struct | Purpose |
|--------|---------|
| `LabelingIR.Sample` | UI-friendly sample representation with payload and artifacts |
| `LabelingIR.Dataset` | Versioned dataset with slices for labeling/eval workloads |
| `LabelingIR.Schema` | Declarative label schema definition |
| `LabelingIR.Schema.Field` | Individual field in a schema (`:text`, `:select`, `:scale`, etc.) |

### Labeling Workflow

| Struct | Purpose |
|--------|---------|
| `LabelingIR.Assignment` | Unit of labeling work binding a sample to a schema |
| `LabelingIR.Label` | Human-provided label values with timing and metadata |
| `LabelingIR.EvalRun` | Evaluation run (human or model) over a dataset slice |

### Artifacts

| Struct | Purpose |
|--------|---------|
| `LabelingIR.Artifact` | Artifact attached to a sample (image, JSON, text, etc.) |
| `LabelingIR.ArtifactRef` | Lightweight reference to an artifact by ID |

## Usage

### Creating a Sample

```elixir
alias LabelingIR.{Sample, Artifact}

sample = %Sample{
  id: "sample_001",
  tenant_id: "acme_corp",
  pipeline_id: "sentiment_v2",
  payload: %{"text" => "Great product, highly recommend!"},
  artifacts: [
    %Artifact{
      id: "img_001",
      url: "https://storage.example.com/screenshot.png",
      filename: "screenshot.png",
      artifact_type: :image,
      mime: "image/png"
    }
  ],
  metadata: %{"source" => "support_tickets"},
  created_at: DateTime.utc_now()
}
```

### Defining a Schema

```elixir
alias LabelingIR.{Schema, Schema.Field}

schema = %Schema{
  id: "sentiment_schema_v1",
  tenant_id: "acme_corp",
  fields: [
    %Field{
      name: "sentiment",
      type: :select,
      required: true,
      options: ["positive", "negative", "neutral"]
    },
    %Field{
      name: "confidence",
      type: :scale,
      required: true,
      min: 1,
      max: 5,
      help: "How confident are you in this label?"
    },
    %Field{
      name: "notes",
      type: :text,
      required: false
    }
  ]
}
```

### Creating an Assignment

```elixir
alias LabelingIR.Assignment

assignment = %Assignment{
  id: "assign_001",
  queue_id: "sentiment_queue",
  tenant_id: "acme_corp",
  sample: sample,
  schema: schema,
  existing_labels: [],
  expires_at: DateTime.add(DateTime.utc_now(), 3600, :second)
}
```

### Submitting a Label

```elixir
alias LabelingIR.Label

label = %Label{
  id: "label_001",
  assignment_id: "assign_001",
  sample_id: "sample_001",
  queue_id: "sentiment_queue",
  tenant_id: "acme_corp",
  user_id: "labeler_alice",
  values: %{
    "sentiment" => "positive",
    "confidence" => 4,
    "notes" => "Clear positive sentiment"
  },
  time_spent_ms: 12500,
  created_at: DateTime.utc_now()
}
```

### Datasets and Eval Runs

```elixir
alias LabelingIR.{Dataset, EvalRun}

dataset = %Dataset{
  id: "sentiment_dataset_v1",
  tenant_id: "acme_corp",
  version: "1.0.0",
  slices: [
    %{name: "train", sample_ids: ["s1", "s2", "s3"], filter: %{}},
    %{name: "test", sample_ids: ["s4", "s5"], filter: %{}}
  ],
  created_at: DateTime.utc_now()
}

eval_run = %EvalRun{
  id: "eval_001",
  tenant_id: "acme_corp",
  dataset_id: "sentiment_dataset_v1",
  slice: "test",
  run_type: :model,
  model_ref: "gpt-4-turbo",
  metrics: %{
    "accuracy" => 0.92,
    "f1" => 0.89,
    "cohens_kappa" => 0.85
  },
  created_at: DateTime.utc_now()
}
```

### JSON Serialization

All structs derive `Jason.Encoder` for seamless JSON serialization:

```elixir
Jason.encode!(sample)
# => {"id":"sample_001","tenant_id":"acme_corp",...}
```

## Field Types

The `Schema.Field` struct supports the following types:

| Type | Description |
|------|-------------|
| `:text` | Free-form text input |
| `:boolean` | True/false toggle |
| `:select` | Single selection from `options` list |
| `:multiselect` | Multiple selections from `options` list |
| `:scale` | Numeric scale with `min`/`max` bounds |

Custom types can be used as atoms (e.g., `:date`, `:datetime`, `:number`).

## Architecture

LabelingIR serves as the shared contract between:

- **Forge** - Sample ingestion and preprocessing pipelines
- **Anvil** - Labeling queue management and human workflows
- **Ingot** - UI frontend for labelers and reviewers
- **External clients** - API consumers and integrations

```
┌─────────┐     ┌─────────┐     ┌─────────┐
│  Forge  │────▶│  Anvil  │────▶│  Ingot  │
└─────────┘     └─────────┘     └─────────┘
     │               │               │
     └───────────────┼───────────────┘
                     │
              ┌──────┴──────┐
              │ LabelingIR  │
              │  (structs)  │
              └─────────────┘
```

## Development

```bash
# Install dependencies
mix deps.get

# Run tests
mix test

# Generate docs
mix docs

# Type checking
mix dialyzer
```

## License

MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgments

Built by the North Shore AI team for the machine learning community.
