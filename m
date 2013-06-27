From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 1/2] Add function for exporting rule to JSON
 format and Order the switch values in the right order
Date: Thu, 27 Jun 2013 21:56:18 +0200
Message-ID: <20130627195618.13980.95963.stgit@Ph0enix>
References: <20130627194837.13980.68301.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60323 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab3F0T4X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Jun 2013 15:56:23 -0400
Received: by mail-wi0-f178.google.com with SMTP id k10so66852wiv.11
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2013 12:56:21 -0700 (PDT)
In-Reply-To: <20130627194837.13980.68301.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 include/libnftables/rule.h |    1 +
 src/chain.c                |    8 +++--
 src/expr/bitwise.c         |   37 ++++++++++++++++++++++++-
 src/expr/byteorder.c       |   22 +++++++++++++++
 src/expr/cmp.c             |   25 ++++++++++++++++-
 src/expr/counter.c         |    7 +++--
 src/expr/ct.c              |    5 +++
 src/expr/data_reg.c        |   65 ++++++++++++++++++++++++++++++++++++=
+++-----
 src/expr/exthdr.c          |   16 +++++++----
 src/expr/immediate.c       |   40 ++++++++++++++++++++++++++-
 src/expr/limit.c           |    4 +++
 src/expr/log.c             |    7 +++++
 src/expr/lookup.c          |   20 ++++++++++++--
 src/expr/match.c           |   18 +++++++++++-
 src/expr/meta.c            |   10 +++++--
 src/expr/nat.c             |   44 ++++++++++++++++++++++++++++--
 src/expr/payload.c         |   39 ++++++++++++++++++++++++--
 src/expr/target.c          |   19 ++++++++++++-
 src/internal.h             |    1 +
 src/rule.c                 |   52 ++++++++++++++++++++++++++++++++++-
 src/table.c                |    4 +--
 21 files changed, 402 insertions(+), 42 deletions(-)

diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index fb6e804..186c82c 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -44,6 +44,7 @@ void nft_rule_nlmsg_build_payload(struct nlmsghdr *nl=
h, struct nft_rule *t);
 enum {
 	NFT_RULE_O_DEFAULT	=3D 0,
 	NFT_RULE_O_XML,
+	NFT_RULE_O_JSON,
 };
