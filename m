From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH] Small fixes to Polish FAQ
Date: Fri, 13 Sep 2002 20:53:41 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0209132051260.8309-200000@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-23717851-866014116-1031943221=:8309"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---23717851-866014116-1031943221=:8309
Content-Type: TEXT/PLAIN; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT

Hi,

Here are some small fixes to the FAQ/pl.

Unfortunately, the Netfilter website still contains the old, unupdated
FAQ, i have written to the webmaster but there was no response :(

Regards,
Maciej Soltysiak

diff -Nru /netfilter.old/documentation/FAQ/pl/netfilter-faq.sgml /netfilter/documentation/FAQ/pl/netfilter-faq.sgml
--- /netfilter.old/documentation/FAQ/pl/netfilter-faq.sgml	Fri Jul 26 22:19:42 2002
+++ /netfilter/documentation/FAQ/pl/netfilter-faq.sgml	Fri Sep 13 20:43:00 2002
@@ -410,12 +410,11 @@

 </sect1>

-<sect1>Dlaczego system ¶ledzenia po³±czeñ (connectrion tracking) ¶ledzi
-po³±czenia UNREPLIED (bez odpowiedzi) z du¿ym timeoutem?
+<sect1>Dlaczego system ¶ledzenia po³±czeñ (connectrion tracking) ¶ledzi po³±czenia UNREPLIED (bez odpowiedzi) z du¿ym timeoutem?

 <p>
 Sprawdzi³e¶ /proc/net/ip_conntrack i znalaz³e¶ wpisy po³±czeñ w stanie
-UNREPLIED o bardzo wysokim licznik (a¿ do piêciu dni) i zastanawiasz siê
+UNREPLIED o bardzo wysokim czasie (a¿ do piêciu dni) i zastanawiasz siê
 dlaczego marnujemy wpisy conntrack (które oczywi¶cie nie s± po³±czeniami)?
 <p>
 Odpowied¼ jest prosta: wpisy UNREPLIED s± tymczasowe, tj. jak tylko
@@ -459,8 +458,7 @@

 </sect1>

-<sect1>Moja aplikacja libipq mowi "Failed to receive netlink message: No
-buffer space available"
+<sect1>Moja aplikacja libipq mowi "Failed to receive netlink message: No buffer space available"
 <p>
 Oznacza to, ze bufor socketu Netlink po stronie kernela wyczerpa³ pamiêc;
 aplikacja przestrzeni u¿ytkownika nie jest w stanie obs³u¿yæ ilo¶ci danych

---23717851-866014116-1031943221=:8309
Content-Type: TEXT/plain; name="faq_pl_small_fixes.diff"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0209132053410.8309@dns.toxicfilms.tv>
Content-Description: faq_pl
Content-Disposition: attachment; filename="faq_pl_small_fixes.diff"

ZGlmZiAtTnJ1IC9uZXRmaWx0ZXIub2xkL2RvY3VtZW50YXRpb24vRkFRL3Bs
L25ldGZpbHRlci1mYXEuc2dtbCAvbmV0ZmlsdGVyL2RvY3VtZW50YXRpb24v
RkFRL3BsL25ldGZpbHRlci1mYXEuc2dtbA0KLS0tIC9uZXRmaWx0ZXIub2xk
L2RvY3VtZW50YXRpb24vRkFRL3BsL25ldGZpbHRlci1mYXEuc2dtbAlGcmkg
SnVsIDI2IDIyOjE5OjQyIDIwMDINCisrKyAvbmV0ZmlsdGVyL2RvY3VtZW50
YXRpb24vRkFRL3BsL25ldGZpbHRlci1mYXEuc2dtbAlGcmkgU2VwIDEzIDIw
OjQzOjAwIDIwMDINCkBAIC00MTAsMTIgKzQxMCwxMSBAQA0KIA0KIDwvc2Vj
dDE+DQogDQotPHNlY3QxPkRsYWN6ZWdvIHN5c3RlbSC2bGVkemVuaWEgcG+z
sWN6ZfEgKGNvbm5lY3RyaW9uIHRyYWNraW5nKSC2bGVkemkNCi1wb7OxY3pl
bmlhIFVOUkVQTElFRCAoYmV6IG9kcG93aWVkemkpIHogZHW/eW0gdGltZW91
dGVtPw0KKzxzZWN0MT5EbGFjemVnbyBzeXN0ZW0gtmxlZHplbmlhIHBvs7Fj
emXxIChjb25uZWN0cmlvbiB0cmFja2luZykgtmxlZHppIHBvs7FjemVuaWEg
VU5SRVBMSUVEIChiZXogb2Rwb3dpZWR6aSkgeiBkdb95bSB0aW1lb3V0ZW0/
DQogDQogPHA+DQogU3ByYXdkemmzZbYgL3Byb2MvbmV0L2lwX2Nvbm50cmFj
ayBpIHpuYWxherNltiB3cGlzeSBwb7OxY3pl8SB3IHN0YW5pZQ0KLVVOUkVQ
TElFRCBvIGJhcmR6byB3eXNva2ltIGxpY3puaWsgKGG/IGRvIHBp6mNpdSBk
bmkpIGkgemFzdGFuYXdpYXN6IHNp6g0KK1VOUkVQTElFRCBvIGJhcmR6byB3
eXNva2ltIGN6YXNpZSAoYb8gZG8gcGnqY2l1IGRuaSkgaSB6YXN0YW5hd2lh
c3ogc2nqDQogZGxhY3plZ28gbWFybnVqZW15IHdwaXN5IGNvbm50cmFjayAo
a3TzcmUgb2N6eXdptmNpZSBuaWUgc7EgcG+zsWN6ZW5pYW1pKT8NCiA8cD4N
CiBPZHBvd2llZLwgamVzdCBwcm9zdGE6IHdwaXN5IFVOUkVQTElFRCBzsSB0
eW1jemFzb3dlLCB0ai4gamFrIHR5bGtvDQpAQCAtNDU5LDggKzQ1OCw3IEBA
DQogDQogPC9zZWN0MT4NCiANCi08c2VjdDE+TW9qYSBhcGxpa2FjamEgbGli
aXBxIG1vd2kgIkZhaWxlZCB0byByZWNlaXZlIG5ldGxpbmsgbWVzc2FnZTog
Tm8NCi1idWZmZXIgc3BhY2UgYXZhaWxhYmxlIg0KKzxzZWN0MT5Nb2phIGFw
bGlrYWNqYSBsaWJpcHEgbW93aSAiRmFpbGVkIHRvIHJlY2VpdmUgbmV0bGlu
ayBtZXNzYWdlOiBObyBidWZmZXIgc3BhY2UgYXZhaWxhYmxlIg0KIDxwPg0K
IE96bmFjemEgdG8sIHplIGJ1Zm9yIHNvY2tldHUgTmV0bGluayBwbyBzdHJv
bmllIGtlcm5lbGEgd3ljemVycGGzIHBhbWnqYzsNCiBhcGxpa2FjamEgcHJ6
ZXN0cnplbmkgdb95dGtvd25pa2EgbmllIGplc3QgdyBzdGFuaWUgb2Jzs3W/
eeYgaWxvtmNpIGRhbnljaA0K
---23717851-866014116-1031943221=:8309--
