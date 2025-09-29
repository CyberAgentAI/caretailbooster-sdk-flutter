---
allowed-tools: Bash(grep:*), Bash(git:*), Bash(sed:*)
description: Android SDKのバージョンを更新してコミットを作成
---

Android SDKのバージョンを更新します。

まず現在のバージョンを確認:

```bash
current_version=$(grep "implementation(\"com.retaiboo:caretailbooster-sdk:" android/build.gradle | grep -o "[0-9]\+\.[0-9]\+\.[0-9]\+" | head -1)
echo "現在のAndroid SDKバージョン: $current_version"
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

echo "新しいAndroid SDKバージョン: $new_version"
```

android/build.gradle のバージョンを更新:

```bash
sed -i '' -E "s/implementation\(\"com.retaiboo:caretailbooster-sdk:[0-9]+\.[0-9]+\.[0-9]+\"\)/implementation(\"com.retaiboo:caretailbooster-sdk:$new_version\")/" android/build.gradle
```

変更内容を確認:

```bash
git diff android/build.gradle
```

変更をコミット:

```bash
git add android/build.gradle
git commit -m "update android sdk version to $new_version"
```

完了しました！