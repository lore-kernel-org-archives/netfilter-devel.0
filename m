From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] fix bug in convert2pomng.sh
Date: Wed, 18 Feb 2004 18:23:24 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040218172324.GW9464@sunbeam.de.gnumonks.org>
References: <20040218101816.GA13588@zion.homelinux.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iJhwK4DKf9Unwzgv"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Sven Schuster <schuster.sven@gmx.de>
Content-Disposition: inline
In-Reply-To: <20040218101816.GA13588@zion.homelinux.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--iJhwK4DKf9Unwzgv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 18, 2004 at 11:18:16AM +0100, Sven Schuster wrote:
>=20
> Hi Harald, hi Netfilter-devel-list,
>=20
> attached you find a patch against convert2pomng.sh.
> The original version didn't create additional .ladd files if there where
> more than one entries to add. For example with the nfnetlink-ctnetlink
> patch there were the files


> But because of an error in the script each part was created as=20
>=20
> ip_conntrack.h.ladd
>=20
> and so just the last part (...-8) went into pom-ng.

:( I'm sorry.

> I hope the fix is fine (and a diff for patch -p0 too :-)!

Seems fine.  'patch -p1' is usual, but that's not too imporant.

> If it is, wouldn't most patches from pom need to be converted to
> pom-ng again??

Unfortunately yes.  Would you (or anybody else) be willing to do this in
a local tree, make a diff, review it and finally submit it to me?  I'd
rather not spend more time with this stuff at the moment, pom-ng has
already taken too much time in the past.

> BTW, I'm currently about to port the nfnetlink-ctnetlink patch to 2.6
> (which actually brought my attention to this bug), is anyone else=20
> working on this??

No.  I'm now working on finalizing the specification for the pkttnetlink
message format (which has implications on nfnetlink).  Once this is
done, we can consider the nfnetlink message format stable and submit for
kernel inclusion (2.6.x).  Your port would be very welcome.

> Regards
> Sven
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--iJhwK4DKf9Unwzgv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAM5+MXaXGVTD0i/8RAqZNAJ4gUfAE2uPAkhTTKHu2pZe3d8Nq7gCfecXR
EIarzd7EVBQJGFTQXsxKaN8=
=DDeL
-----END PGP SIGNATURE-----

--iJhwK4DKf9Unwzgv--
