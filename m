From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH][TRIVIAL] remove unused callback in ip6t_ipv6header.c
Date: Wed, 10 Sep 2003 17:18:48 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0309101716380.14549@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-23717851-823584273-1063207128=:14549"
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---23717851-823584273-1063207128=:14549
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi,

this patch adds a patch to patch-o-matic/pedning directory that
removes an unused destroy callback in ip6_ipv6header.c

Regards,
Maciej

Looks like this:


diff -Nru netfilter.orig/patch-o-matic/pending/64_ipv6header.patch netfilter/patch-o-matic/pending/64_ipv6header.patch
--- netfilter.orig/patch-o-matic/pending/64_ipv6header.patch	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/pending/64_ipv6header.patch	2003-09-10 17:15:07.000000000 +0200
@@ -0,0 +1,24 @@
+diff -u linux.orig/net/ipv6/netfilter/ip6t_ipv6header.c linux/net/ipv6/netfilter/ip6t_ipv6header.c
+--- linux.orig/net/ipv6/netfilter/ip6t_ipv6header.c	2003-07-27 19:12:09.000000000 +0200
++++ linux/net/ipv6/netfilter/ip6t_ipv6header.c	2003-09-02 00:19:01.295173544 +0200
+@@ -129,20 +129,12 @@
+ 	return 1;
+ }
+
+-static void
+-ipv6header_destroy(void *matchinfo,
+-		   unsigned int matchinfosize)
+-{
+-	return;
+-}
+-
+ static struct ip6t_match
+ ip6t_ipv6header_match = {
+ 	{ NULL, NULL },
+ 	"ipv6header",
+ 	&ipv6header_match,
+ 	&ipv6header_checkentry,
+-	&ipv6header_destroy,
+ 	THIS_MODULE
+ };
+
diff -Nru netfilter.orig/patch-o-matic/pending/64_ipv6header.patch.help netfilter/patch-o-matic/pending/64_ipv6header.patch.help
--- netfilter.orig/patch-o-matic/pending/64_ipv6header.patch.help	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/pending/64_ipv6header.patch.help	2003-09-10 17:12:04.000000000 +0200
@@ -0,0 +1,4 @@
+Author: Maciej Soltysiak
+Status: Trivial
+
+This patch removes unused destroy callback in ip6t_ipv6header.c
---23717851-823584273-1063207128=:14549
Content-Type: TEXT/plain; name="ipv6header_unused_callback.diff"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.51.0309101718480.14549@dns.toxicfilms.tv>
Content-Description: unused_callback.diff
Content-Disposition: attachment; filename="ipv6header_unused_callback.diff"

ZGlmZiAtTnJ1IG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMvcGVuZGlu
Zy82NF9pcHY2aGVhZGVyLnBhdGNoIG5ldGZpbHRlci9wYXRjaC1vLW1hdGlj
L3BlbmRpbmcvNjRfaXB2NmhlYWRlci5wYXRjaA0KLS0tIG5ldGZpbHRlci5v
cmlnL3BhdGNoLW8tbWF0aWMvcGVuZGluZy82NF9pcHY2aGVhZGVyLnBhdGNo
CTE5NzAtMDEtMDEgMDE6MDA6MDAuMDAwMDAwMDAwICswMTAwDQorKysgbmV0
ZmlsdGVyL3BhdGNoLW8tbWF0aWMvcGVuZGluZy82NF9pcHY2aGVhZGVyLnBh
dGNoCTIwMDMtMDktMTAgMTc6MTU6MDcuMDAwMDAwMDAwICswMjAwDQpAQCAt
MCwwICsxLDI0IEBADQorZGlmZiAtdSBsaW51eC5vcmlnL25ldC9pcHY2L25l
dGZpbHRlci9pcDZ0X2lwdjZoZWFkZXIuYyBsaW51eC9uZXQvaXB2Ni9uZXRm
aWx0ZXIvaXA2dF9pcHY2aGVhZGVyLmMNCistLS0gbGludXgub3JpZy9uZXQv
aXB2Ni9uZXRmaWx0ZXIvaXA2dF9pcHY2aGVhZGVyLmMJMjAwMy0wNy0yNyAx
OToxMjowOS4wMDAwMDAwMDAgKzAyMDANCisrKysgbGludXgvbmV0L2lwdjYv
bmV0ZmlsdGVyL2lwNnRfaXB2NmhlYWRlci5jCTIwMDMtMDktMDIgMDA6MTk6
MDEuMjk1MTczNTQ0ICswMjAwDQorQEAgLTEyOSwyMCArMTI5LDEyIEBADQor
IAlyZXR1cm4gMTsNCisgfQ0KKyANCistc3RhdGljIHZvaWQNCistaXB2Nmhl
YWRlcl9kZXN0cm95KHZvaWQgKm1hdGNoaW5mbywNCistCQkgICB1bnNpZ25l
ZCBpbnQgbWF0Y2hpbmZvc2l6ZSkNCistew0KKy0JcmV0dXJuOw0KKy19DQor
LQ0KKyBzdGF0aWMgc3RydWN0IGlwNnRfbWF0Y2gNCisgaXA2dF9pcHY2aGVh
ZGVyX21hdGNoID0gew0KKyAJeyBOVUxMLCBOVUxMIH0sDQorIAkiaXB2Nmhl
YWRlciIsDQorIAkmaXB2NmhlYWRlcl9tYXRjaCwNCisgCSZpcHY2aGVhZGVy
X2NoZWNrZW50cnksDQorLQkmaXB2NmhlYWRlcl9kZXN0cm95LA0KKyAJVEhJ
U19NT0RVTEUNCisgfTsNCisgDQpkaWZmIC1OcnUgbmV0ZmlsdGVyLm9yaWcv
cGF0Y2gtby1tYXRpYy9wZW5kaW5nLzY0X2lwdjZoZWFkZXIucGF0Y2guaGVs
cCBuZXRmaWx0ZXIvcGF0Y2gtby1tYXRpYy9wZW5kaW5nLzY0X2lwdjZoZWFk
ZXIucGF0Y2guaGVscA0KLS0tIG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0
aWMvcGVuZGluZy82NF9pcHY2aGVhZGVyLnBhdGNoLmhlbHAJMTk3MC0wMS0w
MSAwMTowMDowMC4wMDAwMDAwMDAgKzAxMDANCisrKyBuZXRmaWx0ZXIvcGF0
Y2gtby1tYXRpYy9wZW5kaW5nLzY0X2lwdjZoZWFkZXIucGF0Y2guaGVscAky
MDAzLTA5LTEwIDE3OjEyOjA0LjAwMDAwMDAwMCArMDIwMA0KQEAgLTAsMCAr
MSw0IEBADQorQXV0aG9yOiBNYWNpZWogU29sdHlzaWFrDQorU3RhdHVzOiBU
cml2aWFsDQorDQorVGhpcyBwYXRjaCByZW1vdmVzIHVudXNlZCBkZXN0cm95
IGNhbGxiYWNrIGluIGlwNnRfaXB2NmhlYWRlci5jDQo=

---23717851-823584273-1063207128=:14549--
