Return-Path: <SRS0=E6gp=UJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A69DC282DD
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jun 2019 11:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58073207E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jun 2019 11:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389379AbfFJLxm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jun 2019 07:53:42 -0400
Received: from mail.us.es ([193.147.175.20]:44736 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388373AbfFJLxl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jun 2019 07:53:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 075E2BAF13
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jun 2019 13:53:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E3698DA70E
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jun 2019 13:53:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 83746DA71A; Mon, 10 Jun 2019 13:53:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7679ADA71A;
        Mon, 10 Jun 2019 13:53:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 10 Jun 2019 13:53:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4E7064265A2F;
        Mon, 10 Jun 2019 13:53:37 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     ffmancera@riseup.net
Subject: [PATCH nft] expression: use expr_clone() from verdict_expr_clone()
Date:   Mon, 10 Jun 2019 13:53:33 +0200
Message-Id: <20190610115333.27294-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Chains are now expressions, do not assume a constant value is used.

Fixes: f1e8a129ee42 ("src: Introduce chain_expr in jump and goto statements")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expression.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expression.c b/src/expression.c
index a41e2dafe9fc..ef694f2a194d 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -217,7 +217,7 @@ static void verdict_expr_clone(struct expr *new, const struct expr *expr)
 {
 	new->verdict = expr->verdict;
 	if (expr->chain != NULL)
-		mpz_init_set(new->chain->value, expr->chain->value);
+		new->chain = expr_clone(expr->chain);
 }
 
 static void verdict_expr_destroy(struct expr *expr)
-- 
2.11.0

