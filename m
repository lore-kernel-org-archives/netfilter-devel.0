From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Fix warning in ipt_u32
Date: Mon, 31 Oct 2005 17:23:20 +0100 (CET)
Message-ID: <Pine.LNX.4.62.0510311721380.2118@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1623345986-1130775800=:2118"
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

---187430788-1623345986-1130775800=:2118
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

Attached (and inlined) patch fixes two warning in ipt_u32 about unused=20
variables.

diff -Nur patch-o-matic-ng-20051019-orig/patchlets/u32/linux-2.6/net/ipv4/n=
etfilter/ipt_u32.c patch-o-matic-ng-20051019/patchlets/u32/linux-2.6/net/ip=
v4/netfilter/ipt_u32.c
--- patch-o-matic-ng-20051019-orig/patchlets/u32/linux-2.6/net/ipv4/netfilt=
er/ipt_u32.c=092005-09-19 16:52:34.000000000 +0200
+++ patch-o-matic-ng-20051019/patchlets/u32/linux-2.6/net/ipv4/netfilter/ip=
t_u32.c=092005-10-20 17:32:20.000000000 +0200
@@ -126,10 +126,8 @@
  {
  =09const struct ipt_u32 *data =3D matchinfo;
  =09int testind, i;
-=09unsigned char* origbase;
  =09unsigned char* base;
  =09unsigned char* head;
-=09unsigned char* end;
  =09int nnums, nvals;
  =09u_int32_t pos, val;



Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-1623345986-1130775800=:2118
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=patch-u32-warnings.diff
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.62.0510311723200.2118@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=patch-u32-warnings.diff

ZGlmZiAtTnVyIHBhdGNoLW8tbWF0aWMtbmctMjAwNTEwMTktb3JpZy9wYXRj
aGxldHMvdTMyL2xpbnV4LTIuNi9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0X3Uz
Mi5jIHBhdGNoLW8tbWF0aWMtbmctMjAwNTEwMTkvcGF0Y2hsZXRzL3UzMi9s
aW51eC0yLjYvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF91MzIuYw0KLS0tIHBh
dGNoLW8tbWF0aWMtbmctMjAwNTEwMTktb3JpZy9wYXRjaGxldHMvdTMyL2xp
bnV4LTIuNi9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0X3UzMi5jCTIwMDUtMDkt
MTkgMTY6NTI6MzQuMDAwMDAwMDAwICswMjAwDQorKysgcGF0Y2gtby1tYXRp
Yy1uZy0yMDA1MTAxOS9wYXRjaGxldHMvdTMyL2xpbnV4LTIuNi9uZXQvaXB2
NC9uZXRmaWx0ZXIvaXB0X3UzMi5jCTIwMDUtMTAtMjAgMTc6MzI6MjAuMDAw
MDAwMDAwICswMjAwDQpAQCAtMTI2LDEwICsxMjYsOCBAQA0KIHsNCiAJY29u
c3Qgc3RydWN0IGlwdF91MzIgKmRhdGEgPSBtYXRjaGluZm87DQogCWludCB0
ZXN0aW5kLCBpOw0KLQl1bnNpZ25lZCBjaGFyKiBvcmlnYmFzZTsNCiAJdW5z
aWduZWQgY2hhciogYmFzZTsNCiAJdW5zaWduZWQgY2hhciogaGVhZDsNCi0J
dW5zaWduZWQgY2hhciogZW5kOw0KIAlpbnQgbm51bXMsIG52YWxzOw0KIAl1
X2ludDMyX3QgcG9zLCB2YWw7DQogDQo=

---187430788-1623345986-1130775800=:2118--
