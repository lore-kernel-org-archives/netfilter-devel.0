From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 07/33] netfilter: conntrack: handle builtin l4proto packet functions via direct calls
Date: Tue, 29 Jan 2019 00:57:24 +0100
Message-ID: <20190128235750.18412-8-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The l4 protocol trackers are invoked via indirect call: l4proto->packet().

With one exception (gre), all l4trackers are builtin, so we can make
.packet optional and use a direct call for most protocols.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h | 37 +++++++++++++++++++++++
 net/netfilter/nf_conntrack_core.c            | 45 +++++++++++++++++++++++++++-
 net/netfilter/nf_conntrack_proto_dccp.c      |  8 ++---
 net/netfilter/nf_conntrack_proto_icmp.c      | 12 +++-----
 net/netfilter/nf_conntrack_proto_icmpv6.c    | 10 +++----
 net/netfilter/nf_conntrack_proto_sctp.c      | 12 ++++----
 net/netfilter/nf_conntrack_proto_tcp.c       | 11 ++++---
 net/netfilter/nf_conntrack_proto_udp.c       | 22 +++++++-------
 8 files changed, 113 insertions(+), 44 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index ae7b86f587f2..6ca4355ae3dc 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -99,6 +99,43 @@ int nf_conntrack_icmpv6_error(struct nf_conn *tmpl,
 			      struct sk_buff *skb,
 			      unsigned int dataoff,
 			      const struct nf_hook_state *state);
+
+int nf_conntrack_icmp_packet(struct nf_conn *ct,
+			     struct sk_buff *skb,
+			     enum ip_conntrack_info ctinfo,
+			     const struct nf_hook_state *state);
+
+int nf_conntrack_icmpv6_packet(struct nf_conn *ct,
+			       struct sk_buff *skb,
+			       enum ip_conntrack_info ctinfo,
+			       const struct nf_hook_state *state);
+
+int nf_conntrack_udp_packet(struct nf_conn *ct,
+			    struct sk_buff *skb,
+			    unsigned int dataoff,
+			    enum ip_conntrack_info ctinfo,
+			    const struct nf_hook_state *state);
+int nf_conntrack_udplite_packet(struct nf_conn *ct,
+				struct sk_buff *skb,
+				unsigned int dataoff,
+				enum ip_conntrack_info ctinfo,
+				const struct nf_hook_state *state);
+int nf_conntrack_tcp_packet(struct nf_conn *ct,
+			    struct sk_buff *skb,
+			    unsigned int dataoff,
+			    enum ip_conntrack_info ctinfo,
+			    const struct nf_hook_state *state);
+int nf_conntrack_dccp_packet(struct nf_conn *ct,
+			     struct sk_buff *skb,
+			     unsigned int dataoff,
+			     enum ip_conntrack_info ctinfo,
+			     const struct nf_hook_state *state);
+int nf_conntrack_sctp_packet(struct nf_conn *ct,
+			     struct sk_buff *skb,
+			     unsigned int dataoff,
+			     enum ip_conntrack_info ctinfo,
+			     const struct nf_hook_state *state);
+
 /* Existing built-in generic protocol */
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic;
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 741b533148ba..5dfd95ae510d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1522,6 +1522,45 @@ nf_conntrack_handle_icmp(struct nf_conn *tmpl,
 	return ret;
 }
 
+/* Returns verdict for packet, or -1 for invalid. */
+static int nf_conntrack_handle_packet(struct nf_conn *ct,
+				      struct sk_buff *skb,
+				      unsigned int dataoff,
+				      enum ip_conntrack_info ctinfo,
+				      const struct nf_hook_state *state)
+{
+	switch (nf_ct_protonum(ct)) {
+	case IPPROTO_TCP:
+		return nf_conntrack_tcp_packet(ct, skb, dataoff,
+					       ctinfo, state);
+	case IPPROTO_UDP:
+		return nf_conntrack_udp_packet(ct, skb, dataoff,
+					       ctinfo, state);
+	case IPPROTO_ICMP:
+		return nf_conntrack_icmp_packet(ct, skb, ctinfo, state);
+	case IPPROTO_ICMPV6:
+		return nf_conntrack_icmpv6_packet(ct, skb, ctinfo, state);
+#ifdef CONFIG_NF_CT_PROTO_UDPLITE
+	case IPPROTO_UDPLITE:
+		return nf_conntrack_udplite_packet(ct, skb, dataoff,
+						   ctinfo, state);
+#endif
+#ifdef CONFIG_NF_CT_PROTO_SCTP
+	case IPPROTO_SCTP:
+		return nf_conntrack_sctp_packet(ct, skb, dataoff,
+						ctinfo, state);
+#endif
+#ifdef CONFIG_NF_CT_PROTO_DCCP
+	case IPPROTO_DCCP:
+		return nf_conntrack_dccp_packet(ct, skb, dataoff,
+						ctinfo, state);
+#endif
+	}
+
+	WARN_ON_ONCE(1);
+	return -NF_ACCEPT;
+}
+
 unsigned int
 nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 {
@@ -1583,7 +1622,11 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 		goto out;
 	}
 
