From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] netfilter: make conntrack timeouts become sysctls
Date: Thu, 2 Oct 2003 18:09:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031002160940.GO5758@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/whNdqcA90P4aItJ"
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


--/whNdqcA90P4aItJ
Content-Type: multipart/mixed; boundary="cVfNNm8lVSmMpOo9"
Content-Disposition: inline


--cVfNNm8lVSmMpOo9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

Please apply the following patchto your 2.6 tree, thanks.

Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

This patch introduces the /proc/sys/net/ipv4/netfilter/ directory for=20
the tuneable parameters of the conntrack engine of netfilter.

The parameters which can currently be fine-tuned (if required at all)=20
are the ip_conntrack_max, and the conntrack timeout parameters in seconds.

The default timeout value for the TCP CLOSE_WAIT state is raised to 3
days, which should cause less problems with long-lived half-closed TCP
sessions.

For the sake of compatibility with 2.4,=20
/proc/sys/net/ipv4/netfilter/ip_conntrack_max is duplicated as=20
/proc/sys/net/ipv4/ip_conntrack_max as well.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--cVfNNm8lVSmMpOo9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="80_ip_conntrack-proc.patch"
Content-Transfer-Encoding: quoted-printable

diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.0-test6-plain/net/ipv4/ne=
tfilter/ip_conntrack_core.c linux-2.6.0-test6-ctsysctl/net/ipv4/netfilter/i=
p_conntrack_core.c
--- linux-2.6.0-test6-plain/net/ipv4/netfilter/ip_conntrack_core.c	2003-09-=
28 02:50:05.000000000 +0200
+++ linux-2.6.0-test6-ctsysctl/net/ipv4/netfilter/ip_conntrack_core.c	2003-=
10-02 17:16:56.000000000 +0200
@@ -59,7 +59,7 @@
 LIST_HEAD(protocol_list);
 static LIST_HEAD(helpers);
 unsigned int ip_conntrack_htable_size =3D 0;
-static int ip_conntrack_max;
+int ip_conntrack_max;
 static atomic_t ip_conntrack_count =3D ATOMIC_INIT(0);
 struct list_head *ip_conntrack_hash;
 static kmem_cache_t *ip_conntrack_cachep;
@@ -1325,45 +1325,6 @@
 	.get		=3D &getorigdst,
 };
