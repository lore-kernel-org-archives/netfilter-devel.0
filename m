From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] bugfix for ip_queue_maxlen sysctl
Date: Tue, 4 Nov 2003 16:55:53 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031104155553.GB31614@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sHrvAb52M6C8blB9"
Cc: James Morris <jmorris@intercode.com.au>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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


--sHrvAb52M6C8blB9
Content-Type: multipart/mixed; boundary="UHN/qo2QbUvPLonB"
Content-Disposition: inline


--UHN/qo2QbUvPLonB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

Unfortunately the current  ip_queue implementation keeps two variables
for the maximum queue length:  One that can be set via sysctl (but is
not used internally), and one that is used by the implementation, but
cannot be set by the user. (bugzilla.netfilter.org #150)

Please apply to the 2.4 tree (2.6 merge will be sent soon).

Thanks to Jim Minter for spotting this bug.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--UHN/qo2QbUvPLonB
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

--UHN/qo2QbUvPLonB--

--sHrvAb52M6C8blB9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/p8wJXaXGVTD0i/8RAsKgAKCIP1UOzmAKw9V893Re+P29cbwGIACdG2IE
KmM1w668xzC0uU1axFVgrlc=
=9BSC
-----END PGP SIGNATURE-----

--sHrvAb52M6C8blB9--
