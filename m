From: Krzysztof Oledzki <olenf@ans.pl>
Subject: [POM-NG 10/10] Fix the unclean extension for 2.6.16 kernels
Date: Mon, 27 Mar 2006 14:21:34 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0603271421060.18053@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-431423964-1143462094=:18053"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-431423964-1143462094=:18053
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

[POM-NG 10/10] Fix the unclean extension for 2.6.16 kernels

This patch allows the unclean extension to be used with 2.6.16 kernels

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>

diff -Nur patch-o-matic-ng-20060311-orig/patchlets/unclean/linux-2.6/net/ipv4/netfilter/Makefile.ladd patch-o-matic-ng-20060311/patchlets/unclean/linux-2.6/net/ipv4/netfilter/Makefile.ladd
--- patch-o-matic-ng-20060311-orig/patchlets/unclean/linux-2.6/net/ipv4/netfilter/Makefile.ladd	2005-01-22 00:33:54.000000000 +0100
+++ patch-o-matic-ng-20060311/patchlets/unclean/linux-2.6/net/ipv4/netfilter/Makefile.ladd	2006-03-12 02:27:40.000000000 +0100
@@ -1,2 +1,2 @@
-obj-$(CONFIG_IP_NF_MATCH_LENGTH) += ipt_length.o
+obj-$(CONFIG_IP_NF_MATCH_RECENT) += ipt_recent.o
  obj-$(CONFIG_IP_NF_MATCH_UNCLEAN) += ipt_unclean.o
diff -Nur patch-o-matic-ng-20060311-orig/patchlets/unclean/linux-2.6/net/ipv4/netfilter/ipt_unclean.c patch-o-matic-ng-20060311/patchlets/unclean/linux-2.6/net/ipv4/netfilter/ipt_unclean.c
--- patch-o-matic-ng-20060311-orig/patchlets/unclean/linux-2.6/net/ipv4/netfilter/ipt_unclean.c	2005-01-22 00:33:54.000000000 +0100
+++ patch-o-matic-ng-20060311/patchlets/unclean/linux-2.6/net/ipv4/netfilter/ipt_unclean.c	2006-03-21 23:46:30.000000000 +0100
@@ -570,6 +570,7 @@
        const struct net_device *out,
        const void *matchinfo,
        int offset,