=20
-#define NET_IP_CONNTRACK_MAX 2089
-#define NET_IP_CONNTRACK_MAX_NAME "ip_conntrack_max"
-
-#ifdef CONFIG_SYSCTL
-static struct ctl_table_header *ip_conntrack_sysctl_header;
-
-static ctl_table ip_conntrack_table[] =3D {
-	{
-		.ctl_name	=3D NET_IP_CONNTRACK_MAX,
-		.procname	=3D NET_IP_CONNTRACK_MAX_NAME,
-		.data		=3D &ip_conntrack_max,
-		.maxlen		=3D sizeof(ip_conntrack_max),
-		.mode		=3D 0644,
-		.proc_handler	=3D proc_dointvec
-	},
- 	{ .ctl_name =3D 0 }
-};
-
-static ctl_table ip_conntrack_dir_table[] =3D {
-	{
-		.ctl_name	=3D NET_IPV4,
-		.procname	=3D "ipv4",
-		.mode		=3D 0555,
-		.child		=3D ip_conntrack_table
-	},
-	{ .ctl_name =3D 0 }
-};
-
-static ctl_table ip_conntrack_root_table[] =3D {
-	{
-		.ctl_name	=3D CTL_NET,
-		.procname	=3D "net",
-		.mode		=3D 0555,
-		.child		=3D ip_conntrack_dir_table
-	},
-	{ .ctl_name =3D 0 }
-};
-#endif /*CONFIG_SYSCTL*/
-
 static int kill_all(const struct ip_conntrack *i, void *data)
 {
 	return 1;
@@ -1373,9 +1334,6 @@
    supposed to kill the mall. */
 void ip_conntrack_cleanup(void)
 {
-#ifdef CONFIG_SYSCTL
-	unregister_sysctl_table(ip_conntrack_sysctl_header);
-#endif
 	ip_ct_attach =3D NULL;
 	/* This makes sure all current packets have passed through
            netfilter framework.  Roll on, two-stage module
@@ -1453,25 +1411,10 @@
 	for (i =3D 0; i < ip_conntrack_htable_size; i++)
 		INIT_LIST_HEAD(&ip_conntrack_hash[i]);
=20
-/* This is fucking braindead.  There is NO WAY of doing this without
-   the CONFIG_SYSCTL unless you don't want to detect errors.
-   Grrr... --RR */
-#ifdef CONFIG_SYSCTL
-	ip_conntrack_sysctl_header
-		=3D register_sysctl_table(ip_conntrack_root_table, 0);
-	if (ip_conntrack_sysctl_header =3D=3D NULL) {
-		goto err_free_ct_cachep;
-	}
-#endif /*CONFIG_SYSCTL*/
-
 	/* For use by ipt_REJECT */
 	ip_ct_attach =3D ip_conntrack_attach;
 	return ret;
=20
-#ifdef CONFIG_SYSCTL
-err_free_ct_cachep:
-	kmem_cache_destroy(ip_conntrack_cachep);
-#endif /*CONFIG_SYSCTL*/
 err_free_hash:
 	vfree(ip_conntrack_hash);
 err_unreg_sockopt:
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.0-test6-plain/net/ipv4/ne=
tfilter/ip_conntrack_proto_generic.c linux-2.6.0-test6-ctsysctl/net/ipv4/ne=
tfilter/ip_conntrack_proto_generic.c
--- linux-2.6.0-test6-plain/net/ipv4/netfilter/ip_conntrack_proto_generic.c=
	2003-09-28 02:50:15.000000000 +0200
+++ linux-2.6.0-test6-ctsysctl/net/ipv4/netfilter/ip_conntrack_proto_generi=
c.c	2003-10-02 17:15:26.000000000 +0200
@@ -4,7 +4,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
=20
-#define GENERIC_TIMEOUT (600*HZ)
+unsigned long ip_ct_generic_timeout =3D 600*HZ;
=20
 static int generic_pkt_to_tuple(const struct sk_buff *skb,
 				unsigned int dataoff,
@@ -44,7 +44,7 @@
 		  const struct sk_buff *skb,
 		  enum ip_conntrack_info conntrackinfo)
 {
-	ip_ct_refresh(conntrack, GENERIC_TIMEOUT);
+	ip_ct_refresh(conntrack, ip_ct_generic_timeout);
 	return NF_ACCEPT;
 }
=20
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.0-test6-plain/net/ipv4/ne=
tfilter/ip_conntrack_proto_icmp.c linux-2.6.0-test6-ctsysctl/net/ipv4/netfi=
lter/ip_conntrack_proto_icmp.c
--- linux-2.6.0-test6-plain/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	20=
03-09-28 02:50:06.000000000 +0200
+++ linux-2.6.0-test6-ctsysctl/net/ipv4/netfilter/ip_conntrack_proto_icmp.c=
	2003-10-02 17:15:26.000000000 +0200
@@ -6,7 +6,7 @@
 #include <linux/icmp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
=20
-#define ICMP_TIMEOUT (30*HZ)
+unsigned long ip_ct_icmp_timeout =3D 30*HZ;
=20
 #if 0
 #define DEBUGP printk
@@ -86,7 +86,7 @@
 			ct->timeout.function((unsigned long)ct);
 	} else {
 		atomic_inc(&ct->proto.icmp.count);
-		ip_ct_refresh(ct, ICMP_TIMEOUT);
+		ip_ct_refresh(ct, ip_ct_icmp_timeout);
 	}
=20
 	return NF_ACCEPT;
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.0-test6-plain/net/ipv4/ne=
tfilter/ip_conntrack_proto_tcp.c linux-2.6.0-test6-ctsysctl/net/ipv4/netfil=
ter/ip_conntrack_proto_tcp.c
--- linux-2.6.0-test6-plain/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	200=
3-09-28 02:51:15.000000000 +0200
+++ linux-2.6.0-test6-ctsysctl/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	=
2003-10-02 17:15:26.000000000 +0200
@@ -49,20 +49,28 @@
 #define HOURS * 60 MINS
 #define DAYS * 24 HOURS
=20
-
-static unsigned long tcp_timeouts[]
-=3D { 30 MINS, 	/*	TCP_CONNTRACK_NONE,	*/
-    5 DAYS,	/*	TCP_CONNTRACK_ESTABLISHED,	*/
-    2 MINS,	/*	TCP_CONNTRACK_SYN_SENT,	*/
-    60 SECS,	/*	TCP_CONNTRACK_SYN_RECV,	*/
-    2 MINS,	/*	TCP_CONNTRACK_FIN_WAIT,	*/
-    2 MINS,	/*	TCP_CONNTRACK_TIME_WAIT,	*/
-    10 SECS,	/*	TCP_CONNTRACK_CLOSE,	*/
-    60 SECS,	/*	TCP_CONNTRACK_CLOSE_WAIT,	*/
-    30 SECS,	/*	TCP_CONNTRACK_LAST_ACK,	*/
-    2 MINS,	/*	TCP_CONNTRACK_LISTEN,	*/
-};
-
+unsigned long ip_ct_tcp_timeout_syn_sent =3D      2 MINS;
+unsigned long ip_ct_tcp_timeout_syn_recv =3D     60 SECS;
+unsigned long ip_ct_tcp_timeout_established =3D   5 DAYS;
+unsigned long ip_ct_tcp_timeout_fin_wait =3D      2 MINS;
+unsigned long ip_ct_tcp_timeout_close_wait =3D    3 DAYS;
+unsigned long ip_ct_tcp_timeout_last_ack =3D     30 SECS;
+unsigned long ip_ct_tcp_timeout_time_wait =3D     2 MINS;
+unsigned long ip_ct_tcp_timeout_close =3D        10 SECS;
+
+static unsigned long * tcp_timeouts[]
+=3D { 0,                                 /*      TCP_CONNTRACK_NONE */
+    &ip_ct_tcp_timeout_established,    /*      TCP_CONNTRACK_ESTABLISHED, =
     */
+    &ip_ct_tcp_timeout_syn_sent,       /*      TCP_CONNTRACK_SYN_SENT, */
+    &ip_ct_tcp_timeout_syn_recv,       /*      TCP_CONNTRACK_SYN_RECV, */
+    &ip_ct_tcp_timeout_fin_wait,       /*      TCP_CONNTRACK_FIN_WAIT, */
+    &ip_ct_tcp_timeout_time_wait,      /*      TCP_CONNTRACK_TIME_WAIT,   =
     */
+    &ip_ct_tcp_timeout_close,          /*      TCP_CONNTRACK_CLOSE,    */
+    &ip_ct_tcp_timeout_close_wait,     /*      TCP_CONNTRACK_CLOSE_WAIT,  =
     */
+    &ip_ct_tcp_timeout_last_ack,       /*      TCP_CONNTRACK_LAST_ACK, */
+    0,                                 /*      TCP_CONNTRACK_LISTEN */
+ };
+=20
 #define sNO TCP_CONNTRACK_NONE
 #define sES TCP_CONNTRACK_ESTABLISHED
 #define sSS TCP_CONNTRACK_SYN_SENT
@@ -204,7 +212,7 @@
 			set_bit(IPS_ASSURED_BIT, &conntrack->status);
=20
 		WRITE_UNLOCK(&tcp_lock);
-		ip_ct_refresh(conntrack, tcp_timeouts[newconntrack]);
+		ip_ct_refresh(conntrack, *tcp_timeouts[newconntrack]);
 	}
