From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 3/5] net: netfilter conntrack - add per-net functionality for TCP protocol
Date: Thu, 26 Mar 2009 19:05:47 +0300
Message-ID: <20090326160712.142181955@openvz.org>
References: <20090326160544.519118777@openvz.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
To: kaber@trash.net, netfilter-devel@vger.kernel.org, xemul@openvz.org,
	daniel.lezcano@free.fr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:19041 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688AbZCZQGm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2009 12:06:42 -0400
Received: by ey-out-2122.google.com with SMTP id 4so182858eyf.37
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2009 09:06:38 -0700 (PDT)
Content-Disposition: inline; filename=net-nf-conntrack-proto-tcp
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Module specific data moved into per-net site and being allocated/freed
during net namespace creation/deletion. For this reason module_init/exit
calls added.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c |  281 +++++++++++++++++++++++----------
 1 file changed, 203 insertions(+), 78 deletions(-)

Index: linux-2.6.git/net/netfilter/nf_conntrack_proto_tcp.c
===================================================================
--- linux-2.6.git.orig/net/netfilter/nf_conntrack_proto_tcp.c
+++ linux-2.6.git/net/netfilter/nf_conntrack_proto_tcp.c
@@ -18,6 +18,9 @@
 
 #include <net/tcp.h>
 
+#include <net/net_namespace.h>
+#include <net/netns/generic.h>
+
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
@@ -31,20 +34,6 @@
 /* Protects ct->proto.tcp */
 static DEFINE_RWLOCK(tcp_lock);
 
-/* "Be conservative in what you do,
-    be liberal in what you accept from others."
-    If it's non-zero, we mark only out of window RST segments as INVALID. */
-static int nf_ct_tcp_be_liberal __read_mostly = 0;
-
-/* If it is set to zero, we disable picking up already established
-   connections. */
-static int nf_ct_tcp_loose __read_mostly = 1;
-
-/* Max number of the retransmitted packets without receiving an (acceptable)
-   ACK from the destination. If this number is reached, a shorter timer
-   will be started. */
-static int nf_ct_tcp_max_retrans __read_mostly = 3;
-
   /* FIXME: Examine ipfilter's timeouts and conntrack transitions more
      closely.  They're more complex. --RR */
 
@@ -66,23 +55,6 @@ static const char *const tcp_conntrack_n
 #define HOURS * 60 MINS
 #define DAYS * 24 HOURS
 
-/* RFC1122 says the R2 limit should be at least 100 seconds.
-   Linux uses 15 packets as limit, which corresponds
-   to ~13-30min depending on RTO. */
-static unsigned int nf_ct_tcp_timeout_max_retrans __read_mostly    =   5 MINS;
-static unsigned int nf_ct_tcp_timeout_unacknowledged __read_mostly =   5 MINS;
-
-static unsigned int tcp_timeouts[TCP_CONNTRACK_MAX] __read_mostly = {
-	[TCP_CONNTRACK_SYN_SENT]	= 2 MINS,
-	[TCP_CONNTRACK_SYN_RECV]	= 60 SECS,
-	[TCP_CONNTRACK_ESTABLISHED]	= 5 DAYS,
-	[TCP_CONNTRACK_FIN_WAIT]	= 2 MINS,
-	[TCP_CONNTRACK_CLOSE_WAIT]	= 60 SECS,
-	[TCP_CONNTRACK_LAST_ACK]	= 30 SECS,
-	[TCP_CONNTRACK_TIME_WAIT]	= 2 MINS,
-	[TCP_CONNTRACK_CLOSE]		= 10 SECS,
-};
-
 #define sNO TCP_CONNTRACK_NONE
 #define sSS TCP_CONNTRACK_SYN_SENT
 #define sSR TCP_CONNTRACK_SYN_RECV
@@ -260,6 +232,51 @@ static const u8 tcp_conntracks[2][6][TCP
 	}
 };
 
