From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 6/5] netfilter: nft_dynset: make sure expr extension exists
 before using it
Date: Sun, 12 Apr 2015 21:26:55 +0100
Message-ID: <20150412202651.GG4568@acer.localdomain>
References: <1428745602-31799-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62120 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbbDLU1R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Apr 2015 16:27:17 -0400
Content-Disposition: inline
In-Reply-To: <1428745602-31799-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes a bug in patch 5/5 (netfilter: nft_dynset: dynamic
stateful expression instantiation), we need to make sure the expr
extension exists without using it to avoid a crash with normal
set updates.

If possible, please simply fold it into 5/5.

Thanks!

commit 6609a3aad8ad8c1e60a4b757d626aeb69fae8066
Author: Patrick McHardy <kaber@trash.net>
Date:   Sun Apr 12 21:24:31 2015 +0100

    netfilter: nft_dynset: make sure expr extension exists before using it
    
    Fix a crash when using dynset without an expression.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 311e21c..513a8ef 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -68,7 +68,9 @@ static void nft_dynset_eval(const struct nft_expr *expr,
 
 	if (set->ops->update(set, &regs->data[priv->sreg_key], nft_dynset_new,
 			     expr, regs, &ext)) {
-		sexpr = nft_set_ext_expr(ext);
+		sexpr = NULL;
+		if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPR))
+			sexpr = nft_set_ext_expr(ext);
 
 		if (priv->op == NFT_DYNSET_OP_UPDATE &&
 		    nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
