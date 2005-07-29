From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] Remove bogus declaration of ipt_mutex
Date: Fri, 29 Jul 2005 14:47:43 +0200
Message-ID: <20050729124743.GE7063@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gMR3gsNFwZpnI/Ts"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
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


--gMR3gsNFwZpnI/Ts
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Marcelo!

Please apply the following trivial fix to your 2.4.32-preX tree:

[NETFILTER] Remove bogus declaration of ipt_mutex

Fix compiler error (gcc-4.0) for bogus declaration of ipt_mutex

Signed-off-by: Harald Welte <laforge@netfilter.org>

diff -Nru linux-2.4.31/include/linux/netfilter_ipv4/ip_tables.h linux-2.4.3=
2-pre2/include/linux/netfilter_ipv4/ip_tables.h
--- linux-2.4.31/include/linux/netfilter_ipv4/ip_tables.h	2005-04-04 03:42:=
20.000000000 +0200
+++ linux-2.4.32-pre2/include/linux/netfilter_ipv4/ip_tables.h	2005-07-29 1=
4:05:27.000000000 +0200
@@ -283,8 +283,6 @@
 	struct ipt_entry entrytable[0];
 };
=20
-extern struct semaphore ipt_mutex;
-
 /* Standard return verdict, or do jump. */
 #define IPT_STANDARD_TARGET ""
 /* Error verdict. */

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--gMR3gsNFwZpnI/Ts
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC6iVvXaXGVTD0i/8RAl4/AJ46Uu0Z+Bhn+ZLJ4jZA6d+6nO+vsACfVeSM
m0CYKf0Wx/moqUzAyXb8HZs=
=92Dt
-----END PGP SIGNATURE-----

--gMR3gsNFwZpnI/Ts--
