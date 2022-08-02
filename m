Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE66C00140
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Aug 2022 06:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbiHBG3V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Aug 2022 02:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbiHBG3U (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Aug 2022 02:29:20 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8C8CD1A385
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2022 23:29:18 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.188:45828.1184787701
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-180.167.241.60 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id F3A032800C1;
        Tue,  2 Aug 2022 14:29:10 +0800 (CST)
X-189-SAVE-TO-SEND: wenxu@chinatelecom.cn
Received: from  ([172.18.0.188])
        by app0023 with ESMTP id 11f902d410e24505bfdf930777aecc99 for pablo@netfilter.org;
        Tue, 02 Aug 2022 14:29:10 CST
X-Transaction-ID: 11f902d410e24505bfdf930777aecc99
X-Real-From: wenxu@chinatelecom.cn
X-Receive-IP: 172.18.0.188
X-MEDUSA-Status: 0
Sender: wenxu@chinatelecom.cn
From:   wenxu@chinatelecom.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v2] netfilter: nf_flow_table: delay teardown the offload flow until fin packet recv from both direction
Date:   Tue,  2 Aug 2022 02:28:36 -0400
Message-Id: <1659421716-109151-1-git-send-email-wenxu@chinatelecom.cn>
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
 include/net/netfilter/nf_flow_table.h |  2 ++
 net/netfilter/nf_flow_table_ip.c      | 19 +++++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index d5326c4..57481df 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -164,6 +164,8 @@ enum nf_flow_flags {
 	NF_FLOW_HW_DYING,
 	NF_FLOW_HW_DEAD,
 	NF_FLOW_HW_PENDING,
+	NF_FLOW_FIN_ORIGINAL,
+	NF_FLOW_FIN_REPLY,
 };
 
 enum flow_offload_type {
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index b350fe9..94f1c00 100644
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
 
@@ -27,9 +28,19 @@ static int nf_flow_state_check(struct flow_offload *flow, int proto,
 		return 0;
 
 	tcph = (void *)(skb_network_header(skb) + thoff);
-	if (unlikely(tcph->fin || tcph->rst)) {
+	if (unlikely(tcph->rst)) {
 		flow_offload_teardown(flow);
 		return -1;
+	} else if (unlikely(tcph->fin)) {
+		if (dir == FLOW_OFFLOAD_DIR_ORIGINAL)
+			set_bit(NF_FLOW_FIN_ORIGINAL, &flow->flags);
+		else if (dir == FLOW_OFFLOAD_DIR_REPLY)
+			set_bit(NF_FLOW_FIN_REPLY, &flow->flags);
+
+		if (test_bit(NF_FLOW_FIN_ORIGINAL, &flow->flags) &&
+		    test_bit(NF_FLOW_FIN_REPLY, &flow->flags))
+			flow_offload_teardown(flow);
+		return -1;
 	}
 
 	return 0;
@@ -373,7 +384,7 @@ static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
 
 	iph = (struct iphdr *)(skb_network_header(skb) + offset);
 	thoff = (iph->ihl * 4) + offset;
-	if (nf_flow_state_check(flow, iph->protocol, skb, thoff))
+	if (nf_flow_state_check(flow, iph->protocol, skb, thoff, dir))
 		return NF_ACCEPT;
 
 	if (!nf_flow_dst_check(&tuplehash->tuple)) {
@@ -635,7 +646,7 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 
 	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
 	thoff = sizeof(*ip6h) + offset;
-	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, thoff))
+	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, thoff, dir))
 		return NF_ACCEPT;
 
 	if (!nf_flow_dst_check(&tuplehash->tuple)) {
-- 
1.8.3.1

