---
allowed-tools: Bash(grep:*), Bash(git:*), Bash(sed:*)
description: iOS SDKのバージョンを更新してコミットを作成
---

iOS SDKのバージョンを更新します。

まず現在のバージョンを確認:

```bash
current_version=$(grep "s\.dependency 'CaRetailBoosterSDK'" ios/caretailbooster_sdk.podspec | grep -o "'[0-9]\+\.[0-9]\+\.[0-9]\+'" | tr -d "'")
echo "現在のiOS SDKバージョン: $current_version"
```

バージョン番号を分解:

```bash
IFS='.' read -r major minor patch <<< "$current_version"
```

どの部分を更新するか選択してもらいます：
- 1: メジャーバージョン (${major}.0.0)
- 2: マイナーバージョン (${major}.${minor}.0)  
- 3: パッチバージョン (${major}.${minor}.$((patch + 1)))

選択に基づいて新しいバージョンを設定:

```bash
case "$1" in
  1)
    new_version="$((major + 1)).0.0"
    ;;
  2)
    new_version="${major}.$((minor + 1)).0"
    ;;
  3)
    new_version="${major}.${minor}.$((patch + 1))"
    ;;
  *)
    echo "1, 2, 3 どれかを選択してください"
    exit 1
    ;;
esac

echo "新しいiOS SDKバージョン: $new_version"
```

ios/caretailbooster_sdk.podspec のバージョンを更新:

```bash
sed -i '' -E "s/s\.dependency 'CaRetailBoosterSDK', '[0-9]+\.[0-9]+\.[0-9]+'/s.dependency 'CaRetailBoosterSDK', '$new_version'/" ios/caretailbooster_sdk.podspec
```

example/ios/Podfile のバージョンを更新:

```bash
sed -i '' -E "s/:tag => '[0-9]+\.[0-9]+\.[0-9]+'/:tag => '$new_version'/" example/ios/Podfile
```

変更内容を確認:

```bash
git diff ios/caretailbooster_sdk.podspec example/ios/Podfile
```

変更をコミット:

```bash
git add ios/caretailbooster_sdk.podspec example/ios/Podfile
git commit -m "update ios sdk version to $new_version"
```

完了しました！