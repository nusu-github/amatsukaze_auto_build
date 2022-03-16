@echo off
setlocal

@rem    何かしらの理由でローカルでビルドしたい場合はこちらを使用してください。
@rem    GitHub action用ではありません。
@rem
@rem    事前準備
@rem    デフォルトはVisual Studio 2022 が必要です。 また、Ut Video Codec SuiteがMSVC v142が必要です。
@rem    Visual Studio 2019 でビルドする場合は、PlatformToolset v142とcmake -G "Visual Studio 16 2019" と指定してください。
@rem    vcpkgを使ってlz4:x64-windows-staticをインストールしてください。
@rem    boostを事前にインストールしてください。インストール先はC:\soft\boost\です。
@rem    もしくはmasktools ビルドの欄にあるcall powershellから始まる行を調整してください。
@rem    CUDA Toolkit 11.6をインストールしてください。
@rem    FFmpegをビルドしてください。コマンドはbuild.ymlのFFmpegビルドコマンドを使用してください。ビルド完了後はFFmpeg内のoutputフォルダーをlocal\FFmpegフォルダーにコピーしてください。

@rem    ワンライナー起動コマンド
@rem    cmd /k 'set MSYS2_PATH_TYPE=inherit && "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64 && C:\tools\msys64\msys2_shell.cmd -mingw64 -defterm -no-start -here'

@rem ビルド依存ライブラリ

@rem zlib-ng ビルド
pushd "%~dp0"
    git clone https://github.com/zlib-ng/zlib-ng.git --depth 1
    cd zlib-ng
    cmake -G "Ninja" -S . -B build -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=true -DZLIB_COMPAT=true -DZLIB_ENABLE_TESTS=false
    cmake --build build
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem mfx_dispatch ビルド
pushd "%~dp0"
    git clone https://github.com/lu-zero/mfx_dispatch.git --depth 1
    cd mfx_dispatch
    cmake -G "Ninja" -S . -B build -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=true
    cmake --build build
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem 同梱&依存ライブラリ

@rem FFmpeg ビルド
pushd "%~dp0"
    @rem MSVCではビルドできないのでMSYS2を使用してビルドしてください。
    @rem 重要なのは --enable-libmfx と --enable-nvdec です。これを指定しないとハードウェアデコードできません。
popd

@rem L-SMASH ビルド
@rem 特に動作に影響がなさそうだが、VCの変更などが加えられているrigaya版を使用する。
pushd "%~dp0"
    git clone https://github.com/rigaya/l-smash.git -b add_ver_info
    cd l-smash
    msbuild L-SMASH.sln /m /t:rebuild /p:Configuration=CLIRelease /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143 /p:TargetFrameworkVersion=v4.8
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem x264 ビルド
pushd "%~dp0"
    @rem MSVCではビルドできないのでMSYS2を使用してビルドしてください。
popd

@rem x265 ビルド
pushd "%~dp0"
    @rem MSVCではビルドできないのでMSYS2を使用してビルドしてください。
popd

@rem Ut Video Codec Suite ビルド
@rem 注意:clangとmsvcを両方使用する為、PlatformToolsetは指定できない。utvideoは現状v142でビルドできる。
pushd "%~dp0"
    git clone --depth=1 https://github.com/umezawatakeshi/utvideo.git
    cd utvideo
    msbuild utvideo.sln /m /t:utv_core:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PostBuildEventUseInBuild=false
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem AviSynthNeo ビルド
@rem 既に本家に取り込まれているがAmatsukazeでは動作しないようなので、元々の方を使用する。
pushd "%~dp0"
    git clone --depth=1 https://github.com/nekopanda/AviSynthPlus.git
    cd AviSynthPlus
    cmake -G "Visual Studio 17 2022" -S . -B build -A x64 -DBUILD_SHARED_LIBS=true -DCMAKE_CONFIGURATION_TYPES=Release
    cmake --build build --config Release --target AvsCore -- /m /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem join_logo_scp ビルド
@rem バージョンが上がっているフォークの方を使用
pushd "%~dp0"
    git clone --depth=1 https://github.com/yobibi/join_logo_scp.git
    cd join_logo_scp\src
    msbuild join_logo_scp.sln /m /t:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem chapter_exe ビルド
pushd "%~dp0"
    git clone --depth=1 https://github.com/nekopanda/chapter_exe.git
    cd chapter_exe\src
    msbuild chapter_exe.sln /m /t:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem MP4Box ビルド
