From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 04/33] netfilter: conntrack: remove helper hook again
Date: Tue, 29 Jan 2019 00:57:21 +0100
Message-ID: <20190128235750.18412-5-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

place them into the confirm one.

Old:
 hook (300): ipv4/6_help() first call helper, then seqadj.
 hook (INT_MAX): confirm

Now:
 hook (INT_MAX): confirm, first call helper, then seqadj, then confirm

Not having the extra call is noticeable in bechmarks.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto.c | 142 ++++++++++---------------------------
 1 file changed, 36 insertions(+), 106 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 859f5d07a915..2bbc32d939e4 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -364,55 +364,55 @@ void nf_ct_l4proto_pernet_unregister(struct net *net,
 }
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_pernet_unregister);
 
-static unsigned int ipv4_helper(void *priv,
-				struct sk_buff *skb,
-				const struct nf_hook_state *state)
+static unsigned int nf_confirm(struct sk_buff *skb,
+			       unsigned int protoff,
+			       struct nf_conn *ct,
+			       enum ip_conntrack_info ctinfo)
 {
-	struct nf_conn *ct;
-	enum ip_conntrack_info ctinfo;
 	const struct nf_conn_help *help;
-	const struct nf_conntrack_helper *helper;
-
-	/* This is where we call the helper: as the packet goes out. */
-	ct = nf_ct_get(skb, &ctinfo);
-	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
-		return NF_ACCEPT;
 
 	help = nfct_help(ct);
-	if (!help)
-		return NF_ACCEPT;
+	if (help) {
+		const struct nf_conntrack_helper *helper;
+		int ret;
+
+		/* rcu_read_lock()ed by nf_hook_thresh */
+		helper = rcu_dereference(help->helper);
+		if (helper) {
+			ret = helper->help(skb,
+					   protoff,
+					   ct, ctinfo);
+			if (ret != NF_ACCEPT)
+				return ret;
+		}
+	}
 
-	/* rcu_read_lock()ed by nf_hook_thresh */
-	helper = rcu_dereference(help->helper);
-	if (!helper)
-		return NF_ACCEPT;
+	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
+	    !nf_is_loopback_packet(skb)) {
+		if (!nf_ct_seq_adjust(skb, ct, ctinfo, protoff)) {
+			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
+			return NF_DROP;
+		}
+	}
 
