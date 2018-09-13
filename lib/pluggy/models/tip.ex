defmodule Pluggy.Tip do
	
	defstruct(id: nil, tip: "", person_id: nil)

    alias Pluggy.Tip
    
    def create(person_id, params) do
        Postgrex.query!(DB, "INSERT INTO tips(tip, person_id) VALUES ($1, $2)", [params["person_tip"], atoi(person_id)], [pool: DBConnection.Poolboy])
    end


	def all(person_id) do
		Postgrex.query!(DB, "SELECT * FROM Tips WHERE person_id = $1", [atoi(person_id)], [pool: DBConnection.Poolboy]).rows
		|> to_struct_list
	end

	def delete(tip_id) do
		Postgrex.query!(DB, "DELETE FROM tips WHERE id = $1", [atoi(tip_id)], [pool: DBConnection.Poolboy])	
	end

    
    defp atoi(str), do: String.to_integer(str)

	def to_struct([[id, tip, person_id]]) do
		%Tip{id: id, tip: tip, person_id: person_id}
	end

	def to_struct_list(rows) do
		for [id, tip, person_id] <- rows, do: %Tip{id: id, tip: tip, person_id: person_id}
	end



end