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

    def add(room_id, params) do
        person_name = params["person_name"]
        group_id = room_id

        IO.inspect params
        
        image_path = "/uploads/#{params["fileupload"].filename}"

        File.rename(params["fileupload"].path, "priv/static" <> image_path)

        Postgrex.query!(DB, "INSERT INTO people(name, image_path, group_id) VALUES ($1, $2, $3)", [person_name, image_path, atoi(group_id)], [pool: DBConnection.Poolboy])
    end

    def pic(person_id, params) do
        image_path = "/uploads/#{params["fileupload"].filename}"
        File.rename(params["fileupload"].path, "priv/static" <> image_path)
        Postgrex.query!(DB, "UPDATE people SET image_path = $1 WHERE id = $2", [image_path, atoi(person_id)], [pool: DBConnection.Poolboy])
    end

    def name(person_id, params) do
        Postgrex.query!(DB, "UPDATE people SET name = $1 WHERE id = $2", [params["person_name"], atoi(person_id)], [pool: DBConnection.Poolboy])
    end

    def deleteperson(person_id) do
        Postgrex.query!(DB, "DELETE FROM people WHERE id = $1", [atoi(person_id)], [pool: DBConnection.Poolboy])	
    end
    
    defp atoi(str), do: String.to_integer(str)

	def to_struct([[id, tip, person_id]]) do
		%Tip{id: id, tip: tip, person_id: person_id}
	end

	def to_struct_list(rows) do
		for [id, tip, person_id] <- rows, do: %Tip{id: id, tip: tip, person_id: person_id}
	end



end