From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH] string match compilation on 2.4.9
Date: Sun, 4 May 2003 17:19:32 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0305041712240.1987@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-23717851-1980701081-1052061572=:2002"
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

---23717851-1980701081-1052061572=:2002
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi,

we all know that the string match does not work on 2.4.9 because
2.4.9 had a different definition of the min/max macros.

I know that Martin said that we are not supporting kernels <2.4.18 anyway,
but there are patches in pom that still may be used be people with 2.4.9
and other < 2.4.18 kernels.

Please consider this patch for the patch-o-matic.

Regards,
Maciej

diff -Nru netfilter.orig/patch-o-matic/extra/string.patch netfilter/patch-o-matic/extra/string.patch
--- netfilter.orig/patch-o-matic/extra/string.patch	2003-05-03 14:31:54.000000000 +0200
+++ netfilter/patch-o-matic/extra/string.patch	2003-05-04 17:06:29.000000000 +0200
@@ -26,12 +26,14 @@
 diff -urN linux.orig/net/ipv4/netfilter/ipt_string.c linux/net/ipv4/netfilter/ipt_string.c
 --- linux.orig/net/ipv4/netfilter/ipt_string.c	Thu Jan  1 01:00:00 1970
 +++ linux/net/ipv4/netfilter/ipt_string.c	Thu Feb 21 20:26:09 2002
