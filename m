From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH] Make LOG targets log uid/gid
Date: Wed, 7 May 2003 20:55:23 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0305072051330.18612@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-23717851-1269327097-1052333723=:18612"
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

---23717851-1269327097-1052333723=:18612
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi,

This patch makes both of the LOG targets log uid and gid of a process
that owns the socket related to the sk_buff.

Regards,
Maciej

diff -Nru netfilter.orig/patch-o-matic/base/LOG-ids.patch netfilter/patch-o-matic/base/LOG-ids.patch
--- netfilter.orig/patch-o-matic/base/LOG-ids.patch	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/LOG-ids.patch	2003-05-07 20:38:48.000000000 +0200
@@ -0,0 +1,54 @@
+diff -Nru linux.bak/net/ipv4/netfilter/ipt_LOG.c linux/net/ipv4/netfilter/ipt_LOG.c
+--- linux.bak/net/ipv4/netfilter/ipt_LOG.c	2003-04-30 15:57:40.000000000 +0200
++++ linux/net/ipv4/netfilter/ipt_LOG.c	2003-05-07 20:35:17.000000000 +0200
+@@ -1,5 +1,8 @@
+ /*
+  * This is a module which is used for logging packets.
++ *
++ * Changelog:
++ * Maciej Soltysiak <solt@dns.toxicfilms.tv>	: UID/GID Logging
+  */
+ #include <linux/module.h>
+ #include <linux/skbuff.h>
+@@ -304,6 +307,14 @@
+ 	}
+
+ 	dump_packet(loginfo, iph, (*pskb)->len, 1);
++
++	/* Is there a socket related to the sk_buff? If so, log uid/gid */
++	if (((*pskb)->sk != NULL && (*pskb)->sk->socket != NULL
++		&& (*pskb)->sk->socket->file != NULL) {
++		printk("UID: %d ", (*pskb)->sk->socket->file->f_uid);
++		printk("GID: %d", (*pskb)->sk->socket->file->f_gid);
++	}
++
+ 	printk("\n");
+ 	spin_unlock_bh(&log_lock);
+
+diff -Nru linux.bak/net/ipv6/netfilter/ip6t_LOG.c linux/net/ipv6/netfilter/ip6t_LOG.c
+--- linux.bak/net/ipv6/netfilter/ip6t_LOG.c	2003-04-30 15:57:42.000000000 +0200
++++ linux/net/ipv6/netfilter/ip6t_LOG.c	2003-05-07 20:35:42.000000000 +0200
+@@ -1,5 +1,9 @@
+ /*
+  * This is a module which is used for logging packets.
++ *
++ * Changelog:
++ * Maciej Soltysiak <solt@dns.toxicfilms.tv>	: uid/gid Logging
++ *
+  */
+ #include <linux/module.h>
+ #include <linux/skbuff.h>
+@@ -327,6 +331,13 @@
+ 	}
+
+ 	dump_packet(loginfo, ipv6h, 1);
++	/* Is there a socket related to the sk_buff? If so, log uid/gid */
++	if ((*pskb)->sk != NULL && (*pskb)->sk->socket != NULL
++		&& (*pskb)->sk->socket->file != NULL) {
++		printk("UID: %d ", (*pskb)->sk->socket->file->f_uid);
++		printk("GID: %d", (*pskb)->sk->socket->file->f_gid);
++	}
++
+ 	printk("\n");
+ 	spin_unlock_bh(&log_lock);
+
diff -Nru netfilter.orig/patch-o-matic/base/LOG-ids.patch.help netfilter/patch-o-matic/base/LOG-ids.patch.help
--- netfilter.orig/patch-o-matic/base/LOG-ids.patch.help	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/LOG-ids.patch.help	2003-05-07 20:40:31.000000000 +0200
@@ -0,0 +1,6 @@
+Author: Maciej Soltysiak <solt@dns.toxicfilms.tv>
+Status: Works for me.
+
+This patch extends the LOG targets (ip4 and ip6) function by adding
+loggins of uid/gid of a process that owns the socket related to the packet's
+sk_buff. If there is one that is.
---23717851-1269327097-1052333723=:18612
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="LOG.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.51.0305072055230.18612@dns.toxicfilms.tv>
Content-Description: LOG.patch
Content-Disposition: attachment; filename="LOG.patch"

