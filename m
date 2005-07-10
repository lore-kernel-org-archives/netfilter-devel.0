From: Harald Welte <laforge@netfilter.org>
Subject: Re: SO_ORIGINAL_DST does not work in nat/OUTPUT anymore
Date: Sun, 10 Jul 2005 17:32:34 +0200
Message-ID: <20050710153234.GM20465@sunbeam.de.gnumonks.org>
References: <42D12E28.7020707@hoelldampf.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8w4vJErrroHezzIq"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jens Hoelldampf <jens@hoelldampf.net>, kaber@trash.net
Content-Disposition: inline
In-Reply-To: <42D12E28.7020707@hoelldampf.net>
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


--8w4vJErrroHezzIq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 10, 2005 at 04:18:16PM +0200, Jens Hoelldampf wrote:
> Hi,
>=20
> the upstream patch from
>=20
> https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=3D91
>=20
> destroys the functionality of SO_ORIGINAL_DST for local generated
> packets. It returns the local address the connection is redirected to
> instead of the original destination address. As a result you cannot use
> local transparent proxies anymore.

ouch.  It seems like we really need to revert that change and find a
different solution for conntrack unloading :(

Thanks for reporting this.

Patrick, are you already working on this?

> Should I open a new bug or reopen the old one?

please open a new one, since it's a different problem.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--8w4vJErrroHezzIq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC0T+SXaXGVTD0i/8RAjjlAJ9zagt9Z5FD8Vq4RM2POMUHykzd3ACfRJb4
zdZixcIcf2w9xl7ScNyOgO0=
=q7qX
-----END PGP SIGNATURE-----

--8w4vJErrroHezzIq--
