From: Harald Welte <laforge@netfilter.org>
Subject: conntrack state synchronization development
Date: Sun, 19 Oct 2003 19:51:38 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031019175138.GT21521@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dBmMfAlnUmK8h9+K"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	netfilter-failover@lists.netfilter.org,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--dBmMfAlnUmK8h9+K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

After some long time of quiescence, there is now some movement in the
netfilter-failover project.

Kovacs Krisztian has done a proof-of-concept implementation of my
OLS2002 paper, and this reference implementation has been committed to a
new CVS repository.   You can find the code at=20

cvs -d:pserver:cvs:cvs@pserver.netfilter.org:/cvspublic co netfilter-ha
(CVSweb at http://cvs.netfilter.org/netfilter-ha/)

Please do _not_ consider this code as production ready or something.
It's a starting point, from which I will continue the implementation.

However, if you are interested on the architecture, feel free to read
the code and comment to the netfilter-failover@lists.netfilter.org
mailinglist.

Thanks to Krisztian for the initial implementation.
Thanks to Astaro AG for paying me to continue the work on conntrack
failover.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--dBmMfAlnUmK8h9+K
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/ks8qXaXGVTD0i/8RAhmPAKCRi8BDuuzFj3DaBsmeVChXXMIFigCfR14T
NBAKjWu7sLrKkpJDVbRydbQ=
=t0KK
-----END PGP SIGNATURE-----

--dBmMfAlnUmK8h9+K--
