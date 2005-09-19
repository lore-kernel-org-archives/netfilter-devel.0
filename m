From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Refuse multiple --to args in [DS]NAT
Date: Mon, 19 Sep 2005 16:55:40 +0200
Message-ID: <20050919145539.GB12075@rama.de.gnumonks.org>
References: <20050904194042.GA11196@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pvezYHf7grwyp3Bc"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
Content-Disposition: inline
In-Reply-To: <20050904194042.GA11196@linuxace.com>
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


--pvezYHf7grwyp3Bc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 04, 2005 at 12:40:42PM -0700, Phil Oester wrote:
> Kernels higher than 2.6.10 don't support multiple --to arguments in
> DNAT and SNAT targets.  At present, the error is somewhat vague:
>=20
> # iptables -t nat -A foo -j SNAT --to 1.2.3.4 --to 2.3.4.5
> iptables: Invalid argument
>=20
> But if we want current iptables to work with kernels <=3D 2.6.10, we
> cannot simply disallow this in all cases.
>=20
> So the below patch adds kernel version checking to iptables, and
> utilizes it in [DS]NAT.  Now, users will see a more informative error:
>=20
> # iptables -t nat -A foo -j SNAT --to 1.2.3.4 --to 2.3.4.5
> iptables v1.3.3: Multiple --to-source not supported
>=20
> This generic infrastructure (shamelessly lifted from procps btw) may
> come in handy in the future for other changes.
>=20
> This fixes bugzilla #367.

thanks, applied.  sorry for the delay.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--pvezYHf7grwyp3Bc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDLtFrXaXGVTD0i/8RAkAUAJ9xwFmUihjfCDtF0yq9MUJNrVTj5wCgm8bo
xEIpyQc8WPP/n74OW+gbD4Y=
=TVB8
-----END PGP SIGNATURE-----

--pvezYHf7grwyp3Bc--
