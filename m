From: Harald Welte <laforge@netfilter.org>
Subject: Re: --reject-with admin-prohib not working
Date: Wed, 30 Jul 2003 16:02:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030730140214.GA4553@sunbeam.de.gnumonks.org>
References: <20030721155732.GA3733@naboo> <1052431003.1059171322687.JavaMail.Administrator@pumbaa>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Internet Protocol version Six <inet6@mail.be>
Content-Disposition: inline
In-Reply-To: <1052431003.1059171322687.JavaMail.Administrator@pumbaa>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 26, 2003 at 12:15:22AM +0200, Internet Protocol version Six wro=
te:
> Hello all,
>=20
> like the subject says, it is not working for me, I applied the PoM
> patch to the kernel, compiled the kernel, even recompiled iptables and
> it still gives me "iptables v1.2.8: unknown reject type
> `admin-prohib'"

just use iptables from CVS.  I should do a 1.2.9 release, if only for
this issue.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/J8/mXaXGVTD0i/8RAie1AJwK90ewck4t3uJnV6YeorfdSx2ZOACfS6TQ
Sh/2Vra1AFsbmTXy1mFCokU=
=l8nZ
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
