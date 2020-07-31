Return-Path: <SRS0=oAJK=BK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1CA6C433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 18:22:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3A3A21744
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 18:22:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387693AbgGaSW5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 Jul 2020 14:22:57 -0400
Received: from correo.us.es ([193.147.175.20]:51572 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387513AbgGaSW5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Jul 2020 14:22:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AEFDBDA70F
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2020 20:22:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9F401DA722
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2020 20:22:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 94D0ADA78B; Fri, 31 Jul 2020 20:22:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6FE0ADA722
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2020 20:22:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 Jul 2020 20:22:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 531A04265A32
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2020 20:22:53 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: disregard ct address matching without family
Date:   Fri, 31 Jul 2020 20:22:49 +0200
Message-Id: <20200731182249.13781-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The following rule:

 # nft add rule ip x y ct original daddr @servers

breaks with:

 # nft list ruleset
nft: netlink_delinearize.c:124: netlink_parse_concat_expr: Assertion `consumed > 0' failed.
Aborted

Bail out if this syntax is used, instead users should rely on:

 # nft add rule ip x y ct original ip daddr @servers
                                   ~~

which uses NFT_CT_{SRC,DST}_{IP,IP6} in the bytecode generation.

This issue is described in 7f742d0a9071 ("ct: support for
NFT_CT_{SRC,DST}_{IP,IP6}").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index a99b11437342..b64ed3c0c6a4 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1907,6 +1907,12 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 							 right);
 			/* fall through */
 		case EXPR_SET_REF:
+			if (rel->left->etype == EXPR_CT &&
+			    (rel->left->ct.key == NFT_CT_SRC ||
+			     rel->left->ct.key == NFT_CT_DST))
+				return expr_error(ctx->msgs, left,
+						  "specify either ip or ip6 for address matching");
+
 			/* Data for range lookups needs to be in big endian order */
 			if (right->set->flags & NFT_SET_INTERVAL &&
 			    byteorder_conversion(ctx, &rel->left, BYTEORDER_BIG_ENDIAN) < 0)
-- 
2.20.1

