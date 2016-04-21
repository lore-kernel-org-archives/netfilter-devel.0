From: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl 3/4] ct: add connlabel set support
Date: Thu, 21 Apr 2016 16:34:43 +0200
Message-ID: <1461249284-12114-4-git-send-email-fw@strlen.de>
References: <1461249284-12114-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54973 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751920AbcDUOef (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Apr 2016 10:34:35 -0400
In-Reply-To: <1461249284-12114-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

label set support is implemented by passing the bit value in a
nftnl_data_reg rather than using an sreg.

The advantage is that the kernel can use set_bit() api to toggle a
connlabel bit rather than having to set the entire label area in the
conntrack based on register contents.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/libnftnl/expr.h             |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 src/expr/ct.c                       | 48 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index da6a251..d4dccb1 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -140,6 +140,7 @@ enum {
 	NFTNL_EXPR_CT_KEY,
 	NFTNL_EXPR_CT_DIR,
 	NFTNL_EXPR_CT_SREG,
+	NFTNL_EXPR_CT_IMM,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index b5fa7cb..e9cf806 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -768,6 +768,7 @@ enum nft_ct_keys {
  * @NFTA_CT_KEY: conntrack data item to load (NLA_U32: nft_ct_keys)
  * @NFTA_CT_DIRECTION: direction in case of directional keys (NLA_U8)
  * @NFTA_CT_SREG: source register (NLA_U32)
+ * @NFTA_CT_IMM: immediate value (NLA_NESTED)
  */
 enum nft_ct_attributes {
 	NFTA_CT_UNSPEC,
@@ -775,6 +776,7 @@ enum nft_ct_attributes {
 	NFTA_CT_KEY,
 	NFTA_CT_DIRECTION,
 	NFTA_CT_SREG,
+	NFTA_CT_IMM,
 	__NFTA_CT_MAX
 };
 #define NFTA_CT_MAX		(__NFTA_CT_MAX - 1)
diff --git a/src/expr/ct.c b/src/expr/ct.c
index a38f40c..8fb13b9 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -26,6 +26,7 @@ struct nftnl_expr_ct {
 	enum nft_registers	dreg;
 	enum nft_registers	sreg;
 	uint8_t			dir;
+	union nftnl_data_reg	imm;
 };
 
 #define IP_CT_DIR_ORIGINAL	0
@@ -54,6 +55,10 @@ nftnl_expr_ct_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_CT_SREG:
 		ct->sreg = *((uint32_t *)data);
 		break;
+	case NFTNL_EXPR_CT_IMM:
+		memcpy(&ct->imm.val, data, data_len);
+		ct->imm.len = data_len;
+		break;
 	default:
 		return -1;
 	}
@@ -79,6 +84,9 @@ nftnl_expr_ct_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_CT_SREG:
 		*data_len = sizeof(ct->sreg);
 		return &ct->sreg;
+	case NFTNL_EXPR_CT_IMM:
+		*data_len = ct->imm.len;
+		return &ct->imm.val;
 	}
 	return NULL;
 }
@@ -102,6 +110,10 @@ static int nftnl_expr_ct_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
 			abi_breakage();
 		break;
+	case NFTA_CT_IMM:
+		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
+			abi_breakage();
+		break;
 	}
 
 	tb[type] = attr;
@@ -121,6 +133,13 @@ nftnl_expr_ct_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
 		mnl_attr_put_u8(nlh, NFTA_CT_DIRECTION, ct->dir);
 	if (e->flags & (1 << NFTNL_EXPR_CT_SREG))
 		mnl_attr_put_u32(nlh, NFTA_CT_SREG, htonl(ct->sreg));
+	if (e->flags & (1 << NFTNL_EXPR_CT_IMM)) {
+		struct nlattr *nest;
+
+		nest = mnl_attr_nest_start(nlh, NFTA_CT_IMM);
+		mnl_attr_put(nlh, NFTA_DATA_VALUE, ct->imm.len, ct->imm.val);
+		mnl_attr_nest_end(nlh, nest);
+	}
 }
 
 static int
