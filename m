From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH] json: remove space in Json output support
Date: Sun, 13 Oct 2013 21:52:34 +0200
Message-ID: <20131013195233.6261.62757.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:47696 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205Ab3JMTxI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Oct 2013 15:53:08 -0400
Received: by mail-wg0-f45.google.com with SMTP id z12so4513587wgg.24
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Oct 2013 12:53:06 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Remove all the spaces inside JSON output support for reducing size
of output buffer and create consistence with table, chain, rule
and set.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/chain.c                            |   24 ++++++++++++------------
 src/expr/bitwise.c                     |   10 +++++-----
 src/expr/byteorder.c                   |   10 +++++-----
 src/expr/cmp.c                         |    2 +-
 src/expr/counter.c                     |    2 +-
 src/expr/ct.c                          |    6 +++---
 src/expr/data_reg.c                    |   20 ++++++++++----------
 src/expr/exthdr.c                      |    6 +++---
 src/expr/immediate.c                   |    4 ++--
 src/expr/limit.c                       |    4 ++--
 src/expr/log.c                         |    8 ++++----
 src/expr/lookup.c                      |    2 +-
 src/expr/match.c                       |    2 +-
 src/expr/meta.c                        |    4 ++--
 src/expr/nat.c                         |   16 +++++++---------
 src/expr/payload.c                     |    8 ++++----
 src/expr/target.c                      |    2 +-
 src/rule.c                             |   18 ++++++++----------
 src/ruleset.c                          |    2 +-
 src/set.c                              |   16 ++++++++--------
 src/set_elem.c                         |    6 +++---
 src/table.c                            |    8 ++++----
 tests/jsonfiles/01-table.json          |    2 +-
 tests/jsonfiles/02-table.json          |    2 +-
 tests/jsonfiles/11-chain.json          |    2 +-
 tests/jsonfiles/12-chain.json          |    2 +-
 tests/jsonfiles/13-chain.json          |    2 +-
 tests/jsonfiles/14-chain.json          |    2 +-
 tests/jsonfiles/20-rule-bitwise.json   |    2 +-
 tests/jsonfiles/21-rule-byteorder.json |    2 +-
 tests/jsonfiles/22-rule-cmp.json       |    2 +-
 tests/jsonfiles/23-rule-counter.json   |    2 +-
 tests/jsonfiles/24-rule-ct.json        |    2 +-
 tests/jsonfiles/25-rule-exthdr.json    |    2 +-
 tests/jsonfiles/26-rule-immediate.json |    2 +-
 tests/jsonfiles/27-rule-limit.json     |    2 +-
 tests/jsonfiles/28-rule-log.json       |    2 +-
 tests/jsonfiles/29-rule-match.json     |    2 +-
 tests/jsonfiles/30-rule-lookup.json    |    2 +-
 tests/jsonfiles/31-rule-meta.json      |    2 +-
 tests/jsonfiles/32-rule-nat4.json      |    2 +-
 tests/jsonfiles/33-rule-nat6.json      |    2 +-
 tests/jsonfiles/34-rule-payload.json   |    2 +-
 tests/jsonfiles/35-rule-target.json    |    2 +-
 tests/jsonfiles/36-rule-real.json      |    2 +-
 tests/jsonfiles/37-rule-real.json      |    2 +-
 tests/jsonfiles/38-rule-real.json      |    2 +-
 tests/jsonfiles/39-rule-real.json      |    2 +-
 tests/jsonfiles/40-rule-real.json      |    2 +-
 tests/jsonfiles/41-rule-real.json      |    2 +-
 tests/jsonfiles/42-rule-real.json      |    2 +-
 tests/jsonfiles/43-rule-real.json      |    2 +-
 tests/jsonfiles/44-rule-real.json      |    2 +-
 tests/jsonfiles/45-rule-real.json      |    2 +-
 tests/jsonfiles/46-rule-real.json      |    2 +-
 tests/jsonfiles/47-rule-real.json      |    2 +-
 tests/jsonfiles/48-rule-real.json      |    2 +-
 tests/jsonfiles/49-rule-real.json      |    2 +-
 tests/jsonfiles/50-rule-real.json      |    2 +-
 tests/jsonfiles/51-rule-real.json      |    2 +-
 tests/jsonfiles/52-rule-real.json      |    2 +-
 tests/jsonfiles/53-rule-real.json      |    2 +-
 tests/jsonfiles/54-rule-real.json      |    2 +-
 tests/jsonfiles/55-rule-real.json      |    2 +-
 tests/jsonfiles/56-rule-real.json      |    2 +-
 tests/jsonfiles/57-rule-real.json      |    2 +-
 tests/jsonfiles/58-rule-real.json      |    2 +-
 tests/jsonfiles/59-rule-real.json      |    2 +-
 tests/jsonfiles/60-rule-real.json      |    2 +-
 tests/jsonfiles/61-rule-real.json      |    2 +-
 tests/jsonfiles/62-set.json            |    2 +-
 tests/jsonfiles/63-set.json            |    2 +-
 tests/jsonfiles/64-ruleset.json        |    2 +-
 73 files changed, 139 insertions(+), 143 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index f831479..6179f68 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -754,14 +754,14 @@ static int nft_chain_snprintf_json(char *buf, siz=
e_t size, struct nft_chain *c)
 	int ret, len =3D size, offset =3D 0;
=20
 	ret =3D snprintf(buf, len,
-		"{ \"chain\": {"
-			"\"name\": \"%s\","
-			"\"handle\": %"PRIu64","
-			"\"bytes\": %"PRIu64","
-			"\"packets\": %"PRIu64","
-			"\"family\": \"%s\","
-			"\"table\": \"%s\","
-			"\"use\": %d",
+			"{\"chain\":{"
+			"\"name\":\"%s\","
+			"\"handle\":%"PRIu64","
+			"\"bytes\":%"PRIu64","
+			"\"packets\":%"PRIu64","
+			"\"family\":\"%s\","
+			"\"table\":\"%s\","
+			"\"use\":%d",
 			c->name, c->handle, c->bytes, c->packets,
 			nft_family2str(c->family),
 			c->table, c->use);
