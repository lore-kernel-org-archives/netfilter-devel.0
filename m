From: Harald Welte <laforge@netfilter.org>
Subject: Re: how to add packet or byte couters to connection tracking module
Date: Wed, 26 Feb 2003 18:36:05 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030226173605.GL8883@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0302200959310.13403-100000@ski.isi.edu> <20030220183340.GA17248@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="73fGQZLCrFzENemP"
Cc: Xuan Chen <xuanc@isi.edu>, netfilter@lists.netfilter.org,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20030220183340.GA17248@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--73fGQZLCrFzENemP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 20, 2003 at 07:33:40PM +0100, Patrick Schaaf wrote:
> > I want to add a packet or byte counter to the connection tracking modul=
e=20
> > in netfilter. That is, I want to track how many packets and bytes havin=
g=20
> > been sent through one connection. Where should I start?
>=20
> 1) Get the kernel source code.
>=20
> [...]=20

*lol*

> 5) Provide ways for userlevel to access those counters. I would be
>    interested to hear about the access methods you imagine.

ctnetlink should do the trick.

> best regards
>   Patrick

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--73fGQZLCrFzENemP
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+XPsFXaXGVTD0i/8RAuWiAKCFTy199RYeG6xumhsSPtb+JG2zDwCfblgT
3ivZm6SAUwkLPycRpqIS1qQ=
=KvRc
-----END PGP SIGNATURE-----

--73fGQZLCrFzENemP--
