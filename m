From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] mnl: use new libnftnl batch API
Date: Tue, 14 Apr 2015 21:00:00 +0200
Message-ID: <1429038000-3961-2-git-send-email-pablo@netfilter.org>
References: <1429038000-3961-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58509 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835AbbDNSzw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Apr 2015 14:55:52 -0400
In-Reply-To: <1429038000-3961-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Each batch page has a size of 320 Kbytes, and the limit has been set to 256
KBytes, so the overrun area is 64 KBytes long to accomodate the largest netlink
message (sets).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c |  124 ++++++++++++++++---------------------------------------------
 1 file changed, 33 insertions(+), 91 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 89c2bb5..76a9714 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -16,6 +16,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/set.h>
+#include <libnftnl/batch.h>
 
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
@@ -126,77 +127,26 @@ static int check_genid(const struct nlmsghdr *nlh)
  */
 #define BATCH_PAGE_SIZE getpagesize() * 32
 
-static struct mnl_nlmsg_batch *mnl_batch_alloc(void)
-{
-	static char *buf;
-
-	/* libmnl needs higher buffer to handle batch overflows. */
-	buf = xmalloc(BATCH_PAGE_SIZE + NFT_NLMSG_MAXSIZE);
-	return mnl_nlmsg_batch_start(buf, BATCH_PAGE_SIZE);
-}
-
-static LIST_HEAD(batch_page_list);
-static int batch_num_pages;
-
-struct batch_page {
-	struct list_head	head;
-	struct mnl_nlmsg_batch *batch;
-};
+static struct nft_batch *batch;
 
 void mnl_batch_init(void)
 {
-	struct batch_page *batch_page;
-
-	batch_page = xmalloc(sizeof(struct batch_page));
-	batch_page->batch = mnl_batch_alloc();
-	batch_num_pages++;
-	list_add_tail(&batch_page->head, &batch_page_list);
-}
-
-static struct batch_page *nft_batch_page_current(void)
-{
-	return list_entry(batch_page_list.prev, struct batch_page, head);
-}
-
-static void *nft_nlmsg_batch_current(void)
-{
-	return mnl_nlmsg_batch_current(nft_batch_page_current()->batch);
-}
-
-static void nft_batch_page_add(void)
-{
-	struct nlmsghdr *last_nlh;
-
-	/* Get the last message not fitting in the batch */
-	last_nlh = nft_nlmsg_batch_current();
-	/* Add new batch page */
-	mnl_batch_init();
-	/* Copy the last message not fitting to the new batch page */
-	memcpy(nft_nlmsg_batch_current(), last_nlh, last_nlh->nlmsg_len);
-	/* No overflow may happen as this is a new empty batch page */
-	mnl_nlmsg_batch_next(nft_batch_page_current()->batch);
-}
-
-static void nft_batch_page_release(struct batch_page *batch_page)
-{
-	list_del(&batch_page->head);
-	xfree(mnl_nlmsg_batch_head(batch_page->batch));
-	mnl_nlmsg_batch_stop(batch_page->batch);
-	xfree(batch_page);
-	batch_num_pages--;
+	batch = nft_batch_alloc(BATCH_PAGE_SIZE, NFT_NLMSG_MAXSIZE);
+	if (batch == NULL)
+		memory_allocation_error();
 }
 
 static void nft_batch_continue(void)
 {
-	if (!mnl_nlmsg_batch_next(nft_batch_page_current()->batch))
-		nft_batch_page_add();
+	if (nft_batch_update(batch) < 0)
+		memory_allocation_error();
 }
 
 uint32_t mnl_batch_begin(void)
 {
 	uint32_t seq = mnl_seqnum_alloc();
 
-	nft_batch_begin(nft_nlmsg_batch_current(), seq);
+	nft_batch_begin(nft_batch_buffer(batch), seq);
 	nft_batch_continue();
 
 	return seq;
@@ -204,7 +154,7 @@ uint32_t mnl_batch_begin(void)
 
 void mnl_batch_end(void)
 {
-	nft_batch_end(nft_nlmsg_batch_current(), mnl_seqnum_alloc());
+	nft_batch_end(nft_batch_buffer(batch), mnl_seqnum_alloc());
 	nft_batch_continue();
 }
 
@@ -213,16 +163,13 @@ bool mnl_batch_ready(void)
 	/* Check if the batch only contains the initial and trailing batch
 	 * messages. In that case, the batch is empty.
 	 */
-	return mnl_nlmsg_batch_size(nft_batch_page_current()->batch) !=
-	       (NLMSG_HDRLEN+sizeof(struct nfgenmsg)) * 2;
+	return nft_batch_buffer_len(batch) !=
+	       (NLMSG_HDRLEN + sizeof(struct nfgenmsg)) * 2;
 }
 
 void mnl_batch_reset(void)
 {
-	struct batch_page *batch_page, *next;
-
-	list_for_each_entry_safe(batch_page, next, &batch_page_list, head)
-		nft_batch_page_release(batch_page);
+	nft_batch_free(batch);
 }
 
 static void mnl_err_list_node_add(struct list_head *err_list, int error,
@@ -247,10 +194,10 @@ static void mnl_set_sndbuffer(const struct mnl_socket *nl)
 {
 	int newbuffsiz;
 
-	if (batch_num_pages * BATCH_PAGE_SIZE <= nlbuffsiz)
+	if (nft_batch_iovec_len(batch) * BATCH_PAGE_SIZE <= nlbuffsiz)
 		return;
 
-	newbuffsiz = batch_num_pages * BATCH_PAGE_SIZE;
+	newbuffsiz = nft_batch_iovec_len(batch) * BATCH_PAGE_SIZE;
 
 	/* Rise sender buffer length to avoid hitting -EMSGSIZE */
 	if (setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_SNDBUFFORCE,
@@ -265,27 +212,26 @@ static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl)
 	static const struct sockaddr_nl snl = {
 		.nl_family = AF_NETLINK
 	};
-	struct iovec iov[batch_num_pages];
+	uint32_t iov_len = nft_batch_iovec_len(batch);
+	struct iovec iov[iov_len];
 	struct msghdr msg = {
 		.msg_name	= (struct sockaddr *) &snl,
 		.msg_namelen	= sizeof(snl),
 		.msg_iov	= iov,
-		.msg_iovlen	= batch_num_pages,
+		.msg_iovlen	= iov_len,
 	};
-	struct batch_page *batch_page;
-	int i = 0;
+#ifdef DEBUG
+	uint32_t i;
+#endif
 
 	mnl_set_sndbuffer(nl);
+	nft_batch_iovec(batch, iov, iov_len);
 
-	list_for_each_entry(batch_page, &batch_page_list, head) {
-		iov[i].iov_base = mnl_nlmsg_batch_head(batch_page->batch);
-		iov[i].iov_len = mnl_nlmsg_batch_size(batch_page->batch);
-		i++;
 #ifdef DEBUG
+	for (i = 0; i < iov_len; i++) {
 		if (debug_level & DEBUG_MNL) {
 			mnl_nlmsg_fprintf(stdout,
-					  mnl_nlmsg_batch_head(batch_page->batch),
-					  mnl_nlmsg_batch_size(batch_page->batch),
+					  iov[i].iov_base, iov[i].iov_len,
 					  sizeof(struct nfgenmsg));
 		}
 #endif
@@ -304,10 +250,6 @@ int mnl_batch_talk(struct mnl_socket *nl, struct list_head *err_list)
 		.tv_usec	= 0
 	};
 
-	/* Remove last page from the batch if it's empty */
-	if (mnl_nlmsg_batch_is_empty(nft_batch_page_current()->batch))
-		nft_batch_page_release(nft_batch_page_current());
-
 	ret = mnl_nft_socket_sendmsg(nl);
 	if (ret == -1)
 		return -1;
@@ -347,7 +289,7 @@ int mnl_nft_rule_batch_add(struct nft_rule *nlr, unsigned int flags,
 {
 	struct nlmsghdr *nlh;
 
-	nlh = nft_rule_nlmsg_build_hdr(nft_nlmsg_batch_current(),
+	nlh = nft_rule_nlmsg_build_hdr(nft_batch_buffer(batch),
 			NFT_MSG_NEWRULE,
 			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
 			NLM_F_CREATE | flags, seqnum);
@@ -363,7 +305,7 @@ int mnl_nft_rule_batch_del(struct nft_rule *nlr, unsigned int flags,
 {
 	struct nlmsghdr *nlh;
 
-	nlh = nft_rule_nlmsg_build_hdr(nft_nlmsg_batch_current(),
+	nlh = nft_rule_nlmsg_build_hdr(nft_batch_buffer(batch),
 			NFT_MSG_DELRULE,
 			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
 			0, seqnum);
@@ -476,7 +418,7 @@ int mnl_nft_chain_batch_add(struct nft_chain *nlc, unsigned int flags,
 {
 	struct nlmsghdr *nlh;
 
-	nlh = nft_chain_nlmsg_build_hdr(nft_nlmsg_batch_current(),
+	nlh = nft_chain_nlmsg_build_hdr(nft_batch_buffer(batch),
 			NFT_MSG_NEWCHAIN,
 			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY),
 			NLM_F_CREATE | flags, seqnum);
@@ -505,7 +447,7 @@ int mnl_nft_chain_batch_del(struct nft_chain *nlc, unsigned int flags,
 {
 	struct nlmsghdr *nlh;
 
-	nlh = nft_chain_nlmsg_build_hdr(nft_nlmsg_batch_current(),
+	nlh = nft_chain_nlmsg_build_hdr(nft_batch_buffer(batch),
 			NFT_MSG_DELCHAIN,
 			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY),
 			NLM_F_ACK, seqnum);
@@ -604,7 +546,7 @@ int mnl_nft_table_batch_add(struct nft_table *nlt, unsigned int flags,
 {
 	struct nlmsghdr *nlh;
 
-	nlh = nft_table_nlmsg_build_hdr(nft_nlmsg_batch_current(),
+	nlh = nft_table_nlmsg_build_hdr(nft_batch_buffer(batch),
 			NFT_MSG_NEWTABLE,
 			nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY),
 			flags, seqnum);
@@ -633,7 +575,7 @@ int mnl_nft_table_batch_del(struct nft_table *nlt, unsigned int flags,
 {
 	struct nlmsghdr *nlh;
 
-	nlh = nft_table_nlmsg_build_hdr(nft_nlmsg_batch_current(),
+	nlh = nft_table_nlmsg_build_hdr(nft_batch_buffer(batch),
 			NFT_MSG_DELTABLE,
 			nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY),
 			NLM_F_ACK, seqnum);
@@ -754,7 +696,7 @@ int mnl_nft_set_batch_add(struct nft_set *nls, unsigned int flags,
 {
 	struct nlmsghdr *nlh;
 
-	nlh = nft_set_nlmsg_build_hdr(nft_nlmsg_batch_current(),
+	nlh = nft_set_nlmsg_build_hdr(nft_batch_buffer(batch),
 			NFT_MSG_NEWSET,
 			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
 			NLM_F_CREATE | flags, seqnum);
@@ -769,7 +711,7 @@ int mnl_nft_set_batch_del(struct nft_set *nls, unsigned int flags,
 {
 	struct nlmsghdr *nlh;
 
-	nlh = nft_set_nlmsg_build_hdr(nft_nlmsg_batch_current(),
+	nlh = nft_set_nlmsg_build_hdr(nft_batch_buffer(batch),
 			NFT_MSG_DELSET,
 			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
 			flags, seqnum);
@@ -920,7 +862,7 @@ int mnl_nft_setelem_batch_add(struct nft_set *nls, unsigned int flags,
 		memory_allocation_error();
 
 	do {
-		nlh = nft_set_elem_nlmsg_build_hdr(nft_nlmsg_batch_current(),
+		nlh = nft_set_elem_nlmsg_build_hdr(nft_batch_buffer(batch),
 				NFT_MSG_NEWSETELEM,
 				nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
 				NLM_F_CREATE | flags, seqnum);
@@ -938,7 +880,7 @@ int mnl_nft_setelem_batch_del(struct nft_set *nls, unsigned int flags,
 {
 	struct nlmsghdr *nlh;
 
-	nlh = nft_set_elem_nlmsg_build_hdr(nft_nlmsg_batch_current(),
+	nlh = nft_set_elem_nlmsg_build_hdr(nft_batch_buffer(batch),
 			NFT_MSG_DELSETELEM,
 			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
 			0, seqnum);
-- 
1.7.10.4

