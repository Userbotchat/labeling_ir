defmodule LabelingIR.Types do
  @moduledoc """
  Common types used across IR structs.
  """

  @type tenant_id :: String.t()
  @type namespace :: String.t()
  @type lineage_ref :: map()
end
