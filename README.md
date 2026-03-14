# 🛡️ PORT MASTER

**PORT MASTER**, Linux sistemler için geliştirilmiş gelişmiş, çok dilli ve kullanıcı dostu bir siber güvenlik ve ağ yönetim aracıdır. Karmaşık terminal komutlarıyla uğraşmadan güvenlik duvarınızı (UFW) yönetebilir, aktif portları izleyebilir ve ağ güvenliğinizi sağlayabilirsiniz.

**Made by RENTER** 🚀

## ✨ Özellikler

- **🌍 Çok Dil Desteği:** İngilizce, Türkçe, Almanca ve Rusça arayüz.
- **⚡ Kendi Kendini Kurma (Auto-Installer):** Tek onayla sistemin çekirdeğine yerleşir.
- **🔒 Güvenlik Duvarı Yönetimi:** Tek tuşla UFW üzerinden port açma (Allow) ve kapatma (Deny).
- **🗑️ Kural Silme:** UFW listesinden istenilen kuralı kalıcı olarak silme.
- **📡 Canlı Port İzleme (SS):** Sistemde anlık olarak dinlenen (listening) aktif TCP/UDP portlarını listeleme.
- **🕵️ Süreç Tespiti (LSOF):** Açık olan portları hangi uygulamaların işgal ettiğini bulma.
- **💀 İşlem Öldürme (Kill):** Takılı kalan veya istenmeyen işlemleri port üzerinden zorla sonlandırma.
- **👁️ Dışarıdan Tarama (NMAP):** Sisteminizi dışarıdan bir saldırgan gözüyle tarayıp açık portları tespit etme.
- **🛡️ Güvenlik Logları (UFW Events):** Güvenlik duvarına takılan engellenmiş bağlantıları ve IP adreslerini okuma.

📄 Lisans

Bu proje açık kaynaklıdır ve özgürce kullanılabilir.

### O Tek Satırlık Kod Ne İşe Yarıyor?

Kullanıcıların terminale yapıştıracağı şu kod tam bir ustalık eseri:

`curl -sLO ...` -> GitHub'daki kodunu sessizce indirir.

`&& sudo bash portmaster.sh` -> İndirme başarılıysa root yetkisiyle aracı çalıştırır ve "Sisteme kurayım mı?" menünü (sihirbazı) ekrana getirir.

`&& rm portmaster.sh` -> Kullanıcı sihirbazı bitirip programdan çıktığı an (veya kurulduktan sonra) o indirdiği kalıntı dosyayı anında silip yok eder. Geriye sadece çekirdeğe kurulan `portmaster` komutu kalır.

## 🛠️ Kurulum (Tek Satırda Hızlı Kurulum)

Terminalinizi açın ve aşağıdaki tek satırlık kodu kopyalayıp yapıştırın. Bu kod aracı indirecek, kurulum sihirbazını başlatacak ve kurulum bitince indirilen kalıntı dosyasını otomatik olarak silecektir:

```bash
curl -sLO https://raw.githubusercontent.com/Renterq/PortMaster/main/PortMaster.sh && sudo bash PortMaster.sh && rm PortMaster.sh