=20
 	return NF_ACCEPT;
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.0-test6-plain/net/ipv4/ne=
tfilter/ip_conntrack_proto_udp.c linux-2.6.0-test6-ctsysctl/net/ipv4/netfil=
ter/ip_conntrack_proto_udp.c
--- linux-2.6.0-test6-plain/net/ipv4/netfilter/ip_conntrack_proto_udp.c	200=
3-09-28 02:50:05.000000000 +0200
+++ linux-2.6.0-test6-ctsysctl/net/ipv4/netfilter/ip_conntrack_proto_udp.c	=
2003-10-02 17:15:26.000000000 +0200
@@ -6,8 +6,8 @@
 #include <linux/udp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
=20
-#define UDP_TIMEOUT (30*HZ)
-#define UDP_STREAM_TIMEOUT (180*HZ)
+unsigned long ip_ct_udp_timeout =3D 30*HZ;
+unsigned long ip_ct_udp_timeout_stream =3D 180*HZ;
=20
 static int udp_pkt_to_tuple(const struct sk_buff *skb,
 			     unsigned int dataoff,
@@ -57,11 +57,11 @@
 	/* If we've seen traffic both ways, this is some kind of UDP
 	   stream.  Extend timeout. */
 	if (test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
-		ip_ct_refresh(conntrack, UDP_STREAM_TIMEOUT);
+		ip_ct_refresh(conntrack, ip_ct_udp_timeout_stream);
 		/* Also, more likely to be important, and not a probe */
 		set_bit(IPS_ASSURED_BIT, &conntrack->status);
 	} else
-		ip_ct_refresh(conntrack, UDP_TIMEOUT);
+		ip_ct_refresh(conntrack, ip_ct_udp_timeout);
=20
 	return NF_ACCEPT;
 }
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.0-test6-plain/net/ipv4/ne=
tfilter/ip_conntrack_standalone.c linux-2.6.0-test6-ctsysctl/net/ipv4/netfi=
lter/ip_conntrack_standalone.c
--- linux-2.6.0-test6-plain/net/ipv4/netfilter/ip_conntrack_standalone.c	20=
03-09-28 02:50:18.000000000 +0200
+++ linux-2.6.0-test6-ctsysctl/net/ipv4/netfilter/ip_conntrack_standalone.c=
	2003-10-02 17:17:46.000000000 +0200
