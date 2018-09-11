defmodule Pluggy.Usergroup do

	defstruct(id: nil, user_id: nil, group_id: nil)

    alias Pluggy.Usergroup
    
    def all() do
		Postgrex.query!(DB, "SELECT * FROM user_groups", [],
            pool: DBConnection.Poolboy
        ).rows |> to_struct_list
    end
    
    def all_with_user(user) do
		Postgrex.query!(DB, "SELECT * FROM user_groups WHERE user_id = $1", [user.id],
            pool: DBConnection.Poolboy
        ).rows |> to_struct_list
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

    def delete(id) do
        Postgrex.query!(DB, "DELETE FROM user_groups WHERE id = $1", [atoi(id)],
            pool: DBConnection.Poolboy)
        :ok
    end
    
    defp atoi(str), do: String.to_integer(str)

	def to_struct([[id, user_id, group_id]]) do
		%Usergroup{id: id, user_id: user_id, group_id: group_id}
    end
    
    def to_struct_list(rows) do
		for [id, user_id, group_id] <- rows, do: %Usergroup{id: id, user_id: user_id, group_id: group_id}
	end
end