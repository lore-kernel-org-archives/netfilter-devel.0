From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] Use C99 initializers for conntrack sysctl tables
Date: Fri, 20 Feb 2004 22:07:58 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040220210758.GV4797@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I9088/5HKimF9CYi"
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


--I9088/5HKimF9CYi
Content-Type: multipart/mixed; boundary="eG/Mb3lYspOUTzsV"
Content-Disposition: inline


--eG/Mb3lYspOUTzsV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi again, Dave!

I guess this needs no further comment.  Oh yes, it depends on the
previous 2.6 resync patch I sent you.

Please apply, thanks

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--eG/Mb3lYspOUTzsV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2.6.3-sysctl.patch"
Content-Transfer-Encoding: quoted-printable

--- linux-2.6.3-nfsubmit/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-=
02-20 20:55:14.000000000 +0100
+++ linux-2.6.3-sysctl/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-02=
-20 22:05:11.000000000 +0100
@@ -300,69 +300,159 @@
 static struct ctl_table_header *ip_ct_sysctl_header;
=20
 static ctl_table ip_ct_sysctl_table[] =3D {
-	{NET_IPV4_NF_CONNTRACK_MAX, "ip_conntrack_max",
-	 &ip_conntrack_max, sizeof(int), 0644, NULL,
-	 &proc_dointvec},
-	{NET_IPV4_NF_CONNTRACK_BUCKETS, "ip_conntrack_buckets",
-	 &ip_conntrack_htable_size, sizeof(unsigned int), 0444, NULL,
-	 &proc_dointvec},
-	{NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_SYN_SENT, "ip_conntrack_tcp_timeout_sy=
n_sent",
-	 &ip_ct_tcp_timeout_syn_sent, sizeof(unsigned int), 0644, NULL,
-	 &proc_dointvec_jiffies},
-	{NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_SYN_RECV, "ip_conntrack_tcp_timeout_sy=
n_recv",
-	 &ip_ct_tcp_timeout_syn_recv, sizeof(unsigned int), 0644, NULL,
-	 &proc_dointvec_jiffies},
-	{NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_ESTABLISHED, "ip_conntrack_tcp_timeout=
_established",
-	 &ip_ct_tcp_timeout_established, sizeof(unsigned int), 0644, NULL,
-	 &proc_dointvec_jiffies},
-	{NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_FIN_WAIT, "ip_conntrack_tcp_timeout_fi=
n_wait",
-	 &ip_ct_tcp_timeout_fin_wait, sizeof(unsigned int), 0644, NULL,
-	 &proc_dointvec_jiffies},
-	{NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_CLOSE_WAIT, "ip_conntrack_tcp_timeout_=
close_wait",
-	 &ip_ct_tcp_timeout_close_wait, sizeof(unsigned int), 0644, NULL,
-	 &proc_dointvec_jiffies},
-	{NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_LAST_ACK, "ip_conntrack_tcp_timeout_la=
st_ack",
-	 &ip_ct_tcp_timeout_last_ack, sizeof(unsigned int), 0644, NULL,
-	 &proc_dointvec_jiffies},
-	{NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_TIME_WAIT, "ip_conntrack_tcp_timeout_t=
ime_wait",
-	 &ip_ct_tcp_timeout_time_wait, sizeof(unsigned int), 0644, NULL,
-	 &proc_dointvec_jiffies},
-	{NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_CLOSE, "ip_conntrack_tcp_timeout_close=
",
-	 &ip_ct_tcp_timeout_close, sizeof(unsigned int), 0644, NULL,
-	 &proc_dointvec_jiffies},
-	{NET_IPV4_NF_CONNTRACK_UDP_TIMEOUT, "ip_conntrack_udp_timeout",
-	 &ip_ct_udp_timeout, sizeof(unsigned int), 0644, NULL,
-	 &proc_dointvec_jiffies},
-	{NET_IPV4_NF_CONNTRACK_UDP_TIMEOUT_STREAM, "ip_conntrack_udp_timeout_stre=
am",
-	 &ip_ct_udp_timeout_stream, sizeof(unsigned int), 0644, NULL,
-	 &proc_dointvec_jiffies},
-	{NET_IPV4_NF_CONNTRACK_ICMP_TIMEOUT, "ip_conntrack_icmp_timeout",
-	 &ip_ct_icmp_timeout, sizeof(unsigned int), 0644, NULL,
-	 &proc_dointvec_jiffies},
-	{NET_IPV4_NF_CONNTRACK_GENERIC_TIMEOUT, "ip_conntrack_generic_timeout",
-	 &ip_ct_generic_timeout, sizeof(unsigned int), 0644, NULL,
-	 &proc_dointvec_jiffies},
-	{0}
+	{
+		.ctl_name	=3D NET_IPV4_NF_CONNTRACK_MAX,
+		.procname	=3D "ip_conntrack_max",
+		.data		=3D &ip_conntrack_max,
+		.maxlen		=3D sizeof(int),
+		.mode		=3D 0644,
+		.proc_handler	=3D &proc_dointvec,
+	},
+	{
+		.ctl_name	=3D NET_IPV4_NF_CONNTRACK_BUCKETS,
+		.procname	=3D "ip_conntrack_buckets",
+		.data		=3D &ip_conntrack_htable_size,
+		.maxlen		=3D sizeof(unsigned int),
+		.mode		=3D 0444,
+		.proc_handler	=3D &proc_dointvec,
+	},
+	{
+		.ctl_name	=3D NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_SYN_SENT,
+		.procname	=3D "ip_conntrack_tcp_timeout_syn_sent",
+		.data		=3D &ip_ct_tcp_timeout_syn_sent,
+		.maxlen		=3D sizeof(unsigned int),
+		.mode		=3D 0644,
+		.proc_handler	=3D &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	=3D NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_SYN_RECV,
+		.procname	=3D "ip_conntrack_tcp_timeout_syn_recv",
+		.data		=3D &ip_ct_tcp_timeout_syn_recv,
+		.maxlen		=3D sizeof(unsigned int),
+		.mode		=3D 0644,
+		.proc_handler	=3D &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	=3D NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_ESTABLISHED,
+		.procname	=3D "ip_conntrack_tcp_timeout_established",
+		.data		=3D &ip_ct_tcp_timeout_established,
+		.maxlen		=3D sizeof(unsigned int),
+		.mode		=3D 0644,
+		.proc_handler	=3D &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	=3D NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_FIN_WAIT,
+		.procname	=3D "ip_conntrack_tcp_timeout_fin_wait",
+		.data		=3D &ip_ct_tcp_timeout_fin_wait,
+		.maxlen		=3D sizeof(unsigned int),
+		.mode		=3D 0644,
+		.proc_handler	=3D &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	=3D NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_CLOSE_WAIT,
+		.procname	=3D "ip_conntrack_tcp_timeout_close_wait",
+		.data		=3D &ip_ct_tcp_timeout_close_wait,
+		.maxlen		=3D sizeof(unsigned int),
+		.mode		=3D 0644,
+		.proc_handler	=3D &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	=3D NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_LAST_ACK,
+		.procname	=3D "ip_conntrack_tcp_timeout_last_ack",
+		.data		=3D &ip_ct_tcp_timeout_last_ack,
+		.maxlen		=3D sizeof(unsigned int),
+		.mode		=3D 0644,
+		.proc_handler	=3D &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	=3D NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_TIME_WAIT,
+		.procname	=3D "ip_conntrack_tcp_timeout_time_wait",
+		.data		=3D &ip_ct_tcp_timeout_time_wait,
+		.maxlen		=3D sizeof(unsigned int),
+		.mode		=3D 0644,
+		.proc_handler	=3D &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	=3D NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_CLOSE,
+		.procname	=3D "ip_conntrack_tcp_timeout_close",
+		.data		=3D &ip_ct_tcp_timeout_close,
+		.maxlen		=3D sizeof(unsigned int),
+		.mode		=3D 0644,
+		.proc_handler	=3D &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	=3D NET_IPV4_NF_CONNTRACK_UDP_TIMEOUT,
+		.procname	=3D "ip_conntrack_udp_timeout",
+		.data		=3D &ip_ct_udp_timeout,
+		.maxlen		=3D sizeof(unsigned int),
+		.mode		=3D 0644,
+		.proc_handler	=3D &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	=3D NET_IPV4_NF_CONNTRACK_UDP_TIMEOUT_STREAM,
+		.procname	=3D "ip_conntrack_udp_timeout_stream",
+		.data		=3D &ip_ct_udp_timeout_stream,
+		.maxlen		=3D sizeof(unsigned int),
+		.mode		=3D 0644,
+		.proc_handler	=3D &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	=3D NET_IPV4_NF_CONNTRACK_ICMP_TIMEOUT,
+		.procname	=3D "ip_conntrack_icmp_timeout",
+		.data		=3D &ip_ct_icmp_timeout,
+		.maxlen		=3D sizeof(unsigned int),
+		.mode		=3D 0644,
+		.proc_handler	=3D &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	=3D NET_IPV4_NF_CONNTRACK_GENERIC_TIMEOUT,
+		.procname	=3D "ip_conntrack_generic_timeout",
+		.data		=3D &ip_ct_generic_timeout,
+		.maxlen		=3D sizeof(unsigned int),
+		.mode		=3D 0644,
+		.proc_handler	=3D &proc_dointvec_jiffies,
+	},
+	{ .ctl_name =3D 0 }
 };
