defmodule Pluggy.Usergroup do

	defstruct(id: nil, user_id: nil, group_id: nil)

    alias Pluggy.Usergroup
    
    def all() do
		Postgrex.query!(DB, "SELECT * FROM user_groups", [],
            pool: DBConnection.Poolboy
        ).rows |> to_struct_list
    end

    def all(id) do
		Postgrex.query!(DB, "SELECT * FROM user_groups", [atoi(id)],
            pool: DBConnection.Poolboy
        ).rows |> to_struct_list
    end

    def update(conn, id, params) do
		Postgrex.query!(DB, "UPDATE users SET name = $2, status = $3 WHERE id = $1", [atoi(tip_id), params["name"], params["status"]], [pool: DBConnection.Poolboy])
	end
    
    def all_with_user(user) do
		Postgrex.query!(DB, "SELECT * FROM user_groups WHERE user_id = $1", [user.id],
            pool: DBConnection.Poolboy
        ).rows |> to_struct_list
    end
    
    def exists?(%{"subscription" => %{"user_id" => user_id, "group_id" => group_id}}) do
        Postgrex.query!(DB, "SELECT * FROM user_groups WHERE user_id = $1 AND group_id = $2 LIMIT 1", [atoi(user_id), atoi(group_id)],
            pool: DBConnection.Poolboy
        ).rows |> empty?
    end

	def get(id) do
		Postgrex.query!(DB, "SELECT * FROM user_groups WHERE id = $1 LIMIT 1", [atoi(id)],
            pool: DBConnection.Poolboy
        ).rows |> to_struct
    end

    def create(%{"subscription" => %{"user_id" => user_id, "group_id" => group_id}}) do
		Postgrex.query!(DB, "INSERT INTO user_groups (user_id, group_id) VALUES ($1, $2)", [atoi(user_id), atoi(group_id)],
            pool: DBConnection.Poolboy)
        :ok
    end

    def delete(conn ,id) do
        Postgrex.query!(DB, "DELETE FROM user_groups WHERE id = $1", [atoi(id)],
            pool: DBConnection.Poolboy)
        :ok
    end

    def delete_with_group(conn, group_id) do
        Postgrex.query!(DB, "DELETE FROM user_groups WHERE group_id = $1", [atoi(group_id)],
            pool: DBConnection.Poolboy)
        :ok
    end
    
    defp atoi(str), do: String.to_integer(str)

    defp empty?([]), do: false
    defp empty?(stupid), do: true

	def to_struct([[id, user_id, group_id]]) do
		%Usergroup{id: id, user_id: user_id, group_id: group_id}
    end
    
    def to_struct_list(rows) do
		for [id, user_id, group_id] <- rows, do: %Usergroup{id: id, user_id: user_id, group_id: group_id}
	end
end