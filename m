From: "Maciej Soltysiak" <solt@dns.toxicfilms.tv>
Subject: [PATCH] Polish FAQ update
Date: Thu, 11 Dec 2003 11:15:49 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <001d01c3bfcf$c0263210$0e25fe0a@southpark.ae.poznan.pl>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_001A_01C3BFD8.21C47470"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_001A_01C3BFD8.21C47470
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 8bit

Hi,

this patch fixes my screwups with the translation.

Also I'd like to point out, that there is a problem with
sgmltools and linuxdoc-tools. They both have has bad translations of
polish words for:
Next, Previous, Index
They have:
Nastny, Poprzedni, Spis Trei
instead of:
Nastêpny, Poprzedni, Spis Tre¶ci

I have just sent the patch to the maintainer of Lang.pm.
You might want to patch your
/usr/share/linuxdoc-tools/LinuxDocTools/Lang.pm
(or whatever the path is for Lang.pm)
with the Lang.pm.diff patch.

I can't belive it hasn't been fixed yet. I have noticed it about 1,5 year
ago :-|
Okay, here they go: FAQ patch, Lang.pm patch.


Index: documentation/FAQ/pl/netfilter-faq.sgml
===================================================================
RCS file: /cvspublic/netfilter/documentation/FAQ/pl/netfilter-faq.sgml,v
retrieving revision 1.8
diff -u -r1.8 netfilter-faq.sgml
--- documentation/FAQ/pl/netfilter-faq.sgml 16 Oct 2003 07:36:38 -0000 1.8
+++ documentation/FAQ/pl/netfilter-faq.sgml 11 Dec 2003 10:03:45 -0000
@@ -4,10 +4,8 @@

 <title>netfilter/iptables FAQ</title>
 <author>Harald Welte &lt;laforge@gnumonks.org&gt;&nl;
-<date>Version $Revision: 1.8 $, $Date: 2003/10/16 07:36:38 $</date>
+<date>Version $Revision: 1.9 $, $Date: 2003/12/11 10:55:39 $</date>
 T³umaczenie: Maciej So³tysiak<tt><htmlurl name="solt@dns.toxicfilms.tv"
url="mailto:solt@dns.toxicfilms.tv"></tt></author>
-<date>Version $Revision: 1.8 $, $Date: 2003/10/16 07:36:38 $</date>
-T³umaczenie: ¦roda 15 Pa¼dziernika 2003 $</date>

 <abstract>
 Ten dokument zawiera najczê¶ciej zadawane pytania (Frequently Asked
Questions) wystêpuj±ce na li¶cie
@@ -123,8 +121,6 @@
 jest w iptables. Zerknij w NAT HOWTO na stronach domowych netfiltra.
 </sect1>

-</sect>
-
 <sect1>Czy iptables/ip6tables jest w stanie zrobiæ IPv6 NAT?
 <p>
 Nie, rdzeñ NAT nie obs³uguje transjacji IPv6 lub IPv6/IPv4 jakiegokolwiek
@@ -144,8 +140,6 @@
 </sect1>

 <sect1>Czy netfilter/iptables wspiera failover/HA?
-
-Does netfilter/iptables support failover/HA?
 <p>
 Odpowied¼ jest prosta 'tak' i 'nie'.
 <p>
@@ -159,7 +153,7 @@
 <p>Je¶li chcesz przechowaæ po³±czenia NAT: <bf>Nie</bf>.
 <p>Je¶li filtrujesz bez przechowywania stanu (stateless): <bf>Tak</bf>
 </sect1>
-
+</sect>


 <sect>Problemy podczas kompilacji
@@ -280,9 +274,7 @@
 <tscreen><verb>
 ip_conntrack: max number of expected connections N of M reached for
aaa.aaa.aaa.aaa -> bbb.bbb.bbb.bbb
 </verb></tscreen>
-</sect1>

-<sect1>
 <p>
 Zasadniczo nie ma siê czym przejmowaæ, szczególnie gdy <tt>N</tt> i
 <tt>M</tt> sa <tt>1</tt>, a po tej wiadomo¶ci jest <tt>, reusing</tt>.


--- Lang.pm~ 2002-03-25 14:46:40.000000000 +0100
+++ Lang.pm 2003-12-11 11:07:41.000000000 +0100
@@ -185,7 +185,7 @@
      "it" => "Avanti",
      "ro" => "Înainte",
      "ja" => "¼¡¤Î¥Ú¡¼¥¸",
-     "pl" => "Nastny",
+     "pl" => "Nastêpny",
      "ko" => "´ÙÀ½"
   },
   "Contents" => {
@@ -201,7 +201,7 @@
      "it" => "Indice",
      "ro" => "Cuprins",
      "ja" => "ÌÜ¼¡¤Ø",
-     "pl" => "Spis Trei",
+     "pl" => "Spis Tre¶ci",
      "ko" => "Â÷·Ê"
   },
   "Table of Contents" => {
@@ -217,7 +217,7 @@
      "it" => "Indice Generale",
      "ro" => "Cuprins",
      "ja" => "ÌÜ¼¡",
-     "pl" => "Spis Trei",
+     "pl" => "Spis Tre¶ci",
      "ko" => "Â÷·Ê"
   }
 };

------=_NextPart_000_001A_01C3BFD8.21C47470
Content-Type: application/octet-stream;
	name="Lang.pm.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="Lang.pm.diff"

