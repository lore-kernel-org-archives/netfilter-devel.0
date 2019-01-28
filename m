From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 20/33] netfilter: conntrack: remove l4proto init and get_net callbacks
Date: Tue, 29 Jan 2019 00:57:37 +0100
Message-ID: <20190128235750.18412-21-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Those were needed we still had modular trackers.
As we don't have those anymore, prefer direct calls and remove all
the (un)register infrastructure associated with this.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h |  15 ++--
 include/net/netns/conntrack.h                |  11 ---
 net/netfilter/nf_conntrack_proto.c           | 103 ++++-----------------------
 net/netfilter/nf_conntrack_proto_dccp.c      |  42 ++++-------
 net/netfilter/nf_conntrack_proto_generic.c   |  11 +--
 net/netfilter/nf_conntrack_proto_gre.c       |   5 +-
 net/netfilter/nf_conntrack_proto_icmp.c      |  12 +---
 net/netfilter/nf_conntrack_proto_icmpv6.c    |  12 +---
 net/netfilter/nf_conntrack_proto_sctp.c      |  29 +++-----
 net/netfilter/nf_conntrack_proto_tcp.c       |  35 +++------
 net/netfilter/nf_conntrack_proto_udp.c       |  24 ++-----
 11 files changed, 65 insertions(+), 234 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 87d9c198c05e..d5909e51ca92 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -61,12 +61,6 @@ struct nf_conntrack_l4proto {
 	/* Print out the private part of the conntrack. */
 	void (*print_conntrack)(struct seq_file *s, struct nf_conn *);
 #endif
-
-	/* Init l4proto pernet data */
-	int (*init_net)(struct net *net);
-
-	/* Return the per-net protocol part. */
-	struct nf_proto_net *(*get_net_proto)(struct net *net);
 };
 
 bool icmp_pkt_to_tuple(const struct sk_buff *skb,
@@ -135,6 +129,15 @@ int nf_conntrack_gre_packet(struct nf_conn *ct,
 			    enum ip_conntrack_info ctinfo,
 			    const struct nf_hook_state *state);
 
+void nf_conntrack_generic_init_net(struct net *net);
+void nf_conntrack_tcp_init_net(struct net *net);
+void nf_conntrack_udp_init_net(struct net *net);
+void nf_conntrack_gre_init_net(struct net *net);
+void nf_conntrack_dccp_init_net(struct net *net);
+void nf_conntrack_sctp_init_net(struct net *net);
+void nf_conntrack_icmp_init_net(struct net *net);
+void nf_conntrack_icmpv6_init_net(struct net *net);
+
 /* Existing built-in generic protocol */
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic;
 
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index b8faa72e0f5b..f19b53130bf7 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -18,17 +18,11 @@
 struct ctl_table_header;
 struct nf_conntrack_ecache;
 
-struct nf_proto_net {
-	unsigned int		users;
-};
-
 struct nf_generic_net {
-	struct nf_proto_net pn;
 	unsigned int timeout;
 };
 
 struct nf_tcp_net {
-	struct nf_proto_net pn;
 	unsigned int timeouts[TCP_CONNTRACK_TIMEOUT_MAX];
 	unsigned int tcp_loose;
 	unsigned int tcp_be_liberal;
@@ -42,18 +36,15 @@ enum udp_conntrack {
 };
 
 struct nf_udp_net {
-	struct nf_proto_net pn;
 	unsigned int timeouts[UDP_CT_MAX];
 };
 
 struct nf_icmp_net {
-	struct nf_proto_net pn;
 	unsigned int timeout;
 };
 
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 struct nf_dccp_net {
-	struct nf_proto_net pn;
 	int dccp_loose;
 	unsigned int dccp_timeout[CT_DCCP_MAX + 1];
 };
@@ -61,7 +52,6 @@ struct nf_dccp_net {
 
 #ifdef CONFIG_NF_CT_PROTO_SCTP
 struct nf_sctp_net {
-	struct nf_proto_net pn;
 	unsigned int timeouts[SCTP_CONNTRACK_MAX];
 };
 #endif
@@ -74,7 +64,6 @@ enum gre_conntrack {
 };
 
 struct nf_gre_net {
-	struct nf_proto_net	nf;
 	struct list_head	keymap_list;
 	unsigned int		timeouts[GRE_CT_MAX];
 };
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index c8f024d731c8..e6bc02c13f0f 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -123,15 +123,6 @@ static int kill_l4proto(struct nf_conn *i, void *data)
 	return nf_ct_protonum(i) == l4proto->l4proto;
 }
 
-static struct nf_proto_net *nf_ct_l4proto_net(struct net *net,
-				const struct nf_conntrack_l4proto *l4proto)
-{
-	if (l4proto->get_net_proto)
-		return l4proto->get_net_proto(net);
-
-	return NULL;
-}
-
 /* FIXME: Allow NULL functions and sub in pointers to generic for
    them. --RR */
 int nf_ct_l4proto_register_one(const struct nf_conntrack_l4proto *l4proto)
@@ -158,27 +149,6 @@ int nf_ct_l4proto_register_one(const struct nf_conntrack_l4proto *l4proto)
 }
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_register_one);
 
