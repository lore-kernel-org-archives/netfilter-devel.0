From: Harald Welte <laforge@netfilter.org>
Subject: Re: nfsim updates
Date: Sat, 25 Sep 2004 09:00:01 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040925070001.GO3236@sunbeam.de.gnumonks.org>
References: <20040919223457.GL1307@sunbeam.de.gnumonks.org>
	<1095732625.1940.166.camel@bach> <200409222104.36526.jk@ozlabs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5OiCWnsosOq6PSM0"
Cc: Rusty Russell <rusty@rustcorp.com.au>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jeremy Kerr <jk@ozlabs.org>
Content-Disposition: inline
In-Reply-To: <200409222104.36526.jk@ozlabs.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--5OiCWnsosOq6PSM0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 22, 2004 at 09:04:36PM -0400, Jeremy Kerr wrote:
> > > As stated before, we could also move it to
> > > svn.netfilter.org (which actually exists, but also has no public
> > > interface yet).
> >
> > Jeremy?
>=20
> This would probably be the best way to go - It also depends on how the=20
> netfilter testsuite is going to be developed - would using the subversion=
=20
> repository cause any problems, rather than rolling it into netfilter cvs?

no, I think that would be a good idea.  I'm actually thinking about
moving the re-organized [as discussed at the netfilter workshop]
patch-o-matic-ng into svn anyway... if only for the single reason that
it allows recursive directory-adding (anybody who has added stuff to pom
CVS knows what I'm talking about).

I'll send you notice when svn.netfilter.org is up and running as
expected.

I've successfully tested certificate-based client authentication with
svn.gnumonks.org, so I think that's the way to go for developer access.
It's the only strongly authenticated way where you still have the power
to have permissions on per-user granularity.

> In the meantime though, I've set up a cron task to create a nightly snaps=
hot=20
> from the ozlabs.org subversion repository (23:00 AEST). This puts the .ta=
r.gz=20
> up at:
>=20
>  http://ozlabs.org/~jk/projects/nfsim/

Thanks.

> Jeremy

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--5OiCWnsosOq6PSM0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBVRdxXaXGVTD0i/8RApnnAKCo6wjz5dSjwrWgUUjZWejFnCynswCgq/w8
P9zkfA9CNeocYKb0rerTz2U=
=gU+f
-----END PGP SIGNATURE-----

--5OiCWnsosOq6PSM0--
