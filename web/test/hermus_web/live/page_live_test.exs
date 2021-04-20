defmodule HermusWeb.PageLiveTest do
  use HermusWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Hermus"
    assert render(page_live) =~ "Hermus"
  end
end
