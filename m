From: Harald Welte <laforge@netfilter.org>
Subject: Re: nf_conntrack [was Re: [PATCH 1/4] RFC: fast string matching
	infrastrure for netfilter]
Date: Mon, 10 Jan 2005 22:20:34 +0100
Message-ID: <20050110212034.GY18568@sunbeam.de.gnumonks.org>
References: <41E1AECD.6020209@eurodev.net> <41E1B9F1.7010106@trash.net>
	<Pine.LNX.4.58.0501102041430.28819@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7mIJwGTFTwAlEXlA"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0501102041430.28819@blackhole.kfki.hu>
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


--7mIJwGTFTwAlEXlA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 10, 2005 at 08:54:40PM +0100, Jozsef Kadlecsik wrote:
>=20
> > I have actually given up keeping nf_conntrack up to date currently, but
> > I hope we can now really put ip_conntrack in maintenance mode and
> > concentrate
> > on nf_conntrack. Any chance you want to base this on the nf_conntrack
> > patch ?
>=20
> Actually, what is the opinion that nf_conntrack uses the union of IPv4 and
> IPv6 addresses in the tuples?

My opinion was that we can rectify the waste of bytes here, since we
save so many bytes due to the get_features and multiple sized conntrack
structures.

> Jozsef

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--7mIJwGTFTwAlEXlA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB4vGiXaXGVTD0i/8RAslCAJ9/8Uq64FLJT/oNO15rV+d/gJnMugCglPw3
7Nnx2tjOYNAZfrlui6oi86M=
=2orw
-----END PGP SIGNATURE-----

--7mIJwGTFTwAlEXlA--
