defmodule Twitter.PostTest do
  use Twitter.DataCase

  alias Twitter.Post

  describe "twits" do
    alias Twitter.Post.Twit

    import Twitter.PostFixtures

    @invalid_attrs %{body: nil, likes_count: nil, reposts_count: nil, username: nil}

    test "list_twits/0 returns all twits" do
      twit = twit_fixture()
      assert Post.list_twits() == [twit]
    end

    test "get_twit!/1 returns the twit with given id" do
      twit = twit_fixture()
      assert Post.get_twit!(twit.id) == twit
    end

    test "create_twit/1 with valid data creates a twit" do
      valid_attrs = %{body: "some body", likes_count: 42, reposts_count: 42, username: "some username"}

      assert {:ok, %Twit{} = twit} = Post.create_twit(valid_attrs)
      assert twit.body == "some body"
      assert twit.likes_count == 42
      assert twit.reposts_count == 42
      assert twit.username == "some username"
    end

    test "create_twit/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Post.create_twit(@invalid_attrs)
    end

    test "update_twit/2 with valid data updates the twit" do
      twit = twit_fixture()
      update_attrs = %{body: "some updated body", likes_count: 43, reposts_count: 43, username: "some updated username"}

      assert {:ok, %Twit{} = twit} = Post.update_twit(twit, update_attrs)
      assert twit.body == "some updated body"
      assert twit.likes_count == 43
      assert twit.reposts_count == 43
      assert twit.username == "some updated username"
    end

    test "update_twit/2 with invalid data returns error changeset" do
      twit = twit_fixture()
      assert {:error, %Ecto.Changeset{}} = Post.update_twit(twit, @invalid_attrs)
      assert twit == Post.get_twit!(twit.id)
    end

    test "delete_twit/1 deletes the twit" do
      twit = twit_fixture()
      assert {:ok, %Twit{}} = Post.delete_twit(twit)
      assert_raise Ecto.NoResultsError, fn -> Post.get_twit!(twit.id) end
    end

    test "change_twit/1 returns a twit changeset" do
      twit = twit_fixture()
      assert %Ecto.Changeset{} = Post.change_twit(twit)
    end
  end
end
