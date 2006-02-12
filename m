From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] netfilter: fix build error due to missing has_bridge_parent macro
Date: Sun, 12 Feb 2006 12:22:34 +0100
Message-ID: <20060212112234.GC5336@sunbeam.de.gnumonks.org>
References: <200602120320.37042.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Cc: LKML <linux-kernel@vger.kernel.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Marc Boucher <marc@mbsi.ca>, James Morris <jmorris@namei.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	coreteam@netfilter.org, netfilter@lists.netfilter.org,
	netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750906AbWBLLWv@vger.kernel.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
Content-Disposition: inline
In-Reply-To: <200602120320.37042.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 12, 2006 at 03:20:36AM +0100, Jesper Juhl wrote:
> Hi,
>=20
> I just did an allyesconfig test build of 2.6.16-rc2-git10 and found a bui=
ld
> problem.

thanks, I'll push this via davem and to stable ASAP.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD7xp6XaXGVTD0i/8RAnGDAJ4rmmx9/1mKnvq8R2Qte7jA0vi3zwCggbfi
wadcN0BjfD3zF2loDA0nXDw=
=6Ix+
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
