From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 4/*] libnfnetlink fixes
Date: Sun, 28 Aug 2005 13:50:13 +0200
Message-ID: <20050828115013.GE4244@rama.de.gnumonks.org>
References: <42D429F9.7000707@eurodev.net> <42D4CF9C.2000304@ufomechanic.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="brEuL7wsLY8+TuWz"
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
Content-Disposition: inline
In-Reply-To: <42D4CF9C.2000304@ufomechanic.net>
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


--brEuL7wsLY8+TuWz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 13, 2005 at 09:23:56AM +0100, Amin Azez wrote:

> It allows the application-supplied callback handler to signifiy in its
> return code whether or not the nfnl_listen read-loop should terminate.
>=20
> If the handler returns a negative code, then nfnl_listen returns
> immediately with the same return code.
>=20
> If the handler returns a postitive code, then nfnl_listen returns at the
> next iteration of the while loop, which is when it finishes handing all
> netlink messages in the current packet.
>=20
> This avois the need to duplicate most of nfnl_listen in a non-loop
> context where the application needs control over the read and packet
> decode process.

I think this change is fine.  Would you mind to re-submit the patch
against current svn?  Please also document the meaning of the return
values, probably with a comment in the code or the header file?

Thanks!

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--brEuL7wsLY8+TuWz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDEaT1XaXGVTD0i/8RAijbAKCTPtYUjEvVQO1uyib6A0u2Pm6faQCgjgHB
lHgCDGy0YD94bciSebqE/3A=
=kODc
-----END PGP SIGNATURE-----

--brEuL7wsLY8+TuWz--
