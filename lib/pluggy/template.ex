defmodule Pluggy.Template do
	import Plug.Conn

  def render(conn, file, data \\ [], layout \\ true) do
  	case layout do
    	true -> 
			EEx.eval_file("templates/layout.eex", conn: conn, template: EEx.eval_file("templates/#{file}.eex", data))
    	false -> 
    		EEx.eval_file("templates/#{file}.eex", data)
		end
  end
end
