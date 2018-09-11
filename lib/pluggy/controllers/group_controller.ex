defmodule Pluggy.GroupController do

    require IEx

    alias Pluggy.Group
    alias Pluggy.User
    import Pluggy.Template, only: [render: 2]
    import Plug.Conn, only: [send_resp: 3]


    def index(conn) do
        #get user if logged in
        session_user = conn.private.plug_session["user_id"]
        case session_user do
            nil ->
                redirect(conn, "/")
            _   ->
                current_user = User.get(session_user)
                send_resp(conn, 200, render("groups/index", groups: Group.all(current_user), user: current_user))
        end
    end

    # TODO: check if user is logged in before CRUD

    def new(conn),          do: send_resp(conn, 200, render("groups/new", owner_id: conn.private.plug_session["user_id"]))
    def show(conn, id),     do: send_resp(conn, 200, render("groups/show", group: Group.get(id)))
    def edit(conn, id),     do: send_resp(conn, 200, render("groups/edit", group: Group.get(id)))

    def create(conn, params) do
        Group.create(params)
        redirect(conn, "/groups")
    end

    def update(conn, id, params) do
        Group.update(id, params)
        redirect(conn, "/groups")
    end

    def destroy(conn, id) do
        Group.delete(id)
        redirect(conn, "/groups")
    end

    defp redirect(conn, url) do
        Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
    end

end
  