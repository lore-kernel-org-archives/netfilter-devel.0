From: Harald Welte <laforge@netfilter.org>
Subject: Re: faster way to read conntrack state than /proc ?
Date: Sat, 18 Oct 2003 18:32:20 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031018163220.GJ21521@sunbeam.de.gnumonks.org>
References: <20031018074256.GA29942@alpha.home.local> <1066467318.12167.80.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UEWYo9iD5Le5Jrpm"
Cc: Willy Tarreau <willy@w.ods.org>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1066467318.12167.80.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--UEWYo9iD5Le5Jrpm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 18, 2003 at 10:55:19AM +0200, Martin Josefsson wrote:

> We have something called nfnetlink and ctnetlink. ctnetlink has the
> ability to dump all connections via netlink (unless someone, possibly
> me, broke it).
>=20
> see extra/nfnetlink-ctnetlink-0.11.patch in patch-o-matic
>=20
> This patch is very experimental and it may crash your machine.
> I have a few quick fixes at
> http://kashyyyk.netfilter.org/~gandalf/patches/nfnetlink_conntrack-fix.di=
ff
> Some of them has been applied to cvs so you'll have to hand-merge.

I've now merged those fixes with nfnetlink-ctnetlink-0.11.patch in CVS

> --=20
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

--UEWYo9iD5Le5Jrpm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/kWsUXaXGVTD0i/8RAq1aAKCMVqTSn/PKf9o//cekmmYu43w1HQCdGVRn
2hIBS0icRL2LPufv5QBUktA=
=bmLM
-----END PGP SIGNATURE-----

--UEWYo9iD5Le5Jrpm--