--- Lang.pm~	2002-03-25 14:46:40.000000000 +0100=0A=
+++ Lang.pm	2003-12-11 11:07:41.000000000 +0100=0A=
@@ -185,7 +185,7 @@=0A=
      "it" =3D> "Avanti",=0A=
      "ro" =3D> "=CEnainte",=0A=
      "ja" =3D> "=BC=A1=A4=CE=A5=DA=A1=BC=A5=B8",=0A=
-     "pl" =3D> "Nastny",=0A=
+     "pl" =3D> "Nast=EApny",=0A=
      "ko" =3D> "=B4=D9=C0=BD"=0A=
   },=0A=
   "Contents" =3D> {=0A=
@@ -201,7 +201,7 @@=0A=
      "it" =3D> "Indice",=0A=
      "ro" =3D> "Cuprins",=0A=
      "ja" =3D> "=CC=DC=BC=A1=A4=D8",=0A=
-     "pl" =3D> "Spis Trei",=0A=
+     "pl" =3D> "Spis Tre=B6ci",=0A=
      "ko" =3D> "=C2=F7=B7=CA"=0A=
   },=0A=
   "Table of Contents" =3D> {=0A=
@@ -217,7 +217,7 @@=0A=
      "it" =3D> "Indice Generale",=0A=
      "ro" =3D> "Cuprins",=0A=
      "ja" =3D> "=CC=DC=BC=A1",=0A=
-     "pl" =3D> "Spis Trei",=0A=
+     "pl" =3D> "Spis Tre=B6ci",=0A=
      "ko" =3D> "=C2=F7=B7=CA"=0A=
   }=0A=
 };=0A=

------=_NextPart_000_001A_01C3BFD8.21C47470
Content-Type: application/octet-stream;
	name="faq.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="faq.diff"

Index: documentation/FAQ/pl/netfilter-faq.sgml=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
RCS file: /cvspublic/netfilter/documentation/FAQ/pl/netfilter-faq.sgml,v=0A=
retrieving revision 1.8=0A=
diff -u -r1.8 netfilter-faq.sgml=0A=
--- documentation/FAQ/pl/netfilter-faq.sgml	16 Oct 2003 07:36:38 -0000	=
1.8=0A=
+++ documentation/FAQ/pl/netfilter-faq.sgml	11 Dec 2003 10:03:45 -0000=0A=
@@ -4,10 +4,8 @@=0A=
 =0A=
 <title>netfilter/iptables FAQ</title>=0A=
 <author>Harald Welte &lt;laforge@gnumonks.org&gt;&nl;=0A=
-<date>Version $Revision: 1.8 $, $Date: 2003/10/16 07:36:38 $</date>=0A=
+<date>Version $Revision: 1.9 $, $Date: 2003/12/11 10:55:39 $</date>=0A=
 T=B3umaczenie: Maciej So=B3tysiak<tt><htmlurl =
name=3D"solt@dns.toxicfilms.tv" =
url=3D"mailto:solt@dns.toxicfilms.tv"></tt></author>=0A=
-<date>Version $Revision: 1.8 $, $Date: 2003/10/16 07:36:38 $</date>=0A=
-T=B3umaczenie: =A6roda 15 Pa=BCdziernika 2003 $</date>=0A=
 =0A=
 <abstract>=0A=
 Ten dokument zawiera najcz=EA=B6ciej zadawane pytania (Frequently Asked =
Questions) wyst=EApuj=B1ce na li=B6cie=0A=
@@ -123,8 +121,6 @@=0A=
 jest w iptables. Zerknij w NAT HOWTO na stronach domowych netfiltra.=0A=
 </sect1>=0A=
 =0A=
-</sect>=0A=
-=0A=
 <sect1>Czy iptables/ip6tables jest w stanie zrobi=E6 IPv6 NAT?=0A=
 <p>=0A=
 Nie, rdze=F1 NAT nie obs=B3uguje transjacji IPv6 lub IPv6/IPv4 =
jakiegokolwiek=0A=
@@ -144,8 +140,6 @@=0A=
 </sect1>=0A=
 =0A=
 <sect1>Czy netfilter/iptables wspiera failover/HA?=0A=
-=0A=
-Does netfilter/iptables support failover/HA?=0A=
 <p>=0A=
 Odpowied=BC jest prosta 'tak' i 'nie'.=0A=
 <p>=0A=
@@ -159,7 +153,7 @@=0A=
 <p>Je=B6li chcesz przechowa=E6 po=B3=B1czenia NAT: <bf>Nie</bf>.=0A=
 <p>Je=B6li filtrujesz bez przechowywania stanu (stateless): <bf>Tak</bf>=0A=
 </sect1>=0A=
-=0A=
+</sect>=0A=
 =0A=
 =0A=
 <sect>Problemy podczas kompilacji=0A=
@@ -280,9 +274,7 @@=0A=
 <tscreen><verb>=0A=
 ip_conntrack: max number of expected connections N of M reached for =
aaa.aaa.aaa.aaa -> bbb.bbb.bbb.bbb=0A=
 </verb></tscreen>=0A=
-</sect1>=0A=
 =0A=
-<sect1>=0A=
 <p>=0A=
 Zasadniczo nie ma si=EA czym przejmowa=E6, szczeg=F3lnie gdy <tt>N</tt> =
i=0A=
 <tt>M</tt> sa <tt>1</tt>, a po tej wiadomo=B6ci jest <tt>, reusing</tt>.=0A=

------=_NextPart_000_001A_01C3BFD8.21C47470--
