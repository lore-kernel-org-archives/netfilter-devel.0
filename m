From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH] Polish FAQ update.
Date: Thu, 26 Jun 2003 16:02:36 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0306261600070.6403@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

this patch:
- adds a missing section 3.17
- adds the translated section 3.18 about REJECT
- corrects typos
- introduces smoother and less crappy jargon-like vocabulary.

Please apply.

Regards,
Maciej

Index: netfilter-faq.sgml
===================================================================
RCS file: /cvspublic/netfilter/documentation/FAQ/pl/netfilter-faq.sgml,v
retrieving revision 1.6
diff -u -r1.6 netfilter-faq.sgml
--- netfilter-faq.sgml	15 Sep 2002 11:34:46 -0000	1.6
+++ netfilter-faq.sgml	26 Jun 2003 13:59:19 -0000
@@ -5,12 +5,12 @@
 <title>netfilter/iptables FAQ</title>
 <author>Harald Welte &lt;laforge@gnumonks.org&gt;&nl;
 T³umaczenie: Maciej So³tysiak<tt><htmlurl name="solt@dns.toxicfilms.tv" url="mailto:solt@dns.toxicfilms.tv"></tt></author>
-<date>Version $Revision: 1.6 $, $Date: 2002/09/15 11:34:46 $
-T³umaczenie: Czwartek 25 Lipca 2002 $</date>
+<date>Version $Revision: 1.40 $, $Date: 2003/03/06 11:37:02 $</date>
+T³umaczenie: Czwartek 26 Czerwca 2003 $</date>

 <abstract>
-Ten dokument zawiera Frequently Asked Questions napotkane na li¶cie
-mailingowej netfilter. Komentarze / dodatki / obja¶nienia s± mile widziane
+Ten dokument zawiera najczê¶ciej zadawane pytania (Frequently Asked Questions) wystêpuj±ce na li¶cie
+dyskusyjnej netfilter. Komentarze / dodatki / obja¶nienia s± mile widziane
 i powinny byæ kierowane do utrzymuj±cego FAQ.
 </abstract>

@@ -19,7 +19,7 @@
 <sect>Pytania ogólne
 <p>
 Ten rozdzia³ zawiera ogólne pytania dotycz±ce netfiltra (i nie tylko) jakie
-napotkali¶my na liscie dyskusyjnej.
+napotkali¶my na li¶cie dyskusyjnej.

 <sect1>Sk±d mogê wzi±æ netfilter/iptables?
 <p>
@@ -37,7 +37,7 @@
 <url url="http://netfilter.filewatcher.org/">.
 </sect1>

-<sect1>Czy jest wersja netfiltra na Linuxa 2.2?
+<sect1>Czy jest wersja netfiltra na Linuksa 2.2?
 <p>
 Nie, nie ma. Ale je¶li kto¶ chce zacz±æ, nie powinno to byæ zbyt trudne z
 uwagi na przejrzysty interface do stosu sieci.
@@ -47,16 +47,16 @@

 <sect1>Czy jest modu³ ICQ conntrack/NAT?
 <p>
-Je¶li jeste¶ przyzwyczajony do maskarady na Linuxach 2.2, zawsze uzywa³es
+Je¶li jeste¶ przyzwyczajony do maskarady na Linuksach 2.2, zawsze u¿ywa³e¶
 modu³u ip_masq_icq by dzia³aly bezpo¶rednie po³±czenia ICQ klient-klient.
 <p>
 Nikt nie zaimplementowa³ ponownie tego modu³u do netfiltra, poniewa¿
-protokó³ ICQ jest ochydny :) Ale my¶lê, ¿e to kwestia czasu zanim bêdzie
+protokó³ ICQ jest ohydny :) Ale my¶lê, ¿e to kwestia czasu zanim bêdzie
 dostêpny.
 <p>
 Rusty kiedy¶ wskaza³ na to, ¿e tylko modu³y dla protoko³ów z przynajmniej
 jednym wolnym klientem i jednym wolnym serwerem bêd± integrowane do
