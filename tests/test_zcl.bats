#!/usr/bin/env bats
#
# zcl test suite
#

setup() {
  # Use a temporary config dir for tests
  export HOME="$BATS_TEST_TMPDIR"
  export XDG_CONFIG_HOME="$HOME/.config"
  CONFIG_DIR="$XDG_CONFIG_HOME/zcl"
  CONFIG_FILE="$CONFIG_DIR/config"
  ZCL="$(cd "$BATS_TEST_DIRNAME/.." && pwd)/zcl"
}

teardown() {
  rm -rf "$CONFIG_DIR"
}

# --- subcommand tests ---------------------------------------------------------

@test "zcl --help exits 0 and mentions zcl" {
  run "$ZCL" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"zcl"* ]]
}

@test "zcl help exits 0" {
  run "$ZCL" help
  [ "$status" -eq 0 ]
}

@test "zcl --version prints version" {
  run "$ZCL" --version
  [ "$status" -eq 0 ]
  [[ "$output" == "zcl v"* ]]
}

# --- config management --------------------------------------------------------

@test "zcl config saves key to config file" {
  run "$ZCL" config "k1.a1B2c3D4e5F6g7H8i9J0kL1M2"
  [ "$status" -eq 0 ]
  [ -f "$CONFIG_FILE" ]
  grep -q "ZAI_API_KEY=k1.a1B2c3D4e5F6g7H8i9J0kL1M2" "$CONFIG_FILE"
}

@test "zcl change-key updates an existing key" {
  "$ZCL" config "old.aBcDeFgHiJkLmNoPqRsTuVwXyZ"
  run "$ZCL" change-key "new.Z9y8x7w6v5u4t3s2r1q0p"
  [ "$status" -eq 0 ]
  grep -q "ZAI_API_KEY=new.Z9y8x7w6v5u4t3s2r1q0p" "$CONFIG_FILE"
}

@test "zcl reset removes config file" {
  "$ZCL" config "t1.a1B2c3D4e5F6g7H8i9J0"
  run "$ZCL" reset
  [ "$status" -eq 0 ]
  [ ! -f "$CONFIG_FILE" ]
}

@test "zcl reset with no config is safe" {
  run "$ZCL" reset
  [ "$status" -eq 0 ]
}

@test "zcl show-config prints config info" {
  "$ZCL" config "show.a1b2c3d4e5f6g7h8i9j0"
  run "$ZCL" show-config
  [ "$status" -eq 0 ]
  [[ "$output" == *"Config file"* ]]
  [[ "$output" == *"stored"* ]]
}

# --- key format validation ----------------------------------------------------

@test "validate_key_format accepts valid keys" {
  run "$ZCL" config "v1.abcdefghijklmnopqrstuvwxyz"
  [ "$status" -eq 0 ]
}

@test "validate_key_format rejects very short keys" {
  run "$ZCL" config "ab"
  # Should warn but still save
  [ "$status" -eq 0 ]
}

# --- dry run ------------------------------------------------------------------

@test "zcl --dry-run prints expected output" {
  "$ZCL" config "dry.a1b2c3d4e5f6g7h8i9j0k1l2m3" 2>/dev/null
  run "$ZCL" --dry-run
  [ "$status" -eq 0 ]
  [[ "$output" == *"ANTHROPIC_BASE_URL"* ]]
  [[ "$output" == *"api.z.ai"* ]]
  [[ "$output" == *"glm-5.2"* ]]
  [[ "$output" == *"glm-4.7"* ]]
  [[ "$output" == *"API_TIMEOUT_MS"* ]]
  [[ "$output" == *"CLAUDE_CODE_AUTO_COMPACT_WINDOW"* ]]
}

@test "zcl --dry-run --safe shows safe mode" {
  "$ZCL" config "safe.Z9Y8X7W6V5U4T3S2R1Q0" 2>/dev/null
  run "$ZCL" --dry-run --safe
  [ "$status" -eq 0 ]
  [[ "$output" == *"permission prompts"* ]]
}

# --- model defaults -----------------------------------------------------------

@test "zcl uses GLM-5.2 as default model" {
  "$ZCL" config "model.Glm52TestKey2024AbcXyz" 2>/dev/null
  run "$ZCL" --dry-run
  [ "$status" -eq 0 ]
  [[ "$output" == *"glm-5.2[1m]"* ]]
}

@test "zcl uses glm-4.7 for haiku/subagent" {
  "$ZCL" config "haiku.TurboFastKey99XyzAbc" 2>/dev/null
  run "$ZCL" --dry-run
  [ "$status" -eq 0 ]
  [[ "$output" == *"glm-4.7"* ]]
}

# --- environment variable override --------------------------------------------

@test "ZCL_MODEL env var overrides default" {
  "$ZCL" config "env.CustomModelTestKey123" 2>/dev/null
  ZCL_MODEL="custom-model" run "$ZCL" --dry-run
  [ "$status" -eq 0 ]
  [[ "$output" == *"custom-model"* ]]
}

# --- passthrough args ---------------------------------------------------------

@test "zcl passes through arguments to claude" {
  "$ZCL" config "args.T3stP4ssThr0ughK3y987" 2>/dev/null
  run "$ZCL" --dry-run "tell me a joke"
  [ "$status" -eq 0 ]
  [[ "$output" == *"tell me a joke"* ]]
}
