From: Harald Welte <laforge@netfilter.org>
Subject: Re: NAT && TIME_WAIT TCP connections
Date: Thu, 2 Oct 2003 22:05:18 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031002200518.GD5758@sunbeam.de.gnumonks.org>
References: <3F78239B.7000406@balabit.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZU15DBTNJjBFkMdF"
Cc: Netfilter Devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kovacs Krisztian <hidden@balabit.hu>
Content-Disposition: inline
In-Reply-To: <3F78239B.7000406@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ZU15DBTNJjBFkMdF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 29, 2003 at 02:20:43PM +0200, Kovacs Krisztian wrote:

>   While the upper example may look a bit extreme, such problems occur=20
> much more often when using the TPROXY patch and a transparent SQUID proxy=
=2E=20
> The attached patch helped a lot in these cases (and after modifying=20
> ip_conntrack_proto_tcp.c accordingly, to mark TPROXY-ed TCP connections=
=20
> 'deletable' when they reach the TIME_WAIT state).
>=20
>   Any comments? (I don't like the idea of deleting conntrack entries in=
=20
> ip_nat_setup_info(), however, I don't have a better idea.)

It's questionable whether we should optimize for minimization of tuple
allocations at the cost of run time performance :(

I'm really not sure if it's worth the effort.

>   Regards,
>     Krisztian KOVACS
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ZU15DBTNJjBFkMdF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fIT+XaXGVTD0i/8RAs+zAKCI5P5Cfxnf4Y8l3aNMfxSPXWhW0gCdFHwz
nH0ZOeFgC8gAgS5JEuvR/Z4=
=+ZLO
-----END PGP SIGNATURE-----

--ZU15DBTNJjBFkMdF--
