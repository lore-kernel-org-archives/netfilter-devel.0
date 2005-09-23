From: Harald Welte <laforge@netfilter.org>
Subject: Re: Unresolved net symbols in recent -mm releases
Date: Fri, 23 Sep 2005 15:58:33 +0200
Message-ID: <20050923135833.GB731@sunbeam.de.gnumonks.org>
References: <432A9D1D.4020502@reub.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fKtH0JUtvN5p2ETH"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Reuben Farrelly <reuben-lkml@reub.net>
Content-Disposition: inline
In-Reply-To: <432A9D1D.4020502@reub.net>
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


--fKtH0JUtvN5p2ETH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 16, 2005 at 10:23:25PM +1200, Reuben Farrelly wrote:
> Hi Harald,
>=20
> This problem outlined below with the ip6tables NFQUEUE target module is s=
till present in=20
> 2.6.14-rc1-mm1, but I didn't get a response after posting to LKML and
> Netdev.  As you're listed as the module author, I figure you're
> probably a good person to ask too..  It's a non critical error for me
> because I don't need it anyway ;-)

sorry, your email got lost.  Does the problem still persist with
2.6.14-rcX ?  If yes, please send your .config ( the url gives a 404).

netfilter-devel@lists.netfilter.org is the right mailinglist.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--fKtH0JUtvN5p2ETH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDNAoJXaXGVTD0i/8RAubHAKCQt/msGHDX7DIP0JkfhObGbJwMUACgtAub
fz52TGa9eksD0WvnD2Z4Rz0=
=dAX+
-----END PGP SIGNATURE-----

--fKtH0JUtvN5p2ETH--
