From: Kiran Kumar Immidi <immidi@spymac.com>
Subject: Re: sctp conntrack
Date: Tue, 27 Jul 2004 13:48:34 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200407271348.34615.immidi@spymac.com>
References: <20040722191649.GJ14946@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_a/gBBUHsn8vLOC4"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040722191649.GJ14946@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Boundary-00=_a/gBBUHsn8vLOC4
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 23 July 2004 12:46 am, Harald Welte wrote:

> I was about to include the SCTP conntrack patch into my set of pending
> patches for 2.6.9 but then discovered that you don't export the timeouts
> via /proc (similar to what recent versions of ip_conntrack_tcp do).
>
> Would you please include suport for /proc tuning of the timeouts and
> submit a patch against current CVS?

  The attached patch adds this support. It is a diff against current cvs pom 
sctp-conntrack-nat module, the following doubt remains:

- The type of these timeouts in case of TCP is unsigned long, though the code 
in ip_conntrack_standalone.c treats them as unsigned int. I am not sure of 
the working, but I suspect something wrong here. I have followed the same 
pattern however.

Regards,
Kiran Kumar Immidi

--Boundary-00=_a/gBBUHsn8vLOC4
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="sctp_timeout.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="sctp_timeout.diff"

Index: linux.patch
===================================================================
RCS file: /cvspublic/patch-o-matic-ng/sctp-conntrack-nat/linux.patch,v
retrieving revision 1.1
diff -u -r1.1 linux.patch
--- linux.patch	10 Apr 2004 15:52:01 -0000	1.1
+++ linux.patch	27 Jul 2004 05:48:13 -0000
@@ -1,6 +1,6 @@
-diff -ru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.4/include/linux/netfilter_ipv4/ip_conntrack_tuple.h tp/linux-2.6.4/include/linux/netfilter_ipv4/ip_conntrack_tuple.h
---- linux-2.6.4/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	2004-01-09 12:29:48.000000000 +0530
-+++ tp/linux-2.6.4/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	2004-04-14 15:33:18.000000000 +0530
+diff -ru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.6.orig/include/linux/netfilter_ipv4/ip_conntrack_tuple.h linux-2.6.6/include/linux/netfilter_ipv4/ip_conntrack_tuple.h
+--- linux-2.6.6.orig/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	2004-01-09 12:29:48.000000000 +0530
++++ linux-2.6.6/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	2004-04-14 15:33:18.000000000 +0530
 @@ -25,6 +25,9 @@
  	struct {
  		u_int16_t id;
@@ -21,3 +21,19 @@
  		} u;
  
  		/* The protocol. */
+--- linux-2.6.6.orig/include/linux/sysctl.h    2004-07-27 04:16:46.000000000 +0530
++++ linux-2.6.6/include/linux/sysctl.h      2004-07-27 06:20:48.333196352 +0530
+@@ -406,6 +406,13 @@
+	NET_IPV4_NF_CONNTRACK_ICMP_TIMEOUT=12,
+	NET_IPV4_NF_CONNTRACK_GENERIC_TIMEOUT=13,
+	NET_IPV4_NF_CONNTRACK_BUCKETS=14,
++	NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_CLOSED=15,
++	NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_COOKIE_WAIT=16,
++	NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_COOKIE_ECHOED=17,
++	NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_ESTABLISHED=18,
++	NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_SENT=19,
++	NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_RECD=20,
++	NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_ACK_SENT=21,
+ };
+
+ /* /proc/sys/net/ipv6 */
Index: linux/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
===================================================================
RCS file: /cvspublic/patch-o-matic-ng/sctp-conntrack-nat/linux/net/ipv4/netfilter/ip_conntrack_proto_sctp.c,v
retrieving revision 1.1
diff -u -r1.1 ip_conntrack_proto_sctp.c
--- linux/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	10 Apr 2004 15:52:01 -0000	1.1
+++ linux/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	27 Jul 2004 05:48:14 -0000
@@ -9,6 +9,10 @@
  * published by the Free Software Foundation.
  */
 