+      unsigned int protoff,
        int *hotdrop)
  {
  	return !check_ip(skb, 0);
@@ -578,7 +579,7 @@
  /* Called when user tries to insert an entry of this type. */
  static int
  checkentry(const char *tablename,
-	   const struct ipt_ip *ip,
+	   const void *ip,
  	   void *matchinfo,
  	   unsigned int matchsize,
  	   unsigned int hook_mask)
---187430788-431423964-1143462094=:18053
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=unclean.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0603271421340.18053@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=unclean.patch

W1BPTS1ORyAxMC8xMF0gRml4IHRoZSB1bmNsZWFuIGV4dGVuc2lvbiBmb3Ig
Mi42LjE2IGtlcm5lbHMNCg0KVGhpcyBwYXRjaCBhbGxvd3MgdGhlIHVuY2xl
YW4gZXh0ZW5zaW9uIHRvIGJlIHVzZWQgd2l0aCAyLjYuMTYga2VybmVscw0K
DQpTaWduZWQtb2ZmLWJ5OiBLcnp5c3p0b2YgUGlvdHIgT2xlZHpraSA8b2xl
QGFucy5wbD4NCg0KZGlmZiAtTnVyIHBhdGNoLW8tbWF0aWMtbmctMjAwNjAz
MTEtb3JpZy9wYXRjaGxldHMvdW5jbGVhbi9saW51eC0yLjYvbmV0L2lwdjQv
bmV0ZmlsdGVyL01ha2VmaWxlLmxhZGQgcGF0Y2gtby1tYXRpYy1uZy0yMDA2
MDMxMS9wYXRjaGxldHMvdW5jbGVhbi9saW51eC0yLjYvbmV0L2lwdjQvbmV0
ZmlsdGVyL01ha2VmaWxlLmxhZGQNCi0tLSBwYXRjaC1vLW1hdGljLW5nLTIw
MDYwMzExLW9yaWcvcGF0Y2hsZXRzL3VuY2xlYW4vbGludXgtMi42L25ldC9p
cHY0L25ldGZpbHRlci9NYWtlZmlsZS5sYWRkCTIwMDUtMDEtMjIgMDA6MzM6
NTQuMDAwMDAwMDAwICswMTAwDQorKysgcGF0Y2gtby1tYXRpYy1uZy0yMDA2
MDMxMS9wYXRjaGxldHMvdW5jbGVhbi9saW51eC0yLjYvbmV0L2lwdjQvbmV0
ZmlsdGVyL01ha2VmaWxlLmxhZGQJMjAwNi0wMy0xMiAwMjoyNzo0MC4wMDAw
MDAwMDAgKzAxMDANCkBAIC0xLDIgKzEsMiBAQA0KLW9iai0kKENPTkZJR19J
UF9ORl9NQVRDSF9MRU5HVEgpICs9IGlwdF9sZW5ndGgubw0KK29iai0kKENP
TkZJR19JUF9ORl9NQVRDSF9SRUNFTlQpICs9IGlwdF9yZWNlbnQubw0KIG9i
ai0kKENPTkZJR19JUF9ORl9NQVRDSF9VTkNMRUFOKSArPSBpcHRfdW5jbGVh
bi5vDQpkaWZmIC1OdXIgcGF0Y2gtby1tYXRpYy1uZy0yMDA2MDMxMS1vcmln
L3BhdGNobGV0cy91bmNsZWFuL2xpbnV4LTIuNi9uZXQvaXB2NC9uZXRmaWx0
ZXIvaXB0X3VuY2xlYW4uYyBwYXRjaC1vLW1hdGljLW5nLTIwMDYwMzExL3Bh
dGNobGV0cy91bmNsZWFuL2xpbnV4LTIuNi9uZXQvaXB2NC9uZXRmaWx0ZXIv
aXB0X3VuY2xlYW4uYw0KLS0tIHBhdGNoLW8tbWF0aWMtbmctMjAwNjAzMTEt
b3JpZy9wYXRjaGxldHMvdW5jbGVhbi9saW51eC0yLjYvbmV0L2lwdjQvbmV0
ZmlsdGVyL2lwdF91bmNsZWFuLmMJMjAwNS0wMS0yMiAwMDozMzo1NC4wMDAw
MDAwMDAgKzAxMDANCisrKyBwYXRjaC1vLW1hdGljLW5nLTIwMDYwMzExL3Bh
dGNobGV0cy91bmNsZWFuL2xpbnV4LTIuNi9uZXQvaXB2NC9uZXRmaWx0ZXIv
aXB0X3VuY2xlYW4uYwkyMDA2LTAzLTIxIDIzOjQ2OjMwLjAwMDAwMDAwMCAr
MDEwMA0KQEAgLTU3MCw2ICs1NzAsNyBAQA0KICAgICAgIGNvbnN0IHN0cnVj
dCBuZXRfZGV2aWNlICpvdXQsDQogICAgICAgY29uc3Qgdm9pZCAqbWF0Y2hp
bmZvLA0KICAgICAgIGludCBvZmZzZXQsDQorICAgICAgdW5zaWduZWQgaW50
IHByb3RvZmYsDQogICAgICAgaW50ICpob3Rkcm9wKQ0KIHsNCiAJcmV0dXJu
ICFjaGVja19pcChza2IsIDApOw0KQEAgLTU3OCw3ICs1NzksNyBAQA0KIC8q
IENhbGxlZCB3aGVuIHVzZXIgdHJpZXMgdG8gaW5zZXJ0IGFuIGVudHJ5IG9m
IHRoaXMgdHlwZS4gKi8NCiBzdGF0aWMgaW50DQogY2hlY2tlbnRyeShjb25z
dCBjaGFyICp0YWJsZW5hbWUsDQotCSAgIGNvbnN0IHN0cnVjdCBpcHRfaXAg
KmlwLA0KKwkgICBjb25zdCB2b2lkICppcCwNCiAJICAgdm9pZCAqbWF0Y2hp
bmZvLA0KIAkgICB1bnNpZ25lZCBpbnQgbWF0Y2hzaXplLA0KIAkgICB1bnNp
Z25lZCBpbnQgaG9va19tYXNrKQ0K

---187430788-431423964-1143462094=:18053--
