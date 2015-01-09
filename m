From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH 1/2] src: not create iterator with empty list
Date: Fri,  9 Jan 2015 13:47:40 +0100
Message-ID: <1420807661-29751-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34249 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbbAIMrP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:47:15 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so2026606wiv.5
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Jan 2015 04:47:14 -0800 (PST)
Received: from localhost.localdomain (129.166.216.87.static.jazztel.es. [87.216.166.129])
        by mx.google.com with ESMTPSA id wr8sm9919145wjc.10.2015.01.09.04.47.13
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Jan 2015 04:47:13 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now, we create iterator without test if the list is empty. If the list
is empty, we have a crash when we set up the current element.
With this patch, we test if the list is empty before to create the iterator. If
the list is empty the iterator return NULL.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/chain.c    |    3 +++
 src/rule.c     |    6 ++++++
 src/set.c      |    3 +++
 src/set_elem.c |    3 +++
 src/table.c    |    3 +++
 5 files changed, 18 insertions(+)

diff --git a/src/chain.c b/src/chain.c
index b67385e..e7de4ef 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -968,6 +968,9 @@ struct nft_chain_list_iter *nft_chain_list_iter_create(struct nft_chain_list *l)
 {
 	struct nft_chain_list_iter *iter;
 
+	if (nft_chain_list_is_empty(l))
+		return NULL;
+
 	iter = calloc(1, sizeof(struct nft_chain_list_iter));
 	if (iter == NULL)
 		return NULL;
diff --git a/src/rule.c b/src/rule.c
index c974f8b..f5a84f7 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1038,6 +1038,9 @@ struct nft_rule_expr_iter *nft_rule_expr_iter_create(struct nft_rule *r)
 {
 	struct nft_rule_expr_iter *iter;
 
+	if (list_empty(&r->expr_list))
+		return NULL;
+
 	iter = calloc(1, sizeof(struct nft_rule_expr_iter));
 	if (iter == NULL)
 		return NULL;
@@ -1147,6 +1150,9 @@ struct nft_rule_list_iter *nft_rule_list_iter_create(struct nft_rule_list *l)
 {
 	struct nft_rule_list_iter *iter;
 
+	if (nft_rule_list_is_empty(l))
+		return NULL;
+
 	iter = calloc(1, sizeof(struct nft_rule_list_iter));
 	if (iter == NULL)
 		return NULL;
diff --git a/src/set.c b/src/set.c
index 2385031..dee24a5 100644
--- a/src/set.c
+++ b/src/set.c
@@ -1015,6 +1015,9 @@ struct nft_set_list_iter *nft_set_list_iter_create(struct nft_set_list *l)
 {
 	struct nft_set_list_iter *iter;
 
+	if (nft_set_list_is_empty(l))
+		return NULL;
+
 	iter = calloc(1, sizeof(struct nft_set_list_iter));
 	if (iter == NULL)
 		return NULL;
diff --git a/src/set_elem.c b/src/set_elem.c
index 95f12bf..85c4519 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -684,6 +684,9 @@ struct nft_set_elems_iter *nft_set_elems_iter_create(struct nft_set *s)
 {
 	struct nft_set_elems_iter *iter;
 
+	if (list_empty(&s->element_list))
+		return NULL;
+
 	iter = calloc(1, sizeof(struct nft_set_elems_iter));
 	if (iter == NULL)
 		return NULL;
diff --git a/src/table.c b/src/table.c
index c93e6fb..544a8c3 100644
--- a/src/table.c
+++ b/src/table.c
@@ -539,6 +539,9 @@ struct nft_table_list_iter *nft_table_list_iter_create(struct nft_table_list *l)
 {
 	struct nft_table_list_iter *iter;
 
+	if (nft_table_list_is_empty(l))
+		return NULL;
+
 	iter = calloc(1, sizeof(struct nft_table_list_iter));
 	if (iter == NULL)
 		return NULL;
-- 
1.7.10.4

