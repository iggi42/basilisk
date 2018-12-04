defmodule Event_StopDumpZone do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          zone_owner_id: integer,
          zone_name: String.t()
        }
  defstruct [:zone_owner_id, :zone_name]

  field(:zone_owner_id, 1, optional: true, type: :sint32)
  field(:zone_name, 2, optional: true, type: :string)
end