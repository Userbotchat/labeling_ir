defmodule LabelingIR.Artifact do
  @moduledoc """
  Artifact attached to a sample or eval run.
  """

  @type artifact_type :: :image | :json | :text | :other | atom()

  @enforce_keys [:id, :url, :filename, :artifact_type]
  @derive Jason.Encoder
  defstruct [
    :id,
    :url,
    :filename,
    :artifact_type,
    :mime,
    :expires_at,
    metadata: %{}
  ]

  @typedoc "Opaque artifact struct"
  @type t :: %__MODULE__{
          id: String.t(),
          url: String.t(),
          filename: String.t(),
          artifact_type: artifact_type(),
          mime: String.t() | nil,
          expires_at: DateTime.t() | nil,
          metadata: map()
        }
end
