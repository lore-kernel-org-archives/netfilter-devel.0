From: Krzysztof Oledzki <olenf@ans.pl>
Subject: [POM-NG 7/10] Fix the set extension for 2.6.16 kernels
Date: Mon, 27 Mar 2006 14:20:14 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0603271418400.17783@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-251415297-1143462014=:17783"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
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

---187430788-251415297-1143462014=:17783
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

[POM-NG 7/10] Fix the set extension for 2.6.16 kernels

This patch removes warnings when the set extension is used in 2.6.16 kernels

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>

diff -Nur patch-o-matic-ng-20060311-orig/patchlets/set/linux-2.6/net/ipv4/netfilter/ipt_SET.c patch-o-matic-ng-20060311/patchlets/set/linux-2.6/net/ipv4/netfilter/ipt_SET.c
--- patch-o-matic-ng-20060311-orig/patchlets/set/linux-2.6/net/ipv4/netfilter/ipt_SET.c	2004-12-06 10:32:59.000000000 +0100
+++ patch-o-matic-ng-20060311/patchlets/set/linux-2.6/net/ipv4/netfilter/ipt_SET.c	2006-03-21 23:41:58.000000000 +0100
@@ -48,7 +48,7 @@

  static int
  checkentry(const char *tablename,
-	   const struct ipt_entry *e,
+	   const void *e,
  	   void *targinfo,
  	   unsigned int targinfosize, unsigned int hook_mask)
  {
diff -Nur patch-o-matic-ng-20060311-orig/patchlets/set/linux-2.6/net/ipv4/netfilter/ipt_set.c patch-o-matic-ng-20060311/patchlets/set/linux-2.6/net/ipv4/netfilter/ipt_set.c
--- patch-o-matic-ng-20060311-orig/patchlets/set/linux-2.6/net/ipv4/netfilter/ipt_set.c	2004-12-06 10:32:59.000000000 +0100
+++ patch-o-matic-ng-20060311/patchlets/set/linux-2.6/net/ipv4/netfilter/ipt_set.c	2006-03-21 23:35:29.000000000 +0100
@@ -34,6 +34,7 @@
        const struct net_device *out,
        const void *matchinfo,
        int offset,
+      unsigned int protoff,
        int *hotdrop)
  {
  	const struct ipt_set_info_match *info = matchinfo;
@@ -45,7 +46,7 @@

  static int
  checkentry(const char *tablename,
-	   const struct ipt_ip *ip,
+	   const void *ip,
  	   void *matchinfo,
  	   unsigned int matchsize,
  	   unsigned int hook_mask)
---187430788-251415297-1143462014=:17783
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=set.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0603271420140.17783@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=set.patch

W1BPTS1ORyA3LzEwXSBGaXggdGhlIHNldCBleHRlbnNpb24gZm9yIDIuNi4x
NiBrZXJuZWxzDQoNClRoaXMgcGF0Y2ggcmVtb3ZlcyB3YXJuaW5ncyB3aGVu
IHRoZSBzZXQgZXh0ZW5zaW9uIGlzIHVzZWQgaW4gMi42LjE2IGtlcm5lbHMN
Cg0KU2lnbmVkLW9mZi1ieTogS3J6eXN6dG9mIFBpb3RyIE9sZWR6a2kgPG9s
ZUBhbnMucGw+DQoNCmRpZmYgLU51ciBwYXRjaC1vLW1hdGljLW5nLTIwMDYw
MzExLW9yaWcvcGF0Y2hsZXRzL3NldC9saW51eC0yLjYvbmV0L2lwdjQvbmV0
ZmlsdGVyL2lwdF9TRVQuYyBwYXRjaC1vLW1hdGljLW5nLTIwMDYwMzExL3Bh
dGNobGV0cy9zZXQvbGludXgtMi42L25ldC9pcHY0L25ldGZpbHRlci9pcHRf
U0VULmMNCi0tLSBwYXRjaC1vLW1hdGljLW5nLTIwMDYwMzExLW9yaWcvcGF0
Y2hsZXRzL3NldC9saW51eC0yLjYvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF9T
RVQuYwkyMDA0LTEyLTA2IDEwOjMyOjU5LjAwMDAwMDAwMCArMDEwMA0KKysr
IHBhdGNoLW8tbWF0aWMtbmctMjAwNjAzMTEvcGF0Y2hsZXRzL3NldC9saW51
eC0yLjYvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF9TRVQuYwkyMDA2LTAzLTIx
IDIzOjQxOjU4LjAwMDAwMDAwMCArMDEwMA0KQEAgLTQ4LDcgKzQ4LDcgQEAN
CiANCiBzdGF0aWMgaW50DQogY2hlY2tlbnRyeShjb25zdCBjaGFyICp0YWJs
ZW5hbWUsDQotCSAgIGNvbnN0IHN0cnVjdCBpcHRfZW50cnkgKmUsDQorCSAg
IGNvbnN0IHZvaWQgKmUsDQogCSAgIHZvaWQgKnRhcmdpbmZvLA0KIAkgICB1
bnNpZ25lZCBpbnQgdGFyZ2luZm9zaXplLCB1bnNpZ25lZCBpbnQgaG9va19t
YXNrKQ0KIHsNCmRpZmYgLU51ciBwYXRjaC1vLW1hdGljLW5nLTIwMDYwMzEx
LW9yaWcvcGF0Y2hsZXRzL3NldC9saW51eC0yLjYvbmV0L2lwdjQvbmV0Zmls
dGVyL2lwdF9zZXQuYyBwYXRjaC1vLW1hdGljLW5nLTIwMDYwMzExL3BhdGNo
bGV0cy9zZXQvbGludXgtMi42L25ldC9pcHY0L25ldGZpbHRlci9pcHRfc2V0
LmMNCi0tLSBwYXRjaC1vLW1hdGljLW5nLTIwMDYwMzExLW9yaWcvcGF0Y2hs
ZXRzL3NldC9saW51eC0yLjYvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF9zZXQu
YwkyMDA0LTEyLTA2IDEwOjMyOjU5LjAwMDAwMDAwMCArMDEwMA0KKysrIHBh
dGNoLW8tbWF0aWMtbmctMjAwNjAzMTEvcGF0Y2hsZXRzL3NldC9saW51eC0y
LjYvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF9zZXQuYwkyMDA2LTAzLTIxIDIz
OjM1OjI5LjAwMDAwMDAwMCArMDEwMA0KQEAgLTM0LDYgKzM0LDcgQEANCiAg
ICAgICBjb25zdCBzdHJ1Y3QgbmV0X2RldmljZSAqb3V0LA0KICAgICAgIGNv
bnN0IHZvaWQgKm1hdGNoaW5mbywNCiAgICAgICBpbnQgb2Zmc2V0LA0KKyAg
ICAgIHVuc2lnbmVkIGludCBwcm90b2ZmLA0KICAgICAgIGludCAqaG90ZHJv
cCkNCiB7DQogCWNvbnN0IHN0cnVjdCBpcHRfc2V0X2luZm9fbWF0Y2ggKmlu
Zm8gPSBtYXRjaGluZm87DQpAQCAtNDUsNyArNDYsNyBAQA0KIA0KIHN0YXRp
YyBpbnQNCiBjaGVja2VudHJ5KGNvbnN0IGNoYXIgKnRhYmxlbmFtZSwNCi0J
ICAgY29uc3Qgc3RydWN0IGlwdF9pcCAqaXAsDQorCSAgIGNvbnN0IHZvaWQg
KmlwLA0KIAkgICB2b2lkICptYXRjaGluZm8sDQogCSAgIHVuc2lnbmVkIGlu
dCBtYXRjaHNpemUsDQogCSAgIHVuc2lnbmVkIGludCBob29rX21hc2spDQo=

---187430788-251415297-1143462014=:17783--
