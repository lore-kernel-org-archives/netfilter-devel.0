From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: pending/69_amanda-helpers.patch does not apply to 2.4.22?
Date: Mon, 13 Oct 2003 19:38:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1066066709.29187.129.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.44.0310112315200.14720-100000@filer.marasystems.com>
	 <1065913241.29186.4.camel@tux.rsn.bth.se>  <3F88C9AB.5010306@trash.net>
	 <1065955978.29179.67.camel@tux.rsn.bth.se>  <3F8AD263.7060802@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tTkpJ5JFR2KUot3mrUCR"
Cc: Henrik Nordstrom <hno@marasystems.com>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3F8AD263.7060802@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-tTkpJ5JFR2KUot3mrUCR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2003-10-13 at 18:27, Patrick McHardy wrote:
> Martin Josefsson wrote:
>=20
> >Almost, I still have a reject in ip_nat_amanda.c
> >
> > =20
> >
> It applies cleanly to latest 2.4 -bk. Which one did you test ?

2.4.22 + submitted and pending

I've found the problem, some patches that went into 2.4-bk havn't been
added to pom, fixing right now. Sorry about that.

--=20
/Martin

--=-tTkpJ5JFR2KUot3mrUCR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/iuMVWm2vlfa207ERAnfLAJoDtQmrHQAA6u11IEwH54mfByWF4wCfdY53
AIdffi7m9yOSPMD8eNFyf04=
=eXZH
-----END PGP SIGNATURE-----

--=-tTkpJ5JFR2KUot3mrUCR--
