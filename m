From: Harald Welte <laforge@netfilter.org>
Subject: Re: Missing ipt_osf.h in p-o-m (kernel 2.6)
Date: Tue, 24 Aug 2004 16:34:35 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040824143435.GY26877@sunbeam.de.gnumonks.org>
References: <20040818223233.GA317@cerbere.dyndns.info> <20040819094720.GZ3921@sunbeam.de.gnumonks.org> <4127E920.2080100@trash.net> <Pine.LNX.4.58.0408241134530.13212@blackhole.kfki.hu> <20040824104945.GR26877@sunbeam.de.gnumonks.org> <Pine.LNX.4.58.0408241400200.13212@blackhole.kfki.hu> <Pine.LNX.4.61.0408241442240.7021@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ECcIMtargrIi2fbc"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0408241442240.7021@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ECcIMtargrIi2fbc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 24, 2004 at 02:43:43PM +0200, Henrik Nordstrom wrote:
> On Tue, 24 Aug 2004, Jozsef Kadlecsik wrote:
>=20
> >As far as I remember the main problem was how to express when a file was
> >*not* required in specific versions or above a given version.
>=20
> I propose that in such case the file need to be forked into the respectiv=
e=20
> version trees where it should be used.

yes, this was my initial idea about this, too.

> Regards
> Henrik

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ECcIMtargrIi2fbc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBK1H7XaXGVTD0i/8RAn6BAJ47asGGthpEtIsBnwYOtnTxV1OHYQCcCdSo
LNLPwYoaBB8sKgZ6KbZVjh4=
=YwGb
-----END PGP SIGNATURE-----

--ECcIMtargrIi2fbc--
