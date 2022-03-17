# amatsukaze_auto_build

Amatsukaze本体及び依存関係の自動ビルド

## 概要

GitHub Actionを使用してAmatsukaze本体及び依存関係の自動ビルドを行います。

## 注意

この配布だけでは動作しません。いくつかのファイルを[Amatsukaze](https://github.com/nekopanda/Amatsukaze.git)から持ってくる必要があります。

- GitHubにあるAviSynthCUDAFiltersが古く、現在のAmatsukazeでは動作しない。

    AvsCUDA.dll、KFM.dll、KFMDeint.avsi、KNNEDI3.dll、KSMDegrain.avsi、KTGMC.avsi、KTGMC.dll を置き換えてください。

## 自動ビルドしているもの

### 本体

- [Amatsukaze](https://github.com/R2Lish/Amatsukaze.git)
- [NicoJK18Client](https://github.com/nekopanda/Amatsukaze.git)

### 同梱AviSynthプラグイン

- [AviSynthCUDAFilters](https://github.com/nekopanda/AviSynthCUDAFilters.git)
- [AvisyntNeo](https://github.com/nekopanda/AviSynthPlus.git)
- [D3DVP](https://github.com/nekopanda/D3DVP.git)
- [masktools](https://github.com/pinterf/masktools.git)
- [mvtools](https://github.com/pinterf/mvtools.git)
- [yadifmod2](https://github.com/Asd-g/yadifmod2.git)
- [TIVTC](https://github.com/pinterf/TIVTC.git)
- [RgTools](https://github.com/pinterf/RgTools.git)
- [NNEDI3](https://github.com/jpsdr/NNEDI3.git)
- [LSMASH Works](https://github.com/Mr-Ojii/L-SMASH-Works.git)

### その他関係ライブラリー

- [openssl](https://github.com/openssl/openssl.git)
- [zlib-ng](https://github.com/zlib-ng/zlib-ng.git)
- [mfx_dispatch](https://github.com/lu-zero/mfx_dispatch.git)
- [nv codec headers](https://github.com/FFmpeg/nv-codec-headers.git)
- [Ut Video Codec Suite](https://github.com/umezawatakeshi/utvideo.git)
- [FFmpeg 4.3](https://github.com/FFmpeg/FFmpeg.git)

### 同梱ソフトウェア

- [L-SMASH](https://github.com/rigaya/l-smash.git)
- [mp4box](https://github.com/gpac/gpac.git)
- [chapter_exe](https://github.com/nekopanda/chapter_exe.git)
- [join_logo_scp](https://github.com/yobibi/join_logo_scp.git)
- [qaac](https://github.com/nu774/qaac.git)
- [x264](https://code.videolan.org/videolan/x264.git)
- [x265](https://bitbucket.org/multicoreware/x265_git.git)

## 今後の予定

fdkaac自体はビルドに成功しており、後にビルド項目に入れますが同梱するかどうかは不明です。ライセンスにいくつかの疑問があるためです。

mkvmergeはMKVToolNixのビルドがかなり複雑なので、対応に時間がかかる予定です。

- mkvmerge(MKVToolNix)
- SvtHevcEnc
- fdkaac
