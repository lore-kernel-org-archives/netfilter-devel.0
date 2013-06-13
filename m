From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 1/2] Add function for exporting rule to JSON format
Date: Thu, 13 Jun 2013 20:50:17 +0200
Message-ID: <20130613185017.423.47991.stgit@Ph0enix>
References: <20130613184810.423.11555.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:64996 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759105Ab3FMSu0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:50:26 -0400
Received: by mail-we0-f178.google.com with SMTP id u53so8135437wes.23
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Jun 2013 11:50:25 -0700 (PDT)
Received: from [127.0.1.1] (85.136.70.56.dyn.user.ono.com. [85.136.70.56])
        by mx.google.com with ESMTPSA id dj7sm12072918wib.6.2013.06.13.11.50.24
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 13 Jun 2013 11:50:24 -0700 (PDT)
In-Reply-To: <20130613184810.423.11555.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 include/libnftables/rule.h |    1 +
 src/expr/bitwise.c         |   33 ++++++++++++++++++++++++++++++
 src/expr/byteorder.c       |   21 +++++++++++++++++++
 src/expr/cmp.c             |   21 +++++++++++++++++++
 src/expr/counter.c         |    4 ++++
 src/expr/ct.c              |    5 ++++
 src/expr/data_reg.c        |   49 ++++++++++++++++++++++++++++++++++++=
++++++++
 src/expr/exthdr.c          |    7 ++++++
 src/expr/immediate.c       |   36 ++++++++++++++++++++++++++++++++
 src/expr/limit.c           |    4 ++++
 src/expr/log.c             |    7 ++++++
 src/expr/lookup.c          |   16 ++++++++++++++
 src/expr/match.c           |   25 ++++++++++++++++++++++
 src/expr/meta.c            |    4 ++++
 src/expr/nat.c             |   44 ++++++++++++++++++++++++++++++++++++=
++++
 src/expr/payload.c         |    6 +++++
 src/expr/target.c          |   26 +++++++++++++++++++++++
 src/internal.h             |    1 +
 src/rule.c                 |   44 ++++++++++++++++++++++++++++++++++++=
++++
 19 files changed, 354 insertions(+)

diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index 9989f19..3287c27 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -42,6 +42,7 @@ void nft_rule_nlmsg_build_payload(struct nlmsghdr *nl=
h, struct nft_rule *t);
 enum {
 	NFT_RULE_O_DEFAULT	=3D 0,
 	NFT_RULE_O_XML,
+	NFT_RULE_O_JSON,
 };
