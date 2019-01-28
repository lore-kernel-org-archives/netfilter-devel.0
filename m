From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 15/33] netfilter: conntrack: remove remaining l4proto indirect packet calls
Date: Tue, 29 Jan 2019 00:57:32 +0100
Message-ID: <20190128235750.18412-16-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Now that all l4trackers are builtin, no need to use a mix of direct and
indirect calls.
This removes the last two users: gre and the generic l4 protocol
tracker.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h | 12 ++++------
 net/netfilter/nf_conntrack_core.c            | 26 +++++++++++++++------
 net/netfilter/nf_conntrack_proto_generic.c   | 35 ----------------------------
 net/netfilter/nf_conntrack_proto_gre.c       | 11 ++++-----
 4 files changed, 29 insertions(+), 55 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index fd8954429e87..dda028996559 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -27,13 +27,6 @@ struct nf_conntrack_l4proto {
 	/* protoinfo nlattr size, closes a hole */
 	u16 nlattr_size;
 
-	/* Returns verdict for packet, or -1 for invalid. */
-	int (*packet)(struct nf_conn *ct,
-		      struct sk_buff *skb,
-		      unsigned int dataoff,
-		      enum ip_conntrack_info ctinfo,
-		      const struct nf_hook_state *state);
-
 	/* Called when a conntrack entry is destroyed */
 	void (*destroy)(struct nf_conn *ct);
 
@@ -136,6 +129,11 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 			     unsigned int dataoff,
 			     enum ip_conntrack_info ctinfo,
 			     const struct nf_hook_state *state);
+int nf_conntrack_gre_packet(struct nf_conn *ct,
+			    struct sk_buff *skb,
+			    unsigned int dataoff,
+			    enum ip_conntrack_info ctinfo,
+			    const struct nf_hook_state *state);
 
 /* Existing built-in generic protocol */
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d56cb0fc82b6..264074f04615 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1534,6 +1534,18 @@ nf_conntrack_handle_icmp(struct nf_conn *tmpl,
 	return ret;
 }
 
+static int generic_packet(struct nf_conn *ct, struct sk_buff *skb,
+			  enum ip_conntrack_info ctinfo)
+{
+	const unsigned int *timeout = nf_ct_timeout_lookup(ct);
+
+	if (!timeout)
+		timeout = &nf_generic_pernet(nf_ct_net(ct))->timeout;
+
+	nf_ct_refresh_acct(ct, ctinfo, skb, *timeout);
+	return NF_ACCEPT;
+}
+
 /* Returns verdict for packet, or -1 for invalid. */
 static int nf_conntrack_handle_packet(struct nf_conn *ct,
 				      struct sk_buff *skb,
@@ -1567,10 +1579,14 @@ static int nf_conntrack_handle_packet(struct nf_conn *ct,
 		return nf_conntrack_dccp_packet(ct, skb, dataoff,
 						ctinfo, state);
 #endif
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	case IPPROTO_GRE:
+		return nf_conntrack_gre_packet(ct, skb, dataoff,
+					       ctinfo, state);
+#endif
 	}
 
-	WARN_ON_ONCE(1);
-	return -NF_ACCEPT;
+	return generic_packet(ct, skb, ctinfo);
 }
 
 unsigned int
@@ -1634,11 +1650,7 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 		goto out;
 	}
 
-	if (l4proto->packet)
-		ret = l4proto->packet(ct, skb, dataoff, ctinfo, state);
-	else
-		ret = nf_conntrack_handle_packet(ct, skb, dataoff, ctinfo, state);
-
+	ret = nf_conntrack_handle_packet(ct, skb, dataoff, ctinfo, state);
 	if (ret <= 0) {
 		/* Invalid: inverse of the return code tells
 		 * the netfilter core what to do */
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index 5a5bf7cb6508..78358d192c60 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -15,40 +15,6 @@
 
 static const unsigned int nf_ct_generic_timeout = 600*HZ;
 
-static bool nf_generic_should_process(u8 proto)
-{
-	switch (proto) {
-#ifdef CONFIG_NF_CT_PROTO_GRE_MODULE
-	case IPPROTO_GRE:
-		return false;
-#endif
-	default:
-		return true;
-	}
-}
-
-/* Returns verdict for packet, or -1 for invalid. */
-static int generic_packet(struct nf_conn *ct,
-			  struct sk_buff *skb,
-			  unsigned int dataoff,
-			  enum ip_conntrack_info ctinfo,
-			  const struct nf_hook_state *state)
-{
-	const unsigned int *timeout = nf_ct_timeout_lookup(ct);
-
-	if (!nf_generic_should_process(nf_ct_protonum(ct))) {
-		pr_warn_once("conntrack: generic helper won't handle protocol %d. Please consider loading the specific helper module.\n",
-			     nf_ct_protonum(ct));
-		return -NF_ACCEPT;
-	}
-
-	if (!timeout)
-		timeout = &nf_generic_pernet(nf_ct_net(ct))->timeout;
-
-	nf_ct_refresh_acct(ct, ctinfo, skb, *timeout);
-	return NF_ACCEPT;
-}
-
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 
 #include <linux/netfilter/nfnetlink.h>
@@ -139,7 +105,6 @@ static struct nf_proto_net *generic_get_net_proto(struct net *net)
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic =
 {
 	.l4proto		= 255,
-	.packet			= generic_packet,
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	.ctnl_timeout		= {
 		.nlattr_to_obj	= generic_timeout_nlattr_to_obj,
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 0c26cfd5d29f..f6391991bcf6 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -213,11 +213,11 @@ static unsigned int *gre_get_timeouts(struct net *net)
 }
 
 /* Returns verdict for packet, and may modify conntrack */
-static int gre_packet(struct nf_conn *ct,
-		      struct sk_buff *skb,
-		      unsigned int dataoff,
-		      enum ip_conntrack_info ctinfo,
-		      const struct nf_hook_state *state)
+int nf_conntrack_gre_packet(struct nf_conn *ct,
+			    struct sk_buff *skb,
+			    unsigned int dataoff,
+			    enum ip_conntrack_info ctinfo,
+			    const struct nf_hook_state *state)
 {
 	if (state->pf != NFPROTO_IPV4)
 		return -NF_ACCEPT;
@@ -371,7 +371,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_gre = {
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 	.print_conntrack = gre_print_conntrack,
 #endif
-	.packet		 = gre_packet,
 	.destroy	 = gre_destroy,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.tuple_to_nlattr = nf_ct_port_tuple_to_nlattr,
-- 
2.11.0
