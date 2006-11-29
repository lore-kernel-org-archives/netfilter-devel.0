From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 16/33]: nf_conntrack: sysctl compatibility with old
	connection tracking
Date: Wed, 29 Nov 2006 03:09:08 +0100 (MET)
Message-ID: <20061129020908.21082.50849.sendpatchset@localhost.localdomain>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_conntrack: sysctl compatibility with old connection tracking

This patch adds an option to keep the connection tracking sysctls visible
under their old names.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit acba3b4bada973eb5697d29accdd3dd734990019
tree 84fbdb635f018df25d304745513cee3903659cc3
parent bcd8d5a98d1a3c257d15c1cfa038aa0bf0e0ea44
author Patrick McHardy <kaber@trash.net> Tue, 28 Nov 2006 23:13:24 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 29 Nov 2006 02:13:33 +0100

 include/net/netfilter/nf_conntrack_l4proto.h   |    6 +
 net/ipv4/netfilter/Kconfig                     |   11 ++
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   58 +++++++++++++
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   18 ++++
 net/netfilter/nf_conntrack_core.c              |    2 
 net/netfilter/nf_conntrack_proto.c             |   20 ++++
 net/netfilter/nf_conntrack_proto_generic.c     |   18 ++++
 net/netfilter/nf_conntrack_proto_sctp.c        |   67 +++++++++++++++
 net/netfilter/nf_conntrack_proto_tcp.c         |  107 ++++++++++++++++++++++++
 net/netfilter/nf_conntrack_proto_udp.c         |   26 ++++++
 10 files changed, 332 insertions(+), 1 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index fe1e8fa..fc8af08 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -80,7 +80,11 @@ #ifdef CONFIG_SYSCTL
 	struct ctl_table_header	**ctl_table_header;
 	struct ctl_table	*ctl_table;
 	unsigned int		*ctl_table_users;
-#endif /* CONFIG_SYSCTL */
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+	struct ctl_table_header	*ctl_compat_table_header;
+	struct ctl_table	*ctl_compat_table;
+#endif
+#endif
 
 	/* Module (if any) which this is connected to. */
 	struct module *me;
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index d88c292..4ac5b5c 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -19,6 +19,17 @@ config NF_CONNTRACK_IPV4
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NF_CONNTRACK_PROC_COMPAT
+	bool "proc/sysctl compatibility with old connection tracking"
+	depends on NF_CONNTRACK
+	default y
+	help
+	  This option enables /proc and sysctl compatibility with the old
+	  layer 3 dependant connection tracking. This is needed to keep
+	  old programs that have not been adapted to the new names working.
+
+	  If unsure, say Y.
+
 # connection tracking, helpers and protocols
 config IP_NF_CONNTRACK
 	tristate "Connection tracking (required for masq/NAT)"
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 786c4ce..bcec682 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -266,6 +266,60 @@ static struct nf_hook_ops ipv4_conntrack
 	},
 };
 
+#if defined(CONFIG_SYSCTL) && defined(CONFIG_NF_CONNTRACK_PROC_COMPAT)
+static int log_invalid_proto_min = 0;
+static int log_invalid_proto_max = 255;
+
+static ctl_table ip_ct_sysctl_table[] = {
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_MAX,
+		.procname	= "ip_conntrack_max",
+		.data		= &nf_conntrack_max,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_COUNT,
+		.procname	= "ip_conntrack_count",
+		.data		= &nf_conntrack_count,
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_BUCKETS,
+		.procname	= "ip_conntrack_buckets",
+		.data		= &nf_conntrack_htable_size,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0444,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_CHECKSUM,
+		.procname	= "ip_conntrack_checksum",
+		.data		= &nf_conntrack_checksum,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_LOG_INVALID,
+		.procname	= "ip_conntrack_log_invalid",
+		.data		= &nf_ct_log_invalid,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &log_invalid_proto_min,
+		.extra2		= &log_invalid_proto_max,
+	},
+	{
+		.ctl_name	= 0
+	}
+};
+#endif /* CONFIG_SYSCTL && CONFIG_NF_CONNTRACK_PROC_COMPAT */
+
 /* Fast function for those who don't want to parse /proc (and I don't
    blame them). */
 /* Reversing the socket's dst/src point of view gives us the reply
@@ -386,6 +440,10 @@ #if defined(CONFIG_NF_CT_NETLINK) || \
 	.tuple_to_nfattr = ipv4_tuple_to_nfattr,
 	.nfattr_to_tuple = ipv4_nfattr_to_tuple,
 #endif
+#if defined(CONFIG_SYSCTL) && defined(CONFIG_NF_CONNTRACK_PROC_COMPAT)
+	.ctl_table_path  = nf_net_ipv4_netfilter_sysctl_path,
+	.ctl_table	 = ip_ct_sysctl_table,
+#endif
 	.me		 = THIS_MODULE,
 };
 
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index c59f281..46aa44a 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -336,6 +336,21 @@ static struct ctl_table icmp_sysctl_tabl
 		.ctl_name = 0
 	}
 };
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+static struct ctl_table icmp_compat_sysctl_table[] = {
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_ICMP_TIMEOUT,
+		.procname	= "ip_conntrack_icmp_timeout",
+		.data		= &nf_ct_icmp_timeout,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+        {
+		.ctl_name = 0
+	}
+};
+#endif /* CONFIG_NF_CONNTRACK_PROC_COMPAT */
 #endif /* CONFIG_SYSCTL */
 
 struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp =
@@ -360,6 +375,9 @@ #endif
 #ifdef CONFIG_SYSCTL
 	.ctl_table_header	= &icmp_sysctl_header,
 	.ctl_table		= icmp_sysctl_table,
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+	.ctl_compat_table	= icmp_compat_sysctl_table,
+#endif
 #endif
 };
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 4b97279..a672806 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -66,10 +66,12 @@ DEFINE_RWLOCK(nf_conntrack_lock);
 
 /* nf_conntrack_standalone needs this */
 atomic_t nf_conntrack_count = ATOMIC_INIT(0);
+EXPORT_SYMBOL_GPL(nf_conntrack_count);
 
 void (*nf_conntrack_destroyed)(struct nf_conn *conntrack) = NULL;
 unsigned int nf_conntrack_htable_size __read_mostly;
 int nf_conntrack_max __read_mostly;
+EXPORT_SYMBOL_GPL(nf_conntrack_max);
 struct list_head *nf_conntrack_hash __read_mostly;
 struct nf_conn nf_conntrack_untracked __read_mostly;
 unsigned int nf_ct_log_invalid __read_mostly;
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 891c9c5..4798afc 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -250,7 +250,22 @@ #ifdef CONFIG_SYSCTL
 					    nf_net_netfilter_sysctl_path,
 					    l4proto->ctl_table,
 					    l4proto->ctl_table_users);
+		if (err < 0)
+			goto out;
 	}
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+	if (l4proto->ctl_compat_table != NULL) {
+		err = nf_ct_register_sysctl(&l4proto->ctl_compat_table_header,
+					    nf_net_ipv4_netfilter_sysctl_path,
+					    l4proto->ctl_compat_table, NULL);
+		if (err == 0)
+			goto out;
+		nf_ct_unregister_sysctl(l4proto->ctl_table_header,
+					l4proto->ctl_table,
+					l4proto->ctl_table_users);
+	}
+#endif /* CONFIG_NF_CONNTRACK_PROC_COMPAT */
+out:
 	mutex_unlock(&nf_ct_proto_sysctl_mutex);
 #endif /* CONFIG_SYSCTL */
 	return err;
@@ -265,6 +280,11 @@ #ifdef CONFIG_SYSCTL
 		nf_ct_unregister_sysctl(l4proto->ctl_table_header,
 					l4proto->ctl_table,
 					l4proto->ctl_table_users);
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+	if (l4proto->ctl_compat_table_header != NULL)
+		nf_ct_unregister_sysctl(&l4proto->ctl_compat_table_header,
+					l4proto->ctl_compat_table, NULL);
+#endif /* CONFIG_NF_CONNTRACK_PROC_COMPAT */
 	mutex_unlock(&nf_ct_proto_sysctl_mutex);
 #endif /* CONFIG_SYSCTL */
 }
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index 15306b9..6990253 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -86,6 +86,21 @@ static struct ctl_table generic_sysctl_t
 		.ctl_name	= 0
 	}
 };
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+static struct ctl_table generic_compat_sysctl_table[] = {
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_GENERIC_TIMEOUT,
+		.procname	= "ip_conntrack_generic_timeout",
+		.data		= &nf_ct_generic_timeout,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= 0
+	}
+};
+#endif /* CONFIG_NF_CONNTRACK_PROC_COMPAT */
 #endif /* CONFIG_SYSCTL */
 
 struct nf_conntrack_l4proto nf_conntrack_l4proto_generic =
@@ -102,5 +117,8 @@ struct nf_conntrack_l4proto nf_conntrack
 #ifdef CONFIG_SYSCTL
 	.ctl_table_header	= &generic_sysctl_header,
 	.ctl_table		= generic_sysctl_table,
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+	.ctl_compat_table	= generic_compat_sysctl_table,
+#endif
 #endif
 };
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index cc69330..7c64b9c 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -573,6 +573,70 @@ static struct ctl_table sctp_sysctl_tabl
 		.ctl_name = 0
 	}
 };
