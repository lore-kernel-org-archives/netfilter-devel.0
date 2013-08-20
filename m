From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 1/3] rule: Add json parser support
Date: Tue, 20 Aug 2013 17:58:46 +0200
Message-ID: <20130820155844.8850.85717.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:48072 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab3HTP7L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:59:11 -0400
Received: by mail-wg0-f52.google.com with SMTP id b13so543618wgh.31
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2013 08:59:10 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Add function for parsing rules in JSON format

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 include/libnftables/rule.h |    1=20
 src/expr/bitwise.c         |   45 ++++++++++++++++++++++
 src/expr/byteorder.c       |   50 ++++++++++++++++++++++++
 src/expr/cmp.c             |   38 ++++++++++++++++++
 src/expr/counter.c         |   26 +++++++++++++
 src/expr/ct.c              |   49 ++++++++++++++++++++++++
 src/expr/data_reg.c        |   77 ++++++++++++++++++++++++++++++++++++=
+
 src/expr/data_reg.h        |    5 ++
 src/expr/exthdr.c          |   43 +++++++++++++++++++++
 src/expr/immediate.c       |   40 +++++++++++++++++++
 src/expr/limit.c           |   25 ++++++++++++
 src/expr/log.c             |   39 +++++++++++++++++++
 src/expr/lookup.c          |   31 +++++++++++++++
 src/expr/match.c           |   22 ++++++++++-
 src/expr/meta.c            |   34 ++++++++++++++++
 src/expr/nat.c             |   59 +++++++++++++++++++++++++++++
 src/expr/payload.c         |   43 +++++++++++++++++++++
 src/expr/target.c          |   20 ++++++++++
 src/expr_ops.h             |    5 ++
 src/internal.h             |    8 ++++
 src/jansson.c              |   91 ++++++++++++++++++++++++++++++++++++=
++++++++
 src/rule.c                 |   90 ++++++++++++++++++++++++++++++++++++=
++++++++
 22 files changed, 839 insertions(+), 2 deletions(-)

diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index c597444..dd0e212 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -51,6 +51,7 @@ enum {
 enum nft_rule_parse_type {
 	NFT_RULE_PARSE_NONE	=3D 0,
 	NFT_RULE_PARSE_XML,
+	NFT_RULE_PARSE_JSON,
 	NFT_RULE_PARSE_MAX,
 };
=20
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 6c86acb..8cea075 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -181,6 +181,50 @@ nft_rule_expr_bitwise_parse(struct nft_rule_expr *=
e, struct nlattr *attr)
 }
=20
 static int
+nft_rule_expr_bitwise_json_parse(struct nft_rule_expr *e, json_t *root=
)
+{
+#ifdef JSON_PARSING
+	struct nft_expr_bitwise *bitwise =3D nft_expr_data(e);
+	uint32_t reg, len;
+
+	if (nft_jansson_value_parse_reg(root, "sreg", NFT_TYPE_U32, &reg) =3D=
=3D -1)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_BITWISE_SREG, reg);
+
+	if (nft_jansson_value_parse_reg(root, "dreg", NFT_TYPE_U32, &reg) =3D=
=3D -1)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_BITWISE_DREG, reg);
+
+	if (nft_jansson_value_parse_val(root, "len", NFT_TYPE_U32, &len) =3D=3D=
 -1)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_BITWISE_LEN, len);
+
+	if (nft_jansson_data_reg_parse(root, "mask",
+				       &bitwise->mask) !=3D DATA_VALUE)
+		return -1;
+
+	e->flags |=3D (1 << NFT_EXPR_BITWISE_MASK);
+
+	if (nft_jansson_data_reg_parse(root, "xor",
+				       &bitwise->xor) !=3D DATA_VALUE)
+		return -1;
+
+	e->flags |=3D (1 << NFT_EXPR_BITWISE_XOR);
+
+	if (bitwise->mask.len !=3D bitwise->xor.len)
+		return -1;
+
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
 nft_rule_expr_bitwise_xml_parse(struct nft_rule_expr *e, mxml_node_t *=
tree)
 {
 #ifdef XML_PARSING
@@ -349,6 +393,7 @@ struct expr_ops expr_ops_bitwise =3D {
 	.build		=3D nft_rule_expr_bitwise_build,
 	.snprintf	=3D nft_rule_expr_bitwise_snprintf,
 	.xml_parse	=3D nft_rule_expr_bitwise_xml_parse,
+	.json_parse	=3D nft_rule_expr_bitwise_json_parse,
 };
=20
 static void __init expr_bitwise(void)
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index e2d442c..f596ff3 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -194,6 +194,55 @@ static inline int nft_str2ntoh(const char *op)
 }
=20
 static int
