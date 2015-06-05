From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 9/9] netlink: handle concat expressions in set data
Date: Fri,  5 Jun 2015 15:42:51 +0200
Message-ID: <1433511771-4620-10-git-send-email-kaber@trash.net>
References: <1433511771-4620-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59950 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbbFENm4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 09:42:56 -0400
In-Reply-To: <1433511771-4620-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Reconstruct the concat expressions in set data by splicing off the
subtype values based on the keytype of the set.

Signed-off-by: Patrick McHardy
---
 src/datatype.c |  2 +-
 src/netlink.c  | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/src/datatype.c b/src/datatype.c
index a06a58e..ca83426 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -932,7 +932,7 @@ const struct datatype *concat_type_alloc(uint32_t type)
 	unsigned int size = 0, subtypes = 0, n;
 
 	n = div_round_up(fls(type), TYPE_BITS);
-	while (concat_subtype_id(type, --n)) {
+	while (n > 0 && concat_subtype_id(type, --n)) {
 		i = concat_subtype_lookup(type, n);
 		if (i == NULL)
 			return NULL;
diff --git a/src/netlink.c b/src/netlink.c
index 3369d22..1167c95 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1383,6 +1383,36 @@ static int netlink_del_setelems_compat(struct netlink_ctx *ctx,
 	return err;
 }
 
+static struct expr *netlink_parse_concat_elem(const struct datatype *dtype,
+					      struct expr *data)
+{
+	const struct datatype *subtype;
+	struct expr *concat, *expr;
+	int off = dtype->subtypes;
+
+	concat = concat_expr_alloc(&data->location);
+	while (off > 0) {
+		subtype = concat_subtype_lookup(dtype->type, --off);
+
+		expr		= constant_expr_splice(data, subtype->size);
+		expr->dtype     = subtype;
+		expr->byteorder = subtype->byteorder;
+
+		if (expr->byteorder == BYTEORDER_HOST_ENDIAN)
+			mpz_switch_byteorder(expr->value, expr->len / BITS_PER_BYTE);
+
+		if (expr->dtype->basetype != NULL &&
+		    expr->dtype->basetype->type == TYPE_BITMASK)
+			expr = bitmask_expr_to_binops(expr);
+
+		compound_expr_add(concat, expr);
+		data->len -= netlink_padding_len(expr->len);
+	}
+	expr_free(data);
+
+	return concat;
+}
+
 static int netlink_delinearize_setelem(struct nft_set_elem *nlse,
 				       struct set *set)
 {
@@ -1398,6 +1428,8 @@ static int netlink_delinearize_setelem(struct nft_set_elem *nlse,
 	key = netlink_alloc_value(&netlink_location, &nld);
 	key->dtype	= set->keytype;
 	key->byteorder	= set->keytype->byteorder;
+	if (set->keytype->subtypes)
+		key = netlink_parse_concat_elem(set->keytype, key);
 
 	if (!(set->flags & SET_F_INTERVAL) &&
 	    key->byteorder == BYTEORDER_HOST_ENDIAN)
-- 
2.1.0

