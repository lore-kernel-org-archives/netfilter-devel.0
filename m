From: Daniel 'NebuchadnezzaR' Dehennin <nebuchadnezzar@nerim.net>
Subject: ipt_sctp undeclared variable
Date: Sun, 14 Mar 2004 14:17:17 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <87znajva8y.fsf@thorr.asgardr.info>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

hello,

I try the latest pom-ng (from cvs) and I have an error during
the build:

net/ipv4/netfilter/ipt_sctp.c: In function =AB match_packet =BB:
net/ipv4/netfilter/ipt_sctp.c:59: error: `i' undeclared (first use in this =
function)
net/ipv4/netfilter/ipt_sctp.c:59: error: (Each undeclared identifier is rep=
orted only once
net/ipv4/netfilter/ipt_sctp.c:59: error: for each function it appears in.)
make[4]: *** [net/ipv4/netfilter/ipt_sctp.o] Erreur 1

Thanks.
=2D-=20
Daniel 'NebuchadnezzaR' Dehennin
R=E9cupp=E9rer ma clef GPG:
gpg --keyserver pgp.mit.edu --recv-keys 0x4CA73DC6

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iQEVAwUAQFRbYdWamn5Mpz3GAQK5QQf8D+sDmcaA4a1+MbEoewhzRBgEIPKwnXqY
37qi4ASqbu8Vbgm1W2WTqKc03SR+z/A9zJ5N0B30o4PgKxkqa7ZyKdl1davIKof0
5mssS9g08IlN/i6eZdhPG7KSIyhrXQR3m5OVbaZ8MwgN9afW88K3PGlk/kl1vZlY
h9Nh49WmvBsPW9aPDdCmc2ynkUJQdC0rDYlKybRBWqajUjjLoPLzKtrdK94PNeeN
EfmGNJ0wp2eMiEvgwBD0tOs1yA0P0z4m8bZwAc0hHAI01cwtnQy/ZXdg4BftbQ2Y
c9HYeU7qI7Zem8D/5bxn/4F2ym4CVLKj2cazyqodU6SjkWQGUEuiQQ==
=YS3m
-----END PGP SIGNATURE-----
--=-=-=--
