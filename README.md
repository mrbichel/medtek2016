# medtek2016
Political data visualization with twitter and processing curriculum and examples for course on media and technology at Roskilde University. February 2016.



MedTek 2016 

- Basal SQL
- Fokus på forskellige former for data visualisering
- guide til opsætning af twitter API key 
- søjlediagram
- abstrakt visualisering
- visualisering over tid
- dataforståelse / statistik
- dårlige til matematik og statistik
- eksempler på måder at sorterer ting
- adgang til metadata, billeder

- netværksanalyse 
- hvad bliver der linket til 

text analysis
- 

sammenhold med ft.dk statistik evt. 

overvej om de skal forholde sig til live data overhovedet.


Database 
stw index på 1 ord
stwi2i index på 2 ord 
og 3 ord
...

Temaet er fortællinger

Materiale til 6 kursusgange

Regner med netværksproblemer

Cache live twitter queries fra API
- lokalt på computer? 

Server Download Datasets - Fleksibel 

sqlite lokalt
brug materiale til flere kurser

Designopgave, – analyse og eksperiment med udgangspunkt i kursets emner – data fra sociale medier – kreativ bearbejdning af disse fx • let forståelige fremstillinger eller • abstrakte ”kunstneriske” fortolkninger

- 238 - faktura + 30% (timer)
- timesats 205 - 

timer uvist max 90

---
Guide til twitter: 
Gå til dev.twitter.com
Login med bruger og password, opret en konto hvis du ikke har en 
Klik på manage your apps nederst på siden eller gå til apps.twitter.com
Klik create new app midt på siden
Udfyld navn og  beskrivelse
fx. medtek16_gruppe1
Exploring visualisation of danish politics at course on data visualization on Roskilde University. 


Inspiration:
http://filip.journet.sdu.dk/twitterpolitikere/

N-grams and Markov chains
http://www.decontextualize.com/teaching/rwet/n-grams-and-markov-chains/


 index unique word-level order-X n-grams


Mashup opposing politicans in correct sentence structures. 

Generate new tweets for party based on historic data 

Markov chain statistical generated political tweets

http://www.chrisharrison.net/index.php/Visualizations/WebTrigrams

Trigrams

Gennemsnitligt profilbillede
Gennemsnitlig politiker feed, navn, indhold mm. 

https://github.com/yusuke/twitter4j.git

Artikelr der bliver linket til 

Allison PArrish inspiration

http://shiffman.net/teaching/a2z/generate/#ngrams
https://github.com/aparrish/gen-text-workshop

context free grammar

Interessante ord:
medicinsk cannabis
prostitution
grænse bom 
invandring
csc
ulighed
rimelighed
justits
hacker
angreb
sikkerhed
forsvar

modpoler ....

konstruktiv, konstaterende / agribende

solidaritet

frihed


Vækst

mad

form

DK + tillægsord

ord + tillægsord -> hvilke tillægsord

politik og køn - hudfarve
alder på politkere
bruger database

caps lock
?? !!

/usr/local/Cellar/mysql/5.6.27/bin/mysql_install_db --verbose --user=johan --basedir=/usr/local/Cellar/mysql/5.6.27 --datadir=/usr/local/var/mysql --tmpdir=/tmp


Skema 
MEDTEK
Scheduled: 18 Feb 2016 09:30 to 15:30

MEDTEK
Scheduled: 22 Feb 2016 09:30 to 15:30 kan ikke

MEDTEK
Scheduled: 25 Feb 2016 09:30 to 15:30 kan ikke

MEDTEK
Scheduled: 29 Feb 2016 09:30 to 12:30 kan ikke

MEDTEK
Scheduled: 03 Mar 2016 09:30 to 15:30 kan ikke

MEDTEK
Scheduled: 07 Mar 2016 09:30 to 15:30 kan ikke 

MEDTEK
Scheduled: 10 Mar 2016 09:30 to 12:30 kan ikke


live data excersise 

fetch and draw

hent og tegn 

Streaming API
and collected data

#cop21


hashtags virker ikke rigtigt

http://codigogenerativo.com/code/twitter-para-processing-2-0/

https://www.youtube.com/watch?v=gwS6irtGK-c


convert mysql to sqlite
https://gist.github.com/esperlu/943776


https://github.com/sqlitebrowser/sqlitebrowser

simple cache proxy

brew install mysql

myysql.server start

mysql -uroot

mysql> CREATE DATABASE medtekpol16
mysql> USE medtekpol16;
mysql> \. /Users/johan/Documents/medtek2016/Dump20160120.sql




Sorterer alle retweets fra 


To eksempel rækker

## SQL, getting the data
- forbind, unix timestamp, basale database termer 
- vælge data
- sortere data
- join

## Tekst analyse
- n-grams
- 

## Drawing, showing the data
- gemme i datatype til draw, undgå at spørge databasen hver frame
- dynamisk visualisering  



almindelige processing eksempelr er fine til at lære og tegne 


--------
For examples

// Lad os lave en klasse tweet til at gemme tweets så vi nemt kan visualisere dem lokalt
// Vores klasse indeholder de samme felter som vi har i databasen
class Tweet {
  String parti;
  String tweet;
  
}



----
    
    // For at finde ud af hvad der interessant at visualiserer er det en god idé
    // at lave mange forskellige queries for at få en idé om hvordan dataen ser ud
    // og hvilke mønstre man måske kan finde








