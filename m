From: Sven Wegener <sven.wegener@stealer.net>
Subject: [PATCH] Change default KERNEL_DIR location and add KBUILD_OUTPUT
Date: Sat, 14 Jul 2007 22:15:14 +0200
Message-ID: <20070714201513.GA9970@titan.stealer.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9zSXsLTf0vkW971A"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


--9zSXsLTf0vkW971A
Content-Type: multipart/mixed; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Setting KERNEL_DIR to the build symlink in /lib/modules is wrong. The
build symlink points to the location of generated object files and the
extension tests use KERNEL_DIR to check the availability of certain
source files. The tests will fail, if build and source point to
different locations. Change KERNEL_DIR from build to source and
introduce KBUILD_OUTPUT for the build symink.

--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iptables-kbuild-output.patch"
Content-Transfer-Encoding: quoted-printable

Index: Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- Makefile	(revision 6905)
+++ Makefile	(working copy)
@@ -12,8 +12,11 @@
 TOPLEVEL_INCLUDED=3DYES
=20
 ifndef KERNEL_DIR
-KERNEL_DIR=3D"/lib/modules/$(shell uname -r)/build"
+KERNEL_DIR=3D"/lib/modules/$(shell uname -r)/source"
 endif
+ifndef KBUILD_OUTPUT
+KBUILD_OUTPUT=3D"/lib/modules/$(shell uname -r)/build"
+endif
 IPTABLES_VERSION:=3D1.3.8
 OLD_IPTABLES_VERSION:=3D1.3.7
=20
@@ -37,7 +40,7 @@
 endif
=20
 COPT_FLAGS:=3D-O2
-CFLAGS:=3D$(COPT_FLAGS) -Wall -Wunused -I$(KERNEL_DIR)/include -Iinclude/ =
-DIPTABLES_VERSION=3D\"$(IPTABLES_VERSION)\" #-g -DDEBUG #-pg # -DIPTC_DEBUG
+CFLAGS:=3D$(COPT_FLAGS) -Wall -Wunused -I$(KBUILD_OUTPUT)/include -I$(KERN=
EL_DIR)/include -Iinclude/ -DIPTABLES_VERSION=3D\"$(IPTABLES_VERSION)\" #-g=
 -DDEBUG #-pg # -DIPTC_DEBUG
=20
 ifdef NO_SHARED_LIBS
 CFLAGS +=3D -DNO_SHARED_LIBS=3D1

--oyUTqETQ0mS9luUI--

--9zSXsLTf0vkW971A
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFGmS7RAXomK8S72HoRAgY/AJ4zYwZKSTjOSwaP6fnUhm4N7cRjdwCfdcMU
Thz6HcSLMPqzqNU2cUH73+0=
=zxfj
-----END PGP SIGNATURE-----

--9zSXsLTf0vkW971A--
