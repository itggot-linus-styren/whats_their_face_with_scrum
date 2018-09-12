defmodule Pluggy.Person do
	
	defstruct(id: nil, name: "", image_path: "", group_id: nil)

	alias Pluggy.Person

	def all(room_id) do
		Postgrex.query!(DB, "SELECT * FROM people", [], [pool: DBConnection.Poolboy]).rows
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

	def update(id, params) do
		name = params["name"]
		tastiness = String.to_integer(params["tastiness"])
		id = String.to_integer(id)
		Postgrex.query!(DB, "UPDATE fruits SET name = $1, tastiness = $2 WHERE id = $3", [name, tastiness, id], [pool: DBConnection.Poolboy])
	end

	def create(params) do
		name = params["name"]
		tastiness = String.to_integer(params["tastiness"])
		Postgrex.query!(DB, "INSERT INTO fruits (name, tastiness) VALUES ($1, $2)", [name, tastiness], [pool: DBConnection.Poolboy])	
	end

	def delete(id) do
		Postgrex.query!(DB, "DELETE FROM fruits WHERE id = $1", [String.to_integer(id)], [pool: DBConnection.Poolboy])	
    end
    
    defp atoi(str), do: String.to_integer(str)

	def to_struct([[id, name, image_path, group_id]]) do
		%Person{id: id, name: name, image_path: image_path, group_id: group_id}
	end

	def to_struct_list(rows) do
		for [id, name, image_path, group_id] <- rows, do: %Person{id: id, name: name, image_path: image_path, group_id: group_id}
	end



end