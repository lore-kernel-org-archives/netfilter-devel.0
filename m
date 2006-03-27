From: Krzysztof Oledzki <olenf@ans.pl>
Subject: [POM-NG 4/10] Fix the TARPIT extension for 2.6.16 kernels
Date: Mon, 27 Mar 2006 14:17:51 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0603271417140.17656@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1674363163-1143461871=:17656"
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

---187430788-1674363163-1143461871=:17656
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

[POM-NG 4/10] Fix the TARPIT extension for 2.6.16 kernels

This patch allows the TARPIT extension to be used with 2.6.16 kernels

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>

diff -Nur patch-o-matic-ng-20060311-orig/patchlets/TARPIT/linux-2.6/net/ipv4/netfilter/ipt_TARPIT.c patch-o-matic-ng-20060311/patchlets/TARPIT/linux-2.6/net/ipv4/netfilter/ipt_TARPIT.c
--- patch-o-matic-ng-20060311-orig/patchlets/TARPIT/linux-2.6/net/ipv4/netfilter/ipt_TARPIT.c	2006-01-03 12:29:44.000000000 +0100
+++ patch-o-matic-ng-20060311/patchlets/TARPIT/linux-2.6/net/ipv4/netfilter/ipt_TARPIT.c	2006-03-21 23:38:57.000000000 +0100
@@ -248,11 +248,13 @@


  static int check(const char *tablename,
-		 const struct ipt_entry *e,
+		 const void *e_void,
  		 void *targinfo,
  		 unsigned int targinfosize,
  		 unsigned int hook_mask)
  {
+	const struct ipt_entry *e = e_void;
+
  	/* Only allow these for input/forward packet filtering. */
  	if (strcmp(tablename, "filter") != 0) {
  		DEBUGP("TARPIT: bad table %s'.\n", tablename);
---187430788-1674363163-1143461871=:17656
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=TARPIT.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0603271417510.17656@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=TARPIT.patch

W1BPTS1ORyA0LzEwXSBGaXggdGhlIFRBUlBJVCBleHRlbnNpb24gZm9yIDIu
Ni4xNiBrZXJuZWxzDQoNClRoaXMgcGF0Y2ggYWxsb3dzIHRoZSBUQVJQSVQg
ZXh0ZW5zaW9uIHRvIGJlIHVzZWQgd2l0aCAyLjYuMTYga2VybmVscw0KDQpT
aWduZWQtb2ZmLWJ5OiBLcnp5c3p0b2YgUGlvdHIgT2xlZHpraSA8b2xlQGFu
cy5wbD4NCg0KZGlmZiAtTnVyIHBhdGNoLW8tbWF0aWMtbmctMjAwNjAzMTEt
b3JpZy9wYXRjaGxldHMvVEFSUElUL2xpbnV4LTIuNi9uZXQvaXB2NC9uZXRm
aWx0ZXIvaXB0X1RBUlBJVC5jIHBhdGNoLW8tbWF0aWMtbmctMjAwNjAzMTEv
cGF0Y2hsZXRzL1RBUlBJVC9saW51eC0yLjYvbmV0L2lwdjQvbmV0ZmlsdGVy
L2lwdF9UQVJQSVQuYw0KLS0tIHBhdGNoLW8tbWF0aWMtbmctMjAwNjAzMTEt
b3JpZy9wYXRjaGxldHMvVEFSUElUL2xpbnV4LTIuNi9uZXQvaXB2NC9uZXRm
aWx0ZXIvaXB0X1RBUlBJVC5jCTIwMDYtMDEtMDMgMTI6Mjk6NDQuMDAwMDAw
MDAwICswMTAwDQorKysgcGF0Y2gtby1tYXRpYy1uZy0yMDA2MDMxMS9wYXRj
aGxldHMvVEFSUElUL2xpbnV4LTIuNi9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0
X1RBUlBJVC5jCTIwMDYtMDMtMjEgMjM6Mzg6NTcuMDAwMDAwMDAwICswMTAw
DQpAQCAtMjQ4LDExICsyNDgsMTMgQEANCiANCiANCiBzdGF0aWMgaW50IGNo
ZWNrKGNvbnN0IGNoYXIgKnRhYmxlbmFtZSwNCi0JCSBjb25zdCBzdHJ1Y3Qg
aXB0X2VudHJ5ICplLA0KKwkJIGNvbnN0IHZvaWQgKmVfdm9pZCwNCiAJCSB2
b2lkICp0YXJnaW5mbywNCiAJCSB1bnNpZ25lZCBpbnQgdGFyZ2luZm9zaXpl
LA0KIAkJIHVuc2lnbmVkIGludCBob29rX21hc2spDQogew0KKwljb25zdCBz
dHJ1Y3QgaXB0X2VudHJ5ICplID0gZV92b2lkOw0KKw0KIAkvKiBPbmx5IGFs
bG93IHRoZXNlIGZvciBpbnB1dC9mb3J3YXJkIHBhY2tldCBmaWx0ZXJpbmcu
ICovDQogCWlmIChzdHJjbXAodGFibGVuYW1lLCAiZmlsdGVyIikgIT0gMCkg
ew0KIAkJREVCVUdQKCJUQVJQSVQ6IGJhZCB0YWJsZSAlcycuXG4iLCB0YWJs
ZW5hbWUpOw0K

---187430788-1674363163-1143461871=:17656--