pushd "%~dp0"
    git clone --recurse-submodules --remote-submodules -j2 https://github.com/gpac/gpac.git
    cd gpac\build\msvc14
    msbuild gpac.sln /m /t:Rebuild /p:Configuration="Release - MP4Box_only" /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem mkvmerge ビルド
pushd "%~dp0"
    @rem MSVCではビルドできないのでMSYS2を使用してビルドしてください。
popd

@rem OpenSSL ビルド
pushd "%~dp0"
    git clone --depth=1 https://github.com/openssl/openssl.git -b OpenSSL_1_0_2-stable
    cd openssl
    perl Configure VC-WIN64A
    call .\ms\do_win64a
    nmake /S /f ms\ntdll.mak
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem qaac ビルド
pushd "%~dp0"
    git clone --depth 1 https://github.com/nu774/qaac.git
    cd qaac\vcproject
    msbuild qaac.sln /m /t:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem 同梱AviSynthプラグイン

@rem LSMASH Works ビルド
pushd "%~dp0"
    git clone https://github.com/Mr-Ojii/L-SMASH-Works.git
    mkdir L-SMASH-Works\build64_msvc\lib
    xcopy zlib-ng\build\zlib.lib L-SMASH-Works\build64_msvc\lib /Y
    xcopy mfx_dispatch\build\mfx.lib L-SMASH-Works\build64_msvc\lib /Y
    xcopy l-smash\x64\CLIRelease\liblsmash.lib L-SMASH-Works\build64_msvc\lib /Y
    xcopy l-smash\lsmash.h L-SMASH-Works\include /Y
    xcopy FFmpeg\output\include L-SMASH-Works\include /Y /E
    xcopy FFmpeg\output\lib L-SMASH-Works\build64_msvc\lib /Y
    cd L-SMASH-Works\AviSynth
    @rem 原因不明なもののビルドできないので、XXH_INLINE_ALLを追加している。
    git am ..\..\..\patch\0001-Add-XXH_INLINE_ALL.patch
    msbuild LSMASHSourceVCX.sln /m /t:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem QTGMC ビルド
pushd "%~dp0"
    cd bin
    git clone https://github.com/realfinder/AVS-Stuff.git
    cd AVS-Stuff
    git reset --hard 17c2b46
popd

@rem RgTools ビルド
pushd "%~dp0"
    git clone --depth=1 https://github.com/pinterf/RgTools.git
    cd RgTools
    msbuild RgTools.sln /m /t:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem NNEDI3 ビルド
pushd "%~dp0"
    git clone --depth 1 https://github.com/jpsdr/NNEDI3.git
    cd NNEDI3
    git am ..\..\patch\0001-asm_FMA_x64-enable.patch
    msbuild NNEDI3.sln /m /t:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem mvtools ビルド
pushd "%~dp0"
    git clone --depth=1 https://github.com/pinterf/mvtools.git
    cd mvtools
    msbuild mvtools.sln /m /t:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem masktools ビルド
pushd "%~dp0"
    git clone --depth=1 https://github.com/pinterf/masktools.git
    cd masktools
    call powershell -command "Get-Content masktools\build\masktools.vcxproj | foreach { $_ -replace 'C:\Soft\Boost' , 'C:\Soft\Boost' } > masktools.vcxproj.tmp"
    xcopy masktools.vcxproj.tmp masktools\build\masktools.vcxproj /Y
    msbuild masktools.sln /m /t:rebuild /p:Configuration=release-boost /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem AvsCUDA,KTGMC,KNNEDI3,KFM ビルド
