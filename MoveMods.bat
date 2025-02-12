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
echo          СКАЧИВАНИЕ И УСТАНОВКА МОДОВ В .minecraft                  
echo ========================================================

:: Проверяем подключение к интернету
ping -n 1 google.com >nul 2>&1
if %errorlevel% neq 0 (
    echo Ошибка: Интернет-соединение отсутствует!
    echo [%date% %time%] Ошибка: Нет доступа в интернет! >> "%LOGFILE%"
    pause
    exit /b
)

:: Проверяем, установлен ли Git
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo Git не найден! Начинаю установку...
    echo [%date% %time%] Git не найден. Начинаю установку. >> "%LOGFILE%"

    :: Скачиваем установщик Git
    echo Скачивание Git...
    powershell -Command "& {Invoke-WebRequest -Uri '%GIT_DOWNLOAD%' -OutFile '%GIT_INSTALLER%'}"

    if not exist "%GIT_INSTALLER%" (
        echo Ошибка: не удалось скачать Git!
        echo [%date% %time%] Ошибка: не удалось скачать Git! >> "%LOGFILE%"
        pause
        exit /b
    )

    :: Устанавливаем Git тихо (без окна установки)
    echo Установка Git...
    start /wait %GIT_INSTALLER% /SILENT

    if %errorlevel% neq 0 (
        echo Ошибка при установке Git!
        echo [%date% %time%] Ошибка при установке Git! >> "%LOGFILE%"
        pause
        exit /b
    )

    :: Удаляем установщик
    del /Q "%GIT_INSTALLER%"

    :: Добавляем Git в переменные среды (только для текущей сессии)
    set "PATH=%ProgramFiles%\Git\bin;%PATH%"

    echo Git успешно установлен!
    echo [%date% %time%] Git успешно установлен. >> "%LOGFILE%"
)

:: Удаляем старую папку с репозиторием, если она есть
if exist "%CLONE_DIR%" rd /s /q "%CLONE_DIR%"

:: Клонирование репозитория
echo Скачивание модов из GitHub...
git clone --depth=1 "%GIT_REPO%" "%CLONE_DIR%" >nul 2>&1
if %errorlevel% neq 0 (
    echo Ошибка при скачивании репозитория!
    echo [%date% %time%] Ошибка при скачивании репозитория! >> "%LOGFILE%"
    pause
    exit /b
)

:: Проверяем, скачались ли моды
if not exist "%CLONE_DIR%\QuarionMods\mods\*.jar" (
    echo Ошибка: файлы модов не найдены в репозитории!
    echo [%date% %time%] Ошибка: файлы модов не найдены! >> "%LOGFILE%"
    pause
    exit /b
)

:: Проверяем или создаем папку назначения
if not exist "%DESTINATION%" mkdir "%DESTINATION%"

:: Копирование модов в .minecraft
echo Копирование модов в .minecraft...
xcopy /Y /E "%CLONE_DIR%\QuarionMods\mods\*" "%DESTINATION%" >nul

:: Вывод списка модов
echo ========================================================
echo Установлены следующие моды:
dir /b "%DESTINATION%\*.jar"
echo ========================================================

:: Записываем список модов в лог
echo [%date% %time%] Установлены моды: >> "%LOGFILE%"
dir /b "%DESTINATION%\*.jar" >> "%LOGFILE%"
echo ======================================================== >> "%LOGFILE%"

:: Удаляем папку с клонированным репозиторием, чтобы не занимала место
rd /s /q "%CLONE_DIR%"

:: Проверяем результат копирования
if %errorlevel% neq 0 (
    echo Ошибка при копировании файлов!
    echo [%date% %time%] Ошибка при копировании файлов! >> "%LOGFILE%"
    pause
    exit /b
)

:: Вывод информации об успешном копировании
echo ========================================================
echo Операция завершена успешно!
echo Моды скачаны из GitHub и установлены в .minecraft\mods.
echo ========================================================

:: Записываем в лог успешное завершение
echo [%date% %time%] Операция завершена успешно. >> "%LOGFILE%"

:: Остановка перед закрытием
pause
