Return-Path: <SRS0=5odi=AW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F41C433E1
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 08:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1905320725
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 08:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgGKIpQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Jul 2020 04:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728049AbgGKIpQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Jul 2020 04:45:16 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55335C08C5DD
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Jul 2020 01:45:16 -0700 (PDT)
Received: from localhost ([::1]:59256 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1juB8D-0006EA-Rm; Sat, 11 Jul 2020 10:45:13 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH] chain: Implement chain list sorting
Date:   Sat, 11 Jul 2020 10:45:05 +0200
Message-Id: <20200711084505.23825-1-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add two convenience functions for nftnl_chain_list sorting, both
accepting a pointer to a user-defined comparison function:

* nftnl_chain_list_sort: Sort existing elements in a list.
* nftnl_chain_list_add_sorted: Add a new element to the sorted list.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/libnftnl/chain.h    |  3 ++
 src/chain.c                 | 59 ++++++++++++++++++++++++++++++++++
 src/libnftnl.map            |  5 +++
 tests/Makefile.am           |  4 +++
 tests/nft-chain-list-test.c | 63 +++++++++++++++++++++++++++++++++++++
 5 files changed, 134 insertions(+)
 create mode 100644 tests/nft-chain-list-test.c

diff --git a/include/libnftnl/chain.h b/include/libnftnl/chain.h
index 291bf22a2fddf..476ea8d496c35 100644
--- a/include/libnftnl/chain.h
+++ b/include/libnftnl/chain.h
@@ -102,6 +102,9 @@ void nftnl_chain_list_add(struct nftnl_chain *r, struct nftnl_chain_list *list);
 void nftnl_chain_list_add_tail(struct nftnl_chain *r, struct nftnl_chain_list *list);
 void nftnl_chain_list_del(struct nftnl_chain *c);
 
+void nftnl_chain_list_sort(struct nftnl_chain_list *list, int (*cmp)(struct nftnl_chain *a, struct nftnl_chain *b));
+void nftnl_chain_list_add_sorted(struct nftnl_chain *r, struct nftnl_chain_list *list, int (*cmp)(struct nftnl_chain *a, struct nftnl_chain *b));
+
 struct nftnl_chain_list_iter;
 
 struct nftnl_chain_list_iter *nftnl_chain_list_iter_create(const struct nftnl_chain_list *l);
diff --git a/src/chain.c b/src/chain.c
index 5f1213013e530..9fc36c038a480 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -1031,6 +1031,65 @@ void nftnl_chain_list_add_tail(struct nftnl_chain *r, struct nftnl_chain_list *l
 	list_add_tail(&r->head, &list->list);
 }
 
