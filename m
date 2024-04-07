Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91B9EA4
	for <netfilter-devel@vger.kernel.org>; Sun,  7 Apr 2024 02:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712455256; cv=none; b=s13dcnu05S2t7DdpQsBIwiLwEUmtTKxcN1QBHPO4GYfIvM8OyPm9fBR+qThcUXv6gSfDTtLukVUHb/gLl2zwkj9UCO31IpwX2K2lbnh7zHTzgiqo4KoWRFV5LqSgqzzbxioYXiAfrmRw7/SF8UFAlCYAmhafc+iFeerI0xGadaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712455256; c=relaxed/simple;
	bh=glSuPbFdjRFXQCXczzfjbHW2GDa6iFRQPiFH1R42dWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=T5+XnLOQJlJKFAz7zFdZwbD9OMWVWdQzlQtzG1eSA1Edmrd4rU59BF57sxe5vl3RMdIzaDN6li458pzxQsr+YOYJI7VIJzsiZf/gSPpWO36hEQRI1heene11K/5M+lrWGg51R2BFlGhhwi9hgrR1Jy02+hCrXYkTsFEXSJu7sIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UiOE8Tx7; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UiOE8Tx7"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6ecee1f325bso2943286b3a.2
        for <netfilter-devel@vger.kernel.org>; Sat, 06 Apr 2024 19:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712455253; x=1713060053; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AT67df3P9OxUasZWYXb1hvrLOfGMDLigg99jx0pQP3A=;
        b=UiOE8Tx7DWSrlj3IaJ2jtTU0olWHaah7MAc6/pMTVBFb+Gzko7aTFlWLLrR7IEwjj+
         qmJ9GQaot/W08Np8ZzrI7ZJxyFqzviB4wh4yX1aqxEYudJyRRfRmL40k3d3TfihLDnD0
         sEy0wlbC9pon8/rIGrcBwPeS8x0RoPPrC+xsdmM4CP4kZp0F6jiDHU15qaEsZq7AX3Sv
         BaCtddDDd/g3ph2KJHh51y3LNt6ESUMUbfW4DddAqk3dlZI67nPA5v961E2ykDqUEjGi
         jldc7bpSgbTbgMS3GtQ4dkyriiaayHtPm6c3q9zrWR3+NoSV2yVu0b7+e7fkb3JF8TLi
         rUpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712455253; x=1713060053;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AT67df3P9OxUasZWYXb1hvrLOfGMDLigg99jx0pQP3A=;
        b=j4ZthFLFC0FAl+ZaW4WqU5w4f8GGKxxHANKP3NifZ44ntjnR25vl9CRUbNAs+e4eyR
         Ew9Ja3iDrSkh3r5sw83Aty3Gerouc0iymbNgqfXzd/lkykKGtqs7Ji0ajK9OPSmWaaNI
         hjfxlfL/5zRVks7buKMm07JseQcVGFYQF7Z5gOUWsB1AP7/WZae4cPHrDTm8J6YZbNaC
         KnTXM8ZJVzMBiwPsIAFbAbqLEIbJw4yO0D1I4FirHcASiaDnRynBg8PI2sz630N94KjD
         LO2NGYLpMTedaJqYEzE0WkDwpTPeQZsdfB0izTwpf4DPSW0/jc8oBBjpW6uTBf/2yd6e
         q2Fg==
X-Gm-Message-State: AOJu0YwY3znLWwWgHZlR4nifRW3fSJGpBmYTWbL/S5Eol4IX81EwV3nJ
	0GpsljI5ZHBy61mdqZ03eb6GGhgFulovwE3WHB7BY7eBn7lH9tphXNmomxCZbv4=
X-Google-Smtp-Source: AGHT+IEkbVY9z0x36d4FwnRUFTvW2LtDTweTGoVe9IINPG7yELBD7qfHlzeFl6BwSjGaUPXyHZDjrA==
X-Received: by 2002:a05:6a00:80f:b0:6ea:b818:f499 with SMTP id m15-20020a056a00080f00b006eab818f499mr7078561pfk.19.1712455252646;
        Sat, 06 Apr 2024 19:00:52 -0700 (PDT)
