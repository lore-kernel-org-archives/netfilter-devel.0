Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26D48C433B4
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 07:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3AFE610CA
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 07:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233151AbhDAHuR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Apr 2021 03:50:17 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:17829 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbhDAHuP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 03:50:15 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id CB392E02B59;
        Thu,  1 Apr 2021 15:50:11 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 2/2] netfilter: flowtable: add vlan pop action offload support
Date:   Thu,  1 Apr 2021 15:50:11 +0800
Message-Id: <1617263411-3244-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617263411-3244-1-git-send-email-wenxu@ucloud.cn>
References: <1617263411-3244-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZTxgeTB9MT04aTk8fVkpNSkxJTUhPSkpDTUtVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MjY6NBw*KD0yHwhRTTxWOTQf
        MDRPCxJVSlVKTUpMSU1IT0pJS0xIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlKTU03Bg++
X-HM-Tid: 0a788c69428120bdkuqycb392e02b59
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
index ee882127..e097273 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -621,6 +621,7 @@ static void flow_offload_decap_tunnel(const struct flow_offload *flow,
 			  struct nf_flow_rule *flow_rule)
 {
 	const struct flow_offload_tuple *other_tuple;
+	const struct flow_offload_tuple *tuple;
 	int i;
 
 	flow_offload_decap_tunnel(flow, dir, flow_rule);
@@ -630,6 +631,20 @@ static void flow_offload_decap_tunnel(const struct flow_offload *flow,
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

