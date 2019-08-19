Return-Path: <SRS0=DEFU=WP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D804C3A5A0
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Aug 2019 18:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBA49214DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Aug 2019 18:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbfHSS7g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Aug 2019 14:59:36 -0400
Received: from correo.us.es ([193.147.175.20]:37842 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727769AbfHSS7f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Aug 2019 14:59:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 69501F2626
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2019 20:50:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5B12BA75E
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2019 20:50:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 509B5CE15C; Mon, 19 Aug 2019 20:50:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5A333DA840;
        Mon, 19 Aug 2019 20:50:11 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 19 Aug 2019 20:50:11 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.209.241])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D6E8F4265A32;
        Mon, 19 Aug 2019 20:50:10 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 3/5] netfilter: nft_flow_offload: missing netlink attribute policy
Date:   Mon, 19 Aug 2019 20:49:09 +0200
Message-Id: <20190819184911.15263-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190819184911.15263-1-pablo@netfilter.org>
References: <20190819184911.15263-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The netlink attribute policy for NFTA_FLOW_TABLE_NAME is missing.

Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_flow_offload.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 060a4ed46d5e..01705ad74a9a 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -149,6 +149,11 @@ static int nft_flow_offload_validate(const struct nft_ctx *ctx,
 	return nft_chain_validate_hooks(ctx->chain, hook_mask);
 }
 
+static const struct nla_policy nft_flow_offload_policy[NFTA_FLOW_MAX + 1] = {
+	[NFTA_FLOW_TABLE_NAME]	= { .type = NLA_STRING,
+				    .len = NFT_NAME_MAXLEN - 1 },
+};
+
 static int nft_flow_offload_init(const struct nft_ctx *ctx,
 				 const struct nft_expr *expr,
 				 const struct nlattr * const tb[])
@@ -207,6 +212,7 @@ static const struct nft_expr_ops nft_flow_offload_ops = {
 static struct nft_expr_type nft_flow_offload_type __read_mostly = {
 	.name		= "flow_offload",
 	.ops		= &nft_flow_offload_ops,
+	.policy		= nft_flow_offload_policy,
 	.maxattr	= NFTA_FLOW_MAX,
 	.owner		= THIS_MODULE,
 };
-- 
2.11.0


