From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/14] netfilter: conntrack: add nf_{tcp,udp,sctp,icmp,dccp,icmpv6,generic}_pernet()
Date: Tue,  6 Nov 2018 00:28:29 +0100
Message-ID: <20181105232832.21896-12-pablo@netfilter.org>
References: <20181105232832.21896-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181105232832.21896-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Expose these functions to access conntrack protocol tracker netns area,
nfnetlink_cttimeout needs this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h | 39 ++++++++++++++++++++++++++++
 net/netfilter/nf_conntrack_proto_dccp.c      | 13 +++-------
 net/netfilter/nf_conntrack_proto_generic.c   | 11 +++-----
 net/netfilter/nf_conntrack_proto_icmp.c      | 11 +++-----
 net/netfilter/nf_conntrack_proto_icmpv6.c    | 11 +++-----
 net/netfilter/nf_conntrack_proto_sctp.c      | 11 +++-----
 net/netfilter/nf_conntrack_proto_tcp.c       | 15 ++++-------
 net/netfilter/nf_conntrack_proto_udp.c       | 11 +++-----
 8 files changed, 63 insertions(+), 59 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index eed04af9b75e..ae7b86f587f2 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -153,4 +153,43 @@ void nf_ct_l4proto_log_invalid(const struct sk_buff *skb,
 			       const char *fmt, ...) { }
 #endif /* CONFIG_SYSCTL */
 
+static inline struct nf_generic_net *nf_generic_pernet(struct net *net)
+{
+       return &net->ct.nf_ct_proto.generic;
+}
+
+static inline struct nf_tcp_net *nf_tcp_pernet(struct net *net)
+{
+       return &net->ct.nf_ct_proto.tcp;
+}
+
+static inline struct nf_udp_net *nf_udp_pernet(struct net *net)
+{
+       return &net->ct.nf_ct_proto.udp;
+}
+
+static inline struct nf_icmp_net *nf_icmp_pernet(struct net *net)
+{
+       return &net->ct.nf_ct_proto.icmp;
+}
+
+static inline struct nf_icmp_net *nf_icmpv6_pernet(struct net *net)
+{
+       return &net->ct.nf_ct_proto.icmpv6;
+}
+
+#ifdef CONFIG_NF_CT_PROTO_DCCP
+static inline struct nf_dccp_net *nf_dccp_pernet(struct net *net)
+{
+       return &net->ct.nf_ct_proto.dccp;
+}
+#endif
+
+#ifdef CONFIG_NF_CT_PROTO_SCTP
+static inline struct nf_sctp_net *nf_sctp_pernet(struct net *net)
+{
+       return &net->ct.nf_ct_proto.sctp;
+}
+#endif
+
 #endif /*_NF_CONNTRACK_PROTOCOL_H*/
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 171e9e122e5f..023c1445bc39 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -384,11 +384,6 @@ dccp_state_table[CT_DCCP_ROLE_MAX + 1][DCCP_PKT_SYNCACK + 1][CT_DCCP_MAX + 1] =
 	},
 };
 
-static inline struct nf_dccp_net *dccp_pernet(struct net *net)
-{
-	return &net->ct.nf_ct_proto.dccp;
-}
-
 static noinline bool
 dccp_new(struct nf_conn *ct, const struct sk_buff *skb,
 	 const struct dccp_hdr *dh)
