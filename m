From: Harald Welte <laforge@netfilter.org>
Subject: Re: [Q] CVS snap 20030418 ...
Date: Sun, 27 Apr 2003 15:10:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427131043.GK990@sunbeam.de.gnumonks.org>
References: <20030422065302.31170.13388.Mailman@kashyyyk> <Pine.LNX.4.44L.0304231409130.29708-100000@alpha.zarz.agh.edu.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kJCZHFqBEEYq/eA6"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Wojciech Sas Cieciwa <cieciwa@alpha.zarz.agh.edu.pl>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L.0304231409130.29708-100000@alpha.zarz.agh.edu.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--kJCZHFqBEEYq/eA6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2003 at 02:18:14PM +0200, Wojciech Sas Cieciwa wrote:
>=20
> Hi,
>=20
> My friend find strange situation.
> He can't reload netfilter modules.
> lsmod says that modules isn't loaded, but insmod says that module is load=
ed.
> And netfilter isn't usable.

sounds like you've compiled something statically into your kernel and
then try to load it as a module at a later point in time.

> Is this bug in netfilter or in our kernel ?

there is no such bug in netfilter/iptables.

> Thanx.
> 					Sas.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--kJCZHFqBEEYq/eA6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+q9bTXaXGVTD0i/8RAs1SAJ9yiE2fEFCMqpSpuDf9lfGdO5GB5ACfecp2
jVu8WvqbYVsNx/80bGDiksk=
=xd63
-----END PGP SIGNATURE-----

--kJCZHFqBEEYq/eA6--
