From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] Fix locking in ip_conntrack_change_expect()
Date: Mon, 14 Oct 2002 18:49:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021014184913.C13233@sunbeam.de.gnumonks.org>
References: <20021014134047.R13233@sunbeam.de.gnumonks.org> <20021014.043805.55513093.davem@redhat.com> <20021014160309.Z13233@sunbeam.de.gnumonks.org> <20021014.070059.53435542.davem@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qAWpXEdoCCy57CK7"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
Content-Disposition: inline
In-Reply-To: <20021014.070059.53435542.davem@redhat.com>; from davem@redhat.com on Mon, Oct 14, 2002 at 07:00:59AM -0700
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--qAWpXEdoCCy57CK7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 14, 2002 at 07:00:59AM -0700, David Miller wrote:
>    From: Harald Welte <laforge@gnumonks.org>
>    Date: Mon, 14 Oct 2002 16:03:09 +0200
>=20
>    On Mon, Oct 14, 2002 at 04:38:05AM -0700, David Miller wrote:
>   =20
>    > I guess this means I really should push this stuff in for
>    > 2.4.20-preX
>   =20
>    yes, this is the only one which should be submitted before 2.4.20-fina=
l.
>=20
> There were two locking fixes Harald :-)

Well, according to my definition of a locking fix (for a locking bug) there
only was one.  Having a nested readlock is not a locking bug.  It was just
the debug statements.

Anyway, it's not worth discussing this further.

> What I want to push to Marcelo is:
>=20
> 1) Avoid nesting readlocks in conntrack
> 2) Fix ip_conntrack_change_expect locking
> 3) Display ipv6 SIT encapsulation properly
>=20
> Ok?

Perfect, thanks.  The only harmful bug is number 2.

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--qAWpXEdoCCy57CK7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9qvWIXaXGVTD0i/8RAsEnAJ9rtUA8jshIKvLGpFQ44M9/0GU60QCghAZ6
cDsLBnAMSJ/4tXNnBDtTvK8=
=rd5G
-----END PGP SIGNATURE-----

--qAWpXEdoCCy57CK7--
