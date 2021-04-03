Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA58C433ED
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Apr 2021 13:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95BCA611ED
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Apr 2021 13:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbhDCN7t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 3 Apr 2021 09:59:49 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:18404 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbhDCN7t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 3 Apr 2021 09:59:49 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id D5E26E01E61;
        Sat,  3 Apr 2021 21:59:43 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v2 2/2] netfilter: flowtable: add vlan pop action offload support
Date:   Sat,  3 Apr 2021 21:59:43 +0800
Message-Id: <1617458383-8620-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617458383-8620-1-git-send-email-wenxu@ucloud.cn>
References: <1617458383-8620-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZTR0eTk1NTB8ZTUIaVkpNSkxPTkNIQ0hCS0xVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MSI6PCo6KD0zEwwhSTwLCDU2
        GgsKCSFVSlVKTUpMT05DSENPS0lLVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlKTEo3Bg++
X-HM-Tid: 0a7898084c1020bdkuqyd5e26e01e61
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch add vlan pop action offload in the flowtable
offload.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_flow_table_offload.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index dc1d6b4..b87f8c3 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -619,6 +619,7 @@ static void flow_offload_decap_tunnel(const struct flow_offload *flow,
 			  struct nf_flow_rule *flow_rule)
 {
 	const struct flow_offload_tuple *other_tuple;
+	const struct flow_offload_tuple *tuple;
 	int i;
 
 	flow_offload_decap_tunnel(flow, dir, flow_rule);
@@ -628,6 +629,20 @@ static void flow_offload_decap_tunnel(const struct flow_offload *flow,
 	    flow_offload_eth_dst(net, flow, dir, flow_rule) < 0)
 		return -1;
 
+	tuple = &flow->tuplehash[dir].tuple;
+
+	for (i = 0; i < tuple->encap_num; i++) {
+		struct flow_action_entry *entry;
+
+		if (tuple->in_vlan_ingress & BIT(i))
+			continue;
+
+		if (tuple->encap[i].proto == htons(ETH_P_8021Q)) {
+			entry = flow_action_entry_next(flow_rule);
+			entry->id = FLOW_ACTION_VLAN_POP;
+		}
+	}
+
 	other_tuple = &flow->tuplehash[!dir].tuple;
 
 	for (i = 0; i < other_tuple->encap_num; i++) {
-- 
1.8.3.1

