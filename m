From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH v2] expr: lookup: give support for inverted matching
Date: Fri, 24 Jun 2016 09:07:02 +0200
Message-ID: <146675196497.29590.7809495991679699746.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:58504 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750853AbcFXHHK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Jun 2016 03:07:10 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id B7C9251F28A
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Jun 2016 07:07:05 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jUFIU_eWQD95 for <netfilter-devel@vger.kernel.org>;
	Fri, 24 Jun 2016 09:07:00 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
	(Authenticated sender: servers@cica.es)
	by smtp.cica.es (Postfix) with ESMTP id 4887651F277
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Jun 2016 09:07:00 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Inverted matching support was included in the kernel, let's give support here
as well.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: refresh patch with current master

 include/libnftnl/expr.h             |    1 +
 include/linux/netfilter/nf_tables.h |    6 ++++++
 src/expr/lookup.c                   |   32 +++++++++++++++++++++++++++++---
 tests/nft-expr_lookup-test.c        |    4 ++++
 4 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 4140652..17f60bd 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -107,6 +107,7 @@ enum {
 	NFTNL_EXPR_LOOKUP_DREG,
 	NFTNL_EXPR_LOOKUP_SET,
 	NFTNL_EXPR_LOOKUP_SET_ID,
+	NFTNL_EXPR_LOOKUP_FLAGS,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 6a4dbe0..01751fa 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -546,6 +546,10 @@ enum nft_cmp_attributes {
 };
 #define NFTA_CMP_MAX		(__NFTA_CMP_MAX - 1)
 
+enum nft_lookup_flags {
+	NFT_LOOKUP_F_INV = (1 << 0),
+};
+
 /**
  * enum nft_lookup_attributes - nf_tables set lookup expression netlink attributes
  *
@@ -553,6 +557,7 @@ enum nft_cmp_attributes {
  * @NFTA_LOOKUP_SREG: source register of the data to look for (NLA_U32: nft_registers)
  * @NFTA_LOOKUP_DREG: destination register (NLA_U32: nft_registers)
  * @NFTA_LOOKUP_SET_ID: uniquely identifies a set in a transaction (NLA_U32)
+ * @NFTA_LOOKUP_FLAGS: flags (NLA_U32: enum nft_lookup_flags)
  */
 enum nft_lookup_attributes {
 	NFTA_LOOKUP_UNSPEC,
@@ -560,6 +565,7 @@ enum nft_lookup_attributes {
 	NFTA_LOOKUP_SREG,
 	NFTA_LOOKUP_DREG,
 	NFTA_LOOKUP_SET_ID,
+	NFTA_LOOKUP_FLAGS,
 	__NFTA_LOOKUP_MAX
 };
 #define NFTA_LOOKUP_MAX		(__NFTA_LOOKUP_MAX - 1)
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 727c287..7f68f74 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -26,6 +26,7 @@ struct nftnl_expr_lookup {
 	enum nft_registers	dreg;
 	char			*set_name;
 	uint32_t		set_id;
+	uint32_t		flags;
 };
 
 static int
@@ -49,6 +50,9 @@ nftnl_expr_lookup_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_LOOKUP_SET_ID:
 		lookup->set_id = *((uint32_t *)data);
 		break;
+	case NFTNL_EXPR_LOOKUP_FLAGS:
+		lookup->flags = *((uint32_t *)data);
+		break;
 	default:
 		return -1;
 	}
@@ -72,6 +76,8 @@ nftnl_expr_lookup_get(const struct nftnl_expr *e, uint16_t type,
 		return lookup->set_name;
 	case NFTNL_EXPR_LOOKUP_SET_ID:
 		return &lookup->set_id;
+	case NFTNL_EXPR_LOOKUP_FLAGS:
+		return &lookup->flags;
 	}
 	return NULL;
 }
@@ -88,6 +94,7 @@ static int nftnl_expr_lookup_cb(const struct nlattr *attr, void *data)
 	case NFTA_LOOKUP_SREG:
 	case NFTA_LOOKUP_DREG:
 	case NFTA_LOOKUP_SET_ID:
+	case NFTA_LOOKUP_FLAGS:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
@@ -115,6 +122,8 @@ nftnl_expr_lookup_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 	if (e->flags & (1 << NFTNL_EXPR_LOOKUP_SET_ID)) {
 		mnl_attr_put_u32(nlh, NFTA_LOOKUP_SET_ID,
 				 htonl(lookup->set_id));
+	if (e->flags & (1 << NFTNL_EXPR_LOOKUP_FLAGS))
+		mnl_attr_put_u32(nlh, NFTA_LOOKUP_FLAGS, htonl(lookup->flags));
 	}
 }
 
