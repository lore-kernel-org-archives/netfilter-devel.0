From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [RFC 3/3] netfilter: nftables: Return preferably given family expression if any
Date: Thu, 27 Mar 2014 11:19:32 +0200
Message-ID: <1395911972-17259-4-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1395911972-17259-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: netfilter-devel@vger.kernel.org,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: pablo@netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:53447 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793AbaC0JTw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Mar 2014 05:19:52 -0400
In-Reply-To: <1395911972-17259-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently, when looking up for the proper expression type, what comes
first is returned. Which might end up to be a non-family tight type.
Instead, if a specific family type exist, it will be better to return
this one.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 net/netfilter/nf_tables_api.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index adce01e..83de6c1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1117,14 +1117,17 @@ EXPORT_SYMBOL_GPL(nft_unregister_expr);
 static const struct nft_expr_type *__nft_expr_type_get(u8 family,
 						       struct nlattr *nla)
 {
-	const struct nft_expr_type *type;
-
-	list_for_each_entry(type, &nf_tables_expressions, list) {
-		if (!nla_strcmp(nla, type->name) &&
-		    (!type->family || type->family == family))
-			return type;
+	const struct nft_expr_type *test, *type = NULL;
+
+	list_for_each_entry(test, &nf_tables_expressions, list) {
+		if (!nla_strcmp(nla, test->name)) {
+			if (test->family == family)
+				return test;
+			if (!test->family)
+				type = test;
+		}
 	}
-	return NULL;
+	return type;
 }
 
 static const struct nft_expr_type *nft_expr_type_get(u8 family,
-- 
1.8.3.2

