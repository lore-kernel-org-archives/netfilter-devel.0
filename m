From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] netfilter buildfix / exported symbols
Date: Mon, 28 Apr 2003 00:32:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427223244.GZ990@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s89yJNDe6fM6BJKb"
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


--s89yJNDe6fM6BJKb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Attached patch (for 2.5.x) fixes a problem with [un]exported symbols in
certain configurations.

Please apply, thanks.


diff -x '*.orig' -urN linux-2.5-bk.orig/net/ipv4/netfilter/ip_conntrack_ama=
nda.c linux-2.5-bk/net/ipv4/netfilter/ip_conntrack_amanda.c
--- linux-2.5-bk.orig/net/ipv4/netfilter/ip_conntrack_amanda.c	2003-04-20 0=
4:50:07.000000000 +0200
+++ linux-2.5-bk/net/ipv4/netfilter/ip_conntrack_amanda.c	2003-04-27 22:34:=
17.000000000 +0200
@@ -207,5 +207,7 @@
 	return 0;
 }
=20
+EXPORT_SYMBOL(ip_amanda_lock);
+
 module_init(init);
 module_exit(fini);
diff -x '*.orig' -urN linux-2.5-bk.orig/net/ipv4/netfilter/ip_conntrack_ftp=
.c linux-2.5-bk/net/ipv4/netfilter/ip_conntrack_ftp.c
--- linux-2.5-bk.orig/net/ipv4/netfilter/ip_conntrack_ftp.c	2003-04-20 04:5=
0:35.000000000 +0200
+++ linux-2.5-bk/net/ipv4/netfilter/ip_conntrack_ftp.c	2003-04-27 22:34:17.=
000000000 +0200
@@ -437,9 +437,7 @@
 	return 0;
 }
=20
-#ifdef CONFIG_IP_NF_NAT_NEEDED
 EXPORT_SYMBOL(ip_ftp_lock);
-#endif
=20
 MODULE_LICENSE("GPL");
 module_init(init);
diff -x '*.orig' -urN linux-2.5-bk.orig/net/ipv4/netfilter/ip_conntrack_irc=
.c linux-2.5-bk/net/ipv4/netfilter/ip_conntrack_irc.c
--- linux-2.5-bk.orig/net/ipv4/netfilter/ip_conntrack_irc.c	2003-04-20 04:5=
0:35.000000000 +0200
+++ linux-2.5-bk/net/ipv4/netfilter/ip_conntrack_irc.c	2003-04-27 22:34:17.=
000000000 +0200
@@ -289,9 +289,7 @@
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

--s89yJNDe6fM6BJKb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+rFqMXaXGVTD0i/8RAqX+AJ0Ul3dcO3lCJj5YMM/jbAIxuhM/jACeKZhT
cdEhOYzs9XiSaAmRJt06388=
=lsuo
-----END PGP SIGNATURE-----

--s89yJNDe6fM6BJKb--
