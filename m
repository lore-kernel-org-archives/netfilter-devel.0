From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH pom-ng] port ip_conntrack_h323 to the linux 2.6.11-rc3
	API
Date: Tue, 15 Feb 2005 00:13:23 +0100
Message-ID: <20050214231323.GF3829@sunbeam.de.gnumonks.org>
References: <20050211223858.GA27306@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MZf7D3rAEoQgPanC"
Cc: netfilter-devel@lists.netfilter.org, kadlec@blackhole.kfki.hu
To: Max Kellermann <max@duempel.org>
Content-Disposition: inline
In-Reply-To: <20050211223858.GA27306@roonstrasse.net>
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


--MZf7D3rAEoQgPanC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 11, 2005 at 11:38:58PM +0100, Max Kellermann wrote:
> Hi,
>=20
> this patch ports the H.323 conntrack module to the new linux
> 2.6.11-rc3 API. I havn't tested that thoroughly; my nfsim tests
> succeed (these will be published later), and it compiles with the real
> kernel.

Thanks, I've merged the patch into the
http://svn.netfilter.org/cgi-bin/viewcvs.cgi/branches/patch-o-matic-ng/linu=
x-2.6.11
branch.  Please submit any updates to that branch rather than pom-ng
trunk.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--MZf7D3rAEoQgPanC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCETCTXaXGVTD0i/8RApA9AJ4gtnoBWkOXwyv2QPdTsamQq8iHGwCfekwf
nwglWnkWKrTE0vnvvWiC03I=
=ZSvw
-----END PGP SIGNATURE-----

--MZf7D3rAEoQgPanC--
