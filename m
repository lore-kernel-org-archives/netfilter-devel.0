Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42848C433B4
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Apr 2021 20:00:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11437610CD
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Apr 2021 20:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbhDRUAm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Apr 2021 16:00:42 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34898 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhDRUAk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Apr 2021 16:00:40 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3A6ED63E84;
        Sun, 18 Apr 2021 21:59:41 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     wenxu@cloud.cn
Subject: [PATCH 3/3,v4] netfilter: nftables_offload: special ethertype handling for VLAN
Date:   Sun, 18 Apr 2021 22:00:06 +0200
Message-Id: <20210418200006.20797-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The nftables offload parser sets FLOW_DISSECTOR_KEY_BASIC .n_proto to the
ethertype field in the ethertype frame. However:

- FLOW_DISSECTOR_KEY_BASIC .n_proto field always stores either IPv4 or IPv6
  ethertypes.
- FLOW_DISSECTOR_KEY_VLAN .vlan_tpid stores either the 802.1q and 802.1ad
  ethertypes. Same as for FLOW_DISSECTOR_KEY_CVLAN.

This function adjusts the flow dissector to handle two scenarios:

1) FLOW_DISSECTOR_KEY_VLAN .vlan_tpid is set to 802.1q or 802.1ad.
   Then, transfer:
   - the .n_proto field to FLOW_DISSECTOR_KEY_VLAN .tpid.
   - the original FLOW_DISSECTOR_KEY_VLAN .tpid to the
     FLOW_DISSECTOR_KEY_CVLAN .tpid
   - the original FLOW_DISSECTOR_KEY_CVLAN .tpid to the .n_proto field.

2) .n_proto is set to 802.1q or 802.1ad. Then, transfer:
   - the .n_proto field to FLOW_DISSECTOR_KEY_VLAN .tpid.
   - the original FLOW_DISSECTOR_KEY_VLAN .tpid to the .n_proto field.

Fixes: a82055af5959 ("netfilter: nft_payload: add VLAN offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: missing check for .used_keys flags.

 net/netfilter/nf_tables_offload.c | 45 +++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 43b56eff3b04..0ae2fbf3d97b 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -47,6 +47,49 @@ void nft_flow_rule_set_addr_type(struct nft_flow_rule *flow,
 		offsetof(struct nft_flow_key, control);
 }
 
+struct nft_offload_ethertype {
+	__be16 value;
+	__be16 mask;
+};
+
+static void nft_flow_rule_transfer_vlan(struct nft_offload_ctx *ctx,
+					struct nft_flow_rule *flow)
+{
+	struct nft_flow_match *match = &flow->match;
+	struct nft_offload_ethertype ethertype;
+
+	if (match->key.basic.n_proto != htons(ETH_P_8021Q) &&
+	    match->key.basic.n_proto != htons(ETH_P_8021AD))
+		return;
+
+	ethertype.value = match->key.basic.n_proto;
+	ethertype.mask = match->mask.basic.n_proto;
+
+	if (match->key.vlan.vlan_tpid == htons(ETH_P_8021Q) ||
+	    match->key.vlan.vlan_tpid == htons(ETH_P_8021AD)) {
+		match->key.basic.n_proto = match->key.cvlan.vlan_tpid;
+		match->mask.basic.n_proto = match->mask.cvlan.vlan_tpid;
+		match->key.cvlan.vlan_tpid = match->key.vlan.vlan_tpid;
+		match->mask.cvlan.vlan_tpid = match->mask.vlan.vlan_tpid;
+		match->key.vlan.vlan_tpid = ethertype.value;
+		match->mask.vlan.vlan_tpid = ethertype.mask;
+		match->dissector.offset[FLOW_DISSECTOR_KEY_VLAN] =
+			offsetof(struct nft_flow_key, vlan);
+		match->dissector.offset[FLOW_DISSECTOR_KEY_CVLAN] =
+			offsetof(struct nft_flow_key, cvlan);
+		match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_VLAN) |
+					      BIT(FLOW_DISSECTOR_KEY_CVLAN);
+	} else {
+		match->key.basic.n_proto = match->key.vlan.vlan_tpid;
+		match->mask.basic.n_proto = match->mask.vlan.vlan_tpid;
+		match->key.vlan.vlan_tpid = ethertype.value;
+		match->mask.vlan.vlan_tpid = ethertype.mask;
+		match->dissector.offset[FLOW_DISSECTOR_KEY_VLAN] =
+			offsetof(struct nft_flow_key, vlan);
+		match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_VLAN);
+	}
+}
+
 struct nft_flow_rule *nft_flow_rule_create(struct net *net,
 					   const struct nft_rule *rule)
 {
@@ -91,6 +134,8 @@ struct nft_flow_rule *nft_flow_rule_create(struct net *net,
 
 		expr = nft_expr_next(expr);
 	}
+	nft_flow_rule_transfer_vlan(ctx, flow);
+
 	flow->proto = ctx->dep.l3num;
 	kfree(ctx);
 
-- 
2.20.1

