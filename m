From: netfilter@interlinx.bc.ca
Subject: [PATCH] p-o-mification of nfnetlink-ctnetlink patch
Date: Fri, 13 Sep 2002 16:52:02 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020913205202.GG2689@pc.ilinx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlxN1C6awaFNesUv"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
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


--UlxN1C6awaFNesUv
Content-Type: multipart/mixed; boundary="ZOudaV4lSIjFTlHv"
Content-Disposition: inline


--ZOudaV4lSIjFTlHv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[ Sorry if this shows up as a duplicate later.  I forgot to use the
  correct posting address and didn't want to wait to see if/when it
  would be approved by the list manager. ]

Hi all,

I noticed when working on my Amanda conntrack/nat module that the
nfnetlink-ctnetlink in p-o-m was not quite to p-o-m standards with
regard to separation of the parts of the patch.  Please find attached
a patch to p-o-m which "p-o-mifies" the one nfnetlink-ctnetlink patch.

Thanx,
b.

--=20
Brian J. Murrell

--ZOudaV4lSIjFTlHv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="nfnetlink-ctnetlink.patch"
Content-Transfer-Encoding: quoted-printable

diff --exclude CVS -Nur ./patch-o-matic/extra/nfnetlink-ctnetlink-0.11.patc=
h ../netfilter/patch-o-matic/extra/nfnetlink-ctnetlink-0.11.patch
--- ./patch-o-matic/extra/nfnetlink-ctnetlink-0.11.patch	2002-09-13 14:49:4=
5.000000000 -0400
+++ ../netfilter/patch-o-matic/extra/nfnetlink-ctnetlink-0.11.patch	2002-08=
-21 10:53:15.000000000 -0400
@@ -1,45 +1,3 @@
-diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.fla=
gs --exclude *.orig --exclude *.rej --exclude *~ linuxppc-020802-newnat/net=
/ipv4/netfilter/Config.in linuxppc-020802-newnat14-ctnl/net/ipv4/netfilter/=
Config.in
---- linuxppc-020802-newnat/net/ipv4/netfilter/Config.in	Fri Aug  2 02:32:3=
0 2002
-+++ linuxppc-020802-newnat14-ctnl/net/ipv4/netfilter/Config.in	Fri Aug  2 =
15:45:54 2002
-@@ -4,11 +4,19 @@
- mainmenu_option next_comment
- comment '  IP: Netfilter Configuration'
-=20
-+tristate 'Netfilter netlink interface' CONFIG_IP_NF_NETLINK
-+
- tristate 'Connection tracking (required for masq/NAT)' CONFIG_IP_NF_CONNT=
RACK
- if [ "$CONFIG_IP_NF_CONNTRACK" !=3D "n" ]; then
-   dep_tristate '  FTP protocol support' CONFIG_IP_NF_FTP $CONFIG_IP_NF_CO=
NNTRACK
-   dep_tristate '  IRC protocol support' CONFIG_IP_NF_IRC $CONFIG_IP_NF_CO=
NNTRACK
-+  if [ "$CONFIG_IP_NF_CONNTRACK" =3D "y" ]; then
-+    dep_tristate '  Connection tracking netlink interface' CONFIG_IP_NF_N=
ETLINK_CONNTRACK $CONFIG_IP_NF_NETLINK
-+  else
-+    dep_tristate '  Connection tracking netlink interface' CONFIG_IP_NF_N=
ETLINK_CONNTRACK $CONFIG_IP_NF_CONNTRACK
-+  fi
- fi
-+
-=20
- if [ "$CONFIG_EXPERIMENTAL" =3D "y" ]; then
-   tristate 'Userspace queueing via NETLINK (EXPERIMENTAL)' CONFIG_IP_NF_Q=
UEUE
-diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.fla=
gs --exclude *.orig --exclude *.rej --exclude *~ linuxppc-020802-newnat/net=
/ipv4/netfilter/Makefile linuxppc-020802-newnat14-ctnl/net/ipv4/netfilter/M=
akefile
---- linuxppc-020802-newnat/net/ipv4/netfilter/Makefile	Fri Aug  2 11:18:23=
 2002
