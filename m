From: Krzysztof Oledzki <olenf@ans.pl>
Subject: [POM-NG 9/10] Fix the u32 extension for 2.6.16 kernels
Date: Mon, 27 Mar 2006 14:21:02 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0603271420410.17980@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1247015290-1143462062=:17980"
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

---187430788-1247015290-1143462062=:17980
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

[POM-NG 9/10] Fix the u32 extension for 2.6.16 kernels

This patch allows the u32 extension to be used with 2.6.16 kernels

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>

diff -Nur patch-o-matic-ng-20060311-orig/patchlets/u32/linux-2.6/net/ipv4/netfilter/Makefile.ladd patch-o-matic-ng-20060311/patchlets/u32/linux-2.6/net/ipv4/netfilter/Makefile.ladd
--- patch-o-matic-ng-20060311-orig/patchlets/u32/linux-2.6/net/ipv4/netfilter/Makefile.ladd	2003-12-18 19:28:42.000000000 +0100
+++ patch-o-matic-ng-20060311/patchlets/u32/linux-2.6/net/ipv4/netfilter/Makefile.ladd	2006-03-12 02:27:20.000000000 +0100
@@ -1,4 +1,2 @@
-obj-$(CONFIG_IP_NF_MATCH_LENGTH) += ipt_length.o
-
+obj-$(CONFIG_IP_NF_MATCH_RECENT) += ipt_recent.o
  obj-$(CONFIG_IP_NF_MATCH_U32) += ipt_u32.o
-
diff -Nur patch-o-matic-ng-20060311-orig/patchlets/u32/linux-2.6/net/ipv4/netfilter/ipt_u32.c patch-o-matic-ng-20060311/patchlets/u32/linux-2.6/net/ipv4/netfilter/ipt_u32.c
--- patch-o-matic-ng-20060311-orig/patchlets/u32/linux-2.6/net/ipv4/netfilter/ipt_u32.c	2005-11-27 00:54:59.000000000 +0100
+++ patch-o-matic-ng-20060311/patchlets/u32/linux-2.6/net/ipv4/netfilter/ipt_u32.c	2006-03-21 23:33:57.000000000 +0100
@@ -122,6 +122,7 @@
        const struct net_device *out,
        const void *matchinfo,
        int offset,
