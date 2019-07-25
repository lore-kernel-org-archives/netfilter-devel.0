Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE80DC761A8
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 11:13:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF6ED21901
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 11:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391656AbfGYLNE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 07:13:04 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:19976 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403880AbfGYLND (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 07:13:03 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 9704241D90;
        Thu, 25 Jul 2019 19:12:57 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v6 7/8] netfilter:nft_flow_offload: Support bridge family flow offload
Date:   Thu, 25 Jul 2019 19:12:55 +0800
Message-Id: <1564053176-28605-8-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564053176-28605-1-git-send-email-wenxu@ucloud.cn>
References: <1564053176-28605-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVQ05KS0tLSEtDQkJLT0NZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MzI6Qgw4Hzg1EFYSQg0MPw81
        SB4wCQlVSlVKTk1PS05ISkxMTEpNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU1NQ0M3Bg++
X-HM-Tid: 0a6c28d5851d2086kuqy9704241d90
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

With nf_conntrack_bridge function. The bridge family can do
conntrack it self. The flow offload function based on the conntrack.
This patch add bridge family operation in nf_flow_offload

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v6: no change

 net/netfilter/nft_flow_offload.c | 138 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 131 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 4af94ce..796d31c 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -6,6 +6,7 @@
 #include <linux/netfilter.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
+#include <linux/if_bridge.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/ip.h> /* for ipv4 options. */
 #include <net/netfilter/nf_tables.h>
@@ -49,23 +50,142 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
 	return 0;
 }
 
