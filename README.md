# 判別分析ツール

学習用データとテスト用データを読み込み、線形判別分析（LDA）でテスト用データに予測ラベルを付与するツールです。GUI とコマンドラインの両方で実行できます。

## 実行ファイル

- `DiscriminantAnalysis.exe`
  - CSV と Excel（`.xlsx`）に対応した通常版です。
- `DiscriminantAnalysisCSV.exe`
  - CSV のみに対応した軽量版です。

## 対応形式

| ツール | 入力 | 出力 |
| --- | --- | --- |
| `DiscriminantAnalysis` | `.csv`, `.xlsx` | 入力したテストファイルと同じ形式 |
| `DiscriminantAnalysisCSV` | `.csv` | `.csv` |

通常版では、テストファイルが `.csv` の場合は CSV、`.xlsx` の場合は Excel で結果を保存します。レポートも同じ拡張子で保存されます。

## 入力データ

学習用データ:

- 1列目: ID
- 2列目以降: 特徴量
- 最終列: クラスター
- クラスターは2種類以上必要です。

テスト用データ:

- 1列目: ID
- 2列目以降: 特徴量
- 最終列名が `label`, `target`, `cluster` の場合はラベル列として扱い、予測対象の特徴量から除外します。

特徴量はすべて数値である必要があります。学習用データとテスト用データの特徴量数は一致している必要があります。

## 出力ファイル

出力先フォルダを指定しない場合、テスト用データと同じフォルダに保存します。ファイル名には `MMDDHHMM` 形式のタイムスタンプが付き、同名ファイルがある場合は `_01`, `_02` のような連番が付きます。

- `lda_report_日時.csv` または `lda_report_日時.xlsx`
  - 学習データの判別精度、学習データのクラスターと予測グループのクロス集計、クラス事前確率、係数、切片、標準化に使った平均と分散を出力します。
  - クロス集計では、行に「クラスター」、列に「予測グループ」を表示します。
- `<テストファイル名>_with_prediction_日時.csv` または `.xlsx`
  - テスト用データに `predicted_label` 列を追加した結果を出力します。

## GUIで使う

1. 実行ファイルを起動します。
2. 学習用ファイルを選択します。
3. テスト用ファイルを選択します。
4. 必要に応じて出力フォルダを選択します。
5. 実行ボタンを押します。

引数なしで Python スクリプトを起動した場合も GUI が起動します。

```powershell
python discriminant_analysis.py
python discriminant_analysis_csv.py
```

## コマンドラインで使う

通常版:

```powershell
python discriminant_analysis.py --train data.xlsx --test test.xlsx --output-dir output
```

CSV専用版:

```powershell
python discriminant_analysis_csv.py --train data.csv --test test.csv --output-dir output
```

主な引数:

- `--train`: 学習用ファイル
- `--test`: テスト用ファイル
- `--output-dir`: 出力フォルダ
- `--output-report`: レポートの出力ファイル名
- `--output-test`: 予測結果の出力ファイル名
- `--gui`: GUIを起動

`--output-report` と `--output-test` を指定した場合も、指定名にタイムスタンプが付与されます。

## ビルド

通常版:

```powershell
.\build_exe.bat
```

CSV専用版:

```powershell
.\build_exe_csv.bat
```

通常版のビルドには `pyinstaller`, `numpy`, `openpyxl` を使用します。CSV専用版のビルドには `pyinstaller`, `numpy` を使用します。

## 追加出力

- `lda_report_日時.csv` または `lda_report_日時.xlsx` の一番下に、テストデータでの予測グループ集計分布を出力します。
- 集計分布は `predicted_label`, `count`, `ratio` の列で、予測グループごとの件数と比率を確認できます。
