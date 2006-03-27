From: Krzysztof Oledzki <olenf@ans.pl>
Subject: [POM-NG 5/10] Fix the ipv4options extension for 2.6.16 kernels
Date: Mon, 27 Mar 2006 14:18:17 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0603271417520.17706@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-680194370-1143461897=:17706"
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

---187430788-680194370-1143461897=:17706
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

[POM-NG 5/10] Fix the ipv4options extension for 2.6.16 kernels

This patch allows the ipv4options extension to be used with 2.6.16 kernels

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>

diff -Nur patch-o-matic-ng-20060311-orig/patchlets/ipv4options/linux-2.6/net/ipv4/netfilter/ipt_ipv4options.c patch-o-matic-ng-20060311/patchlets/ipv4options/linux-2.6/net/ipv4/netfilter/ipt_ipv4options.c
--- patch-o-matic-ng-20060311-orig/patchlets/ipv4options/linux-2.6/net/ipv4/netfilter/ipt_ipv4options.c	2005-11-16 11:52:50.000000000 +0100
+++ patch-o-matic-ng-20060311/patchlets/ipv4options/linux-2.6/net/ipv4/netfilter/ipt_ipv4options.c	2006-03-21 23:49:43.000000000 +0100
@@ -27,6 +27,7 @@
        const struct net_device *out,
        const void *matchinfo,
        int offset,
+      unsigned int protoff,
        int *hotdrop)
  {
  	const struct ipt_ipv4options_info *info = matchinfo;   /* match info for rule */
@@ -105,7 +106,7 @@

  static int
  checkentry(const char *tablename,
-	   const struct ipt_ip *ip,
+	   const void *ip,
  	   void *matchinfo,
  	   unsigned int matchsize,
  	   unsigned int hook_mask)
---187430788-680194370-1143461897=:17706
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=ipv4options.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0603271418170.17706@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=ipv4options.patch

W1BPTS1ORyA1LzEwXSBGaXggdGhlIGlwdjRvcHRpb25zIGV4dGVuc2lvbiBm
b3IgMi42LjE2IGtlcm5lbHMNCg0KVGhpcyBwYXRjaCBhbGxvd3MgdGhlIGlw
djRvcHRpb25zIGV4dGVuc2lvbiB0byBiZSB1c2VkIHdpdGggMi42LjE2IGtl
cm5lbHMNCg0KU2lnbmVkLW9mZi1ieTogS3J6eXN6dG9mIFBpb3RyIE9sZWR6
a2kgPG9sZUBhbnMucGw+DQoNCmRpZmYgLU51ciBwYXRjaC1vLW1hdGljLW5n
LTIwMDYwMzExLW9yaWcvcGF0Y2hsZXRzL2lwdjRvcHRpb25zL2xpbnV4LTIu
Ni9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0X2lwdjRvcHRpb25zLmMgcGF0Y2gt
by1tYXRpYy1uZy0yMDA2MDMxMS9wYXRjaGxldHMvaXB2NG9wdGlvbnMvbGlu
dXgtMi42L25ldC9pcHY0L25ldGZpbHRlci9pcHRfaXB2NG9wdGlvbnMuYw0K
LS0tIHBhdGNoLW8tbWF0aWMtbmctMjAwNjAzMTEtb3JpZy9wYXRjaGxldHMv
aXB2NG9wdGlvbnMvbGludXgtMi42L25ldC9pcHY0L25ldGZpbHRlci9pcHRf
aXB2NG9wdGlvbnMuYwkyMDA1LTExLTE2IDExOjUyOjUwLjAwMDAwMDAwMCAr
MDEwMA0KKysrIHBhdGNoLW8tbWF0aWMtbmctMjAwNjAzMTEvcGF0Y2hsZXRz
L2lwdjRvcHRpb25zL2xpbnV4LTIuNi9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0
X2lwdjRvcHRpb25zLmMJMjAwNi0wMy0yMSAyMzo0OTo0My4wMDAwMDAwMDAg
KzAxMDANCkBAIC0yNyw2ICsyNyw3IEBADQogICAgICAgY29uc3Qgc3RydWN0
IG5ldF9kZXZpY2UgKm91dCwNCiAgICAgICBjb25zdCB2b2lkICptYXRjaGlu
Zm8sDQogICAgICAgaW50IG9mZnNldCwNCisgICAgICB1bnNpZ25lZCBpbnQg
cHJvdG9mZiwNCiAgICAgICBpbnQgKmhvdGRyb3ApDQogew0KIAljb25zdCBz
dHJ1Y3QgaXB0X2lwdjRvcHRpb25zX2luZm8gKmluZm8gPSBtYXRjaGluZm87
ICAgLyogbWF0Y2ggaW5mbyBmb3IgcnVsZSAqLw0KQEAgLTEwNSw3ICsxMDYs
NyBAQA0KIA0KIHN0YXRpYyBpbnQNCiBjaGVja2VudHJ5KGNvbnN0IGNoYXIg
KnRhYmxlbmFtZSwNCi0JICAgY29uc3Qgc3RydWN0IGlwdF9pcCAqaXAsDQor
CSAgIGNvbnN0IHZvaWQgKmlwLA0KIAkgICB2b2lkICptYXRjaGluZm8sDQog
CSAgIHVuc2lnbmVkIGludCBtYXRjaHNpemUsDQogCSAgIHVuc2lnbmVkIGlu
dCBob29rX21hc2spDQo=

---187430788-680194370-1143461897=:17706--