@@ -401,7 +396,7 @@ dccp_new(struct nf_conn *ct, const struct sk_buff *skb,
 	state = dccp_state_table[CT_DCCP_ROLE_CLIENT][dh->dccph_type][CT_DCCP_NONE];
 	switch (state) {
 	default:
-		dn = dccp_pernet(net);
+		dn = nf_dccp_pernet(net);
 		if (dn->dccp_loose == 0) {
 			msg = "not picking up existing connection ";
 			goto out_invalid;
@@ -568,7 +563,7 @@ static int dccp_packet(struct nf_conn *ct, struct sk_buff *skb,
 
 	timeouts = nf_ct_timeout_lookup(ct);
 	if (!timeouts)
-		timeouts = dccp_pernet(nf_ct_net(ct))->dccp_timeout;
+		timeouts = nf_dccp_pernet(nf_ct_net(ct))->dccp_timeout;
 	nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[new_state]);
 
 	return NF_ACCEPT;
@@ -681,7 +676,7 @@ static int nlattr_to_dccp(struct nlattr *cda[], struct nf_conn *ct)
 static int dccp_timeout_nlattr_to_obj(struct nlattr *tb[],
 				      struct net *net, void *data)
 {
-	struct nf_dccp_net *dn = dccp_pernet(net);
+	struct nf_dccp_net *dn = nf_dccp_pernet(net);
 	unsigned int *timeouts = data;
 	int i;
 
@@ -814,7 +809,7 @@ static int dccp_kmemdup_sysctl_table(struct net *net, struct nf_proto_net *pn,
 
 static int dccp_init_net(struct net *net)
 {
-	struct nf_dccp_net *dn = dccp_pernet(net);
+	struct nf_dccp_net *dn = nf_dccp_pernet(net);
 	struct nf_proto_net *pn = &dn->pn;
 
 	if (!pn->users) {
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index e10e867e0b55..5da19d5fbc76 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -27,11 +27,6 @@ static bool nf_generic_should_process(u8 proto)
 	}
 }
 
-static inline struct nf_generic_net *generic_pernet(struct net *net)
-{
-	return &net->ct.nf_ct_proto.generic;
-}
-
 static bool generic_pkt_to_tuple(const struct sk_buff *skb,
 				 unsigned int dataoff,
 				 struct net *net, struct nf_conntrack_tuple *tuple)
@@ -58,7 +53,7 @@ static int generic_packet(struct nf_conn *ct,
 	}
 
 	if (!timeout)
-		timeout = &generic_pernet(nf_ct_net(ct))->timeout;
+		timeout = &nf_generic_pernet(nf_ct_net(ct))->timeout;
 
 	nf_ct_refresh_acct(ct, ctinfo, skb, *timeout);
 	return NF_ACCEPT;
@@ -72,7 +67,7 @@ static int generic_packet(struct nf_conn *ct,
 static int generic_timeout_nlattr_to_obj(struct nlattr *tb[],
 					 struct net *net, void *data)
 {
-	struct nf_generic_net *gn = generic_pernet(net);
+	struct nf_generic_net *gn = nf_generic_pernet(net);
 	unsigned int *timeout = data;
 
 	if (!timeout)
@@ -138,7 +133,7 @@ static int generic_kmemdup_sysctl_table(struct nf_proto_net *pn,
 
 static int generic_init_net(struct net *net)
 {
-	struct nf_generic_net *gn = generic_pernet(net);
+	struct nf_generic_net *gn = nf_generic_pernet(net);
 	struct nf_proto_net *pn = &gn->pn;
 
 	gn->timeout = nf_ct_generic_timeout;
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index 3598520bd19b..de64d8a5fdfd 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -25,11 +25,6 @@
 
 static const unsigned int nf_ct_icmp_timeout = 30*HZ;
 
-static inline struct nf_icmp_net *icmp_pernet(struct net *net)
-{
-	return &net->ct.nf_ct_proto.icmp;
-}
-
 static bool icmp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
 			      struct net *net, struct nf_conntrack_tuple *tuple)
 {
@@ -103,7 +98,7 @@ static int icmp_packet(struct nf_conn *ct,
 	}
 
 	if (!timeout)
-		timeout = &icmp_pernet(nf_ct_net(ct))->timeout;
+		timeout = &nf_icmp_pernet(nf_ct_net(ct))->timeout;
 
 	nf_ct_refresh_acct(ct, ctinfo, skb, *timeout);
 	return NF_ACCEPT;
@@ -275,7 +270,7 @@ static int icmp_timeout_nlattr_to_obj(struct nlattr *tb[],
 				      struct net *net, void *data)
 {
 	unsigned int *timeout = data;
-	struct nf_icmp_net *in = icmp_pernet(net);
+	struct nf_icmp_net *in = nf_icmp_pernet(net);
 
 	if (tb[CTA_TIMEOUT_ICMP_TIMEOUT]) {
 		if (!timeout)
@@ -337,7 +332,7 @@ static int icmp_kmemdup_sysctl_table(struct nf_proto_net *pn,
 
 static int icmp_init_net(struct net *net)
 {
-	struct nf_icmp_net *in = icmp_pernet(net);
+	struct nf_icmp_net *in = nf_icmp_pernet(net);
 	struct nf_proto_net *pn = &in->pn;
 
 	in->timeout = nf_ct_icmp_timeout;
diff --git a/net/netfilter/nf_conntrack_proto_icmpv6.c b/net/netfilter/nf_conntrack_proto_icmpv6.c
index 378618feed5d..a15eefb8e317 100644
--- a/net/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/netfilter/nf_conntrack_proto_icmpv6.c
@@ -30,11 +30,6 @@
 
 static const unsigned int nf_ct_icmpv6_timeout = 30*HZ;
 
-static inline struct nf_icmp_net *icmpv6_pernet(struct net *net)
-{
-	return &net->ct.nf_ct_proto.icmpv6;
-}
-
 static bool icmpv6_pkt_to_tuple(const struct sk_buff *skb,
 				unsigned int dataoff,
 				struct net *net,
@@ -87,7 +82,7 @@ static bool icmpv6_invert_tuple(struct nf_conntrack_tuple *tuple,
 
 static unsigned int *icmpv6_get_timeouts(struct net *net)
 {
-	return &icmpv6_pernet(net)->timeout;
+	return &nf_icmpv6_pernet(net)->timeout;
 }
 
 /* Returns verdict for packet, or -1 for invalid. */
@@ -286,7 +281,7 @@ static int icmpv6_timeout_nlattr_to_obj(struct nlattr *tb[],
 					struct net *net, void *data)
 {
 	unsigned int *timeout = data;
-	struct nf_icmp_net *in = icmpv6_pernet(net);
+	struct nf_icmp_net *in = nf_icmpv6_pernet(net);
 
 	if (!timeout)
 		timeout = icmpv6_get_timeouts(net);
@@ -348,7 +343,7 @@ static int icmpv6_kmemdup_sysctl_table(struct nf_proto_net *pn,
 
 static int icmpv6_init_net(struct net *net)
 {
-	struct nf_icmp_net *in = icmpv6_pernet(net);
+	struct nf_icmp_net *in = nf_icmpv6_pernet(net);
 	struct nf_proto_net *pn = &in->pn;
 
 	in->timeout = nf_ct_icmpv6_timeout;
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 3d719d3eb9a3..d53e3e78f605 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -146,11 +146,6 @@ static const u8 sctp_conntracks[2][11][SCTP_CONNTRACK_MAX] = {
 	}
 };
 
-static inline struct nf_sctp_net *sctp_pernet(struct net *net)
-{
-	return &net->ct.nf_ct_proto.sctp;
-}
-
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 /* Print out the private part of the conntrack. */
 static void sctp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
@@ -480,7 +475,7 @@ static int sctp_packet(struct nf_conn *ct,
 
 	timeouts = nf_ct_timeout_lookup(ct);
 	if (!timeouts)
-		timeouts = sctp_pernet(nf_ct_net(ct))->timeouts;
+		timeouts = nf_sctp_pernet(nf_ct_net(ct))->timeouts;
 
 	nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[new_state]);
 
@@ -599,7 +594,7 @@ static int sctp_timeout_nlattr_to_obj(struct nlattr *tb[],
 				      struct net *net, void *data)
 {
 	unsigned int *timeouts = data;
-	struct nf_sctp_net *sn = sctp_pernet(net);
+	struct nf_sctp_net *sn = nf_sctp_pernet(net);
 	int i;
 
 	/* set default SCTP timeouts. */
@@ -736,7 +731,7 @@ static int sctp_kmemdup_sysctl_table(struct nf_proto_net *pn,
 
 static int sctp_init_net(struct net *net)
 {
-	struct nf_sctp_net *sn = sctp_pernet(net);
+	struct nf_sctp_net *sn = nf_sctp_pernet(net);
 	struct nf_proto_net *pn = &sn->pn;
 
 	if (!pn->users) {
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 1bcf9984d45e..4dcbd51a8e97 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -272,11 +272,6 @@ static const u8 tcp_conntracks[2][6][TCP_CONNTRACK_MAX] = {
 	}
 };
 
-static inline struct nf_tcp_net *tcp_pernet(struct net *net)
-{
-	return &net->ct.nf_ct_proto.tcp;
-}
-
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 /* Print out the private part of the conntrack. */
 static void tcp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
@@ -475,7 +470,7 @@ static bool tcp_in_window(const struct nf_conn *ct,
 			  const struct tcphdr *tcph)
 {
 	struct net *net = nf_ct_net(ct);
-	struct nf_tcp_net *tn = tcp_pernet(net);
+	struct nf_tcp_net *tn = nf_tcp_pernet(net);
 	struct ip_ct_tcp_state *sender = &state->seen[dir];
 	struct ip_ct_tcp_state *receiver = &state->seen[!dir];
 	const struct nf_conntrack_tuple *tuple = &ct->tuplehash[dir].tuple;
@@ -767,7 +762,7 @@ static noinline bool tcp_new(struct nf_conn *ct, const struct sk_buff *skb,
 {
 	enum tcp_conntrack new_state;
 	struct net *net = nf_ct_net(ct);
-	const struct nf_tcp_net *tn = tcp_pernet(net);
+	const struct nf_tcp_net *tn = nf_tcp_pernet(net);
 	const struct ip_ct_tcp_state *sender = &ct->proto.tcp.seen[0];
 	const struct ip_ct_tcp_state *receiver = &ct->proto.tcp.seen[1];
 
@@ -841,7 +836,7 @@ static int tcp_packet(struct nf_conn *ct,
 		      const struct nf_hook_state *state)
 {
 	struct net *net = nf_ct_net(ct);
-	struct nf_tcp_net *tn = tcp_pernet(net);
+	struct nf_tcp_net *tn = nf_tcp_pernet(net);
 	struct nf_conntrack_tuple *tuple;
 	enum tcp_conntrack new_state, old_state;
 	unsigned int index, *timeouts;
@@ -1283,7 +1278,7 @@ static unsigned int tcp_nlattr_tuple_size(void)
 static int tcp_timeout_nlattr_to_obj(struct nlattr *tb[],
 				     struct net *net, void *data)
 {
-	struct nf_tcp_net *tn = tcp_pernet(net);
+	struct nf_tcp_net *tn = nf_tcp_pernet(net);
 	unsigned int *timeouts = data;
 	int i;
 
@@ -1508,7 +1503,7 @@ static int tcp_kmemdup_sysctl_table(struct nf_proto_net *pn,
 
 static int tcp_init_net(struct net *net)
 {
-	struct nf_tcp_net *tn = tcp_pernet(net);
+	struct nf_tcp_net *tn = nf_tcp_pernet(net);
 	struct nf_proto_net *pn = &tn->pn;
 
 	if (!pn->users) {
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index a7aa70370913..c879d8d78cfd 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -32,14 +32,9 @@ static const unsigned int udp_timeouts[UDP_CT_MAX] = {
 	[UDP_CT_REPLIED]	= 180*HZ,
 };
 
-static inline struct nf_udp_net *udp_pernet(struct net *net)
-{
-	return &net->ct.nf_ct_proto.udp;
-}
-
 static unsigned int *udp_get_timeouts(struct net *net)
 {
-	return udp_pernet(net)->timeouts;
+	return nf_udp_pernet(net)->timeouts;
 }
 
 static void udp_error_log(const struct sk_buff *skb,
@@ -212,7 +207,7 @@ static int udp_timeout_nlattr_to_obj(struct nlattr *tb[],
 				     struct net *net, void *data)
 {
 	unsigned int *timeouts = data;
-	struct nf_udp_net *un = udp_pernet(net);
+	struct nf_udp_net *un = nf_udp_pernet(net);
 
 	if (!timeouts)
 		timeouts = un->timeouts;
@@ -292,7 +287,7 @@ static int udp_kmemdup_sysctl_table(struct nf_proto_net *pn,
 
 static int udp_init_net(struct net *net)
 {
-	struct nf_udp_net *un = udp_pernet(net);
+	struct nf_udp_net *un = nf_udp_pernet(net);
 	struct nf_proto_net *pn = &un->pn;
 
 	if (!pn->users) {
-- 
2.11.0
