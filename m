From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] netfilter: export conntrack bucket count via sysctl
Date: Sun, 30 Nov 2003 21:10:06 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031130154006.GI26749@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OX2aLCKeO1apYW07"
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


--OX2aLCKeO1apYW07
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This mail contains the seventh (and last) netfilter patch, please apply.


Author: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.=
net>

This creates a new (read-only) sysctl to read out the number of hash bucket=
s.


=3D=3D=3D=3D=3D net/ipv4/netfilter/ip_conntrack_standalone.c 1.22 vs edited=
 =3D=3D=3D=3D=3D
--- 1.22/net/ipv4/netfilter/ip_conntrack_standalone.c	Fri Oct  3 08:21:19 2=
003
+++ edited/net/ipv4/netfilter/ip_conntrack_standalone.c	Thu Nov 27 06:28:59=
 2003
@@ -266,6 +266,7 @@
=20
 /* From ip_conntrack_core.c */
 extern int ip_conntrack_max;
+extern unsigned int ip_conntrack_htable_size;
=20
 /* From ip_conntrack_proto_tcp.c */
 extern unsigned long ip_ct_tcp_timeout_syn_sent;
@@ -292,6 +293,9 @@
 static ctl_table ip_ct_sysctl_table[] =3D {
 	{NET_IPV4_NF_CONNTRACK_MAX, "ip_conntrack_max",
 	 &ip_conntrack_max, sizeof(int), 0644, NULL,
+	 &proc_dointvec},
+	{NET_IPV4_NF_CONNTRACK_BUCKETS, "ip_conntrack_buckets",
+	 &ip_conntrack_htable_size, sizeof(unsigned int), 0444, NULL,
 	 &proc_dointvec},
 	{NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_SYN_SENT, "ip_conntrack_tcp_timeout_sy=
n_sent",
 	 &ip_ct_tcp_timeout_syn_sent, sizeof(unsigned int), 0644, NULL,
=3D=3D=3D=3D=3D include/linux/sysctl.h 1.53 vs edited =3D=3D=3D=3D=3D
--- 1.53/include/linux/sysctl.h	Wed Oct 29 21:19:30 2003
+++ edited/include/linux/sysctl.h	Thu Nov 27 06:08:04 2003
@@ -376,6 +376,7 @@
 	NET_IPV4_NF_CONNTRACK_UDP_TIMEOUT_STREAM=3D11,
 	NET_IPV4_NF_CONNTRACK_ICMP_TIMEOUT=3D12,
 	NET_IPV4_NF_CONNTRACK_GENERIC_TIMEOUT=3D13,
+	NET_IPV4_NF_CONNTRACK_BUCKETS=3D14,
 };
 =20
 /* /proc/sys/net/ipv6 */

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--OX2aLCKeO1apYW07
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/yg9rXaXGVTD0i/8RApZkAJwMD5ju6tKsOyls6b6xZbzmvGuFUwCeNopn
wNYVQNP0xB/ASzJt9orgAy0=
=TpXP
-----END PGP SIGNATURE-----

--OX2aLCKeO1apYW07--
