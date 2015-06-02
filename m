From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3/3] netlink_delinearize: remove obsolete fixme
Date: Tue,  2 Jun 2015 12:57:41 +0200
Message-ID: <1433242661-32125-3-git-send-email-kaber@trash.net>
References: <1433242661-32125-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58049 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780AbbFBK57 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2015 06:57:59 -0400
In-Reply-To: <1433242661-32125-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The FIXME was related to exclusion of string types from cmp length checks.
Since with fixed sized helper names the last case where this could happen
is gone, remove the FIXME and perform length checks on strings as well.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/netlink_delinearize.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index ec1a964..b23d587 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -166,9 +166,7 @@ static void netlink_parse_cmp(struct netlink_parse_ctx *ctx,
 	nld.value = nft_rule_expr_get(nle, NFT_EXPR_CMP_DATA, &nld.len);
 	right = netlink_alloc_value(loc, &nld);
 
-	// FIXME
-	if (left->len && left->dtype && left->dtype->type != TYPE_STRING &&
-	    left->len != right->len)
+	if (left->len != right->len)
 		return netlink_error(ctx, loc,
 				     "Relational expression size mismatch");
 
-- 
2.1.0

