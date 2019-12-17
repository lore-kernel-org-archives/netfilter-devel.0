Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 410B7C2D0C5
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 08:52:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 177492072D
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 08:52:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfLQIw5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 03:52:57 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:20025 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbfLQIw5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 03:52:57 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 3999641A69;
        Tue, 17 Dec 2019 16:52:48 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf v2 1/3] netfilter: nf_flow_table_offload: fix dst_neigh lookup
Date:   Tue, 17 Dec 2019 16:52:45 +0800
Message-Id: <1576572767-19779-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1576572767-19779-1-git-send-email-wenxu@ucloud.cn>
References: <1576572767-19779-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkJNS0tLSUpDSEJKT0lZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NBA6Kgw4OTg1MU0rLx8QPDYp
        KjMKCTRVSlVKTkxNTkxJTE1DT0lCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlKS0M3Bg++
X-HM-Tid: 0a6f130f4ff92086kuqy3999641a69
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Get the dst_neigh through dst_ip, The dst_ip should get
through peer tuple.src_v4 fix for dnat case.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v2: no change

 net/netfilter/nf_flow_table_offload.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index de7a0d1..91dd6eb 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -166,14 +166,16 @@ static int flow_offload_eth_dst(struct net *net,
 				enum flow_offload_tuple_dir dir,
 				struct nf_flow_rule *flow_rule)
 {
-	const struct flow_offload_tuple *tuple = &flow->tuplehash[dir].tuple;
 	struct flow_action_entry *entry0 = flow_action_entry_next(flow_rule);
 	struct flow_action_entry *entry1 = flow_action_entry_next(flow_rule);
+	const void *daddr = &flow->tuplehash[!dir].tuple.src_v4;
+	const struct dst_entry *dst_cache;
 	struct neighbour *n;
 	u32 mask, val;
 	u16 val16;
 
-	n = dst_neigh_lookup(tuple->dst_cache, &tuple->dst_v4);
+	dst_cache = flow->tuplehash[dir].tuple.dst_cache;
+	n = dst_neigh_lookup(dst_cache, daddr);
 	if (!n)
 		return -ENOENT;
 
-- 
1.8.3.1