-static int nf_ct_l4proto_pernet_register_one(struct net *net,
-					     const struct nf_conntrack_l4proto *l4proto)
-{
-	int ret = 0;
-	struct nf_proto_net *pn = NULL;
-
-	if (l4proto->init_net) {
-		ret = l4proto->init_net(net);
-		if (ret < 0)
-			goto out;
-	}
-
-	pn = nf_ct_l4proto_net(net, l4proto);
-	if (pn == NULL)
-		goto out;
-
-	pn->users++;
-out:
-	return ret;
-}
-
 static void __nf_ct_l4proto_unregister_one(const struct nf_conntrack_l4proto *l4proto)
 
 {
@@ -204,17 +174,6 @@ void nf_ct_l4proto_unregister_one(const struct nf_conntrack_l4proto *l4proto)
 }
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_unregister_one);
 
-static void nf_ct_l4proto_pernet_unregister_one(struct net *net,
-				const struct nf_conntrack_l4proto *l4proto)
-{
-	struct nf_proto_net *pn = nf_ct_l4proto_net(net, l4proto);
-
-	if (pn == NULL)
-		return;
-
-	pn->users--;
-}
-
 static void
 nf_ct_l4proto_unregister(const struct nf_conntrack_l4proto * const l4proto[],
 			 unsigned int num_proto)
@@ -252,34 +211,6 @@ nf_ct_l4proto_register(const struct nf_conntrack_l4proto * const l4proto[],
 	return ret;
 }
 
