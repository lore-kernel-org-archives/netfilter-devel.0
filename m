From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 1/2] expr: nat: add support for the new flags
	attribute
Date: Thu, 26 Jun 2014 14:22:15 +0200
Message-ID: <20140626122215.6913.15730.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42723 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757147AbaFZMWY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:22:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchs adds support for the new flags attribute in the nft_nat expression.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 0 files changed

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index cfa5c66..4200c4e 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -100,6 +100,7 @@ enum {
 	NFT_EXPR_NAT_REG_ADDR_MAX,
 	NFT_EXPR_NAT_REG_PROTO_MIN,
 	NFT_EXPR_NAT_REG_PROTO_MAX,
+	NFT_EXPR_NAT_FLAGS,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 2a88f64..92c211b 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -773,6 +773,7 @@ enum nft_nat_types {
  * @NFTA_NAT_REG_ADDR_MAX: source register of address range end (NLA_U32: nft_registers)
  * @NFTA_NAT_REG_PROTO_MIN: source register of proto range start (NLA_U32: nft_registers)
  * @NFTA_NAT_REG_PROTO_MAX: source register of proto range end (NLA_U32: nft_registers)
+ * @NFTA_NAT_FLAGS: additional NAT configuration (NF_NAT_RANGE_*) (NLA_U32)
  */
 enum nft_nat_attributes {
 	NFTA_NAT_UNSPEC,
@@ -782,6 +783,7 @@ enum nft_nat_attributes {
 	NFTA_NAT_REG_ADDR_MAX,
 	NFTA_NAT_REG_PROTO_MIN,
 	NFTA_NAT_REG_PROTO_MAX,
+	NFTA_NAT_FLAGS,
 	__NFTA_NAT_MAX
 };
 #define NFTA_NAT_MAX		(__NFTA_NAT_MAX - 1)
diff --git a/src/expr/nat.c b/src/expr/nat.c
index c719b6c..51188c1 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -31,6 +31,7 @@ struct nft_expr_nat {
 	enum nft_registers sreg_proto_max;
 	int                family;
 	enum nft_nat_types type;
+	uint32_t	   flags;
 };
 
 static int
@@ -58,6 +59,9 @@ nft_rule_expr_nat_set(struct nft_rule_expr *e, uint16_t type,
 	case NFT_EXPR_NAT_REG_PROTO_MAX:
 		nat->sreg_proto_max = *((uint32_t *)data);
 		break;
+	case NFT_EXPR_NAT_FLAGS:
+		nat->flags = *((uint32_t *)data);
+		break;
 	default:
 		return -1;
 	}
@@ -90,6 +94,9 @@ nft_rule_expr_nat_get(const struct nft_rule_expr *e, uint16_t type,
 	case NFT_EXPR_NAT_REG_PROTO_MAX:
 		*data_len = sizeof(nat->sreg_proto_max);
 		return &nat->sreg_proto_max;
+	case NFT_EXPR_NAT_FLAGS:
+		*data_len = sizeof(nat->flags);
+		return &nat->flags;
 	}
 	return NULL;
 }
@@ -109,6 +116,7 @@ static int nft_rule_expr_nat_cb(const struct nlattr *attr, void *data)
 	case NFTA_NAT_REG_ADDR_MAX:
 	case NFTA_NAT_REG_PROTO_MIN:
 	case NFTA_NAT_REG_PROTO_MAX:
+	case NFTA_NAT_FLAGS:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
 			perror("mnl_attr_validate");
 			return MNL_CB_ERROR;
@@ -157,6 +165,10 @@ nft_rule_expr_nat_parse(struct nft_rule_expr *e, struct nlattr *attr)
 			ntohl(mnl_attr_get_u32(tb[NFTA_NAT_REG_PROTO_MAX]));
 		e->flags |= (1 << NFT_EXPR_NAT_REG_PROTO_MAX);
 	}
+	if (tb[NFTA_NAT_FLAGS]) {
+		nat->flags = ntohl(mnl_attr_get_u32(tb[NFTA_NAT_FLAGS]));
+		e->flags |= (1 << NFT_EXPR_NAT_FLAGS);
+	}
 
 	return 0;
 }
@@ -182,6 +194,8 @@ nft_rule_expr_nat_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
 	if (e->flags & (1 << NFT_EXPR_NAT_REG_PROTO_MAX))
 		mnl_attr_put_u32(nlh, NFTA_NAT_REG_PROTO_MAX,
 				 htonl(nat->sreg_proto_max));
+	if (e->flags & (1 << NFT_EXPR_NAT_FLAGS))
+		mnl_attr_put_u32(nlh, NFTA_NAT_FLAGS, htonl(nat->flags));
 }
 
 static inline const char *nft_nat2str(uint16_t nat)
@@ -213,7 +227,7 @@ static int nft_rule_expr_nat_json_parse(struct nft_rule_expr *e, json_t *root,
 {
 #ifdef JSON_PARSING
 	const char *nat_type, *family_str;
-	uint32_t reg;
+	uint32_t reg, flags;
 	int val32;
 
 	nat_type = nft_jansson_parse_str(root, "nat_type", err);
@@ -252,6 +266,10 @@ static int nft_rule_expr_nat_json_parse(struct nft_rule_expr *e, json_t *root,
 				  &reg, err) == 0)
 		nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_PROTO_MAX, reg);
 
+	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U32,
+				  &flags, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_NAT_FLAGS, flags);
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -264,7 +282,7 @@ static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 {
 #ifdef XML_PARSING
 	const char *nat_type;
-	uint32_t family, nat_type_value;
+	uint32_t family, nat_type_value, flags;
 	uint32_t reg_addr_min, reg_addr_max;
 	uint32_t reg_proto_min, reg_proto_max;
 
@@ -302,6 +320,10 @@ static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 			       MXML_DESCEND, NFT_XML_MAND, err) == 0)
 		nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_PROTO_MAX, reg_proto_max);
 
+	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND, BASE_DEC, &flags,
+			       NFT_TYPE_U32, NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_NAT_FLAGS, flags);
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -333,11 +355,20 @@ nft_rule_expr_nat_snprintf_json(char *buf, size_t size,
 
 	if (e->flags & (1 << NFT_EXPR_NAT_REG_PROTO_MIN)) {
 		ret = snprintf(buf+offset, len, "\"sreg_proto_min\":%u,"
-						"\"sreg_proto_max\":%u",
+						"\"sreg_proto_max\":%u,",
 		       nat->sreg_proto_min, nat->sreg_proto_max);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	if (e->flags & (1 << NFT_EXPR_NAT_FLAGS)) {
+		ret = snprintf(buf+offset, len, "\"flags\":%u,", nat->flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	/* Remove the last comma separator */
+	if (offset > 0)
+		offset--;
+
 	return offset;
 }
 
@@ -372,6 +403,12 @@ nft_rule_expr_nat_snprintf_xml(char *buf, size_t size,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	if (e->flags & (1 << NFT_EXPR_NAT_FLAGS)) {
+		ret = snprintf(buf+offset, len, "<flags>%u</flags>",
+			       nat->flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	return offset;
 }
 
@@ -402,6 +439,11 @@ nft_rule_expr_nat_snprintf_default(char *buf, size_t size,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	if (e->flags & (1 << NFT_EXPR_NAT_FLAGS)) {
+		ret = snprintf(buf+offset, len, "flags %u", nat->flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	return offset;
 }
 