+/* per-net specifics */
+static int tcp_net_id;
+struct tcp_net {
+	/*
+	 * "Be conservative in what you do,
+	 * be liberal in what you accept from others."
+	 * If it's non-zero, we mark only out of window
+	 * RST segments as INVALID.
+	 */
+	int tcp_be_liberal;
+	/*
+	 * If it is set to zero, we disable picking up
+	 * already established connections.
+	 */
+	int tcp_loose;
+	/*
+	 * Max number of the retransmitted packets without
+	 * receiving an (acceptable) ACK from the destination.
+	 * If this number is reached, a shorter timer will be started.
+	 */
+	int tcp_max_retrans;
+	/*
+	 * RFC1122 says the R2 limit should be at least 100 seconds.
+	 * Linux uses 15 packets as limit, which corresponds
+	 * to ~13-30min depending on RTO.
+	 */
+	unsigned int tcp_timeout_max_retrans;
+	unsigned int tcp_timeout_unacknowledged;
+
+	unsigned int tcp_timeouts[TCP_CONNTRACK_MAX];
+#ifdef CONFIG_SYSCTL
+	struct ctl_table_header *sysctl_header;
+	struct ctl_table *sysctl_table;
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+	struct ctl_table_header *compat_sysctl_header;
+	struct ctl_table *compat_sysctl_table;
+#endif
+#endif
+};
+
+static inline struct tcp_net *tcp_pernet(struct net *net)
+{
+	return net_generic(net, tcp_net_id);
+}
+
 static bool tcp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
 			     struct nf_conntrack_tuple *tuple)
 {
@@ -491,6 +508,7 @@ static bool tcp_in_window(const struct n
 			  u_int8_t pf)
 {
 	struct net *net = nf_ct_net(ct);
+	struct tcp_net *tn;
 	struct ip_ct_tcp_state *sender = &state->seen[dir];
 	struct ip_ct_tcp_state *receiver = &state->seen[!dir];
 	const struct nf_conntrack_tuple *tuple = &ct->tuplehash[dir].tuple;
@@ -668,8 +686,9 @@ static bool tcp_in_window(const struct n
 		res = true;
 	} else {
 		res = false;
+		tn = tcp_pernet(net);
 		if (sender->flags & IP_CT_TCP_FLAG_BE_LIBERAL ||
-		    nf_ct_tcp_be_liberal)
+		    tn->tcp_be_liberal)
 			res = true;
 		if (!res && LOG_INVALID(net, IPPROTO_TCP))
 			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
@@ -812,6 +831,7 @@ static int tcp_packet(struct nf_conn *ct
 		      unsigned int hooknum)
 {
 	struct net *net = nf_ct_net(ct);
+	struct tcp_net *tn;
 	struct nf_conntrack_tuple *tuple;
 	enum tcp_conntrack new_state, old_state;
 	enum ip_conntrack_dir dir;
@@ -950,6 +970,8 @@ static int tcp_packet(struct nf_conn *ct
 	ct->proto.tcp.last_index = index;
 	ct->proto.tcp.last_dir = dir;
 
+	tn = tcp_pernet(net);
+
 	pr_debug("tcp_conntracks: ");
 	nf_ct_dump_tuple(tuple);
 	pr_debug("syn=%i ack=%i fin=%i rst=%i old=%i new=%i\n",
@@ -962,15 +984,15 @@ static int tcp_packet(struct nf_conn *ct
 	    && new_state == TCP_CONNTRACK_FIN_WAIT)
 		ct->proto.tcp.seen[dir].flags |= IP_CT_TCP_FLAG_CLOSE_INIT;
 
-	if (ct->proto.tcp.retrans >= nf_ct_tcp_max_retrans &&
-	    tcp_timeouts[new_state] > nf_ct_tcp_timeout_max_retrans)
-		timeout = nf_ct_tcp_timeout_max_retrans;
+	if (ct->proto.tcp.retrans >= tn->tcp_max_retrans &&
+	    tn->tcp_timeouts[new_state] > tn->tcp_timeout_max_retrans)
+		timeout = tn->tcp_timeout_max_retrans;
 	else if ((ct->proto.tcp.seen[0].flags | ct->proto.tcp.seen[1].flags) &
 		 IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&
-		 tcp_timeouts[new_state] > nf_ct_tcp_timeout_unacknowledged)
-		timeout = nf_ct_tcp_timeout_unacknowledged;
+		 tn->tcp_timeouts[new_state] > tn->tcp_timeout_unacknowledged)
+		timeout = tn->tcp_timeout_unacknowledged;
 	else
-		timeout = tcp_timeouts[new_state];
+		timeout = tn->tcp_timeouts[new_state];
 	write_unlock_bh(&tcp_lock);
 
 	nf_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, ct);
@@ -1007,6 +1029,7 @@ static bool tcp_new(struct nf_conn *ct, 
 {
 	enum tcp_conntrack new_state;
 	const struct tcphdr *th;
+	struct tcp_net *tn;
 	struct tcphdr _tcph;
 	const struct ip_ct_tcp_state *sender = &ct->proto.tcp.seen[0];
 	const struct ip_ct_tcp_state *receiver = &ct->proto.tcp.seen[1];
@@ -1025,6 +1048,8 @@ static bool tcp_new(struct nf_conn *ct, 
 		return false;
 	}
 
+	tn = tcp_pernet(nf_ct_net(ct));
+
 	if (new_state == TCP_CONNTRACK_SYN_SENT) {
 		/* SYN packet */
 		ct->proto.tcp.seen[0].td_end =
@@ -1038,7 +1063,7 @@ static bool tcp_new(struct nf_conn *ct, 
 
 		tcp_options(skb, dataoff, th, &ct->proto.tcp.seen[0]);
 		ct->proto.tcp.seen[1].flags = 0;
-	} else if (nf_ct_tcp_loose == 0) {
+	} else if (tn->tcp_loose == 0) {
 		/* Don't try to pick up connections. */
 		return false;
 	} else {
@@ -1197,75 +1222,64 @@ static int tcp_nlattr_tuple_size(void)
 #endif
 
 #ifdef CONFIG_SYSCTL
-static unsigned int tcp_sysctl_table_users;
-static struct ctl_table_header *tcp_sysctl_header;
+/* templates, data assigned later */
 static struct ctl_table tcp_sysctl_table[] = {
 	{
 		.procname	= "nf_conntrack_tcp_timeout_syn_sent",
-		.data		= &tcp_timeouts[TCP_CONNTRACK_SYN_SENT],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nf_conntrack_tcp_timeout_syn_recv",
-		.data		= &tcp_timeouts[TCP_CONNTRACK_SYN_RECV],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nf_conntrack_tcp_timeout_established",
-		.data		= &tcp_timeouts[TCP_CONNTRACK_ESTABLISHED],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nf_conntrack_tcp_timeout_fin_wait",
-		.data		= &tcp_timeouts[TCP_CONNTRACK_FIN_WAIT],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nf_conntrack_tcp_timeout_close_wait",
-		.data		= &tcp_timeouts[TCP_CONNTRACK_CLOSE_WAIT],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nf_conntrack_tcp_timeout_last_ack",
-		.data		= &tcp_timeouts[TCP_CONNTRACK_LAST_ACK],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nf_conntrack_tcp_timeout_time_wait",
-		.data		= &tcp_timeouts[TCP_CONNTRACK_TIME_WAIT],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nf_conntrack_tcp_timeout_close",
-		.data		= &tcp_timeouts[TCP_CONNTRACK_CLOSE],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nf_conntrack_tcp_timeout_max_retrans",
-		.data		= &nf_ct_tcp_timeout_max_retrans,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nf_conntrack_tcp_timeout_unacknowledged",
-		.data		= &nf_ct_tcp_timeout_unacknowledged,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
@@ -1273,7 +1287,6 @@ static struct ctl_table tcp_sysctl_table
 	{
 		.ctl_name	= NET_NF_CONNTRACK_TCP_LOOSE,
 		.procname	= "nf_conntrack_tcp_loose",
-		.data		= &nf_ct_tcp_loose,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
@@ -1281,7 +1294,6 @@ static struct ctl_table tcp_sysctl_table
 	{
 		.ctl_name	= NET_NF_CONNTRACK_TCP_BE_LIBERAL,
 		.procname       = "nf_conntrack_tcp_be_liberal",
-		.data           = &nf_ct_tcp_be_liberal,
 		.maxlen         = sizeof(unsigned int),
 		.mode           = 0644,
 		.proc_handler   = proc_dointvec,
@@ -1289,7 +1301,6 @@ static struct ctl_table tcp_sysctl_table
 	{
 		.ctl_name	= NET_NF_CONNTRACK_TCP_MAX_RETRANS,
 		.procname	= "nf_conntrack_tcp_max_retrans",
-		.data		= &nf_ct_tcp_max_retrans,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
@@ -1303,63 +1314,54 @@ static struct ctl_table tcp_sysctl_table
 static struct ctl_table tcp_compat_sysctl_table[] = {
 	{
 		.procname	= "ip_conntrack_tcp_timeout_syn_sent",
-		.data		= &tcp_timeouts[TCP_CONNTRACK_SYN_SENT],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "ip_conntrack_tcp_timeout_syn_recv",
-		.data		= &tcp_timeouts[TCP_CONNTRACK_SYN_RECV],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "ip_conntrack_tcp_timeout_established",
-		.data		= &tcp_timeouts[TCP_CONNTRACK_ESTABLISHED],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "ip_conntrack_tcp_timeout_fin_wait",
-		.data		= &tcp_timeouts[TCP_CONNTRACK_FIN_WAIT],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "ip_conntrack_tcp_timeout_close_wait",
-		.data		= &tcp_timeouts[TCP_CONNTRACK_CLOSE_WAIT],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "ip_conntrack_tcp_timeout_last_ack",
-		.data		= &tcp_timeouts[TCP_CONNTRACK_LAST_ACK],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "ip_conntrack_tcp_timeout_time_wait",
-		.data		= &tcp_timeouts[TCP_CONNTRACK_TIME_WAIT],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "ip_conntrack_tcp_timeout_close",
-		.data		= &tcp_timeouts[TCP_CONNTRACK_CLOSE],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "ip_conntrack_tcp_timeout_max_retrans",
-		.data		= &nf_ct_tcp_timeout_max_retrans,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
@@ -1367,7 +1369,6 @@ static struct ctl_table tcp_compat_sysct
 	{
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_LOOSE,
 		.procname	= "ip_conntrack_tcp_loose",
-		.data		= &nf_ct_tcp_loose,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
@@ -1375,7 +1376,6 @@ static struct ctl_table tcp_compat_sysct
 	{
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_BE_LIBERAL,
 		.procname	= "ip_conntrack_tcp_be_liberal",
-		.data		= &nf_ct_tcp_be_liberal,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
@@ -1383,7 +1383,6 @@ static struct ctl_table tcp_compat_sysct
 	{
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_MAX_RETRANS,
 		.procname	= "ip_conntrack_tcp_max_retrans",
-		.data		= &nf_ct_tcp_max_retrans,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
@@ -1416,14 +1415,6 @@ struct nf_conntrack_l4proto nf_conntrack
 	.nlattr_tuple_size	= tcp_nlattr_tuple_size,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
-#ifdef CONFIG_SYSCTL
-	.ctl_table_users	= &tcp_sysctl_table_users,
-	.ctl_table_header	= &tcp_sysctl_header,
-	.ctl_table		= tcp_sysctl_table,
-#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
-	.ctl_compat_table	= tcp_compat_sysctl_table,
-#endif
-#endif
 };
 EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_tcp4);
 
@@ -1448,10 +1439,144 @@ struct nf_conntrack_l4proto nf_conntrack
 	.nlattr_tuple_size	= tcp_nlattr_tuple_size,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
+};
+EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_tcp6);
+
+static __net_init int tcp_net_init(struct net *net)
+{
+	struct tcp_net *tn;
+	int err;
+
+	tn = kmalloc(sizeof(*tn), GFP_KERNEL);
+	if (!tn)
+		return -ENOMEM;
+
+	/* default values */
+	tn->tcp_be_liberal	= 0;
+	tn->tcp_loose		= 1;
+	tn->tcp_max_retrans	= 3;
+
+	tn->tcp_timeout_max_retrans	= 5 MINS;
+	tn->tcp_timeout_unacknowledged	= 5 MINS;
+
+	tn->tcp_timeouts[TCP_CONNTRACK_SYN_SENT]	= 2 MINS;
+	tn->tcp_timeouts[TCP_CONNTRACK_SYN_RECV]	= 60 SECS;
+	tn->tcp_timeouts[TCP_CONNTRACK_ESTABLISHED]	= 5 DAYS;
+	tn->tcp_timeouts[TCP_CONNTRACK_FIN_WAIT]	= 2 MINS;
+	tn->tcp_timeouts[TCP_CONNTRACK_CLOSE_WAIT]	= 60 SECS;
+	tn->tcp_timeouts[TCP_CONNTRACK_LAST_ACK]	= 30 SECS;
+	tn->tcp_timeouts[TCP_CONNTRACK_TIME_WAIT]	= 2 MINS;
+	tn->tcp_timeouts[TCP_CONNTRACK_CLOSE]		= 10 SECS;
+
+	err = net_assign_generic(net, tcp_net_id, tn);
+	if (err)
+		goto out;
+
+	/*
+	 * Pin per-net data to sysctl tables
+	 *
+	 * We allocate new ctrl tables from predefined templates
+	 * and then assign .data fields iteratively, we allowed
+	 * to do so since TCP_CONNTRACK_... (enum tcp_conntrack)
+	 * is a part of userspace ABI and it's hardly that the enum
+	 * entries will be rearranged
+	 */
+
+#ifdef CONFIG_SYSCTL
+	{
+	int i;
+	err = -ENOMEM;
+	tn->sysctl_table = kmemdup(tcp_sysctl_table,
+			sizeof(tcp_sysctl_table), GFP_KERNEL);
+	if (!tn->sysctl_table)
+		goto out;
+
+	for (i = TCP_CONNTRACK_SYN_SENT; i < TCP_CONNTRACK_LISTEN; i++)
+		tn->sysctl_table[i - 1].data = &tn->tcp_timeouts[i];
+
+	tn->sysctl_table[8].data = &tn->tcp_timeout_max_retrans;
+	tn->sysctl_table[9].data = &tn->tcp_timeout_unacknowledged;
+	tn->sysctl_table[10].data = &tn->tcp_loose;
+	tn->sysctl_table[11].data = &tn->tcp_be_liberal;
+	tn->sysctl_table[12].data = &tn->tcp_max_retrans;
+
+	tn->sysctl_header = register_net_sysctl_table(net,
+			nf_net_netfilter_sysctl_path, tn->sysctl_table);
+	if (!tn->sysctl_header)
+		goto out_free;
+
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+	tn->compat_sysctl_table = kmemdup(tcp_compat_sysctl_table,
+			sizeof(tcp_compat_sysctl_table), GFP_KERNEL);
+	if (!tn->compat_sysctl_table)
+		goto out_sysctl;
+
+	for (i = TCP_CONNTRACK_SYN_SENT; i < TCP_CONNTRACK_LISTEN; i++)
+		tn->compat_sysctl_table[i - 1].data = &tn->tcp_timeouts[i];
+
+	tn->compat_sysctl_table[8].data = &tn->tcp_timeout_max_retrans;
+	tn->compat_sysctl_table[9].data = &tn->tcp_loose;
+	tn->compat_sysctl_table[10].data = &tn->tcp_be_liberal;
+	tn->compat_sysctl_table[11].data = &tn->tcp_max_retrans;
+
+	tn->compat_sysctl_header = register_net_sysctl_table(net,
+			nf_net_ipv4_netfilter_sysctl_path,
+			tn->compat_sysctl_table);
+	if (!tn->compat_sysctl_header)
+		goto out_free_compat;
+#endif /* CONFIG_NF_CONNTRACK_PROC_COMPAT */
+	}
+#endif /* CONFIG_SYSCTL */
+
+	return 0;
+
+#ifdef CONFIG_SYSCTL
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+out_free_compat:
+	kfree(tn->compat_sysctl_table);
+#endif
+out_sysctl:
+	unregister_net_sysctl_table(tn->sysctl_header);
+out_free:
+	kfree(tn->sysctl_table);
+#endif
+
+out:
+	kfree(tn);
+	return err;
+}
+
+static __net_exit void tcp_net_exit(struct net *net)
+{
+	struct tcp_net *tn = tcp_pernet(net);
 #ifdef CONFIG_SYSCTL
-	.ctl_table_users	= &tcp_sysctl_table_users,
-	.ctl_table_header	= &tcp_sysctl_header,
-	.ctl_table		= tcp_sysctl_table,
+	unregister_net_sysctl_table(tn->sysctl_header);
+	kfree(tn->sysctl_table);
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+	unregister_net_sysctl_table(tn->compat_sysctl_header);
+	kfree(tn->compat_sysctl_table);
 #endif
+#endif
+	kfree(tn);
+
+	net_assign_generic(net, tcp_net_id, NULL);
 };
-EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_tcp6);
+
+static struct pernet_operations tcp_net_ops = {
+	.init = tcp_net_init,
+	.exit = tcp_net_exit,
+};
+
+static int __init nf_ct_tcp_proto_init(void)
+{
+	return register_pernet_gen_subsys(&tcp_net_id, &tcp_net_ops);
+}
+
+static void __exit nf_ct_tcp_proto_fini(void)
+{
+	unregister_pernet_gen_subsys(tcp_net_id, &tcp_net_ops);
+}
+
+module_init(nf_ct_tcp_proto_init);
+module_exit(nf_ct_tcp_proto_fini);
+MODULE_LICENSE("GPL");

