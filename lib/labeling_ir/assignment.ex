defmodule LabelingIR.Assignment do
  @moduledoc """
  A unit of labeling work for a queue.
  """

  alias LabelingIR.{Label, Sample, Schema}

  @enforce_keys [:id, :queue_id, :tenant_id, :sample, :schema]
  defstruct [
    :id,
    :queue_id,
    :tenant_id,
    :sample,
    :schema,
    existing_labels: [],
    expires_at: nil,
    metadata: %{}
  ]

  @type t :: %__MODULE__{
          id: String.t(),
          queue_id: String.t(),
          tenant_id: String.t(),
          sample: Sample.t(),
          schema: Schema.t(),
          existing_labels: [Label.t()],
          expires_at: DateTime.t() | nil,
          metadata: map()
        }
end
