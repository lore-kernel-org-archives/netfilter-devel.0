From: Harald Welte <laforge@netfilter.org>
Subject: [ADMIN] patch-o-matic cleanup
Date: Mon, 19 Sep 2005 17:15:33 +0200
Message-ID: <20050919151533.GF12075@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z0eOaCaDLjvTGF2l"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
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


--z0eOaCaDLjvTGF2l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

Following up to the bad experience over the last couple of months,
Patrick and me decided that we'd get rid of a lot of code in
patch-o-matic.

None of the developers seems to have any time left to put into backwards
compatibility, and the idea of explicit "patch o matic maintainers" that
we tried some two years ago also didn't work out.

Therefore, the current best practise seems to be:

1) get rid of any code in patch-o-matic that has already included in
   mainline (I've already remove tons of directories today)
2) stop supporting anything than the most current version of a patchlet.

Sorry, but it really wasn't of any use to provide outdated unmaintained
and unfixed old versions of the code.

Whether pom-ng will continue to exist in it's current form, or whether
we'll just move all the individual patches into local branches of one
big git tree (or yet something completely different) will be on the
agenda of the netfilte developer workshop 2005 in October.

Cheers,

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--z0eOaCaDLjvTGF2l
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDLtYVXaXGVTD0i/8RAqz5AJ9nZJjMaqTdKBEL5tKiXfxFycwffQCggmm+
GWvgclxEooBElbWxxM30E5k=
=qv06
-----END PGP SIGNATURE-----

--z0eOaCaDLjvTGF2l--
