From: Thomas Knop <tknop@maxrelax.de>
Subject: German translation of the netfilter-extension-HOWTO (2)
Date: Thu, 10 Oct 2002 12:53:21 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021010105321.GA26867@mail.maxrelax.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Sorry, I vorgott to attach the translation.

Thomas

--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="netfilter-extensions-HOWTO.sgml"
Content-Transfer-Encoding: 8bit

<!doctype linuxdoc system>

<!-- Das ist das Netfilter Erweiterungen HOWTO.
 -->

<article>

<!-- Title information -->

<title>Netfilter Erweiterungen HOWTO</title>
<author>Fabrice MARIE &lt;fabrice@celestix.com&gt;, Mailing Liste <tt/netfilter-devel@lists.samba.org/. Deutsche Übersetzung von Thomas Knop &lt;tknop@maxrelax.de&gt;
</author>
<date>$Revision: 1.20$</date>
<abstract>
Dieses Dokument beschreibt wie die aktuellen iptables Erweiterungen installiert und benutzt werden.

</abstract>

<!-- Table of contents -->
<toc>

<!-- Begin the document -->

<sect>Einleitung<label id="intro">
<p>
Zunächst ein paar Worte zur deutschen Übersetzung dieses HOWTO. Es ist teilweise extrem schwierig englische Fachbergriffe wirklich sinnvoll zu übersetzen. Da ich davon ausgehe, dass der geneigte Leser wenigstens ein Grundverständniss von Netzwerken, Protokollen und natürlich Netfilter hat, habe ich Worte wie ``conntrack'' oder ``match'' nicht mit ``Verbindungsverfolgung'' oder ``Übereinstimmung finden'' übersetzt. Falls jemand Mängel in der Übersetzung feststellt oder Verbesserungen vorschlagen möchte, freue ich mich eine Email zu erhalten.

<p>
Hallo. Dies ist eine gute Möglichkeit mich bei all den Leuten zu bedanken, die sehr viel Zeit in die Entwicklung, das Testen, das Melden von Fehlern und das Benutzen von Netfilter investiert haben.

Also, danke euch allen !!

<p>
Dieses HOWTO setzt voraus, dass du Rusty's 
<url url="http://www.netfilter.org/documentation/HOWTO/de/packet-filtering-HOWTO.html" name="Linux 2.4 Packet Filtering HOWTO"> gelesen und verstanden hast.
Es wird ebenfalls vorausgesetzt, dass du weißt wie man einen Linux Kernel richtig kompiliert und installiert.

<p>
Die <tt>iptables</tt> Distribution enthält Erweiterungen, die nicht von regulären Benutzern verwendet werden, die noch recht experimentell sind oder die zu guter Letzt noch nicht in den offiziellen Kernel eingeflossen sind.

Diese Erweiterungen sind im Normalfall nicht mit kompiliert, es sei denn du hast das veranlaßt.

<p>
Du findest die aktuellste Version dieses Dokumenten auf der <url url="http://www.netfilter.org/documentation/index.html#HOWTO" name="Netfilter Dokumentation"> Homepage.

<p>
Das Ziel dieses HOWTO soll es sein Leuten zu helfen, die mit den Netfilter Erweiterung gerade anfangen. Hierzu wird erklärt, wie man die Erweitrungen installiert und rudimentär wie man sie nutzt.

<p>(C) 2002 Fabrice MARIE. Deutsche Übersetzung (C) 2002 Thomas Knop. Lizensiert unter der GNU GPL Version 2.

<sect>Patch-O-Matic

<sect1>Was is Patch-O-Matic ?
<p>
Das <tt>iptables</tt> Makefile enthält eine Funktionalität die sich `patch-o-matic' (oder `p-o-m') nennt. p-o-m erleichtert dir die Patches auszuwählen, die du möchtes, und patcht dann automatisch den Kernel für dich. 

<p>
Zunächst solltest du dir die aktuellen CVS Sourcen holen. Damit ist sicher gestellt, dass du die jüngsten Erweiterungen benutzt. Um das zu erledigen, führe folgende Schritte durch:

<tscreen><verb>
# cvs -d :pserver:cvs@pserver.netfilter.org:/cvspublic login

