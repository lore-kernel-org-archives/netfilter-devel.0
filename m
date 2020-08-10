Return-Path: <SRS0=PHp+=BU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA68AC433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Aug 2020 11:52:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0C6C206C3
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Aug 2020 11:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgHJLwe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Aug 2020 07:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbgHJLwd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Aug 2020 07:52:33 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A2FC061756
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2020 04:52:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1k56Ln-00021Q-UH; Mon, 10 Aug 2020 13:52:23 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: avoid ipv6 -> nf_defrag_ipv6 module dependency
Date:   Mon, 10 Aug 2020 13:52:15 +0200
Message-Id: <20200810115215.369-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nf_ct_frag6_gather is part of nf_defrag_ipv6.ko, not ipv6 core.

The current use of the netfilter ipv6 stub indirections  causes a module
dependency between ipv6 and nf_defrag_ipv6.

This prevents nf_defrag_ipv6 module from being removed because ipv6 can't
be unloaded.

Remove the indirection and always use a direct call.  This creates a
depency from nf_conntrack_bridge to nf_defrag_ipv6 instead:

modinfo nf_conntrack
depends:        nf_conntrack,nf_defrag_ipv6,bridge

.. and nf_conntrack already depends on nf_defrag_ipv6 anyway.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 I can also re-send it when nf-next reopens later, whatever you prefer.

 include/linux/netfilter_ipv6.h             | 18 ------------------
 net/bridge/netfilter/nf_conntrack_bridge.c |  8 ++++++--
 net/ipv6/netfilter.c                       |  3 ---
 3 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index aac42c28fe62..9b67394471e1 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -58,7 +58,6 @@ struct nf_ipv6_ops {
 			int (*output)(struct net *, struct sock *, struct sk_buff *));
 	int (*reroute)(struct sk_buff *skb, const struct nf_queue_entry *entry);
 #if IS_MODULE(CONFIG_IPV6)
-	int (*br_defrag)(struct net *net, struct sk_buff *skb, u32 user);
 	int (*br_fragment)(struct net *net, struct sock *sk,
 			   struct sk_buff *skb,
 			   struct nf_bridge_frag_data *data,
@@ -117,23 +116,6 @@ static inline int nf_ip6_route(struct net *net, struct dst_entry **dst,
 
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 
-static inline int nf_ipv6_br_defrag(struct net *net, struct sk_buff *skb,
-				    u32 user)
-{
-#if IS_MODULE(CONFIG_IPV6)
-	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
-
-	if (!v6_ops)
-		return 1;
-
-	return v6_ops->br_defrag(net, skb, user);
-#elif IS_BUILTIN(CONFIG_IPV6)
-	return nf_ct_frag6_gather(net, skb, user);
-#else
-	return 1;
-#endif
-}
-
 int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		    struct nf_bridge_frag_data *data,
 		    int (*output)(struct net *, struct sock *sk,
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 809673222382..8d033a75a766 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -168,6 +168,7 @@ static unsigned int nf_ct_br_defrag4(struct sk_buff *skb,
 static unsigned int nf_ct_br_defrag6(struct sk_buff *skb,
 				     const struct nf_hook_state *state)
 {
+#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 	u16 zone_id = NF_CT_DEFAULT_ZONE_ID;
 	enum ip_conntrack_info ctinfo;
 	struct br_input_skb_cb cb;
@@ -180,14 +181,17 @@ static unsigned int nf_ct_br_defrag6(struct sk_buff *skb,
 
 	br_skb_cb_save(skb, &cb, sizeof(struct inet6_skb_parm));
 
-	err = nf_ipv6_br_defrag(state->net, skb,
-				IP_DEFRAG_CONNTRACK_BRIDGE_IN + zone_id);
+	err = nf_ct_frag6_gather(state->net, skb,
+				 IP_DEFRAG_CONNTRACK_BRIDGE_IN + zone_id);
 	/* queued */
 	if (err == -EINPROGRESS)
 		return NF_STOLEN;
 
 	br_skb_cb_restore(skb, &cb, IP6CB(skb)->frag_max_size);
 	return err == 0 ? NF_ACCEPT : NF_DROP;
+#else
+	return NF_ACCEPT;
+#endif
 }
 
 static int nf_ct_br_ip_check(const struct sk_buff *skb)
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 409e79b84a83..6d0e942d082d 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -245,9 +245,6 @@ static const struct nf_ipv6_ops ipv6ops = {
 	.route_input		= ip6_route_input,
 	.fragment		= ip6_fragment,
 	.reroute		= nf_ip6_reroute,
-#if IS_MODULE(CONFIG_IPV6) && IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
-	.br_defrag		= nf_ct_frag6_gather,
-#endif
 #if IS_MODULE(CONFIG_IPV6)
 	.br_fragment		= br_ip6_fragment,
 #endif
-- 
2.26.2

