defmodule LabelingIR.Schema do
  @moduledoc """
  Declarative label schema definition.
  """

  alias LabelingIR.Schema.Field

  @enforce_keys [:id, :tenant_id, :fields]
  @derive Jason.Encoder
  defstruct [
    :id,
    :tenant_id,
    :namespace,
    fields: [],
    layout: nil,
    component_module: nil,
    metadata: %{}
  ]

  @type t :: %__MODULE__{
          id: String.t(),
          tenant_id: String.t(),
          namespace: String.t() | nil,
          fields: [Field.t()],
          layout: map() | nil,
          component_module: String.t() | nil,
          metadata: map()
        }
end
