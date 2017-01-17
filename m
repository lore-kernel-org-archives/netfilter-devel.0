From: Phil Sutter <phil@nwl.cc>
Subject: [libnftnl PATCH] exthdr: Add support for exthdr flags
Date: Tue, 17 Jan 2017 22:55:00 +0100
Message-ID: <20170117215500.13706-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:59929 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751025AbdAQVwR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Jan 2017 16:52:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Along with the actual support for exthdr expression specific flags, this
also declares NFT_EXTHDR_F_PRESENT used for exthdr existence match.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/libnftnl/expr.h             |  1 +
 include/linux/netfilter/nf_tables.h |  6 ++++++
 src/expr/exthdr.c                   | 21 +++++++++++++++++++++
 3 files changed, 28 insertions(+)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 74e986de6b4b2..654d2bb95142c 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -156,6 +156,7 @@ enum {
 	NFTNL_EXPR_EXTHDR_TYPE,
 	NFTNL_EXPR_EXTHDR_OFFSET,
 	NFTNL_EXPR_EXTHDR_LEN,
+	NFTNL_EXPR_EXTHDR_FLAGS,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 881d49e945696..787955c7d5ed5 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -704,6 +704,10 @@ enum nft_payload_attributes {
 };
 #define NFTA_PAYLOAD_MAX	(__NFTA_PAYLOAD_MAX - 1)
 
+enum nft_exthdr_flags {
+	NFT_EXTHDR_F_PRESENT = (1 << 0),
+};
+
 /**
  * enum nft_exthdr_attributes - nf_tables IPv6 extension header expression netlink attributes
  *
@@ -711,6 +715,7 @@ enum nft_payload_attributes {
  * @NFTA_EXTHDR_TYPE: extension header type (NLA_U8)
  * @NFTA_EXTHDR_OFFSET: extension header offset (NLA_U32)
  * @NFTA_EXTHDR_LEN: extension header length (NLA_U32)
+ * @NFTA_EXTHDR_FLAGS: extension header flags (NLA_U32)
  */
 enum nft_exthdr_attributes {
 	NFTA_EXTHDR_UNSPEC,
@@ -718,6 +723,7 @@ enum nft_exthdr_attributes {
 	NFTA_EXTHDR_TYPE,
 	NFTA_EXTHDR_OFFSET,
 	NFTA_EXTHDR_LEN,
+	NFTA_EXTHDR_FLAGS,
 	__NFTA_EXTHDR_MAX
 };
 #define NFTA_EXTHDR_MAX		(__NFTA_EXTHDR_MAX - 1)
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index b164e3fba3de4..90362a54554d0 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -33,6 +33,7 @@ struct nftnl_expr_exthdr {
 	uint32_t		offset;
 	uint32_t		len;
 	uint8_t			type;
+	uint32_t		flags;
 };
 
 static int
@@ -54,6 +55,9 @@ nftnl_expr_exthdr_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_EXTHDR_LEN:
 		exthdr->len = *((uint32_t *)data);
 		break;
+	case NFTNL_EXPR_EXTHDR_FLAGS:
+		exthdr->flags = *((uint32_t *)data);
+		break;
 	default:
 		return -1;
 	}
@@ -79,6 +83,9 @@ nftnl_expr_exthdr_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_EXTHDR_LEN:
 		*data_len = sizeof(exthdr->len);
 		return &exthdr->len;
+	case NFTNL_EXPR_EXTHDR_FLAGS:
+		*data_len = sizeof(exthdr->flags);
+		return &exthdr->flags;
 	}
 	return NULL;
 }
@@ -99,6 +106,7 @@ static int nftnl_expr_exthdr_cb(const struct nlattr *attr, void *data)
 	case NFTA_EXTHDR_DREG:
 	case NFTA_EXTHDR_OFFSET:
 	case NFTA_EXTHDR_LEN:
+	case NFTA_EXTHDR_FLAGS:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
@@ -121,6 +129,8 @@ nftnl_expr_exthdr_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 		mnl_attr_put_u32(nlh, NFTA_EXTHDR_OFFSET, htonl(exthdr->offset));
 	if (e->flags & (1 << NFTNL_EXPR_EXTHDR_LEN))
 		mnl_attr_put_u32(nlh, NFTA_EXTHDR_LEN, htonl(exthdr->len));
+	if (e->flags & (1 << NFTNL_EXPR_EXTHDR_FLAGS))
+		mnl_attr_put_u32(nlh, NFTA_EXTHDR_FLAGS, htonl(exthdr->flags));
 }
 
 static int
@@ -148,6 +158,10 @@ nftnl_expr_exthdr_parse(struct nftnl_expr *e, struct nlattr *attr)
 		exthdr->len = ntohl(mnl_attr_get_u32(tb[NFTA_EXTHDR_LEN]));
 		e->flags |= (1 << NFTNL_EXPR_EXTHDR_LEN);
 	}
+	if (tb[NFTA_EXTHDR_FLAGS]) {
+		exthdr->flags = ntohl(mnl_attr_get_u32(tb[NFTA_EXTHDR_FLAGS]));
+		e->flags |= (1 << NFTNL_EXPR_EXTHDR_FLAGS);
+	}
 
 	return 0;
 }
@@ -214,6 +228,9 @@ nftnl_expr_exthdr_json_parse(struct nftnl_expr *e, json_t *root,
 	if (nftnl_jansson_parse_val(root, "len", NFTNL_TYPE_U32, &uval32, err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_EXTHDR_LEN, uval32);
 
+	if (nftnl_jansson_parse_val(root, "flags", NFTNL_TYPE_U32, &uval32, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_EXTHDR_FLAGS, uval32);
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -235,6 +252,8 @@ static int nftnl_expr_exthdr_export(char *buf, size_t len,
 		nftnl_buf_u32(&b, type, exthdr->offset, OFFSET);
 	if (e->flags & (1 << NFTNL_EXPR_EXTHDR_LEN))
 		nftnl_buf_u32(&b, type, exthdr->len, LEN);
+	if (e->flags & (1 << NFTNL_EXPR_EXTHDR_FLAGS))
+		nftnl_buf_u32(&b, type, exthdr->flags, FLAGS);
 
 	return nftnl_buf_done(&b);
 }
@@ -280,6 +299,8 @@ static bool nftnl_expr_exthdr_cmp(const struct nftnl_expr *e1,
 		eq &= (h1->len == h2->len);
 	if (e1->flags & (1 << NFTNL_EXPR_EXTHDR_TYPE))
 		eq &= (h1->type == h2->type);
+	if (e1->flags & (1 << NFTNL_EXPR_EXTHDR_FLAGS))
+		eq &= (h1->flags == h2->flags);
 
 	return eq;
 }
-- 
2.11.0

