From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH][TRIVIAL] warnings removal in some ip6 patches
Date: Tue, 14 Jan 2003 21:09:01 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0301142108170.32725@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY="-23717851-1463801144-1041966024=:19704"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.samba.org
Content-ID: <Pine.LNX.4.51.0301142108171.32725@dns.toxicfilms.tv>
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

---23717851-1463801144-1041966024=:19704
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <Pine.LNX.4.51.0301142108172.32725@dns.toxicfilms.tv>

Hi
i mistakenly sent it to the user mailin list on the 7th.

this patch adds casts to some ipv6 patches to remove compile warnings.

Best Regards,
Maciej Soltysiak

diff -ru netfilter.orig/patch-o-matic/base/ahesp6.patch.ipv6 netfilter/patch-o-matic/base/ahesp6.patch.ipv6
--- netfilter.orig/patch-o-matic/base/ahesp6.patch.ipv6	2003-01-07 19:49:12.000000000 +0100
+++ netfilter/patch-o-matic/base/ahesp6.patch.ipv6	2003-01-07 19:52:51.000000000 +0100
@@ -101,7 +101,7 @@
 +                     break;
 +              }
 +
-+              hdr=skb->data+ptr;
++              hdr=(struct ipv6_opt_hdr *)skb->data+ptr;
 +
 +              /* Calculate the header length */
 +                if (nexthdr == NEXTHDR_FRAGMENT) {
@@ -320,7 +320,7 @@
 +			break;
 +		}
 +
-+		hdr=skb->data+ptr;
++		hdr=(struct ipv6_opt_hdr *)skb->data+ptr;
 +
 +		/* Calculate the header length */
 +                if (nexthdr == NEXTHDR_FRAGMENT) {
diff -ru netfilter.orig/patch-o-matic/base/frag6.patch.ipv6 netfilter/patch-o-matic/base/frag6.patch.ipv6
--- netfilter.orig/patch-o-matic/base/frag6.patch.ipv6	2003-01-07 19:49:12.000000000 +0100
+++ netfilter/patch-o-matic/base/frag6.patch.ipv6	2003-01-07 19:53:00.000000000 +0100
@@ -115,7 +115,7 @@
 +                     break;
 +              }
 +
-+              hdr=skb->data+ptr;
++              hdr=(struct ipv6_opt_hdr *)skb->data+ptr;
 +
 +              /* Calculate the header length */
 +                if (nexthdr == NEXTHDR_FRAGMENT) {
diff -ru netfilter.orig/patch-o-matic/base/ipv6header.patch.ipv6 netfilter/patch-o-matic/base/ipv6header.patch.ipv6
--- netfilter.orig/patch-o-matic/base/ipv6header.patch.ipv6	2003-01-07 19:49:12.000000000 +0100
+++ netfilter/patch-o-matic/base/ipv6header.patch.ipv6	2003-01-07 19:53:07.000000000 +0100
@@ -120,7 +120,7 @@
 +			break;
 +		}
 +
-+		hdr=skb->data+ptr;
++		hdr=(struct ipv6_opt_hdr *)skb->data+ptr;
 +
 +		/* Calculate the header length */
 +                if (nexthdr == NEXTHDR_FRAGMENT) {
diff -ru netfilter.orig/patch-o-matic/base/route6.patch.ipv6 netfilter/patch-o-matic/base/route6.patch.ipv6
--- netfilter.orig/patch-o-matic/base/route6.patch.ipv6	2003-01-07 19:49:12.000000000 +0100
+++ netfilter/patch-o-matic/base/route6.patch.ipv6	2003-01-07 19:53:23.000000000 +0100
@@ -139,7 +139,7 @@
 +                     break;
 +              }
 +
