                     ; multi-segment executable file template.

data segment
    ; add your data here!
    pkey db "press any key...$" 
    
    
    birler   db  "bir$","iki$","uc$","dort$","bes$","alti$","yedi$","sekiz$","dokuz$"
    onlar    db  "on$","yirmi$","otuz$","kirk$","elli$","altmis$","yetmis$","seksen$","doksan$"
    yuzler   db  "yuz$","iki yuz$","uc yuz$","dort yuz$","bes yuz$","alti yuz$","yedi yuz$","sekiz yuz$","dokuz yuz$" 
    buyukler db  "trilyon$","milyar$","milyon$","bin$"       
    yuz db "yuz$"   
    bin db "bin$"
    milyon db "milyon$"
    milyar db "milyar$"
    trilyon db "trilyon$" 
    string db "emrullah$" 
    string1 db "durumlu$"
    girilenSayi db ?
    girilenSayiUzunluk db ?
    kalanUzunluk db ?      
    
    onlarFlag db 0
    yuzlerFlag db 0
    binlerFlag db 0
    milyonFlag db 0
    milyarFlag db 0
    trilyonFlag db 0  
    onlarYok db 1 
    
    imlecYeri dw ?
    
    sayi1 db 15 dup('0')
    sayi2 db 15 dup('0') 
    degisken db 15 dup(?)
ends          



stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax
    

    
    
    
      jmp go     
      
      degerleriSifirla proc
        mov si,offset girilenSayi
        add si,dx  
        ret
        
      degerleriSifirla endp  
      
    basamagaAta proc      
            cmp yuzlerFlag,1       ; burada yüzler flaginin basta yazilmasinin degeri eger yüzler flagi bu basamaklarin hepsinin içinde var yani dolayisiyla diyelimki binli bir sayidayiz ve burada bin kelimesini program yüzden önce görecek 
            jz _ikiyuz            ; ve haliyle imleci ona göre ayarliyacak bizim yüzler flagimizin 1 olmasi demekki yüzler basamagina(bulundugu konumun yüzler basamagi) bir sayi gelicek  (örn:iki yüz : önce yüz görülcek ve yüzler flagi bir olucak yüzler flagi 1 olunca mevcut konumda imlec kalicak ve ikini rakam degeri o konuma yazilacak )
            cmp trilyonFlag,1   ;imleci trilyonlarin oldugu 3 lü gruba ayralamk için kullanildi    
            jz _ikiTrilyon
            cmp milyarFlag,1    ; imleci milyarlarin oldugu 3 lü gruba ayarlamak için kullanildi
            jz _ikiMilyar
            cmp milyonFlag,1    ; imleci milyonlarin oldugu 3 lü gruba ayarlamak için kullanildi
            jz _ikiMilyon
            cmp binlerFlag,1    ; imleci binlerin oldugu 3 lü gruba ayarlamak için kullanildi
            jz _ikibin
             
            
            _ikiyuz:
             mov yuzlerFlag,0
             jmp _ikiBitti   
            _ikibin:  
            mov bx,offset sayi1 
            add bx,14
            sub bx,3  
            mov binlerFlag,0
            jmp _ikiBitti 
            _ikiMilyon:
            mov bx,offset sayi1 
             add bx,14 
            sub bx,6        
            mov milyonFlag,0
            jmp _ikiBitti
            _ikiMilyar:
            mov bx,offset sayi1 
             add bx,14
            sub bx,9        
            mov milyarFlag,0
            jmp _ikiBitti
            
            _ikiTrilyon: 
            mov bx,offset sayi1 
            add bx,14
            sub bx,12       
            mov trilyonFlag,0
            jmp _ikiBitti
            
           
            _ikiBitti:   
            mov [bx],al       ;islemin son adimi basamk degerini sayiya at bu fonksiyonu çagiriken degisken degeri tutmak için kullandigimiz al nin degerini mevcut konuma kaydet
            mov imlecYeri ,bx ; ve imlecin konumunu kayit et ...
            
        
        
        ret
    basamagaAta endp    
    
       go:
          
          
      mov di,offset girilenSayi    
    yaziSayiCevir  proc    
        
        
        
        
           mov bx,0
           mov cx,0 ; kelime adedini tutmak i\E7in 
           mov bx,0 ; kelimelerin baslangi\E7 adreslerini tespit etmek i\E7in  
           push bx 
           degerAlYazi:
                mov ah,01
                int 21h   
                
                cmp al,13      ; enter (\n okuma bitti)
                jz _girisBitti
                
                cmp al,32  ; space karakterine g\F6re kelimelerin baslangic adresini tespit ediyoruz burda
                jz _spaceKarakteri
                
                mov [di],al
                inc di    ; dinin g\F6sterdigi adresi bir arttir /(bir sonraki adresi g\F6ster)
                inc bx   ; karakterleri sayar   (space den sonraki karakter de bir sonraki kelimenin baslangicidir)
                 jmp _spaceGirme
                _spaceKarakteri:
                mov [di],al      ; spaci i de degiskene ekle
                inc di           ; di g\F6sterdigi adresi bir arttir
                inc bx           ; 
                push bx          ;yeni kelimeninin baslangicinin tutuldugu degiskenin ilk adresinden ne kadar uzak ?
                inc cx ; toplam kelime adedini g\FCncelle  
                
                
                _spaceGirme:
                
           jmp degerAlYazi
              
               _girisBitti:
               inc cx 
                 
               
        
        
        
        
        
        
        
      
       mov bx,offset sayi1 ; yazinin sayiya dönüstükten sonra tutulacagi degiskenin baslangiç adresi
       add bx,14  ; baslangiç adresine 14 ekleyerek sayinin birler basamagi konumuna ulastim (Çünkü fonksiyon 1 ler basamagindan dönüstürerek üst basamaklara dogru gidiyor) 
       mov si,offset girilenSayi ; yazi olarak alinan sayinin baslangiçç adresi 
              
       cevirmeBasla:
          mov kalanUzunluk,cl
          pop dx  ; Kullanicidan yaziyi alirken her kelimeden sonraki bosluk karakterini stack a attik böylelikle her kelimenin baslangiç adresine ulasabilecegiz. Burdada stacktan kelimelerin baslangiç adresini çekiyoruz. 
          add si,dx ; yazinin tutuldugu degiskenin adresini tutan diziye kelimenin baslangicini veriyoruz  
          mov di,offset birler ; birler basamagi dizisinin baslangiç adresi  
          mov imlecYeri,bx ; bu degisken sayinin basamklarina göre indekslenmesi için kullanilmaktadir
          
          mov cx,3  ; bir yazisinin uzunlugu uzunulugu
          repe cmpsb  ; di nin içindeki degerle si nin içindeki degeri karsilastiriyoruz 
          jz _bir      ; eger esitse bu sartli dallanma komutuyla ilgili yere dallanip islemlere baslanilacak.
          
          mov di,offset birler ; bu tanimlamayi yeniden yapmamin sebebi repe komutu çalisir iken di ve si nin indekslerinde kayma oluyor . Bunun önüne geçmek için bu komutla yeniden diziyi baslangiç adresine çekiyoruz.
          call degerleriSifirla ;Bu fonksiyonda girilen sayinin tutuldugu degiskeni baslangiç konumuna çekmek için kullanilmistir.(bir üst satirda bahsettigim sorun nedeniyle)
          mov cx,2 ; iki sayisinin uzunlugunu belirtiyor repe komutu için (aslinda 2 nin uzunlugu 3 harf ama programi yazarken 3 harf yapinca bir sorunla karsilastim karsilastirilan kelimeler tamamaen ayni olmasina ragmen sartli dallanmaya giris yapamiyordu fonksiyon bende bunu bu sekilde denedim ve oldu. "ik" de karsilastirdigim kelimeler arasinda essiz oldugu için bu sekilde birakip fazla üstüne gitmedim)  
          add di,4  ; birler dizisinde ikinin tutuldugu yerin baslangici ....
          repe cmpsb
          jz _iki     
          
          mov di,offset birler 
          call degerleriSifirla
          mov cx,2
          add di,8      ; birler dizisinde uc un tutuldugu yerin baslangici
          repe cmpsb
          jz _uc
                               
          mov di,offset birler                      
          call degerleriSifirla
          mov cx,4
          add di,11   ;  birler dizisinde dort un tutuldugu yerin baslangici
          repe cmpsb
          jz _dort
                               
          mov di,offset birler                      
          call degerleriSifirla
          mov cx,3
          add di,16      ; birler dizisinde bes un tutuldugu yerin baslangici
          repe cmpsb
          jz _bes
                               
          mov di,offset birler                      
          call degerleriSifirla
          mov cx,4
          add di,20      ; birler dizisinde alti un tutuldugu yerin baslangici
          repe cmpsb
          jz _alti
                               
          mov di,offset birler                      
          call degerleriSifirla
          mov cx,4
          add di,25    ; birler dizisinde yedi un tutuldugu yerin baslangici
          repe cmpsb
          jz _yedi
                               
          mov di,offset birler                      
          call degerleriSifirla
          mov cx,5
          add di,30   ; birler dizisinde sekiz un tutuldugu yerin baslangici
          repe cmpsb
          jz _sekiz
                               
          mov di,offset birler                      
          call degerleriSifirla
          mov cx,5
          add di,36   ; birler dizisinde dokuz un tutuldugu yerin baslangici
          repe cmpsb
          jz _dokuz
             
                        ; birler basamaginda 0 i kontorl etmememin sebebi zaten sayiyi tutacagim degiskenin tüm karakterlerine 0 atamiss olmamdan dolayidir . Böylece bunlardan herhangi birine dallanmazsa o basamagin degerinin sifir oldugunu anliyoruz.
          mov di,offset onlar
          call degerleriSifirla
          mov cx,2
          repe cmpsb
          jz _on
          
          call degerleriSifirla
          mov di,offset onlar
          mov cx,5
          add di,3  ;onlar dizinde yirminin tutuldugu yerin baslangici
          repe cmpsb
          jz _yirmi
          
          call degerleriSifirla
          mov di,offset onlar          
          mov cx,4
          add di,9   ;onlar dizinde otuz tutuldugu yerin baslangici
          repe cmpsb
          jz _otuz
          
          call degerleriSifirla
          mov di,offset onlar
          mov cx,4
          add di,14  ;onlar dizinde kirk tutuldugu yerin baslangici
          repe cmpsb
          jz _kirk
          
          call degerleriSifirla
          mov di,offset onlar  
          call degerleriSifirla
          mov cx,4
          add di,19    ;onlar dizinde elli tutuldugu yerin baslangici
          repe cmpsb
          jz _elli
          
          call degerleriSifirla                  
          mov di,offset onlar                  
          mov cx,6
          add di,24    ;onlar dizinde altmis tutuldugu yerin baslangici
          repe cmpsb
          jz _altmis
          
          call degerleriSifirla
          mov di,offset onlar
          mov cx,6
          add di,31   ;onlar dizinde yetmis tutuldugu yerin baslangici
          repe cmpsb
          jz _yetmis
          
          call degerleriSifirla
          mov di,offset onlar
          mov cx,6
          add di,38     ;onlar dizinde seksen tutuldugu yerin baslangici
          repe cmpsb
          jz _seksen
                              
          call degerleriSifirla                    
          mov di,offset onlar
          mov cx,6
          add di,45   ;onlar dizinde doksan tutuldugu yerin baslangici
          repe cmpsb
          jz _doksan        
                  
          
          call degerleriSifirla        
          lea di,yuz        
          mov cx,3  
          repe cmpsb
          jz _yuz 
          
          call degerleriSifirla
          lea di,bin
          mov cx,3
          repe cmpsb
          jz _bin
                               
          call degerleriSifirla                     
          lea di,milyon
          mov cx,6
          repe cmpsb
          jz _milyon
          
          call degerleriSifirla
          lea di,milyar
          mov cx,6
          repe cmpsb
          jz _milyar
          
          call degerleriSifirla
          lea di, milyar
          mov cx,6
          repe cmpsb 
          jz _milyar
          
          call degerleriSifirla
          lea di,trilyon
          mov cx,7
          repe cmpsb
          jz _trilyon
          
                   
          _bir:  
                mov al,'1'
                call basamagaAta ; bu fonksiyonu kullanarak karsilatirilan yazilarin basamak yerleri olmasi gereken yerlerine yazilmistir. Fonksiyonun açiklamasini yukarida fonksiyonun içinde yaptim.                           
                                                      
           jmp yaziBitti 
          _iki:  
               mov al,'2'
               call basamagaAta   ; bu fonksiyonu kullanarak karsilatirilan yazilarin basamak yerleri olmasi gereken yerlerine yazilmistir. Fonksiyonun açiklamasini yukarida fonksiyonun içinde yaptim.
            jmp yaziBitti
          _uc:     
          
             mov al,'3'
             call basamagaAta   
             jmp yaziBitti               
          _dort:
              mov al,'4'
              call basamagaAta
              jmp yaziBitti
          _bes:            
              mov al,'5'
              call basamagaAta
              jmp yaziBitti  
          
          _alti:           
              mov al,'6'  
              call basamagaAta
              jmp yaziBitti
          _yedi:           
              mov al,'7'
              call basamagaAta
              jmp yaziBitti  
          
          _sekiz:          
              mov al,'8'
              call basamagaAta
              jmp yaziBitti  
          
          _dokuz:
              mov al,'9'
              call basamagaAta
              jmp yaziBitti
          
                      
                      
          
          _on:  
              dec bx
              mov al,'1'      
              mov onlarFlag,1         ; bu flag imlecin konumunu ayaralarken karisikliklari onlemek için kullanilmistir . Söyleki eger onlar basamaginda elemann girilmis ise yüzler basamaginda konuma yazilir iken 1 azaltilip yaziliyor 
              call basamagaAta   ; eger girilmemisse ve yüz dallanmasina girilmis ise demek ki onlar basamagi 0 ve yüzün basamak degerinin yazilacagi yer iki azaltilip yaziliyor
              jmp yaziBitti
               
             
          
          _yirmi:
              dec bx
              mov al,'2'     
              mov onlarFlag,1
              call basamagaAta
              jmp yaziBitti
              
          _otuz:      
              dec bx      
              mov al,'3'     
              mov onlarFlag,1
              call basamagaAta
              jmp yaziBitti
 
          _kirk:     
              dec bx      
              mov al,'4'     
              mov onlarFlag,1
              call basamagaAta
              jmp yaziBitti

          _elli:     
              dec bx      
              mov al,'5'      
              mov onlarFlag,1
              call basamagaAta
              jmp yaziBitti

          _altmis:   
              dec bx      
              mov al,'6'      
              mov onlarFlag,1
              call basamagaAta
              jmp yaziBitti

          _yetmis:   
              dec bx      
              mov al,'7'      
              mov onlarFlag,1
              call basamagaAta
              jmp yaziBitti

          _seksen:   
              dec bx      
              mov al,'8'     
              mov onlarFlag,1
              call basamagaAta
              jmp yaziBitti

          _doksan:   
              dec bx      
              mov al,'9'      
              mov onlarFlag,1
              call basamagaAta
              jmp yaziBitti

          _yuz:    
          
                cmp onlarFlag,1        ; programin isleyisi sayiyi yuzluk kisimlara ayirip ilerlemek seklindedir 
                jz imleciDuzelt        ; dolayisiyla 10 lar basamagina giris yapilmissa orda bx in konumu edcrement edilmistir demektir 
                jmp hatasizImlec       ; bu yüzden burada yazar iken  onlar flag in degeri 1 ise sadece bir kere dec edip yüzün basamak degeri girilir
                imleciDuzelt:
                mov bx,imlecYeri
                dec bx
                mov [bx],'1'
                mov onlarFlag,0 
                jmp git
                hatasizImlec: 

                sub bx,2                ; eger onlarin degeri 0 ise bu kez söyle bir anlam cikiyor onlar basamagina program ugramamis dolayisiyla onlar basamagi sifir
                mov [bx],'1'            ; ve herhangi bir dec yapilmamis bu yüzden imlecin konumunu yüzler basamagina konumlamak için mevcut yerinden 2 eksiltmemiz gerekiyor
                git:
                mov yuzlerFlag,1  
                jmp yaziBitti
              
          _bin:  
              mov bx,offset sayi1 
              add bx,14
              sub bx,3                  ; burada imlec binler basamagina konumlandirilmistir 
             ; mov imlecYeri,bx          ; 
              mov [bx],'1'
              mov binlerFlag,1          ; burada binler flag in kullanma amcai sayiyi 2. yüzlük kisima geçirmek için   yani eger program bin ibaresiyle karsilasmis ise bu flag 1 e esitlenicek 
                                        ; ve basamaga ata fonksiyonunda bin in degerine girerek imlecinYerini 3 eksilticek yani en basta yaptigim islem gibi de düsünüle bilir 
              jmp yaziBitti            ; en basta direk imleci birler basamagina konumlandirmistir, program yüzlü yüzlü kontrol etmesinden dolayi bu kisimda yeni birler basamagi olarak düsünülebilir
          _milyon:   
              mov bx,offset sayi1 
              add bx,14
              sub bx,6        
              ;mov imlecYeri,bx  
              mov [bx],'1'
              mov milyonFlag,1             
              jmp yaziBitti
          
          _milyar:    
              mov bx,offset sayi1
              add bx,14
              sub bx,9        
              ;mov imlecYeri,bx
              mov [bx],'1'
              mov milyarFlag,1 
              jmp yaziBitti
          _trilyon:   
              mov bx,offset sayi1
              add bx,14
              sub bx,12       
              ;mov imlecYeri,bx
              mov [bx],'1'
              mov trilyonFlag,1
              
              
          
          yaziBitti:
          mov cl,KalanUZUNLUK
       loop cevirmeBasla 

        ret
    yaziSayiCevir endp    
    

      
      



            
    lea dx, pkey
    mov ah, 9
    int 21h        ; output string at ds:dx
    
    ; wait for any key....    
    mov ah, 1
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
