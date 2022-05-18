Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A546FC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 May 2022 21:42:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbiERVmI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 May 2022 17:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232911AbiERVju (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 May 2022 17:39:50 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CDED824989A;
        Wed, 18 May 2022 14:38:50 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH net 7/7] netfilter: nf_tables: disable expression reduction infra
Date:   Wed, 18 May 2022 23:38:41 +0200
Message-Id: <20220518213841.359653-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220518213841.359653-1-pablo@netfilter.org>
References: <20220518213841.359653-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Either userspace or kernelspace need to pre-fetch keys inconditionally
before comparisons for this to work. Otherwise, register tracking data
is misleading and it might result in reducing expressions which are not
yet registers.

First expression is also guaranteed to be evaluated always, however,
certain expressions break before writing data to registers, before
comparing the data, leaving the register in undetermined state.

This patch disables this infrastructure by now.

Fixes: b2d306542ff9 ("netfilter: nf_tables: do not reduce read-only expressions")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 16c3a39689f4..a096b9fbbbdf 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8342,16 +8342,7 @@ EXPORT_SYMBOL_GPL(nf_tables_trans_destroy_flush_work);
 static bool nft_expr_reduce(struct nft_regs_track *track,
 			    const struct nft_expr *expr)
 {
-	if (!expr->ops->reduce) {
-		pr_warn_once("missing reduce for expression %s ",
-			     expr->ops->type->name);
-		return false;
-	}
-
-	if (nft_reduce_is_readonly(expr))
-		return false;
-
-	return expr->ops->reduce(track, expr);
+	return false;
 }
 
 static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *chain)
-- 
2.30.2