+static const struct net_device *
+nft_get_bridge(const struct net_device *dev)
+{
+	if (dev && netif_is_bridge_port(dev))
+		return netdev_master_upper_dev_get_rcu((struct net_device *)dev);
+
+	return NULL;
+}
+
+static int nft_flow_forward(const struct nft_pktinfo *pkt,
+			    const struct nf_conn *ct,
+			    struct nf_flow_forward *forward,
+			    enum ip_conntrack_dir dir)
+{
+#ifdef CONFIG_NF_TABLES_BRIDGE
+	const struct net_device *br_dev;
+	u16 vlan_proto = 0;
+	u16 vid = 0;
+
+	if (skb_vlan_tag_present(pkt->skb)) {
+		vid = skb_vlan_tag_get_id(pkt->skb);
+		vlan_proto = ntohs(pkt->skb->vlan_proto);
+	}
+
+	forward->tuple[dir].dst_port.dst_vlan_tag = vid;
+	forward->tuple[dir].dst_port.vlan_proto = vlan_proto;
+	forward->tuple[!dir].vlan_tag = vid;
+	forward->tuple[dir].dst_port.dev = dev_get_by_index(dev_net(nft_out(pkt)),
+							    nft_out(pkt)->ifindex);
+	forward->tuple[!dir].dst_port.dev = dev_get_by_index(dev_net(nft_in(pkt)),
+							     nft_in(pkt)->ifindex);
+
+	br_dev = nft_get_bridge(nft_out(pkt));
+	if (!br_dev)
+		goto err;
+
+	if (!br_vlan_enabled(br_dev))
+		goto out;
+
+	if (!vid)
+		br_vlan_get_pvid_rcu(nft_out(pkt), &vid);
+
+	if (vid) {
+		struct bridge_vlan_info vinfo;
+		int ret;
+
+		ret = br_vlan_get_proto(br_dev, &vlan_proto);
+		if (ret < 0)
+			goto err;
+
+		ret = br_vlan_get_info_rcu(nft_in(pkt), vid, &vinfo);
+		if (ret < 0)
+			goto err;
+
+		if (vinfo.flags & BRIDGE_VLAN_INFO_UNTAGGED) {
+			vid = 0;
+			vlan_proto = 0;
+		}
+	}
+
+out:
+	forward->tuple[!dir].dst_port.vlan_proto = vlan_proto;
+	forward->tuple[!dir].dst_port.dst_vlan_tag = vid;
+	forward->tuple[dir].vlan_tag = vid;
+
+	return 0;
+
+err:
+	dev_put(forward->tuple[dir].dst_port.dev);
+	dev_put(forward->tuple[!dir].dst_port.dev);
+#endif
+	return -ENOENT;
+}
+
 static bool nft_flow_offload_skip(struct sk_buff *skb, int family)
 {
 	if (skb_sec_path(skb))
 		return true;
 
-	if (family == NFPROTO_IPV4) {
+	switch (family) {
+	case NFPROTO_IPV4: {
 		const struct ip_options *opt;
 
 		opt = &(IPCB(skb)->opt);
 
 		if (unlikely(opt->optlen))
 			return true;
+		break;
+	}
+	case NFPROTO_BRIDGE: {
+		if (skb->protocol != htons(ETH_P_IPV6) &&
+		    skb->protocol != htons(ETH_P_IP))
+			return true;
+
+		if (skb->protocol == htons(ETH_P_IP)) {
+			const struct iphdr *iph;
+
+			iph = ip_hdr(skb);
+			if (iph->ihl > 5)
+				return true;
+		}
+		break;
+	}
 	}
 
 	return false;
 }
 
+static void flow_offload_release_dst(struct nf_flow_dst *flow_dst,
+				     enum ip_conntrack_dir dir)
+{
+	if (flow_dst->type == FLOW_OFFLOAD_TYPE_BRIDGE) {
+		dev_put(flow_dst->forward.tuple[dir].dst_port.dev);
+		dev_put(flow_dst->forward.tuple[!dir].dst_port.dev);
+	} else {
+		dst_release(flow_dst->route.tuple[!dir].dst);
+	}
+}
+
+static int flow_offload_get_dst(const struct nft_pktinfo *pkt, struct nf_conn *ct,
+				enum ip_conntrack_dir dir, int family,
+				struct nf_flow_dst *flow_dst)
+{
+	if (family == NFPROTO_BRIDGE) {
+		flow_dst->type = FLOW_OFFLOAD_TYPE_BRIDGE;
+		if (nft_flow_forward(pkt, ct, &flow_dst->forward, dir) < 0)
+			return -1;
+	} else {
+		flow_dst->type = FLOW_OFFLOAD_TYPE_INET;
+		if (nft_flow_route(pkt, ct, &flow_dst->route, dir) < 0)
+			return -1;
+	}
+
+	return 0;
+}
+
 static void nft_flow_offload_eval(const struct nft_expr *expr,
 				  struct nft_regs *regs,
 				  const struct nft_pktinfo *pkt)
@@ -76,11 +196,12 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	struct nf_flow_dst flow_dst;
 	struct flow_offload *flow;
 	enum ip_conntrack_dir dir;
+	int family = nft_pf(pkt);
 	bool is_tcp = false;
 	struct nf_conn *ct;
 	int ret;
 
-	if (nft_flow_offload_skip(pkt->skb, nft_pf(pkt)))
+	if (nft_flow_offload_skip(pkt->skb, family))
 		goto out;
 
 	ct = nf_ct_get(pkt->skb, &ctinfo);
@@ -108,8 +229,9 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 		goto out;
 
 	dir = CTINFO2DIR(ctinfo);
-	if (nft_flow_route(pkt, ct, &flow_dst.route, dir) < 0)
-		goto err_flow_route;
+
+	if (flow_offload_get_dst(pkt, ct, dir, family, &flow_dst) < 0)
+		goto err_flow_dst;
 
 	flow = flow_offload_alloc(ct, &flow_dst);
 	if (!flow)
@@ -124,14 +246,16 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (ret < 0)
 		goto err_flow_add;
 
-	dst_release(flow_dst.route.tuple[!dir].dst);
+	if (family != NFPROTO_BRIDGE)
+		dst_release(flow_dst.route.tuple[!dir].dst);
+
 	return;
 
 err_flow_add:
 	flow_offload_free(flow);
 err_flow_alloc:
-	dst_release(flow_dst.route.tuple[!dir].dst);
-err_flow_route:
+	flow_offload_release_dst(&flow_dst, dir);
+err_flow_dst:
 	clear_bit(IPS_OFFLOAD_BIT, &ct->status);
 out:
 	regs->verdict.code = NFT_BREAK;
-- 
1.8.3.1

