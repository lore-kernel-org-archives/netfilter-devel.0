Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B7C4C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 17:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237361AbhKXR1e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 12:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237537AbhKXR1R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 12:27:17 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3679BC061756
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 09:24:07 -0800 (PST)
Received: from localhost ([::1]:44880 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mpw05-00018v-Et; Wed, 24 Nov 2021 18:24:05 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 13/15] mnl: Provide libnftnl with set element meta info when dumping
Date:   Wed, 24 Nov 2021 18:22:49 +0100
Message-Id: <20211124172251.11539-14-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124172251.11539-1-phil@nwl.cc>
References: <20211124172251.11539-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

To consistently print set elements' data regs irrespective of host byte
order, libnftnl needs to be provided with data reg sizes and byteorder.

To collect sizes, generalize the population of 'field_len' and
'field_count' fields to non-interval concat keys, too. Perform the same
data collection for target data in maps as well, making use of
'data_len' and 'data_count' fields in set desc.

Collect individual data reg fields' byteorder info on demand by
inspecting the constructed data types of concatenated keys/values.

To pass above data along to nftnl_set_elem_snprintf_desc() when dumping
set elements, pass a pointer to the relevant struct set when calling
mnl_nft_setelem_batch().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/evaluate.c | 16 ++++++----
 src/mnl.c      | 84 ++++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 81 insertions(+), 19 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 983808d65714b..5a875eaf8b17c 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1582,13 +1582,13 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		map = *expr;
 		map->mappings->set->flags |= map->mappings->set->init->set_flags;
 
-		if (map->mappings->set->flags & NFT_SET_INTERVAL &&
-		    map->map->etype == EXPR_CONCAT) {
+		if (map->map->etype == EXPR_CONCAT) {
 			memcpy(&map->mappings->set->desc.field_len, &map->map->field_len,
 			       sizeof(map->mappings->set->desc.field_len));
 			map->mappings->set->desc.field_count = map->map->field_count;
 			map->mappings->flags |= NFT_SET_CONCAT;
 		}
+
 		break;
 	case EXPR_SYMBOL:
 		if (expr_evaluate(ctx, &map->mappings) < 0)
@@ -3974,7 +3974,7 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 						  set->key->dtype, type);
 	}
 
