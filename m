Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBCDFC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 May 2022 06:57:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234027AbiEZG55 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 May 2022 02:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242736AbiEZG5y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 May 2022 02:57:54 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B84095BD31
        for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2022 23:57:52 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.188:47608.1673014714
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-101.229.165.111 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id B96DE2800B5;
        Thu, 26 May 2022 14:57:45 +0800 (CST)
X-189-SAVE-TO-SEND: +wenxu@chinatelecom.cn
Received: from  ([172.18.0.188])
        by app0023 with ESMTP id 66a3282bc56443f6aa4fad7a92343bd2 for pablo@netfilter.org;
        Thu, 26 May 2022 14:57:46 CST
X-Transaction-ID: 66a3282bc56443f6aa4fad7a92343bd2
X-Real-From: wenxu@chinatelecom.cn
X-Receive-IP: 172.18.0.188
X-MEDUSA-Status: 0
Sender: wenxu@chinatelecom.cn
From:   wenxu@chinatelecom.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, wenxu@chinatelecom.cn
Subject: [PATCH nf-next v2 1/3] nf_flow_table_offload: offload the vlan encap in the flowtable
Date:   Thu, 26 May 2022 02:57:30 -0400
Message-Id: <1653548252-2602-1-git-send-email-wenxu@chinatelecom.cn>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@chinatelecom.cn>

This patch put the vlan dev process in the FLOW_OFFLOAD_XMIT_DIRECT
mode. Xmit the packet with vlan can offload to the real dev directly.

It can support all kinds of VLAN dev path:
br0.100-->br0(vlan filter enable)-->eth
br0(vlan filter enable)-->eth
br0(vlan filter disable)-->eth.100-->eth

The packet xmit and recv offload to the 'eth' in both original and
reply direction.

Signed-off-by: wenxu <wenxu@chinatelecom.cn>
---
 net/netfilter/nf_flow_table_ip.c | 19 +++++++++++++++++++
 net/netfilter/nft_flow_offload.c |  9 ++++++---
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index b350fe9..5da651d 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -291,6 +291,23 @@ static bool nf_flow_skb_encap_protocol(const struct sk_buff *skb, __be16 proto,
 	return false;
 }
 
+static void nf_flow_encap_push(struct sk_buff *skb,
+			       struct flow_offload_tuple_rhash *tuplehash)
+{
+	int i;
+
+	for (i = 0; i < tuplehash->tuple.encap_num; i++) {
+		switch (tuplehash->tuple.encap[i].proto) {
+		case htons(ETH_P_8021Q):
+		case htons(ETH_P_8021AD):
+			skb_vlan_push(skb,
+				      tuplehash->tuple.encap[i].proto,
+				      tuplehash->tuple.encap[i].id);
+			break;
+		}
+	}
+}
+
 static void nf_flow_encap_pop(struct sk_buff *skb,
 			      struct flow_offload_tuple_rhash *tuplehash)
 {
@@ -417,6 +434,7 @@ static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
 		ret = NF_STOLEN;
 		break;
 	case FLOW_OFFLOAD_XMIT_DIRECT:
+		nf_flow_encap_push(skb, &flow->tuplehash[!dir]);
 		ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IP);
 		if (ret == NF_DROP)
 			flow_offload_teardown(flow);
@@ -678,6 +696,7 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 		ret = NF_STOLEN;
 		break;
 	case FLOW_OFFLOAD_XMIT_DIRECT:
+		nf_flow_encap_push(skb, &flow->tuplehash[!dir]);
 		ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IPV6);
 		if (ret == NF_DROP)
 			flow_offload_teardown(flow);
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index a25c88b..bfe7a3a 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -123,13 +123,16 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				info->indev = NULL;
 				break;
 			}
-			if (!info->outdev)
-				info->outdev = path->dev;
 			info->encap[info->num_encaps].id = path->encap.id;
 			info->encap[info->num_encaps].proto = path->encap.proto;
 			info->num_encaps++;
-			if (path->type == DEV_PATH_PPPOE)
+			if (path->type == DEV_PATH_PPPOE) {
+				if (!info->outdev)
+					info->outdev = path->dev;
 				memcpy(info->h_dest, path->encap.h_dest, ETH_ALEN);
+			}
+			if (path->type == DEV_PATH_VLAN)
+				info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 			break;
 		case DEV_PATH_BRIDGE:
 			if (is_zero_ether_addr(info->h_source))
-- 
1.8.3.1

