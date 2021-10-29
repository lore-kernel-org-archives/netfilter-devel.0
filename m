Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E1C2C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Oct 2021 20:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6179F61040
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Oct 2021 20:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbhJ2Umy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Oct 2021 16:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbhJ2Umq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Oct 2021 16:42:46 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAC7C061714
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Oct 2021 13:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=m5rWr82lBjyAKtePQ+6lmhfGRTD3IaW4FRoxBVUaJjk=; b=RB3Mb42cF9G6nmflIXd7eUQfvT
        75rMK/+ZC0naIYIb6d8olorfkN1CihkLGv/UsVOK9QGuOGsKmdJIR4pDL5cL1PRnobxQG4qlPaLOC
        ezp+N4XQOKGegFCDSQJ9pjmhSMBJIr9a/PHTFKcgbWdUxVuMLZ447Z8oypxQrs0gYBpL5BCD61ic9
        WR8Ti1VfQc0Ad9BnqkYUktLtk41FRKgNSfHygG/NUXqkK34SdwzluTy6p1sARYA2KnG+iZhJiQN6K
        +yOkRAbvw9uhZxiiwjPJmonCABM1LkObrNIIFT1Aer5e381KCPSTrseJJIbE+libN5GeKPZ0iNsqV
        M8PIB2gw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgYfb-009Imx-1j; Fri, 29 Oct 2021 21:40:11 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH v2 1/3] parser: add new `limit_bytes` rule
Date:   Fri, 29 Oct 2021 21:40:07 +0100
Message-Id: <20211029204009.954315-2-jeremy@azazel.net>
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

Refactor the `N byte-unit` expression out of the `limit_bytes_burst`
rule into a separate `limit_bytes` rule.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/parser_bison.y | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index c25af6ba114a..3acd80317456 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -689,7 +689,7 @@ int nft_lex(void *, void *, void *);
 %type <val>			level_type log_flags log_flags_tcp log_flag_tcp
 %type <stmt>			limit_stmt quota_stmt connlimit_stmt
 %destructor { stmt_free($$); }	limit_stmt quota_stmt connlimit_stmt
-%type <val>			limit_burst_pkts limit_burst_bytes limit_mode time_unit quota_mode
+%type <val>			limit_burst_pkts limit_burst_bytes limit_mode limit_bytes time_unit quota_mode
 %type <stmt>			reject_stmt reject_stmt_alloc
 %destructor { stmt_free($$); }	reject_stmt reject_stmt_alloc
 %type <stmt>			nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc redir_stmt redir_stmt_alloc
@@ -3251,19 +3251,22 @@ limit_burst_pkts	:	/* empty */			{ $$ = 5; }
 			;
 
 limit_burst_bytes	:	/* empty */			{ $$ = 5; }
-			|	BURST	NUM	BYTES		{ $$ = $2; }
-			|	BURST	NUM	STRING
+			|	BURST	limit_bytes		{ $$ = $2; }
+			;
+
+limit_bytes		:	NUM	BYTES		{ $$ = $1; }
+			|	NUM	STRING
 			{
 				struct error_record *erec;
 				uint64_t rate;
 
-				erec = data_unit_parse(&@$, $3, &rate);
-				xfree($3);
+				erec = data_unit_parse(&@$, $2, &rate);
+				xfree($2);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
 				}
-				$$ = $2 * rate;
+				$$ = $1 * rate;
 			}
 			;
 
-- 
2.33.0

