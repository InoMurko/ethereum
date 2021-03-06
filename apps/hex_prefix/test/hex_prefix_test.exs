defmodule HexPrefixTest do
  use ExUnit.Case, async: true
  doctest HexPrefix

  test "encode then decode - no terminator" do
    assert {[0x01, 0x02], false} |> HexPrefix.encode() |> HexPrefix.decode() == {[1, 2], false}
  end

  test "encode then decode - terminator" do
    assert {[0x01, 0x02], true} |> HexPrefix.encode() |> HexPrefix.decode() == {[1, 2], true}
  end
end
