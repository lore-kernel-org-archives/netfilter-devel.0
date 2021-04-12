Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CF85C43460
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Apr 2021 13:12:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 797956134F
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Apr 2021 13:12:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241867AbhDLNNK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Apr 2021 09:13:10 -0400
Received: from mail.netfilter.org ([217.70.188.207]:48260 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241705AbhDLNNJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Apr 2021 09:13:09 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 67D4963E56;
        Mon, 12 Apr 2021 15:12:26 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     wenxu@ucloud.cn
Subject: [PATCH nf-next 3/3] netfilter: nftables_offload: special ethertype handling for VLAN
Date:   Mon, 12 Apr 2021 15:12:42 +0200
Message-Id: <20210412131242.2907-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412131242.2907-1-pablo@netfilter.org>
References: <20210412131242.2907-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The nftables offload parser sets FLOW_DISSECTOR_KEY_BASIC .n_proto to the
ethertype field in in the ethertype frame. However:

- FLOW_DISSECTOR_KEY_BASIC .n_proto field always stores either IPv4 or IPv6
  ethertypes.
- FLOW_DISSECTOR_KEY_VLAN .vlan_tpid stores either the 802.1q and 802.1ad
  ethertypes. Same as for C-VLAN.

This function adjusts the flow dissector to handle three scenarios:

1) FLOW_DISSECTOR_KEY_VLAN and FLOW_DISSECTOR_KEY_CVLAN are set. Then,
   transfer the .n_proto field to FLOW_DISSECTOR_KEY_VLAN .tpid, and
   FLOW_DISSECTOR_KEY_VLAN .tpid to FLOW_DISSECTOR_KEY_CVLAN .tpid.
   Finally set .n_proto to FLOW_DISSECTOR_KEY_CVLAN .tpid.
2) FLOW_DISSECTOR_KEY_VLAN is set. Swap the .n_proto and the
   FLOW_DISSECTOR_KEY_VLAN .tpid fields.
3) ethertype is set to 802.1q or 802.1ad, in this case, transfer the .n_proto
   field to FLOW_DISSECTOR_KEY_VLAN .vlan_tpid.

Fixes: a82055af5959 ("netfilter: nft_payload: add VLAN offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_offload.c | 41 +++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 43b56eff3b04..41bd6b67f92c 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -47,6 +47,45 @@ void nft_flow_rule_set_addr_type(struct nft_flow_rule *flow,
 		offsetof(struct nft_flow_key, control);
 }
 
+struct nft_offload_ethertype {
+	__be16 value;
+	__be16 mask;
+};
+
+void nft_flow_rule_transfer_vlan(struct nft_offload_ctx *ctx,
+				 struct nft_flow_rule *flow)
+{
+	struct nft_flow_match *match = &flow->match;
+	struct nft_offload_ethertype ethertype = {
+		.value	= match->key.basic.n_proto,
+		.mask	= match->mask.basic.n_proto,
+	};
+
+	if ((flow->match.dissector.used_keys &
+	     (BIT(FLOW_DISSECTOR_KEY_VLAN) | BIT(FLOW_DISSECTOR_KEY_CVLAN))) ==
+	    (BIT(FLOW_DISSECTOR_KEY_VLAN) | BIT(FLOW_DISSECTOR_KEY_CVLAN))) {
+		match->key.basic.n_proto = match->key.cvlan.vlan_tpid;
+		match->mask.basic.n_proto = match->mask.cvlan.vlan_tpid;
+		match->key.cvlan.vlan_tpid = match->key.vlan.vlan_tpid;
+		match->mask.cvlan.vlan_tpid = match->mask.vlan.vlan_tpid;
+		match->key.vlan.vlan_tpid = ethertype.value;
+		match->mask.vlan.vlan_tpid = ethertype.mask;
+	} else if (flow->match.dissector.used_keys & (BIT(FLOW_DISSECTOR_KEY_VLAN))) {
+		match->key.basic.n_proto = match->key.vlan.vlan_tpid;
+		match->mask.basic.n_proto = match->mask.vlan.vlan_tpid;
+		match->key.vlan.vlan_tpid = ethertype.value;
+		match->mask.vlan.vlan_tpid = ethertype.mask;
+	} else if (match->key.basic.n_proto == htons(ETH_P_8021Q) ||
+		   match->key.basic.n_proto == htons(ETH_P_8021AD)) {
+		match->key.vlan.vlan_tpid = ethertype.value;
+		match->mask.vlan.vlan_tpid = ethertype.mask;
+		match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_VLAN);
+		match->key.basic.n_proto = 0;
+		match->mask.basic.n_proto = 0;
+		match->dissector.used_keys &= ~BIT(FLOW_DISSECTOR_KEY_BASIC);
+	}
+}
+
 struct nft_flow_rule *nft_flow_rule_create(struct net *net,
 					   const struct nft_rule *rule)
 {
@@ -91,6 +130,8 @@ struct nft_flow_rule *nft_flow_rule_create(struct net *net,
 
 		expr = nft_expr_next(expr);
 	}
+	nft_flow_rule_transfer_vlan(ctx, flow);
+
 	flow->proto = ctx->dep.l3num;
 	kfree(ctx);
 
-- 
2.30.2

