From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft,v4 11/16] rule: add chain reference counter
Date: Mon,  6 Jul 2015 20:17:03 +0200
Message-ID: <1436206628-23894-12-git-send-email-pablo@netfilter.org>
References: <1436206628-23894-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40455 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137AbbGFSLn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2015 14:11:43 -0400
In-Reply-To: <1436206628-23894-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When adding declared chains to the cache, we may hold more than one single
reference from struct cmd and the cache.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h |    3 +++
 src/rule.c     |    9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/rule.h b/include/rule.h
index 03d7d45..6cf401d 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -113,6 +113,7 @@ enum chain_flags {
  * @list:	list node in table list
  * @handle:	chain handle
  * @location:	location the chain was defined at
+ * @refcnt:	reference counter
  * @flags:	chain flags
  * @hookstr:	unified and human readable hook name (base chains)
  * @hooknum:	hook number (base chains)
@@ -125,6 +126,7 @@ struct chain {
 	struct list_head	list;
 	struct handle		handle;
 	struct location		location;
+	unsigned int		refcnt;
 	uint32_t		flags;
 	const char		*hookstr;
 	unsigned int		hooknum;
@@ -138,6 +140,7 @@ struct chain {
 extern const char *chain_type_name_lookup(const char *name);
 extern const char *chain_hookname_lookup(const char *name);
 extern struct chain *chain_alloc(const char *name);
+extern struct chain *chain_get(struct chain *chain);
 extern void chain_free(struct chain *chain);
 extern void chain_add_hash(struct chain *chain, struct table *table);
 extern struct chain *chain_lookup(const struct table *table,
diff --git a/src/rule.c b/src/rule.c
index 0077f8e..88b1834 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -400,6 +400,7 @@ struct chain *chain_alloc(const char *name)
 	struct chain *chain;
 
 	chain = xzalloc(sizeof(*chain));
+	chain->refcnt = 1;
 	init_list_head(&chain->rules);
 	init_list_head(&chain->scope.symbols);
 	if (name != NULL)
@@ -409,10 +410,18 @@ struct chain *chain_alloc(const char *name)
 	return chain;
 }
 
+struct chain *chain_get(struct chain *chain)
+{
+	chain->refcnt++;
+	return chain;
+}
+
 void chain_free(struct chain *chain)
 {
 	struct rule *rule, *next;
 
+	if (--chain->refcnt > 0)
+		return;
 	list_for_each_entry_safe(rule, next, &chain->rules, list)
 		rule_free(rule);
 	handle_free(&chain->handle);
-- 
1.7.10.4