=20
 enum nft_rule_parse_type {
diff --git a/src/chain.c b/src/chain.c
index bdcfec2..68744bc 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -794,12 +794,12 @@ int nft_chain_snprintf(char *buf, size_t size, st=
ruct nft_chain *c,
 		       uint32_t type, uint32_t flags)
 {
 	switch(type) {
-	case NFT_CHAIN_O_JSON:
-		return nft_chain_snprintf_json(buf, size, c);
-	case NFT_CHAIN_O_XML:
-		return nft_chain_snprintf_xml(buf, size, c);
 	case NFT_CHAIN_O_DEFAULT:
 		return nft_chain_snprintf_default(buf, size, c);
+	case NFT_CHAIN_O_XML:
+		return nft_chain_snprintf_xml(buf, size, c);
+	case NFT_CHAIN_O_JSON:
+		return nft_chain_snprintf_json(buf, size, c);
 	default:
 		break;
 	}
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 80c4f20..6843086 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -325,6 +325,37 @@ nft_rule_expr_bitwise_xml_parse(struct nft_rule_ex=
pr *e, char *xml)
 }
=20
 static int
+nft_rule_expr_bitwise_snprintf_json(char *buf, size_t size,
+				   struct nft_expr_bitwise *bitwise)
+{
+	int len =3D size, offset =3D 0, ret;
+
+	ret =3D snprintf(buf, len, "\"sreg\" : %u, "
+				"\"dreg\" : %u, ",
+		       bitwise->sreg, bitwise->dreg);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret =3D snprintf(buf+offset, len, "\"mask\" : ");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret =3D nft_data_reg_snprintf(buf+offset, len, &bitwise->mask,
+				    NFT_RULE_O_JSON, 0, DATA_VALUE);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret =3D snprintf(buf+offset, len, ", \"xor\" : ");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret =3D nft_data_reg_snprintf(buf+offset, len, &bitwise->xor,
+				    NFT_RULE_O_JSON, 0, DATA_VALUE);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret =3D snprintf(buf+offset, len, "\"");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+static int
 nft_rule_expr_bitwise_snprintf_xml(char *buf, size_t size,
 				   struct nft_expr_bitwise *bitwise)
 {
@@ -389,11 +420,13 @@ nft_rule_expr_bitwise_snprintf(char *buf, size_t =
size, uint32_t type,
 	struct nft_expr_bitwise *bitwise =3D (struct nft_expr_bitwise *)e->da=
ta;
=20
 	switch(type) {
-	case NFT_RULE_O_XML:
-		return nft_rule_expr_bitwise_snprintf_xml(buf, size, bitwise);
 	case NFT_RULE_O_DEFAULT:
 		return nft_rule_expr_bitwise_snprintf_default(buf, size,
 							      bitwise);
+	case NFT_RULE_O_XML:
+		return nft_rule_expr_bitwise_snprintf_xml(buf, size, bitwise);
+	case NFT_RULE_O_JSON:
+		return nft_rule_expr_bitwise_snprintf_json(buf, size, bitwise);
 	default:
 		break;
 	}
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index b0ba009..bb47f10 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -298,6 +298,25 @@ err:
 }
=20
 static int
+nft_rule_expr_byteorder_snprintf_json(char *buf, size_t size,
+				       struct nft_expr_byteorder *byteorder)
+{
+	int len =3D size, offset =3D 0, ret;
+
+	ret =3D snprintf(buf, len, "\"sreg\" : %u, "
+				 "\"dreg\" : %u, "
+				 "\"op\" : \"%s\", "
+				 "\"len\" : %u, "
+				 "\"size\" : %u",
+		       byteorder->sreg, byteorder->dreg,
+		       expr_byteorder_str[byteorder->op],
+		       byteorder->len, byteorder->size);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+static int
 nft_rule_expr_byteorder_snprintf_xml(char *buf, size_t size,
 				   struct nft_expr_byteorder *byteorder)
 {
@@ -344,6 +363,9 @@ nft_rule_expr_byteorder_snprintf(char *buf, size_t =
size, uint32_t type,
 	case NFT_RULE_O_XML:
 		return nft_rule_expr_byteorder_snprintf_xml(buf, size,
 							    byteorder);
+	case NFT_RULE_O_JSON:
+		return nft_rule_expr_byteorder_snprintf_json(buf, size,
+							    byteorder);
 	default:
 		break;
 	}
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 9507a0e..f92b3b6 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -265,6 +265,25 @@ static int nft_rule_expr_cmp_xml_parse(struct nft_=
rule_expr *e, char *xml)
 }
=20
 static int
+nft_rule_expr_cmp_snprintf_json(char *buf, size_t size, struct nft_exp=
r_cmp *cmp)
+{
+	int len =3D size, offset =3D 0, ret;
+
+	ret =3D snprintf(buf, len, "\"sreg\" : %u, \"op\" : \"%s\", \"cmpdata=
\" : {",
+		       cmp->sreg, expr_cmp_str[cmp->op]);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret =3D nft_data_reg_snprintf(buf+offset, len, &cmp->data,
+				    NFT_RULE_O_JSON, 0, DATA_VALUE);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret =3D snprintf(buf+offset, len, "}");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+static int
 nft_rule_expr_cmp_snprintf_xml(char *buf, size_t size, struct nft_expr=
_cmp *cmp)
 {
 	int len =3D size, offset =3D 0, ret;
@@ -306,10 +325,12 @@ nft_rule_expr_cmp_snprintf(char *buf, size_t size=
, uint32_t type,
 {
 	struct nft_expr_cmp *cmp =3D (struct nft_expr_cmp *)e->data;
 	switch(type) {
-	case NFT_RULE_O_XML:
-		return nft_rule_expr_cmp_snprintf_xml(buf, size, cmp);
 	case NFT_RULE_O_DEFAULT:
 		return nft_rule_expr_cmp_snprintf_default(buf, size, cmp);
+	case NFT_RULE_O_XML:
+		return nft_rule_expr_cmp_snprintf_xml(buf, size, cmp);
+	case NFT_RULE_O_JSON:
+		return nft_rule_expr_cmp_snprintf_json(buf, size, cmp);
 	default:
 		break;
 	}
diff --git a/src/expr/counter.c b/src/expr/counter.c
index 77054e2..62bd143 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -194,11 +194,14 @@ nft_rule_expr_counter_snprintf(char *buf, size_t =
len, uint32_t type,
 	struct nft_expr_counter *ctr =3D (struct nft_expr_counter *)e->data;
=20
 	switch(type) {
+	case NFT_RULE_O_DEFAULT:
+		return snprintf(buf, len, "pkts=3D%lu bytes=3D%lu ",
+				ctr->pkts, ctr->bytes);
 	case NFT_RULE_O_XML:
 		return snprintf(buf, len, "<pkts>%lu</pkts><bytes>%lu</bytes>",
 				ctr->pkts, ctr->bytes);
-	case NFT_RULE_O_DEFAULT:
-		return snprintf(buf, len, "pkts=3D%lu bytes=3D%lu ",
+	case NFT_RULE_O_JSON:
+		return snprintf(buf, len, "\"pkts\" : %lu, \"bytes\" : %lu",
 				ctr->pkts, ctr->bytes);
 	default:
 		break;
diff --git a/src/expr/ct.c b/src/expr/ct.c
index e4ab3ed..fcdabce 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -279,6 +279,11 @@ nft_rule_expr_ct_snprintf(char *buf, size_t len, u=
int32_t type,
 					  "<key>%s</key>"
 					  "<dir>%u</dir>",
 				ct->dreg, ctkey2str(ct->key), ct->dir);
+	case NFT_RULE_O_JSON:
+		return snprintf(buf, len, "\"dreg\" : %u, "
+					  "\"key\" : \"%s\", "
+					  "\"dir\" : %u",
+				ct->dreg, ctkey2str(ct->key), ct->dir);
 	default:
 		break;
 	}
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index c123d88..b8c9fe2 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -253,6 +253,44 @@ int nft_data_reg_xml_parse(union nft_data_reg *reg=
, char *xml)
 #endif
 }
=20
+static int=20
+nft_data_reg_value_snprintf_json(char *buf, size_t size,
+					   union nft_data_reg *reg,
+					   uint32_t flags)
+{
+	int len =3D size, offset =3D 0, ret, i, j;
+	uint32_t utemp;
+	uint8_t *tmp;
+	int data_len =3D reg->len/sizeof(uint32_t);
+
+	ret =3D snprintf(buf, len, "\"data_reg\": { \"type\" : \"value\", ");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret =3D snprintf(buf+offset, len, "\"len\" : %zd, ", reg->len);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	for (i =3D 0; i<data_len; i++) {
+		ret =3D snprintf(buf+offset, len, "\"data%d\" : \"0x", i);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		utemp =3D htonl(reg->val[i]);
+		tmp =3D (uint8_t *)&utemp;
+
+		for (j =3D 0; j<sizeof(uint32_t); j++) {
+			ret =3D snprintf(buf+offset, len, "%.02x", tmp[j]);
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		}
+
+		ret =3D snprintf(buf+offset, len, "\"");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	ret =3D snprintf(buf+offset, len, "}");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
 static
 int nft_data_reg_value_snprintf_xml(char *buf, size_t size,
 				    union nft_data_reg *reg, uint32_t flags)
@@ -310,36 +348,49 @@ int nft_data_reg_snprintf(char *buf, size_t size,=
 union nft_data_reg *reg,
 	switch(reg_type) {
 	case DATA_VALUE:
 		switch(output_format) {
-		case NFT_RULE_O_XML:
-			return nft_data_reg_value_snprintf_xml(buf, size,
-							       reg, flags);
 		case NFT_RULE_O_DEFAULT:
 			return nft_data_reg_value_snprintf_default(buf, size,
 								   reg, flags);
+		case NFT_RULE_O_XML:
+			return nft_data_reg_value_snprintf_xml(buf, size,
+							       reg, flags);
+		case NFT_RULE_O_JSON:
+			return nft_data_reg_value_snprintf_json(buf, size,
+							       reg, flags);
 		default:
 			break;
 		}
 	case DATA_VERDICT:
 		switch(output_format) {
+		case NFT_RULE_O_DEFAULT:
+			return snprintf(buf, size, "verdict=3D%d", reg->verdict);
 		case NFT_RULE_O_XML:
 			return snprintf(buf, size,
 					"<data_reg type=3D\"verdict\">"
 						"<verdict>%d</verdict>"
 					"</data_reg>", reg->verdict);
-		case NFT_RULE_O_DEFAULT:
-			return snprintf(buf, size, "verdict=3D%d", reg->verdict);
+		case NFT_RULE_O_JSON:
+			return snprintf(buf, size,
+					"\"data_reg\": { \"type\" : \"verdict\", "
+						"\"verdict\" : %d"
+					"}", reg->verdict);
 		default:
 			break;
 		}
 	case DATA_CHAIN:
 		switch(output_format) {
+		case NFT_RULE_O_DEFAULT:
+			return snprintf(buf, size, "chain=3D%s", reg->chain);
 		case NFT_RULE_O_XML:
 			return snprintf(buf, size,
 					"<data_reg type=3D\"chain\">"
 						"<chain>%s</chain>"
 					"</data_reg>", reg->chain);
-		case NFT_RULE_O_DEFAULT:
-			return snprintf(buf, size, "chain=3D%s", reg->chain);
+		case NFT_RULE_O_JSON:
+			return snprintf(buf, size,
+					"\"data_reg\": { \"type\" : \"chain\", "
+						"\"chain\" : %d"
+					"}", reg->verdict);
 		default:
 			break;
 		}
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index a31f079..b4b9c13 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -325,6 +325,10 @@ nft_rule_expr_exthdr_snprintf(char *buf, size_t le=
n, uint32_t type,
 	struct nft_expr_exthdr *exthdr =3D (struct nft_expr_exthdr *)e->data;
=20
 	switch(type) {
+	case NFT_RULE_O_DEFAULT:
+		return snprintf(buf, len, "dreg=3D%u type=3D%u offset=3D%u len=3D%u =
",
+				exthdr->dreg, exthdr->type,
+				exthdr->offset, exthdr->len);
 	case NFT_RULE_O_XML:
 		return snprintf(buf, len, "<dreg>%u</dreg>"
 					  "<exthdr_type>%s</exthdr_type>"
@@ -333,11 +337,13 @@ nft_rule_expr_exthdr_snprintf(char *buf, size_t l=
en, uint32_t type,
 					exthdr->dreg,
 					exthdr_type2str(exthdr->type),
 					exthdr->offset, exthdr->len);
-
-	case NFT_RULE_O_DEFAULT:
-		return snprintf(buf, len, "dreg=3D%u type=3D%u offset=3D%u len=3D%u =
",
-				exthdr->dreg, exthdr->type,
-				exthdr->offset, exthdr->len);
+	case NFT_RULE_O_JSON:
+		return snprintf(buf, len, "\"dreg\" : %u, "
+					  "\"exthdr_type\" : \"%s\", \"offset\" : %u, "
+					  "\"len\" : %u",
+					exthdr->dreg,
+					exthdr_type2str(exthdr->type),
+					exthdr->offset, exthdr->len);
 	default:
 		break;
 	}
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 8bc810c..1937d82 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -300,6 +300,40 @@ nft_rule_expr_immediate_xml_parse(struct nft_rule_=
expr *e, char *xml)
 }
=20
 static int
+nft_rule_expr_immediate_snprintf_json(char *buf, size_t len,
+				     struct nft_rule_expr *e, uint32_t flags)
+{
+	int size =3D len, offset =3D 0, ret;
+	struct nft_expr_immediate *imm =3D (struct nft_expr_immediate *)e->da=
ta;
+
+	ret =3D snprintf(buf, len, "\"dreg\" : %u, "
+				"\"immediatedata\" : {", imm->dreg);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+
+	if (e->flags & (1 << NFT_EXPR_IMM_DATA)) {
+		ret =3D nft_data_reg_snprintf(buf+offset, len, &imm->data,
+					    NFT_RULE_O_JSON, flags, DATA_VALUE);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	} else if (e->flags & (1 << NFT_EXPR_IMM_VERDICT)) {
+		ret =3D nft_data_reg_snprintf(buf+offset, len, &imm->data,
+					  NFT_RULE_O_JSON, flags, DATA_VERDICT);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	} else if (e->flags & (1 << NFT_EXPR_IMM_CHAIN)) {
+		ret =3D nft_data_reg_snprintf(buf+offset, len, &imm->data,
+					    NFT_RULE_O_JSON, flags, DATA_CHAIN);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	ret =3D snprintf(buf+offset, len, "}");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+static int
 nft_rule_expr_immediate_snprintf_xml(char *buf, size_t len,
 				     struct nft_rule_expr *e, uint32_t flags)
 {
@@ -367,10 +401,12 @@ nft_rule_expr_immediate_snprintf(char *buf, size_=
t len, uint32_t type,
 				 uint32_t flags, struct nft_rule_expr *e)
 {
 	switch(type) {
-	case NFT_RULE_O_XML:
-		return nft_rule_expr_immediate_snprintf_xml(buf, len, e, flags);
 	case NFT_RULE_O_DEFAULT:
 		return nft_rule_expr_immediate_snprintf_default(buf, len, e, flags);
+	case NFT_RULE_O_XML:
+		return nft_rule_expr_immediate_snprintf_xml(buf, len, e, flags);
+	case NFT_RULE_O_JSON:
+		return nft_rule_expr_immediate_snprintf_json(buf, len, e, flags);
 	default:
 		break;
 	}
diff --git a/src/expr/limit.c b/src/expr/limit.c
index d6dc900..1e843ce 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -195,6 +195,10 @@ nft_rule_expr_limit_snprintf(char *buf, size_t len=
, uint32_t type,
 		return snprintf(buf, len, "<rate>%"PRIu64"</rate>"
 					  "<depth>%"PRIu64"</depth>",
 				limit->rate, limit->depth);
+	case NFT_RULE_O_JSON:
+		return snprintf(buf, len, "\"rate\" : %"PRIu64", "
+					  "\"depth\" : %"PRIu64" ",
+				limit->rate, limit->depth);
 	default:
 		break;
 	}
diff --git a/src/expr/log.c b/src/expr/log.c
index 2d93b2a..8dc5201 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -263,6 +263,13 @@ nft_rule_expr_log_snprintf(char *buf, size_t len, =
uint32_t type,
 					  "<qthreshold>%u</qthreshold>",
 				log->prefix, log->group,
 				log->snaplen, log->qthreshold);
+	case NFT_RULE_O_JSON:
+		return snprintf(buf, len, "\"prefix\" : \"%s\", "
+					  "\"group\" : %u, "
+					  "\"snaplen\" : %u, "
+					  "\"qthreshold\" : %u ",
+				log->prefix, log->group,
+				log->snaplen, log->qthreshold);
 	default:
 		break;
 	}
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index ecc07cb..8591d4e 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -239,6 +239,20 @@ nft_rule_expr_lookup_xml_parse(struct nft_rule_exp=
r *e, char *xml)
 }
=20
 static int
+nft_rule_expr_lookup_snprintf_json(char *buf, size_t size,
+				  struct nft_expr_lookup *l)
+{
+	int len =3D size, offset =3D 0, ret;
+
+	ret =3D snprintf(buf, len, "\"set\" : \"%s\", \"sreg\" : %u, \"dreg\"=
 : %u",
+			l->set_name, l->sreg, l->dreg);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+
+static int
 nft_rule_expr_lookup_snprintf_xml(char *buf, size_t size,
 				  struct nft_expr_lookup *l)
 {
@@ -271,10 +285,12 @@ nft_rule_expr_lookup_snprintf(char *buf, size_t s=
ize, uint32_t type,
 	struct nft_expr_lookup *lookup =3D (struct nft_expr_lookup *)e->data;
=20
 	switch(type) {
-	case NFT_RULE_O_XML:
-		return nft_rule_expr_lookup_snprintf_xml(buf, size, lookup);
 	case NFT_RULE_O_DEFAULT:
 		return nft_rule_expr_lookup_snprintf_default(buf, size, lookup);
+	case NFT_RULE_O_XML:
+		return nft_rule_expr_lookup_snprintf_xml(buf, size, lookup);
+	case NFT_RULE_O_JSON:
+		return nft_rule_expr_lookup_snprintf_json(buf, size, lookup);
 	default:
 		break;
 	}
diff --git a/src/expr/match.c b/src/expr/match.c
index 7b4377f..7d0f078 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -226,6 +226,18 @@ static int nft_rule_expr_match_xml_parse(struct nf=
t_rule_expr *e, char *xml)
 #endif
 }
=20
+static int nft_rule_expr_match_snprintf_json(char *buf, size_t len,
+					    struct nft_expr_match *mt)
+{
+	int ret, size =3D len, offset =3D 0;
+
+	ret =3D snprintf(buf, len, "\"name\" : \"%s\"",
+				mt->name);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
 static int nft_rule_expr_match_snprintf_xml(char *buf, size_t len,
 					    struct nft_expr_match *mt)
 {
@@ -246,11 +258,13 @@ nft_rule_expr_match_snprintf(char *buf, size_t le=
n, uint32_t type,
 	struct nft_expr_match *match =3D (struct nft_expr_match *)e->data;
=20
 	switch(type) {
-	case NFT_RULE_O_XML:
-		return nft_rule_expr_match_snprintf_xml(buf, len, match);
 	case NFT_RULE_O_DEFAULT:
 		return snprintf(buf, len, "name=3D%s rev=3D%u ",
 				match->name, match->rev);
+	case NFT_RULE_O_XML:
+		return nft_rule_expr_match_snprintf_xml(buf, len, match);
+	case NFT_RULE_O_JSON:
+		return nft_rule_expr_match_snprintf_json(buf, len, match);
 	default:
 		break;
 	}
diff --git a/src/expr/meta.c b/src/expr/meta.c
index d5d297b..1a609cf 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -246,13 +246,17 @@ nft_rule_expr_meta_snprintf(char *buf, size_t len=
, uint32_t type,
 	struct nft_expr_meta *meta =3D (struct nft_expr_meta *)e->data;
=20
 	switch(type) {
+	case NFT_RULE_O_DEFAULT:
+		return snprintf(buf, len, "dreg=3D%u key=3D%u ",
+				meta->dreg, meta->key);
 	case NFT_RULE_O_XML:
 		return snprintf(buf, len, "<dreg>%u</dreg>"
 					  "<key>%s</key>",
 				meta->dreg, meta_key2str(meta->key));
-	case NFT_RULE_O_DEFAULT:
-		return snprintf(buf, len, "dreg=3D%u key=3D%u ",
-				meta->dreg, meta->key);
+	case NFT_RULE_O_JSON:
+		return snprintf(buf, len, "\"dreg\" : %u, "
+					  "\"key\" : %s",
+				meta->dreg, meta_key2str(meta->key));
 	default:
 		break;
 	}
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 506c0b1..a1e6700 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -328,6 +328,44 @@ static int nft_rule_expr_nat_xml_parse(struct nft_=
rule_expr *e, char *xml)
 }
=20
 static int
+nft_rule_expr_nat_snprintf_json(char *buf, size_t size,
+				struct nft_rule_expr *e)
+{
+	struct nft_expr_nat *nat =3D (struct nft_expr_nat *)e->data;
+	int len =3D size, offset =3D 0, ret =3D 0;
+
+	if (nat->type =3D=3D NFT_NAT_SNAT)
+		ret =3D snprintf(buf, len, "\"nat_type\" : \"snat\", ");
+	else if (nat->type =3D=3D NFT_NAT_DNAT)
+		ret =3D snprintf(buf, len, "\nat_type\" : \"dnat\", ");
+
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret =3D snprintf(buf+offset, len, "\"family\" : \"%s\", ",
+		       nft_family2str(nat->family));
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if (e->flags & (1 << NFT_EXPR_NAT_REG_ADDR_MIN)) {
+		ret =3D snprintf(buf+offset, len,=20
+				"\"sreg_addr_min\" : %u, "
+				"\"sreg_addr_max\" : %u, ",
+			       nat->sreg_addr_min, nat->sreg_addr_max);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (e->flags & (1 << NFT_EXPR_NAT_REG_PROTO_MIN)) {
+		ret =3D snprintf(buf+offset, len,=20
+				"\"sreg_proto_min\" : %u, "
+				"\"sreg_proto_max\" : %u",
+		       nat->sreg_proto_min, nat->sreg_proto_max);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
+}
+
+
+static int
 nft_rule_expr_nat_snprintf_xml(char *buf, size_t size,
 				struct nft_rule_expr *e)
 {
@@ -410,10 +448,12 @@ nft_rule_expr_nat_snprintf(char *buf, size_t size=
, uint32_t type,
 			   uint32_t flags, struct nft_rule_expr *e)
 {
 	switch (type) {
-	case NFT_RULE_O_XML:
-		return nft_rule_expr_nat_snprintf_xml(buf, size, e);
 	case NFT_RULE_O_DEFAULT:
 		return nft_rule_expr_nat_snprintf_default(buf, size, e);
+	case NFT_RULE_O_XML:
+		return nft_rule_expr_nat_snprintf_xml(buf, size, e);
+	case NFT_RULE_O_JSON:
+		return nft_rule_expr_nat_snprintf_json(buf, size, e);
 	default:
 		break;
 	}
diff --git a/src/expr/payload.c b/src/expr/payload.c
index ae72fa2..2111c47 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -167,6 +167,36 @@ nft_rule_expr_payload_parse(struct nft_rule_expr *=
e, struct nlattr *attr)
 }
=20
 static int
+nft_rule_expr_payload_snprintf_json(char *buf, size_t len, uint32_t fl=
ags,
+				   struct nft_expr_payload *p)
+{
+	int size =3D len, offset =3D 0, ret;
+
+	ret =3D snprintf(buf, len, "\"dreg\" : %u, \"offset\" : %u, \"len\" :=
 %u, ",
+					p->dreg, p->offset, p->len);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	switch (p->base) {
+	case NFT_PAYLOAD_LL_HEADER:
+		ret =3D snprintf(buf+offset, len, "\"base\" : \"link\"");
+		break;
+	case NFT_PAYLOAD_NETWORK_HEADER:
+		ret =3D snprintf(buf+offset, len, "\"base\" : \"network\"");
+		break;
+	case NFT_PAYLOAD_TRANSPORT_HEADER:
+		ret =3D snprintf(buf+offset, len, "\"base\" : \"transport\"");
+		break;
+	default:
+		ret =3D snprintf(buf+offset, len, "\"base\" : \"unknown\"");
+		break;
+	}
+
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+static int
 nft_rule_expr_payload_xml_parse(struct nft_rule_expr *e, char *xml)
 {
 #ifdef XML_PARSING
@@ -304,13 +334,16 @@ nft_rule_expr_payload_snprintf(char *buf, size_t =
len, uint32_t type,
 	struct nft_expr_payload *payload =3D (struct nft_expr_payload *)e->da=
ta;
=20
 	switch(type) {
-	case NFT_RULE_O_XML:
-		return nft_rule_expr_payload_snprintf_xml(buf, len, flags,
-							  payload);
 	case NFT_RULE_O_DEFAULT:
 		return snprintf(buf, len, "dreg=3D%u base=3D%u offset=3D%u len=3D%u =
",
 				payload->dreg, payload->base,
 				payload->offset, payload->len);
+	case NFT_RULE_O_XML:
+		return nft_rule_expr_payload_snprintf_xml(buf, len, flags,
+							  payload);
+	case NFT_RULE_O_JSON:
+		return nft_rule_expr_payload_snprintf_json(buf, len, flags,
+							  payload);
 	default:
 		break;
 	}
diff --git a/src/expr/target.c b/src/expr/target.c
index ed29f6d..0ad39d5 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -228,6 +228,19 @@ nft_rule_expr_target_xml_parse(struct nft_rule_exp=
r *e, char *xml)
 }
=20
 static
+int nft_rule_exp_target_snprintf_json(char *buf, size_t len,
+				struct nft_expr_target *tg)
+{
+	int ret, size =3D len, offset =3D 0;
+
+	ret =3D snprintf(buf, len, "\"name\" : \"%s\"",
+			tg->name);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+static
 int nft_rule_exp_target_snprintf_xml(char *buf, size_t len,
 				struct nft_expr_target *tg)
 {
@@ -247,11 +260,13 @@ nft_rule_expr_target_snprintf(char *buf, size_t l=
en, uint32_t type,
 	struct nft_expr_target *target =3D (struct nft_expr_target *)e->data;
=20
 	switch(type) {
-	case NFT_RULE_O_XML:
-		return nft_rule_exp_target_snprintf_xml(buf, len, target);
 	case NFT_RULE_O_DEFAULT:
 		return snprintf(buf, len, "name=3D%s rev=3D%u ",
 				target->name, target->rev);
+	case NFT_RULE_O_XML:
+		return nft_rule_exp_target_snprintf_xml(buf, len, target);
+	case NFT_RULE_O_JSON:
+		return nft_rule_exp_target_snprintf_json(buf, len, target);
 	default:
 		break;
 	}
diff --git a/src/internal.h b/src/internal.h
index 23a3e59..55505be 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -22,6 +22,7 @@
 #define NFT_RULE_XML_VERSION 0
 #define NFT_TABLE_JSON_VERSION 0
 #define NFT_CHAIN_JSON_VERSION 0
+#define NFT_RULE_JSON_VERSION 0
=20
 const char *nft_family2str(uint32_t family);
 int nft_str2family(const char *family);
diff --git a/src/rule.c b/src/rule.c
index e792169..ca6981d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -668,6 +668,52 @@ int nft_rule_parse(struct nft_rule *r, enum nft_ru=
le_parse_type type, char *data
 }
 EXPORT_SYMBOL(nft_rule_parse);
=20
+static int nft_rule_snprintf_json(char *buf, size_t size, struct nft_r=
ule *r,
+					 uint32_t type, uint32_t flags)
+{
+	int ret, len =3D size, offset =3D 0;
+	struct nft_rule_expr *expr;
+
+	ret =3D snprintf(buf, size,
+				"{ \"rule\": { \"family\" : \"%s\", \"table\" : \"%s\", "
+				"\"chain\"  : \"%s\", \"handle\" : %llu, \"version\" : %d, ",
+				nft_family2str(r->family), r->table, r->chain,
+				(unsigned long long)r->handle,
+				NFT_RULE_JSON_VERSION);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret =3D snprintf(buf+offset, len, "\"rule_flags\" : %u, ",
+					r->rule_flags);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+=09
+	if(NFT_RULE_ATTR_COMPAT_PROTO !=3D 0 || NFT_RULE_ATTR_COMPAT_FLAGS !=3D=
 0){
+		ret =3D snprintf(buf+offset,len,"\"compat_flags\" : %u, "
+									  "\"compat_proto\" : %u, ",
+					r->compat.flags, r->compat.proto);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	ret =3D snprintf(buf+offset, len, "\"expr\" : [");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	list_for_each_entry(expr, &r->expr_list, head) {
+		ret =3D snprintf(buf+offset, len,
+				" { \"type\" : \"%s\", ", expr->ops->name);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		ret =3D expr->ops->snprintf(buf+offset, len, type, flags, expr);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		ret =3D snprintf(buf+offset, len, "},");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	}
+	ret =3D snprintf(buf+offset-1, len, "]}}");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
 static int nft_rule_snprintf_xml(char *buf, size_t size, struct nft_ru=
le *r,
 				 uint32_t type, uint32_t flags)
 {
@@ -739,10 +785,12 @@ int nft_rule_snprintf(char *buf, size_t size, str=
uct nft_rule *r,
 		       uint32_t type, uint32_t flags)
 {
 	switch(type) {
-	case NFT_RULE_O_XML:
-		return nft_rule_snprintf_xml(buf, size, r, type, flags);
 	case NFT_RULE_O_DEFAULT:
 		return nft_rule_snprintf_default(buf, size, r, type, flags);
+	case NFT_RULE_O_XML:
+		return nft_rule_snprintf_xml(buf, size, r, type, flags);
+	case NFT_RULE_O_JSON:
+		return nft_rule_snprintf_json(buf, size, r, type, flags);
 	default:
 		break;
 	}
diff --git a/src/table.c b/src/table.c
index dc0c2a1..982d101 100644
--- a/src/table.c
+++ b/src/table.c
@@ -367,12 +367,12 @@ int nft_table_snprintf(char *buf, size_t size, st=
ruct nft_table *t,
 		       uint32_t type, uint32_t flags)
 {
 	switch(type) {
+	case NFT_TABLE_O_DEFAULT:
+		return nft_table_snprintf_default(buf, size, t);
 	case NFT_TABLE_O_XML:
 		return nft_table_snprintf_xml(buf, size, t);
 	case NFT_TABLE_O_JSON:
 		return nft_table_snprintf_json(buf, size, t);
-	case NFT_TABLE_O_DEFAULT:
-		return nft_table_snprintf_default(buf, size, t);
 	default:
 		break;
 	}

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
