From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] fix typo in ftp conntrack helper
Date: Wed, 26 Feb 2003 20:02:29 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030226190229.GC15997@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qbvjkv9qwOGw/5Fx"
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


--Qbvjkv9qwOGw/5Fx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Please apply this (obvious) cosmetic fix,

Thanks.

--- linux/net/ipv4/netfilter/ip_conntrack_ftp.c	2002-11-29 00:53:15.0000000=
00 +0100
+++ linux.new/net/ipv4/netfilter/ip_conntrack_ftp.c	2003-01-10 16:53:57.000=
000000 +0100
@@ -32,7 +32,7 @@
=20
 static int try_rfc959(const char *, size_t, u_int32_t [], char);
 static int try_eprt(const char *, size_t, u_int32_t [], char);
-static int try_espv_response(const char *, size_t, u_int32_t [], char);
+static int try_epsv_response(const char *, size_t, u_int32_t [], char);
=20
 static struct ftp_search {
 	enum ip_conntrack_dir dir;
@@ -65,7 +65,7 @@
 		IP_CT_DIR_REPLY,
 		"229 ", sizeof("229 ") - 1, '(', ')',
 		IP_CT_FTP_EPSV,
-		try_espv_response,
+		try_epsv_response,
 	},
 };
=20
@@ -157,7 +157,7 @@
 }
=20
 /* Returns 0, or length of numbers: |||6446| */
-static int try_espv_response(const char *data, size_t dlen, u_int32_t arra=
y[6],
+static int try_epsv_response(const char *data, size_t dlen, u_int32_t arra=
y[6],
 			     char term)
 {
 	char delim;
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Qbvjkv9qwOGw/5Fx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+XQ9FXaXGVTD0i/8RAr++AJ4tFPc/jTHtwxJWHaYXmS5U8S3aPACfcpRr
tSsqYTujST2datYOJmrGlAI=
=CWzD
-----END PGP SIGNATURE-----

--Qbvjkv9qwOGw/5Fx--
