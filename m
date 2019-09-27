Return-Path: <SRS0=c7vx=XW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F006C4360C
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 12:27:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3956321850
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 12:27:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfI0M1p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Sep 2019 08:27:45 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:49804 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbfI0M1o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Sep 2019 08:27:44 -0400
Received: from localhost ([::1]:34662 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iDpLb-0005En-EO; Fri, 27 Sep 2019 14:27:43 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH] set: Export nftnl_set_list_lookup_byname()
Date:   Fri, 27 Sep 2019 14:27:34 +0200
Message-Id: <20190927122734.30535-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Rename and optimize internal function nftnl_set_lookup() for external
use. Just like with nftnl_chain_list, use a hash table for fast set name
lookups.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/libnftnl/set.h |  2 ++
 include/set.h          |  1 +
 src/libnftnl.map       |  4 ++++
 src/set.c              | 53 +++++++++++++++++++++++++++---------------
 4 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index 67c54e9ae12c6..6640ad929f346 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -75,6 +75,8 @@ void nftnl_set_list_add(struct nftnl_set *s, struct nftnl_set_list *list);
 void nftnl_set_list_add_tail(struct nftnl_set *s, struct nftnl_set_list *list);
 void nftnl_set_list_del(struct nftnl_set *s);
 int nftnl_set_list_foreach(struct nftnl_set_list *set_list, int (*cb)(struct nftnl_set *t, void *data), void *data);
+struct nftnl_set *nftnl_set_list_lookup_byname(struct nftnl_set_list *set_list,
+					       const char *set);
 
 struct nftnl_set_list_iter;
 struct nftnl_set_list_iter *nftnl_set_list_iter_create(const struct nftnl_set_list *l);
diff --git a/include/set.h b/include/set.h
index 3bcec7c8c1b39..446acd24ca7cc 100644
--- a/include/set.h
+++ b/include/set.h
@@ -5,6 +5,7 @@
 
 struct nftnl_set {
 	struct list_head	head;
+	struct hlist_node	hnode;
 
 	uint32_t		family;
 	uint32_t		set_flags;
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 3c6f8631c1e60..3ddb9468c96c3 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -351,3 +351,7 @@ LIBNFTNL_12 {
   nftnl_chain_list_lookup_byname;
   nftnl_rule_lookup_byindex;
 } LIBNFTNL_11;
+
+LIBNFTNL_13 {
+  nftnl_set_list_lookup_byname;
+} LIBNFTNL_12;
diff --git a/src/set.c b/src/set.c
index d1bdb165ab4b1..e6db7258cc224 100644
--- a/src/set.c
+++ b/src/set.c
@@ -715,20 +715,26 @@ void nftnl_set_elem_add(struct nftnl_set *s, struct nftnl_set_elem *elem)
 	list_add_tail(&elem->head, &s->element_list);
 }
 
+#define SET_NAME_HSIZE		512
+
 struct nftnl_set_list {
 	struct list_head list;
+	struct hlist_head name_hash[SET_NAME_HSIZE];
 };
 
 EXPORT_SYMBOL(nftnl_set_list_alloc);
 struct nftnl_set_list *nftnl_set_list_alloc(void)
 {
 	struct nftnl_set_list *list;
+	int i;
 
 	list = calloc(1, sizeof(struct nftnl_set_list));
 	if (list == NULL)
 		return NULL;
 
 	INIT_LIST_HEAD(&list->list);
+	for (i = 0; i < SET_NAME_HSIZE; i++)
+		INIT_HLIST_HEAD(&list->name_hash[i]);
 
 	return list;
 }
@@ -740,6 +746,7 @@ void nftnl_set_list_free(struct nftnl_set_list *list)
 
 	list_for_each_entry_safe(s, tmp, &list->list, head) {
 		list_del(&s->head);
+		hlist_del(&s->hnode);
 		nftnl_set_free(s);
 	}
 	xfree(list);
@@ -751,15 +758,31 @@ int nftnl_set_list_is_empty(const struct nftnl_set_list *list)
 	return list_empty(&list->list);
 }
 
+static uint32_t djb_hash(const char *key)
+{
+	uint32_t i, hash = 5381;
+
+	for (i = 0; i < strlen(key); i++)
+		hash = ((hash << 5) + hash) + key[i];
+
+	return hash;
+}
+
 EXPORT_SYMBOL(nftnl_set_list_add);
 void nftnl_set_list_add(struct nftnl_set *s, struct nftnl_set_list *list)
 {
+	int key = djb_hash(s->name) % SET_NAME_HSIZE;
+
+	hlist_add_head(&s->hnode, &list->name_hash[key]);
 	list_add(&s->head, &list->list);
 }
 
 EXPORT_SYMBOL(nftnl_set_list_add_tail);
 void nftnl_set_list_add_tail(struct nftnl_set *s, struct nftnl_set_list *list)
 {
+	int key = djb_hash(s->name) % SET_NAME_HSIZE;
+
+	hlist_add_head(&s->hnode, &list->name_hash[key]);
 	list_add_tail(&s->head, &list->list);
 }
 
@@ -767,6 +790,7 @@ EXPORT_SYMBOL(nftnl_set_list_del);
 void nftnl_set_list_del(struct nftnl_set *s)
 {
 	list_del(&s->head);
+	hlist_del(&s->hnode);
 }
 
 EXPORT_SYMBOL(nftnl_set_list_foreach);
@@ -837,28 +861,19 @@ void nftnl_set_list_iter_destroy(const struct nftnl_set_list_iter *iter)
 	xfree(iter);
 }
 
-static struct nftnl_set *nftnl_set_lookup(const char *this_set_name,
-				      struct nftnl_set_list *set_list)
+EXPORT_SYMBOL(nftnl_set_list_lookup_byname);
+struct nftnl_set *
+nftnl_set_list_lookup_byname(struct nftnl_set_list *set_list, const char *set)
 {
-	struct nftnl_set_list_iter *iter;
+	int key = djb_hash(set) % SET_NAME_HSIZE;
+	struct hlist_node *n;
 	struct nftnl_set *s;
-	const char *set_name;
-
-	iter = nftnl_set_list_iter_create(set_list);
-	if (iter == NULL)
-		return NULL;
 
-	s = nftnl_set_list_iter_cur(iter);
-	while (s != NULL) {
-		set_name  = nftnl_set_get_str(s, NFTNL_SET_NAME);
-		if (strcmp(this_set_name, set_name) == 0)
-			break;
-
-		s = nftnl_set_list_iter_next(iter);
+	hlist_for_each_entry(s, n, &set_list->name_hash[key], hnode) {
+		if (!strcmp(set, s->name))
+			return s;
 	}
-	nftnl_set_list_iter_destroy(iter);
-
-	return s;
+	return NULL;
 }
 
 int nftnl_set_lookup_id(struct nftnl_expr *e,
@@ -871,7 +886,7 @@ int nftnl_set_lookup_id(struct nftnl_expr *e,
 	if (set_name == NULL)
 		return 0;
 
-	s = nftnl_set_lookup(set_name, set_list);
+	s = nftnl_set_list_lookup_byname(set_list, set_name);
 	if (s == NULL)
 		return 0;
 
-- 
2.23.0

