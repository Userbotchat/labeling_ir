defmodule LabelingIR.Schema do
  @moduledoc """
  Declarative label schema definition.
  """

  alias LabelingIR.Schema.Field

  @enforce_keys [:id, :tenant_id, :fields]
  defstruct [
    :id,
    :tenant_id,
    fields: [],
    layout: nil,
    component_module: nil,
    metadata: %{}
  ]

  @type t :: %__MODULE__{
          id: String.t(),
          tenant_id: String.t(),
          fields: [Field.t()],
          layout: map() | nil,
          component_module: String.t() | nil,
          metadata: map()
        }
end