+/*
+ * Added support for proc manipulation of timeouts.
+ */
+
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/timer.h>
@@ -505,11 +509,125 @@
 	.me 		 = THIS_MODULE 
 };
 
+#ifdef CONFIG_SYSCTL
+static ctl_table ip_ct_sysctl_table[] = {
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_CLOSED,
+		.procname	= "ip_conntrack_sctp_timeout_closed",
+		.data		= &ip_ct_sctp_timeout_closed,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_COOKIE_WAIT,
+		.procname	= "ip_conntrack_sctp_timeout_cookie_wait",
+		.data		= &ip_ct_sctp_timeout_cookie_wait,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_COOKIE_ECHOED,
+		.procname	= "ip_conntrack_sctp_timeout_cookie_echoed",
+		.data		= &ip_ct_sctp_timeout_cookie_echoed,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_ESTABLISHED,
+		.procname	= "ip_conntrack_sctp_timeout_established",
+		.data		= &ip_ct_sctp_timeout_established,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_SENT,
+		.procname	= "ip_conntrack_sctp_timeout_shutdown_sent",
+		.data		= &ip_ct_sctp_timeout_shutdown_sent,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_RECD,
+		.procname	= "ip_conntrack_sctp_timeout_shutdown_recd",
+		.data		= &ip_ct_sctp_timeout_shutdown_recd,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_ACK_SENT,
+		.procname	= "ip_conntrack_sctp_timeout_shutdown_ack_sent",
+		.data		= &ip_ct_sctp_timeout_shutdown_ack_sent,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{ .ctl_name = 0 }
+};
+
+static ctl_table ip_ct_netfilter_table[] = {
+	{
+		.ctl_name	= NET_IPV4_NETFILTER,
+		.procname	= "netfilter",
+		.mode		= 0555,
+		.child		= ip_ct_sysctl_table,
+	},
+	{ .ctl_name = 0 }
+};
+
+static ctl_table ip_ct_ipv4_table[] = {
+	{
+		.ctl_name	= NET_IPV4,
+		.procname	= "ipv4",
+		.mode		= 0555,
+		.child		= ip_ct_netfilter_table,
+	},
+	{ .ctl_name = 0 }
+};
+
+static ctl_table ip_ct_net_table[] = {
+	{
+		.ctl_name	= CTL_NET,
+		.procname	= "net",
+		.mode		= 0555, 
+		.child		= ip_ct_ipv4_table,
+	},
+	{ .ctl_name = 0 }
+};
+
+static struct ctl_table_header *ip_ct_sysctl_header;
+#endif
+
 int __init init(void)
 {
 	int ret;
 
 	ret = ip_conntrack_protocol_register(&ip_conntrack_protocol_sctp);
+	if (ret) {
+		printk("ip_conntrack_proto_sctp: protocol register failed\n");
+		goto out;
+	}
+
+#ifdef CONFIG_SYSCTL
+	ip_ct_sysctl_header = register_sysctl_table(ip_ct_net_table, 0);
+	if (ip_ct_sysctl_header == NULL) {
+		printk("ip_conntrack_proto_sctp: can't register to sysctl.\n");
+		goto cleanup;
+	}
+#endif
+
+	return ret;
+
+ cleanup:
+#ifdef CONFIG_SYSCTL
+	ip_conntrack_protocol_unregister(&ip_conntrack_protocol_sctp);
+#endif
+ out:
 	DEBUGP("SCTP conntrack module loading %s\n", 
 					ret ? "failed": "succeeded");
 	return ret;
@@ -518,6 +636,9 @@
 void __exit fini(void)
 {
 	ip_conntrack_protocol_unregister(&ip_conntrack_protocol_sctp);
+#ifdef CONFIG_SYSCTL
+ 	unregister_sysctl_table(ip_ct_sysctl_header);
+#endif
 	DEBUGP("SCTP conntrack module unloaded\n");
 }
 

--Boundary-00=_a/gBBUHsn8vLOC4--
