From: Harald Welte <laforge@netfilter.org>
Subject: Re: Missing ipt_osf.h in p-o-m (kernel 2.6)
Date: Tue, 24 Aug 2004 16:38:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040824143832.GA26877@sunbeam.de.gnumonks.org>
References: <20040818223233.GA317@cerbere.dyndns.info> <20040819094720.GZ3921@sunbeam.de.gnumonks.org> <4127E920.2080100@trash.net> <Pine.LNX.4.58.0408241134530.13212@blackhole.kfki.hu> <20040824104945.GR26877@sunbeam.de.gnumonks.org> <Pine.LNX.4.61.0408241435260.7021@filer.marasystems.com> <Pine.LNX.4.58.0408241447140.13212@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jZnw8Q/DKt8Pu8HW"
Cc: Henrik Nordstrom <hno@marasystems.com>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0408241447140.13212@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--jZnw8Q/DKt8Pu8HW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 24, 2004 at 03:10:28PM +0200, Jozsef Kadlecsik wrote:
> > I propose that in such case the file need to be forked into the
> > respective version trees where it should be used.
>=20
> Using the directory scheme and logic above, how you could express that
> foo.c is required up to 2.6.8 but not above?

oh, i see.  So a more recent version doesn't require a file to be
different or to be present, but requires an old one not to be present.

Now I understand, thanks Jozsef.

> Best regards,
> Jozsef

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--jZnw8Q/DKt8Pu8HW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBK1LoXaXGVTD0i/8RAgtsAJ49xPtWCg8BKjIskb0AJObzmvDVNgCfWeqh
BWLmmJOiKgP9uM2Y7S/OxMc=
=b2eI
-----END PGP SIGNATURE-----

--jZnw8Q/DKt8Pu8HW--