-static void nf_ct_l4proto_pernet_unregister(struct net *net,
-				const struct nf_conntrack_l4proto *const l4proto[],
-				unsigned int num_proto)
-{
-	while (num_proto-- != 0)
-		nf_ct_l4proto_pernet_unregister_one(net, l4proto[num_proto]);
-}
-
-static int nf_ct_l4proto_pernet_register(struct net *net,
-				  const struct nf_conntrack_l4proto *const l4proto[],
-				  unsigned int num_proto)
-{
-	int ret = -EINVAL;
-	unsigned int i;
-
-	for (i = 0; i < num_proto; i++) {
-		ret = nf_ct_l4proto_pernet_register_one(net, l4proto[i]);
-		if (ret < 0)
-			break;
-	}
-	if (i != num_proto) {
-		pr_err("nf_conntrack %d: pernet registration failed\n",
-		       l4proto[i]->l4proto);
-		nf_ct_l4proto_pernet_unregister(net, l4proto, i);
-	}
-	return ret;
-}
-
 static unsigned int nf_confirm(struct sk_buff *skb,
 			       unsigned int protoff,
 			       struct nf_conn *ct,
@@ -784,31 +715,25 @@ void nf_conntrack_proto_fini(void)
 
 int nf_conntrack_proto_pernet_init(struct net *net)
 {
-	int err;
-	struct nf_proto_net *pn = nf_ct_l4proto_net(net,
-					&nf_conntrack_l4proto_generic);
-
-	err = nf_conntrack_l4proto_generic.init_net(net);
-	if (err < 0)
-		return err;
-
-	err = nf_ct_l4proto_pernet_register(net, builtin_l4proto,
-					    ARRAY_SIZE(builtin_l4proto));
-	if (err < 0)
-		return err;
-
-	pn->users++;
+	nf_conntrack_generic_init_net(net);
+	nf_conntrack_udp_init_net(net);
+	nf_conntrack_tcp_init_net(net);
+	nf_conntrack_icmp_init_net(net);
+	nf_conntrack_icmpv6_init_net(net);
+#ifdef CONFIG_NF_CT_PROTO_DCCP
+	nf_conntrack_dccp_init_net(net);
+#endif
+#ifdef CONFIG_NF_CT_PROTO_SCTP
+	nf_conntrack_sctp_init_net(net);
+#endif
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	nf_conntrack_gre_init_net(net);
+#endif
 	return 0;
 }
 
 void nf_conntrack_proto_pernet_fini(struct net *net)
 {
-	struct nf_proto_net *pn = nf_ct_l4proto_net(net,
-					&nf_conntrack_l4proto_generic);
-
-	nf_ct_l4proto_pernet_unregister(net, builtin_l4proto,
-					ARRAY_SIZE(builtin_l4proto));
-	pn->users--;
 #ifdef CONFIG_NF_CT_PROTO_GRE
 	nf_ct_gre_keymap_flush(net);
 #endif
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 31ba88311bc4..6fca80587505 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -724,34 +724,24 @@ dccp_timeout_nla_policy[CTA_TIMEOUT_DCCP_MAX+1] = {
 };
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
-static int dccp_init_net(struct net *net)
+void nf_conntrack_dccp_init_net(struct net *net)
 {
 	struct nf_dccp_net *dn = nf_dccp_pernet(net);
-	struct nf_proto_net *pn = &dn->pn;
-
-	if (!pn->users) {
-		/* default values */
-		dn->dccp_loose = 1;
-		dn->dccp_timeout[CT_DCCP_REQUEST]	= 2 * DCCP_MSL;
-		dn->dccp_timeout[CT_DCCP_RESPOND]	= 4 * DCCP_MSL;
-		dn->dccp_timeout[CT_DCCP_PARTOPEN]	= 4 * DCCP_MSL;
-		dn->dccp_timeout[CT_DCCP_OPEN]		= 12 * 3600 * HZ;
-		dn->dccp_timeout[CT_DCCP_CLOSEREQ]	= 64 * HZ;
-		dn->dccp_timeout[CT_DCCP_CLOSING]	= 64 * HZ;
-		dn->dccp_timeout[CT_DCCP_TIMEWAIT]	= 2 * DCCP_MSL;
-
-		/* timeouts[0] is unused, make it same as SYN_SENT so
-		 * ->timeouts[0] contains 'new' timeout, like udp or icmp.
-		 */
-		dn->dccp_timeout[CT_DCCP_NONE] = dn->dccp_timeout[CT_DCCP_REQUEST];
-	}
-
-	return 0;
-}
 
-static struct nf_proto_net *dccp_get_net_proto(struct net *net)
-{
-	return &net->ct.nf_ct_proto.dccp.pn;
+	/* default values */
+	dn->dccp_loose = 1;
+	dn->dccp_timeout[CT_DCCP_REQUEST]	= 2 * DCCP_MSL;
+	dn->dccp_timeout[CT_DCCP_RESPOND]	= 4 * DCCP_MSL;
+	dn->dccp_timeout[CT_DCCP_PARTOPEN]	= 4 * DCCP_MSL;
+	dn->dccp_timeout[CT_DCCP_OPEN]		= 12 * 3600 * HZ;
+	dn->dccp_timeout[CT_DCCP_CLOSEREQ]	= 64 * HZ;
+	dn->dccp_timeout[CT_DCCP_CLOSING]	= 64 * HZ;
+	dn->dccp_timeout[CT_DCCP_TIMEWAIT]	= 2 * DCCP_MSL;
+
+	/* timeouts[0] is unused, make it same as SYN_SENT so
+	 * ->timeouts[0] contains 'new' timeout, like udp or icmp.
+	 */
+	dn->dccp_timeout[CT_DCCP_NONE] = dn->dccp_timeout[CT_DCCP_REQUEST];
 }
 
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp = {
@@ -778,6 +768,4 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp = {
 		.nla_policy	= dccp_timeout_nla_policy,
 	},
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
-	.init_net		= dccp_init_net,
-	.get_net_proto		= dccp_get_net_proto,
 };
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index 0edbf82594d0..0f526fafecae 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -60,18 +60,11 @@ generic_timeout_nla_policy[CTA_TIMEOUT_GENERIC_MAX+1] = {
 };
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
-static int generic_init_net(struct net *net)
+void nf_conntrack_generic_init_net(struct net *net)
 {
 	struct nf_generic_net *gn = nf_generic_pernet(net);
 
 	gn->timeout = nf_ct_generic_timeout;
-
-	return 0;
-}
-
-static struct nf_proto_net *generic_get_net_proto(struct net *net)
-{
-	return &net->ct.nf_ct_proto.generic.pn;
 }
 
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic =
@@ -86,6 +79,4 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic =
 		.nla_policy	= generic_timeout_nla_policy,
 	},
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
-	.init_net		= generic_init_net,
-	.get_net_proto		= generic_get_net_proto,
 };
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index e573ec0fa12b..fa765d2fd586 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -313,7 +313,7 @@ gre_timeout_nla_policy[CTA_TIMEOUT_GRE_MAX+1] = {
 };
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
-static int gre_init_net(struct net *net)
+void nf_conntrack_gre_init_net(struct net *net)
 {
 	struct nf_gre_net *net_gre = gre_pernet(net);
 	int i;
@@ -321,8 +321,6 @@ static int gre_init_net(struct net *net)
 	INIT_LIST_HEAD(&net_gre->keymap_list);
 	for (i = 0; i < GRE_CT_MAX; i++)
 		net_gre->timeouts[i] = gre_timeouts[i];
-
-	return 0;
 }
 
 /* protocol helper struct */
