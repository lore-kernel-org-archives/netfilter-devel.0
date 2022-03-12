Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 292E0C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Mar 2022 15:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbiCLPoN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Mar 2022 10:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiCLPoM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Mar 2022 10:44:12 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 32B593B565
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2022 07:43:06 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1E96560866
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2022 16:40:56 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v3] netfilter: nf_tables: disable register tracking
Date:   Sat, 12 Mar 2022 16:43:01 +0100
Message-Id: <20220312154301.68404-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The register tracking infrastructure is incomplete, it might lead to
generating incorrect ruleset bytecode, disable it by now given we are
late in the release process.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: add track object to function.

 net/netfilter/nf_tables_api.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c86748b3873b..d71a33ae39b3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8260,6 +8260,12 @@ void nf_tables_trans_destroy_flush_work(void)
 }
 EXPORT_SYMBOL_GPL(nf_tables_trans_destroy_flush_work);
 
+static bool nft_expr_reduce(struct nft_regs_track *track,
+			    const struct nft_expr *expr)
+{
+	return false;
+}
+
 static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *chain)
 {
 	const struct nft_expr *expr, *last;
@@ -8307,8 +8313,7 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 		nft_rule_for_each_expr(expr, last, rule) {
 			track.cur = expr;
 
-			if (expr->ops->reduce &&
-			    expr->ops->reduce(&track, expr)) {
+			if (nft_expr_reduce(&track, expr)) {
 				expr = track.cur;
 				continue;
 			}
-- 
2.30.2

