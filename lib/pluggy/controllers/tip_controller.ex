defmodule Pluggy.TipController do
  
    require IEx

    alias Pluggy.Tip
    alias Pluggy.Person
    alias Pluggy.Group
    alias Pluggy.User
    import Pluggy.Template, only: [render: 3]
    import Plug.Conn, only: [send_resp: 3]
  
  
    def create(conn, person_id) do
        send_resp(conn, 200, render(conn, "tips/create", person_id: person_id))
    end

    def create(conn, person_id, params) do
        Tip.create(person_id,params)
        redirect(conn, "/groups")
    end

    def show(conn, id) do
  
        #get user if logged in
        #session_user = conn.private.plug_session["user_id"]
        person_id = id
        case person_id do
          nil -> 
              redirect(conn, "/")
          _   -> 
              #current_user = User.get(session_user)
              send_resp(conn, 200, render(conn, "tips/show", tips: Tip.all(person_id)))
        end
      end
  
    defp redirect(conn, url) do
      Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
    end
  
  end
  