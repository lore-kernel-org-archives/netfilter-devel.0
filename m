Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37039C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Nov 2022 11:39:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiKILjL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Nov 2022 06:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiKILjK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Nov 2022 06:39:10 -0500
X-Greylist: delayed 1023 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Nov 2022 03:39:08 PST
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFE31E3F1
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2022 03:39:08 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1osj9f-0002dG-2X; Wed, 09 Nov 2022 12:22:03 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: merge ipv4+ipv6 confirm functions
Date:   Wed,  9 Nov 2022 12:21:58 +0100
Message-Id: <20221109112158.9618-1-fw@strlen.de>
X-Mailer: git-send-email 2.37.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No need to have distinct functions.  After merge, ipv6 can avoid
protooff computation if the connection neither needs sequence adjustment
nor helper invocation -- this is the normal case.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_core.h  |   3 +-
 net/bridge/netfilter/nf_conntrack_bridge.c |  32 +-----
 net/netfilter/nf_conntrack_proto.c         | 124 +++++++++------------
 3 files changed, 57 insertions(+), 102 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index b2b9de70d9f4..71d1269fe4d4 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -71,8 +71,7 @@ static inline int nf_conntrack_confirm(struct sk_buff *skb)
 	return ret;
 }
 
-unsigned int nf_confirm(struct sk_buff *skb, unsigned int protoff,
-			struct nf_conn *ct, enum ip_conntrack_info ctinfo);
+unsigned int nf_confirm(void *priv, struct sk_buff *skb, const struct nf_hook_state *state);
 
 void print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
 		 const struct nf_conntrack_l4proto *proto);
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 73242962be5d..5c5dd437f1c2 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -366,42 +366,12 @@ static int nf_ct_bridge_refrag_post(struct net *net, struct sock *sk,
 	return br_dev_queue_push_xmit(net, sk, skb);
 }
 
-static unsigned int nf_ct_bridge_confirm(struct sk_buff *skb)
-{
-	enum ip_conntrack_info ctinfo;
-	struct nf_conn *ct;
-	int protoff;
-
-	ct = nf_ct_get(skb, &ctinfo);
-	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
-		return nf_conntrack_confirm(skb);
-
-	switch (skb->protocol) {
-	case htons(ETH_P_IP):
-		protoff = skb_network_offset(skb) + ip_hdrlen(skb);
-		break;
-	case htons(ETH_P_IPV6): {
-		unsigned char pnum = ipv6_hdr(skb)->nexthdr;
-		__be16 frag_off;
-
-		protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum,
-					   &frag_off);
-		if (protoff < 0 || (frag_off & htons(~0x7)) != 0)
-			return nf_conntrack_confirm(skb);
-		}
-		break;
-	default:
-		return NF_ACCEPT;
-	}
-	return nf_confirm(skb, protoff, ct, ctinfo);
-}
-
 static unsigned int nf_ct_bridge_post(void *priv, struct sk_buff *skb,
 				      const struct nf_hook_state *state)
 {
 	int ret;
 
-	ret = nf_ct_bridge_confirm(skb);
+	ret = nf_confirm(priv, skb, state);
 	if (ret != NF_ACCEPT)
 		return ret;
 
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 895b09cbd7cf..99323fb12d0f 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -121,17 +121,61 @@ const struct nf_conntrack_l4proto *nf_ct_l4proto_find(u8 l4proto)
 };
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_find);
 
-unsigned int nf_confirm(struct sk_buff *skb, unsigned int protoff,
-			struct nf_conn *ct, enum ip_conntrack_info ctinfo)
+static bool in_vrf_postrouting(const struct nf_hook_state *state)
+{
+#if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
+	if (state->hook == NF_INET_POST_ROUTING &&
+	    netif_is_l3_master(state->out))
+		return true;
+#endif
+	return false;
+}
+
+unsigned int nf_confirm(void *priv,
+			struct sk_buff *skb,
+			const struct nf_hook_state *state)
 {
 	const struct nf_conn_help *help;
+	enum ip_conntrack_info ctinfo;
+	unsigned int protoff;
+	struct nf_conn *ct;
+	bool seqadj_needed;
+	__be16 frag_off;
+	u8 pnum;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct || in_vrf_postrouting(state))
+		return NF_ACCEPT;
 
 	help = nfct_help(ct);