@@ -347,5 +345,4 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_gre = {
 		.nla_policy	= gre_timeout_nla_policy,
 	},
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
-	.init_net	= gre_init_net,
 };
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index eb77f747759f..7df477996b16 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -298,19 +298,11 @@ icmp_timeout_nla_policy[CTA_TIMEOUT_ICMP_MAX+1] = {
 };
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
-
-static int icmp_init_net(struct net *net)
+void nf_conntrack_icmp_init_net(struct net *net)
 {
 	struct nf_icmp_net *in = nf_icmp_pernet(net);
 
 	in->timeout = nf_ct_icmp_timeout;
-
-	return 0;
-}
-
-static struct nf_proto_net *icmp_get_net_proto(struct net *net)
-{
-	return &net->ct.nf_ct_proto.icmp.pn;
 }
 
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp =
@@ -331,6 +323,4 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp =
 		.nla_policy	= icmp_timeout_nla_policy,
 	},
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
-	.init_net		= icmp_init_net,
-	.get_net_proto		= icmp_get_net_proto,
 };
diff --git a/net/netfilter/nf_conntrack_proto_icmpv6.c b/net/netfilter/nf_conntrack_proto_icmpv6.c
index d243ef8a128e..bec4a3211658 100644
--- a/net/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/netfilter/nf_conntrack_proto_icmpv6.c
@@ -309,19 +309,11 @@ icmpv6_timeout_nla_policy[CTA_TIMEOUT_ICMPV6_MAX+1] = {
 };
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
-
-static int icmpv6_init_net(struct net *net)
+void nf_conntrack_icmpv6_init_net(struct net *net)
 {
 	struct nf_icmp_net *in = nf_icmpv6_pernet(net);
 
 	in->timeout = nf_ct_icmpv6_timeout;
-
-	return 0;
-}
-
-static struct nf_proto_net *icmpv6_get_net_proto(struct net *net)
-{
-	return &net->ct.nf_ct_proto.icmpv6.pn;
 }
 
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6 =
@@ -342,6 +334,4 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6 =
 		.nla_policy	= icmpv6_timeout_nla_policy,
 	},
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
-	.init_net		= icmpv6_init_net,
-	.get_net_proto		= icmpv6_get_net_proto,
 };
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 31130f218d8f..a7818101ad80 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -642,29 +642,18 @@ sctp_timeout_nla_policy[CTA_TIMEOUT_SCTP_MAX+1] = {
 };
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
-static int sctp_init_net(struct net *net)
+void nf_conntrack_sctp_init_net(struct net *net)
 {
 	struct nf_sctp_net *sn = nf_sctp_pernet(net);
-	struct nf_proto_net *pn = &sn->pn;
-
-	if (!pn->users) {
-		int i;
-
-		for (i = 0; i < SCTP_CONNTRACK_MAX; i++)
-			sn->timeouts[i] = sctp_timeouts[i];
-
-		/* timeouts[0] is unused, init it so ->timeouts[0] contains
-		 * 'new' timeout, like udp or icmp.
-		 */
-		sn->timeouts[0] = sctp_timeouts[SCTP_CONNTRACK_CLOSED];
-	}
+	int i;
 
-	return 0;
-}
+	for (i = 0; i < SCTP_CONNTRACK_MAX; i++)
+		sn->timeouts[i] = sctp_timeouts[i];
 
