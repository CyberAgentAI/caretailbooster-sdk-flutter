---
allowed-tools: Bash(grep:*), Bash(git:*), Bash(sed:*)
description: Flutter SDKのバージョンを更新してコミットを作成
---

Flutter SDKのバージョンを更新します。

まず現在のバージョンを確認:

```bash
current_version=$(grep "^version:" pubspec.yaml | grep -o "[0-9]\+\.[0-9]\+\.[0-9]\+")
echo "現在のFlutter SDKバージョン: $current_version"
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

echo "新しいFlutter SDKバージョン: $new_version"
```

pubspec.yaml のバージョンを更新:

```bash
sed -i '' -E "s/^version: [0-9]+\.[0-9]+\.[0-9]+$/version: $new_version/" pubspec.yaml
```

ios/caretailbooster_sdk.podspec のバージョンを更新:

```bash
sed -i '' -E "s/s\.version.*=.*'[0-9]+\.[0-9]+\.[0-9]+'/s.version          = '$new_version'/" ios/caretailbooster_sdk.podspec
```

example/pubspec.yaml のgit refを更新:

```bash
sed -i '' -E "s/ref: [0-9]+\.[0-9]+\.[0-9]+$/ref: $new_version/" example/pubspec.yaml
```

変更内容を確認:

```bash
git diff pubspec.yaml ios/caretailbooster_sdk.podspec example/pubspec.yaml
```

変更をコミット:

```bash
git add pubspec.yaml ios/caretailbooster_sdk.podspec example/pubspec.yaml
git commit -m "update sdk version to $new_version"
```

完了しました！