-g³ównej dystrybucji netfiltra. Co do ICQ, darmowe s± tylko klienty, wiêc
+g³ównej dystrybucji netfiltra. Co do ICQ, darmowi s± tylko klienci, wiêc
 kryteria odrzucaj± ten modu³. (wolnym w sensie swobody, nie jak wolny ¿ó³w
 czy darmowy, tj. definicja RMS - Richarda M. Stallmana)
 </sect1>
@@ -64,7 +64,7 @@
 <sect1>Co siê sta³o z modu³ami ip_masq_vdolive / ip_masq_quake?
 <p>
 Niektóre z nich nie s± wymagane, a niektóre nie zosta³y jeszcze przeniesione
-do netfiltra.  Netfilter wykonje pe³n± rejestracjê po³±czeñ (connection
+do netfiltra.  Netfilter wykonuje pe³ne ¶ledzenie po³±czeñ (connection
 tracking) nawet dla UDP i ma zasadê by nie przeszkadzaæ pakietom w miarê
 mo¿liwo¶ci, wiêc czasami to 'po prostu dzia³a'.
 </sect1>
@@ -73,13 +73,13 @@
 <p>
 J±dra 2.4.x s± stabiln± wersj±, wiêc nie mo¿emy ot tak wysy³aæ aktualnego
 kodu do g³ównego j±dra.  Ca³y kod jest rozwijany i testowany najpierw w
-netfilter patch-o-matic.  Je¶li chcesz u¿ywac której¶ z nowych funkcji
-netfiltra, bêdziesz musia³ zastosowaæ jeden lub kilka patchy z
+netfilter patch-o-matic.  Je¶li chcesz u¿ywaæ której¶ z nowych funkcji
+netfiltra, bêdziesz musia³ zastosowaæ jedn± lub kilka ³at z
 patch-o-matic.  Mo¿esz znale¼æ patch-o-matic w najnowszym pakiecie
-netfiltra (lub oczywiscie w CVS) i ¶ci±gn±æ ze strony domowej netfiltra.
+netfiltra (lub oczywi¶cie w CVS) i ¶ci±gn±æ ze strony domowej netfiltra.

 <p>
-patch-o-matic ma teraz trzy rózne opcje:
+patch-o-matic ma teraz trzy ró¿ne opcje:
 <itemize>
 <item>make pending-patches
 <item>make most-of-pom
@@ -88,10 +88,10 @@

 <p>
 Pierwszy jest po ty by upewniæ siê czy wszystkie wa¿ne poprawki (które
-zosta³y wys³ane do utrzymuj±cych kernel) s± w j±drze. Drugi `most-of-pom`
-dodatkowo pyta o nowe patche, które mo¿na zastosowaæ bez konfliktów. Trzecia
+zosta³y wys³ane do utrzymuj±cych j±dro) s± w j±drze. Drugi `most-of-pom`
+dodatkowo pyta o nowe ³aty, które mo¿na zastosowaæ bez konfliktów. Trzecia
 opcja `patch-o-matic` jest dla prawdziwych ekspertów którzy chc± widzieæ
-wszystkie patche - ale miej ¶wiadomo¶æ, mog± ze sob± konfliktowaæ.
+wszystkie ³atki - ale miej ¶wiadomo¶æ, mog± powodowaæ konflikty.
 <p>
 patch-o-matic ma fajny interfejs u¿ytkownika. Po prostu wpisz

@@ -106,8 +106,8 @@
 </verb></tscreen>

 w najwy¿szym katalogu pakietu netfilter.  patch-o-matic sprawdza czy
-ka¿dy patch zastosowa³by siê w ¿ródle j±dra jakie masz zainstalowane.
-Je¶li tak, zobaczysz opcje: mo¿esz przeczytaæ wiêcej o patchu,
+ka¿da ³atka zaaplikowa³aby siê w ¼ródle j±dra jakie masz zainstalowane.
+Je¶li tak, zobaczysz opcje: mo¿esz przeczytaæ wiêcej o ³acie,
 zastosowaæ go lub przej¶æ do nastêpnego ...

 Wiêcej informacji na temat patch-o-matic jest w netfilter extensions HOWTO.
@@ -127,23 +127,23 @@
 <sect>Problemy podczas kompilacji
 <p>

