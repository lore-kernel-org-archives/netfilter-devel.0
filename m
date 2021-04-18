Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32EAAC43460
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Apr 2021 21:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CACB6135D
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Apr 2021 21:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbhDRVEz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Apr 2021 17:04:55 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34980 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbhDRVEx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Apr 2021 17:04:53 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 790B663E89;
        Sun, 18 Apr 2021 23:03:54 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 02/14] netfilter: flowtable: add vlan pop action offload support
Date:   Sun, 18 Apr 2021 23:04:03 +0200
Message-Id: <20210418210415.4719-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210418210415.4719-1-pablo@netfilter.org>
References: <20210418210415.4719-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch adds vlan pop action offload in the flowtable offload.

Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index dc1d6b4e35f8..b87f8c3ee6c2 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -619,6 +619,7 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
 			  struct nf_flow_rule *flow_rule)
 {
 	const struct flow_offload_tuple *other_tuple;
+	const struct flow_offload_tuple *tuple;
 	int i;
 
 	flow_offload_decap_tunnel(flow, dir, flow_rule);
@@ -628,6 +629,20 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
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
2.30.2

