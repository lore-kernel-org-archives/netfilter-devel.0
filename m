From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 1/2] src: add batch abstraction
Date: Tue, 14 Apr 2015 20:59:59 +0200
Message-ID: <1429038000-3961-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58503 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbbDNSzv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Apr 2015 14:55:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a new batch class to libnftnl, it basically generalizes what we
already have.

A batch is composed of one or more page objects. Every page may contain one or
more netlink messages.

 batch
   *      .------.   .------.         .------.
   |      |      |   |      |         |      |
   `----> | page |-->| page |-->...-->| page |
          |      |   |      |         |      |
          `------'   `------'         `------'

You can create a batch via:

	batch = nft_batch_alloc(...);

This batch initially comes with one initial page.

You can fetch a pointer to the next spare area in the current page to add a new
netlink message to the batch.

	void *nft_batch_buffer(struct nft_batch *batch);

Once you have added a netlink message, you have to call:

	nft_batch_update(batch);

this internally updates the pointer to the next spare data area in the page.

Every page has a limit threshold after which you start using the overrun area.

  page  .------.
        |      |
        |      |
        .      . page area
        |      |
        |      |
        |------|<--- limit
        |      |
        |      | overrun area
        |      |
        '______'<--- real page size

If we write over the limit, then the next call to nft_batch_update() results in
a new empty page added to the batch. With careful page size and limit
selection, we ensure that a netlink message always fit into the page, so we
avoid the overhead of canceling netlink messages that doesn't fit in.

Once your batch is complete, if you want to send it out to kernel-space, you
can convert them to iovec via:

	nft_batch_iovec(batch, iov, iov_len);

Then, after having sent the batch, you can release it via:

	nft_batch_free(batch);

This class relies on the libmnl batching infrastructure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/Makefile.am |    3 +-
 include/libnftnl/batch.h     |   18 +++++
 src/Makefile.am              |    1 +
 src/batch.c                  |  162 ++++++++++++++++++++++++++++++++++++++++++
 src/libnftnl.map             |    8 +++
 5 files changed, 191 insertions(+), 1 deletion(-)
 create mode 100644 include/libnftnl/batch.h
 create mode 100644 src/batch.c

diff --git a/include/libnftnl/Makefile.am b/include/libnftnl/Makefile.am
index 010c01f..a20aaee 100644
--- a/include/libnftnl/Makefile.am
+++ b/include/libnftnl/Makefile.am
@@ -1,4 +1,5 @@
-pkginclude_HEADERS = table.h		\
+pkginclude_HEADERS = batch.h		\
+		     table.h		\
 		     chain.h		\
 		     rule.h		\
 		     expr.h		\
diff --git a/include/libnftnl/batch.h b/include/libnftnl/batch.h
new file mode 100644
index 0000000..40416e6
--- /dev/null
+++ b/include/libnftnl/batch.h
@@ -0,0 +1,18 @@
+#ifndef _LIBNFTNL_BATCH_H_
+#define _LIBNFTNL_BATCH_H_
+
+#include <stdint.h>
+
+struct nft_batch;
+
+struct nft_batch *nft_batch_alloc(uint32_t pg_size, uint32_t pg_overrun_size);
+int nft_batch_update(struct nft_batch *batch);
+void nft_batch_free(struct nft_batch *batch);
+
+void *nft_batch_buffer(struct nft_batch *batch);
+uint32_t nft_batch_buffer_len(struct nft_batch *batch);
+
+int nft_batch_iovec_len(struct nft_batch *batch);
+void nft_batch_iovec(struct nft_batch *batch, struct iovec *iov, uint32_t iovlen);
+
+#endif
diff --git a/src/Makefile.am b/src/Makefile.am
index 3fca5e4..edabb52 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -6,6 +6,7 @@ libnftnl_la_LDFLAGS = -Wl,--version-script=$(srcdir)/libnftnl.map	\
 		      -version-info $(LIBVERSION)
 
 libnftnl_la_SOURCES = utils.c		\
+		      batch.c		\
 		      buffer.c		\
 		      common.c		\
 		      gen.c		\
diff --git a/src/batch.c b/src/batch.c
new file mode 100644
index 0000000..ec9f728
--- /dev/null
+++ b/src/batch.c
@@ -0,0 +1,162 @@
+/*
+ * Copyright (c) 2013-2015 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "internal.h"
+#include <errno.h>
+#include <libmnl/libmnl.h>
+#include <libnftnl/batch.h>
+
+struct nft_batch {
+	uint32_t		num_pages;
+	struct nft_batch_page	*current_page;
+	uint32_t		page_size;
+	uint32_t		page_overrun_size;
+	struct list_head	page_list;
+};
+
+struct nft_batch_page {
+	struct list_head	head;
+	struct mnl_nlmsg_batch	*batch;
+};
+
+static struct nft_batch_page *nft_batch_page_alloc(struct nft_batch *batch)
+{
+	struct nft_batch_page *page;
+	char *buf;
+
+	page = malloc(sizeof(struct nft_batch_page));
+	if (page == NULL)
+		return NULL;
+
+	buf = malloc(batch->page_size + batch->page_overrun_size);
+	if (buf == NULL)
+		goto err1;
+
+	page->batch = mnl_nlmsg_batch_start(buf, batch->page_size);
+	if (page->batch == NULL)
+		goto err2;
+
+	return page;
+err2:
+	free(buf);
+err1:
+	free(page);
+	return NULL;
+}
+
+static void nft_batch_add_page(struct nft_batch_page *page,
+			       struct nft_batch *batch)
+{
+	batch->current_page = page;
+	batch->num_pages++;
+	list_add_tail(&page->head, &batch->page_list);
+}
+
+struct nft_batch *nft_batch_alloc(uint32_t pg_size, uint32_t pg_overrun_size)
+{
+	struct nft_batch *batch;
+	struct nft_batch_page *page;
+
+	batch = calloc(1, sizeof(struct nft_batch));
+	if (batch == NULL)
+		return NULL;
+
+	batch->page_size = pg_size;
+	batch->page_overrun_size = pg_overrun_size;
+	INIT_LIST_HEAD(&batch->page_list);
+
+	page = nft_batch_page_alloc(batch);
+	if (page == NULL)
+		goto err1;
+
+	nft_batch_add_page(page, batch);
+	return batch;
+err1:
+	free(batch);
+	return NULL;
+}
+EXPORT_SYMBOL(nft_batch_alloc);
+
+void nft_batch_free(struct nft_batch *batch)
+{
+	struct nft_batch_page *page, *next;
+
+	list_for_each_entry_safe(page, next, &batch->page_list, head) {
+		free(mnl_nlmsg_batch_head(page->batch));
+		mnl_nlmsg_batch_stop(page->batch);
+		free(page);
+	}
+
+	free(batch);
+}
+EXPORT_SYMBOL(nft_batch_free);
+
+int nft_batch_update(struct nft_batch *batch)
+{
+	struct nft_batch_page *page;
+	struct nlmsghdr *last_nlh;
+
+	if (mnl_nlmsg_batch_next(batch->current_page->batch))
+		return 0;
+
+	last_nlh = nft_batch_buffer(batch);
+
+	page = nft_batch_page_alloc(batch);
+	if (page == NULL)
+		goto err1;
+
+	nft_batch_add_page(page, batch);
+
+	memcpy(nft_batch_buffer(batch), last_nlh, last_nlh->nlmsg_len);
+	mnl_nlmsg_batch_next(batch->current_page->batch);
+
+	return 0;
+err1:
+	return -1;
+}
+EXPORT_SYMBOL(nft_batch_update);
+
+void *nft_batch_buffer(struct nft_batch *batch)
+{
+	return mnl_nlmsg_batch_current(batch->current_page->batch);
+}
+EXPORT_SYMBOL(nft_batch_buffer);
+
+uint32_t nft_batch_buffer_len(struct nft_batch *batch)
+{
+	return mnl_nlmsg_batch_size(batch->current_page->batch);
+}
+EXPORT_SYMBOL(nft_batch_buffer_len);
+
+int nft_batch_iovec_len(struct nft_batch *batch)
+{
+	int num_pages = batch->num_pages;
+
+	/* Skip last page if it's empty */
+	if (mnl_nlmsg_batch_is_empty(batch->current_page->batch))
+		num_pages--;
+
+	return num_pages;
+}
+EXPORT_SYMBOL(nft_batch_iovec_len);
+
+void nft_batch_iovec(struct nft_batch *batch, struct iovec *iov, uint32_t iovlen)
+{
+	struct nft_batch_page *page;
+	int i = 0;
+
+	list_for_each_entry(page, &batch->page_list, head) {
+		if (i >= iovlen)
+			break;
+
+		iov[i].iov_base = mnl_nlmsg_batch_head(page->batch);
+		iov[i].iov_len = mnl_nlmsg_batch_size(page->batch);
+		i++;
+	}
+}
+EXPORT_SYMBOL(nft_batch_iovec);
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 7c74fbc..78e1799 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -234,4 +234,12 @@ LIBNFTNL_1.2.0 {
   nft_ruleset_ctx_get_u32;
   nft_ruleset_parse_file_cb;
   nft_ruleset_parse_buffer_cb;
+
+  nft_batch_alloc;
+  nft_batch_update;
+  nft_batch_free;
+  nft_batch_buffer;
+  nft_batch_buffer_len;
+  nft_batch_iovec_len;
+  nft_batch_iovec;
 } LIBNFTNL_1.2;
-- 
1.7.10.4

