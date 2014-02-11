From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [libftnl PATCH] rule: Reformat the string to output so it breaks line relevantly
Date: Tue, 11 Feb 2014 19:01:57 +0200
Message-ID: <1392138117-11147-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:43689 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaBKRCq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:02:46 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As for chain and table.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 src/rule.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 53d2ebf..887b506 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -787,20 +787,20 @@ static int nft_rule_snprintf_default(char *buf, size_t size, struct nft_rule *r,
 	struct nft_rule_expr *expr;
 	int ret, len = size, offset = 0;
 
-	ret = snprintf(buf, len, "%s %s %s %"PRIu64" %"PRIu64"\n",
+	ret = snprintf(buf, len, "%s %s %s %"PRIu64" %"PRIu64"",
 			nft_family2str(r->family), r->table, r->chain,
 			r->handle, r->position);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	list_for_each_entry(expr, &r->expr_list, head) {
-		ret = snprintf(buf+offset, len, "  [ %s ", expr->ops->name);
+		ret = snprintf(buf+offset, len, "\n  [ %s ", expr->ops->name);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		ret = nft_rule_expr_snprintf(buf+offset, len, expr,
 					     type, flags);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-		ret = snprintf(buf+offset, len, "]\n");
+		ret = snprintf(buf+offset, len, "]");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-- 
1.8.3.2

