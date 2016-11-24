From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2 libnftnl] expr: payload: add NFTNL_EXPR_PAYLOAD_FLAGS
Date: Thu, 24 Nov 2016 12:08:52 +0100
Message-ID: <1479985732-6104-2-git-send-email-pablo@netfilter.org>
References: <1479985732-6104-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45308 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937926AbcKXLJI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 06:09:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7D7EB16B283
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 12:08:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C3D5DA3AC
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 12:08:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 490A6DA38C
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 12:08:57 +0100 (CET)
In-Reply-To: <1479985732-6104-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So we can include the new NFT_PAYLOAD_L4CSUM_PSEUDOHDR flag.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/expr.h             |  1 +
 include/linux/netfilter/nf_tables.h |  6 ++++++
 src/expr/payload.c                  | 22 ++++++++++++++++++++--
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index edf86a966fc0..c4a6d53a3559 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -48,6 +48,7 @@ enum {
 	NFTNL_EXPR_PAYLOAD_SREG,
 	NFTNL_EXPR_PAYLOAD_CSUM_TYPE,
 	NFTNL_EXPR_PAYLOAD_CSUM_OFFSET,
+	NFTNL_EXPR_PAYLOAD_FLAGS,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 14e5f619167e..f030e59aa2ec 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -659,6 +659,10 @@ enum nft_payload_csum_types {
 	NFT_PAYLOAD_CSUM_INET,
 };
 
+enum nft_payload_csum_flags {
+	NFT_PAYLOAD_L4CSUM_PSEUDOHDR = (1 << 0),
+};
+
 /**
  * enum nft_payload_attributes - nf_tables payload expression netlink attributes
  *
@@ -669,6 +673,7 @@ enum nft_payload_csum_types {
  * @NFTA_PAYLOAD_SREG: source register to load data from (NLA_U32: nft_registers)
  * @NFTA_PAYLOAD_CSUM_TYPE: checksum type (NLA_U32)
  * @NFTA_PAYLOAD_CSUM_OFFSET: checksum offset relative to base (NLA_U32)
+ * @NFTA_PAYLOAD_CSUM_FLAGS: checksum flags (NLA_U32)
  */
 enum nft_payload_attributes {
 	NFTA_PAYLOAD_UNSPEC,
@@ -679,6 +684,7 @@ enum nft_payload_attributes {
 	NFTA_PAYLOAD_SREG,
 	NFTA_PAYLOAD_CSUM_TYPE,
 	NFTA_PAYLOAD_CSUM_OFFSET,
+	NFTA_PAYLOAD_CSUM_FLAGS,
 	__NFTA_PAYLOAD_MAX
 };
 #define NFTA_PAYLOAD_MAX	(__NFTA_PAYLOAD_MAX - 1)
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 17dd4cd6409b..d65585711bd1 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -32,6 +32,7 @@ struct nftnl_expr_payload {
 	uint32_t		len;
 	uint32_t		csum_type;
 	uint32_t		csum_offset;
+	uint32_t		csum_flags;
 };
 
 static int
@@ -62,6 +63,9 @@ nftnl_expr_payload_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_PAYLOAD_CSUM_OFFSET:
 		payload->csum_offset = *((uint32_t *)data);
 		break;
+	case NFTNL_EXPR_PAYLOAD_FLAGS:
+		payload->csum_flags = *((uint32_t *)data);
+		break;
 	default:
 		return -1;
 	}
@@ -96,6 +100,9 @@ nftnl_expr_payload_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_PAYLOAD_CSUM_OFFSET:
 		*data_len = sizeof(payload->csum_offset);
 		return &payload->csum_offset;
+	case NFTNL_EXPR_PAYLOAD_FLAGS:
+		*data_len = sizeof(payload->csum_flags);
+		return &payload->csum_flags;
 	}
 	return NULL;
 }
@@ -116,6 +123,7 @@ static int nftnl_expr_payload_cb(const struct nlattr *attr, void *data)
 	case NFTA_PAYLOAD_LEN:
 	case NFTA_PAYLOAD_CSUM_TYPE:
 	case NFTA_PAYLOAD_CSUM_OFFSET:
+	case NFTA_PAYLOAD_CSUM_FLAGS:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
@@ -146,6 +154,9 @@ nftnl_expr_payload_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 	if (e->flags & (1 << NFTNL_EXPR_PAYLOAD_CSUM_OFFSET))
 		mnl_attr_put_u32(nlh, NFTA_PAYLOAD_CSUM_OFFSET,
 				 htonl(payload->csum_offset));
+	if (e->flags & (1 << NFTNL_EXPR_PAYLOAD_FLAGS))
+		mnl_attr_put_u32(nlh, NFTA_PAYLOAD_CSUM_FLAGS,
+				 htonl(payload->csum_flags));
 }
 
 static int
@@ -185,6 +196,10 @@ nftnl_expr_payload_parse(struct nftnl_expr *e, struct nlattr *attr)
 		payload->csum_offset = ntohl(mnl_attr_get_u32(tb[NFTA_PAYLOAD_CSUM_OFFSET]));
 		e->flags |= (1 << NFTNL_EXPR_PAYLOAD_CSUM_OFFSET);
 	}
+	if (tb[NFTA_PAYLOAD_CSUM_FLAGS]) {
+		payload->csum_flags = ntohl(mnl_attr_get_u32(tb[NFTA_PAYLOAD_CSUM_FLAGS]));
+		e->flags |= (1 << NFTNL_EXPR_PAYLOAD_FLAGS);
+	}
 	return 0;
 }
 
@@ -278,11 +293,12 @@ nftnl_expr_payload_snprintf(char *buf, size_t len, uint32_t type,
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		if (payload->sreg)
-			return snprintf(buf, len, "write reg %u => %ub @ %s header + %u csum_type %u csum_off %u ",
+			return snprintf(buf, len, "write reg %u => %ub @ %s header + %u csum_type %u csum_off %u csum_flags 0x%x ",
 					payload->sreg,
 					payload->len, base2str(payload->base),
 					payload->offset, payload->csum_type,
-					payload->csum_offset);
+					payload->csum_offset,
+					payload->csum_flags);
 		else
 			return snprintf(buf, len, "load %ub @ %s header + %u => reg %u ",
 					payload->len, base2str(payload->base),
@@ -317,6 +333,8 @@ static bool nftnl_expr_payload_cmp(const struct nftnl_expr *e1,
 		eq &= (p1->csum_type == p2->csum_type);
 	if (e1->flags & (1 << NFTNL_EXPR_PAYLOAD_CSUM_OFFSET))
 		eq &= (p1->csum_offset == p2->csum_offset);
+	if (e1->flags & (1 << NFTNL_EXPR_PAYLOAD_FLAGS))
+		eq &= (p1->csum_flags == p2->csum_flags);
 
 	return eq;
 }
-- 
2.1.4

