Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9D5AC43460
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Apr 2021 01:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84C5361163
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Apr 2021 01:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbhDZBPF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 25 Apr 2021 21:15:05 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49718 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbhDZBPF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Apr 2021 21:15:05 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id F354B63E72
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Apr 2021 03:13:47 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 3/4] netfilter: nftables: add helper function to flush set elements
Date:   Mon, 26 Apr 2021 03:14:17 +0200
Message-Id: <20210426011418.69330-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210426011418.69330-1-pablo@netfilter.org>
References: <20210426011418.69330-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds nft_set_flush() which prepares for the catch-all
element support.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 502240fbb087..a8b226ef570c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5869,6 +5869,18 @@ static int nft_flush_set(const struct nft_ctx *ctx,
 	return err;
 }
 
+static int nft_set_flush(struct nft_ctx *ctx, struct nft_set *set, u8 genmask)
+{
+	struct nft_set_iter iter = {
+		.genmask	= genmask,
+		.fn		= nft_flush_set,
+	};
+
+	set->ops->walk(ctx, set, &iter);
+
+	return iter.err;
+}
+
 static int nf_tables_delsetelem(struct sk_buff *skb,
 				const struct nfnl_info *info,
 				const struct nlattr * const nla[])
@@ -5892,14 +5904,10 @@ static int nf_tables_delsetelem(struct sk_buff *skb,
 	if (!list_empty(&set->bindings) && set->flags & NFT_SET_CONSTANT)
 		return -EBUSY;
 
-	if (nla[NFTA_SET_ELEM_LIST_ELEMENTS] == NULL) {
-		struct nft_set_iter iter = {
-			.genmask	= genmask,
-			.fn		= nft_flush_set,
-		};
-		set->ops->walk(&ctx, set, &iter);
-
-		return iter.err;
+	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS]) {
+		err = nft_set_flush(&ctx, set, genmask);
+		if (err < 0)
+			return err;
 	}
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-- 
2.30.2

