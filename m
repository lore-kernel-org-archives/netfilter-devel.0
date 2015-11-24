From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH libnftnl] payload: add payload mangling support
Date: Tue, 24 Nov 2015 12:48:58 +0000
Message-ID: <1448369338-18517-2-git-send-email-kaber@trash.net>
References: <1448369338-18517-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:45589 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753364AbbKXMtD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 07:49:03 -0500
In-Reply-To: <1448369338-18517-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/libnftnl/expr.h             |  6 ++++
 include/linux/netfilter/nf_tables.h | 17 +++++++++++
 src/expr/payload.c                  | 58 ++++++++++++++++++++++++++++++++++---
 3 files changed, 77 insertions(+), 4 deletions(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 4a37581..ab2c5ba 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -43,6 +43,9 @@ enum {
 	NFTNL_EXPR_PAYLOAD_BASE,
 	NFTNL_EXPR_PAYLOAD_OFFSET,
 	NFTNL_EXPR_PAYLOAD_LEN,
+	NFTNL_EXPR_PAYLOAD_SREG,
+	NFTNL_EXPR_PAYLOAD_CSUM_TYPE,
+	NFTNL_EXPR_PAYLOAD_CSUM_OFFSET,
 };
 
 enum {
@@ -218,6 +221,9 @@ enum {
 	NFT_EXPR_PAYLOAD_BASE,
 	NFT_EXPR_PAYLOAD_OFFSET,
 	NFT_EXPR_PAYLOAD_LEN,
+	NFT_EXPR_PAYLOAD_SREG,
+	NFT_EXPR_PAYLOAD_CSUM_TYPE,
+	NFT_EXPR_PAYLOAD_CSUM_OFFSET,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 9796d82..5420c8c 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -598,12 +598,26 @@ enum nft_payload_bases {
 };
 
 /**
+ * enum nft_payload_csum_types - nf_tables payload expression checksum types
+ *
+ * @NFT_PAYLOAD_CSUM_NONE: no checksumming
+ * @NFT_PAYLOAD_CSUM_INET: internet checksum (RFC 791)
+ */
+enum nft_payload_csum_types {
+	NFT_PAYLOAD_CSUM_NONE,
+	NFT_PAYLOAD_CSUM_INET,
+};
+
+/**
  * enum nft_payload_attributes - nf_tables payload expression netlink attributes
  *
  * @NFTA_PAYLOAD_DREG: destination register to load data into (NLA_U32: nft_registers)
  * @NFTA_PAYLOAD_BASE: payload base (NLA_U32: nft_payload_bases)
  * @NFTA_PAYLOAD_OFFSET: payload offset relative to base (NLA_U32)
  * @NFTA_PAYLOAD_LEN: payload length (NLA_U32)
+ * @NFTA_PAYLOAD_SREG: source register to load data from (NLA_U32: nft_registers)
+ * @NFTA_PAYLOAD_CSUM_TYPE: checksum type (NLA_U32)
+ * @NFTA_PAYLOAD_CSUM_OFFSET: checksum offset relative to base (NLA_U32)
  */
 enum nft_payload_attributes {
 	NFTA_PAYLOAD_UNSPEC,
@@ -611,6 +625,9 @@ enum nft_payload_attributes {
 	NFTA_PAYLOAD_BASE,
 	NFTA_PAYLOAD_OFFSET,
 	NFTA_PAYLOAD_LEN,
+	NFTA_PAYLOAD_SREG,
+	NFTA_PAYLOAD_CSUM_TYPE,
+	NFTA_PAYLOAD_CSUM_OFFSET,
 	__NFTA_PAYLOAD_MAX
 };
 #define NFTA_PAYLOAD_MAX	(__NFTA_PAYLOAD_MAX - 1)
diff --git a/src/expr/payload.c b/src/expr/payload.c
index be10663..508f11a 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -25,10 +25,13 @@
 #include <libnftnl/rule.h>
 
 struct nftnl_expr_payload {
+	enum nft_registers	sreg;
 	enum nft_registers	dreg;
 	enum nft_payload_bases	base;
 	uint32_t		offset;
 	uint32_t		len;
+	uint32_t		csum_type;
+	uint32_t		csum_offset;
 };
 
 static int
@@ -38,6 +41,9 @@ nftnl_expr_payload_set(struct nftnl_expr *e, uint16_t type,
 	struct nftnl_expr_payload *payload = nftnl_expr_data(e);
 
 	switch(type) {
+	case NFTNL_EXPR_PAYLOAD_SREG:
+		payload->sreg = *((uint32_t *)data);
+		break;
 	case NFTNL_EXPR_PAYLOAD_DREG:
 		payload->dreg = *((uint32_t *)data);
 		break;
@@ -50,6 +56,12 @@ nftnl_expr_payload_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_PAYLOAD_LEN:
 		payload->len = *((unsigned int *)data);
 		break;
+	case NFTNL_EXPR_PAYLOAD_CSUM_TYPE:
+		payload->csum_type = *((uint32_t *)data);
+		break;
+	case NFTNL_EXPR_PAYLOAD_CSUM_OFFSET:
+		payload->csum_offset = *((uint32_t *)data);
+		break;
 	default:
 		return -1;
 	}
@@ -63,6 +75,9 @@ nftnl_expr_payload_get(const struct nftnl_expr *e, uint16_t type,
 	struct nftnl_expr_payload *payload = nftnl_expr_data(e);
 
 	switch(type) {
+	case NFTNL_EXPR_PAYLOAD_SREG:
+		*data_len = sizeof(payload->sreg);
+		return &payload->sreg;
 	case NFTNL_EXPR_PAYLOAD_DREG:
 		*data_len = sizeof(payload->dreg);
 		return &payload->dreg;
@@ -75,6 +90,12 @@ nftnl_expr_payload_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_PAYLOAD_LEN:
 		*data_len = sizeof(payload->len);
 		return &payload->len;
+	case NFTNL_EXPR_PAYLOAD_CSUM_TYPE:
+		*data_len = sizeof(payload->csum_type);
+		return &payload->csum_type;
+	case NFTNL_EXPR_PAYLOAD_CSUM_OFFSET:
+		*data_len = sizeof(payload->csum_offset);
+		return &payload->csum_offset;
 	}
 	return NULL;
 }
@@ -88,10 +109,13 @@ static int nftnl_expr_payload_cb(const struct nlattr *attr, void *data)
 		return MNL_CB_OK;
 
 	switch(type) {
+	case NFTA_PAYLOAD_SREG:
 	case NFTA_PAYLOAD_DREG:
 	case NFTA_PAYLOAD_BASE:
 	case NFTA_PAYLOAD_OFFSET:
 	case NFTA_PAYLOAD_LEN:
+	case NFTA_PAYLOAD_CSUM_TYPE:
+	case NFTA_PAYLOAD_CSUM_OFFSET:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
@@ -106,6 +130,8 @@ nftnl_expr_payload_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
 {
 	struct nftnl_expr_payload *payload = nftnl_expr_data(e);
 
+	if (e->flags & (1 << NFTNL_EXPR_PAYLOAD_SREG))
+		mnl_attr_put_u32(nlh, NFTA_PAYLOAD_SREG, htonl(payload->sreg));
 	if (e->flags & (1 << NFTNL_EXPR_PAYLOAD_DREG))
 		mnl_attr_put_u32(nlh, NFTA_PAYLOAD_DREG, htonl(payload->dreg));
 	if (e->flags & (1 << NFTNL_EXPR_PAYLOAD_BASE))
@@ -114,6 +140,12 @@ nftnl_expr_payload_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
 		mnl_attr_put_u32(nlh, NFTA_PAYLOAD_OFFSET, htonl(payload->offset));
 	if (e->flags & (1 << NFTNL_EXPR_PAYLOAD_LEN))
 		mnl_attr_put_u32(nlh, NFTA_PAYLOAD_LEN, htonl(payload->len));
+	if (e->flags & (1 << NFTNL_EXPR_PAYLOAD_CSUM_TYPE))
+		mnl_attr_put_u32(nlh, NFTA_PAYLOAD_CSUM_TYPE,
+				 htonl(payload->csum_type));
+	if (e->flags & (1 << NFTNL_EXPR_PAYLOAD_CSUM_OFFSET))
+		mnl_attr_put_u32(nlh, NFTA_PAYLOAD_CSUM_OFFSET,
+				 htonl(payload->csum_offset));
 }
 
 static int
@@ -125,6 +157,10 @@ nftnl_expr_payload_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_payload_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_PAYLOAD_SREG]) {
+		payload->sreg = ntohl(mnl_attr_get_u32(tb[NFTA_PAYLOAD_SREG]));
+		e->flags |= (1 << NFT_EXPR_PAYLOAD_SREG);
+	}
 	if (tb[NFTA_PAYLOAD_DREG]) {
 		payload->dreg = ntohl(mnl_attr_get_u32(tb[NFTA_PAYLOAD_DREG]));
 		e->flags |= (1 << NFTNL_EXPR_PAYLOAD_DREG);
@@ -141,7 +177,14 @@ nftnl_expr_payload_parse(struct nftnl_expr *e, struct nlattr *attr)
 		payload->len = ntohl(mnl_attr_get_u32(tb[NFTA_PAYLOAD_LEN]));
 		e->flags |= (1 << NFTNL_EXPR_PAYLOAD_LEN);
 	}
-
+	if (tb[NFTA_PAYLOAD_CSUM_TYPE]) {
+		payload->csum_type = ntohl(mnl_attr_get_u32(tb[NFTA_PAYLOAD_CSUM_TYPE]));
+		e->flags |= (1 << NFTNL_EXPR_PAYLOAD_CSUM_TYPE);
+	}
+	if (tb[NFTA_PAYLOAD_CSUM_OFFSET]) {
+		payload->csum_offset = ntohl(mnl_attr_get_u32(tb[NFTA_PAYLOAD_CSUM_OFFSET]));
+		e->flags |= (1 << NFTNL_EXPR_PAYLOAD_CSUM_OFFSET);
+	}
 	return 0;
 }
 
@@ -273,9 +316,16 @@ nftnl_expr_payload_snprintf(char *buf, size_t len, uint32_t type,
 
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		return snprintf(buf, len, "load %ub @ %s header + %u => reg %u ",
-				payload->len, base2str(payload->base),
-				payload->offset, payload->dreg);
+		if (payload->sreg)
+			return snprintf(buf, len, "write reg %u => %ub @ %s header + %u csum_type %u csum_off %u ",
+					payload->sreg,
+					payload->len, base2str(payload->base),
+					payload->offset, payload->csum_type,
+					payload->csum_offset);
+		else
+			return snprintf(buf, len, "load %ub @ %s header + %u => reg %u ",
+					payload->len, base2str(payload->base),
+					payload->offset, payload->dreg);
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
 		return nftnl_expr_payload_export(buf, len, flags, e, type);
-- 
2.5.0

