Return-Path: <SRS0=chdK=V2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A61D6C7618B
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 14:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78C212070B
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 14:35:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=untangle.com header.i=@untangle.com header.b="TtQ1tjET"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbfG2OfE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Jul 2019 10:35:04 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:35887 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbfG2OfE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Jul 2019 10:35:04 -0400
Received: by mail-io1-f65.google.com with SMTP id o9so16878520iom.3
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jul 2019 07:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=untangle.com; s=google;
        h=from:to:subject:date:message-id;
        bh=GjQFOvftJzfQIWWf9DQT3mLzT4MhH8oZ+RdT1nr7CPM=;
        b=TtQ1tjETyfzHtjQhK5m2YeGILhos8H5E/zlY2tD5BmZnL61goH7DmRjbNmVtsvAH9L
         A+poMPIIoY93Ed0rWBsarFN0qVFGas7Ks3gCcfuRh1K1GsFtvWuIddCeWa7Nojoe2BAf
         zpRZE7uRjuTtcieflyTuR7LqnF6FuHdknqDgE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=GjQFOvftJzfQIWWf9DQT3mLzT4MhH8oZ+RdT1nr7CPM=;
        b=VjuQipiBXnj1ROWA0EJpi9hDGIY7IUbqtBpRX27o2KggkE+mfWYc62VmvOD/ptDQ9Z
         a2i+MkaacxegoQMxITzEYG5ROnQpOGiQrQfW0gQ1wiONwvSjP4R02pnOLEEgRkKwa5Cv
         8kPda5TNvQ0rl9kk0jtP+FmNZX47zOlo6Izr10pAu8nwkCw+4+jRrpI0yERn5LtSq7jb
         3feKHG3sJaxReb9Fu73sfDGtPTBZS/93K8rv41AWT75+EwcUXUn5VYZqIJGi5ELXIQdw
         zJKmyz6zVC3LDYW3UwYlkt2LiOKAcNNSElKFeTzZRrMGAQ/PS/0dqqfl4wvCl2IbVkbm
         lTmw==
X-Gm-Message-State: APjAAAUG2T2+dkTqlNlyGbM27W4SkD7//oNuJDmLTaVYAKNyS7Dw4yGk
        OtwgmStyVQpV84b4BUG5nenbq4HcxBiNRA==
X-Google-Smtp-Source: APXvYqw2ik+upW9Lvf97Ni+szAUQ7bthzFcC6IaHCM4h7d5thQqjP809zdS+hA9NudMLtPUditv9Hg==
X-Received: by 2002:a02:22c6:: with SMTP id o189mr22711625jao.35.1564410902948;
        Mon, 29 Jul 2019 07:35:02 -0700 (PDT)
Received: from pinebook.zebraskunk.int (cpe-74-137-94-90.kya.res.rr.com. [74.137.94.90])
        by smtp.gmail.com with ESMTPSA id u17sm56831100iob.57.2019.07.29.07.35.02
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 07:35:02 -0700 (PDT)
From:   Brett Mastbergen <bmastbergen@untangle.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: Support maps as left side expressions
Date:   Mon, 29 Jul 2019 10:34:50 -0400
Message-Id: <20190729143450.5733-1-bmastbergen@untangle.com>
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

Signed-off-by: Brett Mastbergen <bmastbergen@untangle.com>
---
 src/evaluate.c            |  2 +-
 src/expression.c          | 12 +++++++++++-
 src/netlink_delinearize.c |  2 ++
 src/parser_bison.y        | 10 +++++++---
 4 files changed, 21 insertions(+), 5 deletions(-)

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
-- 
2.17.1