-+              hdr=skb->data+ptr;
++              hdr=(struct ipv6_opt_hdr *)skb->data+ptr;
 +
 +              /* Calculate the header length */
 +                if (nexthdr == NEXTHDR_FRAGMENT) {




-----BEGIN GEEK CODE BLOCK-----
VERSION: 3.1
GIT/MU d-- s:- a-- C++ UL++++$ P L++++ E- W- N- K- w--- O! M- V- PS+ PE++
Y+ PGP- t+ 5-- X+ R tv- b DI+ D---- G e+++> h! y?
-----END GEEK CODE BLOCK-----
---23717851-1463801144-1041966024=:19704
Content-Type: TEXT/PLAIN; NAME="trivial_warnings.diff"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0301072000240.19704@dns.toxicfilms.tv>
Content-Description: trivial warnings
Content-Disposition: ATTACHMENT; FILENAME="trivial_warnings.diff"

ZGlmZiAtcnUgbmV0ZmlsdGVyLm9yaWcvcGF0Y2gtby1tYXRpYy9iYXNlL2Fo
ZXNwNi5wYXRjaC5pcHY2IG5ldGZpbHRlci9wYXRjaC1vLW1hdGljL2Jhc2Uv
YWhlc3A2LnBhdGNoLmlwdjYNCi0tLSBuZXRmaWx0ZXIub3JpZy9wYXRjaC1v
LW1hdGljL2Jhc2UvYWhlc3A2LnBhdGNoLmlwdjYJMjAwMy0wMS0wNyAxOTo0
OToxMi4wMDAwMDAwMDAgKzAxMDANCisrKyBuZXRmaWx0ZXIvcGF0Y2gtby1t
YXRpYy9iYXNlL2FoZXNwNi5wYXRjaC5pcHY2CTIwMDMtMDEtMDcgMTk6NTI6
NTEuMDAwMDAwMDAwICswMTAwDQpAQCAtMTAxLDcgKzEwMSw3IEBADQogKyAg
ICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KICsgICAgICAgICAgICAgIH0N
CiArDQotKyAgICAgICAgICAgICAgaGRyPXNrYi0+ZGF0YStwdHI7DQorKyAg
ICAgICAgICAgICAgaGRyPShzdHJ1Y3QgaXB2Nl9vcHRfaGRyICopc2tiLT5k
YXRhK3B0cjsNCiArDQogKyAgICAgICAgICAgICAgLyogQ2FsY3VsYXRlIHRo
ZSBoZWFkZXIgbGVuZ3RoICovDQogKyAgICAgICAgICAgICAgICBpZiAobmV4
dGhkciA9PSBORVhUSERSX0ZSQUdNRU5UKSB7DQpAQCAtMzIwLDcgKzMyMCw3
IEBADQogKwkJCWJyZWFrOw0KICsJCX0NCiArDQotKwkJaGRyPXNrYi0+ZGF0
YStwdHI7DQorKwkJaGRyPShzdHJ1Y3QgaXB2Nl9vcHRfaGRyICopc2tiLT5k
YXRhK3B0cjsNCiArDQogKwkJLyogQ2FsY3VsYXRlIHRoZSBoZWFkZXIgbGVu
Z3RoICovDQogKyAgICAgICAgICAgICAgICBpZiAobmV4dGhkciA9PSBORVhU
SERSX0ZSQUdNRU5UKSB7DQpkaWZmIC1ydSBuZXRmaWx0ZXIub3JpZy9wYXRj
aC1vLW1hdGljL2Jhc2UvZnJhZzYucGF0Y2guaXB2NiBuZXRmaWx0ZXIvcGF0
Y2gtby1tYXRpYy9iYXNlL2ZyYWc2LnBhdGNoLmlwdjYNCi0tLSBuZXRmaWx0
ZXIub3JpZy9wYXRjaC1vLW1hdGljL2Jhc2UvZnJhZzYucGF0Y2guaXB2Ngky
MDAzLTAxLTA3IDE5OjQ5OjEyLjAwMDAwMDAwMCArMDEwMA0KKysrIG5ldGZp
bHRlci9wYXRjaC1vLW1hdGljL2Jhc2UvZnJhZzYucGF0Y2guaXB2NgkyMDAz
LTAxLTA3IDE5OjUzOjAwLjAwMDAwMDAwMCArMDEwMA0KQEAgLTExNSw3ICsx
MTUsNyBAQA0KICsgICAgICAgICAgICAgICAgICAgICBicmVhazsNCiArICAg
ICAgICAgICAgICB9DQogKw0KLSsgICAgICAgICAgICAgIGhkcj1za2ItPmRh
dGErcHRyOw0KKysgICAgICAgICAgICAgIGhkcj0oc3RydWN0IGlwdjZfb3B0
X2hkciAqKXNrYi0+ZGF0YStwdHI7DQogKw0KICsgICAgICAgICAgICAgIC8q
IENhbGN1bGF0ZSB0aGUgaGVhZGVyIGxlbmd0aCAqLw0KICsgICAgICAgICAg
ICAgICAgaWYgKG5leHRoZHIgPT0gTkVYVEhEUl9GUkFHTUVOVCkgew0KZGlm
ZiAtcnUgbmV0ZmlsdGVyLm9yaWcvcGF0Y2gtby1tYXRpYy9iYXNlL2lwdjZo
ZWFkZXIucGF0Y2guaXB2NiBuZXRmaWx0ZXIvcGF0Y2gtby1tYXRpYy9iYXNl
L2lwdjZoZWFkZXIucGF0Y2guaXB2Ng0KLS0tIG5ldGZpbHRlci5vcmlnL3Bh
dGNoLW8tbWF0aWMvYmFzZS9pcHY2aGVhZGVyLnBhdGNoLmlwdjYJMjAwMy0w
MS0wNyAxOTo0OToxMi4wMDAwMDAwMDAgKzAxMDANCisrKyBuZXRmaWx0ZXIv
cGF0Y2gtby1tYXRpYy9iYXNlL2lwdjZoZWFkZXIucGF0Y2guaXB2NgkyMDAz
LTAxLTA3IDE5OjUzOjA3LjAwMDAwMDAwMCArMDEwMA0KQEAgLTEyMCw3ICsx
MjAsNyBAQA0KICsJCQlicmVhazsNCiArCQl9DQogKw0KLSsJCWhkcj1za2It
PmRhdGErcHRyOw0KKysJCWhkcj0oc3RydWN0IGlwdjZfb3B0X2hkciAqKXNr
Yi0+ZGF0YStwdHI7DQogKw0KICsJCS8qIENhbGN1bGF0ZSB0aGUgaGVhZGVy
IGxlbmd0aCAqLw0KICsgICAgICAgICAgICAgICAgaWYgKG5leHRoZHIgPT0g
TkVYVEhEUl9GUkFHTUVOVCkgew0KZGlmZiAtcnUgbmV0ZmlsdGVyLm9yaWcv
cGF0Y2gtby1tYXRpYy9iYXNlL3JvdXRlNi5wYXRjaC5pcHY2IG5ldGZpbHRl
ci9wYXRjaC1vLW1hdGljL2Jhc2Uvcm91dGU2LnBhdGNoLmlwdjYNCi0tLSBu
ZXRmaWx0ZXIub3JpZy9wYXRjaC1vLW1hdGljL2Jhc2Uvcm91dGU2LnBhdGNo
LmlwdjYJMjAwMy0wMS0wNyAxOTo0OToxMi4wMDAwMDAwMDAgKzAxMDANCisr
KyBuZXRmaWx0ZXIvcGF0Y2gtby1tYXRpYy9iYXNlL3JvdXRlNi5wYXRjaC5p
cHY2CTIwMDMtMDEtMDcgMTk6NTM6MjMuMDAwMDAwMDAwICswMTAwDQpAQCAt
MTM5LDcgKzEzOSw3IEBADQogKyAgICAgICAgICAgICAgICAgICAgIGJyZWFr
Ow0KICsgICAgICAgICAgICAgIH0NCiArDQotKyAgICAgICAgICAgICAgaGRy
PXNrYi0+ZGF0YStwdHI7DQorKyAgICAgICAgICAgICAgaGRyPShzdHJ1Y3Qg
aXB2Nl9vcHRfaGRyICopc2tiLT5kYXRhK3B0cjsNCiArDQogKyAgICAgICAg
ICAgICAgLyogQ2FsY3VsYXRlIHRoZSBoZWFkZXIgbGVuZ3RoICovDQogKyAg
ICAgICAgICAgICAgICBpZiAobmV4dGhkciA9PSBORVhUSERSX0ZSQUdNRU5U
KSB7DQo=
---23717851-1463801144-1041966024=:19704--
