#!/bin/bash

# Renkler
G="\e[1;32m"
B="\e[1;34m"
C="\e[1;36m"
Y="\e[1;33m"
R="\e[1;31m"
W="\e[1;37m"
N="\e[0m"

# 
SCRIPT_PATH=$(realpath "$0")
INSTALL_DIR="/usr/local/bin"

# Eğer script zaten /usr/local/bin içinde değilse kurulum sorusu sor
if [[ "$SCRIPT_PATH" != "$INSTALL_DIR/portmaster" ]]; then
    clear
    echo -e "${C}===================================================${N}"
    echo -e "${W}         PORT MASTER KURULUM SİHİRBAZI             ${N}"
    echo -e "${C}===================================================${N}"
    echo -e "${Y}Bu aracı sisteme kalıcı olarak kurmak ister misiniz?${N}"
    echo -e "Kurulum sonrası terminalde sadece şu komutla başlatabilirsiniz:"
    echo -e "${G}- portmaster${N}"
    echo ""
    echo -e -n "${C}Sisteme kurulsun mu? (e/h): ${N}"
    read install_ans

    if [[ "$install_ans" == "e" || "$install_ans" == "E" ]]; then
        echo -e "${Y}[*] Kurulum yapılıyor, lütfen sudo şifrenizi girin...${N}"
        sudo cp "$SCRIPT_PATH" "$INSTALL_DIR/portmaster"
        sudo chmod +x "$INSTALL_DIR/portmaster"
        
        echo -e "${G}[+] Kurulum Başarılı!${N}"
        echo -e "${W}Artık bu dosyayı silebilirsiniz. Tool'u başlatmak için terminale ${G}portmaster${W} yazmanız yeterlidir.${N}"
        exit 0
    else
        echo -e "${Y}[-] Kurulum atlandı, geçici modda başlatılıyor...${N}"
        sleep 2
    fi
fi

# ==========================================
# ANA SİSTEM
# ==========================================

