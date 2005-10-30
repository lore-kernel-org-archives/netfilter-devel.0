From: Harald Welte <laforge@netfilter.org>
Subject: Re: PPTP patch
Date: Sun, 30 Oct 2005 10:45:57 +0100
Message-ID: <20051030094557.GB4479@sunbeam.de.gnumonks.org>
References: <01f701c5d9a1$f0fe8020$220ca8c0@columbuscontainer.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u38uBrv5Nk1Kq3n1"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: John HIll <jhill@noach.com>
Content-Disposition: inline
In-Reply-To: <01f701c5d9a1$f0fe8020$220ca8c0@columbuscontainer.com>
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


--u38uBrv5Nk1Kq3n1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 25, 2005 at 03:22:57PM -0500, John HIll wrote:
>=20
> When I compile any kernel 2.6.11.x-2.6.12.x I get an error:
> ip_conntrack_pptp.ko needs unknown symbol __ip_conntrack_expect_find .
>=20
> I searched all over Google and netfilter I found another person with the
> same problem but no replies.

sorry, we don't support any other kernels but the latest released stable
version anymore.   Backporting fixes/code/... is just eating up way too
much valuable development time, sorry.

So unless you find someone who will do the backport, there is little
chance you will get it working.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--u38uBrv5Nk1Kq3n1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDZJZVXaXGVTD0i/8RAoO2AJ4wmFeOWDJWy/DtzfSXJSwBLu8stwCePS05
mLhb3klqMZyL77EnPWkCQYI=
=EDj3
-----END PGP SIGNATURE-----

--u38uBrv5Nk1Kq3n1--
