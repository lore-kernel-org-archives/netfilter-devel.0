From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] [LIBNFNETLINK] fixes
Date: Sun, 15 Jan 2006 10:45:21 +0100
Message-ID: <20060115094521.GG6740@sunbeam.de.gnumonks.org>
References: <43C9B94E.9040409@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K/+MhuhYzqQJJ3Xj"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <43C9B94E.9040409@netfilter.org>
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


--K/+MhuhYzqQJJ3Xj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 15, 2006 at 03:54:06AM +0100, Pablo Neira Ayuso wrote:
> Hi Harald!
>=20
> The patch attached fixes two issues in libnfnetlink:
>=20
> - subsys_id was not set in nfnl_subsys_open
> - set nfnlh->local.nl_pid in nfnl_open since nfnl_talk checks that:
> h->nlmsg_pid !=3D nfnlh->local.nl_pid

unfortunately no patch attached...

> Now the libnetfilter_conntrack test says OK again ;)

great. sorry for the breakage, but I hope you can appreciate the beauty
of this new concept.  Being able to talk to all nfnetlink subsystems at
the same time through one socket...

Cheers,
	Harald
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--K/+MhuhYzqQJJ3Xj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDyhmxXaXGVTD0i/8RApKmAJ0ZGzyFwx2nAV4XFLVpzuALcublCgCcDwsK
9adi4hBm6XO47eFeEW3chP0=
=iig8
-----END PGP SIGNATURE-----

--K/+MhuhYzqQJJ3Xj--
