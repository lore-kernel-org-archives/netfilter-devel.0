Return-Path: <SRS0=FCuH=V3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB910C0650F
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 12:28:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0657206E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 12:28:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=untangle.com header.i=@untangle.com header.b="HwE7uvZ8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbfG3M20 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 08:28:26 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:37876 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbfG3M20 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 08:28:26 -0400
Received: by mail-io1-f66.google.com with SMTP id q22so7797127iog.4
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 05:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=untangle.com; s=google;
        h=from:to:subject:date:message-id;
        bh=4j5/teSlDdA8cCmR5o2TJa1qhAorvE1XnuxVFIFYUtU=;
        b=HwE7uvZ8D53NnaDyI908eRPoXyOa31ca6pcXnnW0stBooVH1ld48qTvl8jNf74lgX9
         bFYBEFR2jkCk0n2qBXXlg1qCHSRehv9UBGGoxZ37KOs4TjjnJ3ig6VS7ofz9LYDh65Dx
         +RmmxhK6tH5cQHQRyZZW9HimsTehSooLrDoSM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=4j5/teSlDdA8cCmR5o2TJa1qhAorvE1XnuxVFIFYUtU=;
        b=hCbp9KUmIb3gUOMJTDl1fwzPIaCqOgTESj/oYQ6HixzAnKwkN+8tIqbGvUaLTnzDf2
         lhznaNrz4wVWuSeCvEtvoqUlc2wFsPMoLW0wA99S3r3EszYnN1xy9bHRbVc4pWFhjWWB
         RuMJ8ZF/Y6jMYYMSsnHeiHYCxbSUs16opLJYOWQQvd2P8qoNWeFUAlhVwZYM57CWBs60
         HWdHoJqnbGYVU4U8SuuUDXwroRPF/yZLXAdxEYL2BcXV91pg1a6CGfJ4hmHxoBfIBnGN
         JUMNm9vRHfkqNDiuRygiPbKnmPdFv/UxGFWk7tBiA4dfHe5ZZPw7XojsutEdC0jeDN29
         oIxg==
X-Gm-Message-State: APjAAAUDVFKW8EHU91PfbTVFhMrcdy2guZfpicG9WAc88zYstwl+xeeC
        oR8r6YGXW8/IiBYhjEogqM97ddzduVUEgg==
X-Google-Smtp-Source: APXvYqxVP2TAtYHwaKi50DMu93YcFHF28jxrBELhD2SPhHkXlEvTvGhHarUcyvwr2gvAnJZD3/a96g==
X-Received: by 2002:a5d:9c12:: with SMTP id 18mr55770572ioe.48.1564489704938;
        Tue, 30 Jul 2019 05:28:24 -0700 (PDT)
Received: from pinebook.zebraskunk.int (cpe-74-137-94-90.kya.res.rr.com. [74.137.94.90])
        by smtp.gmail.com with ESMTPSA id v3sm8964157ioh.58.2019.07.30.05.28.24
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 05:28:24 -0700 (PDT)
From:   Brett Mastbergen <bmastbergen@untangle.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft v2] src: Support maps as left side expressions
Date:   Tue, 30 Jul 2019 08:28:18 -0400
Message-Id: <20190730122818.2032-1-bmastbergen@untangle.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This change allows map expressions on the left side of comparisons:

nft add rule foo bar ip saddr map @map_a == 22 counter

It also allows map expressions as the left side expression of other
map expressions:

nft add rule foo bar ip saddr map @map_a map @map_b == 22 counter

To accomplish this, some additional context needs to be set during
evaluation and delinearization.  A tweak is also make to the parser
logic to allow map expressions as the left hand expression to other
map expressions.

By allowing maps as left side comparison expressions one can map
information in the packet to some arbitrary piece of data and use
the equality (or inequality) to make some decision about the traffic,
unlike today where the result of a map lookup is only usable as the
right side of a statement (like dnat or snat) that actually uses the
value as input.

v2: Add testcases

Signed-off-by: Brett Mastbergen <bmastbergen@untangle.com>
---
 src/evaluate.c                                     |  2 +-
 src/expression.c                                   | 12 +++++++++++-
 src/netlink_delinearize.c                          |  2 ++
 src/parser_bison.y                                 | 10 +++++++---
 .../shell/testcases/maps/dumps/left_side_map_0.nft | 10 ++++++++++
 tests/shell/testcases/maps/dumps/map_to_map_0.nft  | 14 ++++++++++++++
 tests/shell/testcases/maps/left_side_map_0         |  8 ++++++++
 tests/shell/testcases/maps/map_to_map_0            |  9 +++++++++
 8 files changed, 62 insertions(+), 5 deletions(-)
 create mode 100644 tests/shell/testcases/maps/dumps/left_side_map_0.nft
 create mode 100644 tests/shell/testcases/maps/dumps/map_to_map_0.nft
 create mode 100755 tests/shell/testcases/maps/left_side_map_0
 create mode 100755 tests/shell/testcases/maps/map_to_map_0

diff --git a/src/evaluate.c b/src/evaluate.c
index 48c65cd2..59538f27 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1385,6 +1385,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		    !set_is_datamap(map->mappings->set->flags))
 			return expr_error(ctx->msgs, map->mappings,
 					  "Expression is not a map");
