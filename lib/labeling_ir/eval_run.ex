defmodule LabelingIR.EvalRun do
  @moduledoc """
  Evaluation run (human or model) over a dataset slice.
  """

  alias LabelingIR.{ArtifactRef, Types}

  @enforce_keys [:id, :tenant_id, :dataset_id, :run_type, :metrics, :created_at]
  @derive Jason.Encoder
  defstruct [
    :id,
    :tenant_id,
    :namespace,
    :dataset_id,
    :slice,
    :model_ref,
    :run_type,
    :metrics,
    :lineage_ref,
    :created_at,
    artifacts: [],
    metadata: %{}
  ]

  @type run_type :: :human | :model | atom()

  @type t :: %__MODULE__{
          id: String.t(),
          tenant_id: String.t(),
          namespace: String.t() | nil,
          dataset_id: String.t(),
          slice: String.t() | nil,
          model_ref: String.t() | nil,
          run_type: run_type(),
          metrics: map(),
          artifacts: [ArtifactRef.t() | map()],
          lineage_ref: Types.lineage_ref() | nil,
          metadata: map(),
          created_at: DateTime.t()
        }
end