=20
 enum nft_rule_parse_type {
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 9ebe3dc..eda452d 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -306,6 +306,37 @@ nft_rule_expr_bitwise_xml_parse(struct nft_rule_ex=
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
@@ -370,6 +401,8 @@ nft_rule_expr_bitwise_snprintf(char *buf, size_t si=
ze, uint32_t type,
 	struct nft_expr_bitwise *bitwise =3D (struct nft_expr_bitwise *)e->da=
ta;
=20
 	switch(type) {
+	case NFT_RULE_O_JSON:
+		return nft_rule_expr_bitwise_snprintf_json(buf, size, bitwise);
 	case NFT_RULE_O_XML:
 		return nft_rule_expr_bitwise_snprintf_xml(buf, size, bitwise);
 	case NFT_RULE_O_DEFAULT:
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index 9d75824..4e0d9d7 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -285,6 +285,24 @@ err:
 }
=20
 static int
+nft_rule_expr_byteorder_snprintf_json(char *buf, size_t size,
+				   struct nft_expr_byteorder *byteorder)
+{
+	int len =3D size, offset =3D 0, ret;
+
+	ret =3D snprintf(buf, len, "\"sreg\" : %u, "
+				 "\"dreg\" : %u, "
+				 "\"op\" : %u, "
+				 "\"len\" : %u, "
+				 "\"size\" : %u",
+		       byteorder->sreg, byteorder->dreg, byteorder->op,
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
@@ -329,6 +347,9 @@ nft_rule_expr_byteorder_snprintf(char *buf, size_t =
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
index 673f3e0..5d3ddeb 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -259,6 +259,25 @@ static int nft_rule_expr_cmp_xml_parse(struct nft_=
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
@@ -300,6 +319,8 @@ nft_rule_expr_cmp_snprintf(char *buf, size_t size, =
uint32_t type,
 {
 	struct nft_expr_cmp *cmp =3D (struct nft_expr_cmp *)e->data;
 	switch(type) {
+	case NFT_RULE_O_JSON:
+		return nft_rule_expr_cmp_snprintf_json(buf, size, cmp);
 	case NFT_RULE_O_XML:
 		return nft_rule_expr_cmp_snprintf_xml(buf, size, cmp);
 	case NFT_RULE_O_DEFAULT:
diff --git a/src/expr/counter.c b/src/expr/counter.c
index 129f32e..5e17bd9 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -193,6 +193,10 @@ nft_rule_expr_counter_snprintf(char *buf, size_t l=
en, uint32_t type,
 	struct nft_expr_counter *ctr =3D (struct nft_expr_counter *)e->data;
=20
 	switch(type) {
+
+	case NFT_RULE_O_JSON:
+		return snprintf(buf, len, "\"pkts\" : %lu, \"bytes\" : %lu",
+				ctr->pkts, ctr->bytes);
 	case NFT_RULE_O_XML:
 		return snprintf(buf, len, "<pkts>%lu</pkts><bytes>%lu</bytes>",
 				ctr->pkts, ctr->bytes);
diff --git a/src/expr/ct.c b/src/expr/ct.c
index 4042926..d6cde67 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -228,6 +228,11 @@ nft_rule_expr_ct_snprintf(char *buf, size_t len, u=
int32_t type,
 					  "<key>%u</key>"
 					  "<dir>%u</dir>",
 				ct->dreg, ct->key, ct->dir);
+	case NFT_RULE_O_JSON:
+		return snprintf(buf, len, "\"dreg\" : %u, "
+					  "\"key\" : %u, "
+					  "\"dir\" : %u",
+				ct->dreg, ct->key, ct->dir);
 	default:
 		break;
 	}
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 5eb7f38..e5bd2fc 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -254,6 +254,42 @@ int nft_data_reg_xml_parse(union nft_data_reg *reg=
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
+	uint8_t *tmp;
+	int data_len =3D reg->len/sizeof(uint32_t);
+
+	ret =3D snprintf(buf, len, "\"data_reg\": { \"type\" : \"value\", ");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret =3D snprintf(buf+offset, len, "\"len\" : %d, ", data_len);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	for (i=3D0; i<data_len; i++) {
+		ret =3D snprintf(buf+offset, len, "\"data%d\" : \"0x", i);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		tmp =3D (uint8_t *)&reg->val[i];
+
+		for (j=3D0; j<sizeof(int); j++) {
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
@@ -309,6 +345,9 @@ int nft_data_reg_snprintf(char *buf, size_t size, u=
nion nft_data_reg *reg,
 	switch(reg_type) {
 	case DATA_VALUE:
 		switch(output_format) {
+		case NFT_RULE_O_JSON:
+			return nft_data_reg_value_snprintf_json(buf, size,
+							       reg, flags);
 		case NFT_RULE_O_XML:
 			return nft_data_reg_value_snprintf_xml(buf, size,
 							       reg, flags);
@@ -320,6 +359,11 @@ int nft_data_reg_snprintf(char *buf, size_t size, =
union nft_data_reg *reg,
 		}
 	case DATA_VERDICT:
 		switch(output_format) {
+		case NFT_RULE_O_JSON:
+			return snprintf(buf, size,
+					"\"data_reg\": { \"type\" : \"verdict\", "
+						"\"verdict\" : %d"
+					"}", reg->verdict);
 		case NFT_RULE_O_XML:
 			return snprintf(buf, size,
 					"<data_reg type=3D\"verdict\">"
@@ -332,6 +376,11 @@ int nft_data_reg_snprintf(char *buf, size_t size, =
union nft_data_reg *reg,
 		}
 	case DATA_CHAIN:
 		switch(output_format) {
+		case NFT_RULE_O_JSON:
+			return snprintf(buf, size,
+					"\"data_reg\": { \"type\" : \"chain\", "
+						"\"chain\" : %d"
+					"}", reg->verdict);
 		case NFT_RULE_O_XML:
 			return snprintf(buf, size,
 					"<data_reg type=3D\"chain\">"
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index fb3f7ad..5d564ec 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -262,6 +262,13 @@ nft_rule_expr_exthdr_snprintf(char *buf, size_t le=
n, uint32_t type,
 	struct nft_expr_exthdr *exthdr =3D (struct nft_expr_exthdr *)e->data;
=20
 	switch(type) {
+	case NFT_RULE_O_JSON:
+		return snprintf(buf, len, "\"dreg\" : %u, "
+					  "\"type\" : %u, \"offset\" : %u, "
+					  "\"len\" : %u",
+					exthdr->dreg, exthdr->type,
+					exthdr->offset, exthdr->len);
+
 	case NFT_RULE_O_XML:
 		return snprintf(buf, len, "<dreg>%u</dreg>"
 					  "<type>%u</type><offset>%u</offset>"
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 295054d..6a79476 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -295,6 +295,40 @@ nft_rule_expr_immediate_xml_parse(struct nft_rule_=
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
@@ -362,6 +396,8 @@ nft_rule_expr_immediate_snprintf(char *buf, size_t =
len, uint32_t type,
 				 uint32_t flags, struct nft_rule_expr *e)
 {
 	switch(type) {
+	case NFT_RULE_O_JSON:
+		return nft_rule_expr_immediate_snprintf_json(buf, len, e, flags);
 	case NFT_RULE_O_XML:
 		return nft_rule_expr_immediate_snprintf_xml(buf, len, e, flags);
 	case NFT_RULE_O_DEFAULT:
diff --git a/src/expr/limit.c b/src/expr/limit.c
index 64a5b70..78798d6 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -194,6 +194,10 @@ nft_rule_expr_limit_snprintf(char *buf, size_t len=
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
index 0e35a65..f7e7558 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -262,6 +262,13 @@ nft_rule_expr_log_snprintf(char *buf, size_t len, =
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
index 6d2b9a2..ba56b78 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -228,6 +228,20 @@ nft_rule_expr_lookup_xml_parse(struct nft_rule_exp=
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
@@ -260,6 +274,8 @@ nft_rule_expr_lookup_snprintf(char *buf, size_t siz=
e, uint32_t type,
 	struct nft_expr_lookup *lookup =3D (struct nft_expr_lookup *)e->data;
=20
 	switch(type) {
+	case NFT_RULE_O_JSON:
+		return nft_rule_expr_lookup_snprintf_json(buf, size, lookup);
 	case NFT_RULE_O_XML:
 		return nft_rule_expr_lookup_snprintf_xml(buf, size, lookup);
 	case NFT_RULE_O_DEFAULT:
diff --git a/src/expr/match.c b/src/expr/match.c
index edb78ea..8b98386 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -241,6 +241,29 @@ static int nft_rule_expr_match_xml_parse(struct nf=
t_rule_expr *e, char *xml)
 #endif
 }
=20
+static int nft_rule_expr_match_snprintf_json(char *buf, size_t len,
+					    struct nft_expr_match *mt)
+{
+	int ret, size=3Dlen;
+	int i;
+	int offset =3D 0;
+	uint8_t *data =3D (uint8_t *)mt->data;
+
+	ret =3D snprintf(buf, len, "\"name\" : \"%s\", \"rev\" : %u, \"info\"=
 : 0x",
+				mt->name, mt->rev);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	for (i=3D0; i < mt->data_len; i++) {
+	        ret =3D snprintf(buf+offset, len, "%x", data[i] & 0xff);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	ret =3D snprintf(buf+offset, len, "\"");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
 static int nft_rule_expr_match_snprintf_xml(char *buf, size_t len,
 					    struct nft_expr_match *mt)
 {
@@ -272,6 +295,8 @@ nft_rule_expr_match_snprintf(char *buf, size_t len,=
 uint32_t type,
 	struct nft_expr_match *match =3D (struct nft_expr_match *)e->data;
=20
 	switch(type) {
+	case NFT_RULE_O_JSON:
+		return nft_rule_expr_match_snprintf_json(buf, len, match);
 	case NFT_RULE_O_XML:
 		return nft_rule_expr_match_snprintf_xml(buf, len, match);
 	case NFT_RULE_O_DEFAULT:
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 6316a49..df0c2ee 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -196,6 +196,10 @@ nft_rule_expr_meta_snprintf(char *buf, size_t len,=
 uint32_t type,
 	struct nft_expr_meta *meta =3D (struct nft_expr_meta *)e->data;
=20
 	switch(type) {
+	case NFT_RULE_O_JSON:
+		return snprintf(buf, len, "\"dreg\" : %u, "
+					  "\"key\" : %u",
+				meta->dreg, meta->key);
 	case NFT_RULE_O_XML:
 		return snprintf(buf, len, "<dreg>%u</dreg>"
 					  "<key>%u</key>",
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 5d924cf..182448d 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -328,6 +328,48 @@ static int nft_rule_expr_nat_xml_parse(struct nft_=
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
+	switch (nat->type) {
+	case NFT_NAT_SNAT:
+		ret =3D snprintf(buf, len,
+			"\"type\" : \"NFT_NAT_SNAT\", ");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		break;
+	case NFT_NAT_DNAT:
+		ret =3D snprintf(buf, len,
+			"\"type\" : \"NFT_NAT_DNAT\", ");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		break;
+	}
+
+	ret =3D snprintf(buf, len, "\"family\" : \"%s\", ",
+		       nat->family =3D=3D AF_INET ? "AF_INET" : "AF_INET6");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if (e->flags & (1 << NFT_EXPR_NAT_REG_ADDR_MIN)) {
+		ret =3D snprintf(buf, len, "\"sreg_addr_min_v4\" : %u, "
+				" \"sreg_addr_max_v4\" : %u, ",
+			       nat->sreg_addr_min, nat->sreg_addr_max);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (e->flags & (1 << NFT_EXPR_NAT_REG_PROTO_MIN)) {
+		ret =3D snprintf(buf, len, "\"sreg_proto_min\" : %u, "
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
@@ -412,6 +454,8 @@ nft_rule_expr_nat_snprintf(char *buf, size_t size, =
uint32_t type,
 			   uint32_t flags, struct nft_rule_expr *e)
 {
 	switch (type) {
+	case NFT_RULE_O_JSON:
+		return nft_rule_expr_nat_snprintf_json(buf, size, e);
 	case NFT_RULE_O_XML:
 		return nft_rule_expr_nat_snprintf_xml(buf, size, e);
 	case NFT_RULE_O_DEFAULT:
diff --git a/src/expr/payload.c b/src/expr/payload.c
index ecb1bce..4f114a6 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -257,6 +257,12 @@ nft_rule_expr_payload_snprintf(char *buf, size_t l=
en, uint32_t type,
 	struct nft_expr_payload *payload =3D (struct nft_expr_payload *)e->da=
ta;
=20
 	switch(type) {
+	case NFT_RULE_O_JSON:
+		return snprintf(buf, len, "\"dreg\" : %u, "
+					  "\"base\" : %u, \"offset\" : %u, "
+					  "\"len\" : %u ",
+				payload->dreg, payload->base,
+					payload->offset, payload->len);
 	case NFT_RULE_O_XML:
 		return snprintf(buf, len, "<dreg>%u</dreg>"
 					  "<base>%u</base><offset>%u</offset>"
diff --git a/src/expr/target.c b/src/expr/target.c
index 6652c47..f534cfe 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -245,6 +245,30 @@ nft_rule_expr_target_xml_parse(struct nft_rule_exp=
r *e, char *xml)
 }
=20
 static
+int nft_rule_exp_target_snprintf_json(char *buf, size_t len,
+				struct nft_expr_target *tg)
+{
+	int ret, size=3Dlen;
+	int i;
+	int offset =3D 0;
+	uint8_t *data =3D (uint8_t *)tg->data;
+
+	ret =3D snprintf(buf, len, "\"name\" : \"%s\",\"rev\" : %u,\"info\" :=
 \"0x",
+			tg->name, tg->rev);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	for (i=3D0; i < tg->data_len; i++) {
+		ret =3D snprintf(buf+offset, len, "%x", data[i] & 0xff);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	ret =3D snprintf(buf+offset, len, "\"");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+static
 int nft_rule_exp_target_snprintf_xml(char *buf, size_t len,
 				struct nft_expr_target *tg)
 {
@@ -275,6 +299,8 @@ nft_rule_expr_target_snprintf(char *buf, size_t len=
, uint32_t type,
 	struct nft_expr_target *target =3D (struct nft_expr_target *)e->data;
=20
 	switch(type) {
+	case NFT_RULE_O_JSON:
+		return nft_rule_exp_target_snprintf_json(buf, len, target);
 	case NFT_RULE_O_XML:
 		return nft_rule_exp_target_snprintf_xml(buf, len, target);
 	case NFT_RULE_O_DEFAULT:
diff --git a/src/internal.h b/src/internal.h
index 769926b..8e2e26d 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -22,6 +22,7 @@
 #define NFT_RULE_XML_VERSION 0
 #define NFT_TABLE_JSON_VERSION 0
 #define NFT_CHAIN_JSON_VERSION 0
+#define NFT_RULE_JSON_VERSION 0
=20
 struct expr_ops;
=20
diff --git a/src/rule.c b/src/rule.c
index 4c1672d..34b9a27 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -665,6 +665,48 @@ int nft_rule_parse(struct nft_rule *r, enum nft_ru=
le_parse_type type, char *data
 }
 EXPORT_SYMBOL(nft_rule_parse);
=20
+static int nft_rule_snprintf_json(char *buf, size_t size, struct nft_r=
ule *r,
+				 uint32_t type, uint32_t flags)
+{
+	int ret, len =3D size, offset =3D 0;
+	struct nft_rule_expr *expr;
+
+ret =3D snprintf(buf, size,
+		"{ \"rule\": { \"family\" : %u, \"table\" : \"%s\", "
+			"\"chain\"  : \"%s\", \"handle\" : %llu, \"version\" : %d, ",
+				r->family, r->table, r->chain,
+				(unsigned long long)r->handle,
+				NFT_RULE_JSON_VERSION);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret =3D snprintf(buf+offset, len, "\"rule_flags\" : %u, "
+					"\"compat_flags\" : %u, "
+					"\"compat_proto\" : %u, ",
+					r->rule_flags,
+					r->compat.flags, r->compat.proto);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
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
@@ -731,6 +773,8 @@ int nft_rule_snprintf(char *buf, size_t size, struc=
t nft_rule *r,
 		       uint32_t type, uint32_t flags)
 {
 	switch(type) {
+	case NFT_RULE_O_JSON:
+		return nft_rule_snprintf_json(buf, size, r, type, flags);
 	case NFT_RULE_O_XML:
 		return nft_rule_snprintf_xml(buf, size, r, type, flags);
 	case NFT_RULE_O_DEFAULT:

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
