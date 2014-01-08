From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 10/12] proto: add support for meta templates
Date: Wed,  8 Jan 2014 13:09:01 +0000
Message-ID: <1389186543-6919-11-git-send-email-kaber@trash.net>
References: <1389186543-6919-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40201 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008AbaAHNJW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:09:22 -0500
In-Reply-To: <1389186543-6919-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following two patches will add two new meta expression types that are
used as dependencies in the inet table. To reuse the existing dependency
generation code, add a slightly hackish way to specify meta expressions
as payload dependencies.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/proto.h | 11 +++++++++++
 src/payload.c   |  6 +++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/proto.h b/include/proto.h
index de58d4c..6a28036 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -2,6 +2,7 @@
 #define NFTABLES_PROTO_H
 
 #include <nftables.h>
+#include <linux/netfilter/nf_tables.h>
 
 /**
  * enum proto_bases - protocol bases
@@ -30,12 +31,14 @@ extern const char *proto_base_tokens[];
  * @dtype:	data type of the header field
  * @offset:	offset of the header field from base
  * @len:	length of header field
+ * @meta_key:	special case: meta expression key
  */
 struct proto_hdr_template {
 	const char			*token;
 	const struct datatype		*dtype;
 	uint16_t			offset;
 	uint16_t			len;
+	enum nft_meta_keys		meta_key;
 };
 
 #define PROTO_HDR_TEMPLATE(__token, __dtype,  __offset, __len)		\
@@ -46,6 +49,14 @@ struct proto_hdr_template {
 		.len		= (__len),				\
 	}
 
+#define PROTO_META_TEMPLATE(__token, __dtype, __key, __len)		\
+	{								\
+		.token		= (__token),				\
+		.dtype		= (__dtype),				\
+		.meta_key	= (__key),				\
+		.len		= (__len),				\
+	}
+
 #define PROTO_UPPER_MAX		16
 #define PROTO_HDRS_MAX		20
 
diff --git a/src/payload.c b/src/payload.c
index 0ef3c79..04a3455 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -187,7 +187,11 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 				  desc->name, expr->payload.desc->name);
 
 	tmpl = &desc->templates[desc->protocol_key];
-	left = payload_expr_alloc(&expr->location, desc, desc->protocol_key);
+	if (tmpl->meta_key)
+		left = meta_expr_alloc(&expr->location, tmpl->meta_key);
+	else
+		left = payload_expr_alloc(&expr->location, desc, desc->protocol_key);
+
 	right = constant_expr_alloc(&expr->location, tmpl->dtype,
 				    BYTEORDER_HOST_ENDIAN,
 				    tmpl->len, &protocol);
-- 
1.8.4.2

