Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F723C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Nov 2021 21:40:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 496306120F
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Nov 2021 21:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbhKDVnJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 17:43:09 -0400
Received: from mail.netfilter.org ([217.70.188.207]:38514 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbhKDVnG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 17:43:06 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 691D76083A
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Nov 2021 22:38:31 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] mnl: do not build nftnl_set element list
Date:   Thu,  4 Nov 2021 22:40:21 +0100
Message-Id: <20211104214021.366663-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211104214021.366663-1-pablo@netfilter.org>
References: <20211104214021.366663-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Do not call alloc_setelem_cache() to build the set element list in
nftnl_set. Instead, translate one single set element expression to
nftnl_set_elem object at a time and use this object to build the netlink
header.

This is reduce userspace memory consumption, using a huge test set
containing 1.1 million element blocklist, this patch is reducing
userspace memory consumption by 40%.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/netlink.h |   2 +
 src/mnl.c         | 112 ++++++++++++++++++++++++++++++++++++----------
 src/netlink.c     |   4 +-
 3 files changed, 93 insertions(+), 25 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 2467ff82a520..c1d7d3189455 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -72,6 +72,8 @@ struct netlink_ctx {
 
 extern struct nftnl_expr *alloc_nft_expr(const char *name);
 extern void alloc_setelem_cache(const struct expr *set, struct nftnl_set *nls);
+struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
+					   const struct expr *expr);
 
 extern struct nftnl_table *netlink_table_alloc(const struct nlmsghdr *nlh);
 extern struct nftnl_chain *netlink_chain_alloc(const struct nlmsghdr *nlh);
diff --git a/src/mnl.c b/src/mnl.c
index 2d5afdfe8c7f..4a10647f9f17 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1518,33 +1518,102 @@ static int set_elem_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-static int mnl_nft_setelem_batch(struct nftnl_set *nls,
+static bool mnl_nft_attr_nest_overflow(struct nlmsghdr *nlh,
+				       const struct nlattr *from,
+				       const struct nlattr *to)
+{
+	int len = (void *)to + to->nla_len - (void *)from;
+
+	/* The attribute length field is 16 bits long, thus the maximum payload
+	 * that an attribute can convey is UINT16_MAX. In case of overflow,
+	 * discard the last attribute that did not fit into the nest.
+	 */
+	if (len > UINT16_MAX) {
+		nlh->nlmsg_len -= to->nla_len;
+		return true;
+	}
+	return false;
+}
+
+static void netlink_dump_setelem(const struct nftnl_set_elem *nlse,
+				 struct netlink_ctx *ctx)
+{
+	FILE *fp = ctx->nft->output.output_fp;
+	char buf[4096];
+
+	if (!(ctx->nft->debug_mask & NFT_DEBUG_NETLINK) || !fp)
+		return;
+
+	nftnl_set_elem_snprintf(buf, sizeof(buf), nlse, NFTNL_OUTPUT_DEFAULT, 0);
+	fprintf(fp, "\t%s", buf);
+}
+
+static void netlink_dump_setelem_done(struct netlink_ctx *ctx)
+{
+	FILE *fp = ctx->nft->output.output_fp;
+
+	if (!(ctx->nft->debug_mask & NFT_DEBUG_NETLINK) || !fp)
+		return;
+
+	fprintf(fp, "\n");
+}
+
+static int mnl_nft_setelem_batch(const struct nftnl_set *nls,
 				 struct nftnl_batch *batch,
 				 enum nf_tables_msg_types cmd,
-				 unsigned int flags, uint32_t seqnum)
+				 unsigned int flags, uint32_t seqnum,
+				 const struct expr *set,
+				 struct netlink_ctx *ctx)
 {
+	struct nlattr *nest1, *nest2;
+	struct nftnl_set_elem *nlse;
 	struct nlmsghdr *nlh;
-	struct nftnl_set_elems_iter *iter;
-	int ret;
-
-	iter = nftnl_set_elems_iter_create(nls);
-	if (iter == NULL)
-		memory_allocation_error();
+	struct expr *expr = NULL;
+	int i = 0;
 
 	if (cmd == NFT_MSG_NEWSETELEM)
 		flags |= NLM_F_CREATE;
 
-	while (nftnl_set_elems_iter_cur(iter)) {
-		nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(batch), cmd,
-					    nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
-					    flags, seqnum);
-		ret = nftnl_set_elems_nlmsg_build_payload_iter(nlh, iter);
-		mnl_nft_batch_continue(batch);
-		if (ret <= 0)
-			break;
+	if (set)
+		expr = list_first_entry(&set->expressions, struct expr, list);
+
+next:
+	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(batch), cmd,
+				    nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
+				    flags, seqnum);
+
+	if (nftnl_set_is_set(nls, NFTNL_SET_TABLE)) {
+                mnl_attr_put_strz(nlh, NFTA_SET_ELEM_LIST_TABLE,
+				  nftnl_set_get_str(nls, NFTNL_SET_TABLE));
+	}
+	if (nftnl_set_is_set(nls, NFTNL_SET_NAME)) {
+		mnl_attr_put_strz(nlh, NFTA_SET_ELEM_LIST_SET,
+				  nftnl_set_get_str(nls, NFTNL_SET_NAME));
 	}
