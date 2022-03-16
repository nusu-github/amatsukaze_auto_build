@echo off
setlocal

@rem    ��������̗��R�Ń��[�J���Ńr���h�������ꍇ�͂�������g�p���Ă��������B
@rem    GitHub action�p�ł͂���܂���B
@rem
@rem    ���O����
@rem    �f�t�H���g��Visual Studio 2022 ���K�v�ł��B �܂��AUt Video Codec Suite��MSVC v142���K�v�ł��B
@rem    Visual Studio 2019 �Ńr���h����ꍇ�́APlatformToolset v142��cmake -G "Visual Studio 16 2019" �Ǝw�肵�Ă��������B
@rem    vcpkg���g����lz4:x64-windows-static���C���X�g�[�����Ă��������B
@rem    boost�����O�ɃC���X�g�[�����Ă��������B�C���X�g�[�����C:\soft\boost\�ł��B
@rem    ��������masktools �r���h�̗��ɂ���call powershell����n�܂�s�𒲐����Ă��������B
@rem    CUDA Toolkit 11.6���C���X�g�[�����Ă��������B
@rem    FFmpeg���r���h���Ă��������B�R�}���h��build.yml��FFmpeg�r���h�R�}���h���g�p���Ă��������B�r���h�������FFmpeg����output�t�H���_�[��local\FFmpeg�t�H���_�[�ɃR�s�[���Ă��������B

@rem    �������C�i�[�N���R�}���h
@rem    cmd /k 'set MSYS2_PATH_TYPE=inherit && "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64 && C:\tools\msys64\msys2_shell.cmd -mingw64 -defterm -no-start -here'

@rem �r���h�ˑ����C�u����

@rem zlib-ng �r���h
pushd "%~dp0"
    git clone https://github.com/zlib-ng/zlib-ng.git --depth 1
    cd zlib-ng
    cmake -G "Ninja" -S . -B build -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=true -DZLIB_COMPAT=true -DZLIB_ENABLE_TESTS=false
    cmake --build build
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem mfx_dispatch �r���h
pushd "%~dp0"
    git clone https://github.com/lu-zero/mfx_dispatch.git --depth 1
    cd mfx_dispatch
    cmake -G "Ninja" -S . -B build -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=true
    cmake --build build
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem ����&�ˑ����C�u����

@rem FFmpeg �r���h
pushd "%~dp0"
    @rem MSVC�ł̓r���h�ł��Ȃ��̂�MSYS2���g�p���ăr���h���Ă��������B
    @rem �d�v�Ȃ̂� --enable-libmfx �� --enable-nvdec �ł��B������w�肵�Ȃ��ƃn�[�h�E�F�A�f�R�[�h�ł��܂���B
popd

@rem L-SMASH �r���h
@rem ���ɓ���ɉe�����Ȃ����������AVC�̕ύX�Ȃǂ��������Ă���rigaya�ł��g�p����B
pushd "%~dp0"
    git clone https://github.com/rigaya/l-smash.git -b add_ver_info
    cd l-smash
    msbuild L-SMASH.sln /m /t:rebuild /p:Configuration=CLIRelease /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143 /p:TargetFrameworkVersion=v4.8
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem x264 �r���h
pushd "%~dp0"
    @rem MSVC�ł̓r���h�ł��Ȃ��̂�MSYS2���g�p���ăr���h���Ă��������B
popd

@rem x265 �r���h
pushd "%~dp0"
    @rem MSVC�ł̓r���h�ł��Ȃ��̂�MSYS2���g�p���ăr���h���Ă��������B
popd

@rem Ut Video Codec Suite �r���h
@rem ����:clang��msvc�𗼕��g�p����ׁAPlatformToolset�͎w��ł��Ȃ��Butvideo�͌���v142�Ńr���h�ł���B
pushd "%~dp0"
    git clone --depth=1 https://github.com/umezawatakeshi/utvideo.git
    cd utvideo
    msbuild utvideo.sln /m /t:utv_core:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PostBuildEventUseInBuild=false
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem AviSynthNeo �r���h
@rem ���ɖ{�ƂɎ�荞�܂�Ă��邪Amatsukaze�ł͓��삵�Ȃ��悤�Ȃ̂ŁA���X�̕����g�p����B
pushd "%~dp0"
    git clone --depth=1 https://github.com/nekopanda/AviSynthPlus.git
    cd AviSynthPlus
    cmake -G "Visual Studio 17 2022" -S . -B build -A x64 -DBUILD_SHARED_LIBS=true -DCMAKE_CONFIGURATION_TYPES=Release
    cmake --build build --config Release --target AvsCore -- /m /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem join_logo_scp �r���h
@rem �o�[�W�������オ���Ă���t�H�[�N�̕����g�p
pushd "%~dp0"
    git clone --depth=1 https://github.com/yobibi/join_logo_scp.git
    cd join_logo_scp\src
    msbuild join_logo_scp.sln /m /t:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem chapter_exe �r���h
pushd "%~dp0"
    git clone --depth=1 https://github.com/nekopanda/chapter_exe.git
    cd chapter_exe\src
    msbuild chapter_exe.sln /m /t:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem MP4Box �r���h
pushd "%~dp0"
    git clone --recurse-submodules --remote-submodules -j2 https://github.com/gpac/gpac.git
    cd gpac\build\msvc14
    msbuild gpac.sln /m /t:Rebuild /p:Configuration="Release - MP4Box_only" /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem mkvmerge �r���h
pushd "%~dp0"
    @rem MSVC�ł̓r���h�ł��Ȃ��̂�MSYS2���g�p���ăr���h���Ă��������B
popd

@rem OpenSSL �r���h
pushd "%~dp0"
    git clone --depth=1 https://github.com/openssl/openssl.git -b OpenSSL_1_0_2-stable
    cd openssl
    perl Configure VC-WIN64A
    call .\ms\do_win64a
    nmake /S /f ms\ntdll.mak
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem qaac �r���h
pushd "%~dp0"
    git clone --depth 1 https://github.com/nu774/qaac.git
    cd qaac\vcproject
    msbuild qaac.sln /m /t:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem ����AviSynth�v���O�C��

@rem LSMASH Works �r���h
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
    @rem �����s���Ȃ��̂̃r���h�ł��Ȃ��̂ŁAXXH_INLINE_ALL��ǉ����Ă���B
    git am ..\..\..\patch\0001-Add-XXH_INLINE_ALL.patch
    msbuild LSMASHSourceVCX.sln /m /t:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem QTGMC �r���h
pushd "%~dp0"
    cd bin
    git clone https://github.com/realfinder/AVS-Stuff.git
    cd AVS-Stuff
    git reset --hard 17c2b46
popd

@rem RgTools �r���h
pushd "%~dp0"
    git clone --depth=1 https://github.com/pinterf/RgTools.git
    cd RgTools
    msbuild RgTools.sln /m /t:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem NNEDI3 �r���h
pushd "%~dp0"
    git clone --depth 1 https://github.com/jpsdr/NNEDI3.git
    cd NNEDI3
    git am ..\..\patch\0001-asm_FMA_x64-enable.patch
    msbuild NNEDI3.sln /m /t:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem mvtools �r���h
pushd "%~dp0"
    git clone --depth=1 https://github.com/pinterf/mvtools.git
    cd mvtools
    msbuild mvtools.sln /m /t:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem masktools �r���h
pushd "%~dp0"
    git clone --depth=1 https://github.com/pinterf/masktools.git
    cd masktools
    call powershell -command "Get-Content masktools\build\masktools.vcxproj | foreach { $_ -replace 'C:\Soft\Boost' , 'C:\Soft\Boost' } > masktools.vcxproj.tmp"
    xcopy masktools.vcxproj.tmp masktools\build\masktools.vcxproj /Y
    msbuild masktools.sln /m /t:rebuild /p:Configuration=release-boost /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem AvsCUDA,KTGMC,KNNEDI3,KFM �r���h
pushd "%~dp0"
    git clone --depth 1 --recurse-submodules --shallow-submodules --remote-submodules -j2 https://github.com/nekopanda/AviSynthCUDAFilters.git
    xcopy AviSynthPlus\build\Output\c_api\AviSynth.lib AviSynthCUDAFilters\lib\x64 /Y
    cd AviSynthCUDAFilters
    @rem CUDA Toolkit�̃o�[�W�����ύX�B
    @rem ���ˑ��R�[�h�������ŐV��GPU�܂őΉ�����悤�ɕύX�B
    @rem �W���������[�h������
    @rem C17�L����
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

@rem SMDegrain �r���h
pushd "%~dp0"
    curl "https://raw.githubusercontent.com/avisynth-repository/SMDegrain/master/SMDegrain.avsi" -O
popd

@rem D3DVP �r���h
pushd "%~dp0"
    git clone --depth 1 --recurse-submodules --shallow-submodules --remote-submodules https://github.com/nekopanda/D3DVP.git
    xcopy AviSynthPlus\build\Output\c_api\AviSynth.lib D3DVP\lib\x64 /Y
    cd D3DVP
    msbuild D3DVP.sln /m /t:D3DVP:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem yadifmod2 �r���h
pushd "%~dp0"
    git clone --depth 1 https://github.com/Asd-g/yadifmod2.git
    cd yadifmod2
    git clone --depth=1 https://github.com/AviSynth/AviSynthPlus.git
    xcopy AviSynthPlus\avs_core\include\* src /Y /E
    msbuild msvc\yadifmod2.vcxproj /m /t:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem TIVTC �r���h
pushd "%~dp0"
    git clone https://github.com/pinterf/TIVTC.git --depth 1
    cd TIVTC\src
    msbuild TIVTC.sln /m /t:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem Amatsukaze�{��

@rem Amatsukaze�{�� �r���h
@rem �{�Ɣłł͂Ȃ��A�l�X�ȍX�V�������Ă���R2Lish�ł��g�p���Ă��܂��B
pushd "%~dp0"
    git clone --recurse-submodules --remote-submodules https://github.com/R2Lish/Amatsukaze.git
    mkdir Amatsukaze\lib\x64
    @rem lib���R�s�[
    xcopy openssl\out32dll\* Amatsukaze\lib\x64 /Y
    xcopy utvideo\x64\Release\* Amatsukaze\lib\x64 /Y
    xcopy FFmpeg\output\bin\* Amatsukaze\lib\x64 /Y
    xcopy AviSynthPlus\build\Output\c_api\AviSynth.lib Amatsukaze\lib\x64 /Y
    xcopy AviSynthPlus\build\Output\AviSynth.dll Amatsukaze\lib\x64 /Y
    @rem header���R�s�[
    rmdir /S /Q Amatsukaze\include\libavcodec Amatsukaze\include\libavdevice Amatsukaze\include\libavfilter Amatsukaze\include\libavformat Amatsukaze\include\libavutil Amatsukaze\include\libswresample Amatsukaze\include\libswscale Amatsukaze\include\openssl Amatsukaze\include\avs Amatsukaze\include\utvideo
    xcopy FFmpeg\output\include\* Amatsukaze\include /Y /E
    xcopy utvideo\utv_core\* Amatsukaze\include\utvideo /Y /E /I
    xcopy openssl\inc32\* Amatsukaze\include /Y /E
    xcopy AviSynthPlus\avs_core\include\* Amatsukaze\include /Y /E
    cd Amatsukaze
    @rem �o�b�`�t�@�C�����쐬����Ƃ��ɕ����R�[�h���K��UTF-8�ɂȂ�o�O�̏C���p�b�`��K�p
    git am ..\..\patch\0001-bat-file-character-encoding-bug-fixed.patch
    msbuild Amatsukaze.sln /m /t:restore /t:FileCutter:rebuild /t:AmatsukazeCLI:rebuild /t:Caption:rebuild /t:BatchHashChecker:rebuild /t:AmatsukazeAddTask:rebuild /t:AmatsukazeServer:rebuild /t:AmatsukazeServerCLI:rebuild /t:AmatsukazeGUI:rebuild /t:ScriptCommand:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem Amatsukaze NicoJK18Client �r���h
@rem ��L�̃o�[�W�����ł�NicoJK18Client�̕ύX���K������Ă��Ȃ��̂ŁANicoJK18Client�����{�ƂŃr���h���܂��B
pushd "%~dp0"
    git clone --depth 1 --recurse-submodules --shallow-submodules --remote-submodules https://github.com/nekopanda/Amatsukaze.git Amatsukaze_nicojk18 -b nicojk18
    cd Amatsukaze_nicojk18
    msbuild Amatsukaze.sln /m /t:restore /t:NicoJK18Client:rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10 /p:PlatformToolset=v143 /p:TargetFrameworkVersion=v4.8
    if %errorlevel%  neq 0 (exit /b 1)
popd

@rem �r���h���ʕ����p�b�N�ɂ���

pushd "%~dp0"
    mkdir Amatsukaze_pack
    xcopy join_logo_scp\JL Amatsukaze_pack\JL /Y /E /I
    mkdir Amatsukaze_pack\exe_files
    mkdir Amatsukaze_pack\exe_files\plugins64
    mkdir Amatsukaze_pack\exe_files\cmd
    mkdir Amatsukaze_pack\exe_files\plugins64\AutoSelected
    @rem ����&�ˑ����C�u����

    @rem L-SMASH
    xcopy l-smash\x64\CLIRelease\*.exe Amatsukaze_pack\exe_files /Y
    @rem join_logo_scp ������(DivFile�R�}���h��ǉ����܂���(������))
    xcopy join_logo_scp\src\x64\Release\join_logo_scp.exe Amatsukaze_pack\exe_files /Y
    @rem chapter_exe �����ŁiVFW�Ɉˑ����Ȃ���Avisynth�X�N���v�g��ǂ߂�悤�ɉ������Ă��܂��j
    xcopy chapter_exe\src\x64\Release\chapter_exe.exe Amatsukaze_pack\exe_files /Y
    @rem MP4Box
    xcopy "gpac\bin\x64\Release - MP4Box_only\mp4box.exe" Amatsukaze_pack\exe_files /Y
    @rem qaac
    xcopy qaac\vcproject\x64\Release\qaac64.exe Amatsukaze_pack\exe_files /Y

    @rem ����AviSynth�v���O�C��

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