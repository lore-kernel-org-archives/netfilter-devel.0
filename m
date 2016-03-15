From: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftl 2/3] ct: add label set support
Date: Tue, 15 Mar 2016 17:10:10 +0100
Message-ID: <1458058211-11147-3-git-send-email-fw@strlen.de>
References: <1458058211-11147-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55487 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756392AbcCOQKC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2016 12:10:02 -0400
In-Reply-To: <1458058211-11147-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

label set support is implemented by passing the bit value that we want
to set as a netlink attribute.

So kernel does
priv->set_label_bit = ntohl(nla_get_be32(tb[NFTA_CT_LABEL]));

and then uses
test_and_set_bit(priv->set_label_bit, ct_labels->bits);

to set it in atomic fashion.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/libnftnl/expr.h             |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 src/expr/ct.c                       | 31 +++++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index da6a251..ab5e2ec 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -140,6 +140,7 @@ enum {
 	NFTNL_EXPR_CT_KEY,
 	NFTNL_EXPR_CT_DIR,
 	NFTNL_EXPR_CT_SREG,
+	NFTNL_EXPR_CT_LABEL,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index b5fa7cb..2b41759 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -768,6 +768,7 @@ enum nft_ct_keys {
  * @NFTA_CT_KEY: conntrack data item to load (NLA_U32: nft_ct_keys)
  * @NFTA_CT_DIRECTION: direction in case of directional keys (NLA_U8)
  * @NFTA_CT_SREG: source register (NLA_U32)
+ * @NFTA_CT_LABEL: label bit number to set (NLA_U32)
  */
 enum nft_ct_attributes {
 	NFTA_CT_UNSPEC,
@@ -775,6 +776,7 @@ enum nft_ct_attributes {
 	NFTA_CT_KEY,
 	NFTA_CT_DIRECTION,
 	NFTA_CT_SREG,
+	NFTA_CT_LABEL,
 	__NFTA_CT_MAX
 };
 #define NFTA_CT_MAX		(__NFTA_CT_MAX - 1)
diff --git a/src/expr/ct.c b/src/expr/ct.c
index 4bee6b1..3250300 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -26,6 +26,7 @@ struct nftnl_expr_ct {
 	enum nft_registers	dreg;
 	enum nft_registers	sreg;
 	uint8_t			dir;
+	uint16_t		set_label_bit;
 };
 
 #define IP_CT_DIR_ORIGINAL	0
@@ -54,6 +55,9 @@ nftnl_expr_ct_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_CT_SREG:
 		ct->sreg = *((uint32_t *)data);
 		break;
+	case NFTNL_EXPR_CT_LABEL:
+		ct->set_label_bit = *((uint16_t *)data);
+		break;
 	default:
 		return -1;
 	}
@@ -79,6 +83,9 @@ nftnl_expr_ct_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_CT_SREG:
 		*data_len = sizeof(ct->sreg);
 		return &ct->sreg;
+	case NFTNL_EXPR_CT_LABEL:
+		*data_len = sizeof(ct->set_label_bit);
+		return &ct->set_label_bit;
 	}
 	return NULL;
 }
@@ -95,6 +102,7 @@ static int nftnl_expr_ct_cb(const struct nlattr *attr, void *data)
 	case NFTA_CT_KEY:
 	case NFTA_CT_DREG:
 	case NFTA_CT_SREG:
+	case NFTA_CT_LABEL:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
@@ -121,6 +129,8 @@ nftnl_expr_ct_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
 		mnl_attr_put_u8(nlh, NFTA_CT_DIRECTION, ct->dir);
 	if (e->flags & (1 << NFTNL_EXPR_CT_SREG))
 		mnl_attr_put_u32(nlh, NFTA_CT_SREG, htonl(ct->sreg));
+	if (e->flags & (1 << NFTNL_EXPR_CT_LABEL))
+		mnl_attr_put_u32(nlh, NFTA_CT_LABEL, htonl(ct->set_label_bit));
 }
 
 static int
@@ -148,6 +158,10 @@ nftnl_expr_ct_parse(struct nftnl_expr *e, struct nlattr *attr)
 		ct->dir = mnl_attr_get_u8(tb[NFTA_CT_DIRECTION]);
 		e->flags |= (1 << NFTNL_EXPR_CT_DIR);
 	}
+	if (tb[NFTA_CT_LABEL]) {
+		ct->set_label_bit = ntohl(mnl_attr_get_u32(tb[NFTA_CT_LABEL]));
+		e->flags |= (1 << NFTNL_EXPR_CT_LABEL);
+	}
 
 	return 0;
 }
@@ -224,6 +238,7 @@ static int nftnl_expr_ct_json_parse(struct nftnl_expr *e, json_t *root,
 #ifdef JSON_PARSING
 	const char *key_str, *dir_str;
 	uint32_t reg;
+	uint16_t bit;
 	uint8_t dir;
 	int key;
 
@@ -252,6 +267,9 @@ static int nftnl_expr_ct_json_parse(struct nftnl_expr *e, json_t *root,
 		nftnl_expr_set_u8(e, NFTNL_EXPR_CT_DIR, dir);
 	}
 
+	if (nftnl_jansson_parse_val(root, "label", NFTNL_TYPE_U16, &bit, err) == 0)
+		nftnl_expr_set_u16(e, NFTNL_EXPR_CT_LABEL, bit);
+
 	return 0;
 err:
 	errno = EINVAL;
@@ -270,6 +288,7 @@ static int nftnl_expr_ct_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 	const char *key_str, *dir_str;
 	int key;
 	uint8_t dir;
+	uint16_t bit;
 	uint32_t dreg, sreg;
 
 	if (nftnl_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
@@ -300,6 +319,10 @@ static int nftnl_expr_ct_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 		nftnl_expr_set_u8(e, NFTNL_EXPR_CT_DIR, dir);
 	}
 
+	if (nftnl_mxml_num_parse(tree, "label", MXML_DESCEND_FIRST, 10, &bit,
+				 NFTNL_TYPE_U16, NFTNL_XML_OPT, err) == 0)
+		nftnl_expr_set_u16(e, NFTNL_EXPR_CT_LABEL, bit);
+
 	return 0;
 err:
 	errno = EINVAL;
@@ -324,6 +347,8 @@ nftnl_expr_ct_export(char *buf, size_t size, struct nftnl_expr *e, int type)
 		nftnl_buf_str(&b, type, ctkey2str(ct->key), KEY);
 	if (e->flags & (1 << NFTNL_EXPR_CT_DIR))
 		nftnl_buf_str(&b, type, ctdir2str(ct->dir), DIR);
+	if (e->flags & (1 << NFTNL_EXPR_CT_LABEL))
+		nftnl_buf_u32(&b, type, ct->set_label_bit, NUM);
 
 	return nftnl_buf_done(&b);
 }
@@ -352,6 +377,12 @@ nftnl_expr_ct_snprintf_default(char *buf, size_t size, struct nftnl_expr *e)
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	if (nftnl_expr_is_set(e, NFTNL_EXPR_CT_LABEL)) {
+		ret = snprintf(buf+offset, len, " set %s %u ",
+			       ctkey2str(NFT_CT_LABELS), ct->set_label_bit);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	return offset;
 }
 
-- 
2.4.10

