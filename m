From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2 nf] netfilter: nft_compat: fix hook validation for non-base chains
Date: Tue, 14 Oct 2014 12:53:27 +0200
Message-ID: <1413284008-3761-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36170 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754846AbaJNKwO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Oct 2014 06:52:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Set hook_mask to zero for non-base chains, otherwise people may hit
bogus errors from the xt_check_target() and xt_check_match() when
validating the uninitialized hook_mask.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_compat.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 7e2683c..44ae273 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -95,6 +95,8 @@ nft_target_set_tgchk_param(struct xt_tgchk_param *par,
 		const struct nf_hook_ops *ops = &basechain->ops[0];
 
 		par->hook_mask = 1 << ops->hooknum;
+	} else {
+		par->hook_mask = 0;
 	}
 	par->family	= ctx->afi->family;
 }
@@ -293,6 +295,8 @@ nft_match_set_mtchk_param(struct xt_mtchk_param *par, const struct nft_ctx *ctx,
 		const struct nf_hook_ops *ops = &basechain->ops[0];
 
 		par->hook_mask = 1 << ops->hooknum;
+	} else {
+		par->hook_mask = 0;
 	}
 	par->family	= ctx->afi->family;
 }
-- 
1.7.10.4

