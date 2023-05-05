Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1174C77B7F
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 May 2023 15:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbjEEPcN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 May 2023 11:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232972AbjEEPcK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2023 11:32:10 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D9C1B150DC
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2023 08:31:55 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1 12/12] netfilter: nf_tables: re-enable expression reduction
Date:   Fri,  5 May 2023 17:31:30 +0200
Message-Id: <20230505153130.2385-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230505153130.2385-1-pablo@netfilter.org>
References: <20230505153130.2385-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The register track provides what registers already contain prefetched
expressions.

The expr->ops->reduce() operation already cancels register tracking in
case an expression updates overwrites existing prefetched expression.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d0c80e11557e..23540b1d6e8d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9150,7 +9150,16 @@ static int nft_prefetch_build(struct nft_regs_track *track,
 static bool nft_expr_reduce(struct nft_regs_track *track,
 			    const struct nft_expr *expr)
 {
-	return false;
+	if (!expr->ops->reduce) {
+		pr_warn_once("missing reduce for expression %s ",
+			     expr->ops->type->name);
+		return false;
+	}
+
+	if (nft_reduce_is_readonly(expr))
+		return false;
+
+	return expr->ops->reduce(track, expr);
 }
 
 static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *chain)
-- 
2.30.2

