defmodule LabelingIR.Schema.Field do
  @moduledoc """
  A single field in a label schema.
  """

  @type field_type :: :scale | :text | :boolean | :select | :multiselect | atom()

  @enforce_keys [:name, :type]
  @derive Jason.Encoder
  defstruct [
    :name,
    :type,
    required: false,
    min: nil,
    max: nil,
    default: nil,
    options: nil,
    help: nil
  ]

  @type t :: %__MODULE__{
          name: String.t(),
          type: field_type(),
          required: boolean(),
          min: integer() | nil,
          max: integer() | nil,
          default: term() | nil,
          options: [String.t()] | nil,
          help: String.t() | nil
        }
end