+		expr_set_context(&ctx->ectx, map->mappings->set->datatype, map->mappings->set->datalen);
 		break;
 	default:
 		BUG("invalid mapping expression %s\n",
@@ -1399,7 +1400,6 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 					 map->map->dtype->desc);
 
 	datatype_set(map, map->mappings->set->datatype);
-	map->flags |= EXPR_F_CONSTANT;
 
 	/* Data for range lookups needs to be in big endian order */
 	if (map->mappings->set->flags & NFT_SET_INTERVAL &&
diff --git a/src/expression.c b/src/expression.c
index cb49e0b7..e5979394 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1067,8 +1067,18 @@ static const struct expr_ops set_ref_expr_ops = {
 struct expr *set_ref_expr_alloc(const struct location *loc, struct set *set)
 {
 	struct expr *expr;
+	const struct datatype *dtype;
+	unsigned int len;
 
-	expr = expr_alloc(loc, EXPR_SET_REF, set->key->dtype, 0, 0);
+	if (set->flags & NFT_SET_MAP) {
+		dtype = set->datatype;
+		len = set->datalen;
+	} else {
+		dtype = set->key->dtype;
+		len = set->key->len;
+	}
+
+	expr = expr_alloc(loc, EXPR_SET_REF, dtype, 0, len);
 	expr->set = set_get(set);
 	expr->flags |= EXPR_F_CONSTANT;
 	return expr;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index fc2574b1..b70433f0 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -341,6 +341,8 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 	if (nftnl_expr_is_set(nle, NFTNL_EXPR_LOOKUP_DREG)) {
 		dreg = netlink_parse_register(nle, NFTNL_EXPR_LOOKUP_DREG);
 		expr = map_expr_alloc(loc, left, right);
+		expr_set_type(expr, right->dtype, right->byteorder);
+		expr->len = right->len;
 		if (dreg != NFT_REG_VERDICT)
 			return netlink_set_register(ctx, dreg, expr);
 	} else {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 53e66952..9b998d65 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -668,8 +668,8 @@ int nft_lex(void *, void *, void *);
 %type <expr>			concat_expr
 %destructor { expr_free($$); }	concat_expr
 
-%type <expr>			map_expr
-%destructor { expr_free($$); }	map_expr
+%type <expr>			map_expr map_lhs_expr
+%destructor { expr_free($$); }	map_expr map_lhs_expr
 
 %type <expr>			verdict_map_stmt
 %destructor { expr_free($$); }	verdict_map_stmt
@@ -3378,7 +3378,11 @@ multiton_rhs_expr	:	prefix_rhs_expr
 			|	wildcard_expr
 			;
 
-map_expr		:	concat_expr	MAP	rhs_expr
+map_lhs_expr		:	concat_expr
+			|	map_expr
+			;
+
+map_expr		:	map_lhs_expr	MAP	rhs_expr
 			{
 				$$ = map_expr_alloc(&@$, $1, $3);
 			}
diff --git a/tests/shell/testcases/maps/dumps/left_side_map_0.nft b/tests/shell/testcases/maps/dumps/left_side_map_0.nft
new file mode 100644
index 00000000..b93948fc
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/left_side_map_0.nft
@@ -0,0 +1,10 @@
+table ip x {
+	map y {
+		type ipv4_addr : inet_service
+	}
+
+	chain z {
+		type filter hook output priority filter; policy accept;
+		ip saddr map @y 22 counter packets 0 bytes 0
+	}
+}
diff --git a/tests/shell/testcases/maps/dumps/map_to_map_0.nft b/tests/shell/testcases/maps/dumps/map_to_map_0.nft
new file mode 100644
index 00000000..fd7339f9
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/map_to_map_0.nft
@@ -0,0 +1,14 @@
+table ip x {
+	map y {
+		type ipv4_addr : mark
+	}
+
+	map yy {
+		type mark : inet_service
+	}
+
+	chain z {
+		type filter hook output priority filter; policy accept;
+		ip saddr map @y map @yy 22 counter packets 0 bytes 0
+	}
+}
diff --git a/tests/shell/testcases/maps/left_side_map_0 b/tests/shell/testcases/maps/left_side_map_0
new file mode 100755
index 00000000..93c721b7
--- /dev/null
+++ b/tests/shell/testcases/maps/left_side_map_0
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table x
+$NFT add map x y { type ipv4_addr : inet_service\; }
+$NFT add chain ip x z { type filter hook output priority 0 \; }
+$NFT add rule x z ip saddr map @y 22 counter
diff --git a/tests/shell/testcases/maps/map_to_map_0 b/tests/shell/testcases/maps/map_to_map_0
new file mode 100755
index 00000000..95a45f62
--- /dev/null
+++ b/tests/shell/testcases/maps/map_to_map_0
@@ -0,0 +1,9 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table x
+$NFT add map x y { type ipv4_addr : mark\; }
+$NFT add map x yy { type mark : inet_service\; }
+$NFT add chain ip x z { type filter hook output priority 0 \; }
+$NFT add rule x z ip saddr map @y map@yy 22 counter
-- 
2.17.1

