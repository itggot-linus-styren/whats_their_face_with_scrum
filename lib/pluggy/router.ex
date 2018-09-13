defmodule Pluggy.Router do
  use Plug.Router

  alias Pluggy.TipController
  alias Pluggy.PersonController
  alias Pluggy.GamesController
  alias Pluggy.GroupController
  alias Pluggy.UserGroupController
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
  plug(:after_do)
  plug(:match)
  plug(:dispatch)

  get "/groups",           do: GroupController.index(conn)
  get "/groups/subscribe", do: UserGroupController.subscribe(conn, conn.query_params)
  get "/groups/new",       do: GroupController.new(conn)
  get "/groups/:id",       do: GroupController.show(conn, id)
  get "/groups/:id/edit",  do: GroupController.edit(conn, id)
  get "/groups/:id/play",  do: GroupController.play(conn, id)

  get "/groups/:id/play/learn",  do: GamesController.learn(conn, id)
  get "/groups/:id/play/name",  do: GamesController.name(conn, id)
  get "/groups/:id/play/face",  do: GamesController.face(conn, id)
  
  post "/groups",          do: GroupController.create(conn, conn.body_params)
  post "/groups/:id/edit", do: GroupController.update(conn, id, conn.body_params)
  post "/groups/:id/destroy", do: GroupController.destroy(conn, id)

  get "/groups/:id/addpeople", do: PersonController.add(conn, id)
  get "/groups/:id/showpeople", do: PersonController.show(conn, id)
  get "/groups/edit/:person_id", do: PersonController.edit(conn, person_id)

  get "/groups/tip/:person_id", do: TipController.create(conn, person_id)
  get "/groups/tips/:person_id", do: TipController.show(conn, person_id)

  post "/groups/tip/:person_id", do: TipController.create(conn, person_id, conn.body_params)
  post "/groups/tip/delete/:tip_id", do: TipController.delete(conn, tip_id)

  post "/groups/:id/addpeople", do: PersonController.add(conn, id, conn.body_params)
  post "/groups/edit/:person_id/pic", do: PersonController.editpic(conn, person_id, conn.body_params)
  post "/groups/edit/:person_id/name", do: PersonController.editname(conn, person_id, conn.body_params)
  post "/groups/delete/:person_id", do: PersonController.deleteperson(conn, person_id)

  post "/groups/subscribe", do: GroupController.subscribe(conn, conn.body_params)
  post "/groups/unsubscribe/:id", do: GroupController.unsubscribe(conn, id)
  
  get "/register", do: UserController.register(conn)
  post "/register", do: UserController.register(conn, conn.body_params)

  get "/", do: UserController.login(conn)
  post "/", do: UserController.login(conn, conn.body_params)


  post "/users/login",     do: UserController.login(conn, conn.body_params)
  post "/users/logout",    do: UserController.logout(conn)

  match _ do
    send_resp(conn, 404, "oops")
  end

  def after_do(conn, _opts) do
    Plug.Conn.register_before_send(conn, fn conn ->
      case conn do
        %Plug.Conn{method: "GET", status: 200} ->
          put_session(conn, :info, "")
        _ -> conn
      end
    end)
  end

  defp put_secret_key_base(conn, _) do
    put_in(
      conn.secret_key_base,
      "-- LONG STRING WITH AT LEAST 64 BYTES LONG STRING WITH AT LEAST 64 BYTES --"
    )
  end
end