@@ -128,6 +147,7 @@ nftnl_expr_ct_parse(struct nftnl_expr *e, struct nlattr *attr)
 {
 	struct nftnl_expr_ct *ct = nftnl_expr_data(e);
 	struct nlattr *tb[NFTA_CT_MAX+1] = {};
+	int ret = 0;
 
 	if (mnl_attr_parse_nested(attr, nftnl_expr_ct_cb, tb) < 0)
 		return -1;
@@ -148,8 +168,12 @@ nftnl_expr_ct_parse(struct nftnl_expr *e, struct nlattr *attr)
 		ct->dir = mnl_attr_get_u8(tb[NFTA_CT_DIRECTION]);
 		e->flags |= (1 << NFTNL_EXPR_CT_DIR);
 	}
+	if (tb[NFTA_CT_IMM]) {
+		ret = nftnl_parse_data(&ct->imm, tb[NFTA_CT_IMM], NULL);
+		e->flags |= (1 << NFTNL_EXPR_CT_IMM);
+	}
 
-	return 0;
+	return ret;
 }
 
 const char *ctkey2str_array[NFT_CT_MAX] = {
@@ -224,6 +248,7 @@ static int nftnl_expr_ct_json_parse(struct nftnl_expr *e, json_t *root,
 #ifdef JSON_PARSING
 	const char *key_str, *dir_str;
 	uint32_t reg;
+	uint16_t bit;
 	uint8_t dir;
 	int key;
 
@@ -252,6 +277,10 @@ static int nftnl_expr_ct_json_parse(struct nftnl_expr *e, json_t *root,
 		nftnl_expr_set_u8(e, NFTNL_EXPR_CT_DIR, dir);
 	}
 
+	if (nftnl_jansson_data_reg_parse(root, "imm", &ct->imm,
+				       err) == DATA_VALUE)
+		e->flags |= (1 << NFTNL_EXPR_CT_IMM);
+
 	return 0;
 err:
 	errno = EINVAL;
@@ -270,6 +299,7 @@ static int nftnl_expr_ct_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 	const char *key_str, *dir_str;
 	int key;
 	uint8_t dir;
+	uint16_t bit;
 	uint32_t dreg, sreg;
 
 	if (nftnl_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
@@ -300,6 +330,10 @@ static int nftnl_expr_ct_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 		nftnl_expr_set_u8(e, NFTNL_EXPR_CT_DIR, dir);
 	}
 
+	if (nftnl_mxml_data_reg_parse(tree, "imm", &ct->imm, NFTNL_XML_OPT,
+				    err) == DATA_VALUE)
+		e->flags |= (1 << NFTNL_EXPR_CT_IMM);
+
 	return 0;
 err:
 	errno = EINVAL;
@@ -324,6 +358,8 @@ nftnl_expr_ct_export(char *buf, size_t size, struct nftnl_expr *e, int type)
 		nftnl_buf_str(&b, type, ctkey2str(ct->key), KEY);
 	if (e->flags & (1 << NFTNL_EXPR_CT_DIR))
 		nftnl_buf_str(&b, type, ctdir2str(ct->dir), DIR);
+	if (e->flags & (1 << NFTNL_EXPR_CT_IMM))
+		nftnl_buf_reg(&b, type, &ct->imm, DATA_VALUE, DATA);
 
 	return nftnl_buf_done(&b);
 }
@@ -340,6 +376,16 @@ nftnl_expr_ct_snprintf_default(char *buf, size_t size, struct nftnl_expr *e)
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	if (nftnl_expr_is_set(e, NFTNL_EXPR_CT_IMM)) {
+		ret = snprintf(buf, size, "set %s with imm ",
+				ctkey2str(ct->key));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		ret = nftnl_data_reg_snprintf(buf+offset, len, &ct->imm,
+					      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	if (e->flags & (1 << NFTNL_EXPR_CT_DREG)) {
 		ret = snprintf(buf, len, "load %s => reg %u ",
 			       ctkey2str(ct->key), ct->dreg);
-- 
2.7.3

