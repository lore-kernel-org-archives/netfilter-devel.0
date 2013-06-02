From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH 3/5] rule: list elements in set in any case
Date: Sun,  2 Jun 2013 12:38:30 +0200
Message-ID: <1370169512-23500-4-git-send-email-eric@regit.org>
References: <1370169512-23500-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:36295 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab3FBKi4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Jun 2013 06:38:56 -0400
In-Reply-To: <1370169512-23500-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

"nft list table" command was not displaying the elements of named
set. This was thus not possible to restore a ruleset by using the
listing output. This patch modifies the code to display the elements
of set in all cases.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/rule.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index e77323d..e7627a7 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -466,8 +466,7 @@ static int do_list_sets(struct netlink_ctx *ctx, const struct location *loc,
 		return -1;
 
 	list_for_each_entry_safe(set, nset, &ctx->list, list) {
-		if (set->flags & SET_F_ANONYMOUS &&
-		    netlink_get_setelems(ctx, &set->handle, loc, set) < 0)
+		if (netlink_get_setelems(ctx, &set->handle, loc, set) < 0)
 			return -1;
 		list_move_tail(&set->list, &table->sets);
 	}
-- 
1.7.10.4

