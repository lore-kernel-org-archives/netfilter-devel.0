From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft] set_elem: convert flag value to inclusive-OR binops during delinearize
Date: Mon, 23 Mar 2015 23:40:27 +0000
Message-ID: <1427154027-11189-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33118 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbbCWXkb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2015 19:40:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When a set contains combined flag values, they are displayed as numeric
value since they don't match any of the single flag values:

tcp flags { 18, psh, syn}

Convert to a series of inclusive-OR binops of the single flag values
for improved readability:

tcp flags { syn | ack, psh, syn}

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/netlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/netlink.c b/src/netlink.c
index bd6aa93..24dda67 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1383,6 +1383,10 @@ static int netlink_delinearize_setelem(struct nft_set_elem *nlse,
 	    expr->byteorder == BYTEORDER_HOST_ENDIAN)
 		mpz_switch_byteorder(expr->value, expr->len / BITS_PER_BYTE);
 
+	if (expr->dtype->basetype != NULL &&
+	    expr->dtype->basetype->type == TYPE_BITMASK)
+		expr = bitmask_expr_to_binops(expr);
+
 	if (flags & NFT_SET_ELEM_INTERVAL_END) {
 		expr->flags |= EXPR_F_INTERVAL_END;
 	} else {
-- 
2.1.0

