From: Harald Welte <laforge@netfilter.org>
Subject: Re: init_conntrack optimization
Date: Wed, 25 Feb 2004 15:40:54 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040225144054.GB13386@sunbeam.de.gnumonks.org>
References: <403C97A5.7070109@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gi8aKAu241S2WqNd"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <403C97A5.7070109@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--gi8aKAu241S2WqNd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 25, 2004 at 01:40:05PM +0100, Pablo Neira wrote:
> Hi Harald and list!
>=20
> I patched the init_conntrack function to optimize the expectation handlin=
g.
>=20
> With this patch, if an expectation is not found for the conntrack, it=20
> will look for an helper and go out, this way we save three "if's". By=20
> other hand, if an expectation is found we save one "if".

yes, thanks for the patch.  It definitely makes the code more readable.
If it really makes a difference in performance - I don't know.

The compiler will certainly not recompute the value of 'expected', and
since it also knows that expected is not written to, it could actually
optimize here.  Whether gcc is smart enough to do so, I don't know.. one
would have to look at the generated assembly code.

> I consider that the general case is that an expectation is not found,=20
> isn't it? because most connection tracked by the system don't need a=20
> helper, so they not need to handle expectations.

yes.  Maybe it's even worth using 'if (unlikely(expected))' in that
case.

> BTW, can we consider that if there's no helper for a given tuple, it=20
> won't have expectations? because while writing the patch i had more=20
> ideas, maybe this could be optimized a bit more. Well, I'm not sure...

No, this is an invalid assumption. =20

> hope that i'm not missing anything! if so, please let me know.

looks fine to me.  would you mind submitting a patch syncing 2.4.x to
your changes?  Thanks.

> cheers,
> Pablo
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--gi8aKAu241S2WqNd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAPLP2XaXGVTD0i/8RAg6TAJ0exr+l7vwfAB8sllYYD81CmnxaiACgiTeA
Zi7/54ZzeEu+GlkJeFR7nWM=
=41zy
-----END PGP SIGNATURE-----

--gi8aKAu241S2WqNd--
