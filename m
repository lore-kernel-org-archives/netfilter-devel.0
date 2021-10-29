Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C067CC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Oct 2021 20:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A18906103E
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Oct 2021 20:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhJ2Umy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Oct 2021 16:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhJ2Umq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Oct 2021 16:42:46 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA3FC061570
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Oct 2021 13:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CikqITi6V0h61qBIWZIWpY2vwZRdr7UosJyYQeYj9t4=; b=WxuGDa93yNntM337Gox06q3joO
        55KBj8Ci414uZB+Xb4oj2qcMrEUYgA16viPJ3Cv18BKbl8I1g2VdoMjF1U8akUbdKAtABm5CGTiQ+
        zALYlzNGweSFJXpTMA6HTDEjcJN8OkV8mAZ9ODl0NEc2srTVm9IRw5+tjNbeY7IcetQFaOGeDnCSY
        MJJZKQ09j5QaLO2FBMzKc4BPas7AJF0Bpjx3j1seKe/1eJKyPmM8Nl9/KLY7d1KLWt86E5p01OMpQ
        o2wSJHvAoYsr8MO+YNH2ExNcB0PAnk6WGGxZcoou/Gm+qbE3aUoMztl2sITVc1tW5aU0CeRXh5QJM
        8OjEVlNw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgYfb-009Imx-6w; Fri, 29 Oct 2021 21:40:11 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH v2 2/3] parser: add `limit_rate_pkts` and `limit_rate_bytes` rules
Date:   Fri, 29 Oct 2021 21:40:08 +0100
Message-Id: <20211029204009.954315-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211029204009.954315-1-jeremy@azazel.net>
References: <20211029204009.954315-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Factor the `N / time-unit` and `N byte-unit / time-unit` expressions
from limit expressions out into separate `limit_rate_pkts` and
`limit_rate_bytes` rules respectively.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/datatype.h |   4 ++
 src/parser_bison.y | 121 ++++++++++++++++++++++-----------------------
 2 files changed, 63 insertions(+), 62 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 448be57fbc7f..7ddd3566d459 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -309,6 +309,10 @@ extern struct error_record *rate_parse(const struct location *loc,
 extern struct error_record *data_unit_parse(const struct location *loc,
 					    const char *str, uint64_t *rate);
 
+struct limit_rate {
+	uint64_t rate, unit;
+};
+
 extern void expr_chain_export(const struct expr *e, char *chain);
 
 #endif /* NFTABLES_DATATYPE_H */
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3acd80317456..cf1e139d42f3 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -186,6 +186,7 @@ int nft_lex(void *, void *, void *);
 	struct handle_spec	handle_spec;
 	struct position_spec	position_spec;
 	struct prio_spec	prio_spec;
+	struct limit_rate	limit_rate;
 }
 
 %token TOKEN_EOF 0		"end of file"
@@ -607,6 +608,9 @@ int nft_lex(void *, void *, void *);
 %token IN			"in"
 %token OUT			"out"
 
+%type <limit_rate>		limit_rate_pkts
+%type <limit_rate>		limit_rate_bytes
+
 %type <string>			identifier type_identifier string comment_spec
 %destructor { xfree($$); }	identifier type_identifier string comment_spec
 
@@ -3145,42 +3149,31 @@ log_flag_tcp		:	SEQUENCE
 			}
 			;
 
