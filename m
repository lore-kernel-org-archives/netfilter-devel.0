Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EDE4C76195
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 00:47:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81E6D21738
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 00:47:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733173AbfGPArx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jul 2019 20:47:53 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:24164 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733155AbfGPArw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jul 2019 20:47:52 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 693E241803;
        Tue, 16 Jul 2019 08:47:47 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v5 3/8] netfilter:nf_flow_table_ip: Separate inet operation to single function
Date:   Tue, 16 Jul 2019 08:47:41 +0800
Message-Id: <1563238066-3105-4-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1563238066-3105-1-git-send-email-wenxu@ucloud.cn>
References: <1563238066-3105-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSkhCS0tLSkxMSENIT0lZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MxA6GAw5CjgrTQNMNk4dQ04i
        Qi5PCiFVSlVKTk1ISUhDS01MTklCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU5CTU83Bg++
X-HM-Tid: 0a6bf83fecf22086kuqy693e241803
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch separate the inet family operation in nf_flow_table_ip to single
function. Prepare for support the bridge family.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_flow_table_ip.c | 72 ++++++++++++++++++++++++----------------
 1 file changed, 43 insertions(+), 29 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 4304070..88b4d59 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -214,6 +214,25 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 	return true;
 }
 
+static void nf_flow_ipv4_xmit(struct flow_offload *flow, struct sk_buff *skb,
+			      enum flow_offload_tuple_dir dir)
+{
+	struct net_device *outdev;
+	struct rtable *rt;
+	struct iphdr *iph;
+	__be32 nexthop;
+
+	rt = (struct rtable *)flow->tuplehash[dir].tuple.dst.dst_cache;
+	outdev = rt->dst.dev;
+	iph = ip_hdr(skb);
+	ip_decrease_ttl(iph);
+
+	skb->dev = outdev;
+	nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
+	skb_dst_set_noref(skb, &rt->dst);
+	neigh_xmit(NEIGH_ARP_TABLE, outdev, &nexthop, skb);
+}
+
 unsigned int
 nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 			const struct nf_hook_state *state)
@@ -223,11 +242,7 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
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
@@ -241,13 +256,11 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 
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
@@ -258,13 +271,7 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 		return NF_DROP;
 
 	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
-	iph = ip_hdr(skb);
-	ip_decrease_ttl(iph);
-
-	skb->dev = outdev;
-	nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
-	skb_dst_set_noref(skb, &rt->dst);
-	neigh_xmit(NEIGH_ARP_TABLE, outdev, &nexthop, skb);
+	nf_flow_ipv4_xmit(flow, skb, dir);
 
 	return NF_STOLEN;
 }
@@ -431,6 +438,25 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 	return 0;
 }
 
+static void nf_flow_ipv6_xmit(struct flow_offload *flow, struct sk_buff *skb,
+			      enum flow_offload_tuple_dir dir)
+{
+	const struct in6_addr *nexthop;
+	struct net_device *outdev;
+	struct ipv6hdr *ip6h;
+	struct rt6_info *rt;
+
+	rt = (struct rt6_info *)flow->tuplehash[dir].tuple.dst.dst_cache;
+	outdev = rt->dst.dev;
+	ip6h = ipv6_hdr(skb);
+	ip6h->hop_limit--;
+
+	skb->dev = outdev;
+	nexthop = rt6_nexthop(rt, &flow->tuplehash[!dir].tuple.src_v6);
+	skb_dst_set_noref(skb, &rt->dst);
+	neigh_xmit(NEIGH_ND_TABLE, outdev, nexthop, skb);
+}
+
 unsigned int
 nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 			  const struct nf_hook_state *state)
@@ -439,11 +465,7 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
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
@@ -457,30 +479,22 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 
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
 
-	if (skb_try_make_writable(skb, sizeof(*ip6h)))
+	if (skb_try_make_writable(skb, sizeof(struct ipv6hdr)))
 		return NF_DROP;
 
 	if (nf_flow_nat_ipv6(flow, skb, dir) < 0)
 		return NF_DROP;
 
 	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
-	ip6h = ipv6_hdr(skb);
-	ip6h->hop_limit--;
-
-	skb->dev = outdev;
-	nexthop = rt6_nexthop(rt, &flow->tuplehash[!dir].tuple.src_v6);
-	skb_dst_set_noref(skb, &rt->dst);
-	neigh_xmit(NEIGH_ND_TABLE, outdev, nexthop, skb);
+	nf_flow_ipv6_xmit(flow, skb, dir);
 
 	return NF_STOLEN;
 }
-- 
1.8.3.1

