From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] ipt_hashlimit.c: expire's type overflow when showing
	tuples at bad moment.
Date: Tue, 1 Feb 2005 14:29:16 +0100
Message-ID: <20050201132915.GJ6878@sunbeam.de.gnumonks.org>
References: <41F2FE92.6020603@cookinglinux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xSXKkePCxtN78XFb"
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
To: Samuel Jean <sj-netfilter@cookinglinux.org>
Content-Disposition: inline
In-Reply-To: <41F2FE92.6020603@cookinglinux.org>
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


--xSXKkePCxtN78XFb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 22, 2005 at 08:32:02PM -0500, Samuel Jean wrote:
> Name: Expire's type overflow when showing tuples at bad moment.
> Status: Tested under Linux 2.6.6 uml patched.
> Signed-off-by: Samuel Jean <sjean@cookinglinux.org>
>=20
> When garbage collector runs slow enough, we have a chance to print
> expired tuples before they get freed. We see weird expiry time.

Thanks.  Patrick, please put this patch in your pending queue.

Signed-off-by: Harald Welte <laforge@netfilter.org>

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--xSXKkePCxtN78XFb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB/4QrXaXGVTD0i/8RApxbAJ0dVLvKNO+V++rOlhHH9Aajhhti5QCgrZm+
XYX8YKQJf2sQX5KJEbWl9e4=
=ThKM
-----END PGP SIGNATURE-----

--xSXKkePCxtN78XFb--
