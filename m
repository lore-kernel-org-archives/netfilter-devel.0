From: Harald Welte <laforge@gnumonks.org>
Subject: [PATCH] remove __NO_VERSION__ from netfilter/iptables
Date: Sat, 7 Sep 2002 18:39:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020907183912.M9675@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VOAkKSXG6MhRWuAn"
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


--VOAkKSXG6MhRWuAn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Please apply the following patch, since __NO_VERSION is bogus since 2.3.x t=
imes
according to Keith Owens + Rusty.

Thanks.

diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/curren=
t-dontdiff --minimal .5467-linux-2.5.33/net/ipv4/netfilter/ip_conntrack_cor=
e.c .5467-linux-2.5.33.updated/net/ipv4/netfilter/ip_conntrack_core.c
--- .5467-linux-2.5.33/net/ipv4/netfilter/ip_conntrack_core.c	2002-08-28 09=
:29:54.000000000 +1000
+++ .5467-linux-2.5.33.updated/net/ipv4/netfilter/ip_conntrack_core.c	2002-=
09-02 12:38:35.000000000 +1000
@@ -14,7 +14,6 @@
  * */
=20
 #ifdef MODULE
-#define __NO_VERSION__
 #endif
 #include <linux/version.h>
 #include <linux/config.h>
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/curren=
t-dontdiff --minimal .5467-linux-2.5.33/net/ipv4/netfilter/ip_conntrack_pro=
to_tcp.c .5467-linux-2.5.33.updated/net/ipv4/netfilter/ip_conntrack_proto_t=
cp.c
--- .5467-linux-2.5.33/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2002-05-=
24 15:20:35.000000000 +1000
+++ .5467-linux-2.5.33.updated/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	=
2002-09-02 12:38:35.000000000 +1000
@@ -1,4 +1,3 @@
-#define __NO_VERSION__
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/timer.h>
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/curren=
t-dontdiff --minimal .5467-linux-2.5.33/net/ipv4/netfilter/ip_nat_core.c .5=
467-linux-2.5.33.updated/net/ipv4/netfilter/ip_nat_core.c
--- .5467-linux-2.5.33/net/ipv4/netfilter/ip_nat_core.c	2002-09-01 12:23:08=
.000000000 +1000
+++ .5467-linux-2.5.33.updated/net/ipv4/netfilter/ip_nat_core.c	2002-09-02 =
12:38:35.000000000 +1000
@@ -3,7 +3,6 @@
 /* (c) 1999 Paul `Rusty' Russell.  Licenced under the GNU General
    Public Licence. */
 #ifdef MODULE
-#define __NO_VERSION__
 #endif
 #include <linux/version.h>
 #include <linux/module.h>
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/curren=
t-dontdiff --minimal .5467-linux-2.5.33/net/ipv4/netfilter/ip_nat_rule.c .5=
467-linux-2.5.33.updated/net/ipv4/netfilter/ip_nat_rule.c
--- .5467-linux-2.5.33/net/ipv4/netfilter/ip_nat_rule.c	2002-05-24 15:20:35=
.000000000 +1000
+++ .5467-linux-2.5.33.updated/net/ipv4/netfilter/ip_nat_rule.c	2002-09-02 =
12:38:35.000000000 +1000
@@ -1,5 +1,4 @@
 /* Everything about the rules for NAT. */
-#define __NO_VERSION__
 #include <linux/types.h>
 #include <linux/ip.h>
 #include <linux/netfilter.h>

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+=
=20
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)

--VOAkKSXG6MhRWuAn
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9eiuvXaXGVTD0i/8RAuUyAKCrh3WYYtUyl59G0qkCcyUa3J/howCgkJnv
dbN8Q4egn8R6R4Vb1yoG478=
=YMYf
-----END PGP SIGNATURE-----

--VOAkKSXG6MhRWuAn--
