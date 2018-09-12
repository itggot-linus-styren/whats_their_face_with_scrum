defmodule Pluggy.Router do
  use Plug.Router

  alias Pluggy.PersonController
  alias Pluggy.FruitController
  alias Pluggy.GroupController
  alias Pluggy.UserController

  plug Plug.Static, at: "/", from: :pluggy
  plug(:put_secret_key_base)

  plug(Plug.Session,
    store: :cookie,
    key: "_pluggy_session",
    encryption_salt: "cookie store encryption salt",
    signing_salt: "cookie store signing salt",
    key_length: 64,
    log: :debug,
    secret_key_base: "-- LONG STRING WITH AT LEAST 64 BYTES --"
  )

  plug(:fetch_session)
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])
  plug(:match)
  plug(:dispatch)

  get "/fruits",           do: FruitController.index(conn)
  get "/fruits/new",       do: FruitController.new(conn)
  get "/fruits/:id",       do: FruitController.show(conn, id)
  get "/fruits/:id/edit",  do: FruitController.edit(conn, id)
  
  post "/fruits",          do: FruitController.create(conn, conn.body_params)
 
  # should be put /fruits/:id, but put/patch/delete are not supported without hidden inputs
  post "/fruits/:id/edit", do: FruitController.update(conn, id, conn.body_params)

  # should be delete /fruits/:id, but put/patch/delete are not supported without hidden inputs
  post "/fruits/:id/destroy", do: FruitController.destroy(conn, id)

  get "/groups",           do: GroupController.index(conn)
  get "/groups/new",       do: GroupController.new(conn)
  get "/groups/:id",       do: GroupController.show(conn, id)
  get "/groups/:id/edit",  do: GroupController.edit(conn, id)
  
  post "/groups",          do: GroupController.create(conn, conn.body_params)
  post "/groups/:id/edit", do: GroupController.update(conn, id, conn.body_params)
  post "/groups/:id/destroy", do: GroupController.destroy(conn, id)

  get "/groups/:id/addpeople", do: PersonController.add(conn, id)
  get "/groups/:id/showpeople", do: PersonController.show(conn, id)

  post "/groups/:id/addpeople", do: PersonController.add(conn, id, conn.body_params)
  
  get "/register", do: UserController.register(conn)
  post "/register", do: UserController.register(conn, conn.body_params)

  get "/", do: UserController.login(conn)
  post "/", do: UserController.login(conn, conn.body_params)


  post "/users/login",     do: UserController.login(conn, conn.body_params)
  post "/users/logout",    do: UserController.logout(conn)

  match _ do
    send_resp(conn, 404, "oops")
  end

  defp put_secret_key_base(conn, _) do
    put_in(
      conn.secret_key_base,
      "-- LONG STRING WITH AT LEAST 64 BYTES LONG STRING WITH AT LEAST 64 BYTES --"
    )
  end
end
