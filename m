From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4.23] pending ip_queue_maxlen fix
Date: Sun, 30 Nov 2003 17:46:50 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031130121650.GC1506@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ey/N+yb7u/X9mFhi"
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


--ey/N+yb7u/X9mFhi
Content-Type: multipart/mixed; boundary="vni90+aGYgRvsTuO"
Content-Disposition: inline


--vni90+aGYgRvsTuO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Somehow the attached fix didn't make it into 2.4.23.  I thought I had
submitted this before, but I must have be mistaken.  Anyway, please make su=
re
this included in 2.4.24.

Thanks!

--- linux/net/ipv4/netfilter/ip_queue.c	2002-11-29 00:53:15.000000000 +0100
+++ linux-new/net/ipv4/netfilter/ip_queue.c	2003-11-04 16:46:54.000000000 +=
0100
@@ -581,12 +581,11 @@
 	0
 };
=20
-static int sysctl_maxlen =3D IPQ_QMAX_DEFAULT;
 static struct ctl_table_header *ipq_sysctl_header;
=20
 static ctl_table ipq_table[] =3D {
-	{ NET_IPQ_QMAX, NET_IPQ_QMAX_NAME, &sysctl_maxlen,
-	  sizeof(sysctl_maxlen), 0644,  NULL, proc_dointvec },
+	{ NET_IPQ_QMAX, NET_IPQ_QMAX_NAME, &queue_maxlen,
+	  sizeof(queue_maxlen), 0644,  NULL, proc_dointvec },
  	{ 0 }
 };
=20
--- linux/net/ipv6/netfilter/ip6_queue.c	2002-11-29 00:53:15.000000000 +0100
+++ linux-new/net/ipv6/netfilter/ip6_queue.c	2003-11-04 16:47:57.000000000 =
+0100
@@ -624,12 +624,11 @@
 	0
 };
=20
-static int sysctl_maxlen =3D IPQ_QMAX_DEFAULT;
 static struct ctl_table_header *ipq_sysctl_header;
=20
 static ctl_table ipq_table[] =3D {
-	{ NET_IPQ_QMAX, NET_IPQ_QMAX_NAME, &sysctl_maxlen,
-	  sizeof(sysctl_maxlen), 0644,  NULL, proc_dointvec },
+	{ NET_IPQ_QMAX, NET_IPQ_QMAX_NAME, &queue_maxlen,
+	  sizeof(queue_maxlen), 0644,  NULL, proc_dointvec },
  	{ 0 }
 };
=20
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--vni90+aGYgRvsTuO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="88_ip_queue-maxlen.patch"
Content-Transfer-Encoding: quoted-printable

--- linux/net/ipv4/netfilter/ip_queue.c	2002-11-29 00:53:15.000000000 +0100
+++ linux-new/net/ipv4/netfilter/ip_queue.c	2003-11-04 16:46:54.000000000 +=
0100
@@ -581,12 +581,11 @@
 	0
 };
=20
-static int sysctl_maxlen =3D IPQ_QMAX_DEFAULT;
 static struct ctl_table_header *ipq_sysctl_header;
=20
 static ctl_table ipq_table[] =3D {
-	{ NET_IPQ_QMAX, NET_IPQ_QMAX_NAME, &sysctl_maxlen,
-	  sizeof(sysctl_maxlen), 0644,  NULL, proc_dointvec },
+	{ NET_IPQ_QMAX, NET_IPQ_QMAX_NAME, &queue_maxlen,
+	  sizeof(queue_maxlen), 0644,  NULL, proc_dointvec },
  	{ 0 }
 };
=20
--- linux/net/ipv6/netfilter/ip6_queue.c	2002-11-29 00:53:15.000000000 +0100
+++ linux-new/net/ipv6/netfilter/ip6_queue.c	2003-11-04 16:47:57.000000000 =
+0100
@@ -624,12 +624,11 @@
 	0
 };
=20
-static int sysctl_maxlen =3D IPQ_QMAX_DEFAULT;
 static struct ctl_table_header *ipq_sysctl_header;
=20
 static ctl_table ipq_table[] =3D {
-	{ NET_IPQ_QMAX, NET_IPQ_QMAX_NAME, &sysctl_maxlen,
-	  sizeof(sysctl_maxlen), 0644,  NULL, proc_dointvec },
+	{ NET_IPQ_QMAX, NET_IPQ_QMAX_NAME, &queue_maxlen,
+	  sizeof(queue_maxlen), 0644,  NULL, proc_dointvec },
  	{ 0 }
 };
=20

--vni90+aGYgRvsTuO--

--ey/N+yb7u/X9mFhi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/yd/HXaXGVTD0i/8RAsVpAJ9WSsv4QJ/AD3pfPXlmXS92mXmdNwCdFVhY
XknWtqi//PgWSBFrj0f3Sys=
=sNls
-----END PGP SIGNATURE-----

--ey/N+yb7u/X9mFhi--
