defmodule Pluggy.Person do
	
	defstruct(id: nil, name: "", image_path: "", group_id: nil)

	alias Pluggy.Person

	def all do
		Postgrex.query!(DB, "SELECT * FROM people", [], [pool: DBConnection.Poolboy]).rows
		|> to_struct_list
	end

	def get(id) do
		Postgrex.query!(DB, "SELECT * FROM fruits WHERE id = $1 LIMIT 1", [String.to_integer(id)], [pool: DBConnection.Poolboy]).rows
		|> to_struct
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

	def to_struct([[id, name, image_path, group_id]]) do
		%Person{id: id, name: name, image_path: image_path, group_id: group_id}
	end

	def to_struct_list(rows) do
		for [id, name, image_path, group_id] <- rows, do: %Person{id: id, name: name, image_path: image_path, group_id: group_id}
	end



end