@@ -148,6 +157,10 @@ nftnl_expr_lookup_parse(struct nftnl_expr *e, struct nlattr *attr)
 			ntohl(mnl_attr_get_u32(tb[NFTA_LOOKUP_SET_ID]));
 		e->flags |= (1 << NFTNL_EXPR_LOOKUP_SET_ID);
 	}
+	if (tb[NFTA_LOOKUP_FLAGS]) {
+		lookup->flags = ntohl(mnl_attr_get_u32(tb[NFTA_LOOKUP_FLAGS]));
+		e->flags |= (1 << NFTNL_EXPR_LOOKUP_FLAGS);
+	}
 
 	return ret;
 }
@@ -158,7 +171,7 @@ nftnl_expr_lookup_json_parse(struct nftnl_expr *e, json_t *root,
 {
 #ifdef JSON_PARSING
 	const char *set_name;
-	uint32_t sreg, dreg;
+	uint32_t sreg, dreg, flags;
 
 	set_name = nftnl_jansson_parse_str(root, "set", err);
 	if (set_name != NULL)
@@ -170,6 +183,10 @@ nftnl_expr_lookup_json_parse(struct nftnl_expr *e, json_t *root,
 	if (nftnl_jansson_parse_reg(root, "dreg", NFTNL_TYPE_U32, &dreg, err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_LOOKUP_DREG, dreg);
 
+	if (nftnl_jansson_parse_val(root, "flags", NFTNL_TYPE_U32,
+				    &flags, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_LOOKUP_FLAGS, flags);
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -183,7 +200,7 @@ nftnl_expr_lookup_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 {
 #ifdef XML_PARSING
 	const char *set_name;
-	uint32_t sreg, dreg;
+	uint32_t sreg, dreg, flags;
 
 	set_name = nftnl_mxml_str_parse(tree, "set", MXML_DESCEND_FIRST,
 				      NFTNL_XML_MAND, err);
@@ -198,6 +215,11 @@ nftnl_expr_lookup_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 			       err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_LOOKUP_DREG, dreg);
 
+        if (nftnl_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
+				 &flags, NFTNL_TYPE_U32,
+				 NFTNL_XML_MAND, err) == 0)
+                nftnl_expr_set_u32(e, NFTNL_EXPR_LOOKUP_FLAGS, flags);
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -218,6 +240,8 @@ nftnl_expr_lookup_export(char *buf, size_t size,
 		nftnl_buf_u32(&b, type, l->sreg, SREG);
 	if (e->flags & (1 << NFTNL_EXPR_LOOKUP_DREG))
 		nftnl_buf_u32(&b, type, l->dreg, DREG);
+	if (e->flags & (1 << NFTNL_EXPR_LOOKUP_FLAGS))
+		nftnl_buf_u32(&b, type, l->flags, FLAGS);
 
 	return nftnl_buf_done(&b);
 }
@@ -232,12 +256,14 @@ nftnl_expr_lookup_snprintf_default(char *buf, size_t size,
 	ret = snprintf(buf, len, "reg %u set %s ", l->sreg, l->set_name);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-
 	if (e->flags & (1 << NFTNL_EXPR_LOOKUP_DREG)) {
 		ret = snprintf(buf+offset, len, "dreg %u ", l->dreg);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	ret = snprintf(buf + offset, len, "0x%x ", l->flags);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
 	return offset;
 }
 
diff --git a/tests/nft-expr_lookup-test.c b/tests/nft-expr_lookup-test.c
index d3b45df..e52345f 100644
--- a/tests/nft-expr_lookup-test.c
+++ b/tests/nft-expr_lookup-test.c
@@ -39,6 +39,9 @@ static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 	if (strcmp(nftnl_expr_get_str(rule_a, NFTNL_EXPR_LOOKUP_SET),
 		   nftnl_expr_get_str(rule_b, NFTNL_EXPR_LOOKUP_SET)))
 		print_err("Expr NFTNL_EXPR_LOOKUP_SET mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_LOOKUP_FLAGS) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_LOOPUP_FLAGS))
+		print_err("Expr NFTNL_EXPR_LOOkUP_FLAGS mismatches");
 }
 
 int main(int argc, char *argv[])
@@ -63,6 +66,7 @@ int main(int argc, char *argv[])
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_LOOKUP_DREG, 0x78123456);
 	nftnl_expr_set(ex, NFTNL_EXPR_LOOKUP_SET, &lookup_set,
 			  sizeof(lookup_set));
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_LOOKUP_FLAGS, 0x12345678);
 
 	nftnl_rule_add_expr(a, ex);
 

