From: Harald Welte <laforge@netfilter.org>
Subject: Re: Missing ipt_osf.h in p-o-m (kernel 2.6)
Date: Tue, 24 Aug 2004 12:49:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040824104945.GR26877@sunbeam.de.gnumonks.org>
References: <20040818223233.GA317@cerbere.dyndns.info> <20040819094720.GZ3921@sunbeam.de.gnumonks.org> <4127E920.2080100@trash.net> <Pine.LNX.4.58.0408241134530.13212@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NyVXgNZ34wipDCDo"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0408241134530.13212@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--NyVXgNZ34wipDCDo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 24, 2004 at 11:41:30AM +0200, Jozsef Kadlecsik wrote:
> > Oops. I just commited the file to 2.6, I didn't knew this works.
> > How come it didn't compile ?
>=20
> In the original design of pom-ng the files in the different version-trees
> were not duplicated. Unfortunately due to the complexity of the versioning
> than could not be preserved=20

Mh, do you still remember the precise reason for this? I would like to
have this resolved in a cleaner way than copying everything over and
over...

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

--NyVXgNZ34wipDCDo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBKx1JXaXGVTD0i/8RAgZmAKCWTFYWgJsaVu/i5ix3A8h0uItP7gCfYaiy
/2N4xY9mfDPHAnuvLCYMI0E=
=11QT
-----END PGP SIGNATURE-----

--NyVXgNZ34wipDCDo--
