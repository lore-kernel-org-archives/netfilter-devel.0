From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 3/4] nfqueue message is on a diet
Date: Mon, 13 Feb 2006 12:19:19 +0100
Message-ID: <20060213111919.GT4601@sunbeam.de.gnumonks.org>
References: <43EFF1EC.2070701@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dFvuq/4WPi1dbS7Q"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Content-Disposition: inline
In-Reply-To: <43EFF1EC.2070701@netfilter.org>
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


--dFvuq/4WPi1dbS7Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 13, 2006 at 03:41:48AM +0100, Pablo Neira Ayuso wrote:
> [NFNETLINK_QUEUE] nfqueue message is on a diet
>=20
> Fix oversized message, use NLMSG_SPACE just one since it reserves space
> for the netlink header.

I think before and after your patch, it is wrong in both cases.

What we rally need is:=20
- one time NLMSG_SPACE in order to account for the nlmsghdr
- all the other times:=20
	Size of struct nfattr=20
	+ size of data element=20
	+ alignment overhead

So IMHO we should use 1 time NLMSG_SPACE, then NFA_SPACE.  Please let me
know what you think, update your patch and resubmit.

Also, the same kind of fix is probably needed for nfnetlink_log.

> Sign-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Signed-off-by !

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--dFvuq/4WPi1dbS7Q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD8Gs3XaXGVTD0i/8RAq+YAKCD/UdeOnvPsBbv02WGjCPdtYRiAgCfU+AV
GeoyFJ9ujeP+vDKHL/zodBc=
=LC4a
-----END PGP SIGNATURE-----

--dFvuq/4WPi1dbS7Q--
