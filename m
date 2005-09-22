From: Harald Welte <laforge@netfilter.org>
Subject: Re: ip_conntrack_tcp_be_liberal vs. large downloads?
Date: Thu, 22 Sep 2005 14:35:43 +0200
Message-ID: <20050922123543.GE26520@sunbeam.de.gnumonks.org>
References: <20050920080825.GA6536@merlin.emma.line.org>
	<Pine.LNX.4.58.0509201127490.745@blackhole.kfki.hu>
	<20050920094641.GB18821@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="llIrKcgUOe3dCx0c"
Cc: netfilter-devel@lists.netfilter.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Matthias Andree <matthias.andree@gmx.de>
Content-Disposition: inline
In-Reply-To: <20050920094641.GB18821@merlin.emma.line.org>
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


--llIrKcgUOe3dCx0c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 20, 2005 at 11:46:41AM +0200, Matthias Andree wrote:
> On Tue, 20 Sep 2005, Jozsef Kadlecsik wrote:
>=20
> > > I can also test newer kernels if needed - only if there'd been some b=
ug,
> > > I might have assumed that SUSE rolled a patch into one of their update
> > > kernels.
> >=20
> > Please try newer kernels - I smell SACKing lost packets and ACKing out =
of
> > window segments here, which is fixed (i.e. supported) in recent kernels.
>=20
> Maybe, although turning SACK of didn't help (of course if the other side
> is doing it, my turning it off cannot help :)

if you prevent SACKPERM tcp option to be set up in any direction (e.g.
by replacing it with noop options), then you could reliably turn it off.
Maybe it's time for an iptables TCPOPTSSTRIP target ;)


--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--llIrKcgUOe3dCx0c
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDMqUfXaXGVTD0i/8RAu6iAJ9BVkeE1y1Hg5Z4s4T14ist6tN7UgCePbyX
YMC6ptUlsXhJ8JP9KwfccoM=
=8eLJ
-----END PGP SIGNATURE-----

--llIrKcgUOe3dCx0c--
