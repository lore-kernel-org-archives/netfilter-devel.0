From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] nfsim: Increase maximum argv size for tcpsession DATA
Date: Fri, 6 Jan 2006 15:41:47 +0100
Message-ID: <20060106144147.GF4898@sunbeam.de.gnumonks.org>
References: <439EF2D0.4000606@ingate.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5gziLYhE2IPTggEg"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marcus Sundberg <marcus@ingate.com>
Content-Disposition: inline
In-Reply-To: <439EF2D0.4000606@ingate.com>
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


--5gziLYhE2IPTggEg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 13, 2005 at 05:12:00PM +0100, Marcus Sundberg wrote:
> Hi,
>=20
> this patch increases the argv buffer in the tcp_send() function.
> I ran in to this limit when constructing RTSP packets, and I see no
> reason not to make it "large enough for everyone" while at it.

thanks, applied.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--5gziLYhE2IPTggEg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDvoGrXaXGVTD0i/8RAs9lAJ4pb+ajrQPVaNqrFhWlD5fQ0Vj79ACghTc1
EG1+cWsxHV5BIRjlAsW/CC8=
=U03f
-----END PGP SIGNATURE-----

--5gziLYhE2IPTggEg--