+nft_rule_expr_byteorder_json_parse(struct nft_rule_expr *e, json_t *ro=
ot)
+{
+#ifdef JSON_PARSING
+	const char *op;
+	uint32_t uval32;
+	int ntoh;
+
+	if (nft_jansson_value_parse_reg(root, "sreg", NFT_TYPE_U32,
+					&uval32) !=3D 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_SREG, uval32);
+
+	if (nft_jansson_value_parse_reg(root, "dreg", NFT_TYPE_U32,
+					&uval32) !=3D 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_DREG, uval32);
+
+	op =3D nft_jansson_value_parse_str(root, "op");
+	if (op =3D=3D NULL)
+		return -1;
+
+	ntoh =3D nft_str2ntoh(op);
+	if (ntoh < 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_OP, ntoh);
+
+	if (nft_jansson_value_parse_val(root, "len", NFT_TYPE_U32,
+					&uval32) !=3D 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_LEN, uval32);
+
+	if (nft_jansson_value_parse_val(root, "size", NFT_TYPE_U32,
+					&uval32) !=3D 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_SIZE, uval32);
+
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
 nft_rule_expr_byteorder_xml_parse(struct nft_rule_expr *e, mxml_node_t=
 *tree)
 {
 #ifdef XML_PARSING
@@ -329,6 +378,7 @@ struct expr_ops expr_ops_byteorder =3D {
 	.build		=3D nft_rule_expr_byteorder_build,
 	.snprintf	=3D nft_rule_expr_byteorder_snprintf,
 	.xml_parse	=3D nft_rule_expr_byteorder_xml_parse,
+	.json_parse	=3D nft_rule_expr_byteorder_json_parse,
 };
=20
 static void __init expr_byteorder_init(void)
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 8ca4cb5..16be540 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -174,6 +174,43 @@ static inline int nft_str2cmp(const char *op)
 	}
 }
