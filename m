From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] src: add nft_*_list_is_empty() functions
Date: Thu, 11 Jul 2013 10:44:13 +0200
Message-ID: <20130711084412.3037.23436.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:46481 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755523Ab3GKIoZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jul 2013 04:44:25 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 3108A51ED77
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Jul 2013 08:44:21 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9MZostrA0Z5p for <netfilter-devel@vger.kernel.org>;
	Thu, 11 Jul 2013 10:44:15 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id B27F251ED55
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Jul 2013 10:44:14 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This functions check if a given nft_*_list is empty or not.

I found this quite useful while working with a full ruleset.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/libnftables/chain.h |    1 +
 include/libnftables/rule.h  |    1 +
 include/libnftables/set.h   |    1 +
 include/libnftables/table.h |    1 +
 src/chain.c                 |    6 ++++++
 src/libnftables.map         |    4 ++++
 src/rule.c                  |    6 ++++++
 src/set.c                   |    6 ++++++
 src/table.c                 |    6 ++++++
 9 files changed, 32 insertions(+)

diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
index 29f7bc7..0eceda1 100644
--- a/include/libnftables/chain.h
+++ b/include/libnftables/chain.h
@@ -65,6 +65,7 @@ struct nft_chain_list;
 
 struct nft_chain_list *nft_chain_list_alloc(void);
 void nft_chain_list_free(struct nft_chain_list *list);
+int nft_chain_list_is_empty(struct nft_chain_list *list);
 int nft_chain_list_foreach(struct nft_chain_list *chain_list, int (*cb)(struct nft_chain *t, void *data), void *data);
 
 void nft_chain_list_add(struct nft_chain *r, struct nft_chain_list *list);
diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index 186c82c..cadd14d 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -73,6 +73,7 @@ struct nft_rule_list;
 
 struct nft_rule_list *nft_rule_list_alloc(void);
 void nft_rule_list_free(struct nft_rule_list *list);
+int nft_rule_list_is_empty(struct nft_rule_list *list);
 void nft_rule_list_add(struct nft_rule *r, struct nft_rule_list *list);
 int nft_rule_list_foreach(struct nft_rule_list *rule_list, int (*cb)(struct nft_rule *t, void *data), void *data);
 
diff --git a/include/libnftables/set.h b/include/libnftables/set.h
index 5c77945..4a94a85 100644
--- a/include/libnftables/set.h
+++ b/include/libnftables/set.h
@@ -41,6 +41,7 @@ struct nft_set_list;
 
 struct nft_set_list *nft_set_list_alloc(void);
 void nft_set_list_free(struct nft_set_list *list);
+int nft_set_list_is_empty(struct nft_set_list *list);
 void nft_set_list_add(struct nft_set *s, struct nft_set_list *list);
 int nft_set_list_foreach(struct nft_set_list *set_list, int (*cb)(struct nft_set *t, void *data), void *data);
 
diff --git a/include/libnftables/table.h b/include/libnftables/table.h
index 9445879..4fc19eb 100644
--- a/include/libnftables/table.h
+++ b/include/libnftables/table.h
@@ -53,6 +53,7 @@ struct nft_table_list;
 
 struct nft_table_list *nft_table_list_alloc(void);
 void nft_table_list_free(struct nft_table_list *list);
+int nft_table_list_is_empty(struct nft_table_list *list);
 int nft_table_list_foreach(struct nft_table_list *table_list, int (*cb)(struct nft_table *t, void *data), void *data);
 
 void nft_table_list_add(struct nft_table *r, struct nft_table_list *list);
diff --git a/src/chain.c b/src/chain.c
index bdbaf60..3555829 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -862,6 +862,12 @@ void nft_chain_list_free(struct nft_chain_list *list)
 }
 EXPORT_SYMBOL(nft_chain_list_free);
 
+int nft_chain_list_is_empty(struct nft_chain_list *list)
+{
+	return list_empty(&list->list);
+}
+EXPORT_SYMBOL(nft_chain_list_is_empty);
+
 void nft_chain_list_add(struct nft_chain *r, struct nft_chain_list *list)
 {
 	list_add_tail(&r->head, &list->list);
diff --git a/src/libnftables.map b/src/libnftables.map
index 9546bca..a60b943 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -17,6 +17,7 @@ global:
   nft_table_nlmsg_parse;
   nft_table_list_alloc;
   nft_table_list_free;
+  nft_table_list_is_empty;
   nft_table_list_foreach;
   nft_table_list_add;
   nft_table_list_iter_create;
@@ -44,6 +45,7 @@ global:
   nft_chain_nlmsg_parse;
   nft_chain_list_alloc;
   nft_chain_list_free;
+  nft_chain_list_is_empty;
   nft_chain_list_add;
   nft_chain_list_del;
   nft_chain_list_foreach;
@@ -94,6 +96,7 @@ global:
 
   nft_rule_list_alloc;
   nft_rule_list_free;
+  nft_rule_list_is_empty;
   nft_rule_list_add;
   nft_rule_list_foreach;
   nft_rule_list_iter_create;
@@ -119,6 +122,7 @@ global:
   nft_set_list_alloc;
   nft_set_list_free;
   nft_set_list_add;
+  nft_set_list_is_empty;
   nft_set_list_foreach;
 
   nft_set_list_iter_create;
diff --git a/src/rule.c b/src/rule.c
index 5a4ae91..aa7aee8 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -867,6 +867,12 @@ void nft_rule_list_free(struct nft_rule_list *list)
 }
 EXPORT_SYMBOL(nft_rule_list_free);
 
+int nft_rule_list_is_empty(struct nft_rule_list *list)
+{
+	return list_empty(&list->list);
+}
+EXPORT_SYMBOL(nft_rule_list_is_empty);
+
 void nft_rule_list_add(struct nft_rule *r, struct nft_rule_list *list)
 {
 	list_add_tail(&r->head, &list->list);
diff --git a/src/set.c b/src/set.c
index dc3bd27..3874a5b 100644
--- a/src/set.c
+++ b/src/set.c
@@ -473,6 +473,12 @@ void nft_set_list_free(struct nft_set_list *list)
 }
 EXPORT_SYMBOL(nft_set_list_free);
 
+int nft_set_list_is_empty(struct nft_set_list *list)
+{
+	return list_empty(&list->list);
+}
+EXPORT_SYMBOL(nft_set_list_is_empty);
+
 void nft_set_list_add(struct nft_set *s, struct nft_set_list *list)
 {
 	list_add_tail(&s->head, &list->list);
diff --git a/src/table.c b/src/table.c
index 27fa8fc..9ec4117 100644
--- a/src/table.c
+++ b/src/table.c
@@ -410,6 +410,12 @@ void nft_table_list_free(struct nft_table_list *list)
 }
 EXPORT_SYMBOL(nft_table_list_free);
 
+int nft_table_list_is_empty(struct nft_table_list *list)
+{
+	return list_empty(&list->list);
+}
+EXPORT_SYMBOL(nft_table_list_is_empty);
+
 void nft_table_list_add(struct nft_table *r, struct nft_table_list *list)
 {
 	list_add_tail(&r->head, &list->list);

