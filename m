From: Harald Welte <laforge@netfilter.org>
Subject: Re: [2.6 patch] netfilter/ip_nat_snmp_basic.c: fix inlines (fwd)
Date: Sun, 1 Aug 2004 19:31:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040801173152.GG14539@sunbeam2>
References: <20040729212048.GD23589@fs.tum.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xs+9IvWevLaxKUtW"
Cc: James Morris <jmorris@intercode.com.au>, Andrew Morton <akpm@osdl.org>,
	linux-kernel@vger.kernel.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Adrian Bunk <bunk@fs.tum.de>
Content-Disposition: inline
In-Reply-To: <20040729212048.GD23589@fs.tum.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--xs+9IvWevLaxKUtW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 29, 2004 at 11:20:49PM +0200, Adrian Bunk wrote:
>=20
> FYI:
> The patch forwarded below is still required in 2.6.8-rc2-mm1.

I've pushed your patch to DaveM now.  Apparently some gcc-3.4 specific
issue...

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--xs+9IvWevLaxKUtW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBDSkIXaXGVTD0i/8RAsD8AJ4txHIHfG1T6pLzJ2iCaqwxvZ3avQCeNN5y
L3IoXydcPIb8H0N9IxwcIO8=
=plPE
-----END PGP SIGNATURE-----

--xs+9IvWevLaxKUtW--
