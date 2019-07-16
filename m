Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF9E1C7618F
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 17:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4B342145D
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 17:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388294AbfGPRtv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 13:49:51 -0400
Received: from mail.us.es ([193.147.175.20]:45414 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728137AbfGPRtv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 13:49:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 39299F2808
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 19:49:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2A0FA909A9
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 19:49:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1F992D190F; Tue, 16 Jul 2019 19:49:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1582CD190F;
        Tue, 16 Jul 2019 19:49:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 16 Jul 2019 19:49:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E39164265A31;
        Tue, 16 Jul 2019 19:49:46 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     charles@ccxtechnologies.com
Subject: [PATCH nft,v2] evaluate: bogus error when refering to existing non-base chain
Date:   Tue, 16 Jul 2019 19:49:42 +0200
Message-Id: <20190716174943.1038-1-pablo@netfilter.org>
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
v2: keep the check for the expression type in place.

@Charles: would you mind to test this one and confirm crash does not happen
          anymore?

 src/evaluate.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index f95f42e1067a..ed3ca484ad22 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1987,12 +1987,9 @@ static int stmt_evaluate_verdict(struct eval_ctx *ctx, struct stmt *stmt)
 		if (stmt->expr->chain != NULL) {
 			if (expr_evaluate(ctx, &stmt->expr->chain) < 0)
 				return -1;
-			if ((stmt->expr->chain->etype != EXPR_SYMBOL &&
-			    stmt->expr->chain->etype != EXPR_VALUE) ||
-			    stmt->expr->chain->symtype != SYMBOL_VALUE) {
-				return stmt_error(ctx, stmt,
-						  "invalid verdict chain expression %s\n",
-						  expr_name(stmt->expr->chain));
+			if (stmt->expr->chain->etype != EXPR_VALUE) {
+				return expr_error(ctx->msgs, stmt->expr->chain,
+						  "not a value expression");
 			}
 		}
 		break;
-- 
2.11.0

