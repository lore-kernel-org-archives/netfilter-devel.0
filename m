From: Jesper Dangaard Brouer <hawk@comx.dk>
Subject: Re: Concurrency issues with the iptables userspace
	program	andexitcodes
Date: Wed, 14 Jun 2006 16:40:40 +0200
Message-ID: <1150296040.26187.114.camel@localhost.localdomain>
References: <1149153349.28481.15.camel@localhost.localdomain>
	<447F1227.7050900@trash.net>
	<Pine.LNX.4.61.0606012200260.27621@ask.diku.dk>
	<447F5204.4080505@trash.net>
	<1149771143.28481.87.camel@localhost.localdomain>
	<44901796.6040000@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-Et8RuXNpl9q77QK87lQ5"
Cc: Jesper Dangaard Brouer <hawk@diku.dk>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44901796.6040000@trash.net>
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


--=-Et8RuXNpl9q77QK87lQ5
Content-Type: multipart/mixed; boundary="=-HzZsogr9DmFO5g/ZmzG8"


--=-HzZsogr9DmFO5g/ZmzG8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2006-06-14 at 16:05 +0200, Patrick McHardy wrote:
> Jesper Dangaard Brouer wrote:
> > For example something like the following patch?
> >=20
> > I have tracked down where the "Resource temporarily unavailable" occurs
> > in libiptc.c, and marked it with a comment... if you can use it for any
> > thing.
>=20
> Seems like you forgot to attach the patch :)

Hmmm... I though I did include it inline below my signature... well lets
try again...This time I also attach it as a file attachment.

--=20
Med venlig hilsen / Best regards
  Jesper Brouer
  ComX Networks A/S
  Linux Network developer
  Cand. Scient Datalog / MSc.
  Author of http://adsl-optimizer.dk

---

diff --exclude '*.d' --exclude-from /var/kernel/exclude_these -urpN iptable=
s-1.3.4-pom-l7/include/iptables_common.h iptables-1.3.4-pom-l7-blocking/inc=
lude/iptables_common.h
--- iptables-1.3.4-pom-l7/include/iptables_common.h	2005-10-31 20:03:49.000=
000000 +0100
+++ iptables-1.3.4-pom-l7-blocking/include/iptables_common.h	2006-06-08 14:=
19:53.000000000 +0200
@@ -5,7 +5,8 @@
 enum exittype {
 	OTHER_PROBLEM =3D 1,
 	PARAMETER_PROBLEM,
-	VERSION_PROBLEM
+	VERSION_PROBLEM,
+	RESOURCE_PROBLEM
 };
=20
 /* this is a special 64bit data type that is 8-byte aligned */
diff --exclude '*.d' --exclude-from /var/kernel/exclude_these -urpN iptable=
s-1.3.4-pom-l7/iptables-standalone.c iptables-1.3.4-pom-l7-blocking/iptable=
s-standalone.c
--- iptables-1.3.4-pom-l7/iptables-standalone.c	2005-01-04 11:38:39.0000000=
00 +0100
+++ iptables-1.3.4-pom-l7-blocking/iptables-standalone.c	2006-06-08 14:23:4=
8.000000000 +0200
@@ -64,9 +64,13 @@ main(int argc, char *argv[])
 	if (ret)
 		ret =3D iptc_commit(&handle);
=20
-	if (!ret)
+	if (!ret) {
 		fprintf(stderr, "iptables: %s\n",
 			iptc_strerror(errno));
+		if (errno =3D=3D EAGAIN) {
+			exit(RESOURCE_PROBLEM);
+		}
+	}
=20
 	exit(!ret);
 }
diff --exclude '*.d' --exclude-from /var/kernel/exclude_these -urpN iptable=
s-1.3.4-pom-l7/libiptc/libiptc.c iptables-1.3.4-pom-l7-blocking/libiptc/lib=
iptc.c
--- iptables-1.3.4-pom-l7/libiptc/libiptc.c	2005-10-31 20:03:49.000000000 +=
0100
+++ iptables-1.3.4-pom-l7-blocking/libiptc/libiptc.c	2006-06-07 10:25:02.00=
0000000 +0200
@@ -2104,6 +2104,7 @@ TC_COMMIT(TC_HANDLE_T *handle)
 		free(repl->counters);
 		free(repl);
 		free(newcounters);
+		// The "EAGAIN: Resource temporarily unavailable" occurs here.
 		return 0;
 	}
=20


--=-HzZsogr9DmFO5g/ZmzG8
Content-Disposition: attachment; filename=iptables-1.3.4-EAGAIN.diff
Content-Type: text/x-patch; name=iptables-1.3.4-EAGAIN.diff; charset=iso-8859-1
Content-Transfer-Encoding: base64