-@@ -0,0 +1,216 @@
+@@ -0,0 +1,222 @@
 +/* Kernel module to match a string into a packet.
 + *
 + * Copyright (C) 2000 Emmanuel Roger  <winfield@freegates.be>
 + *
 + * ChangeLog
++ *	04.05.2003: Maciej Soltysiak <solt@dns.toxicfilms.tv>
++ *		Fixed 2.4.9 broken max macro usage.
 + *	19.02.2002: Gianni Tedesco <gianni@ecsc.co.uk>
 + *		Fixed SMP re-entrancy problem using per-cpu data areas
 + *		for the skip/shift tables.
@@ -106,7 +108,11 @@
 +
 +		sk = skip[haystack[right_end - i]];
 +		sh = shift[i];
++#if LINUX_VERSION_CODE == KERNEL_VERSION(2,4,9)
++		right_end = max(int , right_end - i + sk, right_end + sh);
++#else
 +		right_end = max(right_end - i + sk, right_end + sh);
++#endif
 +	}
 +
 +	return NULL;
diff -Nru netfilter.orig/patch-o-matic/extra/string.patch.help netfilter/patch-o-matic/extra/string.patch.help
--- netfilter.orig/patch-o-matic/extra/string.patch.help	2003-05-03 14:31:54.000000000 +0200
+++ netfilter/patch-o-matic/extra/string.patch.help	2003-05-04 17:07:11.000000000 +0200
@@ -1,8 +1,6 @@
 Author: Emmanuel Roger <winfield@freegates.be>
-Status: Working, not with kernel 2.4.9
+Status: Working

 This patch adds CONFIG_IP_NF_MATCH_STRING which allows you to
 match a string in a whole packet.

-THIS PATCH DOES NOT WORK WITH KERNEL 2.4.9 !!!
-
---23717851-1980701081-1052061572=:2002
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="string.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.51.0305041719320.2002@dns.toxicfilms.tv>
Content-Description: string.patch
Content-Disposition: attachment; filename="string.patch"

ZGlmZiAtTnJ1IG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMvZXh0cmEv
c3RyaW5nLnBhdGNoIG5ldGZpbHRlci9wYXRjaC1vLW1hdGljL2V4dHJhL3N0
cmluZy5wYXRjaA0KLS0tIG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMv
ZXh0cmEvc3RyaW5nLnBhdGNoCTIwMDMtMDUtMDMgMTQ6MzE6NTQuMDAwMDAw
MDAwICswMjAwDQorKysgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMvZXh0cmEv
c3RyaW5nLnBhdGNoCTIwMDMtMDUtMDQgMTc6MDY6MjkuMDAwMDAwMDAwICsw
MjAwDQpAQCAtMjYsMTIgKzI2LDE0IEBADQogZGlmZiAtdXJOIGxpbnV4Lm9y
aWcvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF9zdHJpbmcuYyBsaW51eC9uZXQv
aXB2NC9uZXRmaWx0ZXIvaXB0X3N0cmluZy5jDQogLS0tIGxpbnV4Lm9yaWcv
bmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF9zdHJpbmcuYwlUaHUgSmFuICAxIDAx
OjAwOjAwIDE5NzANCiArKysgbGludXgvbmV0L2lwdjQvbmV0ZmlsdGVyL2lw
dF9zdHJpbmcuYwlUaHUgRmViIDIxIDIwOjI2OjA5IDIwMDINCi1AQCAtMCww
ICsxLDIxNiBAQA0KK0BAIC0wLDAgKzEsMjIyIEBADQogKy8qIEtlcm5lbCBt
b2R1bGUgdG8gbWF0Y2ggYSBzdHJpbmcgaW50byBhIHBhY2tldC4NCiArICoN
CiArICogQ29weXJpZ2h0IChDKSAyMDAwIEVtbWFudWVsIFJvZ2VyICA8d2lu
ZmllbGRAZnJlZWdhdGVzLmJlPg0KICsgKiANCiArICogQ2hhbmdlTG9nDQor
KyAqCTA0LjA1LjIwMDM6IE1hY2llaiBTb2x0eXNpYWsgPHNvbHRAZG5zLnRv
eGljZmlsbXMudHY+DQorKyAqCQlGaXhlZCAyLjQuOSBicm9rZW4gbWF4IG1h
Y3JvIHVzYWdlLg0KICsgKgkxOS4wMi4yMDAyOiBHaWFubmkgVGVkZXNjbyA8
Z2lhbm5pQGVjc2MuY28udWs+DQogKyAqCQlGaXhlZCBTTVAgcmUtZW50cmFu
Y3kgcHJvYmxlbSB1c2luZyBwZXItY3B1IGRhdGEgYXJlYXMNCiArICoJCWZv
ciB0aGUgc2tpcC9zaGlmdCB0YWJsZXMuDQpAQCAtMTA2LDcgKzEwOCwxMSBA
QA0KICsJCQ0KICsJCXNrID0gc2tpcFtoYXlzdGFja1tyaWdodF9lbmQgLSBp
XV07ICANCiArCQlzaCA9IHNoaWZ0W2ldOw0KKysjaWYgTElOVVhfVkVSU0lP
Tl9DT0RFID09IEtFUk5FTF9WRVJTSU9OKDIsNCw5KQ0KKysJCXJpZ2h0X2Vu
ZCA9IG1heChpbnQgLCByaWdodF9lbmQgLSBpICsgc2ssIHJpZ2h0X2VuZCAr
IHNoKTsNCisrI2Vsc2UNCiArCQlyaWdodF9lbmQgPSBtYXgocmlnaHRfZW5k
IC0gaSArIHNrLCByaWdodF9lbmQgKyBzaCk7ICANCisrI2VuZGlmDQogKwl9
DQogKw0KICsJcmV0dXJuIE5VTEw7DQpkaWZmIC1OcnUgbmV0ZmlsdGVyLm9y
aWcvcGF0Y2gtby1tYXRpYy9leHRyYS9zdHJpbmcucGF0Y2guaGVscCBuZXRm
aWx0ZXIvcGF0Y2gtby1tYXRpYy9leHRyYS9zdHJpbmcucGF0Y2guaGVscA0K
LS0tIG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMvZXh0cmEvc3RyaW5n
LnBhdGNoLmhlbHAJMjAwMy0wNS0wMyAxNDozMTo1NC4wMDAwMDAwMDAgKzAy
MDANCisrKyBuZXRmaWx0ZXIvcGF0Y2gtby1tYXRpYy9leHRyYS9zdHJpbmcu
cGF0Y2guaGVscAkyMDAzLTA1LTA0IDE3OjA3OjExLjAwMDAwMDAwMCArMDIw
MA0KQEAgLTEsOCArMSw2IEBADQogQXV0aG9yOiBFbW1hbnVlbCBSb2dlciA8
d2luZmllbGRAZnJlZWdhdGVzLmJlPg0KLVN0YXR1czogV29ya2luZywgbm90
IHdpdGgga2VybmVsIDIuNC45DQorU3RhdHVzOiBXb3JraW5nDQogDQogVGhp
cyBwYXRjaCBhZGRzIENPTkZJR19JUF9ORl9NQVRDSF9TVFJJTkcgd2hpY2gg
YWxsb3dzIHlvdSB0bw0KIG1hdGNoIGEgc3RyaW5nIGluIGEgd2hvbGUgcGFj
a2V0Lg0KIA0KLVRISVMgUEFUQ0ggRE9FUyBOT1QgV09SSyBXSVRIIEtFUk5F
TCAyLjQuOSAhISENCi0NCg==

---23717851-1980701081-1052061572=:2002--
