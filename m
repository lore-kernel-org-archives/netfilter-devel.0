From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] 2.4.x netfilter Makefile / Build fix
Date: Sun, 27 Apr 2003 13:48:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427114853.GM990@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WuT04sMzYDXq8et0"
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


--WuT04sMzYDXq8et0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Here's some fixes for a compilation problem in 2.4 when
conntrack-helpers are selected as modules but no NAT support is
configured, but ipfwadm or ipchains is configured.
(No NAT-helpers but CONFIG_IP_NF_NAT_NEEDED is defined)

The patch is from Martin Josefsson.

Please apply, we should get this in before 2.4.21 is released.

Thanks!

diff -urN linux-2.4.21-pre7-bk.orig/net/ipv4/netfilter/Makefile linux-2.4.2=
1-pre7-bk/net/ipv4/netfilter/Makefile
--- linux-2.4.21-pre7-bk.orig/net/ipv4/netfilter/Makefile	2003-04-14 02:42:=
11.000000000 +0200
+++ linux-2.4.21-pre7-bk/net/ipv4/netfilter/Makefile	2003-04-14 02:42:44.00=
0000000 +0200
@@ -31,27 +31,25 @@
 # connection tracking
 obj-$(CONFIG_IP_NF_CONNTRACK) +=3D ip_conntrack.o
=20
-# Amanda protocol support
+# connection tracking helpers
 obj-$(CONFIG_IP_NF_AMANDA) +=3D ip_conntrack_amanda.o
-obj-$(CONFIG_IP_NF_NAT_AMANDA) +=3D ip_nat_amanda.o
-ifdef CONFIG_IP_NF_NAT_AMANDA
+ifdef CONFIG_IP_NF_AMANDA
 	export-objs +=3D ip_conntrack_amanda.o
 endif
=20
-
-# connection tracking helpers
 obj-$(CONFIG_IP_NF_TFTP) +=3D ip_conntrack_tftp.o
 obj-$(CONFIG_IP_NF_FTP) +=3D ip_conntrack_ftp.o
-ifdef CONFIG_IP_NF_NAT_FTP
+ifdef CONFIG_IP_NF_FTP
 	export-objs +=3D ip_conntrack_ftp.o
 endif
=20
 obj-$(CONFIG_IP_NF_IRC) +=3D ip_conntrack_irc.o
-ifdef CONFIG_IP_NF_NAT_IRC
+ifdef CONFIG_IP_NF_IRC
 	export-objs +=3D ip_conntrack_irc.o
 endif
=20
 # NAT helpers=20
+obj-$(CONFIG_IP_NF_NAT_AMANDA) +=3D ip_nat_amanda.o
 obj-$(CONFIG_IP_NF_NAT_TFTP) +=3D ip_nat_tftp.o
 obj-$(CONFIG_IP_NF_NAT_FTP) +=3D ip_nat_ftp.o
 obj-$(CONFIG_IP_NF_NAT_IRC) +=3D ip_nat_irc.o
diff -urN linux-2.4.21-pre7-bk.orig/net/ipv4/netfilter/ip_conntrack_amanda.=
c linux-2.4.21-pre7-bk/net/ipv4/netfilter/ip_conntrack_amanda.c
--- linux-2.4.21-pre7-bk.orig/net/ipv4/netfilter/ip_conntrack_amanda.c	2003=
-04-14 02:42:11.000000000 +0200
+++ linux-2.4.21-pre7-bk/net/ipv4/netfilter/ip_conntrack_amanda.c	2003-04-1=
4 02:42:44.000000000 +0200
@@ -229,5 +229,7 @@
 	return 0;
 }
=20
+EXPORT_SYMBOL(ip_amanda_lock);
+
 module_init(init);
 module_exit(fini);
diff -urN linux-2.4.21-pre7-bk.orig/net/ipv4/netfilter/ip_conntrack_ftp.c l=
inux-2.4.21-pre7-bk/net/ipv4/netfilter/ip_conntrack_ftp.c
--- linux-2.4.21-pre7-bk.orig/net/ipv4/netfilter/ip_conntrack_ftp.c	2003-04=
-14 02:42:02.000000000 +0200
+++ linux-2.4.21-pre7-bk/net/ipv4/netfilter/ip_conntrack_ftp.c	2003-04-14 0=
2:42:44.000000000 +0200
@@ -436,9 +436,7 @@
 	return 0;
 }
=20
-#ifdef CONFIG_IP_NF_NAT_NEEDED
 EXPORT_SYMBOL(ip_ftp_lock);
-#endif
=20
 MODULE_LICENSE("GPL");
 module_init(init);
diff -urN linux-2.4.21-pre7-bk.orig/net/ipv4/netfilter/ip_conntrack_irc.c l=
inux-2.4.21-pre7-bk/net/ipv4/netfilter/ip_conntrack_irc.c
--- linux-2.4.21-pre7-bk.orig/net/ipv4/netfilter/ip_conntrack_irc.c	2002-11=
-29 00:53:15.000000000 +0100
+++ linux-2.4.21-pre7-bk/net/ipv4/netfilter/ip_conntrack_irc.c	2003-04-14 0=
2:42:44.000000000 +0200
@@ -305,9 +305,7 @@
 	}
 }
=20
-#ifdef CONFIG_IP_NF_NAT_NEEDED
 EXPORT_SYMBOL(ip_irc_lock);
-#endif
=20
 module_init(init);
 module_exit(fini);
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--WuT04sMzYDXq8et0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+q8OlXaXGVTD0i/8RApQvAJ9KmUyU7EizqoS65/xKHPDLm10x0QCaAmXm
7VWoeqBMsilPO9L7SvAfYsY=
=U7BX
-----END PGP SIGNATURE-----

--WuT04sMzYDXq8et0--
