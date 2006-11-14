From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH] nf_conntrack/nf_nat: nf_conntrack_netlink fix
Date: Tue, 14 Nov 2006 20:54:34 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0611142051120.1650@blackhole.kfki.hu>
References: <454D1C8F.5060302@trash.net> <454D291E.9010708@trash.net>
	<454D3137.40109@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391808-634696572-1163534074=:1650"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <454D3137.40109@trash.net>
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

--110391808-634696572-1163534074=:1650
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi Patrick,

Attached is a simple fix on top of your git tree.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110391808-634696572-1163534074=:1650
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=netlink0.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0611142054340.1650@blackhole.kfki.hu>
Content-Description: netlink0.patch
Content-Disposition: attachment; filename=netlink0.patch

W05FVEZJTFRFUl06IG5mX2Nvbm50cmFja19uZXRsaW5rOiBmaXggaG9va251
bQ0KDQpCdWdneSBwb3J0aW5nIGZpeGVkLCB3ZSBjYW4gZmlndXJlIG91dCB0
aGUgaG9va251bS4NCg0KU2lnbmVkLW9mZi1ieTogIEpvenNlZiBLYWRsZWNz
aWsgPGthZGxlY0BibGFja2hvbGUua2ZraS5odT4NCg0KZGlmZiAtdXJOIC0t
ZXhjbHVkZS1mcm9tPS91c3Ivc3JjL2RpZmYuZXhjbHVkZSBsaW51eC0yLjYu
MjAtbmF0LWNvcmUvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfbmV0bGlu
ay5jIGxpbnV4LTIuNi4yMC1uZXRsaW5rMC9uZXQvbmV0ZmlsdGVyL25mX2Nv
bm50cmFja19uZXRsaW5rLmMNCi0tLSBsaW51eC0yLjYuMjAtbmF0LWNvcmUv
bmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfbmV0bGluay5jCTIwMDYtMTEt
MDYgMTQ6MDg6MTUuMDAwMDAwMDAwICswMTAwDQorKysgbGludXgtMi42LjIw
LW5ldGxpbmswL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX25ldGxpbmsu
YwkyMDA2LTExLTE0IDIwOjQ1OjU3LjAwMDAwMDAwMCArMDEwMA0KQEAgLTgw
MSw4ICs4MDEsNiBAQA0KIAkJcmV0dXJuIC1FSU5WQUw7DQogI2Vsc2UNCiAJ
CXN0cnVjdCBuZl9uYXRfcmFuZ2UgcmFuZ2U7DQotCQkvKiBUaGlzIGlzIExZ
SU5HISBCdXQgaG93IGNvdWxkIHdlIGdldCB0aGUgcHJvcGVyIGRhdGE/ICov
DQotCQl1bnNpZ25lZCBpbnQgaG9va251bSA9IE5GX0lQX1BPU1RfUk9VVElO
RzsNCiANCiAJCWlmIChjZGFbQ1RBX05BVF9EU1QtMV0pIHsNCiAJCQlpZiAo
bmZuZXRsaW5rX3BhcnNlX25hdChjZGFbQ1RBX05BVF9EU1QtMV0sIGN0LA0K
QEAgLTgxMSw3ICs4MDksNyBAQA0KIAkJCWlmIChuZl9uYXRfaW5pdGlhbGl6
ZWQoY3QsDQogCQkJCQkgICAgICAgSE9PSzJNQU5JUChORl9JUF9QUkVfUk9V
VElORykpKQ0KIAkJCQlyZXR1cm4gLUVFWElTVDsNCi0JCQluZl9uYXRfc2V0
dXBfaW5mbyhjdCwgJnJhbmdlLCBob29rbnVtKTsNCisJCQluZl9uYXRfc2V0
dXBfaW5mbyhjdCwgJnJhbmdlLCBORl9JUF9QUkVfUk9VVElORyk7DQogCQl9
DQogCQlpZiAoY2RhW0NUQV9OQVRfU1JDLTFdKSB7DQogCQkJaWYgKG5mbmV0
bGlua19wYXJzZV9uYXQoY2RhW0NUQV9OQVRfU1JDLTFdLCBjdCwNCkBAIC04
MjAsNyArODE4LDcgQEANCiAJCQlpZiAobmZfbmF0X2luaXRpYWxpemVkKGN0
LA0KIAkJCQkJICAgICAgIEhPT0syTUFOSVAoTkZfSVBfUE9TVF9ST1VUSU5H
KSkpDQogCQkJCXJldHVybiAtRUVYSVNUOw0KLQkJCW5mX25hdF9zZXR1cF9p
bmZvKGN0LCAmcmFuZ2UsIGhvb2tudW0pOw0KKwkJCW5mX25hdF9zZXR1cF9p
bmZvKGN0LCAmcmFuZ2UsIE5GX0lQX1BPU1RfUk9VVElORyk7DQogCQl9DQog
I2VuZGlmDQogCX0NCg==

--110391808-634696572-1163534074=:1650--