-limit_stmt		:	LIMIT	RATE	limit_mode	NUM	SLASH	time_unit	limit_burst_pkts	close_scope_limit
+limit_stmt		:	LIMIT	RATE	limit_mode	limit_rate_pkts	limit_burst_pkts	close_scope_limit
 	    		{
-				if ($7 == 0) {
-					erec_queue(error(&@7, "limit burst must be > 0"),
+				if ($5 == 0) {
+					erec_queue(error(&@5, "limit burst must be > 0"),
 						   state->msgs);
 					YYERROR;
 				}
 				$$ = limit_stmt_alloc(&@$);
-				$$->limit.rate	= $4;
-				$$->limit.unit	= $6;
-				$$->limit.burst	= $7;
+				$$->limit.rate	= $4.rate;
+				$$->limit.unit	= $4.unit;
+				$$->limit.burst	= $5;
 				$$->limit.type	= NFT_LIMIT_PKTS;
 				$$->limit.flags = $3;
 			}
-			|	LIMIT	RATE	limit_mode	NUM	STRING	limit_burst_bytes	close_scope_limit
+			|	LIMIT	RATE	limit_mode	limit_rate_bytes	limit_burst_bytes	close_scope_limit
 			{
-				struct error_record *erec;
-				uint64_t rate, unit;
-
-				if ($6 == 0) {
-					erec_queue(error(&@6, "limit burst must be > 0"),
+				if ($5 == 0) {
+					erec_queue(error(&@5, "limit burst must be > 0"),
 						   state->msgs);
 					YYERROR;
 				}
-
-				erec = rate_parse(&@$, $5, &rate, &unit);
-				xfree($5);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					YYERROR;
-				}
-
 				$$ = limit_stmt_alloc(&@$);
-				$$->limit.rate	= rate * $4;
-				$$->limit.unit	= unit;
-				$$->limit.burst	= $6;
+				$$->limit.rate	= $4.rate;
+				$$->limit.unit	= $4.unit;
+				$$->limit.burst	= $5;
 				$$->limit.type	= NFT_LIMIT_PKT_BYTES;
 				$$->limit.flags = $3;
 			}
@@ -3250,10 +3243,33 @@ limit_burst_pkts	:	/* empty */			{ $$ = 5; }
 			|	BURST	NUM	PACKETS		{ $$ = $2; }
 			;
 
+limit_rate_pkts		:	NUM     SLASH	time_unit
+			{
+				$$.rate = $1;
+				$$.unit = $3;
+			}
+			;
+
 limit_burst_bytes	:	/* empty */			{ $$ = 5; }
 			|	BURST	limit_bytes		{ $$ = $2; }
 			;
 
+limit_rate_bytes	:	NUM     STRING
+			{
+				struct error_record *erec;
+				uint64_t rate, unit;
+
+				erec = rate_parse(&@$, $2, &rate, &unit);
+				xfree($2);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+				$$.rate = rate * $1;
+				$$.unit = unit;
+			}
+			;
+
 limit_bytes		:	NUM	BYTES		{ $$ = $1; }
 			|	NUM	STRING
 			{
@@ -4283,44 +4299,34 @@ set_elem_stmt		:	COUNTER	close_scope_counter
 				$$->counter.packets = $3;
 				$$->counter.bytes = $5;
 			}
-			|	LIMIT   RATE    limit_mode      NUM     SLASH   time_unit       limit_burst_pkts	close_scope_limit
+			|	LIMIT   RATE    limit_mode      limit_rate_pkts       limit_burst_pkts	close_scope_limit
 			{
-				if ($7 == 0) {
-					erec_queue(error(&@7, "limit burst must be > 0"),
+				if ($5 == 0) {
+					erec_queue(error(&@5, "limit burst must be > 0"),
 						   state->msgs);
 					YYERROR;
 				}
 				$$ = limit_stmt_alloc(&@$);
-				$$->limit.rate  = $4;
-				$$->limit.unit  = $6;
-				$$->limit.burst = $7;
+				$$->limit.rate  = $4.rate;
+				$$->limit.unit  = $4.unit;
+				$$->limit.burst = $5;
 				$$->limit.type  = NFT_LIMIT_PKTS;
 				$$->limit.flags = $3;
 			}
-			|       LIMIT   RATE    limit_mode      NUM     STRING  limit_burst_bytes	close_scope_limit
+			|       LIMIT   RATE    limit_mode      limit_rate_bytes  limit_burst_bytes	close_scope_limit
 			{
-				struct error_record *erec;
-				uint64_t rate, unit;
-
-				if ($6 == 0) {
+				if ($5 == 0) {
 					erec_queue(error(&@6, "limit burst must be > 0"),
 						   state->msgs);
 					YYERROR;
 				}
-				erec = rate_parse(&@$, $5, &rate, &unit);
-				xfree($5);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					YYERROR;
-				}
-
 				$$ = limit_stmt_alloc(&@$);
-				$$->limit.rate  = rate * $4;
-				$$->limit.unit  = unit;
-				$$->limit.burst = $6;
+				$$->limit.rate  = $4.rate;
+				$$->limit.unit  = $4.unit;
+				$$->limit.burst = $5;
 				$$->limit.type  = NFT_LIMIT_PKT_BYTES;
 				$$->limit.flags = $3;
-                        }
+			}
 			|	CT	COUNT	NUM	close_scope_ct
 			{
 				$$ = connlimit_stmt_alloc(&@$);
@@ -4553,34 +4559,25 @@ ct_obj_alloc		:	/* empty */
 			}
 			;
 
-limit_config		:	RATE	limit_mode	NUM	SLASH	time_unit	limit_burst_pkts
+limit_config		:	RATE	limit_mode	limit_rate_pkts	limit_burst_pkts
 			{
 				struct limit *limit;
 
 				limit = &$<obj>0->limit;
-				limit->rate	= $3;
-				limit->unit	= $5;
-				limit->burst	= $6;
+				limit->rate	= $3.rate;
+				limit->unit	= $3.unit;
+				limit->burst	= $4;
 				limit->type	= NFT_LIMIT_PKTS;
 				limit->flags	= $2;
 			}
-			|	RATE	limit_mode	NUM	STRING	limit_burst_bytes
+			|	RATE	limit_mode	limit_rate_bytes	limit_burst_bytes
 			{
 				struct limit *limit;
-				struct error_record *erec;
-				uint64_t rate, unit;
-
-				erec = rate_parse(&@$, $4, &rate, &unit);
-				xfree($4);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					YYERROR;
-				}
 
 				limit = &$<obj>0->limit;
-				limit->rate	= rate * $3;
-				limit->unit	= unit;
-				limit->burst	= $5;
+				limit->rate	= $3.rate;
+				limit->unit	= $3.unit;
+				limit->burst	= $4;
 				limit->type	= NFT_LIMIT_PKT_BYTES;
 				limit->flags	= $2;
 			}
-- 
2.33.0