+	if (nftnl_set_is_set(nls, NFTNL_SET_ID)) {
+		mnl_attr_put_u32(nlh, NFTA_SET_ELEM_LIST_SET_ID,
+				 htonl(nftnl_set_get_u32(nls, NFTNL_SET_ID)));
+	}
+
+	if (!set || list_empty(&set->expressions))
+		return 0;
 
-	nftnl_set_elems_iter_destroy(iter);
+	assert(expr);
+	nest1 = mnl_attr_nest_start(nlh, NFTA_SET_ELEM_LIST_ELEMENTS);
+	list_for_each_entry_from(expr, &set->expressions, list) {
+		nlse = alloc_nftnl_setelem(set, expr);
+		nest2 = nftnl_set_elem_nlmsg_build(nlh, nlse, ++i);
+		netlink_dump_setelem(nlse, ctx);
+		nftnl_set_elem_free(nlse);
+		if (mnl_nft_attr_nest_overflow(nlh, nest1, nest2)) {
+			mnl_attr_nest_end(nlh, nest1);
+			mnl_nft_batch_continue(batch);
+			goto next;
+		}
+	}
+	mnl_attr_nest_end(nlh, nest1);
+	mnl_nft_batch_continue(batch);
+	netlink_dump_setelem_done(ctx);
 
 	return 0;
 }
@@ -1569,11 +1638,10 @@ int mnl_nft_setelem_add(struct netlink_ctx *ctx, const struct set *set,
 		nftnl_set_set_u32(nls, NFTNL_SET_DATA_TYPE,
 				  dtype_map_to_kernel(set->data->dtype));
 
-	alloc_setelem_cache(expr, nls);
 	netlink_dump_set(nls, ctx);
 
-	err = mnl_nft_setelem_batch(nls, ctx->batch, NFT_MSG_NEWSETELEM, flags,
-				    ctx->seqnum);
+	err = mnl_nft_setelem_batch(nls, ctx->batch, NFT_MSG_NEWSETELEM,
+				    flags, ctx->seqnum, expr, ctx);
 	nftnl_set_free(nls);
 
 	return err;
@@ -1626,12 +1694,10 @@ int mnl_nft_setelem_del(struct netlink_ctx *ctx, const struct cmd *cmd)
 	else if (h->handle.id)
 		nftnl_set_set_u64(nls, NFTNL_SET_HANDLE, h->handle.id);
 
-	if (cmd->expr)
-		alloc_setelem_cache(cmd->expr, nls);
 	netlink_dump_set(nls, ctx);
 
 	err = mnl_nft_setelem_batch(nls, ctx->batch, NFT_MSG_DELSETELEM, 0,
-				    ctx->seqnum);
+				    ctx->seqnum, cmd->expr, ctx);
 	nftnl_set_free(nls);
 
 	return err;
diff --git a/src/netlink.c b/src/netlink.c
index 28a5514ad873..f63f2bd1bd60 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -100,8 +100,8 @@ struct nftnl_expr *alloc_nft_expr(const char *name)
 void __netlink_gen_data(const struct expr *expr,
 			struct nft_data_linearize *data, bool expand);
 
-static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
-						  const struct expr *expr)
+struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
+					   const struct expr *expr)
 {
 	const struct expr *elem, *data;
 	struct nftnl_set_elem *nlse;
-- 
2.30.2