pushd "%~dp0"
    git clone --depth 1 --recurse-submodules --shallow-submodules --remote-submodules -j2 https://github.com/nekopanda/AviSynthCUDAFilters.git
    xcopy AviSynthPlus\build\Output\c_api\AviSynth.lib AviSynthCUDAFilters\lib\x64 /Y
    cd AviSynthCUDAFilters
    @rem CUDA Toolkitのバージョン変更。
    @rem 環境依存コード生成を最新のGPUまで対応するように変更。
    @rem 標準準拠モード無効化
    @rem C17有効化
    call powershell -command "Get-Content AvsCUDA\AvsCUDA.vcxproj | foreach { $_ -replace 'CUDA 8.0' , 'CUDA 11.6' } | foreach { $_ -replace 'compute_61,sm_61;compute_35,sm_35' , 'compute_35,sm_35;compute_52,sm_52;compute_61,sm_61;compute_75,sm_75;compute_86,sm_86' } | foreach { $_ -replace '<ConformanceMode>true</ConformanceMode>' , '<ConformanceMode>false</ConformanceMode>' } | foreach { $_ -replace '<AdditionalOptions>-Xcompiler \"/wd 4819\"', '<AdditionalOptions>-std=c++17 -Xcompiler \"/std:c++17\" -Xcompiler \"/wd 4819\"' } > AvsCUDA.vcxproj.tmp"
    call powershell -command "Get-Content KFM\KFM.vcxproj | foreach { $_ -replace 'CUDA 8.0' , 'CUDA 11.6' } | foreach { $_ -replace 'compute_61,sm_61;compute_35,sm_35' , 'compute_35,sm_35;compute_52,sm_52;compute_61,sm_61;compute_75,sm_75;compute_86,sm_86' } > KFM.vcxproj.tmp"
    call powershell -command "Get-Content KTGMC\KTGMC.vcxproj | foreach { $_ -replace 'CUDA 8.0' , 'CUDA 11.6' } | foreach { $_ -replace 'compute_61,sm_61;compute_35,sm_35' , 'compute_35,sm_35;compute_52,sm_52;compute_61,sm_61;compute_75,sm_75;compute_86,sm_86' }  > KTGMC.vcxproj.tmp"
    call powershell -command "Get-Content nnedi3\nnedi3\nnedi3.vcxproj | foreach { $_ -replace 'CUDA 8.0' , 'CUDA 11.6' } | foreach { $_ -replace 'compute_61,sm_61;compute_35,sm_35' , 'compute_35,sm_35;compute_52,sm_52;compute_61,sm_61;compute_75,sm_75;compute_86,sm_86' } > nnedi3.vcxproj.tmp"
    xcopy AvsCUDA.vcxproj.tmp AvsCUDA\AvsCUDA.vcxproj /Y
    xcopy KFM.vcxproj.tmp KFM\KFM.vcxproj /Y
    xcopy KTGMC.vcxproj.tmp KTGMC\KTGMC.vcxproj /Y
    xcopy nnedi3.vcxproj.tmp nnedi3\nnedi3\nnedi3.vcxproj /Y
    msbuild AviSynthCUDAFilters.sln /m /t:AvsCUDA:rebuild /t:KTGMC:rebuild /t:KNNEDI3:rebuild /t:KFM:rebuild /t:KUtil:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143 /p:ContinueOnError=WarnAndContinue
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem SMDegrain ビルド
pushd "%~dp0"
    curl "https://raw.githubusercontent.com/avisynth-repository/SMDegrain/master/SMDegrain.avsi" -O
popd

@rem D3DVP ビルド
pushd "%~dp0"
    git clone --depth 1 --recurse-submodules --shallow-submodules --remote-submodules https://github.com/nekopanda/D3DVP.git
    xcopy AviSynthPlus\build\Output\c_api\AviSynth.lib D3DVP\lib\x64 /Y
    cd D3DVP
    msbuild D3DVP.sln /m /t:D3DVP:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem yadifmod2 ビルド
pushd "%~dp0"
    git clone --depth 1 https://github.com/Asd-g/yadifmod2.git
    cd yadifmod2
    git clone --depth=1 https://github.com/AviSynth/AviSynthPlus.git
    xcopy AviSynthPlus\avs_core\include\* src /Y /E
    msbuild msvc\yadifmod2.vcxproj /m /t:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem TIVTC ビルド
pushd "%~dp0"
    git clone https://github.com/pinterf/TIVTC.git --depth 1
    cd TIVTC\src
    msbuild TIVTC.sln /m /t:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem Amatsukaze本体

