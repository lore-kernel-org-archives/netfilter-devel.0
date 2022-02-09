Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 713B4C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Feb 2022 13:36:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbiBINg3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Feb 2022 08:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234123AbiBINgZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Feb 2022 08:36:25 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6D67FC0613C9;
        Wed,  9 Feb 2022 05:36:29 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id BE0AE601CC;
        Wed,  9 Feb 2022 14:36:17 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 09/14] netfilter: nft_compat: suppress comment match
Date:   Wed,  9 Feb 2022 14:36:11 +0100
Message-Id: <20220209133616.165104-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220209133616.165104-1-pablo@netfilter.org>
References: <20220209133616.165104-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

No need to have the datapath call the always-true comment match stub.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_compat.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index f69cc73c5813..5a46d8289d1d 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -731,6 +731,14 @@ static const struct nfnetlink_subsystem nfnl_compat_subsys = {
 
 static struct nft_expr_type nft_match_type;
 
+static bool nft_match_reduce(struct nft_regs_track *track,
+			     const struct nft_expr *expr)
+{
+	const struct xt_match *match = expr->ops->data;
+
+	return strcmp(match->name, "comment") == 0;
+}
+
 static const struct nft_expr_ops *
 nft_match_select_ops(const struct nft_ctx *ctx,
 		     const struct nlattr * const tb[])
@@ -773,6 +781,7 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 	ops->dump = nft_match_dump;
 	ops->validate = nft_match_validate;
 	ops->data = match;
+	ops->reduce = nft_match_reduce;
 
 	matchsize = NFT_EXPR_SIZE(XT_ALIGN(match->matchsize));
 	if (matchsize > NFT_MATCH_LARGE_THRESH) {
-- 
2.30.2

