defmodule LabelingIR.ArtifactRef do
  @moduledoc """
  Reference to an artifact (by id, optional version).
  """

  @enforce_keys [:artifact_id]
  defstruct [:artifact_id, :version]

  @type t :: %__MODULE__{
          artifact_id: String.t(),
          version: String.t() | nil
        }
end
