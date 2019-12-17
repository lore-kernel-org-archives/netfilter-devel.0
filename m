Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457BBC43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 08:52:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 225BB2072D
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 08:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfLQIw4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 03:52:56 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:20053 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbfLQIw4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 03:52:56 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 79560419D3;
        Tue, 17 Dec 2019 16:52:48 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf v2 2/3] netfilter: nf_flow_table_offload: check the status of dst_neigh
Date:   Tue, 17 Dec 2019 16:52:46 +0800
Message-Id: <1576572767-19779-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1576572767-19779-1-git-send-email-wenxu@ucloud.cn>
References: <1576572767-19779-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkJNS0tLSUpDSEJKT0lZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PQg6OBw5NDgwPU1IER0xPD8T
        Lw5PFB5VSlVKTkxNTkxJTE1DTU5IVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlOS0s3Bg++
X-HM-Tid: 0a6f130f50ff2086kuqy79560419d3
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
v2: neigh_release for non NUD_VALID neighbor
 
 net/netfilter/nf_flow_table_offload.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 91dd6eb..acaa1ef 100644
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
@@ -179,13 +181,23 @@ static int flow_offload_eth_dst(struct net *net,
 	if (!n)
 		return -ENOENT;
 
+	read_lock_bh(&n->lock);
+	nud_state = n->nud_state;
+	ether_addr_copy(ha, n->ha);
+	read_unlock_bh(&n->lock);
+
+	if (!(nud_state & NUD_VALID)) {
+		neigh_release(n);
+		return -ENOENT;
+	}
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