+
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+static struct ctl_table sctp_compat_sysctl_table[] = {
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_CLOSED,
+		.procname	= "ip_conntrack_sctp_timeout_closed",
+		.data		= &nf_ct_sctp_timeout_closed,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_COOKIE_WAIT,
+		.procname	= "ip_conntrack_sctp_timeout_cookie_wait",
+		.data		= &nf_ct_sctp_timeout_cookie_wait,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_COOKIE_ECHOED,
+		.procname	= "ip_conntrack_sctp_timeout_cookie_echoed",
+		.data		= &nf_ct_sctp_timeout_cookie_echoed,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_ESTABLISHED,
+		.procname	= "ip_conntrack_sctp_timeout_established",
+		.data		= &nf_ct_sctp_timeout_established,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_SENT,
+		.procname	= "ip_conntrack_sctp_timeout_shutdown_sent",
+		.data		= &nf_ct_sctp_timeout_shutdown_sent,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_RECD,
+		.procname	= "ip_conntrack_sctp_timeout_shutdown_recd",
+		.data		= &nf_ct_sctp_timeout_shutdown_recd,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_ACK_SENT,
+		.procname	= "ip_conntrack_sctp_timeout_shutdown_ack_sent",
+		.data		= &nf_ct_sctp_timeout_shutdown_ack_sent,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name = 0
+	}
+};
+#endif /* CONFIG_NF_CONNTRACK_PROC_COMPAT */
 #endif
 
 struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4 = {
@@ -590,6 +654,9 @@ #ifdef CONFIG_SYSCTL
 	.ctl_table_users	= &sctp_sysctl_table_users,
 	.ctl_table_header	= &sctp_sysctl_header,
 	.ctl_table		= sctp_sysctl_table,
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+	.ctl_compat_table	= sctp_compat_sysctl_table,
+#endif
 #endif
 };
 
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 6f6f9a0..d99c7c4 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1273,6 +1273,110 @@ static struct ctl_table tcp_sysctl_table
 		.ctl_name	= 0
 	}
 };
+
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+static struct ctl_table tcp_compat_sysctl_table[] = {
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_SYN_SENT,
+		.procname	= "ip_conntrack_tcp_timeout_syn_sent",
+		.data		= &nf_ct_tcp_timeout_syn_sent,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_SYN_RECV,
+		.procname	= "ip_conntrack_tcp_timeout_syn_recv",
+		.data		= &nf_ct_tcp_timeout_syn_recv,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_ESTABLISHED,
+		.procname	= "ip_conntrack_tcp_timeout_established",
+		.data		= &nf_ct_tcp_timeout_established,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_FIN_WAIT,
+		.procname	= "ip_conntrack_tcp_timeout_fin_wait",
+		.data		= &nf_ct_tcp_timeout_fin_wait,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_CLOSE_WAIT,
+		.procname	= "ip_conntrack_tcp_timeout_close_wait",
+		.data		= &nf_ct_tcp_timeout_close_wait,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_LAST_ACK,
+		.procname	= "ip_conntrack_tcp_timeout_last_ack",
+		.data		= &nf_ct_tcp_timeout_last_ack,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_TIME_WAIT,
+		.procname	= "ip_conntrack_tcp_timeout_time_wait",
+		.data		= &nf_ct_tcp_timeout_time_wait,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_CLOSE,
+		.procname	= "ip_conntrack_tcp_timeout_close",
+		.data		= &nf_ct_tcp_timeout_close,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_MAX_RETRANS,
+		.procname	= "ip_conntrack_tcp_timeout_max_retrans",
+		.data		= &nf_ct_tcp_timeout_max_retrans,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_LOOSE,
+		.procname	= "ip_conntrack_tcp_loose",
+		.data		= &nf_ct_tcp_loose,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_BE_LIBERAL,
+		.procname	= "ip_conntrack_tcp_be_liberal",
+		.data		= &nf_ct_tcp_be_liberal,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_MAX_RETRANS,
+		.procname	= "ip_conntrack_tcp_max_retrans",
+		.data		= &nf_ct_tcp_max_retrans,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= 0
+	}
+};
+#endif /* CONFIG_NF_CONNTRACK_PROC_COMPAT */
 #endif /* CONFIG_SYSCTL */
 
 struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4 =
@@ -1298,6 +1402,9 @@ #ifdef CONFIG_SYSCTL
 	.ctl_table_users	= &tcp_sysctl_table_users,
 	.ctl_table_header	= &tcp_sysctl_header,
 	.ctl_table		= tcp_sysctl_table,
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+	.ctl_compat_table	= tcp_compat_sysctl_table,
+#endif
 #endif
 };
 
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index d86749c..908fde7 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -172,6 +172,29 @@ static struct ctl_table udp_sysctl_table
 		.ctl_name	= 0
 	}
 };
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+static struct ctl_table udp_compat_sysctl_table[] = {
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_UDP_TIMEOUT,
+		.procname	= "ip_conntrack_udp_timeout",
+		.data		= &nf_ct_udp_timeout,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_UDP_TIMEOUT_STREAM,
+		.procname	= "ip_conntrack_udp_timeout_stream",
+		.data		= &nf_ct_udp_timeout_stream,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= 0
+	}
+};
+#endif /* CONFIG_NF_CONNTRACK_PROC_COMPAT */
 #endif /* CONFIG_SYSCTL */
 
 struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4 =
@@ -195,6 +218,9 @@ #ifdef CONFIG_SYSCTL
 	.ctl_table_users	= &udp_sysctl_table_users,
 	.ctl_table_header	= &udp_sysctl_header,
 	.ctl_table		= udp_sysctl_table,
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+	.ctl_compat_table	= udp_compat_sysctl_table,
+#endif
 #endif
 };
 
