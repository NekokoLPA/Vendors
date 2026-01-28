# Vendors

このリポジトリには、Nekoko LPA 2 で使用、対応されている物理 eSIM カードおよびカードリーダーに関するベンダー提供データが含まれています。

**Language:** [English](README.md) | [中文](README.zh-cn.md) | **日本語**

## 構造

- `cards/`: 物理 eSIM カードのブランド別にグループ化された YAML ファイル
- `readers/`: カードリーダーのブランド別にグループ化された YAML ファイル

## 貢献

1. `cards/` または `readers/` 下にブランドの YAML を追加または更新します。
2. `./build.sh` を実行し、`supported.json` を再生成します。
3. プルリクエストを送信してください。

## ベンダーへの説明

カードまたはリーダーの販売者であり、プロジェクトのスポンサーに参加したい場合 (アフィリエイトリンク数がわずかでも) は、`business@nekoko.ee` にご連絡ください。

Nekoko LPA 2 を対応させるには、少なくとも以下の 2 つの ARA-M SHA-1 を追加してください:

- `d1c0f48b370e74d4ea4770ed4c3cd70a3198d31f`
- `c47350c7ba682b34a3e584a0d58463ea42b1ad73`
