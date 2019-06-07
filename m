Return-Path: <SRS0=PuwI=UG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A8CC2BCA1
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 10:39:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CAD020B7C
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 10:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbfFGKjY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Jun 2019 06:39:24 -0400
Received: from mail.us.es ([193.147.175.20]:56804 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726584AbfFGKjY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 06:39:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 748C518FD82
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Jun 2019 12:39:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 658A9DA70A
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Jun 2019 12:39:22 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 64DCCDA702; Fri,  7 Jun 2019 12:39:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0E7EEDA70A
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Jun 2019 12:39:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 07 Jun 2019 12:39:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E9ABB4265A31
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Jun 2019 12:39:19 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: use-after-free in implicit set
Date:   Fri,  7 Jun 2019 12:39:16 +0200
Message-Id: <20190607103916.3241-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

valgrind reports:

==2272== Invalid read of size 4
==2272==    at 0x4E612A5: expr_free (expression.c:86)
==2272==    by 0x4E58EA2: set_free (rule.c:367)
==2272==    by 0x4E612DA: expr_destroy (expression.c:79)
==2272==    by 0x4E612DA: expr_free (expression.c:93)
==2272==    by 0x4E612DA: expr_destroy (expression.c:79)
==2272==    by 0x4E612DA: expr_free (expression.c:93)
==2272==    by 0x4E5D7E7: stmt_free (statement.c:50)
==2272==    by 0x4E5D8B7: stmt_list_free (statement.c:60)
==2272==    by 0x4E590FF: rule_free (rule.c:610)
==2272==    by 0x4E5C094: cmd_free (rule.c:1420)
==2272==    by 0x4E7E7EF: nft_run_cmd_from_filename (libnftables.c:490)
==2272==    by 0x109A53: main (main.c:310)
==2272==  Address 0x65d94c8 is 56 bytes inside a block of size 128 free'd
==2272==    at 0x4C2CDDB: free (vg_replace_malloc.c:530)
==2272==    by 0x4E6143C: mapping_expr_destroy (expression.c:966)
==2272==    by 0x4E612DA: expr_destroy (expression.c:79)
==2272==    by 0x4E612DA: expr_free (expression.c:93)
==2272==    by 0x4E5D7E7: stmt_free (statement.c:50)
==2272==    by 0x4E5D8B7: stmt_list_free (statement.c:60)
==2272==    by 0x4E590FF: rule_free (rule.c:610)
==2272==    by 0x4E5C094: cmd_free (rule.c:1420)
==2272==    by 0x4E7E7EF: nft_run_cmd_from_filename (libnftables.c:490)
==2272==    by 0x109A53: main (main.c:310)
==2272==  Block was alloc'd at
==2272==    at 0x4C2BBAF: malloc (vg_replace_malloc.c:299)
==2272==    by 0x4E79248: xmalloc (utils.c:36)
==2272==    by 0x4E7932D: xzalloc (utils.c:65)
==2272==    by 0x4E60690: expr_alloc (expression.c:45)
==2272==    by 0x4E68B1D: payload_expr_alloc (payload.c:159)
==2272==    by 0x4E91013: nft_parse (parser_bison.y:4242)
==2272==    by 0x4E7E722: nft_parse_bison_filename (libnftables.c:374)
==2272==    by 0x4E7E722: nft_run_cmd_from_filename (libnftables.c:471)
==2272==    by 0x109A53: main (main.c:310)

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 63be2dde8fa2..b9660d778172 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1689,7 +1689,8 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 			break;
 		case EXPR_SET:
 			right = rel->right =
-				implicit_set_declaration(ctx, "__set%d", left, right);
+				implicit_set_declaration(ctx, "__set%d",
+							 expr_get(left), right);
 			/* fall through */
 		case EXPR_SET_REF:
 			/* Data for range lookups needs to be in big endian order */
-- 
2.11.0

