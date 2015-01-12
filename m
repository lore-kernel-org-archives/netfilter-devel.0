From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH 1/2 v2] src: not create iterator with empty list
Date: Mon, 12 Jan 2015 14:46:14 +0100
Message-ID: <1421070375-1057-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:55783 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbbALNqC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:46:02 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so14524073wiv.0
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Jan 2015 05:46:00 -0800 (PST)
Received: from localhost.localdomain (129.166.216.87.static.jazztel.es. [87.216.166.129])
        by mx.google.com with ESMTPSA id jp3sm10288322wid.9.2015.01.12.05.45.59
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Jan 2015 05:45:59 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now, we create iterator without test if the list is empty. If the list
is empty, we have a crash when we set up the current element.
With this patch, we test if the list is empty before to create the iterator. If
the list is empty the iterator return NULL.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v2]
 * If the list is empty, we set iter->cur to NULL and we check it in _next.

 src/chain.c    |    8 +++++++-
 src/rule.c     |   17 +++++++++++++++--
 src/set.c      |    8 +++++++-
 src/set_elem.c |    9 ++++++++-
 src/table.c    |    8 +++++++-
 5 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index b67385e..26ad14d 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -973,7 +973,10 @@ struct nft_chain_list_iter *nft_chain_list_iter_create(struct nft_chain_list *l)
 		return NULL;
 
 	iter->list = l;
-	iter->cur = list_entry(l->list.next, struct nft_chain, head);
+	if (nft_chain_list_is_empty(l))
+		iter->cur = NULL;
+	else
+		iter->cur = list_entry(l->list.next, struct nft_chain, head);
 
 	return iter;
 }
@@ -983,6 +986,9 @@ struct nft_chain *nft_chain_list_iter_next(struct nft_chain_list_iter *iter)
 {
 	struct nft_chain *r = iter->cur;
 
+	if (r == NULL)
+		return NULL;
+
 	/* get next chain, if any */
 	iter->cur = list_entry(iter->cur->head.next, struct nft_chain, head);
 	if (&iter->cur->head == iter->list->list.next)
diff --git a/src/rule.c b/src/rule.c
index c974f8b..ac5136c 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1043,7 +1043,11 @@ struct nft_rule_expr_iter *nft_rule_expr_iter_create(struct nft_rule *r)
 		return NULL;
 
 	iter->r = r;
-	iter->cur = list_entry(r->expr_list.next, struct nft_rule_expr, head);
+	if (list_empty(&r->expr_list))
+		iter->cur = NULL;
+	else
+		iter->cur = list_entry(r->expr_list.next, struct nft_rule_expr,
+				       head);
 
 	return iter;
 }
@@ -1053,6 +1057,9 @@ struct nft_rule_expr *nft_rule_expr_iter_next(struct nft_rule_expr_iter *iter)
 {
 	struct nft_rule_expr *expr = iter->cur;
 
+	if (expr == NULL)
+		return NULL;
+
 	/* get next expression, if any */
 	iter->cur = list_entry(iter->cur->head.next, struct nft_rule_expr, head);
 	if (&iter->cur->head == iter->r->expr_list.next)
@@ -1152,7 +1159,10 @@ struct nft_rule_list_iter *nft_rule_list_iter_create(struct nft_rule_list *l)
 		return NULL;
 
 	iter->list = l;
-	iter->cur = list_entry(l->list.next, struct nft_rule, head);
+	if (nft_rule_list_is_empty(l))
+		iter->cur = NULL;
+	else
+		iter->cur = list_entry(l->list.next, struct nft_rule, head);
 
 	return iter;
 }
@@ -1168,6 +1178,9 @@ struct nft_rule *nft_rule_list_iter_next(struct nft_rule_list_iter *iter)
 {
 	struct nft_rule *r = iter->cur;
 
+	if (r == NULL)
+		return NULL;
+
 	/* get next rule, if any */
 	iter->cur = list_entry(iter->cur->head.next, struct nft_rule, head);
 	if (&iter->cur->head == iter->list->list.next)
diff --git a/src/set.c b/src/set.c
index 2385031..61e0632 100644
--- a/src/set.c
+++ b/src/set.c
@@ -1020,7 +1020,10 @@ struct nft_set_list_iter *nft_set_list_iter_create(struct nft_set_list *l)
 		return NULL;
 
 	iter->list = l;
-	iter->cur = list_entry(l->list.next, struct nft_set, head);
+	if (nft_set_list_is_empty(l))
+		iter->cur = NULL;
+	else
+		iter->cur = list_entry(l->list.next, struct nft_set, head);
 
 	return iter;
 }
@@ -1036,6 +1039,9 @@ struct nft_set *nft_set_list_iter_next(struct nft_set_list_iter *iter)
 {
 	struct nft_set *s = iter->cur;
 
+	if (s == NULL)
+		return NULL;
+
 	/* get next rule, if any */
 	iter->cur = list_entry(iter->cur->head.next, struct nft_set, head);
 	if (&iter->cur->head == iter->list->list.next)
diff --git a/src/set_elem.c b/src/set_elem.c
index 95f12bf..4f52b1a 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -690,7 +690,11 @@ struct nft_set_elems_iter *nft_set_elems_iter_create(struct nft_set *s)
 
 	iter->set = s;
 	iter->list = &s->element_list;
-	iter->cur = list_entry(s->element_list.next, struct nft_set_elem, head);
+	if (list_empty(&s->element_list))
+		iter->cur = NULL;
+	else
+		iter->cur = list_entry(s->element_list.next,
+				       struct nft_set_elem, head);
 
 	return iter;
 }
@@ -706,6 +710,9 @@ struct nft_set_elem *nft_set_elems_iter_next(struct nft_set_elems_iter *iter)
 {
 	struct nft_set_elem *s = iter->cur;
 
+	if (s == NULL)
+		return NULL;
+
 	iter->cur = list_entry(iter->cur->head.next, struct nft_set_elem, head);
 	if (&iter->cur->head == iter->list->next)
 		return NULL;
diff --git a/src/table.c b/src/table.c
index c93e6fb..e947394 100644
--- a/src/table.c
+++ b/src/table.c
@@ -544,7 +544,10 @@ struct nft_table_list_iter *nft_table_list_iter_create(struct nft_table_list *l)
 		return NULL;
 
 	iter->list = l;
-	iter->cur = list_entry(l->list.next, struct nft_table, head);
+	if (nft_table_list_is_empty(l))
+		iter->cur = NULL;
+	else
+		iter->cur = list_entry(l->list.next, struct nft_table, head);
 
 	return iter;
 }
@@ -554,6 +557,9 @@ struct nft_table *nft_table_list_iter_next(struct nft_table_list_iter *iter)
 {
 	struct nft_table *r = iter->cur;
 
+	if (r == NULL)
+		return NULL;
+
 	/* get next table, if any */
 	iter->cur = list_entry(iter->cur->head.next, struct nft_table, head);
 	if (&iter->cur->head == iter->list->list.next)
-- 
1.7.10.4

