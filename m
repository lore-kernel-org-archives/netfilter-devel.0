From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft v5 03/14] rule: add reference counter to the table object
Date: Mon, 10 Aug 2015 13:50:37 +0200
Message-ID: <1439207448-22485-4-git-send-email-pablo@netfilter.org>
References: <1439207448-22485-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55969 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbbHJLo4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2015 07:44:56 -0400
In-Reply-To: <1439207448-22485-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We may hold multiple references to table objects in follow up patches when
adding object declarations to the cache.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h |    3 +++
 src/rule.c     |   10 ++++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/rule.h b/include/rule.h
index 1520222..cc4e5c2 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -76,6 +76,7 @@ enum table_flags {
  * @chains:	chains contained in the table
  * @sets:	sets contained in the table
  * @flags:	table flags
+ * @refcnt:	table reference counter
  */
 struct table {
 	struct list_head	list;
@@ -85,9 +86,11 @@ struct table {
 	struct list_head	chains;
 	struct list_head	sets;
 	enum table_flags 	flags;
+	unsigned int		refcnt;
 };
 
 extern struct table *table_alloc(void);
+extern struct table *table_get(struct table *table);
 extern void table_free(struct table *table);
 extern void table_add_hash(struct table *table);
 extern struct table *table_lookup(const struct handle *h);
diff --git a/src/rule.c b/src/rule.c
index 60c5d72..cb69369 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -569,6 +569,8 @@ struct table *table_alloc(void)
 	init_list_head(&table->chains);
 	init_list_head(&table->sets);
 	init_list_head(&table->scope.symbols);
+	table->refcnt = 1;
+
 	return table;
 }
 
@@ -576,6 +578,8 @@ void table_free(struct table *table)
 {
 	struct chain *chain, *next;
 
+	if (--table->refcnt > 0)
+		return;
 	list_for_each_entry_safe(chain, next, &table->chains, list)
 		chain_free(chain);
 	handle_free(&table->handle);
@@ -583,6 +587,12 @@ void table_free(struct table *table)
 	xfree(table);
 }
 
+struct table *table_get(struct table *table)
+{
+	table->refcnt++;
+	return table;
+}
+
 void table_add_hash(struct table *table)
 {
 	list_add_tail(&table->list, &table_list);
-- 
1.7.10.4

