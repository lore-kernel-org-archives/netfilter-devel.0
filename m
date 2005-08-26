From: Harald Welte <laforge@netfilter.org>
Subject: Re: Patch for TTL target
Date: Fri, 26 Aug 2005 12:59:21 +0200
Message-ID: <20050826105921.GP4226@rama.de.gnumonks.org>
References: <200508151552.59571.mgarski@post.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bJ3jXuwtxrXxD2iT"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marcin Garski <mgarski@post.pl>
Content-Disposition: inline
In-Reply-To: <200508151552.59571.mgarski@post.pl>
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


--bJ3jXuwtxrXxD2iT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 15, 2005 at 03:52:59PM +0200, Marcin Garski wrote:
> [Please CC me on replies, I am not subscribed to the list, thanks]
>=20
> Hello,
>=20
> Here is the patch that fix some C formatting issues (so source are more=
=20
> readable).

I'm only applying this cosmetic whitespace-change patch because the code
is only in svn and not in the mainline kernel.  I've also done some
further cleanups, result is revision 4244.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--bJ3jXuwtxrXxD2iT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDDvYIXaXGVTD0i/8RAqfoAJ9mecGTKDZ5PVTVXXO0hZerCvoDzQCfUW+e
8Ee0LWsPv2NC1IYnMYVsY+M=
=Wkh+
-----END PGP SIGNATURE-----

--bJ3jXuwtxrXxD2iT--