@@ -769,10 +769,10 @@ static int nft_chain_snprintf_json(char *buf, siz=
e_t size, struct nft_chain *c)
=20
 	if (c->flags & (1 << NFT_CHAIN_ATTR_HOOKNUM)) {
 		ret =3D  snprintf(buf+offset, len,
-				",\"type\": \"%s\","
-				"\"hooknum\": \"%s\","
-				"\"prio\": %d,"
-				"\"policy\": \"%s\"",
+				",\"type\":\"%s\","
+				"\"hooknum\":\"%s\","
+				"\"prio\":%d,"
+				"\"policy\":\"%s\"",
 			c->type, nft_hooknum2str(c->family, c->hooknum),
 			c->prio, nft_verdict2str(c->policy));
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index f293069..0be1593 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -283,20 +283,20 @@ nft_rule_expr_bitwise_snprintf_json(char *buf, si=
ze_t size,
 {
 	int len =3D size, offset =3D 0, ret;
=20
-	ret =3D snprintf(buf, len, "\"sreg\" : %u, "
-				"\"dreg\" : %u, "
-				"\"len\" : %u, ",
+	ret =3D snprintf(buf, len, "\"sreg\":%u,"
+				 "\"dreg\":%u,"
+				 "\"len\":%u,",
 		       bitwise->sreg, bitwise->dreg, bitwise->len);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
-	ret =3D snprintf(buf+offset, len, "\"mask\" : {");
+	ret =3D snprintf(buf+offset, len, "\"mask\":{");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D nft_data_reg_snprintf(buf+offset, len, &bitwise->mask,
 				    NFT_RULE_O_JSON, 0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
-	ret =3D snprintf(buf+offset, len, "}, \"xor\" : {");
+	ret =3D snprintf(buf+offset, len, "},\"xor\":{");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D nft_data_reg_snprintf(buf+offset, len, &bitwise->xor,
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index f05ddb5..7012452 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -298,11 +298,11 @@ nft_rule_expr_byteorder_snprintf_json(char *buf, =
size_t size,
 {
 	int len =3D size, offset =3D 0, ret;
=20
-	ret =3D snprintf(buf, len, "\"sreg\" : %u, "
-				 "\"dreg\" : %u, "
-				 "\"op\" : \"%s\", "
-				 "\"len\" : %u, "
-				 "\"size\" : %u",
+	ret =3D snprintf(buf, len, "\"sreg\":%u,"
+				 "\"dreg\":%u,"
+				 "\"op\":\"%s\","
+				 "\"len\":%u,"
+				 "\"size\":%u",
 		       byteorder->sreg, byteorder->dreg,
 		       expr_byteorder_str[byteorder->op],
 		       byteorder->len, byteorder->size);
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index c6789b6..7de7226 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -253,7 +253,7 @@ nft_rule_expr_cmp_snprintf_json(char *buf, size_t s=
ize, struct nft_expr_cmp *cmp
 {
 	int len =3D size, offset =3D 0, ret;
=20
-	ret =3D snprintf(buf, len, "\"sreg\" : %u, \"op\" : \"%s\", \"cmpdata=
\" : {",
+	ret =3D snprintf(buf, len, "\"sreg\":%u,\"op\":\"%s\",\"cmpdata\":{",
 		       cmp->sreg, expr_cmp_str[cmp->op]);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
diff --git a/src/expr/counter.c b/src/expr/counter.c
index bba9261..561f26c 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -180,7 +180,7 @@ nft_rule_expr_counter_snprintf(char *buf, size_t le=
n, uint32_t type,
 		return snprintf(buf, len, "<pkts>%"PRIu64"</pkts><bytes>%"PRIu64"</b=
ytes>",
 				ctr->pkts, ctr->bytes);
 	case NFT_RULE_O_JSON:
-		return snprintf(buf, len, "\"pkts\" : %"PRIu64", \"bytes\" : %"PRIu6=
4"",
+		return snprintf(buf, len, "\"pkts\":%"PRIu64",\"bytes\":%"PRIu64"",
 				ctr->pkts, ctr->bytes);
 	default:
 		break;
diff --git a/src/expr/ct.c b/src/expr/ct.c
index bf18c7e..e84d996 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -279,17 +279,17 @@ nft_expr_ct_snprintf_json(char *buf, size_t size,=
 struct nft_rule_expr *e)
 	int ret, len =3D size, offset =3D 0;
 	struct nft_expr_ct *ct =3D nft_expr_data(e);
=20
-	ret =3D snprintf(buf, len, "\"dreg\" : %u", ct->dreg);
+	ret =3D snprintf(buf, len, "\"dreg\":%u", ct->dreg);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	if (e->flags & (1 << NFT_EXPR_CT_KEY)) {
-		ret =3D snprintf(buf+offset, len, ", \"key\" : \"%s\"",
+		ret =3D snprintf(buf+offset, len, ",\"key\":\"%s\"",
 						ctkey2str(ct->key));
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
=20
 	if (e->flags & (1 << NFT_EXPR_CT_DIR)) {
-		ret =3D snprintf(buf+offset, len, ", \"dir\" : %u", ct->dir);
+		ret =3D snprintf(buf+offset, len, ",\"dir\":%u", ct->dir);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
=20
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 2b9ecee..193f3ab 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -216,14 +216,14 @@ nft_data_reg_value_snprintf_json(char *buf, size_=
t size,
 	uint32_t utemp;
 	uint8_t *tmp;
=20
-	ret =3D snprintf(buf, len, "\"data_reg\": { \"type\" : \"value\", ");
+	ret =3D snprintf(buf, len, "\"data_reg\":{\"type\":\"value\",");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
-	ret =3D snprintf(buf+offset, len, "\"len\" : %u, ", reg->len);
+	ret =3D snprintf(buf+offset, len, "\"len\":%u,", reg->len);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	for (i =3D 0; i < div_round_up(reg->len, sizeof(uint32_t)); i++) {
-		ret =3D snprintf(buf+offset, len, "\"data%d\" : \"0x", i);
+		ret =3D snprintf(buf+offset, len, "\"data%d\":\"0x", i);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 		utemp =3D htonl(reg->val[i]);
@@ -234,10 +234,10 @@ nft_data_reg_value_snprintf_json(char *buf, size_=
t size,
 			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		}
=20
-		ret =3D snprintf(buf+offset, len, "\", ");
+		ret =3D snprintf(buf+offset, len, "\",");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
-	offset -=3D 2;
+	offset--;
 	ret =3D snprintf(buf+offset, len, "}");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
@@ -324,9 +324,9 @@ int nft_data_reg_snprintf(char *buf, size_t size, u=
nion nft_data_reg *reg,
 					nft_verdict2str(reg->verdict));
 		case NFT_RULE_O_JSON:
 			return snprintf(buf, size,
-					"\"data_reg\": {"
-						"\"type\" : \"verdict\", "
-						"\"verdict\" : \"%s\""
+					"\"data_reg\":{"
+					"\"type\":\"verdict\","
+					"\"verdict\":\"%s\""
 					"}", nft_verdict2str(reg->verdict));
 		default:
 			break;
@@ -342,8 +342,8 @@ int nft_data_reg_snprintf(char *buf, size_t size, u=
nion nft_data_reg *reg,
 					"</data_reg>", reg->chain);
 		case NFT_RULE_O_JSON:
 			return snprintf(buf, size,
-					"\"data_reg\": { \"type\" : \"chain\", "
-						"\"chain\" : \"%s\""
+					"\"data_reg\":{\"type\":\"chain\","
+					"\"chain\":\"%s\""
 					"}", reg->chain);
 		default:
 			break;
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 1290f3f..32791d0 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -302,9 +302,9 @@ nft_rule_expr_exthdr_snprintf(char *buf, size_t len=
, uint32_t type,
 					exthdr_type2str(exthdr->type),
 					exthdr->offset, exthdr->len);
 	case NFT_RULE_O_JSON:
-		return snprintf(buf, len, "\"dreg\" : %u, "
-					  "\"exthdr_type\" : \"%s\", \"offset\" : %u, "
-					  "\"len\" : %u",
+		return snprintf(buf, len, "\"dreg\":%u,"
+					  "\"exthdr_type\":\"%s\",\"offset\":%u,"
+					  "\"len\":%u",
 					exthdr->dreg,
 					exthdr_type2str(exthdr->type),
 					exthdr->offset, exthdr->len);
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index e824801..cb3b209 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -261,8 +261,8 @@ nft_rule_expr_immediate_snprintf_json(char *buf, si=
ze_t len,
 	int size =3D len, offset =3D 0, ret;
 	struct nft_expr_immediate *imm =3D nft_expr_data(e);
=20
-	ret =3D snprintf(buf, len, "\"dreg\" : %u, "
-				"\"immediatedata\" : {", imm->dreg);
+	ret =3D snprintf(buf, len, "\"dreg\":%u,"
+				 "\"immediatedata\":{", imm->dreg);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
=20
diff --git a/src/expr/limit.c b/src/expr/limit.c
index 6954014..bdb0414 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -179,8 +179,8 @@ nft_rule_expr_limit_snprintf(char *buf, size_t len,=
 uint32_t type,
 					  "<depth>%"PRIu64"</depth>",
 				limit->rate, limit->depth);
 	case NFT_RULE_O_JSON:
-		return snprintf(buf, len, "\"rate\" : %"PRIu64", "
-					  "\"depth\" : %"PRIu64" ",
+		return snprintf(buf, len, "\"rate\":%"PRIu64","
+					  "\"depth\":%"PRIu64"",
 				limit->rate, limit->depth);
 	default:
 		break;
diff --git a/src/expr/log.c b/src/expr/log.c
index 0a8e86c..7722d62 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -256,10 +256,10 @@ nft_rule_expr_log_snprintf(char *buf, size_t len,=
 uint32_t type,
 				log->prefix, log->group,
 				log->snaplen, log->qthreshold);
 	case NFT_RULE_O_JSON:
-		return snprintf(buf, len, "\"prefix\" : \"%s\", "
-					  "\"group\" : %u, "
-					  "\"snaplen\" : %u, "
-					  "\"qthreshold\" : %u ",
+		return snprintf(buf, len, "\"prefix\":\"%s\","
+					  "\"group\":%u,"
+					  "\"snaplen\":%u,"
+					  "\"qthreshold\":%u",
 				log->prefix, log->group,
 				log->snaplen, log->qthreshold);
 	default:
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 1f10e15..e37e295 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -216,7 +216,7 @@ nft_rule_expr_lookup_snprintf_json(char *buf, size_=
t size,
 {
 	int len =3D size, offset =3D 0, ret;
=20
-	ret =3D snprintf(buf, len, "\"set\" : \"%s\", \"sreg\" : %u, \"dreg\"=
 : %u",
+	ret =3D snprintf(buf, len, "\"set\":\"%s\",\"sreg\":%u,\"dreg\":%u",
 			l->set_name, l->sreg, l->dreg);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
diff --git a/src/expr/match.c b/src/expr/match.c
index 91e59ff..c03ab12 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -218,7 +218,7 @@ static int nft_rule_expr_match_snprintf_json(char *=
buf, size_t len,
 {
 	int ret, size =3D len, offset =3D 0;
=20
-	ret =3D snprintf(buf, len, "\"name\" : \"%s\"",
+	ret =3D snprintf(buf, len, "\"name\":\"%s\"",
 				mt->name);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 98d83b0..beeb8ca 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -239,8 +239,8 @@ nft_rule_expr_meta_snprintf(char *buf, size_t len, =
uint32_t type,
 					  "<key>%s</key>",
 				meta->dreg, meta_key2str(meta->key));
 	case NFT_RULE_O_JSON:
-		return snprintf(buf, len, "\"dreg\" : %u, "
-					  "\"key\" : \"%s\"",
+		return snprintf(buf, len, "\"dreg\":%u,"
+					  "\"key\":\"%s\"",
 				meta->dreg, meta_key2str(meta->key));
 	default:
 		break;
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 3c40b93..7150eec 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -327,28 +327,26 @@ nft_rule_expr_nat_snprintf_json(char *buf, size_t=
 size,
 	int len =3D size, offset =3D 0, ret =3D 0;
=20
 	if (nat->type =3D=3D NFT_NAT_SNAT)
-		ret =3D snprintf(buf, len, "\"nat_type\" : \"snat\", ");
+		ret =3D snprintf(buf, len, "\"nat_type\":\"snat\",");
 	else if (nat->type =3D=3D NFT_NAT_DNAT)
-		ret =3D snprintf(buf, len, "\"nat_type\" : \"dnat\", ");
+		ret =3D snprintf(buf, len, "\"nat_type\":\"dnat\",");
=20
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
-	ret =3D snprintf(buf+offset, len, "\"family\" : \"%s\", ",
+	ret =3D snprintf(buf+offset, len, "\"family\":\"%s\",",
 		       nft_family2str(nat->family));
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	if (e->flags & (1 << NFT_EXPR_NAT_REG_ADDR_MIN)) {
-		ret =3D snprintf(buf+offset, len,
-				"\"sreg_addr_min\" : %u, "
-				"\"sreg_addr_max\" : %u, ",
+		ret =3D snprintf(buf+offset, len, "\"sreg_addr_min\":%u,"
+						"\"sreg_addr_max\":%u,",
 			       nat->sreg_addr_min, nat->sreg_addr_max);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
=20
 	if (e->flags & (1 << NFT_EXPR_NAT_REG_PROTO_MIN)) {
-		ret =3D snprintf(buf+offset, len,
-				"\"sreg_proto_min\" : %u, "
-				"\"sreg_proto_max\" : %u",
+		ret =3D snprintf(buf+offset, len, "\"sreg_proto_min\":%u,"
+						"\"sreg_proto_max\":%u",
 		       nat->sreg_proto_min, nat->sreg_proto_max);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
diff --git a/src/expr/payload.c b/src/expr/payload.c
index d76e2c4..390b8ef 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -169,10 +169,10 @@ nft_rule_expr_payload_snprintf_json(char *buf, si=
ze_t len, uint32_t flags,
 {
 	int size =3D len, offset =3D 0, ret;
=20
-	ret =3D snprintf(buf, len, "\"dreg\" : %u, "
-				 "\"offset\" : %u, "
-				 "\"len\" : %u, "
-				 "\"base\" : \"%s\"",
+	ret =3D snprintf(buf, len, "\"dreg\":%u,"
+				 "\"offset\":%u,"
+				 "\"len\":%u,"
+				 "\"base\":\"%s\"",
 		       p->dreg, p->offset, p->len, base2str(p->base));
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
diff --git a/src/expr/target.c b/src/expr/target.c
index 19eedde..43fb666 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -220,7 +220,7 @@ int nft_rule_exp_target_snprintf_json(char *buf, si=
ze_t len,
 {
 	int ret, size =3D len, offset =3D 0;
=20
-	ret =3D snprintf(buf, len, "\"name\" : \"%s\"",
+	ret =3D snprintf(buf, len, "\"name\":\"%s\"",
 			tg->name);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
diff --git a/src/rule.c b/src/rule.c
index 7f2bce6..9302dfb 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -705,37 +705,35 @@ static int nft_rule_snprintf_json(char *buf, size=
_t size, struct nft_rule *r,
 	int ret, len =3D size, offset =3D 0;
 	struct nft_rule_expr *expr;
=20
-	ret =3D snprintf(buf, len,
-		       "{ \"rule\": { \"family\" : \"%s\", \"table\" : \"%s\", "
-		       "\"chain\"  : \"%s\", \"handle\" : %llu,",
+	ret =3D snprintf(buf, len, "{\"rule\":{\"family\":\"%s\",\"table\":\"=
%s\","
+		       		 "\"chain\":\"%s\",\"handle\":%llu,",
 		       nft_family2str(r->family), r->table, r->chain,
 		       (unsigned long long)r->handle);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
-	ret =3D snprintf(buf+offset, len, "\"flags\" : %u, ", r->rule_flags);
+	ret =3D snprintf(buf+offset, len, "\"flags\":%u,", r->rule_flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	if (r->flags & (1 << NFT_RULE_ATTR_COMPAT_PROTO) ||
 	    r->flags & (1 << NFT_RULE_ATTR_COMPAT_FLAGS)) {
-		ret =3D snprintf(buf+offset, len, "\"compat_flags\" : %u, "
-					        "\"compat_proto\" : %u, ",
+		ret =3D snprintf(buf+offset, len, "\"compat_flags\":%u,"
+					        "\"compat_proto\":%u,",
 			       r->compat.flags, r->compat.proto);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
=20
 	if (r->flags & (1 << NFT_RULE_ATTR_POSITION)) {
-		ret =3D snprintf(buf+offset, len,
-			       "\"position\" : %"PRIu64", ",
+		ret =3D snprintf(buf+offset, len, "\"position\":%"PRIu64",",
 			       r->position);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
=20
-	ret =3D snprintf(buf+offset, len, "\"expr\" : [");
+	ret =3D snprintf(buf+offset, len, "\"expr\":[");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	list_for_each_entry(expr, &r->expr_list, head) {
 		ret =3D snprintf(buf+offset, len,
-			       " { \"type\" : \"%s\", ", expr->ops->name);
+			       "{\"type\":\"%s\",", expr->ops->name);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 		ret =3D expr->ops->snprintf(buf+offset, len, type, flags, expr);
diff --git a/src/ruleset.c b/src/ruleset.c
index 7fdfa4d..8944da6 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -783,7 +783,7 @@ nft_ruleset_snprintf_json(char *buf, size_t size, c=
onst struct nft_ruleset *rs,
 {
 	int ret, len =3D size, offset =3D 0;
=20
-	ret =3D snprintf(buf, size, "{ \"nftables\": [");
+	ret =3D snprintf(buf, size, "{\"nftables\":[");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D nft_ruleset_do_snprintf(buf+offset, len, rs, NFT_RULESET_O_JS=
ON,
diff --git a/src/set.c b/src/set.c
index 31185a0..74ec1e3 100644
--- a/src/set.c
+++ b/src/set.c
@@ -543,10 +543,10 @@ static int nft_set_snprintf_json(char *buf, size_=
t size, struct nft_set *s,
 	int len =3D size, offset =3D 0, ret;
 	struct nft_set_elem *elem;
=20
-	ret =3D snprintf(buf, len, "{ \"set\": { \"name\": \"%s\","
-				  "\"table\": \"%s\","
-				  "\"flags\": %u,\"family\": \"%s\","
-				  "\"key_type\": %u,\"key_len\": %u",
+	ret =3D snprintf(buf, len, "{\"set\":{\"name\":\"%s\","
+				  "\"table\":\"%s\","
+				  "\"flags\":%u,\"family\":\"%s\","
+				  "\"key_type\":%u,\"key_len\":%u",
 			s->name, s->table, s->set_flags,
 			nft_family2str(s->family), s->key_type, s->key_len);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
@@ -554,7 +554,7 @@ static int nft_set_snprintf_json(char *buf, size_t =
size, struct nft_set *s,
 	if(s->flags & (1 << NFT_SET_ATTR_DATA_TYPE) &&
 	   s->flags & (1 << NFT_SET_ATTR_DATA_LEN)){
 		ret =3D snprintf(buf+offset, len,
-				  ",\"data_type\": %u,\"data_len\": %u",
+				  ",\"data_type\":%u,\"data_len\":%u",
 			s->data_type, s->data_len);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
@@ -566,7 +566,7 @@ static int nft_set_snprintf_json(char *buf, size_t =
size, struct nft_set *s,
 		return offset;
 	}
=20
-	ret =3D snprintf(buf+offset, len, ",\"set_elem\": [");
+	ret =3D snprintf(buf+offset, len, ",\"set_elem\":[");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	list_for_each_entry(elem, &s->element_list, head) {
@@ -576,11 +576,11 @@ static int nft_set_snprintf_json(char *buf, size_=
t size, struct nft_set *s,
 		ret =3D nft_set_elem_snprintf(buf+offset, len, elem, type, flags);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
-		ret =3D snprintf(buf+offset, len, "}, ");
+		ret =3D snprintf(buf+offset, len, "},");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 	/* Overwrite trailing ", " from last set element */
-	offset -=3D 2;
+	offset --;
=20
 	ret =3D snprintf(buf+offset, len, "]}}");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
diff --git a/src/set_elem.c b/src/set_elem.c
index ba24c96..5bb82f6 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -454,10 +454,10 @@ static int nft_set_elem_snprintf_json(char *buf, =
size_t size,
 {
 	int ret, len =3D size, offset =3D 0, type =3D -1;
=20
-	ret =3D snprintf(buf, len, "\"flags\": %u", e->set_elem_flags);
+	ret =3D snprintf(buf, len, "\"flags\":%u", e->set_elem_flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
-	ret =3D snprintf(buf+offset, len, ",\"key\": {");
+	ret =3D snprintf(buf+offset, len, ",\"key\":{");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D nft_data_reg_snprintf(buf+offset, len, &e->key,
@@ -475,7 +475,7 @@ static int nft_set_elem_snprintf_json(char *buf, si=
ze_t size,
 		type =3D DATA_VERDICT;
=20
 	if (type !=3D -1) {
-		ret =3D snprintf(buf+offset, len, ",\"data\": {");
+		ret =3D snprintf(buf+offset, len, ",\"data\":{");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 		ret =3D nft_data_reg_snprintf(buf+offset, len, &e->data,
diff --git a/src/table.c b/src/table.c
index 7f14b32..d3ff188 100644
--- a/src/table.c
+++ b/src/table.c
@@ -349,10 +349,10 @@ EXPORT_SYMBOL(nft_table_parse);
 static int nft_table_snprintf_json(char *buf, size_t size, struct nft_=
table *t)
 {
 	return snprintf(buf, size,
-			"{\"table\" : {"
-			"\"name\" : \"%s\","
-			"\"family\" : \"%s\","
-			"\"flags\" : %d"
+			"{\"table\":{"
+			"\"name\":\"%s\","
+			"\"family\":\"%s\","
+			"\"flags\":%d"
 			"}"
 			"}" ,
 			t->name, nft_family2str(t->family), t->table_flags);
diff --git a/tests/jsonfiles/01-table.json b/tests/jsonfiles/01-table.j=
son
index b4fc91b..cfe7e9d 100644
--- a/tests/jsonfiles/01-table.json
+++ b/tests/jsonfiles/01-table.json
@@ -1 +1 @@
-{"table" : {"name" : "filter","family" : "ip","flags" : 0}}
+{"table":{"name":"filter","family":"ip","flags":0}}
diff --git a/tests/jsonfiles/02-table.json b/tests/jsonfiles/02-table.j=
son
index 01eff74..ddd119c 100644
--- a/tests/jsonfiles/02-table.json
+++ b/tests/jsonfiles/02-table.json
@@ -1 +1 @@
-{"table" : {"name" : "filter2","family" : "ip6","flags" : 0}}
+{"table":{"name":"filter2","family":"ip6","flags":0}}
diff --git a/tests/jsonfiles/11-chain.json b/tests/jsonfiles/11-chain.j=
son
index 2381eb6..e1ed07f 100644
--- a/tests/jsonfiles/11-chain.json
+++ b/tests/jsonfiles/11-chain.json
@@ -1 +1 @@
-{ "chain": {"name": "input","handle": 1,"bytes": 1375696,"packets": 41=
36,"family": "ip","table": "filter","use": 0,"type": "filter","hooknum"=
: "input","prio": 0,"policy": "accept"}}
+{"chain":{"name":"input","handle":1,"bytes":1375696,"packets":4136,"fa=
mily":"ip","table":"filter","use":0,"type":"filter","hooknum":"input","=
prio":0,"policy":"accept"}}
diff --git a/tests/jsonfiles/12-chain.json b/tests/jsonfiles/12-chain.j=
son
index d20cb1d..b3fa541 100644
--- a/tests/jsonfiles/12-chain.json
+++ b/tests/jsonfiles/12-chain.json
@@ -1 +1 @@
-{ "chain": {"name": "forward","handle": 2,"bytes": 0,"packets": 0,"fam=
ily": "ip","table": "filter","use": 0,"type": "filter","hooknum": "forw=
ard","prio": 0,"policy": "accept"}}
+{"chain":{"name":"forward","handle":2,"bytes":0,"packets":0,"family":"=
ip","table":"filter","use":0,"type":"filter","hooknum":"forward","prio"=
:0,"policy":"accept"}}
diff --git a/tests/jsonfiles/13-chain.json b/tests/jsonfiles/13-chain.j=
son
index 69f8750..6d8230d 100644
--- a/tests/jsonfiles/13-chain.json
+++ b/tests/jsonfiles/13-chain.json
@@ -1 +1 @@
-{ "chain": {"name": "output","handle": 3,"bytes": 454786,"packets": 26=
81,"family": "ip","table": "filter","use": 0,"type": "filter","hooknum"=
: "output","prio": 0,"policy": "accept"}}
+{"chain":{"name":"output","handle":3,"bytes":454786,"packets":2681,"fa=
mily":"ip","table":"filter","use":0,"type":"filter","hooknum":"output",=
"prio":0,"policy":"accept"}}
diff --git a/tests/jsonfiles/14-chain.json b/tests/jsonfiles/14-chain.j=
son
index 716d022..44bc106 100644
--- a/tests/jsonfiles/14-chain.json
+++ b/tests/jsonfiles/14-chain.json
@@ -1 +1 @@
-{ "chain": {"name": "chain1","handle": 4,"bytes": 0,"packets": 0,"fami=
ly": "ip","table": "filter","use": 0}}
+{"chain":{"name":"chain1","handle":4,"bytes":0,"packets":0,"family":"i=
p","table":"filter","use":0}}
diff --git a/tests/jsonfiles/20-rule-bitwise.json b/tests/jsonfiles/20-=
rule-bitwise.json
index d39d0f9..e1bf9a6 100644
--- a/tests/jsonfiles/20-rule-bitwise.json
+++ b/tests/jsonfiles/20-rule-bitwise.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "input", "=
handle" : 20,"flags" : 0, "expr" : [ { "type" : "bitwise", "sreg" : 1, =
"dreg" : 1, "len" : 4, "mask" : {"data_reg": { "type" : "value", "len" =
: 4, "data0" : "0x0000000a"}}, "xor" : {"data_reg": { "type" : "value",=
 "len" : 4, "data0" : "0x00000000"}}}]}}
+{"rule":{"family":"ip","table":"filter","chain":"input","handle":20,"f=
lags":0,"expr":[{"type":"bitwise","sreg":1,"dreg":1,"len":4,"mask":{"da=
ta_reg":{"type":"value","len":4,"data0":"0x0000000a"}},"xor":{"data_reg=
":{"type":"value","len":4,"data0":"0x00000000"}}}]}}
diff --git a/tests/jsonfiles/21-rule-byteorder.json b/tests/jsonfiles/2=
1-rule-byteorder.json
index 631ee51..3ad991d 100644
--- a/tests/jsonfiles/21-rule-byteorder.json
+++ b/tests/jsonfiles/21-rule-byteorder.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "input", "=
handle" : 21,"flags" : 0, "expr" : [ { "type" : "byteorder", "sreg" : 3=
, "dreg" : 4, "op" : "hton", "len" : 4, "size" : 4}]}}
+{"rule":{"family":"ip","table":"filter","chain":"input","handle":21,"f=
lags":0,"expr":[{"type":"byteorder","sreg":3,"dreg":4,"op":"hton","len"=
:4,"size":4}]}}
diff --git a/tests/jsonfiles/22-rule-cmp.json b/tests/jsonfiles/22-rule=
-cmp.json
index ae36cbc..e0a6fb6 100644
--- a/tests/jsonfiles/22-rule-cmp.json
+++ b/tests/jsonfiles/22-rule-cmp.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "forward",=
 "handle" : 22,"flags" : 0, "expr" : [ { "type" : "cmp", "sreg" : 1, "o=
p" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 16, "da=
ta0" : "0x00000000", "data1" : "0x6e6f6200", "data2" : "0x2e303164", "d=
ata3" : "0x00393331"}}}]}}
+{"rule":{"family":"ip","table":"filter","chain":"forward","handle":22,=
"flags":0,"expr":[{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg=
":{"type":"value","len":16,"data0":"0x00000000","data1":"0x6e6f6200","d=
ata2":"0x2e303164","data3":"0x00393331"}}}]}}
diff --git a/tests/jsonfiles/23-rule-counter.json b/tests/jsonfiles/23-=
rule-counter.json
index 6c0a745..ec95c0f 100644
--- a/tests/jsonfiles/23-rule-counter.json
+++ b/tests/jsonfiles/23-rule-counter.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 23,"flags" : 0, "expr" : [ { "type" : "counter", "pkts" : 13=
5, "bytes" : 21655}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":23,"=
flags":0,"expr":[{"type":"counter","pkts":135,"bytes":21655}]}}
diff --git a/tests/jsonfiles/24-rule-ct.json b/tests/jsonfiles/24-rule-=
ct.json
index 2c640c5..9e73ff9 100644
--- a/tests/jsonfiles/24-rule-ct.json
+++ b/tests/jsonfiles/24-rule-ct.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "input", "=
handle" : 24,"flags" : 0, "expr" : [ { "type" : "ct", "dreg" : 1, "key"=
 : "state"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {"d=
ata_reg": { "type" : "value", "len" : 4, "data0" : "0x00000008"}}}]}}
+{"rule":{"family":"ip","table":"filter","chain":"input","handle":24,"f=
lags":0,"expr":[{"type":"ct","dreg":1,"key":"state"},{"type":"cmp","sre=
g":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0=
x00000008"}}}]}}
diff --git a/tests/jsonfiles/25-rule-exthdr.json b/tests/jsonfiles/25-r=
ule-exthdr.json
index 8234a8b..b229b41 100644
--- a/tests/jsonfiles/25-rule-exthdr.json
+++ b/tests/jsonfiles/25-rule-exthdr.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "input", "=
handle" : 25,"flags" : 0, "expr" : [ { "type" : "exthdr", "dreg" : 1, "=
exthdr_type" : "mh", "offset" : 2, "len" : 16}]}}
+{"rule":{"family":"ip","table":"filter","chain":"input","handle":25,"f=
lags":0,"expr":[{"type":"exthdr","dreg":1,"exthdr_type":"mh","offset":2=
,"len":16}]}}
diff --git a/tests/jsonfiles/26-rule-immediate.json b/tests/jsonfiles/2=
6-rule-immediate.json
index 1751c17..078ee27 100644
--- a/tests/jsonfiles/26-rule-immediate.json
+++ b/tests/jsonfiles/26-rule-immediate.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "input", "=
handle" : 26,"flags" : 0, "expr" : [ { "type" : "immediate", "dreg" : 0=
, "immediatedata" : {"data_reg": {"type" : "verdict", "verdict" : "acce=
pt"}}}]}}
+{"rule":{"family":"ip","table":"filter","chain":"input","handle":26,"f=
lags":0,"expr":[{"type":"immediate","dreg":0,"immediatedata":{"data_reg=
":{"type":"verdict","verdict":"accept"}}}]}}
diff --git a/tests/jsonfiles/27-rule-limit.json b/tests/jsonfiles/27-ru=
le-limit.json
index 4ae3b70..1f066b4 100644
--- a/tests/jsonfiles/27-rule-limit.json
+++ b/tests/jsonfiles/27-rule-limit.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "input", "=
handle" : 27,"flags" : 0, "expr" : [ { "type" : "limit", "rate" : 32132=
1, "depth" : 0 }]}}
+{"rule":{"family":"ip","table":"filter","chain":"input","handle":27,"f=
lags":0,"expr":[{"type":"limit","rate":321321,"depth":0}]}}
diff --git a/tests/jsonfiles/28-rule-log.json b/tests/jsonfiles/28-rule=
-log.json
index 50e5088..26b4f77 100644
--- a/tests/jsonfiles/28-rule-log.json
+++ b/tests/jsonfiles/28-rule-log.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "input", "=
handle" : 28,"flags" : 0, "expr" : [ { "type" : "log", "prefix" : "test=
_chain", "group" : 1, "snaplen" : 0, "qthreshold" : 0 }]}}
+{"rule":{"family":"ip","table":"filter","chain":"input","handle":28,"f=
lags":0,"expr":[{"type":"log","prefix":"test_chain","group":1,"snaplen"=
:0,"qthreshold":0}]}}
diff --git a/tests/jsonfiles/29-rule-match.json b/tests/jsonfiles/29-ru=
le-match.json
index 8270764..49f30d2 100644
--- a/tests/jsonfiles/29-rule-match.json
+++ b/tests/jsonfiles/29-rule-match.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "input", "=
handle" : 9,"flags" : 0, "expr" : [ { "type" : "match", "name" : "state=
"}, { "type" : "counter", "pkts" : 0, "bytes" : 0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"input","handle":9,"fl=
ags":0,"expr":[{"type":"match","name":"state"},{"type":"counter","pkts"=
:0,"bytes":0}]}}
diff --git a/tests/jsonfiles/30-rule-lookup.json b/tests/jsonfiles/30-r=
ule-lookup.json
index e98b865..e2900c2 100644
--- a/tests/jsonfiles/30-rule-lookup.json
+++ b/tests/jsonfiles/30-rule-lookup.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "input", "=
handle" : 8,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1, "=
offset" : 12, "len" : 4, "base" : "network"}, { "type" : "lookup", "set=
" : "set0", "sreg" : 1, "dreg" : 0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"input","handle":8,"fl=
ags":0,"expr":[{"type":"payload","dreg":1,"offset":12,"len":4,"base":"n=
etwork"},{"type":"lookup","set":"set0","sreg":1,"dreg":0}]}}
diff --git a/tests/jsonfiles/31-rule-meta.json b/tests/jsonfiles/31-rul=
e-meta.json
index b67a719..867b2d4 100644
--- a/tests/jsonfiles/31-rule-meta.json
+++ b/tests/jsonfiles/31-rule-meta.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 8,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "ke=
y" : "protocol"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" =
: {"data_reg": { "type" : "value", "len" : 4, "data0" : "0x000003e8"}}}=
, { "type" : "counter", "pkts" : 0, "bytes" : 0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":8,"f=
lags":0,"expr":[{"type":"meta","dreg":1,"key":"protocol"},{"type":"cmp"=
,"sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data=
0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/32-rule-nat4.json b/tests/jsonfiles/32-rul=
e-nat4.json
index fb311d2..fa93d35 100644
--- a/tests/jsonfiles/32-rule-nat4.json
+++ b/tests/jsonfiles/32-rule-nat4.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "input", "=
handle" : 10,"flags" : 0, "expr" : [ { "type" : "nat", "nat_type" : "dn=
at", "family" : "ip", "sreg_addr_min" : 1, "sreg_addr_max" : 2, "sreg_p=
roto_min" : 3, "sreg_proto_max" : 4}]}}
+{"rule":{"family":"ip","table":"filter","chain":"input","handle":10,"f=
lags":0,"expr":[{"type":"nat","nat_type":"dnat","family":"ip","sreg_add=
r_min":1,"sreg_addr_max":2,"sreg_proto_min":3,"sreg_proto_max":4}]}}
diff --git a/tests/jsonfiles/33-rule-nat6.json b/tests/jsonfiles/33-rul=
e-nat6.json
index cd11c04..b9df998 100644
--- a/tests/jsonfiles/33-rule-nat6.json
+++ b/tests/jsonfiles/33-rule-nat6.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip6", "table" : "nat", "chain"  : "output", "h=
andle" : 33,"flags" : 0, "expr" : [ { "type" : "nat", "nat_type" : "sna=
t", "family" : "ip6", "sreg_addr_min" : 1, "sreg_addr_max" : 2, "sreg_p=
roto_min" : 3, "sreg_proto_max" : 4}]}}
+{"rule":{"family":"ip6","table":"nat","chain":"output","handle":33,"fl=
ags":0,"expr":[{"type":"nat","nat_type":"snat","family":"ip6","sreg_add=
r_min":1,"sreg_addr_max":2,"sreg_proto_min":3,"sreg_proto_max":4}]}}
diff --git a/tests/jsonfiles/34-rule-payload.json b/tests/jsonfiles/34-=
rule-payload.json
index 6015dc4..1d0f2cd 100644
--- a/tests/jsonfiles/34-rule-payload.json
+++ b/tests/jsonfiles/34-rule-payload.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "input", "=
handle" : 26,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1, =
"offset" : 9, "len" : 1, "base" : "network"}, { "type" : "cmp", "sreg" =
: 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : =
1, "data0" : "0x00000006"}}}, { "type" : "payload", "dreg" : 1, "offset=
" : 2, "len" : 2, "base" : "transport"}, { "type" : "cmp", "sreg" : 1, =
"op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 2, "d=
ata0" : "0x00001600"}}}, { "type" : "immediate", "dreg" : 0, "immediate=
data" : {"data_reg": {"type" : "verdict", "verdict" : "accept"}}}]}}
+{"rule":{"family":"ip","table":"filter","chain":"input","handle":26,"f=
lags":0,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"n=
etwork"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type"=
:"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"of=
fset":2,"len":2,"base":"transport"},{"type":"cmp","sreg":1,"op":"eq","c=
mpdata":{"data_reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"t=
ype":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict"=
,"verdict":"accept"}}}]}}
diff --git a/tests/jsonfiles/35-rule-target.json b/tests/jsonfiles/35-r=
ule-target.json
index a435264..0c93d5e 100644
--- a/tests/jsonfiles/35-rule-target.json
+++ b/tests/jsonfiles/35-rule-target.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "INPUT", "=
handle" : 20,"flags" : 0, "expr" : [ { "type" : "counter", "pkts" : 17,=
 "bytes" : 4436}, { "type" : "target", "name" : "LOG"}]}}
+{"rule":{"family":"ip","table":"filter","chain":"INPUT","handle":20,"f=
lags":0,"expr":[{"type":"counter","pkts":17,"bytes":4436},{"type":"targ=
et","name":"LOG"}]}}
diff --git a/tests/jsonfiles/36-rule-real.json b/tests/jsonfiles/36-rul=
e-real.json
index 9ea5e48..6a1d705 100644
--- a/tests/jsonfiles/36-rule-real.json
+++ b/tests/jsonfiles/36-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 36,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1,=
 "offset" : 12, "len" : 8, "base" : "link"}, { "type" : "cmp", "sreg" :=
 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 8=
, "data0" : "0x0100a8c0", "data1" : "0x6400a8c0"}}}, { "type" : "counte=
r", "pkts" : 0, "bytes" : 0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":36,"=
flags":0,"expr":[{"type":"payload","dreg":1,"offset":12,"len":8,"base":=
"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":=
"value","len":8,"data0":"0x0100a8c0","data1":"0x6400a8c0"}}},{"type":"c=
ounter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/37-rule-real.json b/tests/jsonfiles/37-rul=
e-real.json
index 99bd818..4abc7fb 100644
--- a/tests/jsonfiles/37-rule-real.json
+++ b/tests/jsonfiles/37-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 37,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1,=
 "offset" : 16, "len" : 4, "base" : "link"}, { "type" : "cmp", "sreg" :=
 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 4=
, "data0" : "0x0100a8c0"}}}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":37,"=
flags":0,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":=
"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":=
"value","len":4,"data0":"0x0100a8c0"}}}]}}
diff --git a/tests/jsonfiles/38-rule-real.json b/tests/jsonfiles/38-rul=
e-real.json
index 26384a4..5b0e360 100644
--- a/tests/jsonfiles/38-rule-real.json
+++ b/tests/jsonfiles/38-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 38,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1,=
 "offset" : 16, "len" : 4, "base" : "link"}, { "type" : "cmp", "sreg" :=
 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 4=
, "data0" : "0x0100a8c0"}}}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":38,"=
flags":0,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":=
"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":=
"value","len":4,"data0":"0x0100a8c0"}}}]}}
diff --git a/tests/jsonfiles/39-rule-real.json b/tests/jsonfiles/39-rul=
e-real.json
index f77c5a5..9232196 100644
--- a/tests/jsonfiles/39-rule-real.json
+++ b/tests/jsonfiles/39-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 39,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1,=
 "offset" : 16, "len" : 4, "base" : "link"}, { "type" : "cmp", "sreg" :=
 1, "op" : "gte", "cmpdata" : {"data_reg": { "type" : "value", "len" : =
4, "data0" : "0x0100a8c0"}}}, { "type" : "cmp", "sreg" : 1, "op" : "lte=
", "cmpdata" : {"data_reg": { "type" : "value", "len" : 4, "data0" : "0=
xfa00a8c0"}}}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":39,"=
flags":0,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":=
"link"},{"type":"cmp","sreg":1,"op":"gte","cmpdata":{"data_reg":{"type"=
:"value","len":4,"data0":"0x0100a8c0"}}},{"type":"cmp","sreg":1,"op":"l=
te","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0xfa00a8c0"}=
}}]}}
diff --git a/tests/jsonfiles/40-rule-real.json b/tests/jsonfiles/40-rul=
e-real.json
index fff70dd..5db129e 100644
--- a/tests/jsonfiles/40-rule-real.json
+++ b/tests/jsonfiles/40-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 40,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1,=
 "offset" : 16, "len" : 4, "base" : "link"}, { "type" : "cmp", "sreg" :=
 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 4=
, "data0" : "0x0100a8c0"}}}, { "type" : "counter", "pkts" : 0, "bytes" =
: 0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":40,"=
flags":0,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":=
"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":=
"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"byt=
es":0}]}}
diff --git a/tests/jsonfiles/41-rule-real.json b/tests/jsonfiles/41-rul=
e-real.json
index a5c0e49..2381378 100644
--- a/tests/jsonfiles/41-rule-real.json
+++ b/tests/jsonfiles/41-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 41,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1,=
 "offset" : 16, "len" : 4, "base" : "link"}, { "type" : "cmp", "sreg" :=
 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 4=
, "data0" : "0x0100a8c0"}}}, { "type" : "counter", "pkts" : 0, "bytes" =
: 0}, { "type" : "immediate", "dreg" : 0, "immediatedata" : {"data_reg"=
: {"type" : "verdict", "verdict" : "drop"}}}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":41,"=
flags":0,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":=
"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":=
"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"byt=
es":0},{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type"=
:"verdict","verdict":"drop"}}}]}}
diff --git a/tests/jsonfiles/42-rule-real.json b/tests/jsonfiles/42-rul=
e-real.json
index ec2b4a9..b265d69 100644
--- a/tests/jsonfiles/42-rule-real.json
+++ b/tests/jsonfiles/42-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 42,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1,=
 "offset" : 16, "len" : 4, "base" : "link"}, { "type" : "cmp", "sreg" :=
 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 4=
, "data0" : "0x0100a8c0"}}}, { "type" : "counter", "pkts" : 0, "bytes" =
: 0}, { "type" : "log", "prefix" : "(null)", "group" : 0, "snaplen" : 0=
, "qthreshold" : 0 }]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":42,"=
flags":0,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":=
"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":=
"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"byt=
es":0},{"type":"log","prefix":"(null)","group":0,"snaplen":0,"qthreshol=
d":0}]}}
diff --git a/tests/jsonfiles/43-rule-real.json b/tests/jsonfiles/43-rul=
e-real.json
index 22f7cd1..7b937ee 100644
--- a/tests/jsonfiles/43-rule-real.json
+++ b/tests/jsonfiles/43-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 43,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1,=
 "offset" : 9, "len" : 1, "base" : "link"}, { "type" : "cmp", "sreg" : =
1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 1,=
 "data0" : "0x00000006"}}}, { "type" : "payload", "dreg" : 1, "offset" =
: 2, "len" : 2, "base" : "link"}, { "type" : "cmp", "sreg" : 1, "op" : =
"eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 2, "data0" :=
 "0x00001600"}}}, { "type" : "counter", "pkts" : 0, "bytes" : 0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":43,"=
flags":0,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"=
link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"=
value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offs=
et":2,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata"=
:{"data_reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"type":"c=
ounter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/44-rule-real.json b/tests/jsonfiles/44-rul=
e-real.json
index c7401ae..dee71d5 100644
--- a/tests/jsonfiles/44-rule-real.json
+++ b/tests/jsonfiles/44-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 44,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1,=
 "offset" : 9, "len" : 1, "base" : "link"}, { "type" : "cmp", "sreg" : =
1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 1,=
 "data0" : "0x00000006"}}}, { "type" : "payload", "dreg" : 1, "offset" =
: 0, "len" : 4, "base" : "link"}, { "type" : "cmp", "sreg" : 1, "op" : =
"eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 4, "data0" :=
 "0x16000004"}}}, { "type" : "counter", "pkts" : 0, "bytes" : 0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":44,"=
flags":0,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"=
link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"=
value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offs=
et":0,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata"=
:{"data_reg":{"type":"value","len":4,"data0":"0x16000004"}}},{"type":"c=
ounter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/45-rule-real.json b/tests/jsonfiles/45-rul=
e-real.json
index 5f9df87..ecce215 100644
--- a/tests/jsonfiles/45-rule-real.json
+++ b/tests/jsonfiles/45-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 45,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1,=
 "offset" : 12, "len" : 8, "base" : "link"}, { "type" : "cmp", "sreg" :=
 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 8=
, "data0" : "0x0100a8c0", "data1" : "0x6400a8c0"}}}, { "type" : "counte=
r", "pkts" : 0, "bytes" : 0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":45,"=
flags":0,"expr":[{"type":"payload","dreg":1,"offset":12,"len":8,"base":=
"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":=
"value","len":8,"data0":"0x0100a8c0","data1":"0x6400a8c0"}}},{"type":"c=
ounter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/46-rule-real.json b/tests/jsonfiles/46-rul=
e-real.json
index 3b1a96b..fbd222a 100644
--- a/tests/jsonfiles/46-rule-real.json
+++ b/tests/jsonfiles/46-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 46,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1,=
 "offset" : 9, "len" : 1, "base" : "link"}, { "type" : "cmp", "sreg" : =
1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 1,=
 "data0" : "0x00000006"}}}, { "type" : "payload", "dreg" : 1, "offset" =
: 0, "len" : 8, "base" : "link"}, { "type" : "cmp", "sreg" : 1, "op" : =
"eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 8, "data0" :=
 "0x16000004", "data1" : "0x00000000"}}}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":46,"=
flags":0,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"=
link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"=
value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offs=
et":0,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata"=
:{"data_reg":{"type":"value","len":8,"data0":"0x16000004","data1":"0x00=
000000"}}}]}}
diff --git a/tests/jsonfiles/47-rule-real.json b/tests/jsonfiles/47-rul=
e-real.json
index 2f36100..4ea2988 100644
--- a/tests/jsonfiles/47-rule-real.json
+++ b/tests/jsonfiles/47-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 47,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1,=
 "offset" : 9, "len" : 1, "base" : "link"}, { "type" : "cmp", "sreg" : =
1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 1,=
 "data0" : "0x00000006"}}}, { "type" : "payload", "dreg" : 1, "offset" =
: 0, "len" : 8, "base" : "link"}, { "type" : "cmp", "sreg" : 1, "op" : =
"eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 8, "data0" :=
 "0x16000004", "data1" : "0x00000000"}}}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":47,"=
flags":0,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"=
link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"=
value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offs=
et":0,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata"=
:{"data_reg":{"type":"value","len":8,"data0":"0x16000004","data1":"0x00=
000000"}}}]}}
diff --git a/tests/jsonfiles/48-rule-real.json b/tests/jsonfiles/48-rul=
e-real.json
index 86fbd83..af67262 100644
--- a/tests/jsonfiles/48-rule-real.json
+++ b/tests/jsonfiles/48-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 48,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "len"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {"=
data_reg": { "type" : "value", "len" : 4, "data0" : "0x000003e8"}}}, { =
"type" : "counter", "pkts" : 0, "bytes" : 0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":48,"=
flags":0,"expr":[{"type":"meta","dreg":1,"key":"len"},{"type":"cmp","sr=
eg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"=
0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/49-rule-real.json b/tests/jsonfiles/49-rul=
e-real.json
index dc6a680..c44c12c 100644
--- a/tests/jsonfiles/49-rule-real.json
+++ b/tests/jsonfiles/49-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 49,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "mark"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {=
"data_reg": { "type" : "value", "len" : 4, "data0" : "0x00000000"}}}, {=
 "type" : "counter", "pkts" : 55, "bytes" : 11407}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":49,"=
flags":0,"expr":[{"type":"meta","dreg":1,"key":"mark"},{"type":"cmp","s=
reg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":=
"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}
diff --git a/tests/jsonfiles/50-rule-real.json b/tests/jsonfiles/50-rul=
e-real.json
index 3845a8c..6ca0004 100644
--- a/tests/jsonfiles/50-rule-real.json
+++ b/tests/jsonfiles/50-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 50,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "iif"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {"=
data_reg": { "type" : "value", "len" : 4, "data0" : "0x00000001"}}}, { =
"type" : "counter", "pkts" : 0, "bytes" : 0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":50,"=
flags":0,"expr":[{"type":"meta","dreg":1,"key":"iif"},{"type":"cmp","sr=
eg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"=
0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/51-rule-real.json b/tests/jsonfiles/51-rul=
e-real.json
index f2f1784..8032664 100644
--- a/tests/jsonfiles/51-rule-real.json
+++ b/tests/jsonfiles/51-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 51,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "iifname"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" =
: {"data_reg": { "type" : "value", "len" : 16, "data0" : "0x00000000", =
"data1" : "0x00000000", "data2" : "0x65000000", "data3" : "0x00306874"}=
}}, { "type" : "counter", "pkts" : 0, "bytes" : 0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":51,"=
flags":0,"expr":[{"type":"meta","dreg":1,"key":"iifname"},{"type":"cmp"=
,"sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":16,"dat=
a0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x0=
0306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/52-rule-real.json b/tests/jsonfiles/52-rul=
e-real.json
index 7d16017..40efcb9 100644
--- a/tests/jsonfiles/52-rule-real.json
+++ b/tests/jsonfiles/52-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 52,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "oif"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {"=
data_reg": { "type" : "value", "len" : 4, "data0" : "0x00000001"}}}, { =
"type" : "counter", "pkts" : 0, "bytes" : 0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":52,"=
flags":0,"expr":[{"type":"meta","dreg":1,"key":"oif"},{"type":"cmp","sr=
eg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"=
0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/53-rule-real.json b/tests/jsonfiles/53-rul=
e-real.json
index 2ba527c..631668b 100644
--- a/tests/jsonfiles/53-rule-real.json
+++ b/tests/jsonfiles/53-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 53,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "oifname"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" =
: {"data_reg": { "type" : "value", "len" : 16, "data0" : "0x00000000", =
"data1" : "0x00000000", "data2" : "0x65000000", "data3" : "0x00306874"}=
}}, { "type" : "counter", "pkts" : 0, "bytes" : 0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":53,"=
flags":0,"expr":[{"type":"meta","dreg":1,"key":"oifname"},{"type":"cmp"=
,"sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":16,"dat=
a0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x0=
0306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/54-rule-real.json b/tests/jsonfiles/54-rul=
e-real.json
index a222e1d..4f7448f 100644
--- a/tests/jsonfiles/54-rule-real.json
+++ b/tests/jsonfiles/54-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 54,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "skuid"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : =
{"data_reg": { "type" : "value", "len" : 4, "data0" : "0x000003e8"}}}, =
{ "type" : "counter", "pkts" : 0, "bytes" : 0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":54,"=
flags":0,"expr":[{"type":"meta","dreg":1,"key":"skuid"},{"type":"cmp","=
sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0"=
:"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/55-rule-real.json b/tests/jsonfiles/55-rul=
e-real.json
index 1527349..3b299cb 100644
--- a/tests/jsonfiles/55-rule-real.json
+++ b/tests/jsonfiles/55-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 55,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "skgid"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : =
{"data_reg": { "type" : "value", "len" : 4, "data0" : "0x000003e8"}}}, =
{ "type" : "counter", "pkts" : 0, "bytes" : 0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":55,"=
flags":0,"expr":[{"type":"meta","dreg":1,"key":"skgid"},{"type":"cmp","=
sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0"=
:"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/56-rule-real.json b/tests/jsonfiles/56-rul=
e-real.json
index b33dd78..05892a8 100644
--- a/tests/jsonfiles/56-rule-real.json
+++ b/tests/jsonfiles/56-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 56,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "secmark"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" =
: {"data_reg": { "type" : "value", "len" : 4, "data0" : "0x00000000"}}}=
, { "type" : "counter", "pkts" : 55, "bytes" : 11407}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":56,"=
flags":0,"expr":[{"type":"meta","dreg":1,"key":"secmark"},{"type":"cmp"=
,"sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data=
0":"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}
diff --git a/tests/jsonfiles/57-rule-real.json b/tests/jsonfiles/57-rul=
e-real.json
index 9c0a1eb..cbab7f0 100644
--- a/tests/jsonfiles/57-rule-real.json
+++ b/tests/jsonfiles/57-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 57,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "len"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {"=
data_reg": { "type" : "value", "len" : 4, "data0" : "0x000003e8"}}}, { =
"type" : "counter", "pkts" : 0, "bytes" : 0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":57,"=
flags":0,"expr":[{"type":"meta","dreg":1,"key":"len"},{"type":"cmp","sr=
eg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"=
0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/58-rule-real.json b/tests/jsonfiles/58-rul=
e-real.json
index 6934748..bbdc0a1 100644
--- a/tests/jsonfiles/58-rule-real.json
+++ b/tests/jsonfiles/58-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 58,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "protocol"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata"=
 : {"data_reg": { "type" : "value", "len" : 2, "data0" : "0x00000008"}}=
}, { "type" : "counter", "pkts" : 55, "bytes" : 11407}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":58,"=
flags":0,"expr":[{"type":"meta","dreg":1,"key":"protocol"},{"type":"cmp=
","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":2,"dat=
a0":"0x00000008"}}},{"type":"counter","pkts":55,"bytes":11407}]}}
diff --git a/tests/jsonfiles/59-rule-real.json b/tests/jsonfiles/59-rul=
e-real.json
index 298a291..9b2476e 100644
--- a/tests/jsonfiles/59-rule-real.json
+++ b/tests/jsonfiles/59-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 59,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "mark"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {=
"data_reg": { "type" : "value", "len" : 4, "data0" : "0x00000000"}}}, {=
 "type" : "counter", "pkts" : 55, "bytes" : 11407}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":59,"=
flags":0,"expr":[{"type":"meta","dreg":1,"key":"mark"},{"type":"cmp","s=
reg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":=
"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}
diff --git a/tests/jsonfiles/60-rule-real.json b/tests/jsonfiles/60-rul=
e-real.json
index e124411..afd20ca 100644
--- a/tests/jsonfiles/60-rule-real.json
+++ b/tests/jsonfiles/60-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 60,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "iif"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {"=
data_reg": { "type" : "value", "len" : 4, "data0" : "0x00000001"}}}, { =
"type" : "counter", "pkts" : 0, "bytes" : 0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":60,"=
flags":0,"expr":[{"type":"meta","dreg":1,"key":"iif"},{"type":"cmp","sr=
eg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"=
0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/61-rule-real.json b/tests/jsonfiles/61-rul=
e-real.json
index f74acf2..bfe7ed5 100644
--- a/tests/jsonfiles/61-rule-real.json
+++ b/tests/jsonfiles/61-rule-real.json
@@ -1 +1 @@
-{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 61,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "iifname"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" =
: {"data_reg": { "type" : "value", "len" : 16, "data0" : "0x00000000", =
"data1" : "0x00000000", "data2" : "0x65000000", "data3" : "0x00306874"}=
}}, { "type" : "counter", "pkts" : 0, "bytes" : 0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":61,"=
flags":0,"expr":[{"type":"meta","dreg":1,"key":"iifname"},{"type":"cmp"=
,"sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":16,"dat=
a0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x0=
0306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/jsonfiles/62-set.json b/tests/jsonfiles/62-set.json
index c5200eb..0e52f70 100644
--- a/tests/jsonfiles/62-set.json
+++ b/tests/jsonfiles/62-set.json
@@ -1 +1 @@
-{ "set": { "name": "set0","table": "filter","flags": 3,"family": "ip",=
"key_type": 12,"key_len": 2,"set_elem": [{"flags": 0,"key": {"data_reg"=
: { "type" : "value", "len" : 2, "data0" : "0x00001700"}}}, {"flags": 0=
,"key": {"data_reg": { "type" : "value", "len" : 2, "data0" : "0x000016=
00"}}}]}}
+{"set":{"name":"set0","table":"filter","flags":3,"family":"ip","key_ty=
pe":12,"key_len":2,"set_elem":[{"flags":0,"key":{"data_reg":{"type":"va=
lue","len":2,"data0":"0x00001700"}}},{"flags":0,"key":{"data_reg":{"typ=
e":"value","len":2,"data0":"0x00001600"}}}]}}
diff --git a/tests/jsonfiles/63-set.json b/tests/jsonfiles/63-set.json
index be3e564..90afec3 100644
--- a/tests/jsonfiles/63-set.json
+++ b/tests/jsonfiles/63-set.json
@@ -1 +1 @@
-{ "set": { "name": "map0","table": "filter","flags": 11,"family": "ip"=
,"key_type": 12,"key_len": 2,"data_type": 4294967040,"data_len": 16,"se=
t_elem": [{"flags": 0,"key": {"data_reg": { "type" : "value", "len" : 2=
, "data0" : "0x00001700"}},"data": {"data_reg": { "type" : "chain", "ch=
ain" : "forward"}}}, {"flags": 0,"key": {"data_reg": { "type" : "value"=
, "len" : 2, "data0" : "0x00001600"}},"data": {"data_reg": { "type" : "=
chain", "chain" : "chain1"}}}]}}
+{"set":{"name":"map0","table":"filter","flags":11,"family":"ip","key_t=
ype":12,"key_len":2,"data_type":4294967040,"data_len":16,"set_elem":[{"=
flags":0,"key":{"data_reg":{"type":"value","len":2,"data0":"0x00001700"=
}},"data":{"data_reg":{"type":"chain","chain":"forward"}}},{"flags":0,"=
key":{"data_reg":{"type":"value","len":2,"data0":"0x00001600"}},"data":=
{"data_reg":{"type":"chain","chain":"chain1"}}}]}}
diff --git a/tests/jsonfiles/64-ruleset.json b/tests/jsonfiles/64-rules=
et.json
index c4fffa1..a1baec8 100644
--- a/tests/jsonfiles/64-ruleset.json
+++ b/tests/jsonfiles/64-ruleset.json
@@ -1,2 +1,2 @@
-{ "nftables": [{"table" : {"name" : "filter","family" : "ip","flags" :=
 0}},{"table" : {"name" : "filter2","family" : "ip6","flags" : 0}},{ "c=
hain": {"name": "input","handle": 1,"bytes": 10681449,"packets": 16216,=
"family": "ip","table": "filter","use": 0,"type": "filter","hooknum": "=
input","prio": 0,"policy": "accept"}},{ "chain": {"name": "forward","ha=
ndle": 2,"bytes": 0,"packets": 0,"family": "ip","table": "filter","use"=
: 0,"type": "filter","hooknum": "forward","prio": 0,"policy": "accept"}=
},{ "chain": {"name": "output","handle": 3,"bytes": 2375830,"packets": =
15184,"family": "ip","table": "filter","use": 0,"type": "filter","hookn=
um": "output","prio": 0,"policy": "accept"}},{ "chain": {"name": "chain=
1","handle": 4,"bytes": 0,"packets": 0,"family": "ip","table": "filter"=
,"use": 0}},{ "set": { "name": "set0","table": "filter","flags": 3,"fam=
ily": "ip","key_type": 12,"key_len": 2}},{ "rule": { "family" : "ip", "=
table" : "filter", "chain"  : "output", "handle" : 6,"flags" : 0, " exp=
r" : [ { "type" : "payload", "dreg" : 1, "offset" : 16, "len" : 4, "bas=
e" : "link"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {"=
data_reg": { "type" : "value", "len" : 4, "data0" : "0x0100a8c0"}}}, { =
"type" : "counter", "pkts" : 0, "bytes" : 0}, { "type" : "immediate", "=
dreg" : 0, "immediatedata" : {"data_reg": {"type" : "verdict", "verdict=
" : "drop"}}}]}},{ "rule": { "family" : "ip", "table" : "filter", "chai=
n"  : "output", "handle" : 9,"flags" : 0, "expr" : [ { "type" : "payloa=
d", "dreg" : 1, "offset" : 9, "len" : 1, "base" : "link"}, { "type" : "=
cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "val=
ue", "len" : 1, "data0" : "0x00000006"}}}, { "type" : "payload", "dreg"=
 : 1, "offset" : 2, "len" : 2, "base" : "link"}, { "type" : "cmp", "sre=
g" : 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len"=
 : 2, "data0" : "0x00001600"}}}, { "type" : "counter", "pkts" : 0, "byt=
es" : 0}]}},{ "rule": { "family" : "ip", "table" : "filter", "chain"  :=
 "output", "handle" : 10,"flags" : 0, "expr" : [ { "type" : "payload", =
"dreg" : 1, "offset" : 16, "len" : 4, "base" : "link"}, { "type" : "cmp=
", "sreg" : 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value"=
, "len" : 4, "data0" : "0x0100a8c0"}}}, { "type" : "counter", "pkts" : =
0, "bytes" : 0}]}},{ "rule": { "family" : "ip", "table" : "filter", "ch=
ain"  : "output", "handle" : 11,"flags" : 0, "expr" : [ { "type" : "pay=
load", "dreg" : 1, "offset" : 16, "len" : 4, "base" : "link"}, { "type"=
 : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : =
"value", "len" : 4, "data0" : "0x0100a8c0"}}}, { "type" : "counter", "p=
kts" : 0, "bytes" : 0}, { "type" : "immediate", "dreg" : 0, "immediated=
ata" : {"data_reg": {"type" : "verdict", "verdict" : "drop"}}}]}}]}
+{"nftables":[{"table":{"name":"filter","family":"ip","flags":0}},{"tab=
le":{"name":"filter2","family":"ip6","flags":0}},{"chain":{"name":"inpu=
t","handle":1,"bytes":10681449,"packets":16216,"family":"ip","table":"f=
ilter","use":0,"type":"filter","hooknum":"input","prio":0,"policy":"acc=
ept"}},{"chain":{"name":"forward","handle":2,"bytes":0,"packets":0,"fam=
ily":"ip","table":"filter","use":0,"type":"filter","hooknum":"forward",=
"prio":0,"policy":"accept"}},{"chain":{"name":"output","handle":3,"byte=
s":2375830,"packets":15184,"family":"ip","table":"filter","use":0,"type=
":"filter","hooknum":"output","prio":0,"policy":"accept"}},{"chain":{"n=
ame":"chain1","handle":4,"bytes":0,"packets":0,"family":"ip","table":"f=
ilter","use":0}},{"set":{"name":"set0","table":"filter","flags":3,"fami=
ly":"ip","key_type":12,"key_len":2}},{"rule":{"family":"ip","table":"fi=
lter","chain":"output","handle":6,"flags":0,"expr":[{"type":"payload","=
dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":=
"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"=
}}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,=
"immediatedata":{"data_reg":{"type":"verdict","verdict":"drop"}}}]}},{"=
rule":{"family":"ip","table":"filter","chain":"output","handle":9,"flag=
s":0,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link=
"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"valu=
e","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":=
2,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"d=
ata_reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"type":"count=
er","pkts":0,"bytes":0}]}},{"rule":{"family":"ip","table":"filter","cha=
in":"output","handle":10,"flags":0,"expr":[{"type":"payload","dreg":1,"=
offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmp=
data":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"typ=
e":"counter","pkts":0,"bytes":0}]}},{"rule":{"family":"ip","table":"fil=
ter","chain":"output","handle":11,"flags":0,"expr":[{"type":"payload","=
dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":=
"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"=
}}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,=
"immediatedata":{"data_reg":{"type":"verdict","verdict":"drop"}}}]}}]}
=20

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
