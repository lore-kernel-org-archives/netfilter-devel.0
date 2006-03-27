From: Krzysztof Oledzki <olenf@ans.pl>
Subject: [POM-NG 6/10] Fix the random extension for 2.6.16 kernels
Date: Mon, 27 Mar 2006 14:18:39 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0603271418230.17756@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1820591781-1143461919=:17756"
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

---187430788-1820591781-1143461919=:17756
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

[POM-NG 6/10] Fix the random extension for 2.6.16 kernels

This patch allows the random extension to be used with 2.6.16 kernels

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>

diff -Nur patch-o-matic-ng-20060311-orig/patchlets/random/linux-2.6/net/ipv4/netfilter/ipt_random.c patch-o-matic-ng-20060311/patchlets/random/linux-2.6/net/ipv4/netfilter/ipt_random.c
--- patch-o-matic-ng-20060311-orig/patchlets/random/linux-2.6/net/ipv4/netfilter/ipt_random.c	2005-09-19 17:09:56.000000000 +0200
+++ patch-o-matic-ng-20060311/patchlets/random/linux-2.6/net/ipv4/netfilter/ipt_random.c	2006-03-21 23:48:03.000000000 +0100
@@ -24,6 +24,7 @@
  	       const struct net_device *out,
  	       const void *matchinfo,
  	       int offset,
+	       unsigned int protoff,
  	       int *hotdrop)
  {
  	/* Parameters from userspace */
@@ -42,7 +43,7 @@

  static int
  ipt_rand_checkentry(const char *tablename,
-		   const struct ipt_ip *e,
+		   const void *e,
  		   void *matchinfo,
  		   unsigned int matchsize,
  		   unsigned int hook_mask)
---187430788-1820591781-1143461919=:17756
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=random.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0603271418390.17756@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=random.patch

W1BPTS1ORyA2LzEwXSBGaXggdGhlIHJhbmRvbSBleHRlbnNpb24gZm9yIDIu
Ni4xNiBrZXJuZWxzDQoNClRoaXMgcGF0Y2ggYWxsb3dzIHRoZSByYW5kb20g
ZXh0ZW5zaW9uIHRvIGJlIHVzZWQgd2l0aCAyLjYuMTYga2VybmVscw0KDQpT
aWduZWQtb2ZmLWJ5OiBLcnp5c3p0b2YgUGlvdHIgT2xlZHpraSA8b2xlQGFu
cy5wbD4NCg0KZGlmZiAtTnVyIHBhdGNoLW8tbWF0aWMtbmctMjAwNjAzMTEt
b3JpZy9wYXRjaGxldHMvcmFuZG9tL2xpbnV4LTIuNi9uZXQvaXB2NC9uZXRm
aWx0ZXIvaXB0X3JhbmRvbS5jIHBhdGNoLW8tbWF0aWMtbmctMjAwNjAzMTEv
cGF0Y2hsZXRzL3JhbmRvbS9saW51eC0yLjYvbmV0L2lwdjQvbmV0ZmlsdGVy
L2lwdF9yYW5kb20uYw0KLS0tIHBhdGNoLW8tbWF0aWMtbmctMjAwNjAzMTEt
b3JpZy9wYXRjaGxldHMvcmFuZG9tL2xpbnV4LTIuNi9uZXQvaXB2NC9uZXRm
aWx0ZXIvaXB0X3JhbmRvbS5jCTIwMDUtMDktMTkgMTc6MDk6NTYuMDAwMDAw
MDAwICswMjAwDQorKysgcGF0Y2gtby1tYXRpYy1uZy0yMDA2MDMxMS9wYXRj
aGxldHMvcmFuZG9tL2xpbnV4LTIuNi9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0
X3JhbmRvbS5jCTIwMDYtMDMtMjEgMjM6NDg6MDMuMDAwMDAwMDAwICswMTAw
DQpAQCAtMjQsNiArMjQsNyBAQA0KIAkgICAgICAgY29uc3Qgc3RydWN0IG5l
dF9kZXZpY2UgKm91dCwNCiAJICAgICAgIGNvbnN0IHZvaWQgKm1hdGNoaW5m
bywNCiAJICAgICAgIGludCBvZmZzZXQsDQorCSAgICAgICB1bnNpZ25lZCBp
bnQgcHJvdG9mZiwNCiAJICAgICAgIGludCAqaG90ZHJvcCkNCiB7DQogCS8q
IFBhcmFtZXRlcnMgZnJvbSB1c2Vyc3BhY2UgKi8NCkBAIC00Miw3ICs0Myw3
IEBADQogDQogc3RhdGljIGludA0KIGlwdF9yYW5kX2NoZWNrZW50cnkoY29u
c3QgY2hhciAqdGFibGVuYW1lLA0KLQkJICAgY29uc3Qgc3RydWN0IGlwdF9p
cCAqZSwNCisJCSAgIGNvbnN0IHZvaWQgKmUsDQogCQkgICB2b2lkICptYXRj
aGluZm8sDQogCQkgICB1bnNpZ25lZCBpbnQgbWF0Y2hzaXplLA0KIAkJICAg
dW5zaWduZWQgaW50IGhvb2tfbWFzaykNCg==

---187430788-1820591781-1143461919=:17756--