-static struct nf_proto_net *sctp_get_net_proto(struct net *net)
-{
-	return &net->ct.nf_ct_proto.sctp.pn;
+	/* timeouts[0] is unused, init it so ->timeouts[0] contains
+	 * 'new' timeout, like udp or icmp.
+	 */
+	sn->timeouts[0] = sctp_timeouts[SCTP_CONNTRACK_CLOSED];
 }
 
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp = {
@@ -691,6 +680,4 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp = {
 		.nla_policy	= sctp_timeout_nla_policy,
 	},
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
-	.init_net		= sctp_init_net,
-	.get_net_proto		= sctp_get_net_proto,
 };
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 422bdedac0ed..01c748fa8913 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1387,32 +1387,21 @@ static const struct nla_policy tcp_timeout_nla_policy[CTA_TIMEOUT_TCP_MAX+1] = {
 };
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
-static int tcp_init_net(struct net *net)
+void nf_conntrack_tcp_init_net(struct net *net)
 {
 	struct nf_tcp_net *tn = nf_tcp_pernet(net);
-	struct nf_proto_net *pn = &tn->pn;
-
-	if (!pn->users) {
-		int i;
-
-		for (i = 0; i < TCP_CONNTRACK_TIMEOUT_MAX; i++)
-			tn->timeouts[i] = tcp_timeouts[i];
-
-		/* timeouts[0] is unused, make it same as SYN_SENT so
-		 * ->timeouts[0] contains 'new' timeout, like udp or icmp.
-		 */
-		tn->timeouts[0] = tcp_timeouts[TCP_CONNTRACK_SYN_SENT];
-		tn->tcp_loose = nf_ct_tcp_loose;
-		tn->tcp_be_liberal = nf_ct_tcp_be_liberal;
-		tn->tcp_max_retrans = nf_ct_tcp_max_retrans;
-	}
+	int i;
 
-	return 0;
-}
+	for (i = 0; i < TCP_CONNTRACK_TIMEOUT_MAX; i++)
+		tn->timeouts[i] = tcp_timeouts[i];
 
-static struct nf_proto_net *tcp_get_net_proto(struct net *net)
-{
-	return &net->ct.nf_ct_proto.tcp.pn;
+	/* timeouts[0] is unused, make it same as SYN_SENT so
+	 * ->timeouts[0] contains 'new' timeout, like udp or icmp.
+	 */
+	tn->timeouts[0] = tcp_timeouts[TCP_CONNTRACK_SYN_SENT];
+	tn->tcp_loose = nf_ct_tcp_loose;
+	tn->tcp_be_liberal = nf_ct_tcp_be_liberal;
+	tn->tcp_max_retrans = nf_ct_tcp_max_retrans;
 }
 
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp =
@@ -1441,6 +1430,4 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp =
 		.nla_policy	= tcp_timeout_nla_policy,
 	},
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
-	.init_net		= tcp_init_net,
-	.get_net_proto		= tcp_get_net_proto,
 };
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 6e81e79844d7..951366dfbec3 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -260,25 +260,13 @@ udp_timeout_nla_policy[CTA_TIMEOUT_UDP_MAX+1] = {
 };
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
-
-static int udp_init_net(struct net *net)
+void nf_conntrack_udp_init_net(struct net *net)
 {
 	struct nf_udp_net *un = nf_udp_pernet(net);
-	struct nf_proto_net *pn = &un->pn;
-
-	if (!pn->users) {
-		int i;
-
-		for (i = 0; i < UDP_CT_MAX; i++)
-			un->timeouts[i] = udp_timeouts[i];
-	}
+	int i;
 
-	return 0;
-}
-
-static struct nf_proto_net *udp_get_net_proto(struct net *net)
-{
-	return &net->ct.nf_ct_proto.udp.pn;
+	for (i = 0; i < UDP_CT_MAX; i++)
+		un->timeouts[i] = udp_timeouts[i];
 }
 
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp =
@@ -300,8 +288,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp =
 		.nla_policy	= udp_timeout_nla_policy,
 	},
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
-	.init_net		= udp_init_net,
-	.get_net_proto		= udp_get_net_proto,
 };
 
 #ifdef CONFIG_NF_CT_PROTO_UDPLITE
@@ -324,7 +310,5 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite =
 		.nla_policy	= udp_timeout_nla_policy,
 	},
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
-	.init_net		= udp_init_net,
-	.get_net_proto		= udp_get_net_proto,
 };
 #endif
-- 
2.11.0
