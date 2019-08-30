Return-Path: <SRS0=JGmF=W2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B80C6C3A5A4
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Aug 2019 04:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 858C321897
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Aug 2019 04:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfH3ERc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Aug 2019 00:17:32 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:42697 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfH3ERb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Aug 2019 00:17:31 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 0337341766;
        Fri, 30 Aug 2019 12:17:23 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v7 3/8] netfilter:nf_flow_table_ip: Separate inet operation to single function
Date:   Fri, 30 Aug 2019 12:17:17 +0800
Message-Id: <1567138642-11446-4-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567138642-11446-1-git-send-email-wenxu@ucloud.cn>
References: <1567138642-11446-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS0NNQkJCTExIQkxCSkJZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6K006DDo5VjgrSDIfFC4sLz1P
        IUsaC0lVSlVKTk1MSkhDTU9ISk9LVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUxNSEg3Bg++
X-HM-Tid: 0a6ce0bdfc562086kuqy0337341766
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch separate the inet family operation in nf_flow_table_ip to single
function. Prepare for support the bridge family.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v7: rebase with upstream fix

 net/netfilter/nf_flow_table_ip.c | 128 ++++++++++++++++++++++-----------------
 1 file changed, 73 insertions(+), 55 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 3ff7b04..1c598af 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -233,6 +233,40 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 	return NF_STOLEN;
 }
 
+static int nf_flow_ipv4_xmit(struct flow_offload *flow, struct sk_buff *skb,
+			     const struct nf_hook_state *state,
+			     enum flow_offload_tuple_dir dir)
+{
+	struct net_device *outdev;
+	struct rtable *rt;
+	struct iphdr *iph;
+	__be32 nexthop;
+
+	rt = (struct rtable *)flow->tuplehash[dir].tuple.dst.dst_cache;
+	if (nf_flow_offload_dst_check(&rt->dst)) {
+		flow_offload_teardown(flow);
+		return NF_ACCEPT;
+	}
+
+	outdev = rt->dst.dev;
+	iph = ip_hdr(skb);
+	ip_decrease_ttl(iph);
+
+	if (unlikely(dst_xfrm(&rt->dst))) {
+		memset(skb->cb, 0, sizeof(struct inet_skb_parm));
+		IPCB(skb)->iif = skb->dev->ifindex;
+		IPCB(skb)->flags = IPSKB_FORWARDED;
+		return nf_flow_xmit_xfrm(skb, state, &rt->dst);
+	}
+
+	skb->dev = outdev;
+	nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
+	skb_dst_set_noref(skb, &rt->dst);
+	neigh_xmit(NEIGH_ARP_TABLE, outdev, &nexthop, skb);
+
+	return NF_STOLEN;
+}
+
 unsigned int
 nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 			const struct nf_hook_state *state)
@@ -242,11 +276,7 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 	struct flow_offload_tuple tuple = {};
 	enum flow_offload_tuple_dir dir;
 	struct flow_offload *flow;
-	struct net_device *outdev;
-	struct rtable *rt;
 	unsigned int thoff;
-	struct iphdr *iph;
-	__be32 nexthop;
 
 	if (skb->protocol != htons(ETH_P_IP))
 		return NF_ACCEPT;
@@ -260,44 +290,23 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
-	rt = (struct rtable *)flow->tuplehash[dir].tuple.dst.dst_cache;
-	outdev = rt->dst.dev;
 
 	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
 		return NF_ACCEPT;
 
-	if (skb_try_make_writable(skb, sizeof(*iph)))
+	if (skb_try_make_writable(skb, sizeof(struct iphdr)))
 		return NF_DROP;
 
 	thoff = ip_hdr(skb)->ihl * 4;
 	if (nf_flow_state_check(flow, ip_hdr(skb)->protocol, skb, thoff))
 		return NF_ACCEPT;
 
-	if (nf_flow_offload_dst_check(&rt->dst)) {
-		flow_offload_teardown(flow);
-		return NF_ACCEPT;
-	}
-
 	if (nf_flow_nat_ip(flow, skb, thoff, dir) < 0)
 		return NF_DROP;
 
 	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
-	iph = ip_hdr(skb);
-	ip_decrease_ttl(iph);
-
-	if (unlikely(dst_xfrm(&rt->dst))) {
-		memset(skb->cb, 0, sizeof(struct inet_skb_parm));
-		IPCB(skb)->iif = skb->dev->ifindex;
-		IPCB(skb)->flags = IPSKB_FORWARDED;
-		return nf_flow_xmit_xfrm(skb, state, &rt->dst);
-	}
 
