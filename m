From: Harald Welte <laforge@netfilter.org>
Subject: Re: Netfilter state table sync status?
Date: Mon, 17 May 2004 15:45:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040517134545.GE11060@obroa-skai.de.gnumonks.org>
References: <20040513121639.GK1775@edu.joroinen.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HeFlAV5LIbMFYYuh"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Content-Disposition: inline
In-Reply-To: <20040513121639.GK1775@edu.joroinen.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--HeFlAV5LIbMFYYuh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 13, 2004 at 03:16:39PM +0300, Pasi K=E4rkk=E4inen wrote:
> Hi,
>=20
> What's the current state of the Netfilter state table sync code? Is it
> already functional?=20

It's working, at least sort-of.  There are three currently known bugs
that I'm hunting down.

> I would like to synchronize the state tables of two different Netfilter
> boxes.

The current code is in CVS (netfilter-ha/ct_sync).  There are no
'easy-to-apply' patches yet.

the code has dependencies on nfnetlink-ctnetlink and l2netfilter from
pom-ng.

> I'm willing to test/debug it :)

great!
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--HeFlAV5LIbMFYYuh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAqMIIXaXGVTD0i/8RAg6RAJ9Ccb5oDsZKL6xt2bdW/ztNAH42DQCgosDZ
uAq2+wPd5vO6qldswQCXYNA=
=kjw+
-----END PGP SIGNATURE-----

--HeFlAV5LIbMFYYuh--
