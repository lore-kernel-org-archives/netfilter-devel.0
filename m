From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH v2] src: add specific byteorder to the struct proto_hdr_template
Date: Tue, 16 Sep 2014 14:21:19 +0200
Message-ID: <1410870079-11421-1-git-send-email-alvaroneay@gmail.com>
References: <1410278479-25864-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:58521 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbaIPMVZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Sep 2014 08:21:25 -0400
Received: by mail-we0-f179.google.com with SMTP id u56so5559272wes.24
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Sep 2014 05:21:23 -0700 (PDT)
In-Reply-To: <1410278479-25864-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If we try to add a rule like:

nft add rule filter input udp length {55-9999}

nftable shows:

BUG: invalid byte order conversion 0 => 2
nft: src/evaluate.c:153: byteorder_conversion_op: Assertion `0' failed.

Some of the existing payload fields rely on BYTEORDER_INVALID. Therefore, if we
try to convert it in evaluation step, we hit this bug.

This patch allows to add a specific byteorder to the struct proto_hdr_template. If
we create a expression with a invalid byteorder, we will use the byteorder
added to the proto_hdr_template structure.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[Changes in v2]
* Use host endian byteorder in the ether saddr/daddr rules.

[Tested with the rules]
nft add rule ip filter input ip length 10-55 counter
nft add rule ip filter input ip length 55-1000 counter
nft add rule ip filter input udp length {0-100} udp dport 9999 counter
nft add rule ip filter input udp length {100-9999} udp dport 9999 counter
nft add rule bridge filter input ether type 0x0800 counter
nft add rule bridge filter input ether saddr 12:34:56:78.9a:bc counter
nft add rule bridge filter input ether daddr 12:34:56:78:9a:bc counter
Tested with the Ana Rey's tests

 include/proto.h |    5 ++++-
 src/exthdr.c    |    6 +++++-
 src/payload.c   |    2 +-
 src/proto.c     |   11 ++++++++---
 4 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/include/proto.h b/include/proto.h
index bd3701e..cc1f51f 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -2,6 +2,7 @@
 #define NFTABLES_PROTO_H
 
 #include <nftables.h>
+#include <datatype.h>
 #include <linux/netfilter/nf_tables.h>
 
 /**
@@ -38,13 +39,15 @@ struct proto_hdr_template {
 	const struct datatype		*dtype;
 	uint16_t			offset;
 	uint16_t			len;
+	enum byteorder			byteorder;
 	enum nft_meta_keys		meta_key;
 };
 
-#define PROTO_HDR_TEMPLATE(__token, __dtype,  __offset, __len)		\
+#define PROTO_HDR_TEMPLATE(__token, __dtype,  __byteorder, __offset, __len)\
 	{								\
 		.token		= (__token),				\
 		.dtype		= (__dtype),				\
+		.byteorder	= (__byteorder),			\
 		.offset		= (__offset),				\
 		.len		= (__len),				\
 	}
diff --git a/src/exthdr.c b/src/exthdr.c
index a619ecc..9ed0b6a 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -48,7 +48,7 @@ static const struct expr_ops exthdr_expr_ops = {
 };
 
 static const struct proto_hdr_template exthdr_unknown_template =
-	PROTO_HDR_TEMPLATE("unknown", &invalid_type, 0, 0);
+	PROTO_HDR_TEMPLATE("unknown", &invalid_type, BYTEORDER_INVALID, 0, 0);
 
 struct expr *exthdr_expr_alloc(const struct location *loc,
 			       const struct exthdr_desc *desc,
@@ -102,6 +102,7 @@ void exthdr_init_raw(struct expr *expr, uint8_t type,
 
 #define HDR_TEMPLATE(__name, __dtype, __type, __member)			\
 	PROTO_HDR_TEMPLATE(__name, __dtype,				\
+			   BYTEORDER_BIG_ENDIAN,			\
 			   offsetof(__type, __member) * 8,		\
 			   field_sizeof(__type, __member) * 8)
 
@@ -179,10 +180,13 @@ const struct exthdr_desc exthdr_frag = {
 		[FRAGHDR_NEXTHDR]	= FRAG_FIELD("nexthdr", ip6f_nxt, &inet_protocol_type),
 		[FRAGHDR_RESERVED]	= FRAG_FIELD("reserved", ip6f_reserved, &integer_type),
 		[FRAGHDR_FRAG_OFF]	= PROTO_HDR_TEMPLATE("frag-off", &integer_type,
+							  BYTEORDER_BIG_ENDIAN,
 							  16, 13),
 		[FRAGHDR_RESERVED2]	= PROTO_HDR_TEMPLATE("reserved2", &integer_type,
+							  BYTEORDER_BIG_ENDIAN,
 							  29, 2),
 		[FRAGHDR_MFRAGS]	= PROTO_HDR_TEMPLATE("more-fragments", &integer_type,
+							  BYTEORDER_BIG_ENDIAN,
 							  31, 1),
 		[FRAGHDR_ID]		= FRAG_FIELD("id", ip6f_ident, &integer_type),
 	},
diff --git a/src/payload.c b/src/payload.c
index 7297520..a3bbe51 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -117,7 +117,7 @@ struct expr *payload_expr_alloc(const struct location *loc,
 	}
 
 	expr = expr_alloc(loc, &payload_expr_ops, tmpl->dtype,
-			  tmpl->dtype->byteorder, tmpl->len);
+			  tmpl->byteorder, tmpl->len);
 	expr->flags |= flags;
 
 	expr->payload.desc   = desc;
diff --git a/src/proto.c b/src/proto.c
index 15a456a..6eb4bb2 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -38,7 +38,7 @@ const char *proto_base_tokens[] = {
 };
 
 const struct proto_hdr_template proto_unknown_template =
-	PROTO_HDR_TEMPLATE("unknown", &invalid_type, 0, 0);
+	PROTO_HDR_TEMPLATE("unknown", &invalid_type, BYTEORDER_INVALID, 0, 0);
 
 const struct proto_desc proto_unknown = {
 	.name		= "unknown",
@@ -186,13 +186,15 @@ void proto_ctx_update(struct proto_ctx *ctx, enum proto_bases base,
 
 #define HDR_TEMPLATE(__name, __dtype, __type, __member)			\
 	PROTO_HDR_TEMPLATE(__name, __dtype,				\
+			   BYTEORDER_BIG_ENDIAN,			\
 			   offsetof(__type, __member) * 8,		\
 			   field_sizeof(__type, __member) * 8)
 
 #define HDR_FIELD(__name, __struct, __member)				\
 	HDR_TEMPLATE(__name, &integer_type, __struct, __member)
 #define HDR_BITFIELD(__name, __dtype,  __offset, __len)			\
-	PROTO_HDR_TEMPLATE(__name, __dtype, __offset, __len)
+	PROTO_HDR_TEMPLATE(__name, __dtype, BYTEORDER_BIG_ENDIAN,	\
+			   __offset, __len)
 #define HDR_TYPE(__name, __dtype, __struct, __member)			\
 	HDR_TEMPLATE(__name, __dtype, __struct, __member)
 
@@ -785,7 +787,10 @@ const struct datatype ethertype_type = {
 #define ETHHDR_TYPE(__name, __member) \
 	ETHHDR_TEMPLATE(__name, &ethertype_type, __member)
 #define ETHHDR_ADDR(__name, __member) \
-	ETHHDR_TEMPLATE(__name, &etheraddr_type, __member)
+	PROTO_HDR_TEMPLATE(__name, &etheraddr_type,		\
+			   BYTEORDER_HOST_ENDIAN,		\
+			   offsetof(struct ether_header, __member) * 8,	\
+			   field_sizeof(struct ether_header, __member) * 8)
 
 const struct proto_desc proto_eth = {
 	.name		= "ether",
-- 
1.7.10.4

