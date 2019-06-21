Return-Path: <SRS0=QW5x=UU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF5FBC43613
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 16:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAA8020673
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 16:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbfFUQ3p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Jun 2019 12:29:45 -0400
Received: from mail.us.es ([193.147.175.20]:38060 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfFUQ3p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Jun 2019 12:29:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C1293EDB15
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jun 2019 18:29:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AFB6EDA702
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jun 2019 18:29:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A49C6DA706; Fri, 21 Jun 2019 18:29:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 61422DA702
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jun 2019 18:29:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 21 Jun 2019 18:29:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 45DD44265A2F
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jun 2019 18:29:37 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2] ct: support for NFT_CT_{SRC,DST}_{IP,IP6}
Date:   Fri, 21 Jun 2019 18:29:34 +0200
Message-Id: <20190621162934.6953-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These keys are available since kernel >= 4.17.

You can still use NFT_CT_{SRC,DST}, however, you need to specify 'meta
protocol' in first place to provide layer 3 context.

Note that NFT_CT_{SRC,DST} are broken with set, maps and concatenations.
This patch is implicitly fixing these cases.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: json doesn't break when running python nft-tests.py -j anymore.

 include/ct.h                   |  3 +--
 src/ct.c                       | 21 +++++++++++++++++++--
 src/evaluate.c                 | 25 ++++++++++++++++++++++++-
 src/json.c                     | 13 -------------
 src/netlink_delinearize.c      |  2 +-
 src/parser_bison.y             | 14 ++++++++------
 src/parser_json.c              | 12 ++++++------
 tests/py/any/ct.t              |  4 ++--
 tests/py/inet/ct.t.json        |  3 +--
 tests/py/inet/ct.t.json.output |  1 -
 tests/py/inet/ct.t.payload     |  5 ++---
 tests/py/ip/ct.t.json          | 24 ++++++++----------------
 tests/py/ip/ct.t.payload       | 16 ++++++++--------
 13 files changed, 80 insertions(+), 63 deletions(-)

diff --git a/include/ct.h b/include/ct.h
index 4c5bd804dabf..063f8cdf4aa4 100644
--- a/include/ct.h
+++ b/include/ct.h
@@ -26,8 +26,7 @@ extern const struct ct_template ct_templates[__NFT_CT_MAX];
 }
 
 extern struct expr *ct_expr_alloc(const struct location *loc,
-				  enum nft_ct_keys key, int8_t direction,
-				  uint8_t nfproto);
+				  enum nft_ct_keys key, int8_t direction);
 extern void ct_expr_update_type(struct proto_ctx *ctx, struct expr *expr);
 
 extern struct stmt *notrack_stmt_alloc(const struct location *loc);
diff --git a/src/ct.c b/src/ct.c
index 72346cd54338..4f7807deea0f 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -291,6 +291,14 @@ const struct ct_template ct_templates[__NFT_CT_MAX] = {
 					      BYTEORDER_HOST_ENDIAN, 16),
 	[NFT_CT_EVENTMASK]	= CT_TEMPLATE("event", &ct_event_type,
 					      BYTEORDER_HOST_ENDIAN, 32),
