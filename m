From: Yanchuan Nian <ycnian@gmail.com>
Subject: [nft PATCH] Kill the correct protocol expression during payload parsing
Date: Sat, 30 Aug 2014 13:17:15 +0800
Message-ID: <1409375835-28041-1-git-send-email-ycnian@gmail.com>
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	Yanchuan Nian <ycnian@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:64530 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaH3FOe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Aug 2014 01:14:34 -0400
Received: by mail-pa0-f53.google.com with SMTP id fa1so7893353pad.40
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Aug 2014 22:14:33 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The protocol expression that should be killed when payload parsing
isn't the first one but the last one. Look at the result of this command:

nft> add rule ip filter input ip protocol != tcp tcp sport 80 drop
nft> list table ip filter
table ip filter {
	chain input {
		 type filter hook input priority 0;
		 ip protocol tcp tcp sport http drop
	}
}
nft>

With this patch, the result is:
nft> add rule ip filter input ip protocol != tcp tcp sport 80 drop
nft> list table ip filter
table ip filter {
	chain input {
		 type filter hook input priority 0;
		 ip protocol != tcp tcp sport http drop
	}
}
nft>

Signed-off-by: Yanchuan Nian <ycnian@gmail.com>
---
 src/netlink_delinearize.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 195d432..322c7cc 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -671,12 +671,11 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 			nstmt = expr_stmt_alloc(&stmt->location, nexpr);
 			list_add_tail(&nstmt->list, &stmt->list);
 
-			/* Remember the first payload protocol expression to
+			/* Remember the last payload protocol expression to
 			 * kill it later on if made redundant by a higher layer
 			 * payload expression.
 			 */
-			if (ctx->pbase == PROTO_BASE_INVALID &&
-			    left->flags & EXPR_F_PROTOCOL)
+			if (left->flags & EXPR_F_PROTOCOL)
 				payload_dependency_store(ctx, nstmt,
 							 left->payload.base);
 			else
-- 
1.9.3