-	return helper->help(skb, skb_network_offset(skb) + ip_hdrlen(skb),
-			    ct, ctinfo);
+	/* We've seen it coming out the other side: confirm it */
+	return nf_conntrack_confirm(skb);
 }
 
 static unsigned int ipv4_confirm(void *priv,
 				 struct sk_buff *skb,
 				 const struct nf_hook_state *state)
 {
-	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
-		goto out;
+		return nf_conntrack_confirm(skb);
 
-	/* adjust seqs for loopback traffic only in outgoing direction */
-	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
-	    !nf_is_loopback_packet(skb)) {
-		if (!nf_ct_seq_adjust(skb, ct, ctinfo, ip_hdrlen(skb))) {
-			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
-			return NF_DROP;
-		}
-	}
-out:
-	/* We've seen it coming out the other side: confirm it */
-	return nf_conntrack_confirm(skb);
+	return nf_confirm(skb,
+			  skb_network_offset(skb) + ip_hdrlen(skb),
+			  ct, ctinfo);
 }
 
 static unsigned int ipv4_conntrack_in(void *priv,
@@ -461,24 +461,12 @@ static const struct nf_hook_ops ipv4_conntrack_ops[] = {
 		.priority	= NF_IP_PRI_CONNTRACK,
 	},
 	{
-		.hook		= ipv4_helper,
-		.pf		= NFPROTO_IPV4,
-		.hooknum	= NF_INET_POST_ROUTING,
-		.priority	= NF_IP_PRI_CONNTRACK_HELPER,
-	},
-	{
 		.hook		= ipv4_confirm,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_POST_ROUTING,
 		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
 	},
 	{
-		.hook		= ipv4_helper,
-		.pf		= NFPROTO_IPV4,
-		.hooknum	= NF_INET_LOCAL_IN,
-		.priority	= NF_IP_PRI_CONNTRACK_HELPER,
-	},
-	{
 		.hook		= ipv4_confirm,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_IN,
@@ -623,31 +611,21 @@ static unsigned int ipv6_confirm(void *priv,
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	unsigned char pnum = ipv6_hdr(skb)->nexthdr;
-	int protoff;
 	__be16 frag_off;
+	int protoff;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
-		goto out;
+		return nf_conntrack_confirm(skb);
 
 	protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum,
 				   &frag_off);
 	if (protoff < 0 || (frag_off & htons(~0x7)) != 0) {
 		pr_debug("proto header not found\n");
-		goto out;
+		return nf_conntrack_confirm(skb);
 	}
 
-	/* adjust seqs for loopback traffic only in outgoing direction */
-	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
-	    !nf_is_loopback_packet(skb)) {
-		if (!nf_ct_seq_adjust(skb, ct, ctinfo, protoff)) {
-			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
-			return NF_DROP;
-		}
-	}
-out:
-	/* We've seen it coming out the other side: confirm it */
-	return nf_conntrack_confirm(skb);
+	return nf_confirm(skb, protoff, ct, ctinfo);
 }
 
 static unsigned int ipv6_conntrack_in(void *priv,
@@ -664,42 +642,6 @@ static unsigned int ipv6_conntrack_local(void *priv,
 	return nf_conntrack_in(skb, state);
 }
 
-static unsigned int ipv6_helper(void *priv,
-				struct sk_buff *skb,
-				const struct nf_hook_state *state)
-{
-	struct nf_conn *ct;
-	const struct nf_conn_help *help;
-	const struct nf_conntrack_helper *helper;
-	enum ip_conntrack_info ctinfo;
-	__be16 frag_off;
-	int protoff;
-	u8 nexthdr;
-
-	/* This is where we call the helper: as the packet goes out. */
-	ct = nf_ct_get(skb, &ctinfo);
-	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
-		return NF_ACCEPT;
-
-	help = nfct_help(ct);
-	if (!help)
-		return NF_ACCEPT;
-	/* rcu_read_lock()ed by nf_hook_thresh */
-	helper = rcu_dereference(help->helper);
-	if (!helper)
-		return NF_ACCEPT;
-
-	nexthdr = ipv6_hdr(skb)->nexthdr;
-	protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr,
-				   &frag_off);
-	if (protoff < 0 || (frag_off & htons(~0x7)) != 0) {
-		pr_debug("proto header not found\n");
-		return NF_ACCEPT;
-	}
-
-	return helper->help(skb, protoff, ct, ctinfo);
-}
-
 static const struct nf_hook_ops ipv6_conntrack_ops[] = {
 	{
 		.hook		= ipv6_conntrack_in,
@@ -714,24 +656,12 @@ static const struct nf_hook_ops ipv6_conntrack_ops[] = {
 		.priority	= NF_IP6_PRI_CONNTRACK,
 	},
 	{
-		.hook		= ipv6_helper,
-		.pf		= NFPROTO_IPV6,
-		.hooknum	= NF_INET_POST_ROUTING,
-		.priority	= NF_IP6_PRI_CONNTRACK_HELPER,
-	},
-	{
 		.hook		= ipv6_confirm,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_POST_ROUTING,
 		.priority	= NF_IP6_PRI_LAST,
 	},
 	{
-		.hook		= ipv6_helper,
-		.pf		= NFPROTO_IPV6,
-		.hooknum	= NF_INET_LOCAL_IN,
-		.priority	= NF_IP6_PRI_CONNTRACK_HELPER,
-	},
-	{
 		.hook		= ipv6_confirm,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_IN,
-- 
2.11.0
