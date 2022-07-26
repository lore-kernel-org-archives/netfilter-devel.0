Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC4E9C43334
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Jul 2022 04:55:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiGZEz3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Jul 2022 00:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbiGZEz3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Jul 2022 00:55:29 -0400
X-Greylist: delayed 570 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 25 Jul 2022 21:55:23 PDT
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D8C85F97
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Jul 2022 21:55:22 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.188:51252.1464825350
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-180.167.241.60 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id E03F12800AB;
        Tue, 26 Jul 2022 12:45:46 +0800 (CST)
X-189-SAVE-TO-SEND: wenxu@chinatelecom.cn
Received: from  ([172.18.0.188])
        by app0023 with ESMTP id 118ad983f4a94e4e87826153003e6e2b for pablo@netfilter.org;
        Tue, 26 Jul 2022 12:45:47 CST
X-Transaction-ID: 118ad983f4a94e4e87826153003e6e2b
X-Real-From: wenxu@chinatelecom.cn
X-Receive-IP: 172.18.0.188
X-MEDUSA-Status: 0
Sender: wenxu@chinatelecom.cn
From:   wenxu@chinatelecom.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_flow_table: delay teardown the offload flow until fin packet recv from both direction
Date:   Tue, 26 Jul 2022 00:45:16 -0400
Message-Id: <1658810716-106274-1-git-send-email-wenxu@chinatelecom.cn>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@chinatelecom.cn>

A fin packet receive not always means the tcp connection teardown.
For tcp half close case, only the client shutdown the connection
and the server still can sendmsg to the client. The connection
can still be offloaded until the server shutdown the connection.

Signed-off-by: wenxu <wenxu@chinatelecom.cn>
---
 include/net/netfilter/nf_flow_table.h |  3 ++-
 net/netfilter/nf_flow_table_ip.c      | 14 ++++++++++----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index d5326c4..0c4864d 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -129,7 +129,8 @@ struct flow_offload_tuple {
 	/* All members above are keys for lookups, see flow_offload_hash(). */
 	struct { }			__hash;
 
-	u8				dir:2,
+	u8				dir:1,
+					fin:1,
 					xmit_type:3,
 					encap_num:2,
 					in_vlan_ingress:2;
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index b350fe9..c191861 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -19,7 +19,8 @@
 #include <linux/udp.h>
 
 static int nf_flow_state_check(struct flow_offload *flow, int proto,
-			       struct sk_buff *skb, unsigned int thoff)
+			       struct sk_buff *skb, unsigned int thoff,
+			       enum flow_offload_tuple_dir dir)
 {
 	struct tcphdr *tcph;
 
@@ -27,9 +28,14 @@ static int nf_flow_state_check(struct flow_offload *flow, int proto,
 		return 0;
 
 	tcph = (void *)(skb_network_header(skb) + thoff);
-	if (unlikely(tcph->fin || tcph->rst)) {
+	if (unlikely(tcph->rst)) {
 		flow_offload_teardown(flow);
 		return -1;
+	} else if (unlikely(tcph->fin)) {
+		flow->tuplehash[dir].tuple.fin = 1;
+		if (flow->tuplehash[!dir].tuple.fin == 1)
+			flow_offload_teardown(flow);
+		return -1;
 	}
 
 	return 0;
@@ -373,7 +379,7 @@ static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
 
 	iph = (struct iphdr *)(skb_network_header(skb) + offset);
 	thoff = (iph->ihl * 4) + offset;
-	if (nf_flow_state_check(flow, iph->protocol, skb, thoff))
+	if (nf_flow_state_check(flow, iph->protocol, skb, thoff, dir))
 		return NF_ACCEPT;
 
 	if (!nf_flow_dst_check(&tuplehash->tuple)) {
@@ -635,7 +641,7 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 
 	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
 	thoff = sizeof(*ip6h) + offset;
-	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, thoff))
+	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, thoff, dir))
 		return NF_ACCEPT;
 
 	if (!nf_flow_dst_check(&tuplehash->tuple)) {
-- 
1.8.3.1

