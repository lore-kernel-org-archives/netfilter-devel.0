From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Q about ip_conntrack_expect_related()/ip_nat_expect_register()
Date: Wed, 30 Oct 2002 09:44:06 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021030094406.N8635@sunbeam.de.gnumonks.org>
References: <3DB6A8B3.7050706@runestig.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4XBiSqiiHCIj6zoM"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Peter 'Luna' Runestig" <peter@runestig.com>
Content-Disposition: inline
In-Reply-To: <3DB6A8B3.7050706@runestig.com>; from peter@runestig.com on Wed, Oct 23, 2002 at 03:48:35PM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--4XBiSqiiHCIj6zoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 23, 2002 at 03:48:35PM +0200, Peter 'Luna' Runestig wrote:
> Hi all!
>=20
> I'm thinking of trying to put together a helper module, and I'm looking=
=20
> at existing code (plus reading howto's and searching the mbox archive)=20
> to try to grasp the way it all works.
>=20
> I actually have two questions:
>=20
> 1) I'm looking at ip_{conntrack,nat}_irc.c (2.4.19). The help() function=
=20

please don't look at 2.4.19 kernels, they predate the newnat changes.

Either look at 2.4.20-preX (where X > 2), or apply (at least) the newnat
patch from patch-o-matic.

The API has changed in both the issues you are questioning.

> TIA,
> - Peter
=20

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--4XBiSqiiHCIj6zoM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9v5vVXaXGVTD0i/8RArMPAJ9aHzEI328COBmTD3M7WGlkSpd+KQCfYeOx
Fk6faecvH9st2ZBDQaMAfog=
=jndp
-----END PGP SIGNATURE-----

--4XBiSqiiHCIj6zoM--
