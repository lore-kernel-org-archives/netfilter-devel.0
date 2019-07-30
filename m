Return-Path: <SRS0=FCuH=V3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D5AC433FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 12:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A232F2087F
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 12:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbfG3M6q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 08:58:46 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:42278 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726241AbfG3M6q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 08:58:46 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hsRiG-0003sT-5B; Tue, 30 Jul 2019 14:58:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     steffen.klassert@secunet.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 2/2] netfilter: nf_flow_table: fix offload for flows that are subject to xfrm
Date:   Tue, 30 Jul 2019 14:57:19 +0200
Message-Id: <20190730125719.23553-2-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190730125719.23553-1-fw@strlen.de>
References: <20190730125719.23553-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This makes the previously added 'encap test' pass.
Because its possible that the xfrm dst entry becomes stale while such
a flow is offloaded, we need to call dst_check() -- the notifier that
handles this for non-tunneled traffic isn't sufficient, because SA or
or policies might have changed.

If dst becomes stale the flow offload entry will be tagged for teardown
and packets will be passed to 'classic' forwarding path.

Removing the entry right away is problematic, as this would
introduce a race condition with the gc worker.

In case flow is long-lived, it could eventually be offloaded again
once the gc worker removes the entry from the flow table.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_flow_table_ip.c | 43 ++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index cdfc33517e85..d68c801dd614 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -214,6 +214,25 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 	return true;
 }
 
+static int nf_flow_offload_dst_check(struct dst_entry *dst)
+{
+	if (unlikely(dst_xfrm(dst)))
+		return dst_check(dst, 0) ? 0 : -1;
+
+	return 0;
+}
+
+static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
+				      const struct nf_hook_state *state,
+				      struct dst_entry *dst)
+{
+	skb_orphan(skb);
+	skb_dst_set_noref(skb, dst);
+	skb->tstamp = 0;
+	dst_output(state->net, state->sk, skb);
+	return NF_STOLEN;
+}
+
 unsigned int
 nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 			const struct nf_hook_state *state)
@@ -254,6 +273,11 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_state_check(flow, ip_hdr(skb)->protocol, skb, thoff))
 		return NF_ACCEPT;
 
+	if (nf_flow_offload_dst_check(&rt->dst)) {
+		flow_offload_teardown(flow);
+		return NF_ACCEPT;
+	}
+
 	if (nf_flow_nat_ip(flow, skb, thoff, dir) < 0)
 		return NF_DROP;
 
@@ -261,6 +285,13 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	iph = ip_hdr(skb);
 	ip_decrease_ttl(iph);
 
+	if (unlikely(dst_xfrm(&rt->dst))) {
+		memset(skb->cb, 0, sizeof(struct inet_skb_parm));
+		IPCB(skb)->iif = skb->dev->ifindex;
+		IPCB(skb)->flags = IPSKB_FORWARDED;
+		return nf_flow_xmit_xfrm(skb, state, &rt->dst);
+	}
+
 	skb->dev = outdev;
 	nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
 	skb_dst_set_noref(skb, &rt->dst);
@@ -467,6 +498,11 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 				sizeof(*ip6h)))
 		return NF_ACCEPT;
 
+	if (nf_flow_offload_dst_check(&rt->dst)) {
+		flow_offload_teardown(flow);
+		return NF_ACCEPT;
+	}
+
 	if (skb_try_make_writable(skb, sizeof(*ip6h)))
 		return NF_DROP;
 
@@ -477,6 +513,13 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	ip6h = ipv6_hdr(skb);
 	ip6h->hop_limit--;
 
+	if (unlikely(dst_xfrm(&rt->dst))) {
+		memset(skb->cb, 0, sizeof(struct inet6_skb_parm));
+		IP6CB(skb)->iif = skb->dev->ifindex;
+		IP6CB(skb)->flags = IP6SKB_FORWARDED;
+		return nf_flow_xmit_xfrm(skb, state, &rt->dst);
+	}
+
 	skb->dev = outdev;
 	nexthop = rt6_nexthop(rt, &flow->tuplehash[!dir].tuple.src_v6);
 	skb_dst_set_noref(skb, &rt->dst);
-- 
2.21.0