-	if (set->flags & NFT_SET_INTERVAL && set->key->etype == EXPR_CONCAT) {
+	if (set->key->etype == EXPR_CONCAT) {
 		memcpy(&set->desc.field_len, &set->key->field_len,
 		       sizeof(set->desc.field_len));
 		set->desc.field_count = set->key->field_count;
@@ -3986,9 +3986,13 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 			return set_error(ctx, set, "map definition does not "
 					 "specify mapping data type");
 
-		if (set->data->etype == EXPR_CONCAT &&
-		    set_expr_evaluate_concat(ctx, &set->data) < 0)
-			return -1;
+		if (set->data->etype == EXPR_CONCAT) {
+			if (expr_evaluate_concat(ctx, &set->data) < 0)
+				return -1;
+			memcpy(&set->desc.data_len, &set->data->field_len,
+			       sizeof(set->desc.data_len));
+			set->desc.data_count = set->data->field_count;
+		}
 
 		if (set->data->flags & EXPR_F_INTERVAL)
 			set->data->len *= 2;
diff --git a/src/mnl.c b/src/mnl.c
index a3ee32680a77a..5bb6dcad81a09 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1063,6 +1063,44 @@ static void set_key_expression(struct netlink_ctx *ctx,
 /*
  * Set
  */
+
+static uint16_t dtype_byteorder_bits(const struct datatype *dtype,
+				     enum byteorder byteorder)
+{
+	const struct datatype *subtype;
+	uint16_t bits = 0;
+	int n, dsz, i = 0;
+
+	if (dtype->type == TYPE_VERDICT)
+		return 0;
+
+	if (!(dtype->type & ~TYPE_MASK)) {
+		/* XXX: is this right? does set->key->byteorder take
+		 *      precedence over set->key->dtype->byteorder?
+		 *      if not, respect byteorder only if
+		 *      dtype->byteorder == BYTEORDER_INVALID
+		 */
+		if (dtype->byteorder == BYTEORDER_BIG_ENDIAN ||
+		    byteorder == BYTEORDER_BIG_ENDIAN)
+			return -1;
+		return 0;
+	}
+	n = div_round_up(fls(dtype->type), TYPE_BITS);
+	while (n > 0 && concat_subtype_id(dtype->type, --n)) {
+		subtype = concat_subtype_lookup(dtype->type, n);
+		if (!subtype)
+			break;
+
+		for (dsz = subtype->size;
+		     dsz > 0;
+		     dsz -= sizeof(uint32_t) * BITS_PER_BYTE) {
+			bits |= (subtype->byteorder ==
+				 BYTEORDER_BIG_ENDIAN) << i++;
+		}
+	}
+	return bits;
+}
+
 int mnl_nft_set_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		    unsigned int flags)
 {
@@ -1535,16 +1573,36 @@ static bool mnl_nft_attr_nest_overflow(struct nlmsghdr *nlh,
 	return false;
 }
 
-static void netlink_dump_setelem(const struct nftnl_set_elem *nlse,
-				 struct netlink_ctx *ctx)
+static void set_to_desc(struct nftnl_set_desc *desc, const struct set *set)
+{
+	if (!set)
+		return;
+
+	memcpy(desc, &set->desc, sizeof(*desc));
+
+	desc->byteorder = dtype_byteorder_bits(set->key->dtype,
+					       set->key->byteorder);
+
+	if (!set_is_datamap(set->flags))
+		return;
+
+	desc->byteorder |= dtype_byteorder_bits(set->data->dtype,
+						set->data->byteorder) << 16;
+}
+
+static void netlink_dump_setelem(struct nftnl_set_elem *nlse,
+				 struct netlink_ctx *ctx, const struct set *set)
 {
 	FILE *fp = ctx->nft->output.output_fp;
+	struct nftnl_set_desc desc;
 	char buf[4096];
 
 	if (!(ctx->nft->debug_mask & NFT_DEBUG_NETLINK) || !fp)
 		return;
 
-	nftnl_set_elem_snprintf(buf, sizeof(buf), nlse, NFTNL_OUTPUT_DEFAULT, 0);
+	set_to_desc(&desc, set);
+	nftnl_set_elem_snprintf_desc(buf, sizeof(buf), nlse, &desc,
+				     NFTNL_OUTPUT_DEFAULT, 0);
 	fprintf(fp, "\t%s", buf);
 }
 
@@ -1562,8 +1620,8 @@ static int mnl_nft_setelem_batch(const struct nftnl_set *nls,
 				 struct nftnl_batch *batch,
 				 enum nf_tables_msg_types cmd,
 				 unsigned int flags, uint32_t seqnum,
-				 const struct expr *set,
-				 struct netlink_ctx *ctx)
+				 const struct expr *init,
+				 struct netlink_ctx *ctx, const struct set *set)
 {
 	struct nlattr *nest1, *nest2;
 	struct nftnl_set_elem *nlse;
@@ -1574,8 +1632,8 @@ static int mnl_nft_setelem_batch(const struct nftnl_set *nls,
 	if (cmd == NFT_MSG_NEWSETELEM)
 		flags |= NLM_F_CREATE;
 
-	if (set)
-		expr = list_first_entry(&set->expressions, struct expr, list);
+	if (init)
+		expr = list_first_entry(&init->expressions, struct expr, list);
 
 next:
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(batch), cmd,
@@ -1595,15 +1653,15 @@ next:
 				 htonl(nftnl_set_get_u32(nls, NFTNL_SET_ID)));
 	}
 
-	if (!set || list_empty(&set->expressions))
+	if (!init || list_empty(&init->expressions))
 		return 0;
 
 	assert(expr);
 	nest1 = mnl_attr_nest_start(nlh, NFTA_SET_ELEM_LIST_ELEMENTS);
-	list_for_each_entry_from(expr, &set->expressions, list) {
-		nlse = alloc_nftnl_setelem(set, expr);
+	list_for_each_entry_from(expr, &init->expressions, list) {
+		nlse = alloc_nftnl_setelem(init, expr);
 		nest2 = nftnl_set_elem_nlmsg_build(nlh, nlse, ++i);
-		netlink_dump_setelem(nlse, ctx);
+		netlink_dump_setelem(nlse, ctx, set);
 		nftnl_set_elem_free(nlse);
 		if (mnl_nft_attr_nest_overflow(nlh, nest1, nest2)) {
 			mnl_attr_nest_end(nlh, nest1);
@@ -1641,7 +1699,7 @@ int mnl_nft_setelem_add(struct netlink_ctx *ctx, const struct set *set,
 	netlink_dump_set(nls, ctx);
 
 	err = mnl_nft_setelem_batch(nls, ctx->batch, NFT_MSG_NEWSETELEM,
-				    flags, ctx->seqnum, expr, ctx);
+				    flags, ctx->seqnum, expr, ctx, set);
 	nftnl_set_free(nls);
 
 	return err;
@@ -1697,7 +1755,7 @@ int mnl_nft_setelem_del(struct netlink_ctx *ctx, const struct cmd *cmd)
 	netlink_dump_set(nls, ctx);
 
 	err = mnl_nft_setelem_batch(nls, ctx->batch, NFT_MSG_DELSETELEM, 0,
-				    ctx->seqnum, cmd->expr, ctx);
+				    ctx->seqnum, cmd->expr, ctx, cmd->elem.set);
 	nftnl_set_free(nls);
 
 	return err;
-- 
2.33.0

