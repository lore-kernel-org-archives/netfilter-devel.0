From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [BUG] UDP connection tracking failure
Date: Thu, 5 Sep 2002 10:48:30 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020905084830.GE1064@naboo.lincon.Uni-Koeln.DE>
References: <200208271837.g7RIbkm02830@vindaloo.ras.ucalgary.ca> <1030623591.5131.295.camel@tux> <200208311650.g7VGooe19044@vindaloo.ras.ucalgary.ca> <1030815452.2313.1.camel@tux>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MfFXiAuoTsnnDAfZ"
Cc: Richard Gooch <rgooch@ras.ucalgary.ca>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1030815452.2313.1.camel@tux>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--MfFXiAuoTsnnDAfZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 31, 2002 at 07:37:32PM +0200, Martin Josefsson wrote:
> On Sat, 2002-08-31 at 18:50, Richard Gooch wrote:
>=20
> > > The attached diff might help, I don't know how correct it is, I'm not=
 so
> > > familiar with the gory details of conntrack yet. It might screw up the
> > > tcp timeouts (or not).
> > >=20
> > > Please test and report back to this list
> > > (netfilter-devel@lists.netfilter.org) if it works.
> >=20
> > Yes, your patch works nicely, thank you. Will this be picked up and
> > fed into the mainline kernel?
>=20
> I will run it by the coreteam, they know the internals better than I do,
> This fix might not be 100% correct for all cases.

The problem is that TCP is making an assumption on the old behaviour in
line 194 of ip_conntrack_proto_tcp.c

In general I think the way you have fixed the UDP case is correct - but
you should somehow make sure that the TCP RST codepath is still working.

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--MfFXiAuoTsnnDAfZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9dxpeXaXGVTD0i/8RAmlqAJ9roJ3j5JDncaYcA9ZqSN4CHVsfHwCgiwP/
ETilbZR4Rozx9Tv3vW5Ocrw=
=YKOs
-----END PGP SIGNATURE-----

--MfFXiAuoTsnnDAfZ--
