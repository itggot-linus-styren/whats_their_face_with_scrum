defmodule Pluggy.UserController do

  
  require IEx

  alias Pluggy.Fruit
  alias Pluggy.User
  import Pluggy.Template, only: [render: 3]
  import Plug.Conn, only: [send_resp: 3]

	def register(conn) do
		send_resp(conn, 200, render(conn, "register/register", []))
	end

	def register(conn, params) do
		username = params["username"]
		password1 = params["password1"]
		password2 = params["password2"]

		if password1 != password2 do
			redirect(conn, "/register")
		end

		result = 
			Postgrex.query!(DB, "SELECT username FROM users WHERE username = $1", [username], pool: DBConnection.Poolboy)

		if result == nil do
			redirect(conn, "/register")
		end 

		crypted_pw = Bcrypt.hash_pwd_salt(password1)
		User.register(username,crypted_pw)

		redirect(conn, "/")
	end


	def login(conn) do
		send_resp(conn, 200, render(conn, "login/login", []))
	end

	def login(conn, params) do
		username = params["username"]
		password = params["password"]

		result =
		  Postgrex.query!(DB, "SELECT id, encrypted_pw FROM users WHERE username = $1", [username],
		    pool: DBConnection.Poolboy
		  )

		case result.num_rows do
		  0 -> #no user with that username
		    redirect(conn, "/")
		  _ -> #user with that username exists
		    [[id, encrypted_pw]] = result.rows

		    #make sure password is correct
				if Bcrypt.verify_pass(password, encrypted_pw) do
		      Plug.Conn.put_session(conn, :user_id, id)
		      |>redirect("/groups")
		    else
		      redirect(conn, "/")
		    end
		end
	end

	def logout(conn) do
		Plug.Conn.configure_session(conn, drop: true)
		|> redirect("/groups")
	end

	# def create(conn, params) do
	# 	#pseudocode
	# 	# in db table users with password_hash CHAR(60)
	# 	# hashed_password = Bcrypt.hash_pwd_salt(params["password"])
    #  	# Postgrex.query!(DB, "INSERT INTO users (username, password_hash) VALUES ($1, $2)", [params["username"], hashed_password], [pool: DBConnection.Poolboy])
    #  	# redirect(conn, "/fruits")
	# end

	defp redirect(conn, url), do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end
