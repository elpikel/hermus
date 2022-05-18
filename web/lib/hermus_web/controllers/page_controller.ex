defmodule HermusWeb.PageController do
  use HermusWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
