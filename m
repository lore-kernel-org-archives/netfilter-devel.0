From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 1/5] NETFILTER ctnetlink: use ENOMEM instead of -1
Date: Mon, 10 Oct 2005 10:44:50 +0200
Message-ID: <20051010084450.GD5091@rama.customers.eurospot.com>
References: <20051007221948.GL4450@rama.customers.eurospot.com>
	<4347E8F4.5010807@trash.net>
	<20051009.215222.44964474.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mJm6k4Vb/yFcL9ZU"
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20051009.215222.44964474.davem@davemloft.net>
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


--mJm6k4Vb/yFcL9ZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 09, 2005 at 09:52:22PM -0700, David S. Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Sat, 08 Oct 2005 17:42:44 +0200
>=20
> > Dave, please drop this patch.
>=20
> I'll kill it from my tree, thanks.

sorry for letting this through, I didn't really look at it in detail,
as it was Pablo who submitted it, and allegedly by a suggestion from
Patrick - and on a superficial level it seemed right :(

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--mJm6k4Vb/yFcL9ZU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDSioCXaXGVTD0i/8RAl4uAJ9lQOnJ/IBGmjcoa2ZqzN2RssiA5gCeKF3t
5T4j1TS/e2Lo8TFPeQUepfU=
=6Zq1
-----END PGP SIGNATURE-----

--mJm6k4Vb/yFcL9ZU--
