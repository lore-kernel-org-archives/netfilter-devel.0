Return-Path: <SRS0=0X8Q=BA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F50AC433E3
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jul 2020 17:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFF4320714
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jul 2020 17:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730455AbgGURFc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Jul 2020 13:05:32 -0400
Received: from correo.us.es ([193.147.175.20]:50736 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728268AbgGURFb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Jul 2020 13:05:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 407A8120821
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2020 19:05:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 32278DA72F
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2020 19:05:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 27D2ADA722; Tue, 21 Jul 2020 19:05:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F06EBDA72F
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2020 19:05:27 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 21 Jul 2020 19:05:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D52944265A32
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2020 19:05:27 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] evaluate: replace variable expression by the value expression
Date:   Tue, 21 Jul 2020 19:05:24 +0200
Message-Id: <20200721170525.3982-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The variable expression provides the binding between the variable
dereference and the value expression. Replace the variable expression by
the real value expression after the evaluation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 4ec91a1ce771..5111dce55eb6 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2013,10 +2013,13 @@ static int expr_evaluate_variable(struct eval_ctx *ctx, struct expr **exprp)
 {
 	struct expr *new = expr_clone((*exprp)->sym->expr);
 
+	if (expr_evaluate(ctx, &new) < 0)
+		return -1;
+
 	expr_free(*exprp);
 	*exprp = new;
 
-	return expr_evaluate(ctx, exprp);
+	return 0;
 }
 
 static int expr_evaluate_xfrm(struct eval_ctx *ctx, struct expr **exprp)
-- 
2.20.1

