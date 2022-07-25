defmodule TwitterWeb.TwitLiveTest do
  use TwitterWeb.ConnCase

  import Phoenix.LiveViewTest
  import Twitter.PostFixtures

  @create_attrs %{body: "some body", likes_count: 42, reposts_count: 42, username: "some username"}
  @update_attrs %{body: "some updated body", likes_count: 43, reposts_count: 43, username: "some updated username"}
  @invalid_attrs %{body: nil, likes_count: nil, reposts_count: nil, username: nil}

  defp create_twit(_) do
    twit = twit_fixture()
    %{twit: twit}
  end

  describe "Index" do
    setup [:create_twit]

    test "lists all twits", %{conn: conn, twit: twit} do
      {:ok, _index_live, html} = live(conn, Routes.twit_index_path(conn, :index))

      assert html =~ "Listing Twits"
      assert html =~ twit.body
    end

    test "saves new twit", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.twit_index_path(conn, :index))

      assert index_live |> element("a", "New Twit") |> render_click() =~
               "New Twit"

      assert_patch(index_live, Routes.twit_index_path(conn, :new))

      assert index_live
             |> form("#twit-form", twit: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#twit-form", twit: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.twit_index_path(conn, :index))

      assert html =~ "Twit created successfully"
      assert html =~ "some body"
    end

    test "updates twit in listing", %{conn: conn, twit: twit} do
      {:ok, index_live, _html} = live(conn, Routes.twit_index_path(conn, :index))

      assert index_live |> element("#twit-#{twit.id} a", "Edit") |> render_click() =~
               "Edit Twit"

      assert_patch(index_live, Routes.twit_index_path(conn, :edit, twit))

      assert index_live
             |> form("#twit-form", twit: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#twit-form", twit: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.twit_index_path(conn, :index))

      assert html =~ "Twit updated successfully"
      assert html =~ "some updated body"
    end

    test "deletes twit in listing", %{conn: conn, twit: twit} do
      {:ok, index_live, _html} = live(conn, Routes.twit_index_path(conn, :index))

      assert index_live |> element("#twit-#{twit.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#twit-#{twit.id}")
    end
  end

  describe "Show" do
    setup [:create_twit]

    test "displays twit", %{conn: conn, twit: twit} do
      {:ok, _show_live, html} = live(conn, Routes.twit_show_path(conn, :show, twit))

      assert html =~ "Show Twit"
      assert html =~ twit.body
    end

    test "updates twit within modal", %{conn: conn, twit: twit} do
      {:ok, show_live, _html} = live(conn, Routes.twit_show_path(conn, :show, twit))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Twit"

      assert_patch(show_live, Routes.twit_show_path(conn, :edit, twit))

      assert show_live
             |> form("#twit-form", twit: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#twit-form", twit: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.twit_show_path(conn, :show, twit))

      assert html =~ "Twit updated successfully"
      assert html =~ "some updated body"
    end
  end
end
