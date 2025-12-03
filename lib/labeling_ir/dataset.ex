defmodule LabelingIR.Dataset do
  @moduledoc """
  Versioned dataset and slices for labeling/eval workloads.
  """

  alias LabelingIR.{ArtifactRef, Types}

  @enforce_keys [:id, :tenant_id, :version, :created_at]
  @derive Jason.Encoder
  defstruct [
    :id,
    :tenant_id,
    :namespace,
    :version,
    :created_at,
    :lineage_ref,
    slices: [],
    source_refs: [],
    metadata: %{}
  ]

  @type slice :: %{
          name: String.t(),
          sample_ids: [String.t()],
          filter: map()
        }

  @type t :: %__MODULE__{
          id: String.t(),
          tenant_id: String.t(),
          namespace: String.t() | nil,
          version: String.t(),
          slices: [slice()],
          source_refs: [ArtifactRef.t() | map()],
          metadata: map(),
          lineage_ref: Types.lineage_ref() | nil,
          created_at: DateTime.t()
        }
end
