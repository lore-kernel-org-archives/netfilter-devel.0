From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RESEND][PATCH] string match compilation on 2.4.9
Date: Wed, 18 Jun 2003 18:42:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030618164201.GG1661@naboo>
References: <Pine.LNX.4.51.0306161340060.14421@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yRA+Bmk8aPhU85Qt"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.51.0306161340060.14421@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--yRA+Bmk8aPhU85Qt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 16, 2003 at 01:41:50PM +0200, Maciej Soltysiak wrote:
> Hi,
>=20
> we all know that the string match does not work on 2.4.9 because
> 2.4.9 had a different definition of the min/max macros.
>=20
> This patch did not receive any comment so far.

I thought I had stated that before, but anyway:  I don't think it's
worth dealing with this very particular case of 2.4.9.  Recent
patch-o-matic releases only support kernels >=3D 2.4.18 anyway.

> Regards,
> Maciej
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--yRA+Bmk8aPhU85Qt
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+8JZYXaXGVTD0i/8RAuTvAKCkWu3fOkQ1UkOyKbQxAgSsBbRNmACeJ6cy
nR5u/6WJn2gIFBogFr+xld8=
=Hejj
-----END PGP SIGNATURE-----

--yRA+Bmk8aPhU85Qt--
