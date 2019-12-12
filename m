Return-Path: <SRS0=xvfr=2C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBBFAC2D0C9
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Dec 2019 10:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91CD721655
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Dec 2019 10:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbfLLKHU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Dec 2019 05:07:20 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:43642 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728327AbfLLKHT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 05:07:19 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 94E1D41A96;
        Thu, 12 Dec 2019 18:07:17 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf 2/3] netfilter: nf_flow_table_offload: check the status of dst_neigh
Date:   Thu, 12 Dec 2019 18:07:16 +0800
Message-Id: <1576145237-20290-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1576145237-20290-1-git-send-email-wenxu@ucloud.cn>
References: <1576145237-20290-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSk9PS0tLS05IT0tOTE1ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Kwg6Ohw5Pjg4TEhJTQgMKBA8
        S0gwCkxVSlVKTkxNSk9OSUhMTUxKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlPSk83Bg++
X-HM-Tid: 0a6ef993b6772086kuqy94e1d41a96
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

It is better to get the dst_neigh with neigh->lock and check the
nud_state is VALID

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_flow_table_offload.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 91dd6eb..e9f95b5 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -170,8 +170,10 @@ static int flow_offload_eth_dst(struct net *net,
 	struct flow_action_entry *entry1 = flow_action_entry_next(flow_rule);
 	const void *daddr = &flow->tuplehash[!dir].tuple.src_v4;
 	const struct dst_entry *dst_cache;
+	unsigned char ha[ETH_ALEN];
 	struct neighbour *n;
 	u32 mask, val;
+	u8 nud_state;
 	u16 val16;
 
 	dst_cache = flow->tuplehash[dir].tuple.dst_cache;
@@ -179,13 +181,21 @@ static int flow_offload_eth_dst(struct net *net,
 	if (!n)
 		return -ENOENT;
 
+	read_lock_bh(&n->lock);
+	nud_state = n->nud_state;
+	ether_addr_copy(ha, n->ha);
+	read_unlock_bh(&n->lock);
+
+	if (!(nud_state & NUD_VALID))
+		return -ENOENT;
+
 	mask = ~0xffffffff;
-	memcpy(&val, n->ha, 4);
+	memcpy(&val, ha, 4);
 	flow_offload_mangle(entry0, FLOW_ACT_MANGLE_HDR_TYPE_ETH, 0,
 			    &val, &mask);
 
 	mask = ~0x0000ffff;
-	memcpy(&val16, n->ha + 4, 2);
+	memcpy(&val16, ha + 4, 2);
 	val = val16;
 	flow_offload_mangle(entry1, FLOW_ACT_MANGLE_HDR_TYPE_ETH, 4,
 			    &val, &mask);
-- 
1.8.3.1

