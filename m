From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 09/10] setelem: add support for attaching comments to set elements
Date: Sun, 12 Apr 2015 13:16:17 +0100
Message-ID: <1428840978-27226-10-git-send-email-kaber@trash.net>
References: <1428840978-27226-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58918 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbbDLMQ3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Apr 2015 08:16:29 -0400
In-Reply-To: <1428840978-27226-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Syntax:

# nft add element filter test { 192.168.0.1 comment "some host" }

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/expression.h                |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 src/expression.c                    |  3 +++
 src/netlink.c                       | 11 +++++++++++
 src/parser_bison.y                  |  4 ++++
 5 files changed, 21 insertions(+)

diff --git a/include/expression.h b/include/expression.h
index 6f23b6d..010cb95 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -236,6 +236,7 @@ struct expr {
 			struct expr		*key;
 			uint64_t		timeout;
 			uint64_t		expiration;
+			const char		*comment;
 		};
 		struct {
 			/* EXPR_UNARY */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 6894ba3..334b389 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -291,6 +291,7 @@ enum nft_set_elem_flags {
  * @NFTA_SET_ELEM_FLAGS: bitmask of nft_set_elem_flags (NLA_U32)
  * @NFTA_SET_ELEM_TIMEOUT: timeout value (NLA_U64)
  * @NFTA_SET_ELEM_EXPIRATION: expiration time (NLA_U64)
+ * @NFTA_SET_ELEM_USERDATA: user data (NLA_BINARY)
  */
 enum nft_set_elem_attributes {
 	NFTA_SET_ELEM_UNSPEC,
@@ -299,6 +300,7 @@ enum nft_set_elem_attributes {
 	NFTA_SET_ELEM_FLAGS,
 	NFTA_SET_ELEM_TIMEOUT,
 	NFTA_SET_ELEM_EXPIRATION,
+	NFTA_SET_ELEM_USERDATA,
 	__NFTA_SET_ELEM_MAX
 };
 #define NFTA_SET_ELEM_MAX	(__NFTA_SET_ELEM_MAX - 1)
diff --git a/src/expression.c b/src/expression.c
index 2037c60..3edc550 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -897,10 +897,13 @@ static void set_elem_expr_print(const struct expr *expr)
 		printf(" expires ");
 		time_print(expr->expiration / 1000);
 	}
+	if (expr->comment)
+		printf(" comment \"%s\"", expr->comment);
 }
 
 static void set_elem_expr_destroy(struct expr *expr)
 {
+	xfree(expr->comment);
 	expr_free(expr->key);
 }
 
diff --git a/src/netlink.c b/src/netlink.c
index 4de4f47..23403bd 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -228,6 +228,9 @@ static struct nft_set_elem *alloc_nft_setelem(const struct expr *expr)
 	if (elem->timeout)
 		nft_set_elem_attr_set_u64(nlse, NFT_SET_ELEM_ATTR_TIMEOUT,
 					  elem->timeout);
+	if (elem->comment)
+		nft_set_elem_attr_set(nlse, NFT_SET_ELEM_ATTR_USERDATA,
+				      elem->comment, strlen(elem->comment) + 1);
 
 	if (data != NULL) {
 		netlink_gen_data(data, &nld);
@@ -1132,6 +1135,14 @@ static int netlink_delinearize_setelem(struct nft_set_elem *nlse,
 		expr->timeout	 = nft_set_elem_attr_get_u64(nlse, NFT_SET_ELEM_ATTR_TIMEOUT);
 	if (nft_set_elem_attr_is_set(nlse, NFT_SET_ELEM_ATTR_EXPIRATION))
 		expr->expiration = nft_set_elem_attr_get_u64(nlse, NFT_SET_ELEM_ATTR_EXPIRATION);
+	if (nft_set_elem_attr_is_set(nlse, NFT_SET_ELEM_ATTR_USERDATA)) {
+		const void *data;
+		uint32_t len;
+
+		data = nft_set_elem_attr_get(nlse, NFT_SET_ELEM_ATTR_USERDATA, &len);
+		expr->comment = xmalloc(len);
+		memcpy((char *)expr->comment, data, len);
+	}
 
 	if (flags & NFT_SET_ELEM_INTERVAL_END) {
 		expr->flags |= EXPR_F_INTERVAL_END;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 736704a..0f2d71a 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1799,6 +1799,10 @@ set_elem_option		:	TIMEOUT			time_spec
 			{
 				$<expr>0->timeout = $2 * 1000;
 			}
+			|	COMMENT			string
+			{
+				$<expr>0->comment = $2;
+			}
 			;
 
 set_lhs_expr		:	concat_expr
-- 
2.1.0

