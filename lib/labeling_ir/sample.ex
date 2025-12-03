defmodule LabelingIR.Sample do
  @moduledoc """
  UI-friendly sample representation produced by Forge.
  """

  alias LabelingIR.{Artifact, Types}

  @enforce_keys [:id, :tenant_id, :pipeline_id, :payload, :created_at]
  @derive Jason.Encoder
  defstruct [
    :id,
    :tenant_id,
    :namespace,
    :pipeline_id,
    :payload,
    :created_at,
    :lineage_ref,
    artifacts: [],
    metadata: %{}
  ]

  @type t :: %__MODULE__{
          id: String.t(),
          tenant_id: String.t(),
          namespace: String.t() | nil,
          pipeline_id: String.t(),
          payload: map(),
          artifacts: [Artifact.t()],
          metadata: map(),
          lineage_ref: Types.lineage_ref() | nil,
          created_at: DateTime.t()
        }
end