# Dil Değişkenleri
set_language() {
    case $1 in
        1|EN)
            L_M1="Open Port (Allow)"
            L_M2="Close Port (Deny)"
            L_M3="Delete Firewall Rule (Completely)"
            L_M4="List Active Ports (SS)"
            L_M5="Show Port Processes (LSOF)"
            L_M6="Kill Process on Port"
            L_M7="Nmap Scan (External View)"
            L_M8="Show UFW Rules List"
            L_M9="Security Event Logs (UFW)"
            L_M10="Change Language"
            L_M11="Exit"
            
            L_SEL="Select (1-11): "
            L_PORT="Port number: "
            L_PROTO="Protocol (tcp/udp, blank for both): "
            L_ENTER="Press Enter to continue..."
            
            L_OPENED="opened"
            L_CLOSED="closed"
            L_DEL_ASK="Enter rule NUMBER to DELETE (from list below): "
            L_DEL_OK="Rule deleted successfully."
            L_DEL_ERR="Rule number not found."
            
            L_SCAN="Scanning active ports..."
            L_PROC="Detecting processes..."
            L_RULES="UFW Rules List:"
            L_EXIT="Exiting... Goodbye! [Made by RENTER]"
            L_ERR="Invalid option!"
            L_KILL_ASK="Enter port to KILL process: "
            L_KILL_OK="Process killed on port"
            L_KILL_ERR="No process found on port"
            L_LOG_MSG="Fetching security logs (blocked connections)..."
            
            L_UFW_WARN="WARNING: UFW Firewall is INACTIVE!"
            L_UFW_ASK="Enable UFW safely (allows port 22/SSH)? (y/n): "
            L_UFW_OK="UFW enabled. SSH is safe."
            L_NMAP_ERR="Nmap is not installed."
            L_NMAP_ASK="Would you like to install it now? (y/n): "
            ;;
        2|TR)
            L_M1="Port Aç (İzin Ver)"
            L_M2="Port Kapat (Engelle)"
            L_M3="Firewall Kuralını Tamamen Sil"
            L_M4="Aktif Portları Listele (SS)"
            L_M5="Portları Kullanan Programlar (LSOF)"
            L_M6="Portu İşgal Edeni Öldür (Kill)"
            L_M7="Nmap Taraması (Dışarıdan)"
            L_M8="UFW Kurallarını Numaralı Listele"
            L_M9="Güvenlik Olay Günlükleri (UFW Logları)"
            L_M10="Dil Değiştir"
            L_M11="Çıkış"
            
            L_SEL="Seçiminiz (1-11): "
            L_PORT="Port numarası: "
            L_PROTO="Protokol (tcp/udp, ikisi için boş bırakın): "
            L_ENTER="Devam etmek için Enter'a basın..."
            
            L_OPENED="açıldı"
            L_CLOSED="kapatıldı"
            L_DEL_ASK="Tamamen SİLİNECEK kural NUMARASINI girin (aşağıdaki listeden): "
            L_DEL_OK="Kural başarıyla silindi."
            L_DEL_ERR="Kural numarası bulunamadı."
            
            L_SCAN="Aktif portlar taranıyor..."
            L_PROC="İşlemler tespit ediliyor..."
            L_RULES="UFW Kuralları Listesi:"
            L_EXIT="Çıkılıyor... Görüşürüz! [RENTER tarafından yapılmıştır]"
            L_ERR="Geçersiz seçenek!"
            L_KILL_ASK="Kapatılacak (KILL) işlemin port numarasını girin: "
            L_KILL_OK="Port üzerindeki işlem sonlandırıldı: "
            L_KILL_ERR="Bu portta çalışan işlem bulunamadı: "
            L_LOG_MSG="Güvenlik logları çekiliyor (engellenen bağlantılar)..."
            
            L_UFW_WARN="UYARI: UFW Güvenlik Duvarı KAPALI!"
            L_UFW_ASK="UFW güvenli bir şekilde aktifleştirilsin mi (22/SSH açılır)? (e/h): "
            L_UFW_OK="UFW aktifleştirildi. SSH güvende."
            L_NMAP_ERR="Nmap yüklü değil."
            L_NMAP_ASK="Şimdi kurmak ister misiniz? (e/h): "
            ;;
        3|DE)
            L_M1="Port öffnen (Erlauben)"
            L_M2="Port schließen (Verweigern)"
            L_M3="Firewall-Regel vollständig löschen"
            L_M4="Aktive Ports auflisten (SS)"
            L_M5="Port-Prozesse anzeigen (LSOF)"
            L_M6="Prozess auf Port beenden (Kill)"
            L_M7="Nmap-Scan (Externe Ansicht)"
            L_M8="UFW-Regelliste anzeigen"
            L_M9="Sicherheitsereignisprotokolle (UFW)"
            L_M10="Sprache ändern"
            L_M11="Beenden"
            
            L_SEL="Auswahl (1-11): "
            L_PORT="Portnummer: "
            L_PROTO="Protokoll (tcp/udp, leer für beide): "
            L_ENTER="Drücken Sie Enter, um fortzufahren..."
            
            L_OPENED="geöffnet"
            L_CLOSED="geschlossen"
            L_DEL_ASK="Geben Sie die RegelNUMMER zum LÖSCHEN ein (aus der Liste unten): "
            L_DEL_OK="Regel erfolgreich gelöscht."
            L_DEL_ERR="Regelnummer nicht gefunden."
            
            L_SCAN="Aktive Ports werden gescannt..."
            L_PROC="Prozesse werden erkannt..."
            L_RULES="UFW-Regelliste:"
            L_EXIT="Beenden... Auf Wiedersehen! [Erstellt von RENTER]"
            L_ERR="Ungültige Option!"
            L_KILL_ASK="Geben Sie den Port ein, um den Prozess zu BEENDEN: "
            L_KILL_OK="Prozess auf Port beendet: "
            L_KILL_ERR="Kein Prozess gefunden auf Port: "
            L_LOG_MSG="Sicherheitslogs werden abgerufen (blockierte Verbindungen)..."
            
            L_UFW_WARN="WARNUNG: UFW-Firewall ist INAKTIV!"
            L_UFW_ASK="UFW sicher aktivieren (erlaubt Port 22/SSH)? (j/n): "
            L_UFW_OK="UFW aktiviert. SSH ist sicher."
            L_NMAP_ERR="Nmap ist nicht installiert."
            L_NMAP_ASK="Möchten Sie es jetzt installieren? (j/n): "
            ;;
        4|RU)
            L_M1="Открыть порт (Разрешить)"
            L_M2="Закрыть порт (Запретить)"
            L_M3="Полностью удалить правило брандмауэра"
            L_M4="Список активных портов (SS)"
            L_M5="Процессы портов (LSOF)"
            L_M6="Завершить процесс порта (Kill)"
            L_M7="Сканирование Nmap"
            L_M8="Показать нумерованный список правил UFW"
            L_M9="Журналы событий безопасности (UFW)"
            L_M10="Изменить язык"
            L_M11="Выход"
            
            L_SEL="Выбор (1-11): "
            L_PORT="Номер порта: "
            L_PROTO="Протокол (tcp/udp, пусто для обоих): "
            L_ENTER="Нажмите Enter для продолжения..."
            
            L_OPENED="открыт"
            L_CLOSED="закрыт"
            L_DEL_ASK="Введите НОМЕР правила для УДАЛЕНИЯ (из списка ниже): "
            L_DEL_OK="Правило успешно удалено."
            L_DEL_ERR="Номер правила не найден."
            
            L_SCAN="Сканирование активных портов..."
            L_PROC="Обнаружение процессов..."
            L_RULES="Список правил UFW:"
            L_EXIT="Выход... До свидания! [Сделано RENTER]"
            L_ERR="Неверная опция!"
            L_KILL_ASK="Введите порт для ЗАВЕРШЕНИЯ процесса: "
            L_KILL_OK="Процесс убит на порту: "
            L_KILL_ERR="Процесс не найден на порту: "
            L_LOG_MSG="Получение журналов безопасности (заблокированные соединения)..."
            
            L_UFW_WARN="ВНИМАНИЕ: Брандмауэр UFW НЕАКТИВЕН!"
            L_UFW_ASK="Безопасно включить UFW (разрешить порт 22/SSH)? (y/n): "
            L_UFW_OK="UFW включен. SSH в безопасности."
            L_NMAP_ERR="Nmap не установлен."
            L_NMAP_ASK="Хотите установить его сейчас? (y/n): "
            ;;
    esac
}

