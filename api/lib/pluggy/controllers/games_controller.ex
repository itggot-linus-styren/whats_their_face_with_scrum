defmodule Pluggy.GamesController do

    require IEx

    alias Pluggy.Person
    import Pluggy.Template, only: [render: 3]
    import Plug.Conn, only: [send_resp: 3]

    def learn(conn, id), do: game(conn, "games/learn", id)
    def name(conn, id), do: game(conn, "games/name", id)
    def face(conn, id), do: game(conn, "games/face", id)
    def hangman(conn, id), do: game(conn, "games/hangman", id)
    def memory(conn, id), do: game(conn, "games/memory", id)

    def game(conn, path, id), do: send_resp(conn, 200, render(conn, path, people_json: Poison.encode!(Person.all(id))))

end