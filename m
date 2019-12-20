Return-Path: <SRS0=tkBW=2K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BC06C2D0C0
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 04:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D24042073D
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 04:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfLTEOo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 23:14:44 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:27217 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbfLTEOo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 23:14:44 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 5AE765C1604;
        Fri, 20 Dec 2019 12:14:39 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf v3 2/3] netfilter: nf_flow_table_offload: check the status of dst_neigh
Date:   Fri, 20 Dec 2019 12:14:37 +0800
Message-Id: <1576815278-1283-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1576815278-1283-1-git-send-email-wenxu@ucloud.cn>
References: <1576815278-1283-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkJDS0tLS0xIT0hJQklZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ogw6Egw6ODg0MUwOHwMsI0IS
        OjkwCTFVSlVKTkxNQ0pOSUxCT09CVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlOT003Bg++
X-HM-Tid: 0a6f2183bd1d2087kuqy5ae765c1604
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

It is better to get the dst_neigh with neigh->lock and check the
nud_state is VALID. If there is not neigh previous, the lookup will
Create a non NUD_VALID with 00:00:00:00:00:00 mac.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_flow_table_offload.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index ee9edbe..92b0bd2 100644
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

