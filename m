From: Eric Leblond <eric@regit.org>
Subject: [libnftables PATCH 3/4] rule: display position in default printf
Date: Sat,  6 Jul 2013 17:33:15 +0200
Message-ID: <1373124796-6810-3-git-send-email-eric@regit.org>
References: <1373124677-6626-1-git-send-email-eric@regit.org>
 <1373124796-6810-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:59760 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3GFPdu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Jul 2013 11:33:50 -0400
In-Reply-To: <1373124796-6810-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/rule.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index a56df34..9dc82b8 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -769,9 +769,9 @@ static int nft_rule_snprintf_default(char *buf, size_t size, struct nft_rule *r,
 	struct nft_rule_expr *expr;
 	int ret, len = size, offset = 0;
 
-	ret = snprintf(buf, size, "%s %s %s %"PRIu64"\n",
+	ret = snprintf(buf, size, "%s %s %s %"PRIu64" %"PRIu64"\n",
 			nft_family2str(r->family), r->table, r->chain,
-			r->handle);
+			r->handle, r->position);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	list_for_each_entry(expr, &r->expr_list, head) {
-- 
1.8.3.2

