From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] nfsim: trivial format string typo fix
Date: Wed, 2 Nov 2005 18:37:34 +0100
Message-ID: <20051102173734.GL4479@sunbeam.de.gnumonks.org>
References: <200511021517.45463@nienna>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gblfvcnLkTb/NiHC"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>, rusty@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
Content-Disposition: inline
In-Reply-To: <200511021517.45463@nienna>
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


--gblfvcnLkTb/NiHC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 02, 2005 at 03:17:44PM +0100, KOVACS Krisztian wrote:
>=20
>   Hi,
>=20
>   While playing with nfsim and nf_conntrack this weekend, I've found a=20
> trivial typo in core/core.c. Please apply the attached patch. (Yes,=20
> it's trivial but obviously it causes a segfault.)

applied, thanks

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--gblfvcnLkTb/NiHC
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDaPleXaXGVTD0i/8RAmA/AJ4+FXKLKcrZQ4ZmQdjThceAww7IMwCdH+6u
p0lVALGyTCJU39ORCBU3e1g=
=bN8l
-----END PGP SIGNATURE-----

--gblfvcnLkTb/NiHC--
