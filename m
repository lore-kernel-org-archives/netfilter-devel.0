From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] Add support for masq port selection
Date: Fri, 22 Jan 2016 11:45:17 +0530
Message-ID: <20160122061517.GA5964@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:36602 "EHLO
	mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbcAVGP0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Jan 2016 01:15:26 -0500
Received: by mail-pf0-f171.google.com with SMTP id n128so36502570pfn.3
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Jan 2016 22:15:25 -0800 (PST)
Received: from gmail.com ([223.176.138.15])
        by smtp.gmail.com with ESMTPSA id l14sm6641201pfb.73.2016.01.21.22.15.22
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Thu, 21 Jan 2016 22:15:24 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Complete masquerading support by allowing port range selection.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 include/libnftnl/expr.h             |  4 ++-
 include/linux/netfilter/nf_tables.h |  2 ++
 src/expr/masq.c                     | 64 ++++++++++++++++++++++++++++++++++---
 3 files changed, 65 insertions(+), 5 deletions(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 4a37581..ba5c605 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -166,7 +166,9 @@ enum {
 };
 
 enum {
-	NFTNL_EXPR_MASQ_FLAGS	= NFTNL_EXPR_BASE,
+	NFTNL_EXPR_MASQ_REG_PROTO_MIN	= NFTNL_EXPR_BASE,
+	NFTNL_EXPR_MASQ_REG_PROTO_MAX,
+	NFTNL_EXPR_MASQ_FLAGS,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 9796d82..c17615a 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -924,6 +924,8 @@ enum nft_nat_attributes {
 enum nft_masq_attributes {
 	NFTA_MASQ_UNSPEC,
 	NFTA_MASQ_FLAGS,
+	NFTA_MASQ_REG_PROTO_MIN,
+	NFTA_MASQ_REG_PROTO_MAX,
 	__NFTA_MASQ_MAX
 };
 #define NFTA_MASQ_MAX		(__NFTA_MASQ_MAX - 1)
diff --git a/src/expr/masq.c b/src/expr/masq.c
index 01512b4..e7c9ec7 100644
--- a/src/expr/masq.c
+++ b/src/expr/masq.c
@@ -21,7 +21,9 @@
 #include <libnftnl/rule.h>
 
 struct nftnl_expr_masq {
-	uint32_t	flags;
+	uint32_t		flags;
+	enum nft_registers	sreg_proto_min;
+	enum nft_registers	sreg_proto_max;
 };
 
 static int
@@ -31,6 +33,12 @@ nftnl_expr_masq_set(struct nftnl_expr *e, uint16_t type,
 	struct nftnl_expr_masq *masq = nftnl_expr_data(e);
 
 	switch (type) {
+	case NFTNL_EXPR_MASQ_REG_PROTO_MIN:
+		masq->sreg_proto_min = *((uint32_t *)data);
+		break;
+	case NFTNL_EXPR_MASQ_REG_PROTO_MAX:
+		masq->sreg_proto_max = *((uint32_t *)data);
+		break;
 	case NFTNL_EXPR_MASQ_FLAGS:
 		masq->flags = *((uint32_t *)data);
 		break;
@@ -47,6 +55,12 @@ nftnl_expr_masq_get(const struct nftnl_expr *e, uint16_t type,
 	struct nftnl_expr_masq *masq = nftnl_expr_data(e);
 
 	switch (type) {
+	case NFTNL_EXPR_MASQ_REG_PROTO_MIN:
+		*data_len = sizeof(masq->sreg_proto_min);
+		return &masq->sreg_proto_min;
+	case NFTNL_EXPR_MASQ_REG_PROTO_MAX:
+		*data_len = sizeof(masq->sreg_proto_max);
+		return &masq->sreg_proto_max;
 	case NFTNL_EXPR_MASQ_FLAGS:
 		*data_len = sizeof(masq->flags);
 		return &masq->flags;
@@ -63,6 +77,8 @@ static int nftnl_expr_masq_cb(const struct nlattr *attr, void *data)
 		return MNL_CB_OK;
 
 	switch (type) {
+	case NFTA_MASQ_REG_PROTO_MIN:
+	case NFTA_MASQ_REG_PROTO_MAX:
 	case NFTA_MASQ_FLAGS:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
@@ -78,6 +94,12 @@ nftnl_expr_masq_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
 {
 	struct nftnl_expr_masq *masq = nftnl_expr_data(e);
 
+	if (e->flags & (1 << NFTNL_EXPR_MASQ_REG_PROTO_MIN))
+		mnl_attr_put_u32(nlh, NFTA_MASQ_REG_PROTO_MIN,
+				 htobe32(masq->sreg_proto_min));
+	if (e->flags & (1 << NFTNL_EXPR_MASQ_REG_PROTO_MAX))
+		mnl_attr_put_u32(nlh, NFTA_MASQ_REG_PROTO_MAX,
+				 htobe32(masq->sreg_proto_max));
 	if (e->flags & (1 << NFTNL_EXPR_MASQ_FLAGS))
 		mnl_attr_put_u32(nlh, NFTA_MASQ_FLAGS, htobe32(masq->flags));
 }
@@ -91,6 +113,16 @@ nftnl_expr_masq_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_masq_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_MASQ_REG_PROTO_MIN]) {
+		masq->sreg_proto_min =
+			be32toh(mnl_attr_get_u32(tb[NFTA_MASQ_REG_PROTO_MIN]));
+		e->flags |= (1 << NFTNL_EXPR_MASQ_REG_PROTO_MIN);
+	}
+	if (tb[NFTA_MASQ_REG_PROTO_MAX]) {
+		masq->sreg_proto_max =
+			be32toh(mnl_attr_get_u32(tb[NFTA_MASQ_REG_PROTO_MAX]));
+		e->flags |= (1 << NFTNL_EXPR_MASQ_REG_PROTO_MAX);
+	}
 	if (tb[NFTA_MASQ_FLAGS]) {
 		masq->flags = be32toh(mnl_attr_get_u32(tb[NFTA_MASQ_FLAGS]));
 		e->flags |= (1 << NFTNL_EXPR_MASQ_FLAGS);
@@ -104,8 +136,14 @@ nftnl_expr_masq_json_parse(struct nftnl_expr *e, json_t *root,
 			      struct nftnl_parse_err *err)
 {
 #ifdef JSON_PARSING
-	uint32_t flags;
-
+	uint32_t reg, flags;
+
+	if (nftnl_jansson_parse_reg(root, "sreg_proto_min", NFTNL_TYPE_U32,
+				    &reg, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_MASQ_REG_PROTO_MIN, reg);
+	if (nftnl_jansson_parse_reg(root, "sreg_proto_max", NFTNL_TYPE_U32,
+				    &reg, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_MASQ_REG_PROTO_MAX, reg);
 	if (nftnl_jansson_parse_val(root, "flags", NFTNL_TYPE_U32, &flags,
 				  err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_MASQ_FLAGS, flags);
@@ -123,7 +161,16 @@ nftnl_expr_masq_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 {
 #ifdef XML_PARSING
 	uint32_t flags;
-
+	uint32_t reg_proto_min, reg_proto_max;
+
+	if (nftnl_mxml_reg_parse(tree, "sreg_proto_min", &reg_proto_min,
+				 MXML_DESCEND, NFTNL_XML_MAND, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_MASQ_REG_PROTO_MIN,
+				   reg_proto_min);
+	if (nftnl_mxml_reg_parse(tree, "sreg_proto_max", &reg_proto_max,
+				 MXML_DESCEND, NFTNL_XML_MAND, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_MASQ_REG_PROTO_MAX,
+				   reg_proto_max);
 	if (nftnl_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
 			       &flags, NFTNL_TYPE_U32, NFTNL_XML_MAND, err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_MASQ_FLAGS, flags);
@@ -140,6 +187,10 @@ static int nftnl_expr_masq_export(char *buf, size_t size,
 	struct nftnl_expr_masq *masq = nftnl_expr_data(e);
 	NFTNL_BUF_INIT(b, buf, size);
 
+	if (e->flags & (1 << NFTNL_EXPR_MASQ_REG_PROTO_MIN))
+		nftnl_buf_u32(&b, type, masq->sreg_proto_min, SREG_PROTO_MIN);
+	if (e->flags & (1 << NFTNL_EXPR_MASQ_REG_PROTO_MAX))
+		nftnl_buf_u32(&b, type, masq->sreg_proto_max, SREG_PROTO_MAX);
 	if (e->flags & (1 << NFTNL_EXPR_MASQ_FLAGS))
 		nftnl_buf_u32(&b, type, masq->flags, FLAGS);
 
@@ -151,6 +202,11 @@ static int nftnl_expr_masq_snprintf_default(char *buf, size_t len,
 {
 	struct nftnl_expr_masq *masq = nftnl_expr_data(e);
 
+	if (e->flags & (1 << NFTNL_EXPR_MASQ_REG_PROTO_MIN)) {
+		return snprintf(buf, len,
+				"proto_min reg %u proto_max reg %u ",
+				masq->sreg_proto_min, masq->sreg_proto_max);
+	}
 	if (e->flags & (1 << NFTNL_EXPR_MASQ_FLAGS))
 		return snprintf(buf, len, "flags 0x%x ", masq->flags);
 
-- 
1.9.1