@rem Amatsukaze本体 ビルド
@rem 本家版ではなく、様々な更新が入っているR2Lish版を使用しています。
pushd "%~dp0"
    git clone --recurse-submodules --remote-submodules https://github.com/R2Lish/Amatsukaze.git
    mkdir Amatsukaze\lib\x64
    @rem libをコピー
    xcopy openssl\out32dll\* Amatsukaze\lib\x64 /Y
    xcopy utvideo\x64\Release\* Amatsukaze\lib\x64 /Y
    xcopy FFmpeg\output\bin\* Amatsukaze\lib\x64 /Y
    xcopy AviSynthPlus\build\Output\c_api\AviSynth.lib Amatsukaze\lib\x64 /Y
    xcopy AviSynthPlus\build\Output\AviSynth.dll Amatsukaze\lib\x64 /Y
    @rem headerをコピー
    rmdir /S /Q Amatsukaze\include\libavcodec Amatsukaze\include\libavdevice Amatsukaze\include\libavfilter Amatsukaze\include\libavformat Amatsukaze\include\libavutil Amatsukaze\include\libswresample Amatsukaze\include\libswscale Amatsukaze\include\openssl Amatsukaze\include\avs Amatsukaze\include\utvideo
    xcopy FFmpeg\output\include\* Amatsukaze\include /Y /E
    xcopy utvideo\utv_core\* Amatsukaze\include\utvideo /Y /E /I
    xcopy openssl\inc32\* Amatsukaze\include /Y /E
    xcopy AviSynthPlus\avs_core\include\* Amatsukaze\include /Y /E
    cd Amatsukaze
    @rem バッチファイルを作成するときに文字コードが必ずUTF-8になるバグの修正パッチを適用
    git am ..\..\patch\0001-bat-file-character-encoding-bug-fixed.patch
    msbuild Amatsukaze.sln /m /t:restore /t:FileCutter:rebuild /t:AmatsukazeCLI:rebuild /t:Caption:rebuild /t:BatchHashChecker:rebuild /t:AmatsukazeAddTask:rebuild /t:AmatsukazeServer:rebuild /t:AmatsukazeServerCLI:rebuild /t:AmatsukazeGUI:rebuild /t:ScriptCommand:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem Amatsukaze NicoJK18Client ビルド
@rem 上記のバージョンではNicoJK18Clientの変更が適応されていないので、NicoJK18Clientだけ本家でビルドします。
pushd "%~dp0"
    git clone --depth 1 --recurse-submodules --shallow-submodules --remote-submodules https://github.com/nekopanda/Amatsukaze.git Amatsukaze_nicojk18 -b nicojk18
    cd Amatsukaze_nicojk18
    msbuild Amatsukaze.sln /m /t:restore /t:NicoJK18Client:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143 /p:TargetFrameworkVersion=v4.8
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem ビルド成果物をパックにする

