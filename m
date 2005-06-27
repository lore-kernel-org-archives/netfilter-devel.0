From: Harald Welte <laforge@netfilter.org>
Subject: Re: Status of Netfilter IPSEC patches
Date: Mon, 27 Jun 2005 10:14:31 +0200
Message-ID: <20050627081431.GY19928@sunbeam.de.gnumonks.org>
References: <42289633.6020804@sysgo.com> <424853B8.9090607@shorewall.net>
	<42485FD2.3020508@trash.net> <42BACCD1.8030403@anduras.de>
	<42BACFEE.3020801@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CSNFvL6ilyiKL/Hs"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42BACFEE.3020801@trash.net>
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


--CSNFvL6ilyiKL/Hs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 23, 2005 at 05:06:22PM +0200, Patrick McHardy wrote:

> > There are newer ones under:
> > ~  http://www.saout.de/misc/linux-2.6.12-ipsec-nat/
> > Please update the patches in the patch-o-matic!
>=20
> If someone sends me a patch for svn I'll apply it.

I took the liberty of downloading the patches from Christophe Saout's
website and commit them to svn as 'linux-2.6.12.patch', this way it
works for new and old kernels. =20

If someone (Christophe?) has patches for 2.6.10/.11, feel free to submit
them so we can include them, too.

Thanks!

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--CSNFvL6ilyiKL/Hs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCv7VnXaXGVTD0i/8RAkHwAJ9ZMU9S3gfEruS9rL8EViJFCxsdxQCgh1su
JvbtdUxooSEzBYDOk42j9N0=
=pHPo
-----END PGP SIGNATURE-----

--CSNFvL6ilyiKL/Hs--
