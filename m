From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 18/31] netfilter: conntrack: remove error callback and handle icmp from core
Date: Tue,  9 Oct 2018 01:01:12 +0200
Message-ID: <20181008230125.2330-19-pablo@netfilter.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

icmp(v6) are the only two layer four protocols that need the error()
callback (to handle icmp errors that are related to an established
connections, e.g. packet too big, port unreachable and the like).

Remove the error callback and handle these two special cases from the core.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h | 13 ++++++---
 net/netfilter/nf_conntrack_core.c            | 43 +++++++++++++++++++++++-----
 net/netfilter/nf_conntrack_proto_icmp.c      |  8 ++----
 net/netfilter/nf_conntrack_proto_icmpv6.c    | 10 +++----
 4 files changed, 52 insertions(+), 22 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 39f0c84f71b9..7fdb4b95bba4 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -51,10 +51,6 @@ struct nf_conntrack_l4proto {
 	/* Called when a conntrack entry is destroyed */
 	void (*destroy)(struct nf_conn *ct);
 
-	int (*error)(struct nf_conn *tmpl, struct sk_buff *skb,
-		     unsigned int dataoff,
-		     const struct nf_hook_state *state);
-
 	/* called by gc worker if table is full */
 	bool (*can_early_drop)(const struct nf_conn *ct);
 
@@ -97,6 +93,15 @@ struct nf_conntrack_l4proto {
 	struct module *me;
 };
 
+int nf_conntrack_icmpv4_error(struct nf_conn *tmpl,
+			      struct sk_buff *skb,
+			      unsigned int dataoff,
+			      const struct nf_hook_state *state);
+
+int nf_conntrack_icmpv6_error(struct nf_conn *tmpl,
+			      struct sk_buff *skb,
+			      unsigned int dataoff,
+			      const struct nf_hook_state *state);
 /* Existing built-in generic protocol */
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic;
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index dccc96e94d7c..087bf63826fb 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1486,6 +1486,39 @@ resolve_normal_ct(struct nf_conn *tmpl,
 	return 0;
 }
 
+/*
+ * icmp packets need special treatment to handle error messages that are
+ * related to a connection.
+ *
+ * Callers need to check if skb has a conntrack assigned when this
+ * helper returns; in such case skb belongs to an already known connection.
+ */
+static unsigned int __cold
+nf_conntrack_handle_icmp(struct nf_conn *tmpl,
+			 struct sk_buff *skb,
+			 unsigned int dataoff,
+			 u8 protonum,
+			 const struct nf_hook_state *state)
+{
+	int ret;
+
+	if (state->pf == NFPROTO_IPV4 && protonum == IPPROTO_ICMP)
+		ret = nf_conntrack_icmpv4_error(tmpl, skb, dataoff, state);
+#if IS_ENABLED(CONFIG_IPV6)
+	else if (state->pf == NFPROTO_IPV6 && protonum == IPPROTO_ICMPV6)
+		ret = nf_conntrack_icmpv6_error(tmpl, skb, dataoff, state);
+#endif
+	else
+		return NF_ACCEPT;
+
+	if (ret <= 0) {
+		NF_CT_STAT_INC_ATOMIC(state->net, error);
+		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
+	}
+
+	return ret;
+}
+
 unsigned int
 nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 {
@@ -1518,14 +1551,10 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 
 	l4proto = __nf_ct_l4proto_find(state->pf, protonum);
 
-	/* It may be an special packet, error, unclean...
-	 * inverse of the return code tells to the netfilter
-	 * core what to do with the packet. */
-	if (l4proto->error != NULL) {
-		ret = l4proto->error(tmpl, skb, dataoff, state);
+	if (protonum == IPPROTO_ICMP || protonum == IPPROTO_ICMPV6) {
+		ret = nf_conntrack_handle_icmp(tmpl, skb, dataoff,
+					       protonum, state);
 		if (ret <= 0) {
-			NF_CT_STAT_INC_ATOMIC(state->net, error);
-			NF_CT_STAT_INC_ATOMIC(state->net, invalid);
 			ret = -ret;
 			goto out;
 		}
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index a2ca3a739aa3..2c981622b674 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -165,10 +165,9 @@ static void icmp_error_log(const struct sk_buff *skb,
 }
 
 /* Small and modified version of icmp_rcv */
-static int
-icmp_error(struct nf_conn *tmpl,
-	   struct sk_buff *skb, unsigned int dataoff,
-	   const struct nf_hook_state *state)
+int nf_conntrack_icmpv4_error(struct nf_conn *tmpl,
+			      struct sk_buff *skb, unsigned int dataoff,
+			      const struct nf_hook_state *state)
 {
 	const struct icmphdr *icmph;
 	struct icmphdr _ih;
@@ -355,7 +354,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp =
 	.pkt_to_tuple		= icmp_pkt_to_tuple,
 	.invert_tuple		= icmp_invert_tuple,
 	.packet			= icmp_packet,
-	.error			= icmp_error,
 	.destroy		= NULL,
 	.me			= NULL,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
diff --git a/net/netfilter/nf_conntrack_proto_icmpv6.c b/net/netfilter/nf_conntrack_proto_icmpv6.c
index a1933566d53d..effac451c7e0 100644
--- a/net/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/netfilter/nf_conntrack_proto_icmpv6.c
@@ -184,11 +184,10 @@ static void icmpv6_error_log(const struct sk_buff *skb,
 			       IPPROTO_ICMPV6, "%s", msg);
 }
 
-static int
-icmpv6_error(struct nf_conn *tmpl,
-	     struct sk_buff *skb,
-	     unsigned int dataoff,
-	     const struct nf_hook_state *state)
+int nf_conntrack_icmpv6_error(struct nf_conn *tmpl,
+			      struct sk_buff *skb,
+			      unsigned int dataoff,
+			      const struct nf_hook_state *state)
 {
 	const struct icmp6hdr *icmp6h;
 	struct icmp6hdr _ih;
@@ -366,7 +365,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6 =
 	.pkt_to_tuple		= icmpv6_pkt_to_tuple,
 	.invert_tuple		= icmpv6_invert_tuple,
 	.packet			= icmpv6_packet,
-	.error			= icmpv6_error,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.tuple_to_nlattr	= icmpv6_tuple_to_nlattr,
 	.nlattr_tuple_size	= icmpv6_nlattr_tuple_size,
-- 
2.11.0
