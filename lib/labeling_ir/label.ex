defmodule LabelingIR.Label do
  @moduledoc """
  Human-provided label values for an assignment.
  """

  alias LabelingIR.Types

  @enforce_keys [
    :id,
    :assignment_id,
    :sample_id,
    :queue_id,
    :tenant_id,
    :user_id,
    :values,
    :time_spent_ms,
    :created_at
  ]
  @derive Jason.Encoder
  defstruct [
    :id,
    :assignment_id,
    :sample_id,
    :queue_id,
    :tenant_id,
    :namespace,
    :user_id,
    :values,
    :notes,
    :time_spent_ms,
    :created_at,
    :lineage_ref,
    metadata: %{}
  ]

  @type t :: %__MODULE__{
          id: String.t(),
          assignment_id: String.t(),
          sample_id: String.t(),
          queue_id: String.t(),
          tenant_id: String.t(),
          namespace: String.t() | nil,
          user_id: String.t(),
          values: map(),
          notes: String.t() | nil,
          time_spent_ms: non_neg_integer(),
          created_at: DateTime.t(),
          lineage_ref: Types.lineage_ref() | nil,
          metadata: map()
        }
end
