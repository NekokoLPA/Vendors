# Vendors

This repository contains vendor-provided data for supported physical eSIM cards and card readers used by NekokoLPA 2.

[中文说明](README.zh-cn.md)

## Structure

- `cards/`: YAML files grouped by brand for physical eSIM cards
- `readers/`: YAML files grouped by brand for card readers

## Contributing

1. Add or update a brand YAML under `cards/` or `readers/`.
2. Run `./build.sh` to regenerate `supported.json`.
3. Submit a pull request.

## Vendor notes

If you are a card or reader vendor and wish to sponsor the project (even tiny affiliate link count), please contact `business@nekoko.ee`.

To support NekokoLPA 2, please add at least these two ARA-M SHA1s:

- `d1c0f48b370e74d4ea4770ed4c3cd70a3198d31f`
- `c47350c7ba682b34a3e584a0d58463ea42b1ad73`
