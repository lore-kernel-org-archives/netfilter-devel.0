From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] netfilter conntrack missing include fix
Date: Fri, 25 Jul 2003 22:51:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030725205100.GL3244@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lXGjgdROvQphKPvG"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
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


--lXGjgdROvQphKPvG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This is the 5th of a set of bugfixes (all tested against 2.4.22-pre7).
You might need to apply them incrementally (didn't test it in a
different order).  You will receive 2.6 merges of those patches soon.

Author: Martin Bene <martin.bene@icomedias.com>

Add an #include statement to ip_conntrack_core.h
This fixes a compile issue with ipt_connlimit (and probably others)


Please apply,


--- linux.old/include/linux/netfilter_ipv4/ip_conntrack_core.h	2003-07-14 0=
9:49:46.000000000 +0200
+++ linux/include/linux/netfilter_ipv4/ip_conntrack_core.h	2003-07-14 09:50=
:04.000000000 +0200
@@ -1,5 +1,6 @@
 #ifndef _IP_CONNTRACK_CORE_H
 #define _IP_CONNTRACK_CORE_H
+#include <linux/netfilter.h>
 #include <linux/netfilter_ipv4/lockhelp.h>
=20
 /* This header is used to share core functionality between the
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--lXGjgdROvQphKPvG
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/IZg0XaXGVTD0i/8RAtvIAJ0ROEDC/9oJfD99lOqAxYdLpSjhJwCgrhU1
BtPM87mzWxFasolPzLl+hxI=
=+Wnj
-----END PGP SIGNATURE-----

--lXGjgdROvQphKPvG--