-<sect1>Nie mogê skompilowaæ iptables-1.1.1 z kernelem &gt;= 2.4.0-test4
+<sect1>Nie mogê skompilowaæ iptables-1.1.1 z j±drem &gt;= 2.4.0-test4
 <p>
-To znany problem. Mechanizm wykrywania które patche zastosowaæ jest zepsuty.
-Spróbój "make build" zamiast "make".
+To znany problem. Mechanizm wykrywania które ³aty zastosowaæ jest zepsuty.
+Spróbuj "make build" zamiast "make".

 <p>
 Lepsze rozwi±zanie: zaktualizuj do iptables-1.1.2 lub pó¼niejszych.

 </sect1>

-<sect1>Nie mogê skompilowaæ iptables 1.1.0 z ostatnimi kernelami (&gt;= 2.3.99-pre8)
+<sect1>Nie mogê skompilowaæ iptables 1.1.0 z ostatnimi j±drami (&gt;= 2.3.99-pre8)
 <p>
 Wewnêtrzne struktury w iptables zmieni³y siê. Uaktualnij iptables do &gt;= 1.1.1

 </sect1>

-<sect1>Niektóre patche patch-o-matic z iptables-1.2.1a nie dzia³aj± z kernelem &gt;= 2.4.4
+<sect1>Niektóre ³aty patch-o-matic z iptables-1.2.1a nie dzia³aj± z j±drem &gt;= 2.4.4
 <p>
 Proszê u¿yj iptables-1.2.2 lub netfilter CVS.
 </sect1>
@@ -153,16 +153,16 @@
 Najprawdopodobniej do¶wiadczasz problemów z funkcj± zwan±
 <tt>ip_nat_setup_info</tt>.
 <p>
-Je¶li u¿ywasz iptables &lt;= 1.2.2, <bf>MUSISZ</bf> zastosowaæ patche 'dropped-table' i 'ftp-fixes'.
+Je¶li u¿ywasz iptables &lt;= 1.2.2, <bf>MUSISZ</bf> zastosowaæ ³aty 'dropped-table' i 'ftp-fixes'.
 <p>
