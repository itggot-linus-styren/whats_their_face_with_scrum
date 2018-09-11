defmodule Pluggy.User do

	defstruct(id: nil, username: "")

	alias Pluggy.User


	def get(id) do
		Postgrex.query!(DB, "SELECT id, username FROM users WHERE id = $1 LIMIT 1", [id],
        pool: DBConnection.Poolboy
      ).rows |> to_struct
	end

	def to_struct([[id, username]]) do
		%User{id: id, username: username}
	end

	def register(user, crypted_pw) do
		Postgrex.query!(DB, "INSERT INTO users(username, encrypted_pw) VALUES ($1, $2)", [user, crypted_pw], pool: DBConnection.Poolboy)
	end
end