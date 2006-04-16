From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] Transmit mark to userspace during conntrack event
Date: Sun, 16 Apr 2006 23:45:45 +0200
Message-ID: <1145223945.5659.4.camel@porky>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-d1Gzp+Wsl7SYQptBqvsW"
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


--=-d1Gzp+Wsl7SYQptBqvsW
Content-Type: multipart/mixed; boundary="=-mEbMYKh8IO/HanKzo/Re"


--=-mEbMYKh8IO/HanKzo/Re
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

When userspace listen to conntrack event, the connection mark was not
sent in the ctnetlink message. The following patch transmits the
connection mark to userspace.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-mEbMYKh8IO/HanKzo/Re
Content-Disposition: attachment; filename=conntrack_event_with_mark.patch
Content-Type: text/x-patch; name=conntrack_event_with_mark.patch;
	charset=ISO-8859-15
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL25ldC9pcHY0L25ldGZpbHRlci9pcF9jb25udHJhY2tfbmV0bGluay5jIGIv
bmV0L2lwdjQvbmV0ZmlsdGVyL2lwX2Nvbm50cmFja19uZXRsaW5rLmMNCmluZGV4IDAxYmQ3Y2Eu
LjA5ODJhOWQgMTAwNjQ0DQotLS0gYS9uZXQvaXB2NC9uZXRmaWx0ZXIvaXBfY29ubnRyYWNrX25l
dGxpbmsuYw0KKysrIGIvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwX2Nvbm50cmFja19uZXRsaW5rLmMN
CkBAIC0zODUsNiArMzg1LDkgQEAgc3RhdGljIGludCBjdG5ldGxpbmtfY29ubnRyYWNrX2V2ZW50
KHN0cg0KIAkgICAgY3RuZXRsaW5rX2R1bXBfY291bnRlcnMoc2tiLCBjdCwgSVBfQ1RfRElSX1JF
UExZKSA8IDApDQogCQlnb3RvIG5mYXR0cl9mYWlsdXJlOw0KIA0KKwlpZiAoY3RuZXRsaW5rX2R1
bXBfbWFyayhza2IsY3QpIDwgMCkNCisJCWdvdG8gbmZhdHRyX2ZhaWx1cmU7DQorDQogCW5saC0+
bmxtc2dfbGVuID0gc2tiLT50YWlsIC0gYjsNCiAJbmZuZXRsaW5rX3NlbmQoc2tiLCAwLCBncm91
cCwgMCk7DQogCXJldHVybiBOT1RJRllfRE9ORTsNCmRpZmYgLS1naXQgYS9uZXQvbmV0ZmlsdGVy
L25mX2Nvbm50cmFja19uZXRsaW5rLmMgYi9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19uZXRs
aW5rLmMNCmluZGV4IGJkMTBlYjkuLjQ1OGEwZDUgMTAwNjQ0DQotLS0gYS9uZXQvbmV0ZmlsdGVy
L25mX2Nvbm50cmFja19uZXRsaW5rLmMNCisrKyBiL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNr
X25ldGxpbmsuYw0KQEAgLTM5NCw2ICszOTQsOSBAQCBzdGF0aWMgaW50IGN0bmV0bGlua19jb25u
dHJhY2tfZXZlbnQoc3RyDQogCSAgICBjdG5ldGxpbmtfZHVtcF9jb3VudGVycyhza2IsIGN0LCBJ
UF9DVF9ESVJfUkVQTFkpIDwgMCkNCiAJCWdvdG8gbmZhdHRyX2ZhaWx1cmU7DQogDQorCWlmIChj
dG5ldGxpbmtfZHVtcF9tYXJrKHNrYixjdCkgPCAwKQ0KKwkJZ290byBuZmF0dHJfZmFpbHVyZTsN
CisNCiAJbmxoLT5ubG1zZ19sZW4gPSBza2ItPnRhaWwgLSBiOw0KIAluZm5ldGxpbmtfc2VuZChz
a2IsIDAsIGdyb3VwLCAwKTsNCiAJcmV0dXJuIE5PVElGWV9ET05FOw0K


--=-mEbMYKh8IO/HanKzo/Re--

--=-d1Gzp+Wsl7SYQptBqvsW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBEQrsInxA7CdMWjzIRAkoGAJ0ckCZGMprChJlIQw41H9rx5QUxzgCfeD8s
eKUHyGcMa73Tg1z4aJjEFwI=
=9+xM
-----END PGP SIGNATURE-----

--=-d1Gzp+Wsl7SYQptBqvsW--
