Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFBD3C48BDF
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Jun 2021 22:00:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96E4561360
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Jun 2021 22:00:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhFVWDG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Jun 2021 18:03:06 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59280 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbhFVWC7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Jun 2021 18:02:59 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 056A164252;
        Tue, 22 Jun 2021 23:59:17 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 6/8] netfilter: nf_tables_offload: check FLOW_DISSECTOR_KEY_BASIC in VLAN transfer logic
Date:   Tue, 22 Jun 2021 23:59:59 +0200
Message-Id: <20210622220001.198508-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210622220001.198508-1-pablo@netfilter.org>
References: <20210622220001.198508-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The VLAN transfer logic should actually check for
FLOW_DISSECTOR_KEY_BASIC, not FLOW_DISSECTOR_KEY_CONTROL. Moreover, do
not fallback to case 2) .n_proto is set to 802.1q or 802.1ad, if
FLOW_DISSECTOR_KEY_BASIC is unset.

Fixes: 783003f3bb8a ("netfilter: nftables_offload: special ethertype handling for VLAN")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_offload.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index ec701b84844f..b58d73a96523 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -54,15 +54,10 @@ static void nft_flow_rule_transfer_vlan(struct nft_offload_ctx *ctx,
 					struct nft_flow_rule *flow)
 {
 	struct nft_flow_match *match = &flow->match;
-	struct nft_offload_ethertype ethertype;
-
-	if (match->dissector.used_keys & BIT(FLOW_DISSECTOR_KEY_CONTROL) &&
-	    match->key.basic.n_proto != htons(ETH_P_8021Q) &&
-	    match->key.basic.n_proto != htons(ETH_P_8021AD))
-		return;
-
-	ethertype.value = match->key.basic.n_proto;
-	ethertype.mask = match->mask.basic.n_proto;
+	struct nft_offload_ethertype ethertype = {
+		.value	= match->key.basic.n_proto,
+		.mask	= match->mask.basic.n_proto,
+	};
 
 	if (match->dissector.used_keys & BIT(FLOW_DISSECTOR_KEY_VLAN) &&
 	    (match->key.vlan.vlan_tpid == htons(ETH_P_8021Q) ||
@@ -76,7 +71,9 @@ static void nft_flow_rule_transfer_vlan(struct nft_offload_ctx *ctx,
 		match->dissector.offset[FLOW_DISSECTOR_KEY_CVLAN] =
 			offsetof(struct nft_flow_key, cvlan);
 		match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_CVLAN);
-	} else {
+	} else if (match->dissector.used_keys & BIT(FLOW_DISSECTOR_KEY_BASIC) &&
+		   (match->key.basic.n_proto == htons(ETH_P_8021Q) ||
+		    match->key.basic.n_proto == htons(ETH_P_8021AD))) {
 		match->key.basic.n_proto = match->key.vlan.vlan_tpid;
 		match->mask.basic.n_proto = match->mask.vlan.vlan_tpid;
 		match->key.vlan.vlan_tpid = ethertype.value;
-- 
2.30.2

