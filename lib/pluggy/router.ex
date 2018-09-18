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
    
    
  end

  get "/persons" do
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, Poison.encode!(Person.all()))
  end

  get "/tips" do
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, Poison.encode!(Tip.all()))
  end

  get "/users" do
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, Poison.encode!(User.all()))
  end

  get "/usergroups" do
    put_resp_content_type(conn, "application/json")
    |> send_resp(200, Poison.encode!(Usergroup.all()))
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
