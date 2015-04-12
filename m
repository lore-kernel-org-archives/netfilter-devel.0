From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 08/10] setelem: add timeout support for set elements
Date: Sun, 12 Apr 2015 13:16:16 +0100
Message-ID: <1428840978-27226-9-git-send-email-kaber@trash.net>
References: <1428840978-27226-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58913 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbbDLMQ2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Apr 2015 08:16:28 -0400
In-Reply-To: <1428840978-27226-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Support specifying per element timeout values and displaying the expiration
time.

If an element should not use the default timeout value of the set, an
element specific value can be specified as follows:

# nft add element filter test { 192.168.0.1, 192.168.0.2 timeout 10m}

For listing of elements that use the default timeout value, just the
expiration time is shown, otherwise the element specific timeout value
is also displayed:

set test {
	type ipv4_addr
	timeout 1h
	elements = { 192.168.0.2 timeout 10m expires 9m59s, 192.168.0.1 expires 59m59s}
}

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/expression.h                |  2 ++
 include/linux/netfilter/nf_tables.h |  4 ++++
 src/expression.c                    |  8 ++++++++
 src/netlink.c                       |  7 +++++++
 src/parser_bison.y                  | 14 ++++++++++++++
 5 files changed, 35 insertions(+)

diff --git a/include/expression.h b/include/expression.h
index d481f28..6f23b6d 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -234,6 +234,8 @@ struct expr {
 		struct {
 			/* EXPR_SET_ELEM */
 			struct expr		*key;
+			uint64_t		timeout;
+			uint64_t		expiration;
 		};
 		struct {
 			/* EXPR_UNARY */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 8671505..6894ba3 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -289,12 +289,16 @@ enum nft_set_elem_flags {
  * @NFTA_SET_ELEM_KEY: key value (NLA_NESTED: nft_data)
  * @NFTA_SET_ELEM_DATA: data value of mapping (NLA_NESTED: nft_data_attributes)
  * @NFTA_SET_ELEM_FLAGS: bitmask of nft_set_elem_flags (NLA_U32)
+ * @NFTA_SET_ELEM_TIMEOUT: timeout value (NLA_U64)
+ * @NFTA_SET_ELEM_EXPIRATION: expiration time (NLA_U64)
  */
 enum nft_set_elem_attributes {
 	NFTA_SET_ELEM_UNSPEC,
 	NFTA_SET_ELEM_KEY,
 	NFTA_SET_ELEM_DATA,
 	NFTA_SET_ELEM_FLAGS,
+	NFTA_SET_ELEM_TIMEOUT,
+	NFTA_SET_ELEM_EXPIRATION,
 	__NFTA_SET_ELEM_MAX
 };
 #define NFTA_SET_ELEM_MAX	(__NFTA_SET_ELEM_MAX - 1)
diff --git a/src/expression.c b/src/expression.c
index 6789396..2037c60 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -889,6 +889,14 @@ struct expr *set_ref_expr_alloc(const struct location *loc, struct set *set)
 static void set_elem_expr_print(const struct expr *expr)
 {
 	expr_print(expr->key);
+	if (expr->timeout) {
+		printf(" timeout ");
+		time_print(expr->timeout / 1000);
+	}
+	if (expr->expiration) {
+		printf(" expires ");
+		time_print(expr->expiration / 1000);
+	}
 }
 
 static void set_elem_expr_destroy(struct expr *expr)
diff --git a/src/netlink.c b/src/netlink.c
index 337d8a1..4de4f47 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -225,6 +225,9 @@ static struct nft_set_elem *alloc_nft_setelem(const struct expr *expr)
 
 	netlink_gen_data(key, &nld);
 	nft_set_elem_attr_set(nlse, NFT_SET_ELEM_ATTR_KEY, &nld.value, nld.len);
+	if (elem->timeout)
+		nft_set_elem_attr_set_u64(nlse, NFT_SET_ELEM_ATTR_TIMEOUT,
+					  elem->timeout);
 
 	if (data != NULL) {
 		netlink_gen_data(data, &nld);
@@ -1125,6 +1128,10 @@ static int netlink_delinearize_setelem(struct nft_set_elem *nlse,
 		key = bitmask_expr_to_binops(key);
 
 	expr = set_elem_expr_alloc(&netlink_location, key);
+	if (nft_set_elem_attr_is_set(nlse, NFT_SET_ELEM_ATTR_TIMEOUT))
+		expr->timeout	 = nft_set_elem_attr_get_u64(nlse, NFT_SET_ELEM_ATTR_TIMEOUT);
+	if (nft_set_elem_attr_is_set(nlse, NFT_SET_ELEM_ATTR_EXPIRATION))
+		expr->expiration = nft_set_elem_attr_get_u64(nlse, NFT_SET_ELEM_ATTR_EXPIRATION);
 
 	if (flags & NFT_SET_ELEM_INTERVAL_END) {
 		expr->flags |= EXPR_F_INTERVAL_END;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 8083187..736704a 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1779,6 +1779,7 @@ set_list_member_expr	:	opt_newline	set_expr	opt_newline
 			;
 
 set_elem_expr		:	set_elem_expr_alloc
+			|	set_elem_expr_alloc		set_elem_options
 			;
 
 set_elem_expr_alloc	:	set_lhs_expr
@@ -1787,6 +1788,19 @@ set_elem_expr_alloc	:	set_lhs_expr
 			}
 			;
 
+set_elem_options	:	set_elem_option
+			{
+				$<expr>$	= $<expr>0;
+			}
+			|	set_elem_options	set_elem_option
+			;
+
+set_elem_option		:	TIMEOUT			time_spec
+			{
+				$<expr>0->timeout = $2 * 1000;
+			}
+			;
+
 set_lhs_expr		:	concat_expr
 			|	multiton_expr
 			;
-- 
2.1.0

