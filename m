From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] rule: fix object ordering via nft -f
Date: Wed, 18 Feb 2015 04:39:12 +0100
Message-ID: <1424230752-4040-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37462 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbbBRDf6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2015 22:35:58 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The objects need to be loaded in the following ordering:

	#1 tables
	#2 chains
	#3 sets
	#4 rules

We have to make sure that chains are in place by when we add rules with
jumps/gotos. Similarly, we have to make sure that the sets are in place
by when rules reference them.

Without this patch, you may hit ENOENT errors depending on your ruleset
configuration.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index feafe26..8d76fd0 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -658,14 +658,19 @@ static int do_add_table(struct netlink_ctx *ctx, const struct handle *h,
 	if (netlink_add_table(ctx, h, loc, table, excl) < 0)
 		return -1;
 	if (table != NULL) {
+		list_for_each_entry(chain, &table->chains, list) {
+			if (netlink_add_chain(ctx, &chain->handle,
+					      &chain->location, chain,
+					      excl) < 0)
+				return -1;
+		}
 		list_for_each_entry(set, &table->sets, list) {
 			handle_merge(&set->handle, &table->handle);
 			if (do_add_set(ctx, &set->handle, set) < 0)
 				return -1;
 		}
 		list_for_each_entry(chain, &table->chains, list) {
-			if (do_add_chain(ctx, &chain->handle, &chain->location,
-					 chain, excl) < 0)
+			if (netlink_add_rule_list(ctx, h, &chain->rules) < 0)
 				return -1;
 		}
 	}
-- 
1.7.10.4

