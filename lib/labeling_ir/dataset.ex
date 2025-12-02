defmodule LabelingIR.Dataset do
  @moduledoc """
  Versioned dataset and slices for labeling/eval workloads.
  """

  alias LabelingIR.ArtifactRef

  @enforce_keys [:id, :tenant_id, :version, :created_at]
  defstruct [:id, :tenant_id, :version, :created_at, slices: [], source_refs: [], metadata: %{}]

  @type slice :: %{
          name: String.t(),
          sample_ids: [String.t()],
          filter: map()
        }

  @type t :: %__MODULE__{
          id: String.t(),
          tenant_id: String.t(),
          version: String.t(),
          slices: [slice()],
          source_refs: [ArtifactRef.t() | map()],
          metadata: map(),
          created_at: DateTime.t()
        }
end