pushd "%~dp0"
    mkdir Amatsukaze_pack
    xcopy join_logo_scp\JL Amatsukaze_pack\JL /Y /E /I
    mkdir Amatsukaze_pack\exe_files
    mkdir Amatsukaze_pack\exe_files\plugins64
    mkdir Amatsukaze_pack\exe_files\cmd
    mkdir Amatsukaze_pack\exe_files\plugins64\AutoSelected
    @rem 同梱&依存ライブラリ

    @rem L-SMASH
    xcopy l-smash\x64\CLIRelease\*.exe Amatsukaze_pack\exe_files /Y
    @rem join_logo_scp 改造版(DivFileコマンドを追加しました(改造元))
    xcopy join_logo_scp\src\x64\Release\join_logo_scp.exe Amatsukaze_pack\exe_files /Y
    @rem chapter_exe 改造版（VFWに依存しないでAvisynthスクリプトを読めるように改造しています）
    xcopy chapter_exe\src\x64\Release\chapter_exe.exe Amatsukaze_pack\exe_files /Y
    @rem MP4Box
    xcopy "gpac\bin\x64\Release - MP4Box_only\mp4box.exe" Amatsukaze_pack\exe_files /Y
    @rem qaac
    xcopy qaac\vcproject\x64\Release\qaac64.exe Amatsukaze_pack\exe_files /Y

    @rem 同梱AviSynthプラグイン

    @rem LSMASH Works
    xcopy L-SMASH-Works\AviSynth\x64\Release\LSMASHSource.dll Amatsukaze_pack\exe_files\plugins64 /Y
    @rem QTGMC
    xcopy "AVS-Stuff\avs 2.6 and up\QTGMC.avsi" Amatsukaze_pack\exe_files\plugins64 /Y
    @rem RgTools
    xcopy RgTools\Build\x64\Release\RgTools.dll Amatsukaze_pack\exe_files\plugins64 /Y
    @rem NNEDI3
    xcopy NNEDI3\x64\Release\nnedi3.dll Amatsukaze_pack\exe_files\plugins64\AutoSelected /Y
    @rem mvtools
    xcopy mvtools\Sources\x64\Release\mvtools2.dll Amatsukaze_pack\exe_files\plugins64 /Y
    @rem masktools
    xcopy masktools\masktools\build\x64\Build\release-boost\masktools2.dll Amatsukaze_pack\exe_files\plugins64 /Y
    @rem AvsCUDA,KTGMC,KNNEDI3,KFM
    xcopy AviSynthCUDAFilters\x64\Release\*.dll Amatsukaze_pack\exe_files\plugins64 /Y
    xcopy AviSynthCUDAFilters\TestScripts\KFMDeint.avsi Amatsukaze_pack\exe_files\plugins64 /Y
    xcopy AviSynthCUDAFilters\TestScripts\KSMDegrain.avsi Amatsukaze_pack\exe_files\plugins64 /Y
    xcopy AviSynthCUDAFilters\TestScripts\KTGMC.avsi Amatsukaze_pack\exe_files\plugins64 /Y
    @rem SMDegrain
    xcopy SMDegrain.avsi Amatsukaze_pack\exe_files\plugins64 /Y
    @rem D3DVP
    xcopy D3DVP\x64\Release\D3DVP.dll Amatsukaze_pack\exe_files\plugins64 /Y
    @rem yadifmod2
    xcopy yadifmod2\msvc\x64\Release\yadifmod2.dll Amatsukaze_pack\exe_files\plugins64\AutoSelected /Y
    @rem TIVTC
    xcopy TIVTC\src\TIVTC\x64\Release\TIVTC.dll Amatsukaze_pack\exe_files\plugins64 /Y

    @rem Amatsukaze
    xcopy Amatsukaze\AmatsukazeAddTask\bin\Release\netcoreapp3.1\*.dll Amatsukaze_pack\exe_files /Y
    xcopy Amatsukaze\AmatsukazeAddTask\bin\Release\netcoreapp3.1\*.exe Amatsukaze_pack\exe_files /Y
    xcopy Amatsukaze\AmatsukazeAddTask\bin\Release\netcoreapp3.1\AmatsukazeAddTask.runtimeconfig.json Amatsukaze_pack\exe_files /Y
    xcopy Amatsukaze\AmatsukazeGUI\bin\Release\netcoreapp3.1\*.dll Amatsukaze_pack\exe_files /Y
    xcopy Amatsukaze\AmatsukazeGUI\bin\Release\netcoreapp3.1\*.exe Amatsukaze_pack\exe_files /Y
    xcopy Amatsukaze\AmatsukazeGUI\bin\Release\netcoreapp3.1\AmatsukazeGUI.runtimeconfig.json Amatsukaze_pack\exe_files /Y
    xcopy Amatsukaze\AmatsukazeServer\bin\Release\netcoreapp3.1\*.dll Amatsukaze_pack\exe_files /Y
    xcopy Amatsukaze\AmatsukazeServer\bin\Release\netcoreapp3.1\*.exe Amatsukaze_pack\exe_files /Y
    xcopy Amatsukaze\AmatsukazeServer\bin\Release\netcoreapp3.1\AmatsukazeServer.runtimeconfig.json Amatsukaze_pack\exe_files /Y
    xcopy Amatsukaze\AmatsukazeServerCLI\bin\Release\netcoreapp3.1\*.dll Amatsukaze_pack\exe_files /Y
    xcopy Amatsukaze\AmatsukazeServerCLI\bin\Release\netcoreapp3.1\*.exe Amatsukaze_pack\exe_files /Y
    xcopy Amatsukaze\AmatsukazeServerCLI\bin\Release\netcoreapp3.1\AmatsukazeServerCLI.runtimeconfig.json Amatsukaze_pack\exe_files /Y
    xcopy Amatsukaze\ScriptCommand\bin\Release\netcoreapp3.1\*.dll Amatsukaze_pack\exe_files /Y
    xcopy Amatsukaze\ScriptCommand\bin\Release\netcoreapp3.1\*.exe Amatsukaze_pack\exe_files /Y
    xcopy Amatsukaze\ScriptCommand\bin\Release\netcoreapp3.1\ScriptCommand.runtimeconfig.json Amatsukaze_pack\exe_files /Y
    xcopy Amatsukaze\x64\Release\*.dll Amatsukaze_pack\exe_files /Y
    xcopy Amatsukaze\x64\Release\*.exe Amatsukaze_pack\exe_files /Y
    xcopy Amatsukaze_nicojk18\x64\Release\*.exe Amatsukaze_pack\exe_files /Y
    if %errorlevel%  neq 0 (exit /b 1)
popd

pause