+static void __nftnl_chain_list_sort(struct list_head *list,
+				    int (*cmp)(struct nftnl_chain *a,
+					       struct nftnl_chain *b))
+{
+	struct nftnl_chain *pivot, *cur, *sav;
+	LIST_HEAD(sublist);
+
+	if (list_empty(list))
+		return;
+
+	/* grab first item as pivot (dividing) value */
+	pivot = list_entry(list->next, struct nftnl_chain, head);
+	list_del(&pivot->head);
+
+	/* move any smaller value into sublist */
+	list_for_each_entry_safe(cur, sav, list, head) {
+		if (cmp(pivot, cur) > 0) {
+			list_del(&cur->head);
+			list_add_tail(&cur->head, &sublist);
+		}
+	}
+	/* conquer divided */
+	__nftnl_chain_list_sort(&sublist, cmp);
+	__nftnl_chain_list_sort(list, cmp);
+
+	/* merge divided and pivot again */
+	list_add_tail(&pivot->head, &sublist);
+	list_splice(&sublist, list);
+}
+
+EXPORT_SYMBOL(nftnl_chain_list_sort);
+void nftnl_chain_list_sort(struct nftnl_chain_list *list,
+			   int (*cmp)(struct nftnl_chain *a,
+				      struct nftnl_chain *b))
+{
+	__nftnl_chain_list_sort(&list->list, cmp);
+}
+
+EXPORT_SYMBOL(nftnl_chain_list_add_sorted);
+void nftnl_chain_list_add_sorted(struct nftnl_chain *c,
+				 struct nftnl_chain_list *list,
+				 int (*cmp)(struct nftnl_chain *a,
+					    struct nftnl_chain *b))
+{
+	int key = djb_hash(c->name) % CHAIN_NAME_HSIZE;
+	struct list_head *pos = &list->list;
+	struct nftnl_chain *cur;
+
+	hlist_add_head(&c->hnode, &list->name_hash[key]);
+
+	list_for_each_entry(cur, &list->list, head) {
+		if (cmp(c, cur) < 0) {
+			pos = &cur->head;
+			break;
+		}
+	}
+	list_add_tail(&c->head, pos);
+}
+
 EXPORT_SYMBOL(nftnl_chain_list_del);
 void nftnl_chain_list_del(struct nftnl_chain *r)
 {
diff --git a/src/libnftnl.map b/src/libnftnl.map
index f62640f83e6b5..379580e9945b8 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -368,3 +368,8 @@ LIBNFTNL_14 {
   nftnl_flowtable_set_array;
   nftnl_flowtable_get_array;
 } LIBNFTNL_13;
+
+LIBNFTNL_15 {
+  nftnl_chain_list_add_sorted;
+  nftnl_chain_list_sort;
+} LIBNFTNL_14;
diff --git a/tests/Makefile.am b/tests/Makefile.am
index c7d77edc020f2..eedc3828eb8ca 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -2,6 +2,7 @@ include $(top_srcdir)/Make_global.am
 
 check_PROGRAMS = 	nft-table-test			\
 			nft-chain-test			\
+			nft-chain-list-test		\
 			nft-object-test			\
 			nft-rule-test			\
 			nft-set-test			\
@@ -41,6 +42,9 @@ nft_table_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 nft_chain_test_SOURCES = nft-chain-test.c
 nft_chain_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
+nft_chain_list_test_SOURCES = nft-chain-list-test.c
+nft_chain_list_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
 nft_object_test_SOURCES = nft-object-test.c
 nft_object_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
diff --git a/tests/nft-chain-list-test.c b/tests/nft-chain-list-test.c
new file mode 100644
index 0000000000000..2bf3ccb8b238a
--- /dev/null
+++ b/tests/nft-chain-list-test.c
@@ -0,0 +1,63 @@
+/*
+ * Copyright (c) 2020  Red Hat GmbH.  Author: Phil Sutter <phil@nwl.cc>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <linux/netfilter/nf_tables.h>
+#include <libnftnl/chain.h>
+
+static struct nftnl_chain *alloc_chain(const char *name)
+{
+	struct nftnl_chain *c = nftnl_chain_alloc();
+
+	if (c)
+		nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, name);
+	return c;
+}
+
+static int chain_name_cmp(struct nftnl_chain *a, struct nftnl_chain *b)
+{
+	return strcmp(nftnl_chain_get_str(a, NFTNL_CHAIN_NAME),
+		      nftnl_chain_get_str(b, NFTNL_CHAIN_NAME));
+}
+
+static int chain_name_check(struct nftnl_chain *c, void *data)
+{
+	return atoi(nftnl_chain_get_str(c, NFTNL_CHAIN_NAME))
+		!= (*(int *)data)++;
+}
+
+int main(int argc, char *argv[])
+{
+	struct nftnl_chain_list *list = nftnl_chain_list_alloc();
+	int i = 1, rc;
+
+	nftnl_chain_list_add_tail(alloc_chain("4"), list);
+	nftnl_chain_list_add_tail(alloc_chain("6"), list);
+	nftnl_chain_list_add_tail(alloc_chain("2"), list);
+
+	nftnl_chain_list_sort(list, chain_name_cmp);
+
+	nftnl_chain_list_add_sorted(alloc_chain("3"), list, chain_name_cmp);
+	nftnl_chain_list_add_sorted(alloc_chain("5"), list, chain_name_cmp);
+	nftnl_chain_list_add_sorted(alloc_chain("1"), list, chain_name_cmp);
+
+	rc = nftnl_chain_list_foreach(list, chain_name_check, &i);
+	nftnl_chain_list_free(list);
+
+	if (rc || i < 7) {
+		printf("\033[31mERROR:\e[0m chain names not in sorted order\n");
+		exit(EXIT_FAILURE);
+	}
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+
+}
-- 
2.27.0