+	[NFT_CT_SRC_IP]		= CT_TEMPLATE("ip saddr", &ipaddr_type,
+					      BYTEORDER_BIG_ENDIAN, 0),
+	[NFT_CT_DST_IP]		= CT_TEMPLATE("ip daddr", &ipaddr_type,
+					      BYTEORDER_BIG_ENDIAN, 0),
+	[NFT_CT_SRC_IP6]	= CT_TEMPLATE("ip6 saddr", &ip6addr_type,
+					      BYTEORDER_BIG_ENDIAN, 0),
+	[NFT_CT_DST_IP6]	= CT_TEMPLATE("ip6 daddr", &ip6addr_type,
+					      BYTEORDER_BIG_ENDIAN, 0),
 };
 
 static void ct_print(enum nft_ct_keys key, int8_t dir, uint8_t nfproto,
@@ -368,7 +376,7 @@ const struct expr_ops ct_expr_ops = {
 };
 
 struct expr *ct_expr_alloc(const struct location *loc, enum nft_ct_keys key,
-			   int8_t direction, uint8_t nfproto)
+			   int8_t direction)
 {
 	const struct ct_template *tmpl = &ct_templates[key];
 	struct expr *expr;
@@ -377,7 +385,6 @@ struct expr *ct_expr_alloc(const struct location *loc, enum nft_ct_keys key,
 			  tmpl->byteorder, tmpl->len);
 	expr->ct.key = key;
 	expr->ct.direction = direction;
-	expr->ct.nfproto = nfproto;
 
 	switch (key) {
 	case NFT_CT_SRC:
@@ -428,6 +435,16 @@ void ct_expr_update_type(struct proto_ctx *ctx, struct expr *expr)
 			break;
 		datatype_set(expr, &inet_service_type);
 		break;
+	case NFT_CT_SRC_IP:
+	case NFT_CT_DST_IP:
+		expr->dtype = &ipaddr_type;
+		expr->len = expr->dtype->size;
+		break;
+	case NFT_CT_SRC_IP6:
+	case NFT_CT_DST_IP6:
+		expr->dtype = &ip6addr_type;
+		expr->len = expr->dtype->size;
+		break;
 	default:
 		break;
 	}
diff --git a/src/evaluate.c b/src/evaluate.c
index dfdd3c242530..19c2d4c6356a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -782,7 +782,7 @@ static int ct_gen_nh_dependency(struct eval_ctx *ctx, struct expr *ct)
 		return 0;
 	}
 
