Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE0FC76188
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 11:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2341B20880
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 11:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbfGPLv1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 07:51:27 -0400
Received: from mail.us.es ([193.147.175.20]:33744 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727796AbfGPLv1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 07:51:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E34E6C1A65
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 13:51:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D5F20D1929
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 13:51:25 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CB6ECD190F; Tue, 16 Jul 2019 13:51:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BA03EDA704;
        Tue, 16 Jul 2019 13:51:23 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 16 Jul 2019 13:51:23 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8DF3A4265A32;
        Tue, 16 Jul 2019 13:51:23 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     charles@ccxtechnologies.com
Subject: [PATCH nft] evaluate: bogus error when refering to existing non-base chain
Date:   Tue, 16 Jul 2019 13:51:20 +0200
Message-Id: <20190716115120.21710-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 add rule ip testNEW test6 jump test8
                                ^^^^^
 Error: invalid verdict chain expression value

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index f95f42e1067a..cd566e856a11 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1984,17 +1984,9 @@ static int stmt_evaluate_verdict(struct eval_ctx *ctx, struct stmt *stmt)
 	case EXPR_VERDICT:
 		if (stmt->expr->verdict != NFT_CONTINUE)
 			stmt->flags |= STMT_F_TERMINAL;
-		if (stmt->expr->chain != NULL) {
-			if (expr_evaluate(ctx, &stmt->expr->chain) < 0)
-				return -1;
-			if ((stmt->expr->chain->etype != EXPR_SYMBOL &&
-			    stmt->expr->chain->etype != EXPR_VALUE) ||
-			    stmt->expr->chain->symtype != SYMBOL_VALUE) {
-				return stmt_error(ctx, stmt,
-						  "invalid verdict chain expression %s\n",
-						  expr_name(stmt->expr->chain));
-			}
-		}
+		if (stmt->expr->chain != NULL &&
+		    expr_evaluate(ctx, &stmt->expr->chain) < 0)
+			return -1;
 		break;
 	case EXPR_MAP:
 		break;
-- 
2.11.0