+
+	seqadj_needed = test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) && !nf_is_loopback_packet(skb);
+	if (!help && !seqadj_needed)
+		return nf_conntrack_confirm(skb);
+
+	/* helper->help() do not expect ICMP packets */
+	if (ctinfo == IP_CT_RELATED_REPLY)
+		return nf_conntrack_confirm(skb);
+
+	switch (nf_ct_l3num(ct)) {
+	case NFPROTO_IPV4:
+		protoff = skb_network_offset(skb) + ip_hdrlen(skb);
+		break;
+	case NFPROTO_IPV6:
+		pnum = ipv6_hdr(skb)->nexthdr;
+		protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum, &frag_off);
+		if (protoff < 0 || (frag_off & htons(~0x7)) != 0)
+			return nf_conntrack_confirm(skb);
+		break;
+	default:
+		return nf_conntrack_confirm(skb);
+	}
+
 	if (help) {
 		const struct nf_conntrack_helper *helper;
 		int ret;
 
-		/* rcu_read_lock()ed by nf_hook_thresh */
+		/* rcu_read_lock()ed by nf_hook */
 		helper = rcu_dereference(help->helper);
 		if (helper) {
 			ret = helper->help(skb,
@@ -142,12 +186,10 @@ unsigned int nf_confirm(struct sk_buff *skb, unsigned int protoff,
 		}
 	}
 
-	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
-	    !nf_is_loopback_packet(skb)) {
-		if (!nf_ct_seq_adjust(skb, ct, ctinfo, protoff)) {
-			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
-			return NF_DROP;
-		}
+	if (seqadj_needed &&
+	    !nf_ct_seq_adjust(skb, ct, ctinfo, protoff)) {
+		NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
+		return NF_DROP;
 	}
 
 	/* We've seen it coming out the other side: confirm it */
@@ -155,35 +197,6 @@ unsigned int nf_confirm(struct sk_buff *skb, unsigned int protoff,
 }
 EXPORT_SYMBOL_GPL(nf_confirm);
 
-static bool in_vrf_postrouting(const struct nf_hook_state *state)
-{
-#if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
-	if (state->hook == NF_INET_POST_ROUTING &&
-	    netif_is_l3_master(state->out))
-		return true;
-#endif
-	return false;
-}
-
-static unsigned int ipv4_confirm(void *priv,
-				 struct sk_buff *skb,
-				 const struct nf_hook_state *state)
-{
-	enum ip_conntrack_info ctinfo;
-	struct nf_conn *ct;
-
-	ct = nf_ct_get(skb, &ctinfo);
-	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
-		return nf_conntrack_confirm(skb);
-
-	if (in_vrf_postrouting(state))
-		return NF_ACCEPT;
-
-	return nf_confirm(skb,
-			  skb_network_offset(skb) + ip_hdrlen(skb),
-			  ct, ctinfo);
-}
-
 static unsigned int ipv4_conntrack_in(void *priv,
 				      struct sk_buff *skb,
 				      const struct nf_hook_state *state)
@@ -230,13 +243,13 @@ static const struct nf_hook_ops ipv4_conntrack_ops[] = {
 		.priority	= NF_IP_PRI_CONNTRACK,
 	},
 	{
-		.hook		= ipv4_confirm,
+		.hook		= nf_confirm,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_POST_ROUTING,
 		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
 	},
 	{
-		.hook		= ipv4_confirm,
+		.hook		= nf_confirm,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
@@ -373,33 +386,6 @@ static struct nf_sockopt_ops so_getorigdst6 = {
 	.owner		= THIS_MODULE,
 };
 
-static unsigned int ipv6_confirm(void *priv,
-				 struct sk_buff *skb,
-				 const struct nf_hook_state *state)
-{
-	struct nf_conn *ct;
-	enum ip_conntrack_info ctinfo;
-	unsigned char pnum = ipv6_hdr(skb)->nexthdr;
-	__be16 frag_off;
-	int protoff;
-
-	ct = nf_ct_get(skb, &ctinfo);
-	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
-		return nf_conntrack_confirm(skb);
-
-	if (in_vrf_postrouting(state))
-		return NF_ACCEPT;
-
-	protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum,
-				   &frag_off);
-	if (protoff < 0 || (frag_off & htons(~0x7)) != 0) {
-		pr_debug("proto header not found\n");
-		return nf_conntrack_confirm(skb);
-	}
-
-	return nf_confirm(skb, protoff, ct, ctinfo);
-}
-
 static unsigned int ipv6_conntrack_in(void *priv,
 				      struct sk_buff *skb,
 				      const struct nf_hook_state *state)
@@ -428,13 +414,13 @@ static const struct nf_hook_ops ipv6_conntrack_ops[] = {
 		.priority	= NF_IP6_PRI_CONNTRACK,
 	},
 	{
-		.hook		= ipv6_confirm,
+		.hook		= nf_confirm,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_POST_ROUTING,
 		.priority	= NF_IP6_PRI_LAST,
 	},
 	{
-		.hook		= ipv6_confirm,
+		.hook		= nf_confirm,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP6_PRI_LAST - 1,
-- 
2.37.4

