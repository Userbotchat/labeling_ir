defmodule LabelingIR.Assignment do
  @moduledoc """
  A unit of labeling work for a queue.
  """

  alias LabelingIR.{Label, Sample, Schema, Types}

  @enforce_keys [:id, :queue_id, :tenant_id, :sample, :schema]
  @derive Jason.Encoder
  defstruct [
    :id,
    :queue_id,
    :tenant_id,
    :namespace,
    :sample,
    :schema,
    :lineage_ref,
    existing_labels: [],
    expires_at: nil,
    metadata: %{}
  ]

  @type t :: %__MODULE__{
          id: String.t(),
          queue_id: String.t(),
          tenant_id: String.t(),
          namespace: String.t() | nil,
          sample: Sample.t(),
          schema: Schema.t(),
          existing_labels: [Label.t()],
          expires_at: DateTime.t() | nil,
          lineage_ref: Types.lineage_ref() | nil,
          metadata: map()
        }
end
