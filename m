From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nftables] mnl: fix inclusion of last rule in batch page
Date: Thu, 30 Jan 2014 16:50:46 +0100
Message-ID: <1391097046-4177-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54878 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808AbaA3Pu4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jan 2014 10:50:56 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes the inclusion of the last rule that didn't fit
into a batch page.

When using sets this has manifested with the -EBUSY error when deleting
the table (it was still containing unused sets after the flush).

The following command line works fine here:

nft -f test ; nft flush table filter ; nft delete chain filter output; nft delete table filter

Tested using this kernel patch: http://patchwork.ozlabs.org/patch/314143/

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
I originally though this was a libmnl bug in the batching infrastructure, but
it's actually in the way nft handles batch pages.

 src/mnl.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/src/mnl.c b/src/mnl.c
index b867902..a38a9ae 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -19,6 +19,7 @@
 #include <linux/netfilter/nf_tables.h>
 
 #include <mnl.h>
+#include <string.h>
 #include <errno.h>
 #include <utils.h>
 #include <nftables.h>
@@ -98,12 +99,21 @@ struct batch_page {
 static void mnl_batch_page_add(void)
 {
 	struct batch_page *batch_page;
+	struct nlmsghdr *last_nlh;
+
+	/* Get the last message not fitting in the batch */
+	last_nlh = mnl_nlmsg_batch_current(batch);
 
 	batch_page = xmalloc(sizeof(struct batch_page));
 	batch_page->batch = batch;
 	list_add_tail(&batch_page->head, &batch_page_list);
 	batch_num_pages++;
 	batch = mnl_batch_alloc();
+
+	/* Copy the last message not fitting to the new batch page */
+	memcpy(mnl_nlmsg_batch_current(batch), last_nlh, last_nlh->nlmsg_len);
+	/* No overflow may happen as this is a new empty batch page */
+	mnl_nlmsg_batch_next(batch);
 }
 
 static uint32_t mnl_batch_put(int type)
-- 
1.7.10.4