# İlk açılışta dil seçimi
clear
echo -e "${C}=========================================${N}"
echo -e "${W}1) English  2) Türkçe  3) Deutsch  4) Русский${N}"
echo -e "${C}=========================================${N}"
echo -e -n "${Y}Select Language / Dil Seçimi: ${N}"
read lang_choice
set_language $lang_choice

# UFW Kontrolü
if sudo ufw status | grep -qi "inactive"; then
    clear
    echo -e "${R}[!] $L_UFW_WARN${N}"
    echo -e -n "${C}$L_UFW_ASK${N}"
    read ans
    if [[ "$ans" == "y" || "$ans" == "Y" || "$ans" == "e" || "$ans" == "E" || "$ans" == "j" || "$ans" == "J" ]]; then
        sudo ufw allow 22/tcp >/dev/null 2>&1
        echo "y" | sudo ufw enable >/dev/null 2>&1
        echo -e "${G}[+] $L_UFW_OK${N}"
        sleep 2
    fi
fi

# IP Paneli Verileri
LOCAL_IP=$(hostname -I | awk '{print $1}')
PUB_IP=$(curl -s --max-time 2 ifconfig.me || echo "Offline")

while true; do
    clear
    
    echo -e "${C}██████   ██████  ██████  ████████  ███    ███  █████  ███████ ████████ ███████ ██████  ${N}"
    echo -e "${C}██   ██ ██    ██ ██   ██    ██     ████  ████ ██   ██ ██         ██    ██      ██   ██ ${N}"
    echo -e "${C}██████  ██    ██ ██████     ██     ██ ████ ██ ███████ ███████    ██    █████   ██████  ${N}"
    echo -e "${C}██      ██    ██ ██   ██    ██     ██  ██  ██ ██   ██      ██    ██    ██      ██   ██ ${N}"
    echo -e "${C}██       ██████  ██   ██    ██     ██      ██ ██   ██ ███████    ██    ███████ ██   ██ ${N}"
    echo -e "${C}========================================================================================${N}"
    echo -e "${W}  🌐 Local IP: ${G}$LOCAL_IP${N}   ${W}🌍 Public IP: ${G}$PUB_IP${N}"
    echo -e "${C}========================================================================================${N}"
    
    echo -e "${Y}1)${N} ${W}$L_M1${N}"
    echo -e "${Y}2)${N} ${W}$L_M2${N}"
    echo -e "${Y}3)${N} ${R}$L_M3${N}" # Kırmızı silme kuralı
    echo -e "${Y}4)${N} ${W}$L_M4${N}"
    echo -e "${Y}5)${N} ${W}$L_M5${N}"
    echo -e "${Y}6)${N} ${R}$L_M6${N}" # Kırmızı işlem öldürme
    echo -e "${Y}7)${N} ${W}$L_M7${N}"
    echo -e "${Y}8)${N} ${W}$L_M8${N}"
    echo -e "${Y}9)${N} ${B}$L_M9${N}" # Mavi loglar
    echo -e "${Y}10)${N} ${W}$L_M10${N}"
    echo -e "${Y}11)${N} ${W}$L_M11${N}"
    echo -e "${C}========================================================================================${N}"
    
    echo -e -n "${W}$L_SEL${N}"
    read sel
    echo ""

    case $sel in
        1)
            echo -e -n "${W}$L_PORT${N}"
            read port
            echo -e -n "${Y}$L_PROTO${N}"
            read proto
            
            if [ -z "$proto" ]; then
                sudo ufw allow $port >/dev/null 2>&1
                echo -e "${G}[+] Port $port (TCP/UDP) $L_OPENED!${N}"
            else
                sudo ufw allow $port/$proto >/dev/null 2>&1
                echo -e "${G}[+] Port $port/$proto $L_OPENED!${N}"
            fi
            echo -e -n "${W}$L_ENTER${N}"; read dummy
            ;;
        2)
            echo -e -n "${W}$L_PORT${N}"
            read port
            echo -e -n "${Y}$L_PROTO${N}"
            read proto
            
            if [ -z "$proto" ]; then
                sudo ufw deny $port >/dev/null 2>&1
                echo -e "${R}[-] Port $port (TCP/UDP) $L_CLOSED!${N}"
            else
                sudo ufw deny $port/$proto >/dev/null 2>&1
                echo -e "${R}[-] Port $port/$proto $L_CLOSED!${N}"
            fi
            echo -e -n "${W}$L_ENTER${N}"; read dummy
            ;;
        3)
            # Tamamen Silme Seçeneği
            echo -e "${C}[*] $L_RULES${N}"
            echo -e "${C}-----------------------------------${N}"
            sudo ufw status numbered
            echo -e "${C}-----------------------------------${N}"
            echo -e -n "${R}$L_DEL_ASK${N}"
            read rule_num
            # UFW numaralı kuralı silme komutu
            sudo ufw delete $rule_num
            echo -e -n "${W}$L_ENTER${N}"; read dummy
            ;;
        4)
            echo -e "${C}[*] $L_SCAN${N}"
            echo -e "${C}-----------------------------------${N}"
            sudo ss -tunl | awk 'NR>1 {proto=$1; n=split($5,a,":"); port=a[n]; print proto, port}' | sort -u | while read p_proto p_port; do
                if [[ "$p_proto" == *"tcp"* ]]; then echo -e "${B}[TCP]${N} \t ${Y}➜  $p_port${N}"
                else echo -e "${G}[UDP]${N} \t ${Y}➜  $p_port${N}"; fi
            done
            echo -e "${C}-----------------------------------${N}"
            echo -e -n "${W}$L_ENTER${N}"; read dummy
            ;;
        5)
            echo -e "${C}[*] $L_PROC${N}"
            echo -e "${C}--------------------------------------------------${N}"
            sudo lsof -i -P -n | grep LISTEN | awk '{print $1, $2, $9}' | while read prog pid port; do
                echo -e "${G}$prog${N} \t ${W}$pid${N} \t ${Y}➜ $port${N}"
            done
            echo -e "${C}--------------------------------------------------${N}"
            echo -e -n "${W}$L_ENTER${N}"; read dummy
            ;;
        6)
            echo -e -n "${R}$L_KILL_ASK${N}"
            read kill_port
            pid=$(sudo lsof -t -i:$kill_port)
            if [ -z "$pid" ]; then
                echo -e "${Y}[!] $L_KILL_ERR $kill_port${N}"
            else
                sudo kill -9 $pid
                echo -e "${G}[+] $L_KILL_OK $kill_port (PID: $pid)${N}"
            fi
            echo -e -n "${W}$L_ENTER${N}"; read dummy
            ;;
        7)
            if ! command -v nmap &> /dev/null; then
                echo -e "${R}[!] $L_NMAP_ERR${N}"
                echo -e -n "${Y}$L_NMAP_ASK${N}"
                read inst
                if [[ "$inst" == "y" || "$inst" == "Y" || "$inst" == "e" || "$inst" == "E" || "$inst" == "j" || "$inst" == "J" ]]; then
                    echo -e "${C}[*] Nmap...${N}"
                    if command -v pacman &> /dev/null; then sudo pacman -S nmap --noconfirm
                    elif command -v apt &> /dev/null; then sudo apt update && sudo apt install nmap -y
                    else sleep 2; continue; fi
                else continue; fi
            fi
            
            echo -e "${R}[*] Nmap localhost...${N}"
            echo -e "${C}-----------------------------------${N}"
            nmap localhost | grep -E "^[0-9]" | while read port state service; do
                echo -e "${Y}$port${N} \t ${R}$state${N} \t ${W}$service${N}"
            done
            echo -e "${C}-----------------------------------${N}"
            echo -e -n "${W}$L_ENTER${N}"; read dummy
            ;;
        8)
            echo -e "${C}[*] $L_RULES${N}"
            echo -e "${C}-----------------------------------${N}"
            sudo ufw status numbered
            echo -e "${C}-----------------------------------${N}"
            echo -e -n "${W}$L_ENTER${N}"; read dummy
            ;;
        9)
            # Güvenlik Günlükleri (Loglar)
            echo -e "${B}[*] $L_LOG_MSG${N}"
            echo -e "${C}--------------------------------------------------${N}"
            # Log dosyası varsa oradan çeker, yoksa journalctl dener, en son dmesg dener.
            if [ -f /var/log/ufw.log ]; then
                sudo tail -n 10 /var/log/ufw.log | grep '[UFW BLOCK]' | awk '{print $1, $2, $3, $11, $12}' || echo -e "${Y}Log bulunamadı.${N}"
            elif command -v journalctl &> /dev/null; then
                sudo journalctl -u ufw | tail -n 10 | grep 'BLOCK' | awk '{print $1, $2, $3, $10, $11}' || echo -e "${Y}Log bulunamadı.${N}"
            else
                sudo dmesg | grep '\[UFW BLOCK\]' | tail -n 10 | awk '{print $4, $5, $6, $10, $11}' || echo -e "${Y}Log bulunamadı veya yetki yok.${N}"
            fi
            echo -e "${C}--------------------------------------------------${N}"
            echo -e -n "${W}$L_ENTER${N}"; read dummy
            ;;
        10)
            clear
            echo -e "${C}=========================================${N}"
            echo -e "${W}1) English  2) Türkçe  3) Deutsch  4) Русский${N}"
            echo -e "${C}=========================================${N}"
            echo -e -n "${Y}Select Language / Dil Seçimi: ${N}"
            read lang_choice
            set_language $lang_choice
            ;;
        11)
            # Marka İmzalı Çıkış
            echo -e "${G}$L_EXIT${N}"
            exit 0
            ;;
        *)
            echo -e "${R}[!] $L_ERR${N}"
            sleep 1
            ;;
    esac
done