ZGlmZiAtLWV4Y2x1ZGUgJyouZCcgLS1leGNsdWRlLWZyb20gL3Zhci9rZXJuZWwvZXhjbHVkZV90
aGVzZSAtdXJwTiBpcHRhYmxlcy0xLjMuNC1wb20tbDcvaW5jbHVkZS9pcHRhYmxlc19jb21tb24u
aCBpcHRhYmxlcy0xLjMuNC1wb20tbDctYmxvY2tpbmcvaW5jbHVkZS9pcHRhYmxlc19jb21tb24u
aA0KLS0tIGlwdGFibGVzLTEuMy40LXBvbS1sNy9pbmNsdWRlL2lwdGFibGVzX2NvbW1vbi5oCTIw
MDUtMTAtMzEgMjA6MDM6NDkuMDAwMDAwMDAwICswMTAwDQorKysgaXB0YWJsZXMtMS4zLjQtcG9t
LWw3LWJsb2NraW5nL2luY2x1ZGUvaXB0YWJsZXNfY29tbW9uLmgJMjAwNi0wNi0wOCAxNDoxOTo1
My4wMDAwMDAwMDAgKzAyMDANCkBAIC01LDcgKzUsOCBAQA0KIGVudW0gZXhpdHR5cGUgew0KIAlP
VEhFUl9QUk9CTEVNID0gMSwNCiAJUEFSQU1FVEVSX1BST0JMRU0sDQotCVZFUlNJT05fUFJPQkxF
TQ0KKwlWRVJTSU9OX1BST0JMRU0sDQorCVJFU09VUkNFX1BST0JMRU0NCiB9Ow0KIA0KIC8qIHRo
aXMgaXMgYSBzcGVjaWFsIDY0Yml0IGRhdGEgdHlwZSB0aGF0IGlzIDgtYnl0ZSBhbGlnbmVkICov
DQpkaWZmIC0tZXhjbHVkZSAnKi5kJyAtLWV4Y2x1ZGUtZnJvbSAvdmFyL2tlcm5lbC9leGNsdWRl
X3RoZXNlIC11cnBOIGlwdGFibGVzLTEuMy40LXBvbS1sNy9pcHRhYmxlcy1zdGFuZGFsb25lLmMg
aXB0YWJsZXMtMS4zLjQtcG9tLWw3LWJsb2NraW5nL2lwdGFibGVzLXN0YW5kYWxvbmUuYw0KLS0t
IGlwdGFibGVzLTEuMy40LXBvbS1sNy9pcHRhYmxlcy1zdGFuZGFsb25lLmMJMjAwNS0wMS0wNCAx
MTozODozOS4wMDAwMDAwMDAgKzAxMDANCisrKyBpcHRhYmxlcy0xLjMuNC1wb20tbDctYmxvY2tp
bmcvaXB0YWJsZXMtc3RhbmRhbG9uZS5jCTIwMDYtMDYtMDggMTQ6MjM6NDguMDAwMDAwMDAwICsw
MjAwDQpAQCAtNjQsOSArNjQsMTMgQEAgbWFpbihpbnQgYXJnYywgY2hhciAqYXJndltdKQ0KIAlp
ZiAocmV0KQ0KIAkJcmV0ID0gaXB0Y19jb21taXQoJmhhbmRsZSk7DQogDQotCWlmICghcmV0KQ0K
KwlpZiAoIXJldCkgew0KIAkJZnByaW50ZihzdGRlcnIsICJpcHRhYmxlczogJXNcbiIsDQogCQkJ
aXB0Y19zdHJlcnJvcihlcnJubykpOw0KKwkJaWYgKGVycm5vID09IEVBR0FJTikgew0KKwkJCWV4
aXQoUkVTT1VSQ0VfUFJPQkxFTSk7DQorCQl9DQorCX0NCiANCiAJZXhpdCghcmV0KTsNCiB9DQpk
aWZmIC0tZXhjbHVkZSAnKi5kJyAtLWV4Y2x1ZGUtZnJvbSAvdmFyL2tlcm5lbC9leGNsdWRlX3Ro
ZXNlIC11cnBOIGlwdGFibGVzLTEuMy40LXBvbS1sNy9saWJpcHRjL2xpYmlwdGMuYyBpcHRhYmxl
cy0xLjMuNC1wb20tbDctYmxvY2tpbmcvbGliaXB0Yy9saWJpcHRjLmMNCi0tLSBpcHRhYmxlcy0x
LjMuNC1wb20tbDcvbGliaXB0Yy9saWJpcHRjLmMJMjAwNS0xMC0zMSAyMDowMzo0OS4wMDAwMDAw
MDAgKzAxMDANCisrKyBpcHRhYmxlcy0xLjMuNC1wb20tbDctYmxvY2tpbmcvbGliaXB0Yy9saWJp
cHRjLmMJMjAwNi0wNi0wNyAxMDoyNTowMi4wMDAwMDAwMDAgKzAyMDANCkBAIC0yMTA0LDYgKzIx
MDQsNyBAQCBUQ19DT01NSVQoVENfSEFORExFX1QgKmhhbmRsZSkNCiAJCWZyZWUocmVwbC0+Y291
bnRlcnMpOw0KIAkJZnJlZShyZXBsKTsNCiAJCWZyZWUobmV3Y291bnRlcnMpOw0KKwkJLy8gVGhl
ICJFQUdBSU46IFJlc291cmNlIHRlbXBvcmFyaWx5IHVuYXZhaWxhYmxlIiBvY2N1cnMgaGVyZS4N
CiAJCXJldHVybiAwOw0KIAl9DQogDQo=


--=-HzZsogr9DmFO5g/ZmzG8--

--=-Et8RuXNpl9q77QK87lQ5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBEkB/owuVH+NB3fZkRAkL2AJ0dnHlXuz7VfrlqN1Hfmjq1iD2X7wCfSXpm
2XC08LbyL7SFvzsZKHbPdxs=
=ZHuy
-----END PGP SIGNATURE-----

--=-Et8RuXNpl9q77QK87lQ5--