-	skb->dev = outdev;
-	nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
-	skb_dst_set_noref(skb, &rt->dst);
-	neigh_xmit(NEIGH_ARP_TABLE, outdev, &nexthop, skb);
-
-	return NF_STOLEN;
+	return nf_flow_ipv4_xmit(flow, skb, state, dir);
 }
 EXPORT_SYMBOL_GPL(nf_flow_offload_ip_hook);
 
@@ -462,6 +471,40 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 	return 0;
 }
 
+static int nf_flow_ipv6_xmit(struct flow_offload *flow, struct sk_buff *skb,
+			     const struct nf_hook_state *state,
+			     enum flow_offload_tuple_dir dir)
+{
+	const struct in6_addr *nexthop;
+	struct net_device *outdev;
+	struct ipv6hdr *ip6h;
+	struct rt6_info *rt;
+
+	rt = (struct rt6_info *)flow->tuplehash[dir].tuple.dst.dst_cache;
+	if (nf_flow_offload_dst_check(&rt->dst)) {
+		flow_offload_teardown(flow);
+		return NF_ACCEPT;
+	}
+
+	outdev = rt->dst.dev;
+	ip6h = ipv6_hdr(skb);
+	ip6h->hop_limit--;
+
+	if (unlikely(dst_xfrm(&rt->dst))) {
+		memset(skb->cb, 0, sizeof(struct inet6_skb_parm));
+		IP6CB(skb)->iif = skb->dev->ifindex;
+		IP6CB(skb)->flags = IP6SKB_FORWARDED;
+		return nf_flow_xmit_xfrm(skb, state, &rt->dst);
+	}
+
+	skb->dev = outdev;
+	nexthop = rt6_nexthop(rt, &flow->tuplehash[!dir].tuple.src_v6);
+	skb_dst_set_noref(skb, &rt->dst);
+	neigh_xmit(NEIGH_ND_TABLE, outdev, nexthop, skb);
+
+	return NF_STOLEN;
+}
+
 unsigned int
 nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 			  const struct nf_hook_state *state)
@@ -470,11 +513,7 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 	struct nf_flowtable *flow_table = priv;
 	struct flow_offload_tuple tuple = {};
 	enum flow_offload_tuple_dir dir;
-	const struct in6_addr *nexthop;
 	struct flow_offload *flow;
-	struct net_device *outdev;
-	struct ipv6hdr *ip6h;
-	struct rt6_info *rt;
 
 	if (skb->protocol != htons(ETH_P_IPV6))
 		return NF_ACCEPT;
@@ -488,43 +527,22 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
-	rt = (struct rt6_info *)flow->tuplehash[dir].tuple.dst.dst_cache;
-	outdev = rt->dst.dev;
 
 	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
 		return NF_ACCEPT;
 
 	if (nf_flow_state_check(flow, ipv6_hdr(skb)->nexthdr, skb,
-				sizeof(*ip6h)))
+				sizeof(struct ipv6hdr)))
 		return NF_ACCEPT;
 
-	if (nf_flow_offload_dst_check(&rt->dst)) {
-		flow_offload_teardown(flow);
-		return NF_ACCEPT;
-	}
-
-	if (skb_try_make_writable(skb, sizeof(*ip6h)))
+	if (skb_try_make_writable(skb, sizeof(struct ipv6hdr)))
 		return NF_DROP;
 
 	if (nf_flow_nat_ipv6(flow, skb, dir) < 0)
 		return NF_DROP;
 
 	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
-	ip6h = ipv6_hdr(skb);
-	ip6h->hop_limit--;
-
-	if (unlikely(dst_xfrm(&rt->dst))) {
-		memset(skb->cb, 0, sizeof(struct inet6_skb_parm));
-		IP6CB(skb)->iif = skb->dev->ifindex;
-		IP6CB(skb)->flags = IP6SKB_FORWARDED;
-		return nf_flow_xmit_xfrm(skb, state, &rt->dst);
-	}
 
-	skb->dev = outdev;
-	nexthop = rt6_nexthop(rt, &flow->tuplehash[!dir].tuple.src_v6);
-	skb_dst_set_noref(skb, &rt->dst);
-	neigh_xmit(NEIGH_ND_TABLE, outdev, nexthop, skb);
-
-	return NF_STOLEN;
+	return nf_flow_ipv6_xmit(flow, skb, state, dir);
 }
 EXPORT_SYMBOL_GPL(nf_flow_offload_ipv6_hook);
-- 
1.8.3.1

