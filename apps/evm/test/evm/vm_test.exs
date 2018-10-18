defmodule EVM.VMTest do
  use ExUnit.Case, async: true
  doctest EVM.VM

  alias EVM.VM
  alias EVM.MachineCode
  alias EVM.ExecEnv
  alias EVM.Interface.Mock.MockAccountInterface
  alias EVM.SubState

  setup do
    account_interface = MockAccountInterface.new()

    {:ok,
     %{
       account_interface: account_interface
     }}
  end

  test "simple program with return value", %{} do
    instructions = [
      :push1,
      3,
      :push1,
      5,
      :add,
      :push1,
      0x00,
      :mstore,
      :push1,
      32,
      :push1,
      0,
      :return
    ]

    exec_env = %ExecEnv{machine_code: MachineCode.compile(instructions)}
    result = VM.run(24, exec_env)

    assert result ==
             {0, %SubState{logs: [], refund: 0, suicide_list: []}, exec_env, <<0x08::256>>}
  end

  test "simple program with block storage", %{account_interface: account_interface} do
    address = 0x0000000000000000000000000000000000000001

    instructions = [
      :push1,
      3,
      :push1,
      5,
      :sstore,
      :stop
    ]

    exec_env = %ExecEnv{
      machine_code: MachineCode.compile(instructions),
      address: address,
      account_interface: account_interface
    }

    result = VM.run(20006, exec_env)

    expected_account_state = %{
      address => %{
        balance: 0,
        nonce: 0,
        storage: %{5 => 3}
      }
    }

    expected_account_interface = MockAccountInterface.new(expected_account_state)

    expected_exec_env = Map.put(exec_env, :account_interface, expected_account_interface)

    assert result == {0, %SubState{logs: [], refund: 0, suicide_list: []}, expected_exec_env, ""}
  end
end
