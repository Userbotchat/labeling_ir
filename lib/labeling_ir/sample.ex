defmodule LabelingIR.Sample do
  @moduledoc """
  UI-friendly sample representation produced by Forge.
  """

  alias LabelingIR.Artifact

  @enforce_keys [:id, :tenant_id, :pipeline_id, :payload, :created_at]
  defstruct [:id, :tenant_id, :pipeline_id, :payload, :created_at, artifacts: [], metadata: %{}]

  @type t :: %__MODULE__{
          id: String.t(),
          tenant_id: String.t(),
          pipeline_id: String.t(),
          payload: map(),
          artifacts: [Artifact.t()],
          metadata: map(),
          created_at: DateTime.t()
        }
end
