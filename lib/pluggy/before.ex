defmodule Pluggy.BeforeDoPlug do
    import Plug.Conn, only: [put_session: 3]

    def init(options), do: options

    def call(conn, _opts) do
        put_session(conn, :info, "")
    end
end