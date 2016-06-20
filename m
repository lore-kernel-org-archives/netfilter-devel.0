From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: nf_tables: fix memory leak if expr init fails
Date: Mon, 20 Jun 2016 21:11:45 +0800
Message-ID: <1466428305-58285-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:45772 "EHLO m12-13.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333AbcFTNMu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jun 2016 09:12:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

If expr init fails then we need to free it.

So when the user add a nft rule as follows:
  # nft add rule filter input tcp dport 22 flow table ssh \
    { ip saddr limit rate 0/second }
memory leak will happen.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nf_tables_api.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2c88187..cf7c745 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1724,9 +1724,11 @@ struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
 
 	err = nf_tables_newexpr(ctx, &info, expr);
 	if (err < 0)
-		goto err2;
+		goto err3;
 
 	return expr;
+err3:
+	kfree(expr);
 err2:
 	module_put(info.ops->type->owner);
 err1:
-- 
1.7.9.5


