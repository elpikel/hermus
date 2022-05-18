defmodule HermusWeb.ProbeLiveTest do
  use HermusWeb.ConnCase

  import Phoenix.LiveViewTest
  import Hermus.DevicesFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_probe(_) do
    probe = probe_fixture()
    %{probe: probe}
  end

  describe "Index" do
    setup [:create_probe]

    test "lists all probes", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.probe_index_path(conn, :index))

      assert html =~ "Listing Probes"
    end

    test "saves new probe", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.probe_index_path(conn, :index))

      assert index_live |> element("a", "New Probe") |> render_click() =~
               "New Probe"

      assert_patch(index_live, Routes.probe_index_path(conn, :new))

      assert index_live
             |> form("#probe-form", probe: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#probe-form", probe: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.probe_index_path(conn, :index))

      assert html =~ "Probe created successfully"
    end

    test "updates probe in listing", %{conn: conn, probe: probe} do
      {:ok, index_live, _html} = live(conn, Routes.probe_index_path(conn, :index))

      assert index_live |> element("#probe-#{probe.id} a", "Edit") |> render_click() =~
               "Edit Probe"

      assert_patch(index_live, Routes.probe_index_path(conn, :edit, probe))

      assert index_live
             |> form("#probe-form", probe: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#probe-form", probe: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.probe_index_path(conn, :index))

      assert html =~ "Probe updated successfully"
    end

    test "deletes probe in listing", %{conn: conn, probe: probe} do
      {:ok, index_live, _html} = live(conn, Routes.probe_index_path(conn, :index))

      assert index_live |> element("#probe-#{probe.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#probe-#{probe.id}")
    end
  end

  describe "Show" do
    setup [:create_probe]

    test "displays probe", %{conn: conn, probe: probe} do
      {:ok, _show_live, html} = live(conn, Routes.probe_show_path(conn, :show, probe))

      assert html =~ "Show Probe"
    end

    test "updates probe within modal", %{conn: conn, probe: probe} do
      {:ok, show_live, _html} = live(conn, Routes.probe_show_path(conn, :show, probe))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Probe"

      assert_patch(show_live, Routes.probe_show_path(conn, :edit, probe))

      assert show_live
             |> form("#probe-form", probe: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#probe-form", probe: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.probe_show_path(conn, :show, probe))

      assert html =~ "Probe updated successfully"
    end
  end
end
