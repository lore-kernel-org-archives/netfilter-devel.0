From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] fix correct_cache() in libiptc.c
Date: Sat, 5 Jul 2003 20:58:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030705185824.GI7073@sunbeam.de.gnumonks.org>
References: <1057411145.12437.128.camel@tux.rsn.bth.se> <20030705171403.GG7073@sunbeam.de.gnumonks.org> <1057426720.12433.140.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aWh+LmBTmEUMKd3g"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1057426720.12433.140.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--aWh+LmBTmEUMKd3g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 05, 2003 at 07:38:40PM +0200, Martin Josefsson wrote:
> On Sat, 2003-07-05 at 19:14, Harald Welte wrote:
>=20
> > Yes, as stated on the mailinglist, I even expect it to still be broken a
> > bit.
> >=20
> > Expect it to break even more in the future, I'm currently working on an
> > almost total reimplementation of the whole library.   The ruleset load
> > time ist still unbearable.
>=20
> I hope you are abandoning the "API" the current library has?

no, not at all. It has to be 100% compatible.

> It will break a lot of "third-party" stuff but IMHO it's worth it.

No.  That's for pkttables.  It's not worth changing the old api.

> /Martin

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--aWh+LmBTmEUMKd3g
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/Bx/QXaXGVTD0i/8RAtcnAJ42fxf99aDODqVDxbHMBECYyj/piACfcdTN
zjNrs+E4IWEXuoZILt4/pus=
=Tvle
-----END PGP SIGNATURE-----

--aWh+LmBTmEUMKd3g--
