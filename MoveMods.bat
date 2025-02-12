@echo off
chcp 65001 >nul
setlocal

:: Устанавливаем пути
set "LOGFILE=%~dp0MoveMods.log"
set "DESTINATION=%APPDATA%\.minecraft\mods"
set "GIT_REPO=https://github.com/kekstm989/Quarion.git"
set "CLONE_DIR=%~dp0QuarionRepo"
set "GIT_INSTALLER=%~dp0GitInstaller.exe"
set "GIT_DOWNLOAD=https://github.com/git-for-windows/git/releases/latest/download/Git-64-bit.exe"

:: Очистка лога
echo. > "%LOGFILE%"

:: Очищаем экран и выводим ASCII-арт
cls
echo ███╗   ██╗███████╗██╗  ██╗ ██████╗ ███╗   ██╗    ██████╗ ██████╗  ██████╗      ██╗███████╗ ██████╗████████╗
echo ████╗  ██║██╔════╝╚██╗██╔╝██╔═══██╗████╗  ██║    ██╔══██╗██╔══██╗██╔═══██╗     ██║██╔════╝██╔════╝╚══██╔══╝
echo ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║██╔██╗ ██║    ██████╔╝██████╔╝██║   ██║     ██║█████╗  ██║        ██║   
echo ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║██║╚██╗██║    ██╔═══╝ ██╔══██╗██║   ██║██   ██║██╔══╝  ██║        ██║   
echo ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝██║ ╚████║    ██║     ██║  ██║╚██████╔╝╚█████╔╝███████╗╚██████╗   ██║   
echo ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝  ╚════╝ ╚══════╝ ╚═════╝   ╚═╝   
echo ========================================================
echo          АВТОМАТИЧЕСКАЯ УСТАНОВКА МОДОВ В .minecraft                  
echo ========================================================
echo.

:: Проверяем, запущен ли Minecraft
echo [1/7] Проверка, запущен ли Minecraft...
tasklist | find /i "javaw.exe" >nul
if %errorlevel%==0 (
    echo Ошибка: Minecraft запущен! Закройте игру перед установкой модов.
    echo [%date% %time%] Ошибка: Minecraft был запущен во время установки! >> "%LOGFILE%"
    pause
    exit /b
)
echo [1/7] Minecraft не запущен. Продолжаем...
echo.

:: Проверяем подключение к интернету
echo [2/7] Проверка подключения к интернету...
ping -n 1 google.com >nul 2>&1
if %errorlevel% neq 0 (
    echo Ошибка: Интернет отсутствует! Проверьте подключение.
    echo [%date% %time%] Ошибка: Нет интернета! >> "%LOGFILE%"
    pause
    exit /b
)
echo [2/7] Интернет в порядке! Продолжаем...
echo.

:: Проверяем, установлен ли Git
echo [3/7] Проверка наличия Git...
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo Git не найден! Начинаю скачивание...
    echo [%date% %time%] Git не найден, скачивание... >> "%LOGFILE%"

    :: Скачиваем установщик Git
    powershell -Command "& {Invoke-WebRequest -Uri '%GIT_DOWNLOAD%' -OutFile '%GIT_INSTALLER%'}"
    if not exist "%GIT_INSTALLER%" (
        echo Ошибка: не удалось скачать Git!
        echo [%date% %time%] Ошибка: Сбой загрузки Git! >> "%LOGFILE%"
        pause
        exit /b
    )

    :: Устанавливаем Git в тихом режиме
    echo Установка Git...
    start /wait %GIT_INSTALLER% /SILENT
    if %errorlevel% neq 0 (
        echo Ошибка при установке Git!
        echo [%date% %time%] Ошибка установки Git! >> "%LOGFILE%"
        pause
        exit /b
    )

    :: Удаляем установщик
    del /Q "%GIT_INSTALLER%"
    
    :: Добавляем Git в переменные среды (только для текущей сессии)
    set "PATH=%ProgramFiles%\Git\bin;%PATH%"

    echo Git установлен успешно!
    echo [%date% %time%] Git установлен! >> "%LOGFILE%"
)
echo [3/7] Git установлен. Переходим к скачиванию модов...
echo.

:: Удаляем старую папку с репозиторием
echo [4/7] Очистка старых данных...
if exist "%CLONE_DIR%" rd /s /q "%CLONE_DIR%"
echo [4/7] Готово!
echo.

:: Очистка папки mods перед установкой (по желанию)
echo Очистить папку mods перед установкой новых модов? (Y/N)
set /p CLEAN_MODS=
if /I "%CLEAN_MODS%"=="Y" (
    echo Очистка папки mods...
    del /Q "%DESTINATION%\*.jar"
    echo Очистка завершена!
)
echo.

:: Клонирование репозитория
echo [5/7] Скачивание модов из GitHub...
git clone --depth=1 "%GIT_REPO%" "%CLONE_DIR%" >nul 2>&1
if %errorlevel% neq 0 (
    echo Ошибка при скачивании репозитория!
    echo [%date% %time%] Ошибка: Репозиторий не скачан! >> "%LOGFILE%"
    pause
    exit /b
)
echo [5/7] Моды скачаны успешно!
echo.

:: Копирование модов в .minecraft
echo [6/7] Копирование модов...
xcopy /Y /E "%CLONE_DIR%\QuarionMods\mods\*" "%DESTINATION%" >nul
echo [6/7] Моды установлены!
echo.

:: Улучшенный список установленных модов
echo ========================================================
echo Установлены следующие моды:
for %%F in ("%DESTINATION%\*.jar") do echo - %%~nF.jar
echo ========================================================

:: Записываем список модов в лог
echo [%date% %time%] Установлены моды: >> "%LOGFILE%"
for %%F in ("%DESTINATION%\*.jar") do echo - %%~nF.jar >> "%LOGFILE%"
echo ======================================================== >> "%LOGFILE%"

:: Удаляем папку с клонированным репозиторием
rd /s /q "%CLONE_DIR%"

:: Завершающее сообщение
echo ========================================================
echo Операция завершена успешно!
echo Моды скачаны из GitHub и установлены в .minecraft\mods.
echo ========================================================

:: Записываем в лог успешное завершение
echo [%date% %time%] Операция завершена успешно. >> "%LOGFILE%"

:: Остановка перед закрытием
pause