@@ -7,6 +7,7 @@
 /* (c) 1999 Paul `Rusty' Russell.  Licenced under the GNU General
    Public Licence. */
=20
+#include <linux/config.h>
 #include <linux/types.h>
 #include <linux/ip.h>
 #include <linux/netfilter.h>
@@ -14,6 +15,9 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/proc_fs.h>
+#ifdef CONFIG_SYSCTL
+#include <linux/sysctl.h>
+#endif
 #include <net/checksum.h>
=20
 #define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_conntrack_lock)
@@ -256,6 +260,98 @@
 	.priority	=3D NF_IP_PRI_LAST-1,
 };
=20
+/* Sysctl support */
+
+#ifdef CONFIG_SYSCTL
+
+/* From ip_conntrack_core.c */
+extern int ip_conntrack_max;
+
+/* From ip_conntrack_proto_tcp.c */
+extern unsigned long ip_ct_tcp_timeout_syn_sent;
+extern unsigned long ip_ct_tcp_timeout_syn_recv;
+extern unsigned long ip_ct_tcp_timeout_established;
+extern unsigned long ip_ct_tcp_timeout_fin_wait;
+extern unsigned long ip_ct_tcp_timeout_close_wait;
+extern unsigned long ip_ct_tcp_timeout_last_ack;
+extern unsigned long ip_ct_tcp_timeout_time_wait;
+extern unsigned long ip_ct_tcp_timeout_close;
+
+/* From ip_conntrack_proto_udp.c */
+extern unsigned long ip_ct_udp_timeout;
+extern unsigned long ip_ct_udp_timeout_stream;
+
+/* From ip_conntrack_proto_icmp.c */
+extern unsigned long ip_ct_icmp_timeout;
+
+/* From ip_conntrack_proto_icmp.c */
+extern unsigned long ip_ct_generic_timeout;
+
+static struct ctl_table_header *ip_ct_sysctl_header;
+
+static ctl_table ip_ct_sysctl_table[] =3D {
+	{NET_IPV4_NF_CONNTRACK_MAX, "ip_conntrack_max",
+	 &ip_conntrack_max, sizeof(int), 0644, NULL,
+	 &proc_dointvec},
+	{NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_SYN_SENT, "ip_conntrack_tcp_timeout_sy=
n_sent",
+	 &ip_ct_tcp_timeout_syn_sent, sizeof(unsigned int), 0644, NULL,
+	 &proc_dointvec_jiffies},
+	{NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_SYN_RECV, "ip_conntrack_tcp_timeout_sy=
n_recv",
+	 &ip_ct_tcp_timeout_syn_recv, sizeof(unsigned int), 0644, NULL,
+	 &proc_dointvec_jiffies},
+	{NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_ESTABLISHED, "ip_conntrack_tcp_timeout=
_established",
+	 &ip_ct_tcp_timeout_established, sizeof(unsigned int), 0644, NULL,
+	 &proc_dointvec_jiffies},
+	{NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_FIN_WAIT, "ip_conntrack_tcp_timeout_fi=
n_wait",
+	 &ip_ct_tcp_timeout_fin_wait, sizeof(unsigned int), 0644, NULL,
+	 &proc_dointvec_jiffies},
+	{NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_CLOSE_WAIT, "ip_conntrack_tcp_timeout_=
close_wait",
+	 &ip_ct_tcp_timeout_close_wait, sizeof(unsigned int), 0644, NULL,
+	 &proc_dointvec_jiffies},
+	{NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_LAST_ACK, "ip_conntrack_tcp_timeout_la=
st_ack",
+	 &ip_ct_tcp_timeout_last_ack, sizeof(unsigned int), 0644, NULL,
+	 &proc_dointvec_jiffies},
+	{NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_TIME_WAIT, "ip_conntrack_tcp_timeout_t=
ime_wait",
+	 &ip_ct_tcp_timeout_time_wait, sizeof(unsigned int), 0644, NULL,
+	 &proc_dointvec_jiffies},
+	{NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_CLOSE, "ip_conntrack_tcp_timeout_close=
",
+	 &ip_ct_tcp_timeout_close, sizeof(unsigned int), 0644, NULL,
+	 &proc_dointvec_jiffies},
+	{NET_IPV4_NF_CONNTRACK_UDP_TIMEOUT, "ip_conntrack_udp_timeout",
+	 &ip_ct_udp_timeout, sizeof(unsigned int), 0644, NULL,
+	 &proc_dointvec_jiffies},
+	{NET_IPV4_NF_CONNTRACK_UDP_TIMEOUT_STREAM, "ip_conntrack_udp_timeout_stre=
am",
+	 &ip_ct_udp_timeout_stream, sizeof(unsigned int), 0644, NULL,
+	 &proc_dointvec_jiffies},
+	{NET_IPV4_NF_CONNTRACK_ICMP_TIMEOUT, "ip_conntrack_icmp_timeout",
+	 &ip_ct_icmp_timeout, sizeof(unsigned int), 0644, NULL,
+	 &proc_dointvec_jiffies},
+	{NET_IPV4_NF_CONNTRACK_GENERIC_TIMEOUT, "ip_conntrack_generic_timeout",
+	 &ip_ct_generic_timeout, sizeof(unsigned int), 0644, NULL,
+	 &proc_dointvec_jiffies},
+	{0}
+};
+
+#define NET_IP_CONNTRACK_MAX 2089
+
+static ctl_table ip_ct_netfilter_table[] =3D {
+	{NET_IPV4_NETFILTER, "netfilter", NULL, 0, 0555, ip_ct_sysctl_table, 0, 0=
, 0, 0, 0},
+	{NET_IP_CONNTRACK_MAX, "ip_conntrack_max",
+	 &ip_conntrack_max, sizeof(int), 0644, NULL,
+	 &proc_dointvec},
+	{0}
+};
+
+static ctl_table ip_ct_ipv4_table[] =3D {
+	{NET_IPV4, "ipv4", NULL, 0, 0555, ip_ct_netfilter_table, 0, 0, 0, 0, 0},
+	{0}
+};
+
+static ctl_table ip_ct_net_table[] =3D {
+	{CTL_NET, "net", NULL, 0, 0555, ip_ct_ipv4_table, 0, 0, 0, 0, 0},
+	{0}
+};
+#endif
 static int init_or_cleanup(int init)
 {
 	struct proc_dir_entry *proc;
@@ -291,10 +387,20 @@
 		printk("ip_conntrack: can't register local in hook.\n");
 		goto cleanup_inoutandlocalops;
 	}
+#ifdef CONFIG_SYSCTL
+	ip_ct_sysctl_header =3D register_sysctl_table(ip_ct_net_table, 0);
+	if (ip_ct_sysctl_header =3D=3D NULL) {
+		printk("ip_conntrack: can't register to sysctl.\n");
+		goto cleanup;
+	}
+#endif
=20
 	return ret;
=20
  cleanup:
+#ifdef CONFIG_SYSCTL
+ 	unregister_sysctl_table(ip_ct_sysctl_header);
+#endif
 	nf_unregister_hook(&ip_conntrack_local_in_ops);
  cleanup_inoutandlocalops:
 	nf_unregister_hook(&ip_conntrack_out_ops);

--cVfNNm8lVSmMpOo9--

--/whNdqcA90P4aItJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fE3EXaXGVTD0i/8RAsG5AJ9VeDYNEvob84q/SQzROiE2ElIzygCfWRbQ
msBx4N/+fGzcegtIXldR8b4=
=2gYL
-----END PGP SIGNATURE-----

--/whNdqcA90P4aItJ--