-+++ linuxppc-020802-newnat14-ctnl/net/ipv4/netfilter/Makefile	Fri Aug  2 1=
5:41:30 2002
-@@ -28,6 +28,15 @@
- ipfwadm-objs		:=3D $(ip_nf_compat-objs) ipfwadm_core.o
- ipchains-objs		:=3D $(ip_nf_compat-objs) ipchains_core.o
-=20
-+# netfilter netlink interface
-+obj-$(CONFIG_IP_NF_NETLINK) +=3D nfnetlink.o
-+ifdef CONFIG_IP_NF_NETLINK
-+	export-objs +=3D nfnetlink.o
-+endif
-+
-+# nfnetlink modules
-+obj-$(CONFIG_IP_NF_NETLINK_CONNTRACK) +=3D nfnetlink_conntrack.o
-+
- # connection tracking
- obj-$(CONFIG_IP_NF_CONNTRACK) +=3D ip_conntrack.o
-=20
 diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.fla=
gs --exclude *.orig --exclude *.rej --exclude *~ linuxppc-020802-newnat/net=
/ipv4/netfilter/nfnetlink.c linuxppc-020802-newnat14-ctnl/net/ipv4/netfilte=
r/nfnetlink.c
 --- linuxppc-020802-newnat/net/ipv4/netfilter/nfnetlink.c	Thu Jan  1 01:00=
:00 1970
 +++ linuxppc-020802-newnat14-ctnl/net/ipv4/netfilter/nfnetlink.c	Fri Aug  =
2 16:35:39 2002
diff --exclude CVS -Nur ./patch-o-matic/extra/nfnetlink-ctnetlink-0.11.patc=
h.config.in ../netfilter/patch-o-matic/extra/nfnetlink-ctnetlink-0.11.patch=
.config.in
--- ./patch-o-matic/extra/nfnetlink-ctnetlink-0.11.patch.config.in	1969-12-=
31 19:00:00.000000000 -0500
+++ ../netfilter/patch-o-matic/extra/nfnetlink-ctnetlink-0.11.patch.config.=
in	2002-08-21 10:47:28.000000000 -0400
@@ -0,0 +1,3 @@
+comment '  IP: Netfilter Configuration'
+
+tristate 'Netfilter netlink interface' CONFIG_IP_NF_NETLINK
diff --exclude CVS -Nur ./patch-o-matic/extra/nfnetlink-ctnetlink-0.11.patc=
h.config.in-2 ../netfilter/patch-o-matic/extra/nfnetlink-ctnetlink-0.11.pat=
ch.config.in-2
--- ./patch-o-matic/extra/nfnetlink-ctnetlink-0.11.patch.config.in-2	1969-1=
2-31 19:00:00.000000000 -0500
+++ ../netfilter/patch-o-matic/extra/nfnetlink-ctnetlink-0.11.patch.config.=
in-2	2002-08-21 10:50:06.000000000 -0400
@@ -0,0 +1,6 @@
+if [ "$CONFIG_IP_NF_CONNTRACK" !=3D "n" ]; then
+  if [ "$CONFIG_IP_NF_CONNTRACK" =3D "y" ]; then
+    dep_tristate '  Connection tracking netlink interface' CONFIG_IP_NF_NE=
TLINK_CONNTRACK $CONFIG_IP_NF_NETLINK
+  else
+    dep_tristate '  Connection tracking netlink interface' CONFIG_IP_NF_NE=
TLINK_CONNTRACK $CONFIG_IP_NF_CONNTRACK
+  fi
diff --exclude CVS -Nur ./patch-o-matic/extra/nfnetlink-ctnetlink-0.11.patc=
h.makefile ../netfilter/patch-o-matic/extra/nfnetlink-ctnetlink-0.11.patch.=
makefile
--- ./patch-o-matic/extra/nfnetlink-ctnetlink-0.11.patch.makefile	1969-12-3=
1 19:00:00.000000000 -0500
+++ ../netfilter/patch-o-matic/extra/nfnetlink-ctnetlink-0.11.patch.makefil=
e	2002-08-21 10:52:48.000000000 -0400
@@ -0,0 +1,10 @@
+ipchains-objs		:=3D $(ip_nf_compat-objs) ipchains_core.o
+
+# netfilter netlink interface
+obj-$(CONFIG_IP_NF_NETLINK) +=3D nfnetlink.o
+ifdef CONFIG_IP_NF_NETLINK
+	export-objs +=3D nfnetlink.o
+endif
+
+# nfnetlink modules
+obj-$(CONFIG_IP_NF_NETLINK_CONNTRACK) +=3D nfnetlink_conntrack.o

--ZOudaV4lSIjFTlHv--

--UlxN1C6awaFNesUv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9gk/yl3EQlGLyuXARAuK+AJ4pHBycq29DY2/hUOdCIid8Y/nZPgCfXlRT
4zJiY2Z0RgbdxRu28EBS2Tw=
=eWko
-----END PGP SIGNATURE-----

--UlxN1C6awaFNesUv--
