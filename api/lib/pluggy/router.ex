defmodule Pluggy.Router do
  use Plug.Router

  alias Pluggy.Group
  alias Pluggy.Person
  alias Pluggy.Tip
  alias Pluggy.User
  alias Pluggy.Usergroup

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


  get "/groups" do
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, Poison.encode!(Group.all()))
  end
  get "/groups/:id" do
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, Poison.encode!(Group.all(id)))
  end
  post "/groups" do
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, '{"status":"OK"}'))
  end
  patch "/groups/:id" do
    Group.update(conn, id, conn.body_params)
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, '{"status":"OK"}'))
  end
  delete "/groups/:id" do
    Group.destroy(conn, id)
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, '{"status":"OK"}'))
  end

  get "/persons" do
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, Poison.encode!(Person.all()))
  end
  get "/persons/:id" do
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, Poison.encode!(Person.all(id)))
  end
  post "/persons" do
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, '{"status":"OK"}'))
  end
  patch "/persons/:id" do
    Person.pic(conn, id, params)
    Person.name(conn, id, params)
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, '{"status":"OK"}'))
  end
  delete "/persons/:id" do
    Person.deleteperson(conn, id)
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, '{"status":"OK"}'))
  end

  get "/tips" do
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, Poison.encode!(Tip.all()))
  end
  get "/tips/:id" do
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, Poison.encode!(Tip.all(id)))
  end
  post "/tips" do
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, '{"status":"OK"}'))
  end
  patch "/tips/:id" do
    Tip.update(conn, id, conn.body_params) 
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, '{"status":"OK"}'))
  end
  delete "/tips/:id" do
    Tip.destroy(conn, id)
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, '{"status":"OK"}'))
  end

  get "/users" do
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, Poison.encode!(User.all()))
  end
  get "/users/:id" do
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, Poison.encode!(User.all(id)))
  end
  post "/users" do
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, '{"status":"OK"}'))
  end
  patch "/users/:id" do
    User.update(conn, id, conn.body_params) 
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, '{"status":"OK"}'))
  end
  delete "/users/:id" do
    User.delete(conn, id) 
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, '{"status":"OK"}'))
  end

  get "/usergroups" do
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, Poison.encode!(Usergroup.all()))
  end
  get "/usergroups/:id" do
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, Poison.encode!(Usergroup.all(id)))
  end
  post "/usergroups" do
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, '{"status":"OK"}'))
  end
  patch "/usergroups/:id" do
    Usergroup.update(conn, id, conn.body_params)
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, '{"status":"OK"}'))
  end
  delete "/usergroups/:id" do
    Usergroup.delete(conn ,id)
    Usergroup.delete_with_group(conn, id)
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, '{"status":"OK"}'))
  end



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
