defmodule Pluggy.GamesController do

    require IEx

    alias Pluggy.Person
    import Pluggy.Template, only: [render: 3]
    import Plug.Conn, only: [send_resp: 3]

    def learn(conn, id), do: game("games/learn", id)
    def learn(conn, id), do: game("games/name", id)
    def learn(conn, id), do: game("games/face", id)

    def game(path, id), do: send_resp(conn, 200, render(conn, path, people_json: Poison.encode!(Person.all(id))))

end