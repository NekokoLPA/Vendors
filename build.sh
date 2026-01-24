#!/usr/bin/env bash
set -euo pipefail
root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ruby - <<'RUBY' "$root_dir"
require "yaml"
require "json"

root = ARGV[0]

STANDARD_SHA1 = "d1c0f48b370e74d4ea4770ed4c3cd70a3198d31f"
SEKIU_SHA1 = "c47350c7ba682b34a3e584a0d58463ea42b1ad73"
EASY_EUICC_SHA1 = "2a2fa878bc7c3354c2cf82935a5945a3edae4afa"
ESTK_ME_SHA1 = "6666666666a2bd0baf0a822766b4f6522500a655"
MULTI_SHA1S = [
  "114514191909beef280ca91de875403b03999682",
  "65d0571854afec519a90f92d7c5d8cf8148da373",
  "8f23ee7868bdb19f94ca3ee295e240d71efa33dc",
  "c47350c7ba682b34a3e584a0d58463ea42b1ad73",
  "d1c0f48b370e74d4ea4770ed4c3cd70a3198d31f",
].freeze


def load_group(dir, key)
  items = []
  Dir.glob(File.join(dir, "*.y{a,}ml")).sort.each do |path|
    data = YAML.load_file(path) || {}
    list = data[key] || data[key.to_sym] || []
    unless list.is_a?(Array)
      raise "Expected #{key} array in #{path}"
    end
    items.concat(list)
  end
  items
end

def normalize_sha1s(values)
  Array(values).compact.map { |v| v.to_s.downcase.strip }.reject(&:empty?)
end

def compatibility_from_sha1s(sha1s)
  {
    "standard" => sha1s.include?(STANDARD_SHA1),
    "multi" => (sha1s & MULTI_SHA1S).any?,
    "sekiu" => sha1s.include?(SEKIU_SHA1),
  }
end

def other_apps_from_sha1s(sha1s, existing, changeable)
  apps = Array(existing).compact.map(&:to_s)
  if changeable
    apps << "Any App"
  else
    apps << "EasyEUICC" if sha1s.include?(EASY_EUICC_SHA1)
  end
  apps.uniq
end

cards = load_group(File.join(root, "cards"), "cards").map do |card|
  card = card.dup
  sha1s = normalize_sha1s(card["aramSHA1s"] || card[:aramSHA1s])
  card["aramSHA1s"] = sha1s
  card["sponsored"] = false if card["sponsored"].nil? && card[:sponsored].nil?
  card["isAramSha1Changeable"] = false if card["isAramSha1Changeable"].nil? && card[:isAramSha1Changeable].nil?
  card["otherApps"] = other_apps_from_sha1s(
    sha1s,
    card["otherApps"] || card[:otherApps],
    card["isAramSha1Changeable"] || card[:isAramSha1Changeable]
  )
  card["compatibility"] = compatibility_from_sha1s(sha1s)
  card
end

readers = load_group(File.join(root, "readers"), "readers").map do |reader|
  reader = reader.dup
  reader["sponsored"] = false if reader["sponsored"].nil? && reader[:sponsored].nil?
  reader.delete("aramSHA1s")
  reader
end

output = {
  "physicalCards" => cards,
  "cardReaders" => readers,
}

File.write(File.join(root, "supported.json"), JSON.pretty_generate(output) + "\n")
RUBY