=20
+static int nft_rule_expr_cmp_json_parse(struct nft_rule_expr *e, json_=
t *root)
+{
+#ifdef JSON_PARSING
+	struct nft_expr_cmp *cmp =3D nft_expr_data(e);
+	const char *op;
+	uint32_t uval32;
+	int base;
+
+	if (nft_jansson_value_parse_val(root, "sreg", NFT_TYPE_U32,
+					&uval32) !=3D 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_CMP_SREG, uval32);
+
+	op =3D nft_jansson_value_parse_str(root, "op");
+	if (op =3D=3D NULL)
+		return -1;
+
+	base =3D nft_str2cmp(op);
+	if (base < 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_CMP_OP, base);
+
+	if (nft_jansson_data_reg_parse(root, "cmpdata",
+				       &cmp->data) !=3D DATA_VALUE)
+		return -1;
+
+	e->flags |=3D (1 << NFT_EXPR_CMP_DATA);
+
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
 static int nft_rule_expr_cmp_xml_parse(struct nft_rule_expr *e, mxml_n=
ode_t *tree)
 {
 #ifdef XML_PARSING
@@ -296,6 +333,7 @@ struct expr_ops expr_ops_cmp =3D {
 	.build		=3D nft_rule_expr_cmp_build,
 	.snprintf	=3D nft_rule_expr_cmp_snprintf,
 	.xml_parse	=3D nft_rule_expr_cmp_xml_parse,
+	.json_parse	=3D nft_rule_expr_cmp_json_parse,
 };
 static void __init expr_cmp_init(void)
 {
diff --git a/src/expr/counter.c b/src/expr/counter.c
index 75ad469..6cdd637 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -119,6 +119,31 @@ nft_rule_expr_counter_parse(struct nft_rule_expr *=
e, struct nlattr *attr)
 }
=20
 static int
+nft_rule_expr_counter_json_parse(struct nft_rule_expr *e, json_t *root=
)
+{
+#ifdef JSON_PARSING
+	uint64_t uval64;
+
+	if (nft_jansson_value_parse_val(root, "pkts", NFT_TYPE_U64,
+					&uval64) !=3D 0)
+		return -1;
+
+	nft_rule_expr_set_u64(e, NFT_EXPR_CTR_PACKETS, uval64);
+
+	if (nft_jansson_value_parse_val(root, "bytes", NFT_TYPE_U64,
+					&uval64) !=3D 0)
+		return -1;
+
+	nft_rule_expr_set_u64(e, NFT_EXPR_CTR_BYTES, uval64);
+
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
 nft_rule_expr_counter_xml_parse(struct nft_rule_expr *e, mxml_node_t *=
tree)
 {
 #ifdef XML_PARSING
@@ -175,6 +200,7 @@ struct expr_ops expr_ops_counter =3D {
 	.build		=3D nft_rule_expr_counter_build,
 	.snprintf	=3D nft_rule_expr_counter_snprintf,
 	.xml_parse	=3D nft_rule_expr_counter_xml_parse,
+	.json_parse	=3D nft_rule_expr_counter_json_parse,
 };
=20
 static void __init expr_counter_init(void)
diff --git a/src/expr/ct.c b/src/expr/ct.c
index f86fd4d..c131e67 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -178,6 +178,54 @@ static inline int str2ctkey(const char *ctkey)
 	return -1;
 }
=20
+static int nft_rule_expr_ct_json_parse(struct nft_rule_expr *e, json_t=
 *root)
+{
+#ifdef JSON_PARSING
+	const char *key_str;
+	uint32_t reg;
+	uint8_t dir;
+	int key;
+
+	if (nft_jansson_value_parse_reg(root, "dreg", NFT_TYPE_U32, &reg) !=3D=
 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_CT_DREG, reg);
+
+	if (nft_jansson_node_exist(root, "key")) {
+		key_str =3D nft_jansson_value_parse_str(root, "key");
+		if (key_str =3D=3D NULL)
+			return -1;
+
+		key =3D str2ctkey(key_str);
+		if (key < 0)
+			goto err;
+
+		nft_rule_expr_set_u32(e, NFT_EXPR_CT_KEY, key);
+
+	}
+
+	if (nft_jansson_node_exist(root, "dir")) {
+		if (nft_jansson_value_parse_val(root, "dir", NFT_TYPE_U8,
+						&dir) !=3D 0)
+			return -1;
+
+		if (dir !=3D IP_CT_DIR_ORIGINAL && dir !=3D IP_CT_DIR_REPLY)
+			goto err;
+
+		nft_rule_expr_set_u8(e, NFT_EXPR_CT_DIR, dir);
+	}
+
+	return 0;
+err:
+	errno =3D EINVAL;
+	return -1;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+
 static int nft_rule_expr_ct_xml_parse(struct nft_rule_expr *e, mxml_no=
de_t *tree)
 {
 #ifdef XML_PARSING
@@ -282,6 +330,7 @@ struct expr_ops expr_ops_ct =3D {
 	.build		=3D nft_rule_expr_ct_build,
 	.snprintf	=3D nft_rule_expr_ct_snprintf,
 	.xml_parse	=3D nft_rule_expr_ct_xml_parse,
+	.json_parse	=3D nft_rule_expr_ct_json_parse,
 };
=20
 static void __init expr_ct_init(void)
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 4c354ef..d0e1a83 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -26,6 +26,83 @@
 #include "data_reg.h"
 #include "internal.h"
=20
+#ifdef JSON_PARSING
+static int nft_data_reg_verdict_json_parse(union nft_data_reg *reg, js=
on_t *data)
+{
+	int verdict;
+	const char *verdict_str;
+
+	verdict_str =3D nft_jansson_value_parse_str(data, "verdict");
+	if (verdict_str =3D=3D NULL)
+		return -1;
+
+	verdict =3D nft_str2verdict(verdict_str);
+	if (verdict < 0)
+		return -1;
+
+	reg->verdict =3D (uint32_t)verdict;
+
+	return 0;
+}
+
+static int nft_data_reg_chain_json_parse(union nft_data_reg *reg, json=
_t *data)
+{
+	reg->chain =3D strdup(nft_jansson_value_parse_str(data, "chain"));
+	if (reg->chain =3D=3D NULL) {
+		return -1;
+	}
+
+	return 0;
+}
+
+static int nft_data_reg_value_json_parse(union nft_data_reg *reg, json=
_t *data)
+{
+	int i;
+	char node_name[6];
+
+	if (nft_jansson_value_parse_val(data, "len", NFT_TYPE_U8,
+					&reg->len) !=3D 0)
+			return -1;
+
+	for (i =3D 0; i < div_round_up(reg->len, sizeof(uint32_t)); i++) {
+		sprintf(node_name, "data%d", i);
+
+		if (nft_jansson_str2num(data, node_name, BASE_HEX,
+				        &reg->val[i], NFT_TYPE_U32) !=3D 0)
+			return -1;
+	}
+
+	return 0;
+}
+#endif
+
+int nft_data_reg_json_parse(union nft_data_reg *reg, json_t *data)
+{
+#ifdef JSON_PARSING
+
+	const char *type;
+
+	type =3D nft_jansson_value_parse_str(data, "type");
+	if (type =3D=3D NULL) {
+		return -1;
+	}
+
+	/* Select what type of parsing is needed */
+	if (strcmp(type, "value") =3D=3D 0) {
+		return nft_data_reg_value_json_parse(reg, data);
+	} else if (strcmp(type, "verdict") =3D=3D 0) {
+		return nft_data_reg_verdict_json_parse(reg, data);
+	} else if (strcmp(type, "chain") =3D=3D 0) {
+		return nft_data_reg_chain_json_parse(reg, data);
+	}
+
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
 #ifdef XML_PARSING
 static int nft_data_reg_verdict_xml_parse(union nft_data_reg *reg, cha=
r *xml)
 {
diff --git a/src/expr/data_reg.h b/src/expr/data_reg.h
index 9aee11f..7819919 100644
--- a/src/expr/data_reg.h
+++ b/src/expr/data_reg.h
@@ -18,9 +18,14 @@ union nft_data_reg {
 	};
 };
=20
+#ifndef JSON_PARSING
+#define json_t void
+#endif
+
 int nft_data_reg_snprintf(char *buf, size_t size, union nft_data_reg *=
reg,
                         uint32_t output_format, uint32_t flags, int re=
g_type);
 int nft_data_reg_xml_parse(union nft_data_reg *reg, char *xml);
 int nft_parse_data(union nft_data_reg *data, struct nlattr *attr, int =
*type);
+int nft_data_reg_json_parse(union nft_data_reg *reg, json_t *data);
=20
 #endif
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 9781232..8d4e8b7 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -192,6 +192,48 @@ static inline int str2exthdr_type(const char *str)
 	return -1;
 }
=20
+static int
+nft_rule_expr_exthdr_json_parse(struct nft_rule_expr *e, json_t *root)
+{
+#ifdef JSON_PARSING
+	const char *exthdr_type;
+	uint32_t uval32;
+	int type;
+
+	if (nft_jansson_value_parse_reg(root, "dreg", NFT_TYPE_U32,
+					&uval32) !=3D 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_EXTHDR_DREG, uval32);
+
+	exthdr_type =3D nft_jansson_value_parse_str(root, "exthdr_type");
+	if (exthdr_type =3D=3D NULL)
+		return -1;
+
+	type =3D str2exthdr_type(exthdr_type);
+	if (type < 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_EXTHDR_TYPE, type);
+
+	if (nft_jansson_value_parse_val(root, "offset", NFT_TYPE_U32,
+					&uval32) !=3D 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_EXTHDR_OFFSET, uval32);
+
+	if (nft_jansson_value_parse_val(root, "len", NFT_TYPE_U32,
+					&uval32) !=3D 0)
+		return -1;
+
+	 nft_rule_expr_set_u32(e, NFT_EXPR_EXTHDR_LEN, uval32);
+
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
=20
 static int
 nft_rule_expr_exthdr_xml_parse(struct nft_rule_expr *e, mxml_node_t *t=
ree)
@@ -284,6 +326,7 @@ struct expr_ops expr_ops_exthdr =3D {
 	.build		=3D nft_rule_expr_exthdr_build,
 	.snprintf	=3D nft_rule_expr_exthdr_snprintf,
 	.xml_parse	=3D nft_rule_expr_exthdr_xml_parse,
+	.json_parse	=3D nft_rule_expr_exthdr_json_parse,
 };
=20
 static void __init expr_exthdr_init(void)
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 2061172..d548b75 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -178,6 +178,45 @@ nft_rule_expr_immediate_parse(struct nft_rule_expr=
 *e, struct nlattr *attr)
 }
=20
 static int
+nft_rule_expr_immediate_json_parse(struct nft_rule_expr *e, json_t *ro=
ot)
+{
+#ifdef JSON_PARSING
+	struct nft_expr_immediate *imm =3D nft_expr_data(e);
+	int datareg_type;
+	uint32_t reg;
+
+	if (nft_jansson_value_parse_reg(root, "dreg", NFT_TYPE_U32, &reg) !=3D=
 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_IMM_DREG, reg);
+
+	datareg_type =3D nft_jansson_data_reg_parse(root, "immediatedata",
+						  &imm->data);
+	if (datareg_type < 0)
+		return -1;
+
+	switch (datareg_type) {
+	case DATA_VALUE:
+		e->flags |=3D (1 << NFT_EXPR_IMM_DATA);
+		break;
+	case DATA_VERDICT:
+		e->flags |=3D (1 << NFT_EXPR_IMM_VERDICT);
+		break;
+	case DATA_CHAIN:
+		e->flags |=3D (1 << NFT_EXPR_IMM_CHAIN);
+		break;
+	default:
+		return -1;
+	}
+
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
 nft_rule_expr_immediate_xml_parse(struct nft_rule_expr *e, mxml_node_t=
 *tree)
 {
 #ifdef XML_PARSING
@@ -342,6 +381,7 @@ struct expr_ops expr_ops_immediate =3D {
 	.build		=3D nft_rule_expr_immediate_build,
 	.snprintf	=3D nft_rule_expr_immediate_snprintf,
 	.xml_parse	=3D nft_rule_expr_immediate_xml_parse,
+	.json_parse	=3D nft_rule_expr_immediate_json_parse,
 };
=20
 static void __init expr_immediate_init(void)
diff --git a/src/expr/limit.c b/src/expr/limit.c
index 336bdb0..d65c0a9 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -118,6 +118,30 @@ nft_rule_expr_limit_parse(struct nft_rule_expr *e,=
 struct nlattr *attr)
 	return 0;
 }
=20
+static int nft_rule_expr_limit_json_parse(struct nft_rule_expr *e, jso=
n_t *root)
+{
+#ifdef JSON_PARSING
+	uint64_t uval64;
+
+	if (nft_jansson_value_parse_val(root, "rate", NFT_TYPE_U64,
+					&uval64) !=3D 0)
+		return -1;
+
+	nft_rule_expr_set_u64(e, NFT_EXPR_LIMIT_RATE, uval64);
+
+	if (nft_jansson_value_parse_val(root, "depth", NFT_TYPE_U64,
+					&uval64) !=3D 0)
+		return -1;
+
+	nft_rule_expr_set_u64(e, NFT_EXPR_LIMIT_DEPTH, uval64);
+
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
 static int nft_rule_expr_limit_xml_parse(struct nft_rule_expr *e, mxml=
_node_t *tree)
 {
 #ifdef XML_PARSING
@@ -176,6 +200,7 @@ struct expr_ops expr_ops_limit =3D {
 	.build		=3D nft_rule_expr_limit_build,
 	.snprintf	=3D nft_rule_expr_limit_snprintf,
 	.xml_parse	=3D nft_rule_expr_limit_xml_parse,
+	.json_parse	=3D nft_rule_expr_limit_json_parse,
 };
=20
 static void __init expr_limit_init(void)
diff --git a/src/expr/log.c b/src/expr/log.c
index 38b59f1..1dfea1b 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -156,6 +156,44 @@ nft_rule_expr_log_parse(struct nft_rule_expr *e, s=
truct nlattr *attr)
 	return 0;
 }
=20
+static int nft_rule_expr_log_json_parse(struct nft_rule_expr *e, json_=
t *root)
+{
+#ifdef JSON_PARSING
+	const char *prefix;
+	uint32_t snaplen;
+	uint16_t uval16;
+
+	prefix =3D nft_jansson_value_parse_str(root, "prefix");
+	if (prefix =3D=3D NULL)
+		return -1;
+
+	nft_rule_expr_set_str(e, NFT_EXPR_LOG_PREFIX, prefix);
+
+	if (nft_jansson_value_parse_val(root, "group", NFT_TYPE_U16,
+					&uval16) !=3D 0)
+		return -1;
+
+	nft_rule_expr_set_u16(e, NFT_EXPR_LOG_GROUP, uval16);
+
+	if (nft_jansson_value_parse_val(root, "snaplen", NFT_TYPE_U32,
+					&snaplen) !=3D 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_LOG_SNAPLEN, snaplen);
+
+	if (nft_jansson_value_parse_val(root, "qthreshold", NFT_TYPE_U16,
+					&uval16) !=3D 0)
+		return -1;
+
+	nft_rule_expr_set_u16(e, NFT_EXPR_LOG_QTHRESHOLD, uval16);
+
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
 static int nft_rule_expr_log_xml_parse(struct nft_rule_expr *e, mxml_n=
ode_t *tree)
 {
 #ifdef XML_PARSING
@@ -236,6 +274,7 @@ struct expr_ops expr_ops_log =3D {
 	.build		=3D nft_rule_expr_log_build,
 	.snprintf	=3D nft_rule_expr_log_snprintf,
 	.xml_parse	=3D nft_rule_expr_log_xml_parse,
+	.json_parse	=3D nft_rule_expr_log_json_parse,
 };
=20
 static void __init expr_log_init(void)
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index d66577b..34f484c 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -143,6 +143,36 @@ nft_rule_expr_lookup_parse(struct nft_rule_expr *e=
, struct nlattr *attr)
 }
=20
 static int
+nft_rule_expr_lookup_json_parse(struct nft_rule_expr *e, json_t *root)
+{
+#ifdef JSON_PARSING
+	const char *set_name;
+	int32_t reg;
+
+	set_name =3D nft_jansson_value_parse_str(root, "set");
+	if (set_name =3D=3D NULL)
+		return -1;
+
+	nft_rule_expr_set_str(e, NFT_EXPR_LOOKUP_SET, set_name);
+
+	if (nft_jansson_value_parse_reg(root, "sreg", NFT_TYPE_U32, &reg) !=3D=
 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_LOOKUP_SREG, reg);
+
+	if (nft_jansson_value_parse_reg(root, "dreg", NFT_TYPE_U32, &reg) !=3D=
 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_LOOKUP_DREG, reg);
+
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
 nft_rule_expr_lookup_xml_parse(struct nft_rule_expr *e, mxml_node_t *t=
ree)
 {
 #ifdef XML_PARSING
@@ -248,6 +278,7 @@ struct expr_ops expr_ops_lookup =3D {
 	.build		=3D nft_rule_expr_lookup_build,
 	.snprintf	=3D nft_rule_expr_lookup_snprintf,
 	.xml_parse	=3D nft_rule_expr_lookup_xml_parse,
+	.json_parse	=3D nft_rule_expr_lookup_json_parse,
 };
=20
 static void __init expr_lookup_init(void)
diff --git a/src/expr/match.c b/src/expr/match.c
index d155bb3..763e11e 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -170,6 +170,25 @@ static int nft_rule_expr_match_parse(struct nft_ru=
le_expr *e, struct nlattr *att
 	return 0;
 }
=20
+static int nft_rule_expr_match_json_parse(struct nft_rule_expr *e, jso=
n_t *root)
+{
+#ifdef JSON_PARSING
+	const char *name;
+
+	name =3D nft_jansson_value_parse_str(root, "name");
+	if (name =3D=3D NULL)
+		return -1;
+
+	nft_rule_expr_set_str(e, NFT_EXPR_MT_NAME, name);
+
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+
 static int nft_rule_expr_match_xml_parse(struct nft_rule_expr *e, mxml=
_node_t *tree)
 {
 #ifdef XML_PARSING
@@ -247,7 +266,8 @@ struct expr_ops expr_ops_match =3D {
 	.parse		=3D nft_rule_expr_match_parse,
 	.build		=3D nft_rule_expr_match_build,
 	.snprintf	=3D nft_rule_expr_match_snprintf,
-	.xml_parse =3D nft_rule_expr_match_xml_parse,
+	.xml_parse 	=3D nft_rule_expr_match_xml_parse,
+	.json_parse 	=3D nft_rule_expr_match_json_parse,
 };
=20
 static void __init expr_match_init(void)
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 8f163f6..84b8ba8 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -156,9 +156,40 @@ static inline int str2meta_key(const char *str)
 			return i;
 	}
=20
+	errno =3D EINVAL;
 	return -1;
 }
=20
+static int nft_rule_expr_meta_json_parse(struct nft_rule_expr *e, json=
_t *root)
+{
+#ifdef JSON_PARSING
+	const char *key_str;
+	uint32_t reg;
+	int key;
+
+	if (nft_jansson_value_parse_reg(root, "dreg", NFT_TYPE_U32, &reg) !=3D=
 0)
+                return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_META_DREG, reg);
+
+	key_str =3D nft_jansson_value_parse_str(root, "key");
+	if (key_str =3D=3D NULL)
+		return -1;
+
+	key =3D str2meta_key(key_str);
+	if (key < 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_META_KEY, key);
+
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+
 static int nft_rule_expr_meta_xml_parse(struct nft_rule_expr *e, mxml_=
node_t *tree)
 {
 #ifdef XML_PARSING
@@ -225,7 +256,8 @@ struct expr_ops expr_ops_meta =3D {
 	.parse		=3D nft_rule_expr_meta_parse,
 	.build		=3D nft_rule_expr_meta_build,
 	.snprintf	=3D nft_rule_expr_meta_snprintf,
-	.xml_parse =3D nft_rule_expr_meta_xml_parse,
+	.xml_parse 	=3D nft_rule_expr_meta_xml_parse,
+	.json_parse 	=3D nft_rule_expr_meta_json_parse,
 };
=20
 static void __init expr_meta_init(void)
diff --git a/src/expr/nat.c b/src/expr/nat.c
index e6866ec..312594f 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -196,6 +196,64 @@ static inline int nft_str2nat(const char *nat)
 	}
 }
=20
+static int nft_rule_expr_nat_json_parse(struct nft_rule_expr *e, json_=
t *root)
+{
+#ifdef JSON_PARSING
+	const char *nat_type, *family_str;
+	uint32_t reg;
+	int val32;
+
+	nat_type =3D nft_jansson_value_parse_str(root, "nat_type");
+	if (nat_type =3D=3D NULL)
+		return -1;
+
+	val32 =3D nft_str2nat(nat_type);
+	if (val32 < 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_TYPE, val32);
+
+	family_str =3D nft_jansson_value_parse_str(root, "family");
+	if (family_str =3D=3D NULL)
+		return -1;
+
+	val32 =3D nft_str2family(family_str);
+	if (val32 < 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_FAMILY, val32);
+
+	if (nft_jansson_value_parse_reg(root, "sreg_addr_min", NFT_TYPE_U32,
+					&reg) !=3D 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_ADDR_MIN, reg);
+
+	if (nft_jansson_value_parse_reg(root, "sreg_addr_max", NFT_TYPE_U32,
+					&reg) !=3D 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_ADDR_MAX, reg);
+
+	if (nft_jansson_value_parse_reg(root, "sreg_proto_min", NFT_TYPE_U32,
+					&reg) !=3D 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_PROTO_MIN, reg);
+
+	if (nft_jansson_value_parse_reg(root, "sreg_proto_max", NFT_TYPE_U32,
+					&reg) !=3D 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_NAT_REG_PROTO_MAX, reg);
+
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
 static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, mxml_n=
ode_t *tree)
 {
 #ifdef XML_PARSING
@@ -402,6 +460,7 @@ struct expr_ops expr_ops_nat =3D {
 	.build		=3D nft_rule_expr_nat_build,
 	.snprintf	=3D nft_rule_expr_nat_snprintf,
 	.xml_parse	=3D nft_rule_expr_nat_xml_parse,
+	.json_parse	=3D nft_rule_expr_nat_json_parse,
 };
=20
 static void __init expr_nat_init(void)
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 340a0d8..84346a1 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -194,6 +194,48 @@ static inline int nft_str2base(const char *base)
 }
=20
 static int
+nft_rule_expr_payload_json_parse(struct nft_rule_expr *e, json_t *root=
)
+{
+#ifdef JSON_PARSING
+	const char *base_str;
+	uint32_t reg, uval32;
+	int base;
+
+	if (nft_jansson_value_parse_reg(root, "dreg", NFT_TYPE_U32, &reg) !=3D=
 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_DREG, reg);
+
+	base_str =3D nft_jansson_value_parse_str(root, "base");
+	if (base_str =3D=3D NULL)
+		return -1;
+
+	base =3D nft_str2base(base_str);
+	if (base < 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_BASE, base);
+
+	if (nft_jansson_value_parse_val(root, "offset", NFT_TYPE_U32,
+					&uval32) !=3D 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_OFFSET, uval32);
+
+	if (nft_jansson_value_parse_val(root, "len", NFT_TYPE_U32,
+					&uval32) !=3D 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_PAYLOAD_LEN, uval32);
+
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
 nft_rule_expr_payload_xml_parse(struct nft_rule_expr *e, mxml_node_t *=
tree)
 {
 #ifdef XML_PARSING
@@ -286,6 +328,7 @@ struct expr_ops expr_ops_payload =3D {
 	.build		=3D nft_rule_expr_payload_build,
 	.snprintf	=3D nft_rule_expr_payload_snprintf,
 	.xml_parse	=3D nft_rule_expr_payload_xml_parse,
+	.json_parse	=3D nft_rule_expr_payload_json_parse,
 };
=20
 static void __init expr_payload_init(void)
diff --git a/src/expr/target.c b/src/expr/target.c
index 5ef53cb..ede4830 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -171,6 +171,25 @@ static int nft_rule_expr_target_parse(struct nft_r=
ule_expr *e, struct nlattr *at
 }
=20
 static int
+nft_rule_expr_target_json_parse(struct nft_rule_expr *e, json_t *root)
+{
+#ifdef JSON_PARSING
+	const char *name;
+
+	name =3D nft_jansson_value_parse_str(root, "name");
+	if (name =3D=3D NULL)
+		return -1;
+
+	nft_rule_expr_set_str(e, NFT_EXPR_TG_NAME, name);
+
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
 nft_rule_expr_target_xml_parse(struct nft_rule_expr *e, mxml_node_t *t=
ree)
 {
 #ifdef XML_PARSING
@@ -250,6 +269,7 @@ struct expr_ops expr_ops_target =3D {
 	.build		=3D nft_rule_expr_target_build,
 	.snprintf	=3D nft_rule_expr_target_snprintf,
 	.xml_parse	=3D nft_rule_expr_target_xml_parse,
+	.json_parse	=3D nft_rule_expr_target_json_parse,
 };
=20
 static void __init expr_target_init(void)
diff --git a/src/expr_ops.h b/src/expr_ops.h
index a46a309..12973ce 100644
--- a/src/expr_ops.h
+++ b/src/expr_ops.h
@@ -13,6 +13,10 @@ struct nft_rule_expr;
 #define mxml_node_t void
 #endif
=20
+#ifndef JSON_PARSING
+#define json_t void
+#endif
+
 struct expr_ops {
 	struct list_head head;
=20
@@ -25,6 +29,7 @@ struct expr_ops {
 	void	(*build)(struct nlmsghdr *nlh, struct nft_rule_expr *e);
 	int	(*snprintf)(char *buf, size_t len, uint32_t type, uint32_t flags,=
 struct nft_rule_expr *e);
 	int	(*xml_parse)(struct nft_rule_expr *e, mxml_node_t *tree);
+	int	(*json_parse)(struct nft_rule_expr *e, json_t *data);
 };
=20
 void nft_expr_ops_register(struct expr_ops *ops);
diff --git a/src/internal.h b/src/internal.h
index 5ca2288..cf110c3 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -52,6 +52,14 @@ json_t *nft_jansson_create_root(char *json, json_err=
or_t *err);
 json_t *nft_jansson_get_node(json_t *root, const char *tag);
 void nft_jansson_free_root(json_t *root);
 int nft_jansson_parse_family(json_t *root, void *out);
+int nft_jansson_str2num(json_t *root, const char *tag, int base, void =
*out,
+			enum nft_type type);
+int nft_jansson_value_parse_reg(json_t *root, const char *tag,
+				int type, void *out);
+struct nft_rule_expr *nft_jansson_expr_parse(json_t *root);
+union nft_data_reg;
+int nft_jansson_data_reg_parse(json_t *root, const char *tag,
+			       union nft_data_reg *data_reg);
 #endif
=20
 const char *nft_family2str(uint32_t family);
diff --git a/src/jansson.c b/src/jansson.c
index ca29863..f0ef04c 100644
--- a/src/jansson.c
+++ b/src/jansson.c
@@ -15,6 +15,10 @@
 #include <arpa/inet.h>
 #include <errno.h>
 #include <string.h>
+#include "expr_ops.h"
+
+#include <libnftables/expr.h>
+#include <linux/netfilter/nf_tables.h>
=20
 #ifdef JSON_PARSING
=20
@@ -121,4 +125,91 @@ int nft_jansson_parse_family(json_t *root, void *o=
ut)
 	memcpy(out, &family, sizeof(family));
 	return 0;
 }
+
+int nft_jansson_value_parse_reg(json_t *root, const char *tag, int typ=
e,
+				void *out)
+{
+	if (nft_jansson_value_parse_val(root, tag, type, out) !=3D 0)
+		return -1;
+
+	if (*((uint32_t *)out) > NFT_REG_MAX){
+		errno =3D ERANGE;
+		return -1;
+	}
+
+	return 0;
+}
+
+int nft_jansson_str2num(json_t *root, const char *tag, int base,
+			void *out, enum nft_type type)
+{
+	const char *str;
+
+	str =3D nft_jansson_value_parse_str(root, tag);
+	if (str =3D=3D NULL)
+		return -1;
+
+	return nft_strtoi(str, base, out, type);
+}
+
+struct nft_rule_expr *nft_jansson_expr_parse(json_t *root)
+{
+	struct nft_rule_expr *e;
+	const char *type;
+	int ret;
+
+	type =3D nft_jansson_value_parse_str(root, "type");
+	if (type =3D=3D NULL)
+		return NULL;
+
+	e =3D nft_rule_expr_alloc(type);
+	if (e =3D=3D NULL)
+		return NULL;;
+
+	ret =3D e->ops->json_parse(e, root);
+
+	return ret < 0 ? NULL : e;
+}
+
+int nft_jansson_data_reg_parse(json_t *root, const char *tag,
+			       union nft_data_reg *data_reg)
+{
+	json_t *data;
+	const char *type;
+	int ret;
+
+	data =3D json_object_get(root, tag);
+	if (data =3D=3D NULL) {
+		errno =3D EINVAL;
+		return -1;
+	}
+
+	data =3D json_object_get(data, "data_reg");
+	if (data =3D=3D NULL) {
+		errno =3D EINVAL;
+		return -1;
+	}
+
+	ret =3D nft_data_reg_json_parse(data_reg, data);
+
+	if (ret < 0) {
+		errno =3D EINVAL;
+		return -1;
+	}
+
+	type =3D nft_jansson_value_parse_str(data, "type");
+	if (type =3D=3D NULL)
+		return -1;
+
+	if (strcmp(type, "value") =3D=3D 0)
+		return DATA_VALUE;
+	else if (strcmp(type, "verdict") =3D=3D 0)
+		return DATA_VERDICT;
+	else if (strcmp(type, "chain") =3D=3D 0)
+		return DATA_CHAIN;
+	else {
+		errno =3D EINVAL;
+		return -1;
+	}
+}
 #endif
diff --git a/src/rule.c b/src/rule.c
index 7f905d2..feacc26 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -475,6 +475,93 @@ int nft_rule_nlmsg_parse(const struct nlmsghdr *nl=
h, struct nft_rule *r)
 }
 EXPORT_SYMBOL(nft_rule_nlmsg_parse);
=20
+static int nft_rule_json_parse(struct nft_rule *r, char *json)
+{
+#ifdef JSON_PARSING
+	json_t *root, *node, *array;
+	json_error_t error;
+	struct nft_rule_expr *e;
+	const char *str =3D NULL;
+	uint64_t uval64;
+	uint32_t uval32;
+	int i, family;
+
+	node =3D nft_jansson_create_root(json, &error);
+	if (node =3D=3D NULL)
+		return -1;
+
+	root =3D nft_jansson_get_node(node, "rule");
+	if (root =3D=3D NULL)
+		return -1;
+
+	if (nft_jansson_parse_family(root, &family) !=3D 0)
+		goto err;
+
+	nft_rule_attr_set_u32(r, NFT_RULE_ATTR_FAMILY, family);
+
+	str =3D nft_jansson_value_parse_str(root, "table");
+	if (str =3D=3D NULL)
+		goto err;
+
+	nft_rule_attr_set_str(r, NFT_RULE_ATTR_TABLE, str);
+
+	str =3D nft_jansson_value_parse_str(root, "chain");
+	if (str =3D=3D NULL)
+		goto err;
+
+	nft_rule_attr_set_str(r, NFT_RULE_ATTR_CHAIN, str);
+
+	if (nft_jansson_value_parse_val(root, "handle",
+					NFT_TYPE_U64, &uval64) =3D=3D -1)
+		goto err;
+
+	nft_rule_attr_set_u64(r, NFT_RULE_ATTR_HANDLE, uval64);
+
+	if (nft_jansson_value_parse_val(root, "flags",
+					NFT_TYPE_U32, &uval32) =3D=3D -1)
+		goto err;
+
+	nft_rule_attr_set_u32(r, NFT_RULE_ATTR_FLAGS, uval32);
+
+	if (nft_jansson_node_exist(root, "compat_proto") ||
+	    nft_jansson_node_exist(root, "compat_flags")) {
+		if (nft_jansson_value_parse_val(root, "compat_proto",
+					 	NFT_TYPE_U32, &uval32) =3D=3D -1)
+			goto err;
+
+		nft_rule_attr_set_u32(r, NFT_RULE_ATTR_COMPAT_PROTO, uval32);
+
+		if (nft_jansson_value_parse_val(root, "compat_flags",
+					 	NFT_TYPE_U32, &uval32) =3D=3D -1)
+			goto err;
+
+		nft_rule_attr_set_u32(r, NFT_RULE_ATTR_COMPAT_FLAGS, uval32);
+	}
+
+	array =3D json_object_get(root, "expr");
+	if (array =3D=3D NULL)
+		goto err;
+
+	for (i =3D 0; i < json_array_size(array); ++i) {
+
+		e =3D nft_jansson_expr_parse(json_array_get(array, i));
+		if (e =3D=3D NULL)
+			goto err;
+
+		nft_rule_add_expr(r, e);
+	}
+
+	json_decref(node);
+	return 0;
+err:
+	json_decref(node);
+	return -1;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
 static int nft_rule_xml_parse(struct nft_rule *r, char *xml)
 {
 #ifdef XML_PARSING
@@ -589,6 +676,9 @@ int nft_rule_parse(struct nft_rule *r, enum nft_rul=
e_parse_type type, char *data
 	case NFT_RULE_PARSE_XML:
 		ret =3D nft_rule_xml_parse(r, data);
 		break;
+	case NFT_RULE_PARSE_JSON:
+		ret =3D nft_rule_json_parse(r, data);
+		break;
 	default:
 		ret =3D -1;
 		errno =3D EOPNOTSUPP;

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
