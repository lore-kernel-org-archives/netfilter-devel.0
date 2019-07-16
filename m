Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 753E2C7618F
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 00:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FC6021738
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 00:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733190AbfGPArz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jul 2019 20:47:55 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:24378 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733163AbfGPArx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jul 2019 20:47:53 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id B709D4181D;
        Tue, 16 Jul 2019 08:47:47 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v5 6/8] netfilter:nf_flow_table_ip: Support bridge family flow offload
Date:   Tue, 16 Jul 2019 08:47:44 +0800
Message-Id: <1563238066-3105-7-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1563238066-3105-1-git-send-email-wenxu@ucloud.cn>
References: <1563238066-3105-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS0tIQkJCTkJLQ0xITElZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mgw6Qxw6NTgzFAMjNk8iQ1Yh
        PUMKCyhVSlVKTk1ISUhDS01MQ0tPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU9CSkI3Bg++
X-HM-Tid: 0a6bf83fee342086kuqyb709d4181d
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

With nf_conntrack_bridge function. The bridge family can do
conntrack it self. The flow offload function based on the
conntrack. This patch a bridge family operation in
nf_flow_table_ip.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_flow_table_ip.c | 59 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 57 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 88b4d59..d88dafb 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -233,12 +233,40 @@ static void nf_flow_ipv4_xmit(struct flow_offload *flow, struct sk_buff *skb,
 	neigh_xmit(NEIGH_ARP_TABLE, outdev, &nexthop, skb);
 }
 
+static void nf_flow_bridge_xmit(struct flow_offload *flow, struct sk_buff *skb,
+				enum flow_offload_tuple_dir dir)
+{
+	struct net_device *outdev;
+	u16 vlan_tag, vlan_proto;
+
+	vlan_tag = flow->tuplehash[dir].tuple.dst.dst_port.dst_vlan_tag;
+	vlan_proto = flow->tuplehash[dir].tuple.dst.dst_port.vlan_proto;
+	outdev = flow->tuplehash[dir].tuple.dst.dst_port.dev;
+	skb->dev = outdev;
+
+	if (vlan_tag)
+		__vlan_hwaccel_put_tag(skb, htons(vlan_proto), vlan_tag);
+	else
+		__vlan_hwaccel_clear_tag(skb);
+
+	skb_push(skb, ETH_HLEN);
+	if (!is_skb_forwardable(skb->dev, skb))
+		goto drop;
+
+	dev_queue_xmit(skb);
+	return;
+
+drop:
+	kfree_skb(skb);
+}
+
 unsigned int
 nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 			const struct nf_hook_state *state)
 {
 	struct flow_offload_tuple_rhash *tuplehash;
 	struct nf_flowtable *flow_table = priv;
+	int family = flow_table->type->family;
 	struct flow_offload_tuple tuple = {};
 	enum flow_offload_tuple_dir dir;
 	struct flow_offload *flow;
@@ -247,9 +275,15 @@ static void nf_flow_ipv4_xmit(struct flow_offload *flow, struct sk_buff *skb,
 	if (skb->protocol != htons(ETH_P_IP))
 		return NF_ACCEPT;
 
+	if (family != NFPROTO_BRIDGE && family != NFPROTO_IPV4)
+		return NF_ACCEPT;
+
 	if (nf_flow_tuple_ip(skb, state->in, &tuple) < 0)
 		return NF_ACCEPT;
 
+	if (family == NFPROTO_BRIDGE && skb_vlan_tag_present(skb))
+		tuple.vlan_tag = skb_vlan_tag_get_id(skb);
+
 	tuplehash = flow_offload_lookup(flow_table, &tuple);
 	if (tuplehash == NULL)
 		return NF_ACCEPT;
@@ -271,7 +305,14 @@ static void nf_flow_ipv4_xmit(struct flow_offload *flow, struct sk_buff *skb,
 		return NF_DROP;
 
 	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
-	nf_flow_ipv4_xmit(flow, skb, dir);
+	switch (family) {
+	case NFPROTO_IPV4:
+		nf_flow_ipv4_xmit(flow, skb, dir);
+		break;
+	case NFPROTO_BRIDGE:
+		nf_flow_bridge_xmit(flow, skb, dir);
+		break;
+	}
 
 	return NF_STOLEN;
 }
@@ -463,6 +504,7 @@ static void nf_flow_ipv6_xmit(struct flow_offload *flow, struct sk_buff *skb,
 {
 	struct flow_offload_tuple_rhash *tuplehash;
 	struct nf_flowtable *flow_table = priv;
+	int family = flow_table->type->family;
 	struct flow_offload_tuple tuple = {};
 	enum flow_offload_tuple_dir dir;
 	struct flow_offload *flow;
@@ -470,9 +512,15 @@ static void nf_flow_ipv6_xmit(struct flow_offload *flow, struct sk_buff *skb,
 	if (skb->protocol != htons(ETH_P_IPV6))
 		return NF_ACCEPT;
 
+	if (family != NFPROTO_BRIDGE && family != NFPROTO_IPV6)
+		return NF_ACCEPT;
+
 	if (nf_flow_tuple_ipv6(skb, state->in, &tuple) < 0)
 		return NF_ACCEPT;
 
+	if (family == NFPROTO_BRIDGE && skb_vlan_tag_present(skb))
+		tuple.vlan_tag = skb_vlan_tag_get_id(skb);
+
 	tuplehash = flow_offload_lookup(flow_table, &tuple);
 	if (tuplehash == NULL)
 		return NF_ACCEPT;
@@ -494,7 +542,14 @@ static void nf_flow_ipv6_xmit(struct flow_offload *flow, struct sk_buff *skb,
 		return NF_DROP;
 
 	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
-	nf_flow_ipv6_xmit(flow, skb, dir);
+	switch (family) {
+	case NFPROTO_IPV6:
+		nf_flow_ipv6_xmit(flow, skb, dir);
+		break;
+	case NFPROTO_BRIDGE:
+		nf_flow_bridge_xmit(flow, skb, dir);
+		break;
+	}
 
 	return NF_STOLEN;
 }
-- 
1.8.3.1

