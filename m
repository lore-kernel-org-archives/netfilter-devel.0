Return-Path: <SRS0=xvfr=2C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A5E6C2D0CA
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Dec 2019 09:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7810222527
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Dec 2019 09:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbfLLJn7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Dec 2019 04:43:59 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:29237 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728261AbfLLJn7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 04:43:59 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 3EE7341C9F;
        Thu, 12 Dec 2019 17:43:56 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf 4/4] netfilter: nf_flow_table_offload: fix the nat port mangle.
Date:   Thu, 12 Dec 2019 17:43:55 +0800
Message-Id: <1576143835-19749-5-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1576143835-19749-1-git-send-email-wenxu@ucloud.cn>
References: <1576143835-19749-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkJOQkJCQkxCQkxJQ09ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ny46USo6Qzg5TEgYCBEVFRks
        LjwKCylVSlVKTkxNSk9IQ0hNSE5PVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhNT0s3Bg++
X-HM-Tid: 0a6ef97e546e2086kuqy3ee7341c9f
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

For dnat:
The original dir maybe modify the dst port to src port of reply dir
The reply dir maybe modify the src port to dst port of origin dir

For snat:
The original dir maybe modify the src port to dst port of reply dir
The reply dir maybe modify the dst port to src port of reply dir

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_flow_table_offload.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 2ce6001..ed2746f 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -353,22 +353,26 @@ static void flow_offload_port_snat(struct net *net,
 				   struct nf_flow_rule *flow_rule)
 {
 	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
-	u32 mask = ~htonl(0xffff0000), port;
+	u32 mask, port;
 	u32 offset;
 
 	switch (dir) {
 	case FLOW_OFFLOAD_DIR_ORIGINAL:
 		port = ntohs(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_port);
 		offset = 0; /* offsetof(struct tcphdr, source); */
+		port = htonl(port << 16);
+		mask = ~htonl(0xffff0000);
 		break;
 	case FLOW_OFFLOAD_DIR_REPLY:
 		port = ntohs(flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_port);
 		offset = 0; /* offsetof(struct tcphdr, dest); */
+		port = htonl(port);
+		mask = ~htonl(0xffff);
 		break;
 	default:
 		return;
 	}
-	port = htonl(port << 16);
+
 	flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
 			    &port, &mask);
 }
@@ -379,22 +383,26 @@ static void flow_offload_port_dnat(struct net *net,
 				   struct nf_flow_rule *flow_rule)
 {
 	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
-	u32 mask = ~htonl(0xffff), port;
+	u32 mask, port;
 	u32 offset;
 
 	switch (dir) {
 	case FLOW_OFFLOAD_DIR_ORIGINAL:
-		port = ntohs(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_port);
-		offset = 0; /* offsetof(struct tcphdr, source); */
+		port = ntohs(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.src_port);
+		offset = 0; /* offsetof(struct tcphdr, dest); */
+		port = htonl(port);
+		mask = ~htonl(0xffff);
 		break;
 	case FLOW_OFFLOAD_DIR_REPLY:
-		port = ntohs(flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_port);
-		offset = 0; /* offsetof(struct tcphdr, dest); */
+		port = ntohs(flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_port);
+		offset = 0; /* offsetof(struct tcphdr, source); */
+		port = htonl(port << 16);
+		mask = ~htonl(0xffff0000);
 		break;
 	default:
 		return;
 	}
-	port = htonl(port);
+
 	flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
 			    &port, &mask);
 }
-- 
1.8.3.1

