From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 18/33] netfilter: conntrack: unify sysctl handling
Date: Tue, 29 Jan 2019 00:57:35 +0100
Message-ID: <20190128235750.18412-19-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Due to historical reasons, all l4 trackers register their own
sysctls.

This leads to copy&pasted boilerplate code, that does exactly same
thing, just with different data structure.

Place all of this in a single file.

This allows to remove the various ctl_table pointers from the ct_netns
structure and reduces overall code size.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_dccp.c    |  86 +------
 net/netfilter/nf_conntrack_proto_generic.c |  30 +--
 net/netfilter/nf_conntrack_proto_gre.c     |  42 +--
 net/netfilter/nf_conntrack_proto_icmp.c    |  29 +--
 net/netfilter/nf_conntrack_proto_icmpv6.c  |  29 +--
 net/netfilter/nf_conntrack_proto_sctp.c    |  89 +------
 net/netfilter/nf_conntrack_proto_tcp.c     | 116 +--------
 net/netfilter/nf_conntrack_proto_udp.c     |  36 +--
 net/netfilter/nf_conntrack_standalone.c    | 394 ++++++++++++++++++++++++++++-
 9 files changed, 391 insertions(+), 460 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 84408ec80624..31ba88311bc4 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -724,90 +724,6 @@ dccp_timeout_nla_policy[CTA_TIMEOUT_DCCP_MAX+1] = {
 };
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
-#ifdef CONFIG_SYSCTL
-/* template, data assigned later */
-static struct ctl_table dccp_sysctl_table[] = {
-	{
-		.procname	= "nf_conntrack_dccp_timeout_request",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_dccp_timeout_respond",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_dccp_timeout_partopen",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_dccp_timeout_open",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_dccp_timeout_closereq",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_dccp_timeout_closing",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_dccp_timeout_timewait",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_dccp_loose",
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{ }
-};
-#endif /* CONFIG_SYSCTL */
-
-static int dccp_kmemdup_sysctl_table(struct net *net, struct nf_proto_net *pn,
-				     struct nf_dccp_net *dn)
-{
-#ifdef CONFIG_SYSCTL
-	if (pn->ctl_table)
-		return 0;
-
-	pn->ctl_table = kmemdup(dccp_sysctl_table,
-				sizeof(dccp_sysctl_table),
-				GFP_KERNEL);
-	if (!pn->ctl_table)
-		return -ENOMEM;
-
-	pn->ctl_table[0].data = &dn->dccp_timeout[CT_DCCP_REQUEST];
-	pn->ctl_table[1].data = &dn->dccp_timeout[CT_DCCP_RESPOND];
-	pn->ctl_table[2].data = &dn->dccp_timeout[CT_DCCP_PARTOPEN];
-	pn->ctl_table[3].data = &dn->dccp_timeout[CT_DCCP_OPEN];
-	pn->ctl_table[4].data = &dn->dccp_timeout[CT_DCCP_CLOSEREQ];
-	pn->ctl_table[5].data = &dn->dccp_timeout[CT_DCCP_CLOSING];
-	pn->ctl_table[6].data = &dn->dccp_timeout[CT_DCCP_TIMEWAIT];
-	pn->ctl_table[7].data = &dn->dccp_loose;
-
-	/* Don't export sysctls to unprivileged users */
-	if (net->user_ns != &init_user_ns)
-		pn->ctl_table[0].procname = NULL;
-#endif
-	return 0;
-}
-
 static int dccp_init_net(struct net *net)
 {
 	struct nf_dccp_net *dn = nf_dccp_pernet(net);
@@ -830,7 +746,7 @@ static int dccp_init_net(struct net *net)
 		dn->dccp_timeout[CT_DCCP_NONE] = dn->dccp_timeout[CT_DCCP_REQUEST];
 	}
 
-	return dccp_kmemdup_sysctl_table(net, pn, dn);
+	return 0;
 }
 
 static struct nf_proto_net *dccp_get_net_proto(struct net *net)
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index 78358d192c60..0edbf82594d0 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -60,41 +60,13 @@ generic_timeout_nla_policy[CTA_TIMEOUT_GENERIC_MAX+1] = {
 };
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
-#ifdef CONFIG_SYSCTL
-static struct ctl_table generic_sysctl_table[] = {
-	{
-		.procname	= "nf_conntrack_generic_timeout",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{ }
-};
-#endif /* CONFIG_SYSCTL */
-
-static int generic_kmemdup_sysctl_table(struct nf_proto_net *pn,
-					struct nf_generic_net *gn)
-{
-#ifdef CONFIG_SYSCTL
-	pn->ctl_table = kmemdup(generic_sysctl_table,
-				sizeof(generic_sysctl_table),
-				GFP_KERNEL);
-	if (!pn->ctl_table)
-		return -ENOMEM;
-
-	pn->ctl_table[0].data = &gn->timeout;
-#endif
-	return 0;
-}
-
 static int generic_init_net(struct net *net)
 {
 	struct nf_generic_net *gn = nf_generic_pernet(net);
-	struct nf_proto_net *pn = &gn->pn;
 
 	gn->timeout = nf_ct_generic_timeout;
 
-	return generic_kmemdup_sysctl_table(pn, gn);
+	return 0;
 }
 
 static struct nf_proto_net *generic_get_net_proto(struct net *net)
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index f6391991bcf6..e573ec0fa12b 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -313,46 +313,6 @@ gre_timeout_nla_policy[CTA_TIMEOUT_GRE_MAX+1] = {
 };
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
-#ifdef CONFIG_SYSCTL
-static struct ctl_table gre_sysctl_table[] = {
-	{
-		.procname       = "nf_conntrack_gre_timeout",
-		.maxlen         = sizeof(unsigned int),
-		.mode           = 0644,
-		.proc_handler   = proc_dointvec_jiffies,
-	},
-	{
-		.procname       = "nf_conntrack_gre_timeout_stream",
-		.maxlen         = sizeof(unsigned int),
-		.mode           = 0644,
-		.proc_handler   = proc_dointvec_jiffies,
-	},
-	{}
-};
-#endif
-
-static int gre_kmemdup_sysctl_table(struct net *net)
-{
-#ifdef CONFIG_SYSCTL
-	struct nf_gre_net *net_gre = gre_pernet(net);
-	struct nf_proto_net *nf = &net_gre->nf;
-	int i;
-
-	if (nf->ctl_table)
-		return 0;
-
-	nf->ctl_table = kmemdup(gre_sysctl_table,
-				sizeof(gre_sysctl_table),
-				GFP_KERNEL);
-	if (!nf->ctl_table)
-		return -ENOMEM;
-
-	for (i = 0; i < GRE_CT_MAX; i++)
-		nf->ctl_table[i].data = &net_gre->timeouts[i];
-#endif
-	return 0;
-}
-
 static int gre_init_net(struct net *net)
 {
 	struct nf_gre_net *net_gre = gre_pernet(net);
@@ -362,7 +322,7 @@ static int gre_init_net(struct net *net)
 	for (i = 0; i < GRE_CT_MAX; i++)
 		net_gre->timeouts[i] = gre_timeouts[i];
 
-	return gre_kmemdup_sysctl_table(net);
+	return 0;
 }
 
 /* protocol helper struct */
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index 1007efae741d..eb77f747759f 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -298,41 +298,14 @@ icmp_timeout_nla_policy[CTA_TIMEOUT_ICMP_MAX+1] = {
 };
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
-#ifdef CONFIG_SYSCTL
-static struct ctl_table icmp_sysctl_table[] = {
-	{
-		.procname	= "nf_conntrack_icmp_timeout",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{ }
-};
-#endif /* CONFIG_SYSCTL */
-
-static int icmp_kmemdup_sysctl_table(struct nf_proto_net *pn,
-				     struct nf_icmp_net *in)
-{
-#ifdef CONFIG_SYSCTL
-	pn->ctl_table = kmemdup(icmp_sysctl_table,
-				sizeof(icmp_sysctl_table),
-				GFP_KERNEL);
-	if (!pn->ctl_table)
-		return -ENOMEM;
-
-	pn->ctl_table[0].data = &in->timeout;
-#endif
-	return 0;
-}
 
 static int icmp_init_net(struct net *net)
 {
 	struct nf_icmp_net *in = nf_icmp_pernet(net);
-	struct nf_proto_net *pn = &in->pn;
 
 	in->timeout = nf_ct_icmp_timeout;
 
-	return icmp_kmemdup_sysctl_table(pn, in);
+	return 0;
 }
 
 static struct nf_proto_net *icmp_get_net_proto(struct net *net)
diff --git a/net/netfilter/nf_conntrack_proto_icmpv6.c b/net/netfilter/nf_conntrack_proto_icmpv6.c
index 6c93c091a8dd..d243ef8a128e 100644
--- a/net/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/netfilter/nf_conntrack_proto_icmpv6.c
@@ -309,41 +309,14 @@ icmpv6_timeout_nla_policy[CTA_TIMEOUT_ICMPV6_MAX+1] = {
 };
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
-#ifdef CONFIG_SYSCTL
-static struct ctl_table icmpv6_sysctl_table[] = {
-	{
-		.procname	= "nf_conntrack_icmpv6_timeout",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{ }
-};
-#endif /* CONFIG_SYSCTL */
-
-static int icmpv6_kmemdup_sysctl_table(struct nf_proto_net *pn,
-				       struct nf_icmp_net *in)
-{
-#ifdef CONFIG_SYSCTL
-	pn->ctl_table = kmemdup(icmpv6_sysctl_table,
-				sizeof(icmpv6_sysctl_table),
-				GFP_KERNEL);
-	if (!pn->ctl_table)
-		return -ENOMEM;
-
-	pn->ctl_table[0].data = &in->timeout;
-#endif
-	return 0;
-}
 
 static int icmpv6_init_net(struct net *net)
 {
 	struct nf_icmp_net *in = nf_icmpv6_pernet(net);
-	struct nf_proto_net *pn = &in->pn;
 
 	in->timeout = nf_ct_icmpv6_timeout;
 
-	return icmpv6_kmemdup_sysctl_table(pn, in);
+	return 0;
 }
 
 static struct nf_proto_net *icmpv6_get_net_proto(struct net *net)
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 952f2cc0fd74..31130f218d8f 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -642,93 +642,6 @@ sctp_timeout_nla_policy[CTA_TIMEOUT_SCTP_MAX+1] = {
 };
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
-
-#ifdef CONFIG_SYSCTL
-static struct ctl_table sctp_sysctl_table[] = {
-	{
-		.procname	= "nf_conntrack_sctp_timeout_closed",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_sctp_timeout_cookie_wait",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_sctp_timeout_cookie_echoed",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_sctp_timeout_established",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_sctp_timeout_shutdown_sent",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_sctp_timeout_shutdown_recd",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_sctp_timeout_shutdown_ack_sent",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_sctp_timeout_heartbeat_sent",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_sctp_timeout_heartbeat_acked",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{ }
-};
-#endif
-
-static int sctp_kmemdup_sysctl_table(struct nf_proto_net *pn,
-				     struct nf_sctp_net *sn)
-{
-#ifdef CONFIG_SYSCTL
-	if (pn->ctl_table)
-		return 0;
-
-	pn->ctl_table = kmemdup(sctp_sysctl_table,
-				sizeof(sctp_sysctl_table),
-				GFP_KERNEL);
-	if (!pn->ctl_table)
-		return -ENOMEM;
-
-	pn->ctl_table[0].data = &sn->timeouts[SCTP_CONNTRACK_CLOSED];
-	pn->ctl_table[1].data = &sn->timeouts[SCTP_CONNTRACK_COOKIE_WAIT];
-	pn->ctl_table[2].data = &sn->timeouts[SCTP_CONNTRACK_COOKIE_ECHOED];
-	pn->ctl_table[3].data = &sn->timeouts[SCTP_CONNTRACK_ESTABLISHED];
-	pn->ctl_table[4].data = &sn->timeouts[SCTP_CONNTRACK_SHUTDOWN_SENT];
-	pn->ctl_table[5].data = &sn->timeouts[SCTP_CONNTRACK_SHUTDOWN_RECD];
-	pn->ctl_table[6].data = &sn->timeouts[SCTP_CONNTRACK_SHUTDOWN_ACK_SENT];
-	pn->ctl_table[7].data = &sn->timeouts[SCTP_CONNTRACK_HEARTBEAT_SENT];
-	pn->ctl_table[8].data = &sn->timeouts[SCTP_CONNTRACK_HEARTBEAT_ACKED];
-#endif
-	return 0;
-}
-
 static int sctp_init_net(struct net *net)
 {
 	struct nf_sctp_net *sn = nf_sctp_pernet(net);
@@ -746,7 +659,7 @@ static int sctp_init_net(struct net *net)
 		sn->timeouts[0] = sctp_timeouts[SCTP_CONNTRACK_CLOSED];
 	}
 
-	return sctp_kmemdup_sysctl_table(pn, sn);
+	return 0;
 }
 
 static struct nf_proto_net *sctp_get_net_proto(struct net *net)
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 32aac9a835d4..422bdedac0ed 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1387,120 +1387,6 @@ static const struct nla_policy tcp_timeout_nla_policy[CTA_TIMEOUT_TCP_MAX+1] = {
 };
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
-#ifdef CONFIG_SYSCTL
-static struct ctl_table tcp_sysctl_table[] = {
-	{
-		.procname	= "nf_conntrack_tcp_timeout_syn_sent",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_tcp_timeout_syn_recv",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_tcp_timeout_established",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_tcp_timeout_fin_wait",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_tcp_timeout_close_wait",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_tcp_timeout_last_ack",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_tcp_timeout_time_wait",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_tcp_timeout_close",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_tcp_timeout_max_retrans",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_tcp_timeout_unacknowledged",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_tcp_loose",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname       = "nf_conntrack_tcp_be_liberal",
-		.maxlen         = sizeof(unsigned int),
-		.mode           = 0644,
-		.proc_handler   = proc_dointvec,
-	},
-	{
-		.procname	= "nf_conntrack_tcp_max_retrans",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{ }
-};
-#endif /* CONFIG_SYSCTL */
-
-static int tcp_kmemdup_sysctl_table(struct nf_proto_net *pn,
-				    struct nf_tcp_net *tn)
-{
-#ifdef CONFIG_SYSCTL
-	if (pn->ctl_table)
-		return 0;
-
-	pn->ctl_table = kmemdup(tcp_sysctl_table,
-				sizeof(tcp_sysctl_table),
-				GFP_KERNEL);
-	if (!pn->ctl_table)
-		return -ENOMEM;
-
-	pn->ctl_table[0].data = &tn->timeouts[TCP_CONNTRACK_SYN_SENT];
-	pn->ctl_table[1].data = &tn->timeouts[TCP_CONNTRACK_SYN_RECV];
-	pn->ctl_table[2].data = &tn->timeouts[TCP_CONNTRACK_ESTABLISHED];
-	pn->ctl_table[3].data = &tn->timeouts[TCP_CONNTRACK_FIN_WAIT];
-	pn->ctl_table[4].data = &tn->timeouts[TCP_CONNTRACK_CLOSE_WAIT];
-	pn->ctl_table[5].data = &tn->timeouts[TCP_CONNTRACK_LAST_ACK];
-	pn->ctl_table[6].data = &tn->timeouts[TCP_CONNTRACK_TIME_WAIT];
-	pn->ctl_table[7].data = &tn->timeouts[TCP_CONNTRACK_CLOSE];
-	pn->ctl_table[8].data = &tn->timeouts[TCP_CONNTRACK_RETRANS];
-	pn->ctl_table[9].data = &tn->timeouts[TCP_CONNTRACK_UNACK];
-	pn->ctl_table[10].data = &tn->tcp_loose;
-	pn->ctl_table[11].data = &tn->tcp_be_liberal;
-	pn->ctl_table[12].data = &tn->tcp_max_retrans;
-#endif
-	return 0;
-}
-
 static int tcp_init_net(struct net *net)
 {
 	struct nf_tcp_net *tn = nf_tcp_pernet(net);
@@ -1521,7 +1407,7 @@ static int tcp_init_net(struct net *net)
 		tn->tcp_max_retrans = nf_ct_tcp_max_retrans;
 	}
 
-	return tcp_kmemdup_sysctl_table(pn, tn);
+	return 0;
 }
 
 static struct nf_proto_net *tcp_get_net_proto(struct net *net)
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index e1f409aa0006..6e81e79844d7 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -260,40 +260,6 @@ udp_timeout_nla_policy[CTA_TIMEOUT_UDP_MAX+1] = {
 };
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
-#ifdef CONFIG_SYSCTL
-static struct ctl_table udp_sysctl_table[] = {
-	{
-		.procname	= "nf_conntrack_udp_timeout",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "nf_conntrack_udp_timeout_stream",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{ }
-};
-#endif /* CONFIG_SYSCTL */
-
-static int udp_kmemdup_sysctl_table(struct nf_proto_net *pn,
-				    struct nf_udp_net *un)
-{
-#ifdef CONFIG_SYSCTL
-	if (pn->ctl_table)
-		return 0;
-	pn->ctl_table = kmemdup(udp_sysctl_table,
-				sizeof(udp_sysctl_table),
-				GFP_KERNEL);
-	if (!pn->ctl_table)
-		return -ENOMEM;
-	pn->ctl_table[0].data = &un->timeouts[UDP_CT_UNREPLIED];
-	pn->ctl_table[1].data = &un->timeouts[UDP_CT_REPLIED];
-#endif
-	return 0;
-}
 
 static int udp_init_net(struct net *net)
 {
@@ -307,7 +273,7 @@ static int udp_init_net(struct net *net)
 			un->timeouts[i] = udp_timeouts[i];
 	}
 
-	return udp_kmemdup_sysctl_table(pn, un);
+	return 0;
 }
 
 static struct nf_proto_net *udp_get_net_proto(struct net *net)
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index b6177fd73304..d848de713dc0 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -547,8 +547,55 @@ enum nf_ct_sysctl_index {
 #ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
 	NF_SYSCTL_CT_TIMESTAMP,
 #endif
+	NF_SYSCTL_CT_PROTO_TIMEOUT_GENERIC,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_SYN_SENT,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_SYN_RECV,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_ESTABLISHED,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_FIN_WAIT,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_CLOSE_WAIT,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_LAST_ACK,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_TIME_WAIT,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_CLOSE,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_RETRANS,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_UNACK,
+	NF_SYSCTL_CT_PROTO_TCP_LOOSE,
+	NF_SYSCTL_CT_PROTO_TCP_LIBERAL,
+	NF_SYSCTL_CT_PROTO_TCP_MAX_RETRANS,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_UDP,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_STREAM,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_ICMP,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_ICMPV6,
+#ifdef CONFIG_NF_CT_PROTO_SCTP
+	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_CLOSED,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_COOKIE_WAIT,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_COOKIE_ECHOED,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_ESTABLISHED,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_SENT,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_RECD,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_SENT,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_ACKED,
+#endif
+#ifdef CONFIG_NF_CT_PROTO_DCCP
+	NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_REQUEST,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_RESPOND,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_PARTOPEN,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_OPEN,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_CLOSEREQ,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_CLOSING,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_TIMEWAIT,
+	NF_SYSCTL_CT_PROTO_DCCP_LOOSE,
+#endif
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	NF_SYSCTL_CT_PROTO_TIMEOUT_GRE,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_GRE_STREAM,
+#endif
+
+	__NF_SYSCTL_CT_LAST_SYSCTL,
 };
 
+#define NF_SYSCTL_CT_LAST_SYSCTL (__NF_SYSCTL_CT_LAST_SYSCTL + 1)
+
 static struct ctl_table nf_ct_sysctl_table[] = {
 	[NF_SYSCTL_CT_MAX] = {
 		.procname	= "nf_conntrack_max",
@@ -626,7 +673,235 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
-	{ }
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_GENERIC] = {
+		.procname	= "nf_conntrack_generic_timeout",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_SYN_SENT] = {
+		.procname	= "nf_conntrack_tcp_timeout_syn_sent",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_SYN_RECV] = {
+		.procname	= "nf_conntrack_tcp_timeout_syn_recv",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_ESTABLISHED] = {
+		.procname	= "nf_conntrack_tcp_timeout_established",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_FIN_WAIT] = {
+		.procname	= "nf_conntrack_tcp_timeout_fin_wait",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_CLOSE_WAIT] = {
+		.procname	= "nf_conntrack_tcp_timeout_close_wait",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_LAST_ACK] = {
+		.procname	= "nf_conntrack_tcp_timeout_last_ack",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_TIME_WAIT] = {
+		.procname	= "nf_conntrack_tcp_timeout_time_wait",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_CLOSE] = {
+		.procname	= "nf_conntrack_tcp_timeout_close",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_RETRANS] = {
+		.procname	= "nf_conntrack_tcp_timeout_max_retrans",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_UNACK] = {
+		.procname	= "nf_conntrack_tcp_timeout_unacknowledged",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TCP_LOOSE] = {
+		.procname	= "nf_conntrack_tcp_loose",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	[NF_SYSCTL_CT_PROTO_TCP_LIBERAL] = {
+		.procname       = "nf_conntrack_tcp_be_liberal",
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec,
+	},
+	[NF_SYSCTL_CT_PROTO_TCP_MAX_RETRANS] = {
+		.procname	= "nf_conntrack_tcp_max_retrans",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP] = {
+		.procname	= "nf_conntrack_udp_timeout",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_STREAM] = {
+		.procname	= "nf_conntrack_udp_timeout_stream",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_ICMP] = {
+		.procname	= "nf_conntrack_icmp_timeout",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_ICMPV6] = {
+		.procname	= "nf_conntrack_icmpv6_timeout",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+#ifdef CONFIG_NF_CT_PROTO_SCTP
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_CLOSED] = {
+		.procname	= "nf_conntrack_sctp_timeout_closed",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_COOKIE_WAIT] = {
+		.procname	= "nf_conntrack_sctp_timeout_cookie_wait",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_COOKIE_ECHOED] = {
+		.procname	= "nf_conntrack_sctp_timeout_cookie_echoed",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_ESTABLISHED] = {
+		.procname	= "nf_conntrack_sctp_timeout_established",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_SENT] = {
+		.procname	= "nf_conntrack_sctp_timeout_shutdown_sent",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_RECD] = {
+		.procname	= "nf_conntrack_sctp_timeout_shutdown_recd",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT] = {
+		.procname	= "nf_conntrack_sctp_timeout_shutdown_ack_sent",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_SENT] = {
+		.procname	= "nf_conntrack_sctp_timeout_heartbeat_sent",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_ACKED] = {
+		.procname       = "nf_conntrack_sctp_timeout_heartbeat_acked",
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_jiffies,
+	},
+#endif
+#ifdef CONFIG_NF_CT_PROTO_DCCP
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_REQUEST] = {
+		.procname	= "nf_conntrack_dccp_timeout_request",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_RESPOND] = {
+		.procname	= "nf_conntrack_dccp_timeout_respond",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_PARTOPEN] = {
+		.procname	= "nf_conntrack_dccp_timeout_partopen",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_OPEN] = {
+		.procname	= "nf_conntrack_dccp_timeout_open",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_CLOSEREQ] = {
+		.procname	= "nf_conntrack_dccp_timeout_closereq",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_CLOSING] = {
+		.procname	= "nf_conntrack_dccp_timeout_closing",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_TIMEWAIT] = {
+		.procname	= "nf_conntrack_dccp_timeout_timewait",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_DCCP_LOOSE] = {
+		.procname	= "nf_conntrack_dccp_loose",
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_GRE] = {
+		.procname       = "nf_conntrack_gre_timeout",
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_GRE_STREAM] = {
+		.procname       = "nf_conntrack_gre_timeout_stream",
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_jiffies,
+	},
+#endif
+	{}
 };
 
 static struct ctl_table nf_ct_netfilter_table[] = {
@@ -640,14 +915,103 @@ static struct ctl_table nf_ct_netfilter_table[] = {
 	{ }
 };
 
+static void nf_conntrack_standalone_init_tcp_sysctl(struct net *net,
+						    struct ctl_table *table)
+{
+	struct nf_tcp_net *tn = nf_tcp_pernet(net);
+
+#define XASSIGN(XNAME, tn) \
+	table[NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_ ## XNAME].data = \
+			&(tn)->timeouts[TCP_CONNTRACK_ ## XNAME]
+
+	XASSIGN(SYN_SENT, tn);
+	XASSIGN(SYN_RECV, tn);
+	XASSIGN(ESTABLISHED, tn);
+	XASSIGN(FIN_WAIT, tn);
+	XASSIGN(CLOSE_WAIT, tn);
+	XASSIGN(LAST_ACK, tn);
+	XASSIGN(TIME_WAIT, tn);
+	XASSIGN(CLOSE, tn);
+	XASSIGN(RETRANS, tn);
+	XASSIGN(UNACK, tn);
+#undef XASSIGN
+#define XASSIGN(XNAME, rval) \
+	table[NF_SYSCTL_CT_PROTO_TCP_ ## XNAME].data = (rval)
+
+	XASSIGN(LOOSE, &tn->tcp_loose);
+	XASSIGN(LIBERAL, &tn->tcp_be_liberal);
+	XASSIGN(MAX_RETRANS, &tn->tcp_max_retrans);
+#undef XASSIGN
+}
+
+static void nf_conntrack_standalone_init_sctp_sysctl(struct net *net,
+						     struct ctl_table *table)
+{
+#ifdef CONFIG_NF_CT_PROTO_SCTP
+	struct nf_sctp_net *sn = nf_sctp_pernet(net);
+
+#define XASSIGN(XNAME, sn) \
+	table[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_ ## XNAME].data = \
+			&(sn)->timeouts[SCTP_CONNTRACK_ ## XNAME]
+
+	XASSIGN(CLOSED, sn);
+	XASSIGN(COOKIE_WAIT, sn);
+	XASSIGN(COOKIE_ECHOED, sn);
+	XASSIGN(ESTABLISHED, sn);
+	XASSIGN(SHUTDOWN_SENT, sn);
+	XASSIGN(SHUTDOWN_RECD, sn);
+	XASSIGN(SHUTDOWN_ACK_SENT, sn);
+	XASSIGN(HEARTBEAT_SENT, sn);
+	XASSIGN(HEARTBEAT_ACKED, sn);
+#undef XASSIGN
+#endif
+}
+
+static void nf_conntrack_standalone_init_dccp_sysctl(struct net *net,
+						     struct ctl_table *table)
+{
+#ifdef CONFIG_NF_CT_PROTO_DCCP
+	struct nf_dccp_net *dn = nf_dccp_pernet(net);
+
+#define XASSIGN(XNAME, dn) \
+	table[NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_ ## XNAME].data = \
+			&(dn)->dccp_timeout[CT_DCCP_ ## XNAME]
+
+	XASSIGN(REQUEST, dn);
+	XASSIGN(RESPOND, dn);
+	XASSIGN(PARTOPEN, dn);
+	XASSIGN(OPEN, dn);
+	XASSIGN(CLOSEREQ, dn);
+	XASSIGN(CLOSING, dn);
+	XASSIGN(TIMEWAIT, dn);
+#undef XASSIGN
+
+	table[NF_SYSCTL_CT_PROTO_DCCP_LOOSE].data = &dn->dccp_loose;
+#endif
+}
+
+static void nf_conntrack_standalone_init_gre_sysctl(struct net *net,
+						    struct ctl_table *table)
+{
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	struct nf_gre_net *gn = nf_gre_pernet(net);
+
+	table[NF_SYSCTL_CT_PROTO_TIMEOUT_GRE].data = &gn->timeouts[GRE_CT_UNREPLIED];
+	table[NF_SYSCTL_CT_PROTO_TIMEOUT_GRE_STREAM].data = &gn->timeouts[GRE_CT_REPLIED];
+#endif
+}
+
 static int nf_conntrack_standalone_init_sysctl(struct net *net)
 {
+	struct nf_udp_net *un = nf_udp_pernet(net);
 	struct ctl_table *table;
 
+	BUILD_BUG_ON(ARRAY_SIZE(nf_ct_sysctl_table) != NF_SYSCTL_CT_LAST_SYSCTL);
+
 	table = kmemdup(nf_ct_sysctl_table, sizeof(nf_ct_sysctl_table),
 			GFP_KERNEL);
 	if (!table)
-		goto out_kmemdup;
+		return -ENOMEM;
 
 	table[NF_SYSCTL_CT_COUNT].data = &net->ct.count;
 	table[NF_SYSCTL_CT_CHECKSUM].data = &net->ct.sysctl_checksum;
@@ -655,6 +1019,16 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	table[NF_SYSCTL_CT_EVENTS].data = &net->ct.sysctl_events;
 #endif
+	table[NF_SYSCTL_CT_PROTO_TIMEOUT_GENERIC].data = &nf_generic_pernet(net)->timeout;
+	table[NF_SYSCTL_CT_PROTO_TIMEOUT_ICMP].data = &nf_icmp_pernet(net)->timeout;
+	table[NF_SYSCTL_CT_PROTO_TIMEOUT_ICMPV6].data = &nf_icmpv6_pernet(net)->timeout;
+	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP].data = &un->timeouts[UDP_CT_UNREPLIED];
+	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_STREAM].data = &un->timeouts[UDP_CT_REPLIED];
+
+	nf_conntrack_standalone_init_tcp_sysctl(net, table);
+	nf_conntrack_standalone_init_sctp_sysctl(net, table);
+	nf_conntrack_standalone_init_dccp_sysctl(net, table);
+	nf_conntrack_standalone_init_gre_sysctl(net, table);
 
 	/* Don't export sysctls to unprivileged users */
 	if (net->user_ns != &init_user_ns) {
@@ -680,7 +1054,6 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 
 out_unregister_netfilter:
 	kfree(table);
-out_kmemdup:
 	return -ENOMEM;
 }
 
@@ -707,27 +1080,26 @@ static int nf_conntrack_pernet_init(struct net *net)
 {
 	int ret;
 
-	ret = nf_conntrack_init_net(net);
+	net->ct.sysctl_checksum = 1;
+
+	ret = nf_conntrack_standalone_init_sysctl(net);
 	if (ret < 0)
-		goto out_init;
+		return ret;
 
 	ret = nf_conntrack_standalone_init_proc(net);
 	if (ret < 0)
 		goto out_proc;
 
-	net->ct.sysctl_checksum = 1;
-	net->ct.sysctl_log_invalid = 0;
-	ret = nf_conntrack_standalone_init_sysctl(net);
+	ret = nf_conntrack_init_net(net);
 	if (ret < 0)
-		goto out_sysctl;
+		goto out_init_net;
 
 	return 0;
 
-out_sysctl:
+out_init_net:
 	nf_conntrack_standalone_fini_proc(net);
 out_proc:
 	nf_conntrack_cleanup_net(net);
-out_init:
 	return ret;
 }
 
-- 
2.11.0
