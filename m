From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] MASQUERADE handling of device events
Date: Mon, 8 Nov 2004 14:50:25 +0100
Message-ID: <20041108135025.GF12437@sunbeam.de.gnumonks.org>
References: <20041107181825.GA3522@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/mvwczta11gu4fnM"
Cc: linux-net@vger.kernel.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
Content-Disposition: inline
In-Reply-To: <20041107181825.GA3522@linuxace.com>
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


--/mvwczta11gu4fnM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[added explicit Cc to Dave]

On Sun, Nov 07, 2004 at 10:18:25AM -0800, Phil Oester wrote:
> The below patch addresses these issues by changing from using ifindex
> comparisons to verifying that the masquerading ip still exists on the
> box.
>=20
> To achieve this, two changes were required to core networking code (thus
> the linux-net cc):

Thanks, Phil. =20

I think this solution is about the best we can get.

Any other comments?

Dave: would the two changes below be acceptable for you?

> 1) export inet_confirm_addr
>=20
> 2) change inet_ifa_match to use ifa_local instead of ifa_address.
>    Since ifa_local !=3D ifa_address on ppp interfaces, inet_ifa_match
>    could not be used to verify ppp interface addresses without
>    this change.
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--/mvwczta11gu4fnM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBj3mhXaXGVTD0i/8RAp90AJ9hgrWWVAyC799z1p9VemsGkrmqtgCeOzYh
hv9YYc9Es4IMZy4JsFjsAgM=
=IZRS
-----END PGP SIGNATURE-----

--/mvwczta11gu4fnM--
