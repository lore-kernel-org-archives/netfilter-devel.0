From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [Fwd: NAT counting]
Date: Sun, 9 Feb 2003 11:00:17 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030209100017.GV13269@naboo.fugue.com>
References: <1044545755.21354.9.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="96icqjDFsSi85SgI"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	sclark46@earthlink.net, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1044545755.21354.9.camel@tux.rsn.bth.se>
List-Id: netfilter-devel.vger.kernel.org


--96icqjDFsSi85SgI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 06, 2003 at 09:46:44PM -0500, Stephen Clark wrote:
>=20
> Is Linux being fixed to prevent this?

Linux is not 'being fixed', because I don't regard this as a bug - and
only bugs need fixing.

I don't want to have the NAT code to _always_ rewrite the IP ID because
of performance reasons.  I think we should leave the current behaviour
and provide an _optional_ 'IPID' target for the mangle table.  So
everybody who wants IP ID rewriting can use that target.

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--96icqjDFsSi85SgI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+RiaxXaXGVTD0i/8RAvugAKCkRlWQwm3uBVtc1KHU3aoeapPo7gCdFsxl
fzOKzVMP50wonseyYUNUyFg=
=TTJN
-----END PGP SIGNATURE-----

--96icqjDFsSi85SgI--
