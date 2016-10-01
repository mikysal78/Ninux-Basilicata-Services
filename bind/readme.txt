Qui è stata copiata tutta la directry presente sulla raspberry p2 del nodo Kali a titolo di esempio.


Primo step, analizziamo la cartella "bind"
  Creare prima di tutto una directory con il comando:
      mkdir -p /etc/bind/zones/

  Iin questa vengono definite le zone dei domini
  Il file db.nnxx definisce il TLD locale, che noi abbiamo chiamato nnxx
  il file db.10.27 è il file di reverse-zone, nel quale vanno inseriti tutti gli hosts presenti nelle zone.
  Attenzione, se nella zona c'è www ed ftp che stanno sullo stesso server (IP), nel reverse-zone va indicato
   solo ed esclusivamente il nome della macchina che ospita i servizi e l'IP va messo al contrario.
   nell'esempio di db.10.27 c'è 5.0 IN PTR ns.nnxx. ...l'IP della macchina è 10.27.0.5


Secondo step, copiare nella propria home i file presenti in "scrtipts".
  Assegnare i permessi di esecuzione con
     chmod +x *.sh
  Come si deduce dal nome dei file, servono a creare/eliminare le zone di dominio e del reverse.
  Si può ancora ottimizzare.
