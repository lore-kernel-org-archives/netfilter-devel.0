From: Harald Welte <laforge@netfilter.org>
Subject: Re: build error in your git tree
Date: Sun, 16 Oct 2005 11:18:43 +0200
Message-ID: <20051016091843.GD4550@rama.0sec.lan>
References: <200510152054.j9FKsmpe010005@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+nBD6E3TurpgldQp"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200510152054.j9FKsmpe010005@toshiba.co.jp>
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


--+nBD6E3TurpgldQp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 16, 2005 at 05:54:48AM +0900, Yasuyuki KOZAKAI wrote:
>=20
> Hi, Harald,
>=20
> I found that ip_conntrack in your git tree cannot be build because there =
are
> two nfattr_to_tcp() in it. Their difference is only return value on error.
> Sorry I didn't make patch because I don't know exactly what was occurred
> in your tree. It seems that, this change, merging with upstream, and not
> reverted change for return value, are related.

thanks for letting me know, I'll fix it.  It's a mistake of git's
auto-merge features.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--+nBD6E3TurpgldQp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDUhrzXaXGVTD0i/8RAsOLAKCv1bIFcmVwYiIu0XDKQb1AGz4tNgCcDAkL
XXUvKLnmd/WhHQjS6kB4INo=
=eswd
-----END PGP SIGNATURE-----

--+nBD6E3TurpgldQp--
