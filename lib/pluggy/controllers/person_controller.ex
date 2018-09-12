defmodule Pluggy.PersonController do
  
    require IEx

    alias Pluggy.Person
    alias Pluggy.Group
    alias Pluggy.User
    import Pluggy.Template, only: [render: 2]
    import Plug.Conn, only: [send_resp: 3]
  
  
    def show(conn, id) do
  
      #get user if logged in
      #session_user = conn.private.plug_session["user_id"]
      room_id = id
      case room_id do
        nil -> 
            redirect(conn, "/")
        _   -> 
            #current_user = User.get(session_user)
            send_resp(conn, 200, render("person/show", persons: Person.all(room_id)))
      end
    end

    def add(conn, id) do
        send_resp(conn, 200, render("person/new", group_id: id))
    end

    def add(conn, id, params ) do
        Person.add(id, params)
        redirect(conn, "/groups/#{id}")
    end

    def edit(conn, person_id) do
        send_resp(conn, 200, render("person/edit", person_id: person_id))
    end

    def editpic(conn, person_id, params) do
        Person.pic(person_id, params)
        redirect(conn, "/groups")
    end

    def editname(conn, person_id, params) do
        Person.name(person_id, params)
        redirect(conn, "/groups")
    end

    def deleteperson(conn, person_id) do
        Person.deleteperson(person_id)
        redirect(conn, "/groups")
    end
  
    defp redirect(conn, url) do
      Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
    end
  
  end
  