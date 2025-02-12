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

:: Очистка лога (только ошибки будут записываться)
echo. > "%LOGFILE%"

:: Выбор языка
cls
echo ========================================================
echo Select language / Выберите язык:
echo [1] English
echo [2] Русский
set /p LANG=

if "%LANG%"=="1" (
    set "MSG_START=Starting installation..."
    set "MSG_MC_RUNNING=Minecraft is running! Please close the game before installing mods."
    set "MSG_DONE=Operation completed successfully!"
    set "MSG_CACHE=Using cached mod:"
    set "MSG_DOWNLOAD=Downloading new mod:"
    set "MSG_CLONING=Cloning repository..."
) else (
    set "MSG_START=Запуск установки..."
    set "MSG_MC_RUNNING=Minecraft запущен! Закройте игру перед установкой модов."
    set "MSG_DONE=Операция завершена успешно!"
    set "MSG_CACHE=Используется кешированный мод:"
    set "MSG_DOWNLOAD=Скачивание нового мода:"
    set "MSG_CLONING=Клонирование репозитория..."
)

echo ========================================================
echo %MSG_START%
echo ========================================================

:: Проверяем, запущен ли Minecraft
echo [1/6] Проверка, запущен ли Minecraft...
tasklist | find /i "javaw.exe" >nul
if %errorlevel%==0 (
    echo Ошибка: %MSG_MC_RUNNING%
    echo [%date% %time%] Ошибка: Minecraft был запущен во время установки! >> "%LOGFILE%"
    pause
    exit /b
)
echo [1/6] Minecraft не запущен. Продолжаем...
echo.

:: Проверяем подключение к интернету
echo [2/6] Проверка подключения к интернету...
ping -n 1 google.com >nul 2>&1
if %errorlevel% neq 0 (
    echo Ошибка: Интернет отсутствует! Проверьте подключение.
    echo [%date% %time%] Ошибка: Нет интернета! >> "%LOGFILE%"
    pause
    exit /b
)
echo [2/6] Интернет в порядке! Продолжаем...
echo.

:: Проверяем, установлен ли Git
echo [3/6] Проверка наличия Git...
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo Git не найден! Начинаю скачивание...
    echo [%date% %time%] Ошибка: Git не найден! >> "%LOGFILE%"

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
        echo [%date% %time%] Ошибка: Git не установлен! >> "%LOGFILE%"
        pause
        exit /b
    )

    :: Удаляем установщик
    del /Q "%GIT_INSTALLER%"
    
    :: Добавляем Git в переменные среды (только для текущей сессии)
    set "PATH=%ProgramFiles%\Git\bin;%PATH%"

    echo Git установлен успешно!
)
echo [3/6] Git установлен. Переходим к скачиванию модов...
echo.

:: Проверяем, нужно ли клонировать репозиторий (если есть, просто обновляем)
if exist "%CLONE_DIR%" (
    echo Обновление существующего репозитория...
    cd "%CLONE_DIR%" && git pull >nul 2>&1
) else (
    echo %MSG_CLONING%
    git clone --depth=1 "%GIT_REPO%" "%CLONE_DIR%" >nul 2>&1
)

if %errorlevel% neq 0 (
    echo Ошибка при скачивании репозитория!
    echo [%date% %time%] Ошибка: Репозиторий не скачан! >> "%LOGFILE%"
    pause
    exit /b
)
echo [4/6] Моды скачаны успешно!
echo.

:: Проверяем и скачиваем только отсутствующие моды
echo [5/6] Проверка кеша модов...
for %%F in ("%CLONE_DIR%\QuarionMods\mods\*.jar") do (
    if exist "%DESTINATION%\%%~nxF" (
        echo %MSG_CACHE% %%~nxF
    ) else (
        echo %MSG_DOWNLOAD% %%~nxF
        xcopy /Y "%%F" "%DESTINATION%" >nul
    )
)
echo.

:: Улучшенный список установленных модов
echo ========================================================
echo Установлены следующие моды:
for %%F in ("%DESTINATION%\*.jar") do echo - %%~nF.jar
echo ========================================================

:: Удаляем папку с клонированным репозиторием
rd /s /q "%CLONE_DIR%"

:: Завершающее сообщение
echo ========================================================
echo %MSG_DONE%
echo ========================================================

:: Записываем ошибки в лог, если были
if %errorlevel% neq 0 (
    echo [%date% %time%] Ошибка при установке модов! >> "%LOGFILE%"
)

:: Остановка перед закрытием
pause
