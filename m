From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] netfilter listhelp.c: fix erroneous (const)
Date: Fri, 20 Feb 2004 19:28:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040220182818.GL4797@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WTEzZvM72OaERIi0"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
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


--WTEzZvM72OaERIi0
Content-Type: multipart/mixed; boundary="l4IMblsHEWQg+b+m"
Content-Disposition: inline


--l4IMblsHEWQg+b+m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Please apply the following fix to your 2.4.x tree, it fixes an erroneous
'const' qualifier introduced by one of our last patches.

A 2.6.x re-sync (probably the last one that syncs from 2.4 to 2.6 and
not the other way around) will follow in a couple of minutes.

Thanks.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--l4IMblsHEWQg+b+m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="91_listhelp_fix.patch"

--- linux-2.4.22-locking-refcount/include/linux/netfilter_ipv4/listhelp.h	2003-11-14 14:02:25.000000000 +0100
+++ a/include/linux/netfilter_ipv4/listhelp.h	2004-02-20 13:27:18.000000000 +0100
@@ -28,7 +28,7 @@
 							\
 	ASSERT_WRITE_LOCK(head);			\
 	list_for_each(__i, (head))			\
-		if (cmpfn((const type)__i , ## args)) {	\
+		if (cmpfn((type)__i , ## args)) {	\
 			__j = __i;			\
 			break;				\
 		}					\

--l4IMblsHEWQg+b+m--

--WTEzZvM72OaERIi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFANlHCXaXGVTD0i/8RAvaoAJ9z87BgAzXmKw1SzI7S6IlL0hNiowCdGIWw
xQAjFITKdjGGhhKqUzc1XpM=
=QhFI
-----END PGP SIGNATURE-----

--WTEzZvM72OaERIi0--
