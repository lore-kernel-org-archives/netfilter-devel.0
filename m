From: Harald Welte <laforge@netfilter.org>
Subject: Re: [1/1] libipt_osf: fix iptables-1.3.0rc1 compilation.
Date: Mon, 7 Feb 2005 19:20:39 +0100
Message-ID: <20050207182039.GI10011@obroa-skai.de.gnumonks.org>
References: <1107797393.5789.17.camel@uganda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FLPM4o+7JoHGki3m"
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Content-Disposition: inline
In-Reply-To: <1107797393.5789.17.camel@uganda>
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


--FLPM4o+7JoHGki3m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 07, 2005 at 08:29:53PM +0300, Evgeniy Polyakov wrote:
> Bug reported by Sami Farin <safari-kernel@safari.iki.fi>.
>=20
> Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

Erm, this is not a libipt_osf.c fix, but a ipt_osf.h fix.  And ipt_osf.h
is not part of the iptables-1.3.0rc1 package at all.

Please clarify, thanks.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--FLPM4o+7JoHGki3m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFCB7F2XaXGVTD0i/8RAgi5AKCnVG/yDMZR00Ff8bwARndnC1Ww4QCbBQKj
BYgknV3GKL2f/PMcrzg51FE=
=2ueU
-----END PGP SIGNATURE-----

--FLPM4o+7JoHGki3m--
