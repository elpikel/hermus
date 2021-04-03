defmodule HermusTest do
  use ExUnit.Case
  doctest Hermus

  test "greets the world" do
    assert Hermus.hello() == :world
  end
end
