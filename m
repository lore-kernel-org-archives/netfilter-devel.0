From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] netlink: add netlink specific location
Date: Wed,  5 Feb 2014 19:54:15 +0000
Message-ID: <1391630055-11493-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59591 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaBETyU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 14:54:20 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a netlink_location and use it for error messages instead of internal_location.

internal:0:0-0: Error: Could not add set: Operation not permitted
=>
netlink: Error: Could not add set: Operation not permitted

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/netlink.h         |  3 +++
 src/netlink.c             | 21 +++++++++++++++------
 src/netlink_delinearize.c |  7 +------
 3 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 84b2487..4e3f8aa 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -12,6 +12,9 @@
 
 #include <rule.h>
 
+extern const struct input_descriptor indesc_netlink;
+extern const struct location netlink_location;
+
 /** 
  * struct netlink_ctx
  *
diff --git a/src/netlink.c b/src/netlink.c
index 98e7fc6..6e797dc 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -33,6 +33,15 @@
 
 static struct mnl_socket *nf_sock;
 
+const struct input_descriptor indesc_netlink = {
+	.name	= "netlink",
+	.type	= INDESC_NETLINK,
+};
+
+const struct location netlink_location = {
+	.indesc	= &indesc_netlink,
+};
+
 static void __init netlink_open_sock(void)
 {
 	nf_sock = mnl_socket_open(NETLINK_NETFILTER);
@@ -55,7 +64,7 @@ int netlink_io_error(struct netlink_ctx *ctx, const struct location *loc,
 	va_list ap;
 
 	if (loc == NULL)
-		loc = &internal_location;
+		loc = &netlink_location;
 
 	va_start(ap, fmt);
 	erec = erec_vcreate(EREC_ERROR, loc, fmt, ap);
@@ -848,7 +857,7 @@ static int list_set_cb(struct nft_set *nls, void *arg)
 	} else
 		datatype = NULL;
 
-	set = set_alloc(&internal_location);
+	set = set_alloc(&netlink_location);
 	set->handle.family = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY);
 	set->handle.table  =
 		xstrdup(nft_set_attr_get_str(nls, NFT_SET_ATTR_TABLE));
@@ -899,7 +908,7 @@ int netlink_get_set(struct netlink_ctx *ctx, const struct handle *h,
 					"Could not receive set from kernel: %s",
 					strerror(errno));
 
-	set = set_alloc(&internal_location);
+	set = set_alloc(&netlink_location);
 	set->handle.family = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY);
 	set->handle.table  =
 		xstrdup(nft_set_attr_get_str(nls, NFT_SET_ATTR_TABLE));
@@ -984,7 +993,7 @@ static int list_setelem_cb(struct nft_set_elem *nlse, void *arg)
 	if (nft_set_elem_attr_is_set(nlse, NFT_SET_ELEM_ATTR_FLAGS))
 		flags = nft_set_elem_attr_get_u32(nlse, NFT_SET_ELEM_ATTR_FLAGS);
 
-	expr = netlink_alloc_value(&internal_location, &nld);
+	expr = netlink_alloc_value(&netlink_location, &nld);
 	expr->dtype	= set->keytype;
 	expr->byteorder	= set->keytype->byteorder;
 	if (expr->byteorder == BYTEORDER_HOST_ENDIAN)
@@ -1004,7 +1013,7 @@ static int list_setelem_cb(struct nft_set_elem *nlse, void *arg)
 		} else
 			goto out;
 
-		data = netlink_alloc_data(&internal_location, &nld,
+		data = netlink_alloc_data(&netlink_location, &nld,
 					  set->datatype->type == TYPE_VERDICT ?
 					  NFT_REG_VERDICT : NFT_REG_1);
 		data->dtype = set->datatype;
@@ -1012,7 +1021,7 @@ static int list_setelem_cb(struct nft_set_elem *nlse, void *arg)
 		if (data->byteorder == BYTEORDER_HOST_ENDIAN)
 			mpz_switch_byteorder(data->value, data->len / BITS_PER_BYTE);
 
-		expr = mapping_expr_alloc(&internal_location, expr, data);
+		expr = mapping_expr_alloc(&netlink_location, expr, data);
 	}
 out:
 	compound_expr_add(set->init, expr);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 59b5074..6668308 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -545,11 +545,6 @@ static const struct {
 	{ .name = "queue",	.parse = netlink_parse_queue },
 };
 
-static const struct input_descriptor indesc_netlink = {
-	.name = "netlink",
-	.type  = INDESC_NETLINK,
-};
-
 static int netlink_parse_expr(struct nft_rule_expr *nle, void *arg)
 {
 	const char *type = nft_rule_expr_get_str(nle, NFT_RULE_EXPR_ATTR_NAME);
@@ -878,7 +873,7 @@ struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
 	if (nft_rule_attr_is_set(nlr, NFT_RULE_ATTR_POSITION))
 		h.position = nft_rule_attr_get_u64(nlr, NFT_RULE_ATTR_POSITION);
 
-	pctx->rule = rule_alloc(&internal_location, &h);
+	pctx->rule = rule_alloc(&netlink_location, &h);
 	pctx->table = table_lookup(&h);
 	assert(pctx->table != NULL);
 	nft_rule_expr_foreach((struct nft_rule *)nlr, netlink_parse_expr, pctx);
-- 
1.8.5.3