(Wenn du nach dem Passwort gefragt wirst, gebe `cvs' an).

# cvs -d :pserver:cvs@pserver.netfilter.org:/cvspublic co netfilter/userspace netfilter/patch-o-matic
</verb></tscreen>

<p>
Es wird ein Verzeichnis `netfilter/' erstellt und alle Dateien werden innerhalb dieses Verzeichnisses für dich ausgescheckt.

<p>
Stelle sicher, dass sich deine Kernelsourcen in `/usr/src/linux/' befinden. Falls - aus welchen Gründen auch immer - der Kernel, den du patchen willst, sich nicht in`/usr/src/linux/' befindet, setze die Variable KERNEL_DIR so das sie auf deine Kernelsourcen zeigt:

<tscreen><verb>
# export KERNEL_DIR=/das/verzeichis/linux
</verb></tscreen>

<p>
Stelle sicher, dass die Abhängigkeiten in den Kernelsourcen stimmen. Wenn du unsicher bist:

<tscreen><verb>
# cd /usr/src/linux/
# make dep
</verb></tscreen>

<p>
Nun kannst du zurück zum Netfilter Verzeichnis in das Unterverzeichnis `userspace/' wechseln. Jetzt ist alles vorbereitet damit du p-o-m auszuführen kannst.

<sect1>Patch-O-Matic ausführen
<p>
Wenn du im Unterverzeichnis `userspace/' bist, starte p-o-m:

<tscreen><verb>
# make patch-o-matic

Welcome to Rusty's Patch-o-matic!

Each patch is a new feature: many have minimal impact, some do not.
Almost every one has bugs, so I don't recommend applying them all!
-------------------------------------------------------

Already applied: 2.4.1 2.4.4
Testing... name_of_the_patch NOT APPLIED ( 2 missing files)
The name_of_the_patch patch:
   Here usually is the help text describing what
   the patch is for, what you can expect from it,
   and what you should not expect from it.
Do you want to apply this patch [N/y/t/f/q/?]
</verb></tscreen>

<p>
Patch-o-matic wird dann alle Patche durchgehen. Wenn ein Patch bereits installiert ist, siehst du das an der ersten Zeile `Already applied:'. Ist ein Patch noch nicht installiert, wird dir p-o-m den Namen des Patches und einige Erklärungen anzeigen. p-o-m teilt dir den Zustand mit: `NOT APPLIED ( n missing files)' meint schlicht, dass der Patch noch nicht installiert ist, während `NOT APPLIED ( n rejects out of n hunks)' generell meint:
<enum>
<item>Entweder das Patchen konnte nicht sauber durchgeführt werden ...
<item>...Oder der Patch ist bereits in dem Kernel enthalten, den du versuchst zu patchen.
</enum>
Zuletzt wird du immer aufgefordert zu entscheiden, ob der Patch installiert werden soll oder nicht.

<itemize>
<item>Drücke einfach Enter (Eingabetaste), wenn du den Patch nicht installieren willst.
<item>Gebe `y' ein, wenn du möchtest, dass p-o-m den Patch testet und installiert. Wenn der Test nicht erfolgreich ist, wird es dir mitgeteilt und du wirst gefragt ob du den Patch dennoch installieren möchtest (conformation). Ist der Test erfolgreich, wird der Patch installiert und du wirst den Namen des Patches in der Zeile `Already applied' sehen.
<item>Gebe `t' ein, wenn du zunächst nur testen möchtest, ob sich der Patch normal installieren läßt.
<item>Gebe `f' ein, um p-o-m zu zwingen den Patch zu installieren.
<item>Gebe `q' ein, um p-o-m zu beenden.
</itemize>

<p>
Als Daumenregel gilt die kurzen Erklärungen zu den Patchen aufmerksam zu lesen bevor du einen Patch installierst. Da es derzeit SEHR VIELE offizielle Patche für patch-o-matic gibt (und wahrscheinlich noch mehr inoffizielle), ist es nicht empfohlen alle zu installieren! Du solltest wirklich nur die Patches installieren, die du jetzt benötigst, auch wenn das bedeutet, dass du Netfilter neu kompilieren mußt, wenn du einmal mehr Patches benötigst.

<p>
Anmerkung des Übersetzers: Du solltest einen Patch nur dann installieren, wenn du die Erklärung zum Patch verstanden hast und dir sicher bist, dass du dieses Feature unbedingt brauchst!

<p>
Es wurde eine neue Variante von patch-o-matic entwickelt, die dir nur solche Patche anzeigt, von denen bekannt ist, dass sie sich sauber installieren lassen oder aber mindestens von denen bekannt ist, dass sie keine anderen Patche negativ beinflussen. Um diese Installationsart auszuführen, führe folgendes aus:

<tscreen>
<verb>
# make most-of-pom
</verb>
</tscreen>

<p>
Es arbeitet genauso wie patch-o-matic was die Bedienung und das Patchen angeht, es überspring schlicht die Entwickler-Patches (`developer-only').

<p>
Patch-o-matic an sich ist einfach nur ein Shellscript im Unterverzeichnis `patch-o-matic/' und heißt `runme'. Du kannst in das Verzeichnis wechseln und es von Hand aufrufen. Rufst du es ohne Parameter auf, wird es dir eine Hilfeseite ausgeben:

<tscreen>
<verb>
Usage: ./runme [--batch] [--reverse] [--exclude suite/patch-file ...] suite|suite/patch-file

  --batch       batch Modus, automatisches installieren der Patches
  --reverse     ausgewählte Patche deinstallieren
  --exclude     die benannten Patche auslassen
</verb>
</tscreen>

<p>
Die Patche befinden sich in den Verzeichnissen `patch-o-matic/pending/', `patch-o-matic/base', u.s.w... Dabei sind `pending' und `base' zwei Suitenamen. Führe ein ls im Verzeichnis `patch-o-matic' aus, um alle Suites zu sehen. Beispiele für den Aufruf von `runme':

<tscreen>
<verb>
./runme --batch pending
./runme --batch userspace/ipt_REJECT-fake-source.patch
</verb>
</tscreen>

<p>
Das erste Kommando installiert alle Patche der Suite pending (die Reihenfolge ist in der Datei `pending/SUITE' festgelegt). Das zweite Kommando installiert nur den Patch `ipt_REJECT-fake-source.patch' aus der userspace Suite.

<sect1>Ok, und was als nächstes?

<p>
Nachdem du alle Patches installiert hast, die du installieren wolltest, ist der nächste Schritt das Neukompilieren und Installieren des Kernels. Diese HOWTO erklärt nicht wie das zu tun ist. Anstelle dessen kannst du das <url url="http://www.ibiblio.org/pub/Linux/docs/HOWTO/translations/de/aktuell/html/DE-Kernel-HOWTO.html.tar.gz" name="Linux Kernel HOWTO"> lesen.

<p>
Beim Konfigurieren deines Kernels, werden dir die neuen Optionen unter ``Networking Options -&gt; Netfilter Configuration'' angezeigt. Wähle die von dir benötigten Optionen aus, kompiliere  &amp; installiere deinen neuen Kernel.

<p>
Ist der Kernel erstmal installiert kannst du mit dem Kompilieren und Installieren des ``iptables'' Paketes aus dem Verzeichnis `userspace/' wie folgt fortfahren:

<tscreen>
<verb>
# make all install
</verb>
</tscreen>

<p>
Das war's! Deine neues iptables Packet ist installiert! Jetzt ist es an der Zeit die brandneuen Funktionalitäten zu benutzen.

<sect>Neue Netfilter Matches

<p>
In diesem Abschnitt werden wir versuchen die Benutzung der neuen Netfilter Matches zu erklären. Die Patche werden in alphabetischer Reihenfolge besprochen. Wir gehen hier nicht auf Patche ein, die andere Patche negativ beeinflussen; das kommt später mal.  

<p>
Generell gilt für Matches, dass du die Hilfe für ein bestimmtes Modul wie folgt abfragen kannst:

<tscreen>
<verb>
# iptables -m match_den_du_willst --help
</verb>
</tscreen>

<p>
Das zeigt dir die normale Hilf von iptables an und zuzüglich am Ende die spezielle Hilfe zu ``match_den_du_willst''.

<sect1>ah-esp Patch
<p>
Dieser Patch von Yon Uriarte &lt;yon@astaro.de&gt; fügt zwei neue Matches hinzu:

<itemize>
<item>``ah'' : erlaubt das Matchen eines AH Packetes basierend auf dem Security Parameter Index (SPI).
<item>``esp'' : erlaubt das Matchen eines ESP Paketes basierend auf dem SPI.
</itemize>

<p>
Dieser Patch kann recht brauchbar sein für Leute die IPSEC benutzen und die Verbindungen an Hand des SPI unterscheiden möchten.

<p>
Als Beispiel wollen wir alle AH Pakete verwerfen, die einen SPI von 500 haben:

<tscreen><verb>
# iptables -A INPUT -p 51 -m ah --ahspi 500 -j DROP

# iptables --list
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
DROP       ipv6-auth--  anywhere             anywhere           ah spi:500
</verb></tscreen>

<p>
Unterstützte Optionen für den ah Match sind:

<descrip>
<tag>--ahspi [!] spi[:spi]</> -&gt; matcht SPI (Bereich)
</descrip>

<p>
Der esp Matche arbeitet ebenso:

<tscreen><verb>
# iptables -A INPUT -p 50 -m esp --espspi 500 -j DROP

# iptables --list
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
DROP       ipv6-crypt--  anywhere             anywhere           esp spi:500 
</verb></tscreen>

<p>
Unterstützte Optionen für den esp Match sind:

<descrip>
<tag>--espspi [!] spi[:spi]</>  -&gt; matcht SPI (Bereich)
</descrip>

<p>
Es ist wichtig, dass du nicht vergisst das passende Protokoll mit ``-p 50'' or ``-p 51'' anzugeben (für jeweils ESP &amp; AH), wenn du einen dieser Matche verwendest. Ansonsten bricht das Einfügen der Regel aus offensichtlichen Gründen ab.

<sect1>conntrack Patch
<p>
Dieser Patch von Marc Boucher &lt;marc+nf@mbsi.ca&gt; fügt ein conntrack Match Modul hinzu (eine Obermenge des state Match), welches dir erlaubt weitere Conntrack Informationen zu matchen.

<p>
Wenn du Beispielsweise alle RELATED Verbindungen für das TCP Protokoll erlauben möchtest, kannst du wie folgt vorgehen:

<tscreen><verb>
# iptables -A FORWARD -m conntrack --ctstate RELATED --ctproto tcp -j ACCEPT

# iptables --list
Chain FORWARD (policy ACCEPT)
target     prot opt source               destination
ACCEPT     all  --  anywhere             anywhere           ctstate RELATED
</verb></tscreen>

<p>
Unterstützte Optionen für den conntrack Match sind:

<descrip>
<tag>[!] --ctstate [INVALID|ESTABLISHED|NEW|RELATED|SNAT|DNAT][,...]</>
-&gt; Match auf Zustand/Zustände. Die neuen `SNAT' and `DNAT' Zustände sind virtuell die dann zutreffen,  wenn die ursprüngliche Quelladresse sich vom Antwortziel oder die ursprüngliche Zieladresse sich von der Antwortquelle unterscheiden.

<tag>[!] --ctproto proto</> -&gt Protokoll; als Nummber oder Name, z.B. `tcp'.

<tag>--ctorigsrc [!] address[/mask]</> -&gt Spezifikation der ursprünglichen Quelladresse.

<tag>--ctorigdst [!] address[/mask]</> -&gt Spezifikation der ursprünglichen Zieladresse.

<tag>--ctreplsrc [!] address[/mask]</> -&gt Spezifikation der Antwortquelle.

<tag>--ctrepldst [!] address[/mask]</> -&gt Spezifikation des Antwortzieles.

<tag>[!] --ctstatus [NONE|EXPECTED|SEEN_REPLY|ASSURED][,...]</>
-&gt; match auf Status/Staten.

<tag>[!] --ctexpire time[:time]</> -&gt Match der restlichen ``Lebenszeit'' (lifetime) in Sekunden gegen eine Wert oder einen Bereich (die Randwerte sind einbezogen).
</descrip>

<sect1>iplimit Patch
<p>
Dieser Patch von Gerd Knorr &lt;kraxel@bytesex.org&gt; erlaubt es dir die Anzahl der parallelen TCP Verbindungen von einem bestimmten Host oder Netzwerk zu bergenzen.

<p>
Als Beispiel wollen wir die Anzahl der parallelen HTTP Verbindungen von einer einzelnen IP Adresse auf 4 begrenzen:

<tscreen><verb>
# iptables -A INPUT -p tcp --syn --dport http -m iplimit --iplimit-above 4 -j REJECT

# iptables --list
Chain INPUT (policy ACCEPT)
target   prot opt source    destination         
REJECT   tcp  --  anywhere  anywhere     tcp dpt:http flags:SYN,RST,ACK/SYN #conn/32 > 4 reject-with icmp-port-unreachable
</verb></tscreen>

<p>
Oder du möchtest eventuell die Anzahl paralleler Verbindungen einer ganzen Gruppe von Host (Netzmaske 255.255.255.0, ehm. Class C Netz) begrenzen:

<tscreen><verb>
# iptables -A INPUT -p tcp --syn --dport http -m iplimit --iplimit-mask 24 --iplimit-above 4 -j REJECT

# iptables --list
Chain INPUT (policy ACCEPT)
target   prot opt source    destination         
REJECT   tcp  --  anywhere  anywhere     tcp dpt:http flags:SYN,RST,ACK/SYN #conn/8 > 4 reject-with icmp-port-unreachable
</verb></tscreen>

<p>
Unterstützte Optionen für den iplimit Match sind:

<descrip>
<tag>[!] --iplimit-above n</> -&gt; matcht, wenn die Anzahl der existierenden TCP Verbindungen (nicht) größer als n ist.
<tag>--iplimit-mask n</> -&gt; Guppierung von Hosts per Maske.
</descrip>

<sect1>ipv4options Patch

<p>
Dieser Patch von Fabrice MARIE &lt;fabrice@celestix.com&gt; erlaubt es dir Pakete an Hand der gesetzten IP Protokoll Optionen zu matchen.

<p>
Als Beispiel verwerfen wir alle Pakete, bei denen die IP Option Record-Route oder Timestamp gesetzt ist:

<tscreen><verb>
# iptables -A INPUT -m ipv4options --rr -j DROP
# iptables -A INPUT -m ipv4options --ts -j DROP

# iptables --list
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
DROP       all  --  anywhere             anywhere            IPV4OPTS RR
DROP       all  --  anywhere             anywhere            IPV4OPTS TS
</verb></tscreen>

<p>
Unterstützte Optionen für den ipv4options Match sind:

<descrip>
<tag>--ssrr</> -&gt; Strict Source Routing Flag gesetzt.
<tag>--lsrr</> -&gt; Loose Source Routing Flag gesetzt.
<tag>--no-srr</> -&gt; Pakete ohne Source Routing.
<tag>[!] --rr</> -&gt; Record Route Flag gesetzt.
<tag>[!] --ts</> -&gt; Timestamp Flag gesetzt.
<tag>[!] --ra</> -&gt; Router-Alert Option aktiv.
<tag>[!] --any-opt</> -&gt; prüft ob mindestens eine IP Option aktiv ist (oder keine wenn ! vorangestellt wurde).
</descrip>

<sect1>length Patch
<p>
Dieser Patch von James Morris &lt;jmorris@intercode.com.au&gt; erlaubt es Pakete auf ihre Länge zu prüfen.

<p>
Als Beispiel wollen wir alle Ping's verbieten, die eine Paketlänge von mehr als 85 Bytes aufweisen:

<tscreen><verb>
# iptables -A INPUT -p icmp --icmp-type echo-request -m length --length 86:65535 -j DROP

# iptables --list
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
DROP       icmp --  anywhere             anywhere           icmp echo-request length 86:65535
</verb></tscreen>

<p>
Unterstützte Optionen für den length Match sind:

<descrip>
<tag>[!] --length length[:length]</> -&gt; prüft auf entsprechende Länge. Die Werte bei einem Bereich sind enthalten.
</descrip>

<p>
Wird bei einem Bereich ein Wert nicht angegeben, werden die implizierten Werte 0 (Minimum) und 65535 (Maximum) verwendet.

<sect1>mport Patch
<p>
Dieser Patch von Andreas Ferber &lt;af@devcon.net&gt; ermöglicht es in einer Regel für das UDP oder TCP Protokoll beliebige Kombination aus einzelnen Ports und Portbereichen zu verwenden.

<p>
Möchtest du zum Beispiel ftp, ssh, telnet und http mit einer einzigen Regel verwerfen, kannst du die folgende verwenden:

<tscreen><verb>
# iptables -A INPUT -p tcp -m mport --ports 20:23,80 -j DROP

# iptables --list
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
DROP       tcp  --  anywhere             anywhere           mport ports ftp-data:telnet,http
</verb></tscreen>

<p>
Unterstützte Optionen für den mport Match sind:

<descrip>
<tag>--source-ports port[,port:port,port...]</> -&gt; Quellports.
<tag>--sports port[,port:port,port...]</> -&gt; Synonym für --source-ports.
<tag>--destination-ports port[,port:port,port...]</> -&gt; Zielports.
<tag>--dports port[,port:port,port...]</> -&gt; Synonym für --destination-ports.
<tag>--ports port[,port:port,port]</> -&gt; Match für Quell- und Zielports.
</descrip>

<sect1>nth Patch
<p>
Dieser Patch von Fabrice MARIE &lt;fabrice@celestix.com&gt; erlaubt es das n-te Paket, welches eine Regel erreicht zu erkennen.

<p>
Wenn du zum Beispiel jedes zweite Ping Paket verwerfen willst, kannst du folgende Regel verwenden:

<tscreen><verb>
# iptables -A INPUT -p icmp --icmp-type echo-request -m nth --every 2 -j DROP

# iptables --list
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
DROP       icmp --  anywhere             anywhere           icmp echo-request every 2th 
</verb></tscreen>

<p>
Erweiterungen von Richard Wagner &lt;rwagner@cloudnet.com&gt; ermöglichen es schnell und einfach eine Last-Verteilung zu implementieren.

<p>
Möchtest du zum Beispiel die Last auf die 3 Adressen 10.0.0.5, 10.0.0.6 and 10.0.0.7 verteilen, kanst du wie folgt vorgehen:

<tscreen><verb>
# iptables -t nat -A POSTROUTING -o eth0 -m nth --counter 7 --every 3 --packet 0 -j SNAT --to-source 10.0.0.5
# iptables -t nat -A POSTROUTING -o eth0 -m nth --counter 7 --every 3 --packet 1 -j SNAT --to-source 10.0.0.6
# iptables -t nat -A POSTROUTING -o eth0 -m nth --counter 7 --every 3 --packet 2 -j SNAT --to-source 10.0.0.7

# iptables -t nat --list
Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination         
SNAT       all  --  anywhere             anywhere           every 3th packet #0 to:10.0.0.5 
SNAT       all  --  anywhere             anywhere           every 3th packet #1 to:10.0.0.6 
SNAT       all  --  anywhere             anywhere           every 3th packet #2 to:10.0.0.7 
</verb></tscreen>

<p>
Unterstützte Optionen für den nth Match sind:

<descrip>
<tag>--every n</> -&gt; Regel trifft auf jedes n-te Packet zu.
<tag>[--counter]  num</> -&gt; Benuze Zähler 0-15 (default:0).
<tag>[--start] num</> -&gt; Initialisiere den Zähler mit Wert `num' anstelle von 0. Der Wert muß zwischen 0 und (n-1) liegen.
<tag>[--packet] num</> -&gt; Trifft auf das `num'-te Packet zu. Der Wert muß zwischen 0 und (n-1) liegen. Wenn `--packet' für einen Zähler benutzt wird, so müssen n `--packet' Regeln existieren um alle Werte zwischen 0 und (n-1) abzudecken.
</descrip>

<sect1>pkttype Patch
<p>
Dieser Patch von Michal Ludvig &lt;michal@logix.cz&gt; ermöglicht es Pakete anhand ihres Types host/broadcast/multicast zu erkennen.

<p>
Wenn du zum Beispiel alle broadcast Pakete stillschweigend verwerfen willst:

<tscreen><verb>
# iptables -A INPUT -m pkttype --pkt-type broadcast -j DROP

# iptables --list
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
DROP       all  --  anywhere             anywhere           PKTTYPE = broadcast 
</verb></tscreen>

<p>
Unterstützte Optionen für diesen Match sind:

<descrip>
<tag>--pkt-type [!] packettype</> -&gt trifft auf den entsprechenden Pakettyp zu. Der Pakettyp kann einder der folgenden sein:
<descrip>
<tag>host</> -&gt; an uns 
<tag>broadcast</> -&gt; an alle
<tag>multicast</> -&gt; an eine Gruppe
</descrip>
</descrip>

<sect1>pool Patch
<p>
Patch von Patrick Schaaf &lt;bof@bof.de&gt;. Joakim Axelsson und Patrick sind gerade dabei diesen Match neu zu implementieren. Deswegen wird dieser Abschnitt mit einer aktuellen Erklärung dann aktualisiert, wenn die Neuimplementierung erfolgt ist.

<sect1>psd Patch
<p>
Dieser Patch von Dennis Koslowski &lt;dkoslowski@astaro.de&gt; versucht Portscans zu erkennen.

<p>
In der einfachsten Version wird der psd Patch wie folgt verwendet:

<tscreen><verb>
# iptables -A INPUT -m psd -j DROP

# iptables --list
Chain INPUT (policy ACCEPT)
target  prot opt source    destination         
DROP    all  --  anywhere  anywhere    psd weight-threshold: 21 delay-threshold: 300 lo-ports-weight: 3 hi-ports-weight: 1
</verb></tscreen>

<p>
Unterstützte Optionen für psd Match sind:

<descrip>
<tag>[--psd-weight-threshold threshold]</> -&gt; Grenze ab der von einem Portscan ausgegangen wird und diese Regel zutrifft.
<tag>[--psd-delay-threshold delay]</> -&gt; Zeit innerhalb der die Portzugriffe erfolgen müssen.
<tag>[--psd-lo-ports-weight lo]</> -&gt; Gewichtung für priviligierte Ports.
<tag>[--psd-hi-ports-weight hi]</> -&gt; Gewichtung für unpreviligierte Ports.
</descrip>

<sect1>quota Patch
<p>
Dieser Patch von Sam Johnston &lt;samj@samj.net&gt; gestattet es Quotas zu setzen. Wenn eine Quote erreicht wird, trifft die entsprechende Regel nicht mehr zu.

<p>
Wenn du zum Beispiel dein Limit von 50 Megabyte für den eingehenden http Traffic setzen möchtes, kannst du folgende Regeln verwenden:

<tscreen><verb>
# iptables -A INPUT -p tcp --dport 80 -m quota --quota 52428800 -j ACCEPT
# iptables -A INPUT -p tcp --dport 80 -j DROP

# iptables --list
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     tcp  --  anywhere             anywhere           tcp dpt:http quota: 52428800 bytes
DROP       tcp  --  anywhere             anywhere           tcp dpt:http 
</verb></tscreen>

<p>
Unterstützte Optionen für den quota Match sind:

<descrip>
<tag> --quota quota</> -&gt; Das Limit, das du setzen möchtest.
</descrip>

<sect1>random Patch
<p>
Dieser Patch von Fabrice MARIE &lt;fabrice@celestix.com&gt; ermöglicht es Pakete zufällig mit eine bestimmten Wahrscheinlichkeit auszuwählen.

<p>
Wenn du zum Beispiel zufällig 50% aller Ping Anfragen verwerfen möchtest, kannst du das wie folgt tun:

<tscreen><verb>
# iptables -A INPUT -p icmp --icmp-type echo-request -m random --average 50 -j DROP

# iptables --list
Chain INPUT (policy ACCEPT)
target     prot opt source       destination         
DROP       icmp --  anywhere     anywhere        icmp echo-request  random 50% 
</verb></tscreen>

<p>
Unterstützte Optionen für den random Match sind:

<descrip>
<tag>[--average percent]</> -&gt; Die Wahrscheinlichkeit in Prozent, mit der die Regel zutreffen soll. Wenn diese Option nicht angegeben wird, wird eine Wahrscheinlichkeit von 50% gesetzt. Der Wert muss inerhalb von 1 &lt;= percent &lt;= 99 liegen.
</descrip>

<sect1>realm Patch
<p>
Dieser Patch von Sampsa Ranta &lt;sampsa@netsonic.fi&gt; erlaubt es Pakete an Hand des ``realm key'' vom Routing auszuwählen; dies entspricht einer Klassifizierung von bestimmten Paketen.

<p>
Wenn du zum Beispiel alle ausgehenden Pakete loggen möchtest, die einen realm Wert von 10 haben, gehst du wie folgt vor:

<tscreen><verb>
# iptables -A OUTPUT -m realm --realm 10 -j LOG

# iptables --list
Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
LOG        all  --  anywhere             anywhere           REALM match 0xa LOG level warning
</verb></tscreen>

<p>
Unterstützte Optionen für den realm Match sind:

<descrip>
<tag>--realm [!] value[/mask]</> -&gt; matcht den entsprechendeb realm Wert zu.
</descrip>

<sect1>recent Patch
<p>
Dieser Patch von Stephen Frost &lt;sfrost@snowman.net&gt; erlaubt es dynamisch  Listen mit IP Adressen zu erstellen und dann an Hand der Listen Pakete auf unterschiedliche Weise zu filtern.

<p>
Zum Beispiel kannst du eine Liste `badgay' von Leuten erstellen, die versuchen einen Verbindung zum Port 139 (NETBIOS Session Service) deiner Firewall herzustellen und dann alle weiteren Pakete (also auch die normalerweise erlaubten) von diesen Leuten verwerfen ohne sie weiter zu betrachten.

<tscreen><verb>
# iptables -A FORWARD -m recent --name badguy --rcheck --seconds 60 -j DROP
# iptables -A FORWARD -p tcp -i eth0 --dport 139 -m recent --name badguy --set -j DROP

# iptables --list
Chain FORWARD (policy ACCEPT)
target     prot opt source               destination
DROP       all  --  anywhere             anywhere           recent: CHECK seconds: 60
DROP       tcp  --  anywhere             anywhere           tcp dpt:netbios-ssn recent: SET
</verb></tscreen>

<p>
Unterstützte Optionen für den recent Match sind:

<descrip>
<tag>--name name</> -&gt; Spezifiziert den Namen der Liste, die für das Kommando verwendet werden soll. Wird kein Name angegeben, so wird 'DEFAULT' verwendet.

<tag>[!] --set</> -&gt; Fügt die Quelladresse des Paketes zu der Liste hinzu. Ist die Adresse bereits in der Liste, wird ein Update durchgeführt. Das Ergebnis dieser Regel ist immer true oder bei vorangestelltem ! false.

<tag>[!] --rcheck</> -&gt; Prüft ob die Quelladresse in der Liste ist und gibt in diesem Fall true, sonst false zurück. Das Ergebnis wir bei vorangestlltem ! umgekehrt.

<tag>[!] --update</> -&gt; Prüft ob die Quelladresse in der Liste ist. Ist die Adresse vorhanden, wird ein Update durchgeführt und true zurückgegeben. Ist die Adresse nicht in der Liste wird false zurückgegeben. Das Ergebnis wir bei vorangestlltem ! umgekehrt.

<tag>[!] --remove</> -&gt; Prüft ob die Quelladresse in der Liste ist. Ist die Adresse vorhanden, wird sie aus der Liste entfernt und true zurückgegeben. Ist die Adresse nicht in der Liste wird false zurückgegeben. Das Ergebnis wir bei vorangestlltem ! umgekehrt.

<tag>[!] --seconds seconds</> -&gt; Diese Option muss etweder mit der 'rcheck' oder 'update' Option zusammen angegeben werden. Sie bewirkt, dass diese Regel nur dann greift, wenn die Quelladresse innerhalb der letzten angegebenen Sekunden 'seconds' in der Liste gesehen worden ist. Das Ergebnis wir bei vorangestlltem ! umgekehrt.

<tag>[!] --hitcount hits</> -&gt; Diese Option muss etweder mit der 'rcheck' oder 'update' Option zusammen angegeben werden. Sie bewirkt, dass diese Regel nur dann greift, wenn die Quelladresse wenigstens 'hits' mal in der Liste gesehen worden ist. Die Option kann zusammen mit der '--seconds' Option verwendet werden, um eine Regel zu erstellen, die nur dann greift wenn eine Adresse mit einer bestimmten Häufigkeit innerhalb eines Zeitintervalles gesehen wird. Das Ergebnis wir bei vorangestelltem ! umgekehrt.

<tag>--rttl</> -&gt; Diese Option muss etweder mit der 'rcheck' oder 'update' Option zusammen angegeben werden. Sie bewirkt, dass diese Regel nur dann greift, wenn die Adresse in der Liste ist und die TTL des aktuellen Paketes mit der TTL des Paketes übereinstimmt, welches die --set Regel ausgelöst hat. Das kann sinvoll sein, wenn du Probleme mit Leuten hast die ihre Quelladresse fälschen und so einen DoS Angriff über diesen Modul auslösen in dem andere Adressen dadurch gesperrt werden, dass sie die gefälschte Pakete senden.
</descrip>

<sect1>record-rpc Patch
<p>
Dieser Patch von Marcelo Barbosa Lima &lt;marcelo.lima@dcc.unicamp.br&gt; erlaubt es Pakete zu erkennen, wenn die Quelladdresse bereits vorher einen Port über den Portmapper angefordert hat oder diese eine neue GET Anfrage an den Portmapper ist. Das ermöglicht effektives RPC-Filtern.

<p>
Um RPC Verbindungen zu verfolgen benutze einfach folgende Regel:

<tscreen><verb>
# iptables -A INPUT -m record_rpc -j ACCEPT

# iptables --list
Chain INPUT (policy ACCEPT)
target     prot opt source               destination 
ACCEPT     all  --  anywhere             anywhere
</verb></tscreen>

<p>
Der record_rpc Match hat keine Optionen.

<p>
Wundere dich nicht, wenn keine Informationen zum Match ausgegeben werden. Das liegt daran, dass die print() Funktion dieses Matches nicht implementiert ist:

<tscreen><verb>
/* Prints out the union ipt_matchinfo. */
static void
print(const struct ipt_ip *ip,
      const struct ipt_entry_match *match,
      int numeric)
{
}
</verb></tscreen>

<sect1>string Patch
<p>
Dieser Patch von Emmanuel Roger &lt;winfield@freegates.be&gt; erlaubt es dir nach einem String an einer belibigen Stelle im Paket zu filtern.

<p>
Um zum Beispiel Pakete zu erkennen, die den String ``cmd.exe'' enthalten und diese an den Userspace weiterzuleiten kannst du folgende Regel benutzen:

<tscreen><verb>
# iptables -A INPUT -m string --string 'cmd.exe' -j QUEUE

# iptables --list
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
QUEUE      all  --  anywhere             anywhere           STRING match cmd.exe 
</verb></tscreen>

<p>
Bitte benutze diesen Match mit Vorsicht. Viele Leute wollen diesen Match benutzen um zusammen mit dem DROP Target Würmer abzuweheren. Dies ist ein grundlegender Fehler. Hierfür gibt es IDS Methoden, die wesentlich besser geeignet sind.

<p>
Auf ähnliche Weise versuchen viele Leute diesen Match dazu zu benutzen um bestimmte HTTP Funktionalitäten wie POST zu verbieten, indem sie alle Pakete verwerfen die diese String enthalten. Bitte verstehe, dass dieser Job wesentlich besser von einem filterndem Proxy übernommen werden kann. Darüber hinaus wird mit dieser Methode auch jeder HTML Inhalt verworfen der den String POST enthält. Dieser Match wurde nur entworfen um interessante Pakete an den Userspace weiterzureichen um sie dort besser zu analysieren. Pakete mit diesem Patch zu verwerfen hebelt jede andere IDS Methode aus.

<p>
Unterstützte Optionen für den string Match sind:

<descrip>
<tag>--string [!] string</> -&gt; String im Paket.
</descrip>

<sect1>time Patch
<p>
Dieser Patch von  Fabrice MARIE &lt;fabrice@celestix.com&gt; ermölicht es Pakete anhand der Zeitmarke (timestamp) zu filtern.

<p>
Um zum Beispiel ankommende Pakete nur von 8:00 Uhr bis 18:00 Uhr von Montags bis Freitags zuzulassen kannst du folgende Regel verwenden: 

<tscreen><verb>
# iptables -A INPUT -m time --timestart 8:00 --timestop 18:00 --days Mon,Tue,Wed,Thu,Fri -j ACCEPT

# iptables --list 
Chain INPUT (policy ACCEPT)
target     prot opt source           destination
ACCEPT     all  --  anywhere         anywhere        TIME from 8:0 to 18:0 on Mon,Tue,Wed,Thu,Fri 
</verb></tscreen>

<p>
Unterstützte Optionen für den time Match sind:

<descrip>
<tag>--timestart value</> -&gt; Minimum HH:MM
<tag>--timestop value</> -&gt; Maximum HH:MM
<tag>--days listofdays</> -&gt; Eine Liste von Tagen (Groß-/Kleinschreibung beachten) aus:
<itemize>
<item>Mon
<item>Tue
<item>Wed
<item>Thu
<item>Fri
<item>Sat
<item>Sun
</itemize>
</descrip>

<sect1>ttl Patch
<p>
Dieser Patch von Harald Welte &lt;laforge@gnumonks.org&gt; erlaubt es Pakete auf der Basis ihrer TTL zu filtern:

<p>
Um zum Beispiel alle Pakete zu loggen, die eine TTT kleiner als 5 aufweisen, kannst du folgende Regel verwenden:

<tscreen><verb>
# iptables -A INPUT -m ttl --ttl-lt 5 -j LOG

# iptables --list
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
LOG        all  --  anywhere             anywhere           TTL match TTL < 5 LOG level warning
</verb></tscreen>

<p>
Optionen des ttl Match sind:

<descrip>
<tag>--ttl-eq value</> -&gt; trifft zu bei gegebener Time-to-Live.
<tag>--ttl-lt value</> -&gt; trifft zu bei TTL &lt; value
<tag>--ttl-gt value</> -&gt; trifft zu bei TTL &gt; value
</descrip>

<sect>Neue Netfilter Targets (Ziele)
<p>
In diesem Abschnit werden wir versuchen die Benutzung der neuen Netfilter Targets zu erklären.  Die Patche werden in alphabetischer Reihenfolge besprochen. Wir werden hier nicht auf Patche eingehen, die andere Patche negativ beeinflussen; das kommt später mal.

<p>
Generell gilt für Targets, dass du die Hilfe für ein bestimmtes Modul wie folgt abfragen kannst:

<tscreen>
<verb>
# iptables -j TARGET_DAS_DU_WILLST --help
</verb>
</tscreen>

<p>
Dies wird dir die normale Hilf von iptables ausgeben zuzüglich der speziellen Hilfe zu ``TARGET_DAS_DU_WILLST'' am Ende.

<sect1>ftos Patch
<p>
Dieser Patch von Matthew G. Marsh &lt;mgm@paktronix.com&gt; fügt ein neues Target hinzu, welches dir gestattet den TOS eines Paketes auf einen beliebigen Wert zu setzen.

<p>
Wenn du zum Beispiel möchtest dass der TOS für alle ausgehenden Pakete den Wert 15 hat, benutzt du folgende Regel:

<tscreen><verb>
# iptables -t mangle -A OUTPUT -j FTOS --set-ftos 15

# iptables -t mangle --list
Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
FTOS       all  --  anywhere             anywhere           TOS set 0x0f 
</verb></tscreen>

<p>
Unterstützte Optionen für das FTOS Target sind:

<descrip>
<tag>--set-ftos value</> -&gt; Setzt das TOS Feld im Paketheader auf den gegebenen Wert. Der Wert kann dezimal (z.B. <tt>32</tt>) oder hexadezimal (z.B. <tt>0x20</tt>) angegeben werden.
</descrip>

<sect1>IPV4OPTSSTRIP Patch
<p>
Dieser Patch von Fabrice MARIE &lt;fabrice@celestix.com&gt; fügt ein neues Target hinzu, welches dir gestattet alle IP Optionen von einem IPv4 Paket zu entfernen.

<p>
Es wird einfache auf die folgende Art aktiviert:

<tscreen><verb>
# iptables -t mangle -A PREROUTING -j IPV4OPTSSTRIP

# iptables -t mangle --list
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination
IPV4OPTSSTRIP  all  --  anywhere             anywhere
</verb></tscreen>

<p>
Dieses Target hat keine Optionen.

<sect1>NETLINK Patch
<p>
Dieser Patch von Gianni Tedesco &lt;gianni@ecsc.co.uk&gt; fügt ein neues Target hinzu, welches dir gestattet verworfene Pakete an den Userspace über den Netlink Socket zu senden.

<p>
Wenn du zum Beispiel alle Pings verwerfen und sie and den Userspace Netlik Socket weiterleiten möchtest, kannst du das wie folgt erreichen:

<tscreen><verb>
# iptables -A INPUT -p icmp --icmp-type echo-request -j NETLINK --nldrop

# iptables --list
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
NETLINK    icmp --  anywhere             anywhere           icmp echo-request nldrop 
</verb></tscreen>

<p>
Unterstützte Optionen für das NETLINK Target sind:

<descrip>
<tag>--nldrop</> -&gt; Weiterreichen und verwerfen.
<tag>--nlmark &lt;number&gt;</> -&gt; Mark setzen.
<tag>--nlsize &lt;bytes&gt;</> -&gt; Paketgröße limitieren.
</descrip>

<p>
Für weitere Informationen über Netlink Sockets, kannst du dir die
<url url="http://www.skyfree.org/linux/kernel_network/netlink.html" name="Netlink Sockets Tour"> ansehen.

<sect1>NETMAP Patch
<p>
Dieser Patch von Svenning Soerensen &lt;svenning@post5.tele.dk&gt; fügt ein neues Target hinzu, welches dir gestattet ein statisches 1:1 Mapping für Netzwerk Adressen vorzunehmen, wobei die Host Adressen erhalten bleiben.

<p>
Wenn du zum Beispiel möchtest das alle einkommenden Pakete von 
1.2.3.0/24 nach 5.6.7.0/24 gemappt werden, kannst du das wie folgt erreichen:

<tscreen><verb>
# iptables -t nat -A PREROUTING -d 1.2.3.0/24 -j NETMAP --to 5.6.7.0/24

# iptables -t nat --list
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination         
NETMAP     all  --  anywhere             1.2.3.0/24         5.6.7.0/24
</verb></tscreen>

<p>
Unterstützte Optionen für das NETMAP Target sind:

<descrip>
<tag>--to address[/mask]</> -&gt; Netwerk Address auf die gemappt werden soll.
</descrip>

<sect1>SAME Patch
<p>
Dieser Patch von Martin Josefsson &lt;gandalf@wlug.westbo.se&gt; fügt ein neues Target hinzu, welches ähnlich dem SNAT ist, jedoch dem Client für jede Verbindung die gleiche Adresse zuweist.

<p>
Wenn du zum Beispiel Quelladressen auf den Bereich 1.2.3.4-1.2.3.7 abbilden willst, kannst du folgende Regel verwenden:

<tscreen><verb>
# iptables -t nat -A POSTROUTING -j SAME --to 1.2.3.4-1.2.3.7

# iptables -t nat --list
Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination         
SAME       all  --  anywhere             anywhere           same:1.2.3.4-1.2.3.7 
</verb></tscreen>

<p>
Optionen die vom SAME Target unterstützt werden sind:

<descrip>
<tag>--to &lt;ipaddr&gt;-&lt;ipaddr&gt;</> -&gt; Adressen auf die die Quelladressen gemappt werden. Kann auch mehrfach für mehrere Ranges spifiziert werden.
<tag>--nodst</> -&gt; Die Ziel IP nicht für die Quellauswahl verwenden.
</descrip>

<sect1>tcp-MSS Patch
<p>
Dieser Patch von Marc Boucher &lt;marc+nf@mbsi.ca&gt; fügt ein neues Target hinzu, welches dir gestattet den MSS Wert von TCP SYN Paketen zu untersuchen und zu ändern um die maximale Paketgröße für die Verbindung festzulegen.

<p>
Wie Marc selbs sagt: DIES IST EIN HACK, der benutzt wird um shon kiminell gehirntote ISPs oder Server die ICMP Fragmentation blocken zu überwinden.

<p>
Die typische Anwendung ist wie folgt:

<tscreen><verb>
# iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

# iptables --list
Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         
TCPMSS     tcp  --  anywhere             anywhere           tcp flags:SYN,RST/SYN TCPMSS clamp to PMTU 
</verb></tscreen>

<p>
Optionen die vom tcp-MSS Target unterstützt werden (schließen sich gegenseitig aus):

<descrip>
<tag>--set-mss value</> explizites setzen der MSS Option auf ``value''.
<tag>--clamp-mss-to-pmtu</> automatisches Anpassen des MSS Wertes (Pfad_MTU - 40).
</descrip>

<sect1>TTL Patch
<p>
Dieser Patch von Harald Welte &lt;laforge@gnumonks.org&gt; fügt ein Target hinzu, mit dem der Benutzer die TTL eines Paketes setzen oder erhöhen/vermindern kann.

<p>
Wenn du zum Beispiel möchtest das alle ausgehenden Verbindungen eine TTL von 126 erhalten, kannst du wie folgt vorgehen:

<tscreen><verb>
# iptables -t mangle -A OUTPUT -j TTL --ttl-set 126

# iptables -t mangle --list
Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
TTL        all  --  anywhere             anywhere           TTL set to 126 
</verb></tscreen>

<p>
Unterstützte Optionen für das TTL Target sind:

<descrip>
<tag>--ttl-set value</> -&gt; Setze TTL auf &lt;value&gt;.
<tag>--ttl-dec value</> -&gt; Vermindert die TTL um &lt;value&gt;.
<tag>--ttl-inc value</> -&gt; Erhöhe die TTL um &lt;value&gt;.
</descrip>

<sect1>ulog Patch
<p>
Dieser Patch von Harald Welte &lt;laforge@gnumonks.org&gt; fügt ein neues Target hinzu, welches einen erweiterten Loggingmechanismus als das standard LOG Target zur Verfügung stellt. Das `libipulog/' Verzeichnis enthält eine Library um ULOG Meldungen zu empfangen.

<p>
Harald betreibt eine <url url="http://www.gnumonks.org/projects/ulogd" name="Website"> auf der die Dokumentation von ULOG bereit stellt. Es besteht also keinen Grund hier weiter darauf einzugehen..

<sect1>ROUTE Patch
<p>
Dieser Patch von Cédric de Launois &lt;delaunois@info.ucl.ac.be&gt; für ein Target hinzu, das es dir gestattet Pakete direkt and ein bestimmtes Interface weiterzuleitet auch und gerade dann, wenn die IP Adresse des Paketes eine IP Adresse des Router selbst ist. Da der Kernel solche Pakete lokal ausliefern würde, können solche Pakete nicht mit dem stadard Routing zu anderen Computern weitergeleitet werden. Manchmal ist es sinnvoll genau dies zu tun ohne die Pakete zu verändern.

<p>
Optionen die vom ROUTE Target unterstützt werden sind:

<descrip>
<tag>--iface name</> Sende das Paket direkt zu dem über den Namen dem spezifizerten Interface.
<tag>--ifindex index</>
Sende das Paket direkt zu dem über den Index spezifizierten Interface. Das ist sinnvoll, wenn du eine Regel entfernen möchtest die an ein Interface gebunden ist, welches nicht mehr existiert (z.B. ein Tunnel der abgebaut wurde). 
</descrip>

<p>
Als Beispiel lass uns annehmen du möchtest einen Service auf einem Server in deinem internen Netz installieren; sagen wir ssh. Du möchtest aber auch, das der Service nach aussen so aussieht als wenn er auf denem Router laufen würde, was natürlich einschließt, dass keine Pakete verändert werden. Diese Situation verbietet das Verwenden des standard Mechnismus der Portweiterleitung.

<p>
Die Lösung besteht dank dieses ROUTE Targets und einem IPIP Tunnep einfach darin, die Pakete mit Zielport 22 neu an den Rechner zu routen, der die gleiche IP Adresse hat wie dein Router und den ssh Servive betreibt.

<p>
Zeit für ein ASCII Bild:
<verb>
              eth0  +------+ 192.168.0.1        192.168.0.2 +----+
    ----------------|router|--------------------------------|host|
    IP: 150.150.0.1 +------+                                +----+
                       | | tunl1              IP: 150.150.0.1 | |
                       | +------------------------------------+ |
                       +----------------------------------------+
                                      IPIP tunnel
</verb>
<p>
Es ist nicht möglich solche Pakete mit dem standard Routing umzuleiten, einfach weil der Kernel davon ausgeht, dass diese Pakete lokal ausgeliefert werden müssen (sie haben die gleiche IP Address wie der Router selbst).

<p>
Das ROUTE Target stellt einen Weg zur Verfügung um das zu machen. Für das obige Beispiel würden wir folgende Regeln verwenden:

<tscreen><verb>
# iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 22 -j ROUTE --iface tunl1
# iptables -A PREROUTING -t nat -i tunl1 --j ROUTE --iface eth0

# iptables -L PREROUTING -t nat
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination         
ROUTE      tcp  --  anywhere             anywhere           tcp dpt:ssh ROUTE iface tunl1(7) 
ROUTE      all  --  anywhere             anywhere           ROUTE iface eth0(3) 
</verb></tscreen>

<p>
Die erste Regel routet Pakete aus dem Internet um und die zweite routet alle Pakete vom Host um. Die Werte in den Klammern hinter den Interfacenamen sind die Interfaceindexe. Es wird die nat Tabelle benutzt, da diese den PREROUTING Hook zur Verfügung stellt. Das heißt aber nicht, dass hier Pakete verändert werden.

<sect>Neue Connection Tracking Patches
<p>
In diesem Abschnitt stellen wir die verfügbaren Connection Tracking/NAT Patches vor. Um sie zu verwenden lade einfach das entsprechende Modul (wenn benötigt mit Optionen).

<sect1>eggdrop-conntrack Patch
<p>
Dieser Patch von Magnus Sandin &lt;magnus@sandin.cx&gt; fügt Support für eggdrop bot Netwerke hinzu.

<sect1>ftp-fxp Patch
<p>
Dieser Patch von Magnus Sandin &lt;magnus@sandin.cx&gt; fügt FXP Support für ftp Connection Tracking hinzu. FXP zu ge-NAT-teten ftp Servern funktioniert derzeit noch nicht. Um FXP Conntracking zu erlauben, gehe wie folgt vor:

<tscreen><verb>
# modprobe ip_conntrack_ftp.o fxp=1
</verb></tscreen>

<p>
Der Patch enthält eine Sicherheits-Warnung: WARNUNG, diesen Patch zu installieren und das Feature einzuschalten <tt>WIRD</tt> die Sicherheit des FTP Connection Tracking erheblich reduzieren. Benuzte es sehr vorsichtig (und nur dann wenn du weißt was du machst).

<sect1>irc-conntrack-nat Patch
<p>
Dieser Patch von Harald Welte &lt;laforge@gnumonks.org&gt; bewirkt das DCC mit NAT und Connection Tracking funktioniert. Per Default, trackt dieses Modul IRC Verbindungen auf Port 6667. Du kannst das aber durch die Option `ports=xx' ändern.

<sect1>pptp Patch
<p>
Diser Patch ermöglicht es pptp Verbindungen zu tracken und zu NAT-en.

<sect1>record-rpc Patch
<p>
Dieser Patch von Marcelo Barbosa Lima &lt;marcelo.lima@dcc.unicamp.br&gt; gestattet es Netfilter portmapper Anfragen für UDP und TCP zu tacken.

<sect1>snmp-nat Patch
<p>
Dieser Patch von James Morris &lt;jmorris@intercode.com.au&gt; gestattet es Netfilter grundlegend NAT für SNMP durchzuführen. Diese ``grundlegende'' Art ist SNMP-ALG, wie sie in <url url="http://www.faqs.org/rfcs/rfc2962.html" name="RFC 2962"> beschrieben wird. Es funktioniert indem die IP Adresse innerhalb der SNMP Payloads an das IP-Mapping angepaßt wird.

<sect1>talk-conntrack-nat Patch
<p>
Dieser Patch von Jozsef Kadlecsik &lt;kadlec@blackhole.kfki.hu&gt; gestattet Netfilter talk Verbindungen zu tracken und NAT mit talk zu verwenden. Per Default werden otalk (UDP Port 517) und talk (UDP Port 518) unterstützt. Du kannst otalk/talk selektiv über die Parameter der Module ip_conntrack_talk und ip_nat_talk ein- und ausschalten. Die Optionen sind:

<itemize>
<item>otalk = 0 | 1
<item>talk = 0 | 1
</itemize>

<p>
Wobei `0' den Support für das entsprechende Protokoll ausschaltet und `1' einschaltet.

<sect1>tcp-window-tracking Patch
<p>
Dieser Patch von Jozsef Kadlecsik &lt;kadlec@blackhole.kfki.hu&gt; gestattet Netfilter das Tracking von TCP Verbindungen entsprechend des Artikels <url url="http://www.iae.nl/users/guido/papers/tcp_filtering.ps.gz" name="Real Stateful TCP Packet Filtering in IP Filter"> von Guido van Rooij. Es supportet window scaling und kann jetz auch bereits etablierte Verbundungen verarbeiten.

<p>
Dieser Patch setzt den ``ftp-fixes'' Patch voraus. Das sollte Bestandteil des standard Kernels sein. Dieser Tage...

<sect1>tftp Patch
<p>
Dieser Patch von Magnus Boden &lt;mb@ozaba.mine.nu&gt; gestattet Netfilter das Tracking und NAT-en von tftp Verbindungen. Per Default trackt dieses Modul tftp Verbindungen auf Port 69. Dies kann mit dem Parameter `ports=xx' auf einen anderen Port festgelegt werden.

<sect>Neue IPv6 Netfilter Matches
<p>
In dieser Sektion werden wir versuchen die Benutzung der neuen Netfilter Matches für IPv6 zu erklären. Die Patche werden in alphabetischer Reihenfolge besprochen. Wir werden hier nicht auf Patche eingehen, die andere Patche negativ beeinflussen; das kommt später mal.

<p>
Generell gilt für Matches, dass du die Hilfe für ein bestimmtes Modul wie folgt abfragen kannst:

<tscreen>
<verb>
# iptables -m match_den_du_willst --help
</verb>
</tscreen>

<p>
Dies wird dir die normale Hilf von ip6tables ausgeben zuzüglich der speziellen Hilfe zu ``match_den_du_willst'' am Ende.

<sect1>agr Patch
<p>
Dieser Patch von Andras Kis-Szabo &lt;kisza@sch.bme.hu&gt; fügt einen neuen Match hinzu:

<itemize>
<item>``eui64'': erlaubt es dir IPv6 Packete auf Basis ihrer addressierungs Parameter zu matchen.
</itemize>
<p>
Aktueller Status: In der Schwebe (2.4.19)

<p>
Dies Patch kann für Leute die das EUI-64 IPv6 Adressierungschema verwenden sinvoll sein, wenn sie die Pakete auf Basis der Auslieferungsadresse im LAN filtern wollen.

<p>
Als Beispiel wollen wir Pakete mit eine korrekten EUI-64 Adresse umleiten:

<tscreen><verb>
# ip6tables -N ipv6ok
# ip6tables -A INPUT -m eui64 -j ipv6ok
# ip6tables -A INPUT -s ! 3FFE:2F00:A0::/64 -j ipv6ok
# ip6tables -A INPUT -j LOG
# ip6tables -A ipv6ok -j ACCEPT

# ip6tables --list
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
ipv6ok     all      anywhere             anywhere           eui64 
ipv6ok     all     !3ffe:2f00:a0::/64    anywhere           
LOG        all      anywhere             anywhere           LOG level warning 

Chain ipv6ok (2 references)
target     prot opt source               destination         
ACCEPT     all      anywhere             anywhere           
</verb></tscreen>

<p>
Dieser Match hat keine Optionen.

<sect1>ahesp6 Patch
<p>
Dieser Patch von Andras Kis-Szabo &lt;kisza@sch.bme.hu&gt; fügt einen Match hinzu, der es dir erlaubt Pakete auf Basis des Inhalts der ah und esp Header zu filtern. Der Name des Matches:
<itemize>
<item>``ah'' : gestattet das Matchen von IPv6 Packeten auf Basis ihres ah Headers.
<item>``esp'' : gestattet das Matchen von IPv6 Packeten auf Basis ihres esp Headers.
</itemize>
<p>
Aktueller Status: Basic, funktioniert bei Fabrice MARIE (Author der original Version dieses Dokumentes)

<p>
Als Beispiel wollen wir alle AH Pakete verwerfen, die einen SPI Wert gleich 500 haben wobei der reservierte Bereich des Headers geprüft wird:

<tscreen><verb>
# ip6tables -A INPUT -m ah --ahspi 500 --ahres -j DROP

# ip6tables --list
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
DROP       all      anywhere             anywhere           ah spi:500 reserved
</verb></tscreen>

<p>
Unterstützte Optionen für den ah Match sind:

<descrip>
<tag>--ahspi [!] spi[:spi]</> -&gt; matcht spi (Bereich).
<tag>--ahlen [!] length</> -&gt; matcht Länge des Headers.
<tag>--ahres </> -&gt; prüft reservierten Bereich des Headers.
</descrip>

<p>
Der esp Match arbeitet genauso wie bei IPv4:

<tscreen><verb>
# ip6tables -A INPUT -m esp --espspi 500 -j DROP

# iptables --list
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
DROP       all      anywhere             anywhere           esp spi:500 
</verb></tscreen>

<p>
Unterstützte Optionen für den esp Match sind:

<descrip>
<tag>--espspi [!] spi[:spi]</>  -&gt; matcht spi (Bereich).
</descrip>

Bei IPv6 können diese Matche zusammen benutzt werden:

<tscreen><verb>
# ip6tables -A INPUT -m ah --ahspi 500 --ahres --ahlen ! 40 -m esp --espspi 500 -j DROP

# iptables --list
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
DROP       all      anywhere             anywhere           ah spi:500 length:!40 reserved esp spi:500
</verb></tscreen>

<sect1>frag6 Patch
<p>
Dieser Patch von Andras Kis-Szabo &lt;kisza@sch.bme.hu&gt; fügt einen Match hinzu, der es gestattet Pakete auf Basis des Inhaltes der Fragmentheader zu filtern.

Name des Matches:
<itemize>
<item>``frag'' : gestattet Pakete auf Basis des Inhaltes der Fragmentheader zu filtern.
</itemize>
<p>
Aktueller Status: Basic, funktioniert bei Fabrice MARIE (Author der orginal Version dieses Dokumentes)

<p>
Als Beispiel wollen wir alle Pakete verwerfen, die eine ID zwischen 100 and 200 haben und das erste Fragent sind:

<tscreen><verb>
# ip6tables -A INPUT -m frag --fragid 100:200 --fragfirst -j DROP

# ip6tables --list
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
DROP       all      anywhere             anywhere           frag ids:100:200 first
</verb></tscreen>

<p>
Unterstützte Optionen für den frag Match sind:

<descrip>
<tag>--fragid [!] id[:id]</> -&gt; matcht die id (Bereich) der Fragmentation.
<tag>--fraglen [!] length</> -&gt; matcht totale Länge des Headers.
<tag>--fragres</> -&gt; prüft den Inhalt des resavierten Bereiches.
<tag>--fragfirst</> -&gt; trifft für das erste Fragment zu.
<tag>--fragmore</> -&gt; trifft zu wenn keine weiteren Fragmente vorhanden sind.
<tag>--fraglast</> -&gt; trifft auf das letzte Fragment zu.
</descrip>

<sect1>ipv6header Patch
<p>
Dieser Patch von Andras Kis-Szabo &lt;kisza@sch.bme.hu&gt; fügt einen Match hinzu der es dir gestattet Pakete auf Basis der erweiterten Header zu filtern.

Name des Match:
<itemize>
<item>``ipv6header'' : gestattet Pakete auf Basis der Header zu filtern.
</itemize>
<p>
Aktueller Status: Basic, funktioniert bei Fabrice MARIE (Author der orginal Version dieses Dokumentes)

<p>
Als Beispiel wollen wir alle Pakete verwerfen die hop-by-hop, ipv6-route 
Header und einen Protokoll Zusatzt haben:

<tscreen><verb>
# ip6tables -A INPUT -m ipv6header --header hop-by-hop,ipv6-route,protocol -j DROP

# ip6tables --list
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
DROP       all      anywhere             anywhere           ipv6header flags:hop-by-hop,ipv6-route,protocol
</verb></tscreen>

<p>
Und nun laß uns Pakete verwerfen, die einen ipv6-route Erweiterungsheader haben:

<tscreen><verb>
# ip6tables -A INPUT -m ipv6header --header ipv6-route --soft -j DROP

# ip6ptables --list
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
DROP       all      anywhere             anywhere           ipv6header flags:ipv6-route soft
</verb></tscreen>

<p>
Unterstützte Optionen für den ipv6header Match sind:
<descrip>
<tag>[!] --header headers</> -&gt; Du kanns die für dich interessanten Header mit dieser Option spezifizieren. Akzeptierte Formate:
<itemize>
<item>hop,dst,route,frag,auth,esp,none,proto
<item>hop-by-hop,ipv6-opts,ipv6-route,ipv6-frag,ah,esp,ipv6-nonxt,protocol
<item>0,60,43,44,51,50,59
</itemize>
<tag>--soft</> -&gt; Du kannst den soft-Modus spezifizieren: In diesem Modus prüft der Match nur auf die Existens der Header, nicht den vollständigen Match!
</descrip>

<sect1>ipv6-ports Patch
<p>
Dieser Patch von Jan Rekorajski &lt;baggins@pld.org.pl&gt; fügt vier neue Matches hinzu:

<itemize>
<item>``limit'' : gestattet dir das limitieren von parallelen TCP Verbindungen von einem bestimmten Host oder Netzwerk.
<item>``mac'' : gestattet dir das erkennen von MAC Adressen.
<item>``multiport'' : gestattet das Angeben einer gemischten Kombination aus Einzelports und Portbereichen für das UDP und TCP Protokoll.
<item>``owner'' : gestattet das erkennen des Benutzer ID, des Prozesses der das Paket verschickt hat.
</itemize>

<p>
Aktueller Status: im Kernel

<p>
Diese Matche sind Portierung der IPv4 Versionen. Für eine genauere Beschreibung siehe dir die Dokument dort an.

<sect1>length Patch
<p>
Dieser Patch von Imran Patel &lt;ipatel@crosswinds.net&gt; erlaubt es Pakete auf ihrer Länge zu prüfen (Dieser Patch ist eine schamlose Adaption des 
IPv4 Match der von James Morris &lt;jmorris@intercode.com.au&gt; geschrieben wurde).

<p>
Als Beispiel wollen wir alle Ping's verbieten, die eine Paketlänge von mehr als 85 Bytes aufweisen:

<tscreen><verb>
# iptables -A INPUT -p icmp --icmp-type echo-request -m length --length 86:65535 -j DROP

# iptables --list
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
DROP       icmp --  anywhere             anywhere           icmp echo-request length 86:65535
</verb></tscreen>

<p>
Unterstützte Optionen für den length Match sind:

<descrip>
<tag>[!] --length length[:length]</> -&gt; prüft auf entsprechende Länge(n). Die Werte bei einem Bereich sind inclusiv.
</descrip>

<p>
Wird bei einem Bereich ein Wert nicht angegeben, werden die implizierten Wert 0 (Minimum) und 65535 (Maximum) verwendet.

<sect1>route6 Patch
<p>
Dieser Patch von Andras Kis-Szabo &lt;kisza@sch.bme.hu&gt; fügt einen Patch hinzu, der es gestattet Pakete auf Basis des Inhalts ihres Routingheaders zu filtern.

Name des Matches:
<itemize>
<item>``rt'' : gestattet Pakete auf Basis des Inhalts ihres Routinheaders zu filtern.
</itemize>
<p>
Aktueller Status: Basic, funktioniert bei Fabrice MARIE (Author der orginal Version dieses Dokumentes)

<p>
Als Beispiel wollen wir alle Pakete verwerfen die den Routing Typ 0 haben und nahe am letzten Hop sind (max. 2 Hops entfernt), der Routing Pfad enthält ::1 und ::2 (aber nicht exakt):

<tscreen><verb>
# ip6tables -A INPUT -m rt --rt-type 0 --rt-segsleft :2 --rt-0-addrs ::1,::2 --rt-0-not-strict -j DROP

# ip6tables --list
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
DROP       all      anywhere             anywhere           rt type:0 segslefts:0:2 0-addrs ::1,::2 0-not-strict
</verb></tscreen>

<p>
Unterstützte Optionen für den rt Match sind:

<descrip>
<tag>--rt-type [!] type</> -&gt; trifft auf den Typ zu.
<tag>--rt-segsleft [!] num[:num]</> -&gt; prüft das Segments Left Feld (Bereich).
<tag>--rt-len [!] length</> -&gt; totale Länge des Headers.
<tag>--rt-0-res</> -&gt; prüft den Inhalt des reservierten Feldes.
<tag>--rt-0-addrs ADDR[,ADDR...]</> -&gt; Type=0 Adressen (Lise, max: 16).
<tag>--rt-0-not-strict</> -&gt; Liste von Type=0 Adressen, keine strikte Liste.
</descrip>

<sect>Neue IPv6 Netfilter Targets (Ziele)
<p>
In diesem Abschnit werden wir versuchen die Benutzung der neuen IPv6 Netfilter Targets zu erklären.  Die Patche werden in alphabetischer Reihenfolge besprochen. Wir werden hier nicht auf Patche eingehen, die andere Patche negativ beeinflussen; das kommt später mal.

<p>
Generell gilt für Targets, dass du dir die Hilfe für ein bestimmtes Modul wie folgt ansehen kannst:

<tscreen>
<verb>
# ip6tables -j TARGET_DAS_DU_WILLST --help
</verb>
</tscreen>

<p>
Das wird die allgemeine Hilfe zu ip6tables anzeigen und zusätzlich die spezielle Hilfe zu ``TARGET_DAS_DU_WILLST'' am Ende.

<sect1>LOG Patch
<p>
Dieser Patch von Jan Rekorajski &lt;baggins@pld.org.pl&gt; fügt ein neues Target hinzu, welches dir gestattet IPv6 Pakete ebenso zu loggen, wie du es von der IPv4 version her gewohnt bist.

<p>
Aktueller Status: Im Kernel.

<p>
Die Beispiele sind die gleichen wie die für iptables. Siehe dir also bitte diese Hilfen an.

<sect1>REJECT Patch
<p>
Dieser Patch von Harald Welte &lt;laforge@gnumonks.org&gt; fügt ein neues Target hinzu, welches dir gestattet IPv6 Pakete ebenso abzuweisen, wie du es von der IPv4 version her gewohnt bist.

<p>
Aktueller Status: Basic, wird getestet.

<p>
Die Beispiele sind die gleichen wie die für iptables. Siehe dir also bitte diese Hilfen an.

<sect>Neue IPv6 Connection Tracking Patches
<p>
Das Connection Tracking wird für IPv6 derzeit noch nicht unterstützt.

<sect>Mitwirken

<sect1>Mitwirken an neuen Erweiterung
<p>
Das Netfilter Core-Team nimmt jederzeit und gerne neue Erweierungen oder Fehlerbereinigungen an. In diesem Abschnitt werden wir uns nicht damit beschäftigen wie du eine neue Erweiterung selbst in das Patch-o-matic Paket einbinden kannst. Aber wir wollen dieses in einer zukünftigen Version dieses HOWTO's aufnehmen.

<p>
Als erstest solltest du dich mit dem <url url="http://www.netfilter.org/documentation/HOWTO/netfilter-hacking-HOWTO.html" name="Netfilter Hacking HOWTO"> vertraut machen..

<p>
Rusty hat bereist eine Kurzanleitung geschrieben, wie du neue Patches für Netfilter entwickeln kannst. Du findest diese in

<tscreen><verb>
/path/to/netfiltercvs/netfilter/Patch-o-matic/NEWPATCHES
</verb></tscreen>

<p>
Oder lese die aktuellste Version online unter:
<url url="http://cvs.netfilter.org/cgi-bin/cvsweb/netfilter/Patch-o-matic/NEWPATCHES" name="NEWPATCHES">.

<p>
Zu guter Letzt ist es sicher ein guter Einfall sich auf der netfilter-devel Mailingliste einzuschreiben. Mehr Informationen hierzu findest du auf der <url url="http://www.netfilter.org/contact.html#devlist" name="Netfilter Homepage">.

<sect1>Mitwirken dieses HOWTO
<p>
Du bist herzlich dazu aufgefordert dieses HOWTO zu erweitern und zu verbessern. Wenn du das tun möchtest ist es der beste Weg das SGML Master dieses Dokumentes an die netfilter-devel Mailingliste zu schicken. 

<p>
Danke für eure Hilfe! Danke an die vielen Entwickler die an jenen Teilen des Netfilter-Extension-HOWTO mitarbeiten, die zu ihren Patches gehöhren.
</article>



--YZ5djTAD1cGYuMQK--