ZGlmZiAtTnJ1IG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMvYmFzZS9M
T0ctaWRzLnBhdGNoIG5ldGZpbHRlci9wYXRjaC1vLW1hdGljL2Jhc2UvTE9H
LWlkcy5wYXRjaA0KLS0tIG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMv
YmFzZS9MT0ctaWRzLnBhdGNoCTE5NzAtMDEtMDEgMDE6MDA6MDAuMDAwMDAw
MDAwICswMTAwDQorKysgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFzZS9M
T0ctaWRzLnBhdGNoCTIwMDMtMDUtMDcgMjA6Mzg6NDguMDAwMDAwMDAwICsw
MjAwDQpAQCAtMCwwICsxLDU0IEBADQorZGlmZiAtTnJ1IGxpbnV4LmJhay9u
ZXQvaXB2NC9uZXRmaWx0ZXIvaXB0X0xPRy5jIGxpbnV4L25ldC9pcHY0L25l
dGZpbHRlci9pcHRfTE9HLmMNCistLS0gbGludXguYmFrL25ldC9pcHY0L25l
dGZpbHRlci9pcHRfTE9HLmMJMjAwMy0wNC0zMCAxNTo1Nzo0MC4wMDAwMDAw
MDAgKzAyMDANCisrKysgbGludXgvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF9M
T0cuYwkyMDAzLTA1LTA3IDIwOjM1OjE3LjAwMDAwMDAwMCArMDIwMA0KK0BA
IC0xLDUgKzEsOCBAQA0KKyAvKg0KKyAgKiBUaGlzIGlzIGEgbW9kdWxlIHdo
aWNoIGlzIHVzZWQgZm9yIGxvZ2dpbmcgcGFja2V0cy4NCisrICoNCisrICog
Q2hhbmdlbG9nOg0KKysgKiBNYWNpZWogU29sdHlzaWFrIDxzb2x0QGRucy50
b3hpY2ZpbG1zLnR2Pgk6IFVJRC9HSUQgTG9nZ2luZw0KKyAgKi8NCisgI2lu
Y2x1ZGUgPGxpbnV4L21vZHVsZS5oPg0KKyAjaW5jbHVkZSA8bGludXgvc2ti
dWZmLmg+DQorQEAgLTMwNCw2ICszMDcsMTQgQEANCisgCX0NCisgDQorIAlk
dW1wX3BhY2tldChsb2dpbmZvLCBpcGgsICgqcHNrYiktPmxlbiwgMSk7DQor
Kw0KKysJLyogSXMgdGhlcmUgYSBzb2NrZXQgcmVsYXRlZCB0byB0aGUgc2tf
YnVmZj8gSWYgc28sIGxvZyB1aWQvZ2lkICovDQorKwlpZiAoKCgqcHNrYikt
PnNrICE9IE5VTEwgJiYgKCpwc2tiKS0+c2stPnNvY2tldCAhPSBOVUxMDQor
KwkJJiYgKCpwc2tiKS0+c2stPnNvY2tldC0+ZmlsZSAhPSBOVUxMKSB7DQor
KwkJcHJpbnRrKCJVSUQ6ICVkICIsICgqcHNrYiktPnNrLT5zb2NrZXQtPmZp
bGUtPmZfdWlkKTsNCisrCQlwcmludGsoIkdJRDogJWQiLCAoKnBza2IpLT5z
ay0+c29ja2V0LT5maWxlLT5mX2dpZCk7DQorKwl9DQorKw0KKyAJcHJpbnRr
KCJcbiIpOw0KKyAJc3Bpbl91bmxvY2tfYmgoJmxvZ19sb2NrKTsNCisgDQor
ZGlmZiAtTnJ1IGxpbnV4LmJhay9uZXQvaXB2Ni9uZXRmaWx0ZXIvaXA2dF9M
T0cuYyBsaW51eC9uZXQvaXB2Ni9uZXRmaWx0ZXIvaXA2dF9MT0cuYw0KKy0t
LSBsaW51eC5iYWsvbmV0L2lwdjYvbmV0ZmlsdGVyL2lwNnRfTE9HLmMJMjAw
My0wNC0zMCAxNTo1Nzo0Mi4wMDAwMDAwMDAgKzAyMDANCisrKysgbGludXgv
bmV0L2lwdjYvbmV0ZmlsdGVyL2lwNnRfTE9HLmMJMjAwMy0wNS0wNyAyMDoz
NTo0Mi4wMDAwMDAwMDAgKzAyMDANCitAQCAtMSw1ICsxLDkgQEANCisgLyoN
CisgICogVGhpcyBpcyBhIG1vZHVsZSB3aGljaCBpcyB1c2VkIGZvciBsb2dn
aW5nIHBhY2tldHMuDQorKyAqDQorKyAqIENoYW5nZWxvZzoNCisrICogTWFj
aWVqIFNvbHR5c2lhayA8c29sdEBkbnMudG94aWNmaWxtcy50dj4JOiB1aWQv
Z2lkIExvZ2dpbmcNCisrICoNCisgICovDQorICNpbmNsdWRlIDxsaW51eC9t
b2R1bGUuaD4NCisgI2luY2x1ZGUgPGxpbnV4L3NrYnVmZi5oPg0KK0BAIC0z
MjcsNiArMzMxLDEzIEBADQorIAl9DQorIA0KKyAJZHVtcF9wYWNrZXQobG9n
aW5mbywgaXB2NmgsIDEpOw0KKysJLyogSXMgdGhlcmUgYSBzb2NrZXQgcmVs
YXRlZCB0byB0aGUgc2tfYnVmZj8gSWYgc28sIGxvZyB1aWQvZ2lkICovDQor
KwlpZiAoKCpwc2tiKS0+c2sgIT0gTlVMTCAmJiAoKnBza2IpLT5zay0+c29j
a2V0ICE9IE5VTEwNCisrCQkmJiAoKnBza2IpLT5zay0+c29ja2V0LT5maWxl
ICE9IE5VTEwpIHsNCisrCQlwcmludGsoIlVJRDogJWQgIiwgKCpwc2tiKS0+
c2stPnNvY2tldC0+ZmlsZS0+Zl91aWQpOw0KKysJCXByaW50aygiR0lEOiAl
ZCIsICgqcHNrYiktPnNrLT5zb2NrZXQtPmZpbGUtPmZfZ2lkKTsNCisrCX0N
CisrDQorIAlwcmludGsoIlxuIik7DQorIAlzcGluX3VubG9ja19iaCgmbG9n
X2xvY2spOw0KKyANCmRpZmYgLU5ydSBuZXRmaWx0ZXIub3JpZy9wYXRjaC1v
LW1hdGljL2Jhc2UvTE9HLWlkcy5wYXRjaC5oZWxwIG5ldGZpbHRlci9wYXRj
aC1vLW1hdGljL2Jhc2UvTE9HLWlkcy5wYXRjaC5oZWxwDQotLS0gbmV0Zmls
dGVyLm9yaWcvcGF0Y2gtby1tYXRpYy9iYXNlL0xPRy1pZHMucGF0Y2guaGVs
cAkxOTcwLTAxLTAxIDAxOjAwOjAwLjAwMDAwMDAwMCArMDEwMA0KKysrIG5l
dGZpbHRlci9wYXRjaC1vLW1hdGljL2Jhc2UvTE9HLWlkcy5wYXRjaC5oZWxw
CTIwMDMtMDUtMDcgMjA6NDA6MzEuMDAwMDAwMDAwICswMjAwDQpAQCAtMCww
ICsxLDYgQEANCitBdXRob3I6IE1hY2llaiBTb2x0eXNpYWsgPHNvbHRAZG5z
LnRveGljZmlsbXMudHY+DQorU3RhdHVzOiBXb3JrcyBmb3IgbWUuDQorDQor
VGhpcyBwYXRjaCBleHRlbmRzIHRoZSBMT0cgdGFyZ2V0cyAoaXA0IGFuZCBp
cDYpIGZ1bmN0aW9uIGJ5IGFkZGluZw0KK2xvZ2dpbnMgb2YgdWlkL2dpZCBv
ZiBhIHByb2Nlc3MgdGhhdCBvd25zIHRoZSBzb2NrZXQgcmVsYXRlZCB0byB0
aGUgcGFja2V0J3MNCitza19idWZmLiBJZiB0aGVyZSBpcyBvbmUgdGhhdCBp
cy4NCg==

---23717851-1269327097-1052333723=:18612--