Received: from localhost.localdomain (122-151-81-38.sta.wbroadband.net.au. [122.151.81.38])
        by smtp.gmail.com with ESMTPSA id v16-20020aa799d0000000b006e567c81d14sm3830411pfi.43.2024.04.06.19.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 19:00:52 -0700 (PDT)
From: Son Dinh <dinhtrason@gmail.com>
To: netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Cc: Son Dinh <dinhtrason@gmail.com>
Subject: [nft PATCH] expr: make map lookup expression as an argument in vmap statement
Date: Sun,  7 Apr 2024 11:58:46 +1000
Message-ID: <20240407015846.1202-1-dinhtrason@gmail.com>
X-Mailer: git-send-email 2.44.0.windows.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Support nested map lookups combined with vmap lookup as shown
in the example below. This syntax enables flexibility to use the
values of a map as keys for looking up vmap when users have two
distinct maps for different purposes and do not want to alter any
packet-related objects (e.g., packet mark, ct mark, ip fields)
to store the value returned from the first map lookup for the
final vmap lookup.

Command:
   add rule ip table-a ip saddr map @map1 vmap @map2

Output:

   chain table-a {
           ip saddr map @map1 vmap @map2
   }

It also supports multiple map lookups prior to vmap if users need
to use multiple maps for the same query, such as

   chain table-a {
           ip saddr map @map1 map @map2 vmap @map3
   }

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1736

Signed-off-by: Son Dinh <dinhtrason@gmail.com>
---
 src/evaluate.c            |  2 +-
 src/netlink_delinearize.c | 12 +++++++-----
 src/parser_bison.y        |  8 ++++++++
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git src/evaluate.c src/evaluate.c
index 1682ba58..07c26d16 100644
--- src/evaluate.c
+++ src/evaluate.c
@@ -2052,7 +2052,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 	expr_set_context(&ctx->ectx, NULL, 0);
 	if (expr_evaluate(ctx, &map->map) < 0)
 		return -1;
-	if (expr_is_constant(map->map))
+	if (map->map->etype != EXPR_MAP && expr_is_constant(map->map))
 		return expr_error(ctx->msgs, map->map,
 				  "Map expression can not be constant");
 
diff --git src/netlink_delinearize.c src/netlink_delinearize.c
index da9f7a91..f8968a25 100644
--- src/netlink_delinearize.c
+++ src/netlink_delinearize.c
@@ -428,11 +428,13 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 		return netlink_error(ctx, loc,
 				     "Lookup expression has no left hand side");
 
-	if (left->len < set->key->len) {
-		expr_free(left);
-		left = netlink_parse_concat_expr(ctx, loc, sreg, set->key->len);
-		if (left == NULL)
-			return;
+	if (left->etype != EXPR_MAP) {
+		if (left->len < set->key->len) {
+			expr_free(left);
+			left = netlink_parse_concat_expr(ctx, loc, sreg, set->key->len);
+			if (left == NULL)
+				return;
+		}
 	}
 
 	right = set_ref_expr_alloc(loc, set);
diff --git src/parser_bison.y src/parser_bison.y
index 61bed761..26b5a50a 100644
--- src/parser_bison.y
+++ src/parser_bison.y
@@ -3254,6 +3254,10 @@ verdict_stmt		:	verdict_expr
 			;
 
 verdict_map_stmt	:	concat_expr	VMAP	verdict_map_expr
+			{
+				$$ = map_expr_alloc(&@$, $1, $3);
+			}
+			|	map_expr	VMAP	verdict_map_expr
 			{
 				$$ = map_expr_alloc(&@$, $1, $3);
 			}
@@ -4579,6 +4583,10 @@ multiton_rhs_expr	:	prefix_rhs_expr
 			;
 
 map_expr		:	concat_expr	MAP	rhs_expr
+			{
+				$$ = map_expr_alloc(&@$, $1, $3);
+			}
+			| map_expr MAP rhs_expr
 			{
 				$$ = map_expr_alloc(&@$, $1, $3);
 			}
-- 
2.44.0.windows.1

