# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :ex_wire,
  p2p_version: 0x04,
  protocol_version: 63,
  # ropsten
  network_id: 3,
  caps: [{"eth", 62}, {"eth", 63}],
  chain: :ropsten,
  # TODO: This should be set and stored in a file
  private_key: :random,
  bootnodes: :from_chain,
  # Number of peer advertisements before we trust a block
  commitment_count: 1

import_config "#{Mix.env()}.exs"
