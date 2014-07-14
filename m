From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 1/2] netlink: monitor: add a helper function to handle
 sets referenced by a rule
Date: Mon, 14 Jul 2014 13:56:46 +0200
Message-ID: <20140714115646.10384.69637.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:55128 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754207AbaGNL45 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:56:57 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a helper function to handle lookup expressions with a callback,
so we can make an action for each set referenced by the rule.

Basically is a refactorization, useful for follow-up patches.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/netlink.c |   75 +++++++++++++++++++++++++++++++++------------------------
 1 file changed, 44 insertions(+), 31 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 987dd63..1a5d07b 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1510,6 +1510,42 @@ static uint32_t netlink_msg2nftnl_of(uint32_t msg)
 	return 0;
 }
 
+static void nlr_for_each_set(struct nft_rule *nlr,
+			     void (*cb)(struct set *s, void *data),
+			     void *data)
+{
+	struct set *s;
+	uint32_t family;
+	const char *set_name, *table;
+	struct nft_rule_expr *nlre;
+	struct nft_rule_expr_iter *nlrei;
+	const char *name;
+
+	nlrei = nft_rule_expr_iter_create(nlr);
+	if (nlrei == NULL)
+		memory_allocation_error();
+
+	family = nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY);
+	table = nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_TABLE);
+
+	nlre = nft_rule_expr_iter_next(nlrei);
+	while (nlre != NULL) {
+		name = nft_rule_expr_get_str(nlre, NFT_RULE_EXPR_ATTR_NAME);
+		if (strcmp(name, "lookup") != 0)
+			goto next;
+
+		set_name = nft_rule_expr_get_str(nlre, NFT_EXPR_LOOKUP_SET);
+		s = set_lookup_global(family, table, set_name);
+		if (s == NULL)
+			goto next;
+
+		cb(s, data);
+next:
+		nlre = nft_rule_expr_iter_next(nlrei);
+	}
+	nft_rule_expr_iter_destroy(nlrei);
+}
+
 static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
 				   struct netlink_mon_handler *monh)
 {
@@ -1833,42 +1869,19 @@ out:
 	nft_set_free(nls);
 }
 
+static void netlink_events_cache_delset_cb(struct set *s,
+					   void *data)
+{
+	list_del(&s->list);
+	set_free(s);
+}
+
 static void netlink_events_cache_delsets(struct netlink_mon_handler *monh,
 					 const struct nlmsghdr *nlh)
 {
-	struct set *s;
-	uint32_t family;
-	struct nft_rule_expr *nlre;
-	struct nft_rule_expr_iter *nlrei;
-	const char *expr_name, *set_name, *table;
 	struct nft_rule *nlr = netlink_rule_alloc(nlh);
 
-	nlrei = nft_rule_expr_iter_create(nlr);
-	if (nlrei == NULL)
-		memory_allocation_error();
-
-	family = nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY);
-	table = nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_TABLE);
-
-	nlre = nft_rule_expr_iter_next(nlrei);
-	while (nlre != NULL) {
-		expr_name = nft_rule_expr_get_str(nlre,
-						  NFT_RULE_EXPR_ATTR_NAME);
-		if (strcmp(expr_name, "lookup") != 0)
-			goto next;
-
-		set_name = nft_rule_expr_get_str(nlre, NFT_EXPR_LOOKUP_SET);
-		s = set_lookup_global(family, table, set_name);
-		if (s == NULL)
-			goto next;
-
-		list_del(&s->list);
-		set_free(s);
-next:
-		nlre = nft_rule_expr_iter_next(nlrei);
-	}
-	nft_rule_expr_iter_destroy(nlrei);
-
+	nlr_for_each_set(nlr, netlink_events_cache_delset_cb, NULL);
 	nft_rule_free(nlr);
 }
 