-	left = ct_expr_alloc(&ct->location, NFT_CT_L3PROTOCOL, ct->ct.direction, ct->ct.nfproto);
+	left = ct_expr_alloc(&ct->location, NFT_CT_L3PROTOCOL, ct->ct.direction);
 
 	right = constant_expr_alloc(&ct->location, left->dtype,
 				    left->dtype->byteorder, left->len,
@@ -803,13 +803,30 @@ static int ct_gen_nh_dependency(struct eval_ctx *ctx, struct expr *ct)
  */
 static int expr_evaluate_ct(struct eval_ctx *ctx, struct expr **expr)
 {
+	const struct proto_desc *base, *error;
 	struct expr *ct = *expr;
 
+	base = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+
 	switch (ct->ct.key) {
 	case NFT_CT_SRC:
 	case NFT_CT_DST:
 		ct_gen_nh_dependency(ctx, ct);
 		break;
+	case NFT_CT_SRC_IP:
+	case NFT_CT_DST_IP:
+		if (base == &proto_ip6) {
+			error = &proto_ip;
+			goto err_conflict;
+		}
+		break;
+	case NFT_CT_SRC_IP6:
+	case NFT_CT_DST_IP6:
+		if (base == &proto_ip) {
+			error = &proto_ip6;
+			goto err_conflict;
+		}
+		break;
 	default:
 		break;
 	}
@@ -817,6 +834,12 @@ static int expr_evaluate_ct(struct eval_ctx *ctx, struct expr **expr)
 	ct_expr_update_type(&ctx->pctx, ct);
 
 	return expr_evaluate_primary(ctx, expr);
+
+err_conflict:
+	return stmt_binary_error(ctx, ct,
+				 &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
+				 "conflicting protocols specified: %s vs. %s",
+				 base->name, error->name);
 }
 
 /*
diff --git a/src/json.c b/src/json.c
index e0127c5741a0..4e6468420163 100644
--- a/src/json.c
+++ b/src/json.c
@@ -485,7 +485,6 @@ json_t *ct_expr_json(const struct expr *expr, struct output_ctx *octx)
 {
 	const char *dirstr = ct_dir2str(expr->ct.direction);
 	enum nft_ct_keys key = expr->ct.key;
-	const struct proto_desc *desc;
 	json_t *root;
 
 	root = json_pack("{s:s}", "key", ct_templates[key].token);
@@ -495,18 +494,6 @@ json_t *ct_expr_json(const struct expr *expr, struct output_ctx *octx)
 
 	if (dirstr)
 		json_object_set_new(root, "dir", json_string(dirstr));
-
-	switch (key) {
-	case NFT_CT_SRC:
-	case NFT_CT_DST:
-		desc = proto_find_upper(&proto_inet, expr->ct.nfproto);
-		if (desc)
-			json_object_set_new(root, "family",
-					    json_string(desc->name));
-		break;
-	default:
-		break;
-	}
 out:
 	return json_pack("{s:o}", "ct", root);
 }
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index a4044f0c7329..1dd3ffd107b2 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -788,7 +788,7 @@ static void netlink_parse_ct_expr(struct netlink_parse_ctx *ctx,
 		dir = nftnl_expr_get_u8(nle, NFTNL_EXPR_CT_DIR);
 
 	key  = nftnl_expr_get_u32(nle, NFTNL_EXPR_CT_KEY);
-	expr = ct_expr_alloc(loc, key, dir, NFPROTO_UNSPEC);
+	expr = ct_expr_alloc(loc, key, dir);
 
 	dreg = netlink_parse_register(nle, NFTNL_EXPR_CT_DREG);
 	netlink_set_register(ctx, dreg, expr);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 1c0b60cf40fd..670e91f544c7 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4060,15 +4060,15 @@ rt_key			:	CLASSID		{ $$ = NFT_RT_CLASSID; }
 
 ct_expr			: 	CT	ct_key
 			{
-				$$ = ct_expr_alloc(&@$, $2, -1, NFPROTO_UNSPEC);
+				$$ = ct_expr_alloc(&@$, $2, -1);
 			}
 			|	CT	ct_dir	ct_key_dir
 			{
-				$$ = ct_expr_alloc(&@$, $3, $2, NFPROTO_UNSPEC);
+				$$ = ct_expr_alloc(&@$, $3, $2);
 			}
-			|	CT	ct_dir	nf_key_proto ct_key_proto_field
+			|	CT	ct_dir	ct_key_proto_field
 			{
-				$$ = ct_expr_alloc(&@$, $4, $2, $3);
+				$$ = ct_expr_alloc(&@$, $3, $2);
 			}
 			;
 
@@ -4102,8 +4102,10 @@ ct_key_dir		:	SADDR		{ $$ = NFT_CT_SRC; }
 			|	ct_key_dir_optional
 			;
 
-ct_key_proto_field	:	SADDR		{ $$ = NFT_CT_SRC; }
-			|	DADDR		{ $$ = NFT_CT_DST; }
+ct_key_proto_field	:	IP	SADDR	{ $$ = NFT_CT_SRC_IP; }
+			|	IP	DADDR	{ $$ = NFT_CT_DST_IP; }
+			|	IP6	SADDR	{ $$ = NFT_CT_SRC_IP6; }
+			|	IP6	DADDR	{ $$ = NFT_CT_DST_IP6; }
 			;
 
 ct_key_dir_optional	:	BYTES		{ $$ = NFT_CT_BYTES; }
diff --git a/src/parser_json.c b/src/parser_json.c
index af7701fcc240..30b171736a8f 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -714,6 +714,10 @@ static bool ct_key_is_dir(enum nft_ct_keys key)
 		NFT_CT_BYTES,
 		NFT_CT_AVGPKT,
 		NFT_CT_ZONE,
+		NFT_CT_SRC_IP,
+		NFT_CT_DST_IP,
+		NFT_CT_SRC_IP6,
+		NFT_CT_DST_IP6,
 	};
 	unsigned int i;
 
@@ -727,9 +731,9 @@ static bool ct_key_is_dir(enum nft_ct_keys key)
 static struct expr *json_parse_ct_expr(struct json_ctx *ctx,
 				       const char *type, json_t *root)
 {
+	int dirval = -1, keyval = -1;
 	const char *key, *dir;
 	unsigned int i;
-	int dirval = -1, familyval, keyval = -1;
 
 	if (json_unpack_err(ctx, root, "{s:s}", "key", &key))
 		return NULL;
@@ -746,10 +750,6 @@ static struct expr *json_parse_ct_expr(struct json_ctx *ctx,
 		return NULL;
 	}
 
-	familyval = json_parse_family(ctx, root);
-	if (familyval < 0)
-		return NULL;
-
 	if (!json_unpack(root, "{s:s}", "dir", &dir)) {
 		if (!strcmp(dir, "original")) {
 			dirval = IP_CT_DIR_ORIGINAL;
@@ -766,7 +766,7 @@ static struct expr *json_parse_ct_expr(struct json_ctx *ctx,
 		}
 	}
 
-	return ct_expr_alloc(int_loc, keyval, dirval, familyval);
+	return ct_expr_alloc(int_loc, keyval, dirval);
 }
 
 static struct expr *json_parse_numgen_expr(struct json_ctx *ctx,
diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index 81d937d97ac9..267eca1a60ea 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -97,10 +97,10 @@ ct both bytes gt 1;fail
 ct bytes original reply;fail
 
 # missing direction
-ct saddr 1.2.3.4;fail
+ct ip saddr 1.2.3.4;fail
 
 # wrong base (ip6 but ipv4 address given)
-meta nfproto ipv6 ct original saddr 1.2.3.4;fail
+meta nfproto ipv6 ct original ip saddr 1.2.3.4;fail
 
 # direction, but must be used without
 ct original mark 42;fail
diff --git a/tests/py/inet/ct.t.json b/tests/py/inet/ct.t.json
index 02bb2d271577..d0c26aef9333 100644
--- a/tests/py/inet/ct.t.json
+++ b/tests/py/inet/ct.t.json
@@ -30,8 +30,7 @@
             "left": {
                 "ct": {
                     "dir": "original",
-                    "family": "ip6",
-                    "key": "saddr"
+                    "key": "ip6 saddr"
                 }
             },
 	    "op": "==",
diff --git a/tests/py/inet/ct.t.json.output b/tests/py/inet/ct.t.json.output
index 8b71519e9be7..74c436a3a79e 100644
--- a/tests/py/inet/ct.t.json.output
+++ b/tests/py/inet/ct.t.json.output
@@ -5,7 +5,6 @@
             "left": {
                 "ct": {
                     "dir": "original",
-                    "family": "ip",
                     "key": "saddr"
                 }
             },
diff --git a/tests/py/inet/ct.t.payload b/tests/py/inet/ct.t.payload
index 97128eccf540..83146869e56c 100644
--- a/tests/py/inet/ct.t.payload
+++ b/tests/py/inet/ct.t.payload
@@ -7,7 +7,6 @@ ip test-ip4 output
 
 # ct original ip6 saddr ::1
 inet test-inet input
-  [ ct load l3protocol => reg 1 , dir original ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ ct load src => reg 1 , dir original ]
+  [ ct load src_ip6 => reg 1 , dir original ]
   [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x01000000 ]
+
diff --git a/tests/py/ip/ct.t.json b/tests/py/ip/ct.t.json
index cc3ab69270cb..881cd4c942c1 100644
--- a/tests/py/ip/ct.t.json
+++ b/tests/py/ip/ct.t.json
@@ -5,8 +5,7 @@
             "left": {
                 "ct": {
                     "dir": "original",
-                    "family": "ip",
-                    "key": "saddr"
+                    "key": "ip saddr"
                 }
             },
 	    "op": "==",
@@ -22,8 +21,7 @@
             "left": {
                 "ct": {
                     "dir": "reply",
-                    "family": "ip",
-                    "key": "saddr"
+                    "key": "ip saddr"
                 }
             },
 	    "op": "==",
@@ -39,8 +37,7 @@
             "left": {
                 "ct": {
                     "dir": "original",
-                    "family": "ip",
-                    "key": "daddr"
+                    "key": "ip daddr"
                 }
             },
 	    "op": "==",
@@ -56,8 +53,7 @@
             "left": {
                 "ct": {
                     "dir": "reply",
-                    "family": "ip",
-                    "key": "daddr"
+                    "key": "ip daddr"
                 }
             },
 	    "op": "==",
@@ -73,8 +69,7 @@
             "left": {
                 "ct": {
                     "dir": "original",
-                    "family": "ip",
-                    "key": "saddr"
+                    "key": "ip saddr"
                 }
             },
 	    "op": "==",
@@ -95,8 +90,7 @@
             "left": {
                 "ct": {
                     "dir": "reply",
-                    "family": "ip",
-                    "key": "saddr"
+                    "key": "ip saddr"
                 }
             },
 	    "op": "==",
@@ -117,8 +111,7 @@
             "left": {
                 "ct": {
                     "dir": "original",
-                    "family": "ip",
-                    "key": "daddr"
+                    "key": "ip daddr"
                 }
             },
 	    "op": "==",
@@ -139,8 +132,7 @@
             "left": {
                 "ct": {
                     "dir": "reply",
-                    "family": "ip",
-                    "key": "daddr"
+                    "key": "ip daddr"
                 }
             },
 	    "op": "==",
diff --git a/tests/py/ip/ct.t.payload b/tests/py/ip/ct.t.payload
index b7cd130dbea2..d5faed4c667c 100644
--- a/tests/py/ip/ct.t.payload
+++ b/tests/py/ip/ct.t.payload
@@ -1,44 +1,44 @@
 # ct original ip saddr 192.168.0.1
 ip test-ip4 output
-  [ ct load src => reg 1 , dir original ]
+  [ ct load src_ip => reg 1 , dir original ]
   [ cmp eq reg 1 0x0100a8c0 ]
 
 # ct reply ip saddr 192.168.0.1
 ip test-ip4 output
-  [ ct load src => reg 1 , dir reply ]
+  [ ct load src_ip => reg 1 , dir reply ]
   [ cmp eq reg 1 0x0100a8c0 ]
 
 # ct original ip daddr 192.168.0.1
 ip test-ip4 output
-  [ ct load dst => reg 1 , dir original ]
+  [ ct load dst_ip => reg 1 , dir original ]
   [ cmp eq reg 1 0x0100a8c0 ]
 
 # ct reply ip daddr 192.168.0.1
 ip test-ip4 output
-  [ ct load dst => reg 1 , dir reply ]
+  [ ct load dst_ip => reg 1 , dir reply ]
   [ cmp eq reg 1 0x0100a8c0 ]
 
 # ct original ip saddr 192.168.1.0/24
 ip test-ip4 output
-  [ ct load src => reg 1 , dir original ]
+  [ ct load src_ip => reg 1 , dir original ]
   [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0001a8c0 ]
 
 # ct reply ip saddr 192.168.1.0/24
 ip test-ip4 output
-  [ ct load src => reg 1 , dir reply ]
+  [ ct load src_ip => reg 1 , dir reply ]
   [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0001a8c0 ]
 
 # ct original ip daddr 192.168.1.0/24
 ip test-ip4 output
-  [ ct load dst => reg 1 , dir original ]
+  [ ct load dst_ip => reg 1 , dir original ]
   [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0001a8c0 ]
 
 # ct reply ip daddr 192.168.1.0/24
 ip test-ip4 output
-  [ ct load dst => reg 1 , dir reply ]
+  [ ct load dst_ip => reg 1 , dir reply ]
   [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0001a8c0 ]
 
-- 
2.11.0