-	ret = l4proto->packet(ct, skb, dataoff, ctinfo, state);
+	if (l4proto->packet)
+		ret = l4proto->packet(ct, skb, dataoff, ctinfo, state);
+	else
+		ret = nf_conntrack_handle_packet(ct, skb, dataoff, ctinfo, state);
+
 	if (ret <= 0) {
 		/* Invalid: inverse of the return code tells
 		 * the netfilter core what to do */
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 023c1445bc39..84408ec80624 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -472,9 +472,10 @@ static bool dccp_error(const struct dccp_hdr *dh,
 	return true;
 }
 
-static int dccp_packet(struct nf_conn *ct, struct sk_buff *skb,
-		       unsigned int dataoff, enum ip_conntrack_info ctinfo,
-		       const struct nf_hook_state *state)
+int nf_conntrack_dccp_packet(struct nf_conn *ct, struct sk_buff *skb,
+			     unsigned int dataoff,
+			     enum ip_conntrack_info ctinfo,
+			     const struct nf_hook_state *state)
 {
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 	struct dccp_hdr _dh, *dh;
@@ -839,7 +840,6 @@ static struct nf_proto_net *dccp_get_net_proto(struct net *net)
 
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp = {
 	.l4proto		= IPPROTO_DCCP,
-	.packet			= dccp_packet,
 	.can_early_drop		= dccp_can_early_drop,
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 	.print_conntrack	= dccp_print_conntrack,
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index de64d8a5fdfd..381a7f3ea68a 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -68,11 +68,10 @@ static bool icmp_invert_tuple(struct nf_conntrack_tuple *tuple,
 }
 
 /* Returns verdict for packet, or -1 for invalid. */
-static int icmp_packet(struct nf_conn *ct,
-		       struct sk_buff *skb,
-		       unsigned int dataoff,
-		       enum ip_conntrack_info ctinfo,
-		       const struct nf_hook_state *state)
+int nf_conntrack_icmp_packet(struct nf_conn *ct,
+			     struct sk_buff *skb,
+			     enum ip_conntrack_info ctinfo,
+			     const struct nf_hook_state *state)
 {
 	/* Do not immediately delete the connection after the first
 	   successful reply to avoid excessive conntrackd traffic
@@ -350,9 +349,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp =
 	.l4proto		= IPPROTO_ICMP,
 	.pkt_to_tuple		= icmp_pkt_to_tuple,
 	.invert_tuple		= icmp_invert_tuple,
-	.packet			= icmp_packet,
-	.destroy		= NULL,
-	.me			= NULL,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.tuple_to_nlattr	= icmp_tuple_to_nlattr,
 	.nlattr_tuple_size	= icmp_nlattr_tuple_size,
diff --git a/net/netfilter/nf_conntrack_proto_icmpv6.c b/net/netfilter/nf_conntrack_proto_icmpv6.c
index a15eefb8e317..93f27d0bcb75 100644
--- a/net/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/netfilter/nf_conntrack_proto_icmpv6.c
@@ -86,11 +86,10 @@ static unsigned int *icmpv6_get_timeouts(struct net *net)
 }
 
 /* Returns verdict for packet, or -1 for invalid. */
-static int icmpv6_packet(struct nf_conn *ct,
-		         struct sk_buff *skb,
-		         unsigned int dataoff,
-		         enum ip_conntrack_info ctinfo,
-		         const struct nf_hook_state *state)
+int nf_conntrack_icmpv6_packet(struct nf_conn *ct,
+			       struct sk_buff *skb,
+			       enum ip_conntrack_info ctinfo,
+			       const struct nf_hook_state *state)
 {
 	unsigned int *timeout = nf_ct_timeout_lookup(ct);
 	static const u8 valid_new[] = {
@@ -361,7 +360,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6 =
 	.l4proto		= IPPROTO_ICMPV6,
 	.pkt_to_tuple		= icmpv6_pkt_to_tuple,
 	.invert_tuple		= icmpv6_invert_tuple,
-	.packet			= icmpv6_packet,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.tuple_to_nlattr	= icmpv6_tuple_to_nlattr,
 	.nlattr_tuple_size	= icmpv6_nlattr_tuple_size,
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index d53e3e78f605..952f2cc0fd74 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -357,11 +357,11 @@ static bool sctp_error(struct sk_buff *skb,
 }
 
 /* Returns verdict for packet, or -NF_ACCEPT for invalid. */
-static int sctp_packet(struct nf_conn *ct,
-		       struct sk_buff *skb,
-		       unsigned int dataoff,
-		       enum ip_conntrack_info ctinfo,
-		       const struct nf_hook_state *state)
+int nf_conntrack_sctp_packet(struct nf_conn *ct,
+			     struct sk_buff *skb,
+			     unsigned int dataoff,
+			     enum ip_conntrack_info ctinfo,
+			     const struct nf_hook_state *state)
 {
 	enum sctp_conntrack new_state, old_state;
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
@@ -759,9 +759,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp = {
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 	.print_conntrack	= sctp_print_conntrack,
 #endif
-	.packet 		= sctp_packet,
 	.can_early_drop		= sctp_can_early_drop,
-	.me 			= THIS_MODULE,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_size		= SCTP_NLATTR_SIZE,
 	.to_nlattr		= sctp_to_nlattr,
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 4dcbd51a8e97..32aac9a835d4 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -829,11 +829,11 @@ static noinline bool tcp_new(struct nf_conn *ct, const struct sk_buff *skb,
 }
 
 /* Returns verdict for packet, or -1 for invalid. */
-static int tcp_packet(struct nf_conn *ct,
-		      struct sk_buff *skb,
-		      unsigned int dataoff,
-		      enum ip_conntrack_info ctinfo,
-		      const struct nf_hook_state *state)
+int nf_conntrack_tcp_packet(struct nf_conn *ct,
+			    struct sk_buff *skb,
+			    unsigned int dataoff,
+			    enum ip_conntrack_info ctinfo,
+			    const struct nf_hook_state *state)
 {
 	struct net *net = nf_ct_net(ct);
 	struct nf_tcp_net *tn = nf_tcp_pernet(net);
@@ -1535,7 +1535,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp =
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 	.print_conntrack 	= tcp_print_conntrack,
 #endif
-	.packet 		= tcp_packet,
 	.can_early_drop		= tcp_can_early_drop,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.to_nlattr		= tcp_to_nlattr,
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index b4f5d5e82031..e1f409aa0006 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -85,11 +85,11 @@ static bool udp_error(struct sk_buff *skb,
 }
 
 /* Returns verdict for packet, and may modify conntracktype */
-static int udp_packet(struct nf_conn *ct,
-		      struct sk_buff *skb,
-		      unsigned int dataoff,
-		      enum ip_conntrack_info ctinfo,
-		      const struct nf_hook_state *state)
+int nf_conntrack_udp_packet(struct nf_conn *ct,
+			    struct sk_buff *skb,
+			    unsigned int dataoff,
+			    enum ip_conntrack_info ctinfo,
+			    const struct nf_hook_state *state)
 {
 	unsigned int *timeouts;
 
@@ -177,11 +177,11 @@ static bool udplite_error(struct sk_buff *skb,
 }
 
 /* Returns verdict for packet, and may modify conntracktype */
-static int udplite_packet(struct nf_conn *ct,
-			  struct sk_buff *skb,
-			  unsigned int dataoff,
-			  enum ip_conntrack_info ctinfo,
-			  const struct nf_hook_state *state)
+int nf_conntrack_udplite_packet(struct nf_conn *ct,
+				struct sk_buff *skb,
+				unsigned int dataoff,
+				enum ip_conntrack_info ctinfo,
+				const struct nf_hook_state *state)
 {
 	unsigned int *timeouts;
 
@@ -319,7 +319,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp =
 {
 	.l4proto		= IPPROTO_UDP,
 	.allow_clash		= true,
-	.packet			= udp_packet,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
@@ -344,7 +343,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite =
 {
 	.l4proto		= IPPROTO_UDPLITE,
 	.allow_clash		= true,
-	.packet			= udplite_packet,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
-- 
2.11.0
