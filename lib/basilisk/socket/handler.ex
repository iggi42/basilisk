defmodule Basilisk.Socket.Handler do
  @moduledoc """
  A worker for decoding, validating, and executing client commands
  """
  @behaviour :ranch_protocol

  use GenServer
  require Logger

  @protocol_version 15

  @impl :ranch_protocol
  def start_link(ref, socket, transport, _opts) do
    pid = :proc_lib.spawn_link(__MODULE__, :init, [{ref, socket, transport}])
    {:ok, pid}
  end

  @impl GenServer
  def init({ref, _socket, transport}) do
    {:ok, socket} = :ranch.handshake(ref)
    :ok = transport.setopts(socket, [{:active, true}])
    :gen_server.enter_loop(__MODULE__, [], %{socket: socket, transport: transport})
  end

  @impl GenServer
  def handle_info({:tcp, socket, <<0, 0, 0, 0>>}, state = %{socket: socket, transport: transport}) do
    transport.send(
      socket,
      "<?xml version=\"1.0\"?><cockatrice_server_stream version=\"#{@protocol_version}\">"
    )

    msg =
      ServerMessage.new(
        message_type: :SESSION_EVENT,
        session_event:
          Protobuf.Extension.put(
            SessionEvent,
            SessionEvent.new(),
            EventServerIdentification.PbExtension,
            :"EventServerIdentification.ext",
            EventServerIdentification.new(
              server_name: Basilisk.server_name(),
              server_version: "basilisk-v#{Basilisk.version()}",
              protocol_version: @protocol_version
            )
          )
      )

    server_id_enc = Protobuf.encode(msg)

    transport.send(socket, server_id_enc)
    {:noreply, state}
  end

  @impl GenServer
  def handle_info({:tcp, socket, data}, state = %{socket: socket, transport: transport}) do
    command = CommandContainer.decode(data)
    _ = Logger.warn(inspect(data))
    _ = Logger.warn(inspect(command))
    # transport.send(socket, data)
    {:noreply, state}
  end

  @impl GenServer
  def handle_info({:tcp_closed, socket}, state = %{socket: socket, transport: transport}) do
    _ = Logger.debug("Closing")
    transport.close(socket)
    {:stop, :normal, state}
  end

  defp encapsulate(msg, wrapper) do
    Protobuf.Utils.convert_to_record()
    _ = Logger.warn(inspect(msg))
    _ = Logger.warn(inspect(wrapper))
    %{msg | ext: wrapper.new()}
  end
end
