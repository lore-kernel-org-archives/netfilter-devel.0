Return-Path: <SRS0=MXD6=UM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F5BCC31E4B
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 728812082C
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731575AbfFMPgM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Jun 2019 11:36:12 -0400
Received: from mail.us.es ([193.147.175.20]:45104 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727493AbfFMKVK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Jun 2019 06:21:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D730611EBA1
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Jun 2019 12:21:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C548CDA711
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Jun 2019 12:21:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C30D4DA70F; Thu, 13 Jun 2019 12:21:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0E3A0DA704
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Jun 2019 12:21:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 13 Jun 2019 12:21:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E83164265A31
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Jun 2019 12:21:05 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2] netlink_delinearize: use-after-free in expr_postprocess_string()
Date:   Thu, 13 Jun 2019 12:20:29 +0200
Message-Id: <20190613102029.12186-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

escaped_string_wildcard_expr_alloc() may reallocate the expression.
valgrind reports errors like this one:

==29945== Invalid write of size 4
==29945==    at 0x72EE944: __expr_postprocess_string (netlink_delinearize.c:2006)
==29945==    by 0x72EE944: expr_postprocess_string (netlink_delinearize.c:2016)
==29945==    by 0x72EE944: expr_postprocess (netlink_delinearize.c:2120)
==29945==    by 0x72EE5A7: expr_postprocess (netlink_delinearize.c:2094)
==29945==    by 0x72EF23B: stmt_expr_postprocess (netlink_delinearize.c:2289)
==29945==    by 0x72EF23B: rule_parse_postprocess (netlink_delinearize.c:2510)
==29945==    by 0x72EF23B: netlink_delinearize_rule (netlink_delinearize.c:2650)
==29945==    by 0x72E6F63: list_rule_cb (netlink.c:330)
==29945==    by 0x7770BD3: nftnl_rule_list_foreach (rule.c:810)
==29945==    by 0x72E739E: netlink_list_rules (netlink.c:349)
==29945==    by 0x72E739E: netlink_list_table (netlink.c:490)
==29945==    by 0x72D4A89: cache_init_objects (rule.c:194)
==29945==    by 0x72D4A89: cache_init (rule.c:216)
==29945==    by 0x72D4A89: cache_update (rule.c:266)
==29945==    by 0x72F829E: nft_evaluate (libnftables.c:388)
==29945==    by 0x72F8A5B: nft_run_cmd_from_buffer (libnftables.c:428)

Remove expr->len, not needed and it triggers use-after-free errors.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: tests/py don't complain anymore.

 src/netlink_delinearize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 6576687ce627..1f63d9d5e2c2 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2003,7 +2003,6 @@ static bool __expr_postprocess_string(struct expr **exprp)
 		escaped_string_wildcard_expr_alloc(exprp, len);
 
 	mpz_clear(tmp);
-	expr->len = len;
 
 	return nulterminated;
 }
@@ -2119,6 +2118,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		if (expr_basetype(expr)->type == TYPE_STRING)
 			*exprp = expr_postprocess_string(expr);
 
+		expr = *exprp;
 		if (expr->dtype->basetype != NULL &&
 		    expr->dtype->basetype->type == TYPE_BITMASK)
 			*exprp = bitmask_expr_to_binops(expr);
-- 
2.11.0

