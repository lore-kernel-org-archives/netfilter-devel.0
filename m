From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/2] set: remove unused set_clone() function
Date: Mon, 12 Jan 2015 10:02:07 +0000
Message-ID: <1421056928-1247-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33881 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbbALKCW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:02:22 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The set_clone() function was added by the event monitor patchset and is
unused. It is also broken since it simply initializes the list head to
the list of the original set, so remove it.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/rule.h |  1 -
 src/rule.c     | 18 ------------------
 2 files changed, 19 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 0c52315..491411e 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -203,7 +203,6 @@ struct set {
 extern struct set *set_alloc(const struct location *loc);
 extern struct set *set_get(struct set *set);
 extern void set_free(struct set *set);
-extern struct set *set_clone(const struct set *set);
 extern void set_add_hash(struct set *set, struct table *table);
 extern struct set *set_lookup(const struct table *table, const char *name);
 extern struct set *set_lookup_global(uint32_t family, const char *table,
diff --git a/src/rule.c b/src/rule.c
index dd39e8a..feafe26 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -80,24 +80,6 @@ void set_free(struct set *set)
 	xfree(set);
 }
 
-struct set *set_clone(const struct set *set)
-{
-	struct set *newset = set_alloc(&set->location);
-
-	newset->list = set->list;
-	handle_merge(&newset->handle, &set->handle);
-	newset->flags = set->flags;
-	newset->keytype = set->keytype;
-	newset->keylen = set->keylen;
-	newset->datatype = set->datatype;
-	newset->datalen = set->datalen;
-	newset->init = expr_clone(set->init);
-	newset->policy = set->policy;
-	newset->desc.size = set->desc.size;
-
-	return newset;
-}
-
 void set_add_hash(struct set *set, struct table *table)
 {
 	list_add_tail(&set->list, &table->sets);
-- 
2.1.0

