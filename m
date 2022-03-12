Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A5FC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Mar 2022 00:05:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiCLAGJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Mar 2022 19:06:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiCLAGJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Mar 2022 19:06:09 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8C05629C83
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Mar 2022 16:05:04 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 93CBE625FD
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2022 01:02:57 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables: disable register tracking
Date:   Sat, 12 Mar 2022 01:05:00 +0100
Message-Id: <20220312000500.21530-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The register tracking infrastructure is incomplete, it might lead to
generating incorrect ruleset bytecode, disable it by now given we are
late in the 5.17-rc release process.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c86748b3873b..7988fe6479e3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8263,7 +8263,6 @@ EXPORT_SYMBOL_GPL(nf_tables_trans_destroy_flush_work);
 static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *chain)
 {
 	const struct nft_expr *expr, *last;
-	struct nft_regs_track track = {};
 	unsigned int size, data_size;
 	void *data, *data_boundary;
 	struct nft_rule_dp *prule;
@@ -8303,16 +8302,7 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 			return -ENOMEM;
 
 		size = 0;
-		track.last = nft_expr_last(rule);
 		nft_rule_for_each_expr(expr, last, rule) {
-			track.cur = expr;
-
-			if (expr->ops->reduce &&
-			    expr->ops->reduce(&track, expr)) {
-				expr = track.cur;
-				continue;
-			}
-
 			if (WARN_ON_ONCE(data + expr->ops->size > data_boundary))
 				return -ENOMEM;
 
-- 
2.30.2

