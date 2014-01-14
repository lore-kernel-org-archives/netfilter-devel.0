From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/3] evaluate: allow to use string with binary operations
Date: Tue, 14 Jan 2014 12:30:29 +0100
Message-ID: <1389699030-6301-3-git-send-email-pablo@netfilter.org>
References: <1389699030-6301-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51917 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbaANLan (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:30:43 -0500
In-Reply-To: <1389699030-6301-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows us to match ifname masks, eg.

nft add rule filter output meta oifname and eth == eth counter

I've been investigating other possibility, such as adding
ofiname-mask, which requires several patches and transformations
to make it look binop tree, but I still think this looks like
a natural way (and simple, look at the patch, it's rather small)
to represent this in the nftables.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 94fee64..49f0f74 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -534,7 +534,8 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 		return -1;
 	right = op->right;
 
-	if (expr_basetype(left)->type != TYPE_INTEGER)
+	if (expr_basetype(left)->type != TYPE_INTEGER &&
+	    expr_basetype(left)->type != TYPE_STRING)
 		return expr_binary_error(ctx, left, op,
 					 "Binary operation (%s) is undefined "
 					 "for %s types",
-- 
1.7.10.4

