# ビルドメモ

## MinGW

- 依存なし (no_dep)

  - 実行ファイル (group_a)

    - x265
      > 時間がかかるため隔離の意味合いもある

  - AviSynth (group_b)

    - yadifmod2
    - masktools
    - mvtools
    - RgTools

- 依存あり (yes_dep)

  - 実行ファイル (group_a)

    - L-SMASH
      > 実行ファイルとして同梱する用
    - x264

  - AviSynth (group_b)

    - mfx_dispatch
    - nv-codec-headers
    - FFmpeg

## MSVC

- 依存なし (no_dep)

  - 実行ファイル (group_a)

    - join_logo_scp
    - chapter_exe
    - MP4Box
      > MinGW ではビルドが面倒なため MSVC でビルド
    - NicoJK18Client

  - AviSynth (group_b)

    - NNEDI3
    - TIVTC
    - D3DVP

- 依存あり (yes_dep)

  - (group_a)

    - Ut Video Codec Suite
    - openssl

  - (group_b)

    - mfx_dispatch
    - L-SMASH
      > L-SMASH-Works用のビルド
    - zlib-ng
    - **MinGW-yes_dep-group_b FFmpeg**
    - L-SMASH-Works

  - (group_c)

    - AvisynthNeo
    - AviSynthCUDAFilters

  - (group_d)

    - **MinGW-yes_dep-group_b FFmpeg**
    - **MSVC-yes_dep-group_a Ut Video Codec Suite**
    - **MSVC-yes_dep-group_a openssl**
    - **MSVC-yes_dep-group_c AvisynthNeo**
    - Amatsukaze

- その他 (other)

  - ダウンロード (download)

    - QTGMC
    - mkvmerge
      > ビルドに時間がかかる上メインじゃないためダウンロード
    - SMDegrain
    - AviSynthCUDAFilters
      > ソースコードでビルドしたものでは動作しないため同梱されてる方に置き換え

## packaging
