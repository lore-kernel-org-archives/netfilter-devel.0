Return-Path: <SRS0=EzAQ=BI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF933C433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jul 2020 18:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1C802053B
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jul 2020 18:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgG2SHF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jul 2020 14:07:05 -0400
Received: from correo.us.es ([193.147.175.20]:52244 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbgG2SHF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jul 2020 14:07:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6628BEBAC3
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2020 20:07:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 57B5BDA73D
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2020 20:07:03 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4D663DA72F; Wed, 29 Jul 2020 20:07:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 56F9EDA73D
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2020 20:07:01 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 Jul 2020 20:07:01 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3AD8142EFB82
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2020 20:07:01 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] netlink_delinearize: transform binary operation to prefix only with values
Date:   Wed, 29 Jul 2020 20:06:58 +0200
Message-Id: <20200729180658.26211-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The following rule:

 nft add rule inet filter input ip6 saddr and ffff:ffff:ffff:ffff:: @allowable counter

when listing the ruleset becomes:

 ip6 saddr @allowable/64 counter packets 3 bytes 212

This transformation is unparseable, allow prefix transformation only for
values.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index d0438f44058d..9e3ed53d09f1 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2102,7 +2102,7 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *e
 
 		expr_free(binop);
 	} else if (binop->left->dtype->flags & DTYPE_F_PREFIX &&
-		   binop->op == OP_AND &&
+		   binop->op == OP_AND && expr->right->etype == EXPR_VALUE &&
 		   expr_mask_is_prefix(binop->right)) {
 		expr->left = expr_get(binop->left);
 		expr->right = prefix_expr_alloc(&expr->location,
-- 
2.20.1

