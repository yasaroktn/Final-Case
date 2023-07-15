# Final-Case

# FINALEX Programı

## Kullanım Talimatları
Bu programın çalışabilmesi için bir COBOL derleyicisine ve çalıştırma ortamına ihtiyaç vardır.

Programın kullanacağı giriş ve çıkış dosyaları tanımlanmalıdır. Giriş dosyası (INP-FILE) ve çıkış dosyası (OUT-FILE) için FILE-CONTROL bölümünde SELECT ifadeleri kullanılır. Dosya yolları bu ifadelerde belirtilmelidir.

Program, çıkış dosyasına başlık bilgileri yazdırmak için HEADER-1, HEADER-2 ve HEADER-3 veri alanlarını kullanır. Bu veri alanları, başlık bilgilerini içeren sabit metinleri içerir.

Programın çalışma işlemleri PROCEDURE DIVISION bölümünde tanımlanmıştır. Ana işlem, 0000-MAIN etiketiyle başlar. İşlem adımları şunlardır:

**H100-OPEN-FILES**: INPUT ve OUTPUT dosyalarını açar.
**H110-OPEN-CONTROL**: INPUT ve OUTPUT dosyalarının açılıp açılmadığını kontrol eder.
**H200-WRITE-HEADERS**: Başlık bilgilerini çıkış dosyasına yazar.
**H300-READ-CONTROL-MOVE**: İlk olarak, INPUT dosyası okunurken bir hatayla karşılaşıldımı diye kontrol etmek için INP-ST değişkeni kullanılır. Eğer INP-ST 0 veya 97 değilse, yani dosya açılamadıysa, hata mesajı gösterilir, RETURN-CODE değişkenine INP-ST değeri atanır ve programın sonlandırılması için H999-PROGRAM-EXIT çağrılır.
Kontrol verilerini taşıyan INPUT dosyasının her bir kaydı okunur. PROCESS-TYPE alanı WS-SUB-FUNC değişkenine, INP-ID alanı WS-SUB-ID değişkenine, ve INP-CURR alanı WS-SUB-CURR değişkenine atanır.
Çıkış kaydı için kullanılan OUT-REC veri alanı temizlenir (SPACES ile doldurulur).
WS-SUB-AREA çağrılırken kontrol verileri bu alanlara aktarılır.
WS-PBEGIDX işlevi, WS-SUB-AREA parametresini kullanarak VSAM dosyası işlemlerini gerçekleştirir.
WS-SUB-FUNC değeri OREC-PROCESS-TYPE alanına, WS-SUB-ID değeri OUT-ID-O alanına, WS-SUB-CURR değeri OUT-CURR-O alanına, ve WS-SUB-RC değeri OUT-RC-O alanına atanır.
İşlem sonucunu içeren açıklama ve diğer ilgili veriler, WS-SUB-DATA alanına atanır.
OUT-REC kaydı çıkış dosyasına yazılır.
Bir sonraki giriş kaydı okunur ve işlem devam eder.
**H999-PROGRAM-EXIT**: "CLOSE INP-FILE" ifadesi ile INPUT dosyamız kapatılır."CLOSE OUT-FILE" ifadesi ile OUTPUT dosyamız kapatılır."SET WS-FUNC-CLOSE" TO TRUE ifadesi, "WS-FUNC-CLOSE" değişkenine TRUE değerini atar. Bu değişken, "WS-FUNC" değişkeninin "CLOSE" işlemine yönlendirildiğini belirtir."CALL WS-PBEGIDX USING WS-SUB-AREA" ifadesi ile "WS-PBEGIDX" alt programını çağırarak dosyanın dizinini günceller. "WS-SUB-AREA" değişkeni, alt programa gerekli parametreleri ileten bir parametre alanıdır. Bu adım, dosyanın güncel durumunu dizine kaydeder."STOP RUN" ifadesi ise programın sonlandırılmasını sağlar.

# PBEGIDX Programı

## Kullanım Talimatları
1. Bu programı çalıştırmak için bir COBOL derleyicisine ve çalıştırma ortamına ihtiyaç duyulmaktadır.

2. Programın ana bölümü, PROCEDURE DIVISION USING LS-SUB-AREA ile başlar ve PBEGIDX.CBL dosyasında bulunur.

3. Programın çalışması için IDX-FILE adlı bir VSAM dosyaya ihtiyaç vardır. Dosya, FILE SECTION bölümünde tanımlanmalı ve dosya yoluna göre ayarlanmalıdır.

4. Programı çağırmak için LS-SUB-AREA isimli bir veri alanı kullanılmalıdır. Bu veri alanı, alt programın işlem yapması için gerekli parametreleri içerir.

5. Alt programın çalışma işlemleri PROCEDURE DIVISION bölümünde tanımlanmıştır.

Alt Programın İşlemleri
**WS-FUNC-OPEN**: Bu işlem, VSAM dosyasını açar. Dosya, SELECT ifadesiyle belirtilen dosya tanımına göre açılır.Dosya açma işlemi, OPEN I-O ifadesi kullanılarak gerçekleştirilir. Bu işlem, dosyanın okuma ve yazma işlemlerine hazır hale getirilmesini sağlar.
**WS-FUNC-WRITE**: Bu işlem, VSAM dosyasına yeni bir kayıt yazmak için kullanılır. Dosyaya yazma işlemi, WRITE ifadesiyle gerçekleştirilir. İşlem öncesi, yeni kayıt verileri ilgili alanlara atanır ve ardından WRITE ifadesiyle kayıt dosyaya yazılır.
**WS-FUNC-UPDATE**: Bu işlem, var olan bir kaydı güncellemek için VSAM dosyasını kullanır. Güncelleme işlemi, REWRITE ifadesiyle gerçekleştirilir. İlgili kayıt önce okunur, ardından güncellenen veriler ilgili alanlara atanır ve REWRITE ifadesiyle kayıt dosyaya geri yazılır.
**WS-FUNC-DELETE**: Bu işlem, var olan bir kaydı silmek için VSAM dosyasını kullanır. Kayıt silme işlemi, DELETE ifadesiyle gerçekleştirilir. İlgili kayıt, DELETE ifadesiyle doğrudan dosyadan silinir.Bu işlem sonrasında dosyanın fiziksel boyutu da dinamik olarak küçültülebilir.
**WS-FUNC-READ**: Bu işlem, VSAM dosyasından bir kaydı okur. Okuma işlemi, READ ifadesiyle gerçekleştirilir. İlgili kayıt, READ ifadesiyle dosyadan okunur ve ilgili alanlara atanır. Bu işlem, dosyayı sırasıyla okuyarak kayıtları işlemek için kullanılır.
**WS-FUNC-CLOSE**: Bu işlem, VSAM dosyasını kapatır. Dosya kapatma işlemi, CLOSE ifadesiyle gerçekleştirilir. Dosya kapatıldıktan sonra, dosyaya erişim sonlanır.