From: Harald Welte <laforge@netfilter.org>
Subject: Re: [Bug] limit match not working on Sparc64
Date: Wed, 28 May 2003 20:26:20 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030528182620.GA12978@naboo>
References: <3ED1275B.3000705@fugmann.dhs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Anders Fugmann <afu@fugmann.dhs.org>
Content-Disposition: inline
In-Reply-To: <3ED1275B.3000705@fugmann.dhs.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 25, 2003 at 10:28:11PM +0200, Anders Fugmann wrote:
> The limit match seems to be broken on sparc64 arch. It works on i386.

can you please submit this bug report to bugzilla.netfilter.org? Thanks.

> I guess that its the 64bit kernel/32bit user-space that is making the=20
> module break. If anyone has some pointers on how to fix this, I would be=
=20
> glad to try and fix it - Maybe we can get a patch into 2.4.21.

yes, I think there's been discussion about this on the netfilter-devel
list before.

> Regards
> Anders Fugmann

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+1P9LXaXGVTD0i/8RAiYCAJ94s7ZT5YvuAgCEm3dRAAxa96jKhACgnyT2
tft2l6Rxjn9QdD85CLNcSh8=
=sF+V
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
