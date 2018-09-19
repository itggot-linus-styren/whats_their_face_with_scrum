defmodule Pluggy.User do

	defstruct(id: nil, username: "", encrypted_pw: "")

	alias Pluggy.User

	def all() do
		Postgrex.query!(DB, "SELECT * FROM users", [],
            pool: DBConnection.Poolboy
        ).rows |> to_struct_list
	end
	def all(id) do
		Postgrex.query!(DB, "SELECT * FROM users WHERE id = $1", [atoi(id)],
            pool: DBConnection.Poolboy
        ).rows |> to_struct_list
	end
	
	def update(conn, id, params) do
		Postgrex.query!(DB, "UPDATE users SET username = $2 WHERE id = $1", [atoi(tip_id), params["username"]], [pool: DBConnection.Poolboy])
	end

	def delete(id) do
        Postgrex.query!(DB, "DELETE FROM users WHERE id = $1", [atoi(id)],
            pool: DBConnection.Poolboy)
        :ok
    end


	def get(id) do
		Postgrex.query!(DB, "SELECT id, username FROM users WHERE id = $1 LIMIT 1", [id],
        pool: DBConnection.Poolboy
      ).rows |> to_struct
	end

	def to_struct([[id, username, encrypted_pw]]) do
		%User{id: id, username: username, encrypted_pw: encrypted_pw}
	end

	def to_struct_list(rows) do
		for [id, username, encrypted_pw] <- rows, do: %User{id: id, username: username, encrypted_pw: encrypted_pw}
	end

	defp atoi(str), do: String.to_integer(str)

	def register(user, crypted_pw) do
		Postgrex.query!(DB, "INSERT INTO users(username, encrypted_pw) VALUES ($1, $2)", [user, crypted_pw], pool: DBConnection.Poolboy)
	end
end