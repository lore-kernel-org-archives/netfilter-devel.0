From: Harald Welte <laforge@gnumonks.org>
Subject: Re: iptables bad byte counter?!?
Date: Thu, 6 Jun 2002 07:42:43 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020606074243.G28940@sunbeam.de.gnumonks.org>
References: <1023304055.2845.69.camel@cygnus> <200206052129.54254.hno@marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5UGlQXeG3ziZS81+"
Cc: Torge Szczepanek <netfilter-devel@szczepanek.de>,
	netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <200206052129.54254.hno@marasystems.com>; from hno@marasystems.com on Wed, Jun 05, 2002 at 09:29:54PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--5UGlQXeG3ziZS81+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 05, 2002 at 09:29:54PM +0200, Henrik Nordstrom wrote:
> Torge Szczepanek wrote:
>=20
> > I am getting byte counters like this:
> >
> > 18446744073707058701
>=20
> Very much looks like a negative number.. the above is the same as 64 bit=
=20
> integer -2492915 printed as a unsigned value.
>=20
> > The byte counters differ (18446744073707 is mostly the same) so I think
> > this might be an overflow of a (longint?!?) counter.
>=20
> Very unlikely as it is 64 bits in size and unsigned..

no, this is clearly a problem within the 32bit-userspace / 64bit kernelspace
handling of iptables.

Don't assume any reasonable value to be in the counters on sparc64.

> Regards
> Henrik

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+=
=20
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)

--5UGlQXeG3ziZS81+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE8/vZSXaXGVTD0i/8RAkvcAJ9EnIvG6XgHM1WDyJNAvQaOZIfelgCeJJzl
3sl2E03iwzVgE5d14kAH9bc=
=7pDJ
-----END PGP SIGNATURE-----

--5UGlQXeG3ziZS81+--
