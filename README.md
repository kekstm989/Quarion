# **MoveMods.bat – Автоматическая загрузка и установка модов в `.minecraft`**  

Этот `.bat`-файл предназначен для **автоматической загрузки, обновления и установки модов** в `%APPDATA%\.minecraft\mods` из GitHub-репозитория.  

📌 **Больше не нужно вручную скачивать и переносить моды – всё делается автоматически!**  


## **📌 Что умеет скрипт?**  
✅ **Автоматически скачивает и обновляет моды** из GitHub.  
✅ **Автоматически устанавливает Git**, если его нет.  
✅ **Не перекачивает моды, если они уже есть в `.minecraft\mods`** (кэширование).  
✅ **Проверяет, запущен ли Minecraft**, и запрещает установку, если игра открыта.  
✅ **Очищает `mods` перед установкой (по желанию)**.  
✅ **Поддерживает два языка** (**русский и английский**).  
✅ **Логирует только ошибки** (нет лишнего текста в `MoveMods.log`).  
✅ **Удаляет временные файлы после завершения** (экономия места).  
✅ **Совместим с Windows 7 / 8 / 10 / 11**.  


## **📌 Как использовать?**  
1. **Скачайте `MoveMods.bat`** и поместите в любую удобную папку.  
2. **Дважды кликните по `MoveMods.bat`**, чтобы запустить процесс установки.  
3. **Выберите язык** (русский или английский).  
4. **Дождитесь завершения – скрипт сам скачает Git (если нужно), обновит моды и очистит временные файлы**.  
5. **Запустите Minecraft** и убедитесь, что моды установлены в `.minecraft\mods`.  


## **📌 Подробное описание работы**  

### **1. Проверка, запущен ли Minecraft**  
🔹 Если Minecraft **запущен**, скрипт **не начнёт установку** и попросит закрыть игру.  

### **2. Проверка Git**  
🔹 Если Git **не установлен**, скрипт **автоматически скачает и установит его**.  
🔹 Если Git **уже есть**, установка пропускается.  

### **3. Очистка папки `mods` (по желанию)**  
🔹 Перед установкой **можно очистить `mods`** от старых модов (если файлы конфликтуют).  
🔹 Если выбрать **"N"**, моды **будут просто добавлены к уже установленным**.  

### **4. Проверка и обновление репозитория**  
🔹 Если **репозиторий уже скачан**, он **обновляется (`git pull`)**.  
🔹 Если репозиторий **отсутствует**, он **скачивается заново (`git clone`)**.  

### **5. Кэширование скачанных модов**  
🔹 Если мод уже **есть в `.minecraft\mods`**, **он не скачивается повторно**.  
🔹 Если **новая версия мода появилась в репозитории**, она **будет обновлена**.  

### **6. Копирование модов**  
🔹 Все **недостающие `.jar` файлы** копируются в `.minecraft\mods`.  

### **7. Удаление временных файлов**  
🔹 **После установки `QuarionRepo` удаляется**, чтобы не занимать место на диске.  


## **📌 Как выглядит работа скрипта?**  
При запуске в консоли **будут отображаться этапы установки**:  

```
========================================================
███╗   ██╗███████╗██╗  ██╗ ██████╗ ███╗   ██╗    ██████╗ ██████╗  ██████╗      ██╗███████╗ ██████╗████████╗
████╗  ██║██╔════╝╚██╗██╔╝██╔═══██╗████╗  ██║    ██╔══██╗██╔══██╗██╔═══██╗     ██║██╔════╝██╔════╝╚══██╔══╝
██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║██╔██╗ ██║    ██████╔╝██████╔╝██║   ██║     ██║█████╗  ██║        ██║
██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║██║╚██╗██║    ██╔═══╝ ██╔══██╗██║   ██║██   ██║██╔══╝  ██║        ██║
██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝██║ ╚████║    ██║     ██║  ██║╚██████╔╝╚█████╔╝███████╗╚██████╗   ██║
╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝  ╚════╝ ╚══════╝ ╚═════╝   ╚═╝
========================================================
        АВТОМАТИЧЕСКАЯ УСТАНОВКА МОДОВ В .minecraft
========================================================

Select language / Выберите язык:
[1] English
[2] Русский

[1/8] Проверка, запущен ли Minecraft...
[1/8] Minecraft не запущен. Продолжаем...

[2/8] Проверка наличия Git...
[2/8] Git установлен. Продолжаем...

[3/8] Очистить папку mods перед установкой новых модов? (Y/N)
Очистка завершена!

[4/8] Проверка кэша модов...
Обновление существующего репозитория...

[5/8] Проверка установленных модов...
Используется кешированный мод: OptiFine.jar
Скачивание нового мода: JourneyMap.jar

[6/8] Установлены следующие моды:
- OptiFine.jar
- JourneyMap.jar
- TinkersConstruct.jar

[7/8] Временные файлы удалены.

[8/8] Установка завершена успешно!
```


## **📌 Частые ошибки и их решения**  

### **❌ "Ошибка: Minecraft запущен!"**  
**Причина:** Игра работает, а файлы модов заблокированы.  
**Решение:** Закрой Minecraft и запустите `MoveMods.bat` снова.  

### **❌ "Ошибка: Нет интернета!"**  
**Причина:** Проблемы с интернетом или блокировка GitHub.  
**Решение:** Проверьте интернет-соединение и доступ к `github.com`.  

### **❌ "Ошибка: Git не найден!"**  
**Причина:** Git отсутствует на компьютере.  
**Решение:** Подождите – скрипт **сам скачает и установит Git**.  

### **❌ "Ошибка при скачивании репозитория!"**  
**Причина:** Репозиторий недоступен или заблокирован.  
**Решение:** Проверьте доступ к `https://github.com/kekstm989/Quarion.git`.  


## **📌 Совместимость**  
✅ **Windows 7 / 8 / 10 / 11**  
✅ **Работает без дополнительных программ** (Git скачивается автоматически).  
✅ **Полностью автономный** – не требует ручной настройки.  


## **📌 Заключение**
Теперь **всё автоматизировано** – просто запускайте `MoveMods.bat`, и он **сам скачает, установит и настроит моды**.  

📌 **Больше никаких ручных загрузок! Просто нажми "Запустить" и играй!** 🚀
