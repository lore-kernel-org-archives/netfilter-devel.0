Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACCD2C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 May 2022 06:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346343AbiEZG57 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 May 2022 02:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242565AbiEZG5y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 May 2022 02:57:54 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C6CD77A836
        for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2022 23:57:52 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.188:47608.1673014714
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-101.229.165.111 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id 7BBF92800B1;
        Thu, 26 May 2022 14:57:46 +0800 (CST)
X-189-SAVE-TO-SEND: +wenxu@chinatelecom.cn
Received: from  ([172.18.0.188])
        by app0023 with ESMTP id 1741483c613c4bafb785fee3c4f6cb04 for pablo@netfilter.org;
        Thu, 26 May 2022 14:57:49 CST
X-Transaction-ID: 1741483c613c4bafb785fee3c4f6cb04
X-Real-From: wenxu@chinatelecom.cn
X-Receive-IP: 172.18.0.188
X-MEDUSA-Status: 0
Sender: wenxu@chinatelecom.cn
From:   wenxu@chinatelecom.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, wenxu@chinatelecom.cn
Subject: [PATCH nf-next v2 2/3] nf_flow_table_offload: offload the PPPoE encap in the flowtable
Date:   Thu, 26 May 2022 02:57:31 -0400
Message-Id: <1653548252-2602-2-git-send-email-wenxu@chinatelecom.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1653548252-2602-1-git-send-email-wenxu@chinatelecom.cn>
References: <1653548252-2602-1-git-send-email-wenxu@chinatelecom.cn>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@chinatelecom.cn>

This patch put the pppoe process in the FLOW_OFFLOAD_XMIT_DIRECT
mode. Xmit the packet with PPPoE can offload to the underlay device
directly.

It can support all kinds of VLAN dev path:
pppoe-->eth
pppoe-->br0.100-->br0(vlan filter enable)-->eth
pppoe-->eth.100-->eth

The packet xmit and recv offload to the 'eth' in both original and
reply direction.

Signed-off-by: wenxu <wenxu@chinatelecom.cn>
---
 include/net/netfilter/nf_flow_table.h | 34 ++++++++++++++++++++++++++++++++++
 net/netfilter/nf_flow_table_ip.c      |  3 +++
 net/netfilter/nft_flow_offload.c      | 11 +++--------
 3 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 64daafd..a0b310e 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -319,6 +319,40 @@ int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
 int nf_flow_table_offload_init(void);
 void nf_flow_table_offload_exit(void);
 
+static inline int nf_flow_ppoe_push(struct sk_buff *skb, u16 id)
+{
+	struct ppp_hdr {
+		struct pppoe_hdr hdr;
+		__be16 proto;
+	} *ph;
+	int data_len = skb->len + 2;
+	__be16 proto;
+
+	if (skb_cow_head(skb, PPPOE_SES_HLEN))
+		return -1;
+
+	if (skb->protocol == htons(ETH_P_IP))
+		proto = htons(PPP_IP);
+	else if (skb->protocol == htons(ETH_P_IPV6))
+		proto = htons(PPP_IPV6);
+	else
+		return -1;
+
+	__skb_push(skb, PPPOE_SES_HLEN);
+	skb_reset_network_header(skb);
+
+	ph = (struct ppp_hdr *)(skb->data);
+	ph->hdr.ver  = 1;
+	ph->hdr.type = 1;
+	ph->hdr.code = 0;
+	ph->hdr.sid  = htons(id);
+	ph->hdr.length = htons(data_len);
+	ph->proto = proto;
+	skb->protocol = htons(ETH_P_PPP_SES);
+
+	return 0;
+}
+
 static inline __be16 nf_flow_pppoe_proto(const struct sk_buff *skb)
 {
 	__be16 proto;
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 5da651d..a0c640e 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -304,6 +304,9 @@ static void nf_flow_encap_push(struct sk_buff *skb,
 				      tuplehash->tuple.encap[i].proto,
 				      tuplehash->tuple.encap[i].id);
 			break;
+		case htons(ETH_P_PPP_SES):
+			nf_flow_ppoe_push(skb, tuplehash->tuple.encap[i].id);
+			break;
 		}
 	}
 }
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index bfe7a3a..9296a1f 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -126,13 +126,9 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 			info->encap[info->num_encaps].id = path->encap.id;
 			info->encap[info->num_encaps].proto = path->encap.proto;
 			info->num_encaps++;
-			if (path->type == DEV_PATH_PPPOE) {
-				if (!info->outdev)
-					info->outdev = path->dev;
+			if (path->type == DEV_PATH_PPPOE)
 				memcpy(info->h_dest, path->encap.h_dest, ETH_ALEN);
-			}
-			if (path->type == DEV_PATH_VLAN)
-				info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
+			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 			break;
 		case DEV_PATH_BRIDGE:
 			if (is_zero_ether_addr(info->h_source))
@@ -160,8 +156,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 			break;
 		}
 	}
-	if (!info->outdev)
-		info->outdev = info->indev;
+	info->outdev = info->indev;
 
 	info->hw_outdev = info->indev;
 
-- 
1.8.3.1

