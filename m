From: Gianni Tedesco <gianni@ecsc.co.uk>
Subject: Re: Layer-7 HTTP Matching Module
Date: 07 Feb 2003 10:42:40 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1044614560.17229.25.camel@lemsip>
References: <Pine.LNX.4.44.0302040925160.12235-100000@kaybee.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature";
	boundary="=-AsyEGXW/VibIQFj1IEIu"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kirk Bauer <kirk@kaybee.org>
In-Reply-To: <Pine.LNX.4.44.0302040925160.12235-100000@kaybee.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-AsyEGXW/VibIQFj1IEIu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2003-02-04 at 14:29, Kirk Bauer wrote:
> -m --content-type 'text/html' --host 'www.mydomain.com'
>=20
> It seems that if the string matching module is possible, then this is
> also possible. =20

The string matching module although possible is insecure on all but the
most basic stateless protocols. A better framework for this kind of
thing would probably be the KTCPVS[0] or to modify tux[1] for the task
if you want to do caching at the same time.

0. http://www.linuxvirtualserver.org/software/ktcpvs/ktcpvs.html
1. http://people.redhat.com/mingo/TUX-patches/

--=20
// Gianni Tedesco (gianni at scaramanga dot co dot uk)
lynx --source www.scaramanga.co.uk/gianni-at-ecsc.asc | gpg --import
8646BE7D: 6D9F 2287 870E A2C9 8F60 3A3C 91B5 7669 8646 BE7D

--=-AsyEGXW/VibIQFj1IEIu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQA+Q42gkbV2aYZGvn0RAkLJAJ9ZUVhqKz9h0o2crWWtot55cCQ6/ACff3VP
EjG81p4T6+VSaCgjEpCJlqo=
=nEru
-----END PGP SIGNATURE-----

--=-AsyEGXW/VibIQFj1IEIu--
