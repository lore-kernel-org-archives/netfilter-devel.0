Return-Path: <SRS0=tHxH=BH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B02C2C433E4
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jul 2020 18:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94E742070B
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jul 2020 18:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732263AbgG1SPz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jul 2020 14:15:55 -0400
Received: from correo.us.es ([193.147.175.20]:41202 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732261AbgG1SPz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jul 2020 14:15:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 585DC15AEB0
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2020 20:15:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 46DDEDA722
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2020 20:15:53 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3C3CBDA78B; Tue, 28 Jul 2020 20:15:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1C3C5DA78F
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2020 20:15:51 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 28 Jul 2020 20:15:51 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id F32D34265A2F
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2020 20:15:50 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/3] evaluate: UAF in hook priority expression
Date:   Tue, 28 Jul 2020 20:15:46 +0200
Message-Id: <20200728181546.12663-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200728181546.12663-1-pablo@netfilter.org>
References: <20200728181546.12663-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Release priority expression right before assigning the constant
expression that results from the evaluation.

Fixes: 627c451b2351 ("src: allow variables in the chain priority specification")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 536325e83537..7f93621827e6 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3707,7 +3707,6 @@ static bool evaluate_priority(struct eval_ctx *ctx, struct prio_spec *prio,
 	mpz_export_data(prio_str, prio->expr->value, BYTEORDER_HOST_ENDIAN,
 			NFT_NAME_MAXLEN);
 	loc = prio->expr->location;
-	expr_free(prio->expr);
 
 	if (sscanf(prio_str, "%s %c %d", prio_fst, &op, &prio_snd) < 3) {
 		priority = std_prio_lookup(prio_str, family, hook);
@@ -3724,6 +3723,7 @@ static bool evaluate_priority(struct eval_ctx *ctx, struct prio_spec *prio,
 		else
 			return false;
 	}
+	expr_free(prio->expr);
 	prio->expr = constant_expr_alloc(&loc, &integer_type,
 					 BYTEORDER_HOST_ENDIAN,
 					 sizeof(int) * BITS_PER_BYTE,
-- 
2.20.1