-Je¶li u¿ywasz iptables &gt; 1.2.2 lub swie¿y CVS, proszê <bf>nie</bf> stosuj
+Je¶li u¿ywasz iptables &gt; 1.2.2 lub ¶wie¿y CVS, proszê <bf>nie</bf> stosuj
 `dropped-table', gdy¿ jest niekompatybilny z BALANCE, NETMAP, irc-nat, SAME
 i talk-nat.
 </sect1>

-<sect1>Mam problemy z kernelem z patchami Alana Coxa 2.4.x-acXX
+<sect1>Mam problemy z j±drem z ³atami Alana Coxa 2.4.x-acXX
 <p>
-G³ówny zespó³ netfiltra opiera rozwój na kernelach Linusa, wiêc serii -ac
+G³ówny zespó³ netfiltra opiera rozwój na j±drach Linusa, wiêc serii -ac
 u¿ywaj na w³asne ryzyko.
 </sect1>

@@ -198,19 +198,19 @@
 <p>
 Prawdopodobne powody to:
 <itemize>
-<item>osi±gniêto maksymaln± liczbê wpisów w bazie danych ¶ledzonych po³±czeñ
+<item>osi±gniêto maksymaln± liczbê wpisów w bazie ¶ledzonych po³±czeñ
 <item>nie mo¿na okre¶liæ pakietu odpowiadaj±cego na po³±czenie (multicast, broadcast)
 <item>kmem_cache_alloc zawodzi (brak pamiêci)
 <item>odpowied¼ na niepotwierdzone po³±czenie
-<item>pakiet mulitcastowy (zobacz poprzednie pytanie)
+<item>pakiet multicastowy (zobacz poprzednie pytanie)
 <item>pakiet icmp jest za krótki
 <item>pakiet icmp jest sfragmentowany
-<item>pakiet icmp ma z³± suma kontroln±
+<item>pakiet icmp ma z³± sumê kontroln±
 </itemize>

 <p>
-Je¶li chcesz mieæ bardziej szczegó³owe logowanie tych pakietów (tj. je¶li
-podejrzewasz, ze to remote probe / pakiety skanuj±ce), u¿yj nastêpuj±cej
+Je¶li chcesz bardziej szczegó³owo logowaæ te pakiety (tj. je¶li
+podejrzewasz, ¿e to zdalna sonda (remote probe) / pakiety skanuj±ce), u¿yj nastêpuj±cej
 regu³ki:
 <tscreen><verb>
 iptables -t mangle -A PREROUTING -j LOG -m state --state INVALID
@@ -229,39 +229,39 @@
 Ale kto¶ pisze nowy bridging code, zerknij na <url url="http://bridge.sourceforge.net/">
 <p>
 Zauwa¿, ¿e wsparcie dla bridge'uj±cego firewalla jest uwa¿ane za skrajnie
-ekperymentalne.
+eksperymentalne.

 </sect1>

 <sect1>Modu³ IRC nie obs³uguje DCC RESUME
 <p>
-Wiêc, jest to po³owiczna prawda. Tylko modu³ NAT nie jest w stanie obs³u¿yæ
-ich.  Je¶li firewallujesz bez NATa, powinno dzia³aæ.
+Jest to po³owiczna prawda. Tylko modu³ NAT nie jest w stanie obs³u¿yæ ich.
+Je¶li jest to firewall bez NAT, powinno dzia³aæ.

 </sect1>

-<sect1>Jak dzia³a SNAT do wielu adresow?
+<sect1>Jak dzia³a SNAT do wielu adresów?
 <p>
 Netfilter stara siê jak najmniej zmieniaæ pakiety. Wiêc je¶li mamy
-swie¿o-prze³adowan± maszynê i kto¶ za SNAT'em otwiera po³±czenie z loklanym
+¶wie¿o-prze³adowan± maszynê i kto¶ za SNAT'em otwiera po³±czenie z loklanym
 portem 1234, netfilter tylko zmienia adres IP a port zostaje ten sam.
 <p>
 Jak tylko kto¶ inny otworzy inne po³±czenie z tym samym ¼ród³owym portem,
 netfilter musia³by zmieniæ IP i port je¶li ma tylko jeden IP dla SNAT.
 <p>
 Ale je¶li jest dostêpny wiêcej ni¿ jeden, <bf>ponownie</bf> tylko musi
-zmieniac czê¶æ IP.
+zmieniaæ czê¶æ IP.
 </sect1>

 <sect1>ip_conntrack: maximum limit of XXX entries exceeded
 <p>
 Je¶li zauwa¿ysz nastêpuj±ce wpisy w syslogu, wygl±da na to, ¿e baza danych
 conntrack nie ma wystarczaj±cego miejsca na twoje ¶rodowisko. Connection
-tracking domy¶lnie obs³uguje do pewnego poziomu liczbê wspolbie¿nych po³±czeñ.
+tracking domy¶lnie obs³uguje do pewnego poziomu liczbê wspó³bie¿nych po³±czeñ.
 Ta liczba zale¿y od rozmiaru pamiêci (przy 64MB: 4096, 128MB: 8192, ...).
 <p>
 Mo¿esz z ³atwo¶ci± zwiêkszyæ maksymaln± liczbê rejestrowanych po³±czeñ, ale
-miej na uwadze, ¿e ka¿de po³±czenie zjada oko³o 350 bajtów nie-swappowalnej
+miej na uwadze, ¿e ka¿de po³±czenie zjada oko³o 350 bajtów nieswappowalnej
 pamiêci j±dra.
 <p>
 By zwiêkszyæ ten limit do np 8192, wpisz:
@@ -272,7 +272,7 @@

 </sect1>

-<sect1>Jak wylistowaæ trackowane / maskaradowane po³±czenia, podobnie jak 'ipchains -L -M' w 2.2.x
+<sect1>Jak wylistowaæ ¶ledzone / maskaradowane po³±czenia, podobnie jak 'ipchains -L -M' w 2.2.x
 <p>
 Jest plik w filesystemie proc, zwany <tt>/proc/net/ip_conntrack</tt>.
 Mo¿esz wy¶wietliæ jego zawarto¶æ pisz±c:
@@ -292,33 +292,33 @@

 <sect1>iptables-save / iptables-restore z iptables-1.2 wywala segfaulty
 <p>
-Znany Bug.  Uaktualnij do naj¶wie¿szego CVS lub u¿yj iptables &gt;= 1.2.1
+Znany b³±d.  Uaktualnij do naj¶wie¿szego CVS lub u¿yj iptables &gt;= 1.2.1
 jak tylko bêdzie dostêpne.
 </sect1>

 <sect1>Mijaj± wieki zanim iptables -L wy¶wietli regu³ki
 <p>
-To dlatego, ¿e iptables robi DNS lookup dla ka¿dego adresu. Jako¿e ka¿da
+To dlatego, ¿e iptables robi DNS lookup dla ka¿dego adresu. Jako ¿e ka¿da
 regu³ka sk³ada siê z dwu adresów, w najgorszym przypadku wychodzi na 2
-DNS lookupy na regu³ke.
+DNS lookupy na regu³kê.
 <p>
 Problem jest, je¶li u¿ywasz prywatnych adresów IP (10.x.x.x lub 192.168.x.x),
 DNS nie jest w stanie rozwi±zaæ nazwy hosta i czekamy na timeout. Suma
 wszystkich timeoutów mo¿e byæ bardzo du¿a, w zale¿no¶ci od zestawu regu³ek.
 <p>
-U¿ywaj opcji -n (numeric) w iptables by pomin±c reverse DNS lookups.
+U¿ywaj opcji -n (numeric) w iptables by pomin±æ reverse DNS lookups.
 </sect1>

-<sect1>Jak zrobiæ by target LOG nie logowa³ na konsole?
+<sect1>Jak zrobiæ by target LOG nie logowa³ na konsolê?
 <p>
 Musisz skonfigurowaæ syslogd odpowiednio:
-Target LOG loguje do facility kern przy priorytecie warining (4).
+Target LOG loguje do facility kern przy priorytecie warning (4).
 Zobacz strony man od syslogd.conf by przeczytaæ wiêcej o facilities i
 priorytetach.
 <p>
 Domy¶lnie, wszystkie wiadomo¶ci na priorytecie bardziej powa¿nym ni¿ debug (7)
 s± wysy³ane na konsole. Je¶li zwiêkszysz to do 4, zamiast 7, sprawisz, ¿e
-logi nie bed± siê pojawia³y na konsoli.
+logi nie bêd± siê pojawia³y na konsoli.
 <p>
 Miej na uwadze, ¿e to tak¿e poci±ga za sob± inne wa¿ne logi i nie pojawi±
 siê na konsoli (to nie wp³ywa na syslog).
@@ -352,12 +352,12 @@

 <sect1>Jak u¿ywaæ target LOG / Jak mogê LOGowac i DROPowac?
 <p>
-Target LOG jest czym¶ co nazywamy "nie-koñcz±cy target", tj. nie koñczy
+Target LOG jest czym¶ co nazywamy "niekoñcz±cy target", tj. nie koñczy
 podró¿y pakietu.  Je¶li u¿yjesz target LOG, pakiet bêdzie zalogowany i
 podró¿ bêdzie kontynuowana od nastêpnej regu³ki.
 <p>
 Wiêc jak mam logowaæ i zrzucaæ pakiet jednocze¶nie? Nic prostszego, mo¿esz
-stworzyæ w³asny chain, zawieraj±cy te dwie regu³ki:
+stworzyæ w³asny ³añcuch, zawieraj±cy te dwie regu³ki:

 <tscreen><verb>
 iptables -N logdrop
@@ -366,7 +366,7 @@
 </verb></tscreen>
 <p>
 Teraz za ka¿dym razem jak bêdziesz chcia³ logowaæ i zrzuciæ pakiet, mo¿esz
-po prostu u¿yc "-j logdrop".
+po prostu u¿yæ "-j logdrop".

 </sect1>

@@ -375,20 +375,20 @@
 Krótka odpowiedz brzmi: nie da siê tego zrobiæ prawid³owo u¿ywaj±c
 netfiltra. Wiêkszo¶æ robaków u¿ywa prawid³owych protoko³ów wy¿szej warstwy
 (tj. HTTP, SMTP (np. VB script w za³±czniku listu), lub wykorzystuje
-jak±kolwiek inn± znan± dziurê w demonie obs³uguj±cym protokó³). Mowi±c
+jak±kolwiek inn± znan± dziurê w demonie obs³uguj±cym protokó³). Mówi±c
 protokó³ wy¿szych wartsw, mamy na my¶li ponad TCP/IP. Jako ¿e iptables nie
 rozumie protoko³ów wy¿szych wartsw, jest prawie nie mo¿liwe filtrowanie ich
 prawid³owo. Do tego potrzeba proxy filtruj±cych na poziomie aplikacji.
 <p>
-Proszê nie u¿ywaj matchu strign z patch-o-matic zamiast takiej aplikacji.
+Proszê nie u¿ywaj matchu string z patch-o-matic zamiast takiej aplikacji.
 Nie da rady sobie z fragmentowanymi pakietami (tj. zapytanie HTTP rozbite na
 dwa pakiety TCP), z technikami unikania systemów IDS, itd... zosta³e¶
 ostrze¿ony! Match string jest przydatny ale w innych celach.
 </sect1>

-<sect1>kernel loguje: Out of windows data xxx
+<sect1>j±dro loguje: Out of windows data xxx
 <p>
-U¿ywasz patcha tcp-window-tracking z patch-o-matic, którego kod ¶ledzi czy
+U¿ywasz ³aty tcp-window-tracking z patch-o-matic, którego kod ¶ledzi czy
 pakiety dopuszczonych strumieni TCP maj± zgodne numery
 sekwencji/potwierdzenia (sequence/acknowledgement), rozmiary segmentów, itd.
 pakietów. Kiedy wykryje, ¿e pakiet jest nieakceptowalny (out of the window),
@@ -402,7 +402,7 @@
 <item>SEQ is over the upper bound (ponad oknem odbiorczym)
 </itemize>
 <p>
-Takze, w nowszych wersjach logowanie mo¿na ca³kowicie wy³±czyæ poprzez
+Tak¿e, w nowszych wersjach logowanie mo¿na ca³kowicie wy³±czyæ poprzez
 sysctl
 <tscreen><verb>
 echo 0 > /proc/sys/net/ipv4/netfilter/ip_ct_tcp_log_out_of_window
@@ -410,7 +410,7 @@

 </sect1>

-<sect1>Dlaczego system ¶ledzenia po³±czeñ (connectrion tracking) ¶ledzi po³±czenia UNREPLIED (bez odpowiedzi) z du¿ym timeoutem?
+<sect1>Dlaczego system ¶ledzenia po³±czeñ (connection tracking) ¶ledzi po³±czenia UNREPLIED (bez odpowiedzi) z du¿ym timeoutem?

 <p>
 Sprawdzi³e¶ /proc/net/ip_conntrack i znalaz³e¶ wpisy po³±czeñ w stanie
@@ -426,9 +426,29 @@
 </sect1>
 <sect1>Dlaczego nie zaimplementowano opcji 'iptables -C' (--check) ?

+<p>
+Po pierwsze dlatego, ¿e jeste¶my leniwi ;). A szczerze mówi±c, implementacja
+opcji check jest prawie niemo¿liwa jak tylko zaczynamy stateful firewalling.
+Tradycyjne firewalle nie przetrzymuj±ce informacji o stanie po³±czenia
+(s± stateless) opieraj± swoje decyzje tylko w oparciu o informacje zawarte
+w nag³ówkach pakietów. A ¿e ¶ledzeniem po³±czeñ (i regu³ami opartymi o '-m
+state'), decyzja o filtrowaniu zale¿y od nag³ówka+dane, a tak¿e od
+nag³ówka+dane poprzednich pakietów danego po³±czenia.
+
+
+</sect1>
+
+<sect1>Dlaczego nie mogê u¿ywaæ REJECT w ³añcuchu PREROUTING?
+<p>
+Target REJECT s³u¿y do filtrowania. Tabela filter ma ³añcuchy
+INPUT/OUTPUT/FORWARD, zatem REJECT mo¿e byæ tylko u¿ywany w tych ³añcuchach
+(i pod³añcuchach, naturalnie).
+
+U¿ytkownicy netfiltra nie filtruj± pakietów w tabeli nat czy mangle.
 </sect1>
 </sect>

+
 <sect>Pytania o rozwój netfiltra

 <sect1>Nie rozumiem jak u¿ywaæ target QUEUE z przestrzeni u¿ytkownika (userspace)
@@ -458,18 +478,18 @@

 </sect1>

-<sect1>Moja aplikacja libipq mowi "Failed to receive netlink message: No buffer space available"
+<sect1>Moja aplikacja oparta na libipq zg³asza "Failed to receive netlink message: No buffer space available"
 <p>
-Oznacza to, ze bufor socketu Netlink po stronie kernela wyczerpa³ pamiêc;
+Oznacza to, ¿e bufor gniazda (socket) Netlink po stronie j±dra wyczerpa³ pamiêæ;
 aplikacja przestrzeni u¿ytkownika nie jest w stanie obs³u¿yæ ilo¶ci danych
 dostarczonych z j±dra.
 <p>
 <quote><em>Czy jest mo¿liwe by zwiêkszyæ bufory j±dra bym nie wpada³ na ten
 problem?</em></quote>
 <p>
-Tak, s± to standardowe sockety Netlink i mo¿esz dostroiæ rozmiary buforów
+Tak, s± to standardowe gniazda (sockety) Netlink i mo¿esz dostroiæ rozmiary buforów
 wej¶ciowych (receive buffer) poprzez /proc/sys/net/core, sysctl lub u¿ywaæ
-opcji socketa SO_RCVBUF na deskryptorze pliku.
+opcji gniazda (socketa) SO_RCVBUF na deskryptorze pliku.
 <p>
 Mo¿esz tak¿e spróbowaæ zapewniæ by aplikacja czyta³a dane najszybciej jak to
 jest mo¿liwe. Je¶li nie potrzebujesz ca³ego pakiety, spróbuj kopiowaæ mniej
@@ -485,14 +505,14 @@
 pobraæ przez CVSweb <url url="http://cvs.netfilter.org/cgi-bin/cvsweb/netfilter/TODO/">
 </sect1>

-<sect1>Naprawi³em buga lub napisa³em nowy modu³. Co mam zrobic?
+<sect1>Naprawi³em b³±d lub napisa³em nowy modu³. Co mam zrobiæ?
 <p>
-Je¶li chcesz to opublikowaæ, wy¶lij to listy mailingowej netfilter-devel.
+Je¶li chcesz to opublikowaæ, wy¶lij to listy dyskusyjnej netfilter-devel.
 Instrukcja jak zostaæ subskrybentem jest w <url url="http://lists.netfilter.org/mailman/listinfo/netfilter-devel/">.

-Prawid³owy sposób wysy³ania patchy:
+Prawid³owy sposób wysy³ania ³at:
 <itemize>
-<item> Temat zaczynaj±cy sie <bf>&#91;PATCH&#93;</bf>
+<item> Temat zaczynaj±cy siê od <bf>&#91;PATCH&#93;</bf>
 <item> Za³±czone prosto w ciele wiadomo¶ci, bez MIME.
 <item> wpis cvs-checkin/Changelog poza diffem.
 <item> forma `diff -u old new', spoza katalogu root pakietu (tj. mo¿e byæ stosowany z -p1 bêd±c pod odtarowanym katalogiem.
@@ -501,7 +521,7 @@
 Je¶li napisa³e¶ nowe rozszerzenie, lub doda³e¶ nowe opcje do starego
 rozszerzenia, zwykle dobrze jest zaktualizowaæ tak¿e
 netfilter-extension-HOWTO by w³±czyæ opis nowej funkcjonalno¶ci. Dodatkowo,
-przyci±gnie to wiêcej u¿tykowników do rozszerzenia i pozwoli na uzyskanie
+przyci±gnie to wiêcej u¿ytkowników do rozszerzenia i pozwoli na uzyskanie
 wiêcej informacji od u¿ytkowników.
 </sect1>
