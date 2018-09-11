defmodule Pluggy.Group do

	defstruct(id: nil, name: "", status: 0, owner_id: nil)

    alias Pluggy.Group
    
    def all(owner) do
		Postgrex.query!(DB, "SELECT * FROM groups WHERE owner_id = $1", [atoi(owner.id)],
            pool: DBConnection.Poolboy
        ).rows |> to_struct_list
	end

	def get(id) do
		Postgrex.query!(DB, "SELECT * FROM groups WHERE id = $1 LIMIT 1", [id],
            pool: DBConnection.Poolboy
        ).rows |> to_struct
    end

    def create(%{"groups[name]" => name, "groups[status]" => status, "groups[owner_id]" => owner_id}) do
		Postgrex.query!(DB, "INSERT INTO groups (name, status, owner_id) VALUES ($1, $2, $3)", [name, atoi(status), atoi(owner_id)],
            pool: DBConnection.Poolboy)
        :ok
    end

    def update(%{"groups[id]" => id, "groups[name]" => name, "groups[status]" => status, "groups[owner_id]" => owner_id}) do
        Postgrex.query!(DB, "UPDATE groups SET name = $1, status = $2, owner_id = $3 WHERE id = $4", [name, atoi(status), atoi(owner_id), atoi(id)],
            pool: DBConnection.Poolboy)
        :ok
    end

    def delete(id) do
        Postgrex.query!(DB, "DELETE FROM groups WHERE id = $1", [atoi(id)],
            pool: DBConnection.Poolboy)
        :ok
    end
    
    defp atoi(str), do: String.to_integer(str)

	def to_struct([[id, name, status, owner_id]]) do
		%Group{id: id, name: name, status: status, owner_id: owner_id}
    end
    
    def to_struct_list(rows) do
		for [id, name, status, owner_id] <- rows, do: %Group{id: id, name: name, status: status, owner_id: owner_id}
	end
end