=20
 #define NET_IP_CONNTRACK_MAX 2089
=20
 static ctl_table ip_ct_netfilter_table[] =3D {
-	{NET_IPV4_NETFILTER, "netfilter", NULL, 0, 0555, ip_ct_sysctl_table, 0, 0=
, 0, 0, 0},
-	{NET_IP_CONNTRACK_MAX, "ip_conntrack_max",
-	 &ip_conntrack_max, sizeof(int), 0644, NULL,
-	 &proc_dointvec},
-	{0}
+	{
+		.ctl_name	=3D NET_IPV4_NETFILTER,
+		.procname	=3D "netfilter",
+		.mode		=3D 0555,
+		.child		=3D ip_ct_sysctl_table,
+	},
+	{
+		.ctl_name	=3D NET_IP_CONNTRACK_MAX,
+		.procname	=3D "ip_conntrack_max",
+		.data		=3D &ip_conntrack_max,
+		.maxlen		=3D sizeof(int),
+		.mode		=3D 0644,
+		.proc_handler	=3D &proc_dointvec
+	},
+	{ .ctl_name =3D 0 }
 };
=20
 static ctl_table ip_ct_ipv4_table[] =3D {
-	{NET_IPV4, "ipv4", NULL, 0, 0555, ip_ct_netfilter_table, 0, 0, 0, 0, 0},
-	{0}
+	{
+		.ctl_name	=3D NET_IPV4,
+		.procname	=3D "ipv4",
+		.mode		=3D 0555,
+		.child		=3D ip_ct_netfilter_table,
+	},
+	{ .ctl_name =3D 0 }
 };
=20
 static ctl_table ip_ct_net_table[] =3D {
-	{CTL_NET, "net", NULL, 0, 0555, ip_ct_ipv4_table, 0, 0, 0, 0, 0},
-	{0}
+	{
+		.ctl_name	=3D CTL_NET,
+		.procname	=3D "net",
+		.mode		=3D 0555,=20
+		.child		=3D ip_ct_ipv4_table,
+	},
+	{ .ctl_name =3D 0 }
 };
 #endif
 static int init_or_cleanup(int init)


--eG/Mb3lYspOUTzsV--

--I9088/5HKimF9CYi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFANncuXaXGVTD0i/8RAihiAJ0WtyizLzZzyiP+7PEEoc2RgcHibwCdHHpx
HPeLBOKVKszF1Hwc4H0tJu0=
=zLl3
-----END PGP SIGNATURE-----

--I9088/5HKimF9CYi--
