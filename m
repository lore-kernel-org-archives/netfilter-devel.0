From: Harald Welte <laforge@netfilter.org>
Subject: Re: Linux 2.6.9-rc1
Date: Thu, 26 Aug 2004 01:48:39 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040825234839.GT5824@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.58.0408240031560.17766@ppc970.osdl.org>
	<412CDFEE.1010505@triplehelix.org>
	<20040825203206.GS5824@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.61.0408252334230.28603@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hlh2aiwFLCZwGcpw"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0408252334230.28603@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--Hlh2aiwFLCZwGcpw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 25, 2004 at 11:35:05PM +0200, Henrik Nordstrom wrote:
> On Wed, 25 Aug 2004, Harald Welte wrote:
>=20
> >The 'problem' is that we try to get a readlock while we're already
> >protected under a write lock.
> >
> >Please see the following [quite trivial, but yet untested] patch:
> >
> >EXPORT_SYMBOL(ip_nat_used_tuple);
> >+EXPORT_SYMBOL(ip_nat_find_helper);
>=20
> Why this new exported symbol?

Because other code that is not yet in the kernel needs it (like
ct_sync).  That's one of the reasons to get the API's straightened out
:)

> Regards
> Henrik

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Hlh2aiwFLCZwGcpw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBLSVXXaXGVTD0i/8RAgGAAJ9XCMFisXx4c0gkIuPGghcRt1dk3QCfQpZx
G3+ul7abzCbmKiRMthsu7Qg=
=5MII
-----END PGP SIGNATURE-----

--Hlh2aiwFLCZwGcpw--
