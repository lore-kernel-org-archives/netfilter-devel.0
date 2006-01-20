From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 0/3] cleanups for matches
Date: Fri, 20 Jan 2006 09:11:51 +0100
Message-ID: <20060120081151.GV4603@sunbeam.de.gnumonks.org>
References: <200601160936.k0G9aXWH026971@toshiba.co.jp>
	<200601200225.k0K2PAn2005682@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zOr5JpMIiGv/Oaxu"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200601200225.k0K2PAn2005682@toshiba.co.jp>
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


--zOr5JpMIiGv/Oaxu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 20, 2006 at 11:25:09AM +0900, Yasuyuki KOZAKAI wrote:
>=20
> From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
> Date: Mon, 16 Jan 2006 18:36:33 +0900 (JST)
>=20
> > These patches are just for cleanup. I didn't cleanup ip6t_esp.c because
> > I have a patch for xt_esp.c. It looks unnecessary to skip IPv6 extension
> > headers before ESP in match() if ip6_packet_match() does it.
> > After some tests, I'll send it.
>=20
> Hmm.. we cannot do that without breaking compatibility of ip6t_esp.
> Because this forces us to add '-p esp' to ip6tables command. The current
> ip6t_esp doesn't require it.

We shouldn't require ourselves to be compatible to bugs.  There is no
point in matching ESP SPI when the protocol !=3D esp.  So any ruleset that
would no longer work with the new xt_esp was most likely invalid anyway.

> JFYI, I attached a patch for xt_esp I wrote at first time. It's sad to dr=
op it,
> but let's keep the current code...

I would want to push this forward (for post-2.6.16).  Patrick has some
infrastructural changes for the checkfn, which we want to push into
net-2.6.17 once it opens.  I would like to ask you to re-submit your
xt_esp after that time.

btw: Your patch doesn't seem to modify the existing ip[6]t_esp.h header
files.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--zOr5JpMIiGv/Oaxu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD0JtHXaXGVTD0i/8RAkvgAKCJ6lcnN584+Zn6UlX5vgJ4XvH3XQCfU7Gu
F8otUJnKpWrzrhNJqYR3Xgw=
=SNrp
-----END PGP SIGNATURE-----

--zOr5JpMIiGv/Oaxu--
