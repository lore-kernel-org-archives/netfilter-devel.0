From: Harald Welte <laforge@netfilter.org>
Subject: ctnetlink expect dumping bug
Date: Sun, 29 Jan 2006 19:07:01 +0100
Message-ID: <20060129180700.GA5490@rama.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
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


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

While doing some nf_conntrack development, I hit a bug that I originally
thought to be in my modifications.

However, after reverting all my patches, the bug persists.

The issue is that for dumping the expect mask, we use regular tuple
dumping functions.  Those regular dumping functions call proto_find_get
and l3proto_find_get with protocol value 0xffff, which leads to an array
overflow in those NPROTO sized arrays.

Rather than using the mask value, we'd need to pass the respective value
=66rom the expect tuple for dumping the expect mask.

=46rom looking at the code, it seems the bug also exists in
ip_conntrack_netlink, but I didn't really test it.

Pablo, would you please prepare a fix for this, and confirm it by having
helpers create expectations inside the kernel while running 'conntrack
-E' ?

Thanks.

p.s.: Patrick and me agreed last week to re-work the structure of an
expectation (and its handling).  Despite any of those (probably 2.6.17)
changes, we need to fix this bug in the current upstream stable releases
now.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD3QREXaXGVTD0i/8RAmnVAJ9Rwi4stmAKhjXsbrVs1YlVRqtgtwCgnJdO
xQEyMk7GjXN97kx3sdeGGcg=
=iQzg
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
