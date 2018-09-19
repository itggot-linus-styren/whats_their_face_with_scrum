defmodule Pluggy.UserGroupController do

    require IEx

    alias Pluggy.Group
    import Pluggy.Template, only: [render: 3]
    import Plug.Conn, only: [send_resp: 3]

    def subscribe(conn, params) do
        search = Map.get_lazy(params, "search", fn -> "" end)
        send_resp(conn, 200, render(conn, "groups/subscribe", groups: Group.all_like(search), user_id: conn.private.plug_session["user_id"]))
    end

end
  