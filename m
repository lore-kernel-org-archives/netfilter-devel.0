From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 3/3] netfilter: nf_tables: fix wrong destroy anonymous sets if binding fails
Date: Sat, 11 Jun 2016 12:20:28 +0800
Message-ID: <1465618828-22162-4-git-send-email-zlpnobody@163.com>
References: <1465618828-22162-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:49484 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbcFKEVS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Jun 2016 00:21:18 -0400
In-Reply-To: <1465618828-22162-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

When we add a nft rule like follows:
  # nft add rule filter test tcp dport vmap {1: jump test}
-ELOOP error will be returned, and the anonymous set will be
destroyed.

But after that, nf_tables_abort will also try to remove the
element and destroy the set, which was already destroyed and
freed.

If we add a nft wrong rule, nft_tables_abort will do the cleanup
work rightly, so nf_tables_set_destroy call here is redundant and
wrong, remove it.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nf_tables_api.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d5f3602..ba2dad4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2956,13 +2956,8 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 		iter.fn			= nf_tables_bind_check_setelem;
 
 		set->ops->walk(ctx, set, &iter);
-		if (iter.err < 0) {
-			/* Destroy anonymous sets if binding fails */
-			if (set->flags & NFT_SET_ANONYMOUS)
-				nf_tables_set_destroy(ctx, set);
-
+		if (iter.err < 0)
 			return iter.err;
-		}
 	}
 bind:
 	binding->chain = ctx->chain;
-- 
2.5.5


