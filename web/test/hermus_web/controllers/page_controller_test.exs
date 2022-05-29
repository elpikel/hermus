defmodule HermusWeb.PageControllerTest do
  use HermusWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Hermus"
  end
end
