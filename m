From: Harald Welte <laforge@netfilter.org>
Subject: Re: runme
Date: Tue, 6 Jan 2004 20:11:22 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040106191122.GG934@obroa-skai.de.gnumonks.org>
References: <Pine.LNX.4.58L.0401061514080.17738@gandalf.uznam.net.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pfTAc8Cvt8L6I27a"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Michal Margula <alchemyx@uznam.net.pl>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58L.0401061514080.17738@gandalf.uznam.net.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--pfTAc8Cvt8L6I27a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2004 at 03:17:22PM +0100, Michal Margula wrote:
> Hello!
>=20
> 	Yesterday I was fighting with patch-o-matic. It was complaining=20
> about "bad substitution" at some line. After few minutes of googling, i=
=20
> found out that runme is bash-based shell. So it requires bash to run. OK,=
=20
> fine. But in header it has #!/bin/sh and it shouldn't. Some distribution=
=20
> (PLD for example) use other shells like pdksh for /bin/sh.=20
>=20
> Solution is simple - changing #!/bin/sh into #!/bin/bash and everything=
=20
> should be fine. I don't know if I should to report it at=20
> bugs.netfilter.org or maybe someone can commit a change to CVS?

thanks, I'll fix it in CVS.  but normally bugzilla would be the right
way to do this.  thanks.

> Thanks.
=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--pfTAc8Cvt8L6I27a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/+whaXaXGVTD0i/8RAo2wAKCUiX72KFa5PnjDeVmW6UyHRaQB1wCeMA+5
5ScPXvKcF7zpTqyw/L2oBH0=
=/2sP
-----END PGP SIGNATURE-----

--pfTAc8Cvt8L6I27a--
