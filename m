From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: minor bug in iptables 1.2.9
Date: Sat, 31 Jan 2004 14:23:15 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1075555394.22658.0.camel@tux.rsn.bth.se>
References: <20040130084832.GA5527@sit0.ifup.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lQb/JQexFrGYliGS63Ym"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Karsten Desler <kdesler@soohrt.org>
In-Reply-To: <20040130084832.GA5527@sit0.ifup.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-lQb/JQexFrGYliGS63Ym
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2004-01-30 at 09:48, Karsten Desler wrote:

> strncpy does not \0-terminate strings if strlen(src) =3D=3D n, thus the
> following loop can easily run over the end of buf, if a big enough
> mask is given:
>   iptables -A INPUT -p tcp -s 1.1.1.1/000000000000000000.
>=20
> Attached is a patch to fix this problem.

Applied, thanks

--=20
/Martin

--=-lQb/JQexFrGYliGS63Ym
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAG6xBWm2vlfa207ERAh40AJ493fr0/d3PkyHadIBDPTa/YbxO2QCffcMw
zWPWQa+UOpPJXtd6cFfhE8o=
=8Oe3
-----END PGP SIGNATURE-----

--=-lQb/JQexFrGYliGS63Ym--
