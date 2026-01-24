#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"

root = File.expand_path("..", __dir__)

def load_items(dir, key)
  items = []
  Dir.glob(File.join(dir, "*.y{a,}ml")).sort.each do |path|
    data = YAML.load_file(path) || {}
    list = data[key] || data[key.to_sym] || []
    unless list.is_a?(Array)
      raise "Expected #{key} array in #{path}"
    end

    list.each_with_index do |item, index|
      unless item.is_a?(Hash)
        raise "Expected #{key} item hash in #{path} index #{index}"
      end
      items << {
        "item" => item,
        "source" => "#{path}:#{index}",
      }
    end
  end
  items
end

def extract_name(entry, label)
  item = entry["item"]
  name = item["name"] || item[:name]
  unless name.is_a?(String) && !name.strip.empty?
    raise "Missing name in #{label} item at #{entry["source"]}"
  end
  name.strip
end

cards = load_items(File.join(root, "cards"), "cards")
readers = load_items(File.join(root, "readers"), "readers")

entries = []
entries.concat(cards.map { |entry| entry.merge("group" => "cards") })
entries.concat(readers.map { |entry| entry.merge("group" => "readers") })

name_map = Hash.new { |hash, key| hash[key] = [] }

entries.each do |entry|
  name = extract_name(entry, entry["group"])
  normalized = name.downcase
  name_map[normalized] << entry.merge("name" => name)
end

duplicates = name_map.select { |_name, items| items.size > 1 }

if duplicates.any?
  warn "Name collisions detected:"
  duplicates.each do |normalized, items|
    names = items.map { |item| item["name"] }.uniq
    sources = items.map { |item| "#{item["group"]} #{item["source"]}" }
    warn "- #{normalized} (#{names.join(" / ")})"
    sources.each { |source| warn "  - #{source}" }
  end
  exit 1
end

puts "Name validation passed (#{entries.size} entries)."
