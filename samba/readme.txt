Abbiamo messo una configurazione molto semplice per la condivisione dei files
Quindi fare una copia dei backup del file di configurazione originale con il comando
  cp -p /etc/samba/smb.conf /etc/samba/smb.conf.sav

copiare il contenuto del nostro file in smb.conf con il comando
  cat smb.conf > /etc/samba/smb.conf

prima di lanciare samba, creare le directory, nel nostro caso
  mkdir -p /home/shares/shared
  mkdir -p /home/shares/ninuxbas

Se ci sono utenti già definiti bisgna aggiungerli a samba con il comando
UTENTE = nome utente che vuoi aggiungere, es. michele
  smbpasswd -a UTENTE

Se vuoi creare nuovi utenti
  useradd UTENTE -m -G users -s /usr/sbin/nologin
  passwd UTENTE
  smbpasswd -a UTENTE
