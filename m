Return-Path: <SRS0=s0US=5F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F955C4332D
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Mar 2020 12:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 292BE20739
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Mar 2020 12:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgCTM5R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Mar 2020 08:57:17 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:16747 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbgCTM5R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Mar 2020 08:57:17 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id CDC99415DF;
        Fri, 20 Mar 2020 20:57:09 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v2] netfilter: nf_flow_table_offload: set hw_stats_type of flow_action_entry to FLOW_ACTION_HW_STATS_ANY
Date:   Fri, 20 Mar 2020 20:57:09 +0800
Message-Id: <1584709029-20268-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVJQ0JLS0tLSE9ISElJQ1lXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nz46Dyo*CDg6EhweHkofETML
        MDgKCR1VSlVKTkNPTEtCS0lCQkpNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpNSk03Bg++
X-HM-Tid: 0a70f804cfda2086kuqycdc99415df
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Set hw_stats_type of flow_action_entry to FLOW_ACTION_HW_STATS_ANY to
follow the driver behavior.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_flow_table_offload.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index a68136a..88d2ac5 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -165,8 +165,12 @@ static void flow_offload_mangle(struct flow_action_entry *entry,
 flow_action_entry_next(struct nf_flow_rule *flow_rule)
 {
 	int i = flow_rule->rule->action.num_entries++;
+	struct flow_action_entry *entry;
+
+	entry = &flow_rule->rule->action.entries[i];
+	entry->hw_stats_type = FLOW_ACTION_HW_STATS_ANY;
 
-	return &flow_rule->rule->action.entries[i];
+	return entry;
 }
 
 static int flow_offload_eth_src(struct net *net,
-- 
1.8.3.1