+      unsigned int protoff,
        int *hotdrop)
  {
  	const struct ipt_u32 *data = matchinfo;
@@ -201,7 +202,7 @@

  static int
  checkentry(const char *tablename,
-           const struct ipt_ip *ip,
+           const void *ip,
             void *matchinfo,
             unsigned int matchsize,
             unsigned int hook_mask)
---187430788-1247015290-1143462062=:17980
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=u32.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0603271421020.17980@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=u32.patch

W1BPTS1ORyA5LzEwXSBGaXggdGhlIHUzMiBleHRlbnNpb24gZm9yIDIuNi4x
NiBrZXJuZWxzDQoNClRoaXMgcGF0Y2ggYWxsb3dzIHRoZSB1MzIgZXh0ZW5z
aW9uIHRvIGJlIHVzZWQgd2l0aCAyLjYuMTYga2VybmVscw0KDQpTaWduZWQt
b2ZmLWJ5OiBLcnp5c3p0b2YgUGlvdHIgT2xlZHpraSA8b2xlQGFucy5wbD4N
Cg0KZGlmZiAtTnVyIHBhdGNoLW8tbWF0aWMtbmctMjAwNjAzMTEtb3JpZy9w
YXRjaGxldHMvdTMyL2xpbnV4LTIuNi9uZXQvaXB2NC9uZXRmaWx0ZXIvTWFr
ZWZpbGUubGFkZCBwYXRjaC1vLW1hdGljLW5nLTIwMDYwMzExL3BhdGNobGV0
cy91MzIvbGludXgtMi42L25ldC9pcHY0L25ldGZpbHRlci9NYWtlZmlsZS5s
YWRkDQotLS0gcGF0Y2gtby1tYXRpYy1uZy0yMDA2MDMxMS1vcmlnL3BhdGNo
bGV0cy91MzIvbGludXgtMi42L25ldC9pcHY0L25ldGZpbHRlci9NYWtlZmls
ZS5sYWRkCTIwMDMtMTItMTggMTk6Mjg6NDIuMDAwMDAwMDAwICswMTAwDQor
KysgcGF0Y2gtby1tYXRpYy1uZy0yMDA2MDMxMS9wYXRjaGxldHMvdTMyL2xp
bnV4LTIuNi9uZXQvaXB2NC9uZXRmaWx0ZXIvTWFrZWZpbGUubGFkZAkyMDA2
LTAzLTEyIDAyOjI3OjIwLjAwMDAwMDAwMCArMDEwMA0KQEAgLTEsNCArMSwy
IEBADQotb2JqLSQoQ09ORklHX0lQX05GX01BVENIX0xFTkdUSCkgKz0gaXB0
X2xlbmd0aC5vDQotDQorb2JqLSQoQ09ORklHX0lQX05GX01BVENIX1JFQ0VO
VCkgKz0gaXB0X3JlY2VudC5vDQogb2JqLSQoQ09ORklHX0lQX05GX01BVENI
X1UzMikgKz0gaXB0X3UzMi5vDQotDQpkaWZmIC1OdXIgcGF0Y2gtby1tYXRp
Yy1uZy0yMDA2MDMxMS1vcmlnL3BhdGNobGV0cy91MzIvbGludXgtMi42L25l
dC9pcHY0L25ldGZpbHRlci9pcHRfdTMyLmMgcGF0Y2gtby1tYXRpYy1uZy0y
MDA2MDMxMS9wYXRjaGxldHMvdTMyL2xpbnV4LTIuNi9uZXQvaXB2NC9uZXRm
aWx0ZXIvaXB0X3UzMi5jDQotLS0gcGF0Y2gtby1tYXRpYy1uZy0yMDA2MDMx
MS1vcmlnL3BhdGNobGV0cy91MzIvbGludXgtMi42L25ldC9pcHY0L25ldGZp
bHRlci9pcHRfdTMyLmMJMjAwNS0xMS0yNyAwMDo1NDo1OS4wMDAwMDAwMDAg
KzAxMDANCisrKyBwYXRjaC1vLW1hdGljLW5nLTIwMDYwMzExL3BhdGNobGV0
cy91MzIvbGludXgtMi42L25ldC9pcHY0L25ldGZpbHRlci9pcHRfdTMyLmMJ
MjAwNi0wMy0yMSAyMzozMzo1Ny4wMDAwMDAwMDAgKzAxMDANCkBAIC0xMjIs
NiArMTIyLDcgQEANCiAgICAgICBjb25zdCBzdHJ1Y3QgbmV0X2RldmljZSAq
b3V0LA0KICAgICAgIGNvbnN0IHZvaWQgKm1hdGNoaW5mbywNCiAgICAgICBp
bnQgb2Zmc2V0LA0KKyAgICAgIHVuc2lnbmVkIGludCBwcm90b2ZmLA0KICAg
ICAgIGludCAqaG90ZHJvcCkNCiB7DQogCWNvbnN0IHN0cnVjdCBpcHRfdTMy
ICpkYXRhID0gbWF0Y2hpbmZvOw0KQEAgLTIwMSw3ICsyMDIsNyBAQA0KIA0K
IHN0YXRpYyBpbnQNCiBjaGVja2VudHJ5KGNvbnN0IGNoYXIgKnRhYmxlbmFt
ZSwNCi0gICAgICAgICAgIGNvbnN0IHN0cnVjdCBpcHRfaXAgKmlwLA0KKyAg
ICAgICAgICAgY29uc3Qgdm9pZCAqaXAsDQogICAgICAgICAgICB2b2lkICpt
YXRjaGluZm8sDQogICAgICAgICAgICB1bnNpZ25lZCBpbnQgbWF0Y2hzaXpl
LA0KICAgICAgICAgICAgdW5zaWduZWQgaW50IGhvb2tfbWFzaykNCg==

---187430788-1247015290-1143462062=:17980--
