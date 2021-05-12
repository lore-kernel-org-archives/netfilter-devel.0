Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66679C433B4
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 May 2021 23:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B81161288
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 May 2021 23:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbhELX6Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 May 2021 19:58:24 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59910 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232349AbhELXzW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 May 2021 19:55:22 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7646C6413E
        for <netfilter-devel@vger.kernel.org>; Thu, 13 May 2021 01:53:11 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables] netlink_delinearize: fix binary operation postprocessing with sets
Date:   Thu, 13 May 2021 01:53:57 +0200
Message-Id: <20210512235357.22960-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the right-hand side expression of the binary expression is a set,
then, skip the postprocessing step otherwise the tests/py report the
following warning:

 # ./nft-test.py inet/tcp.t
 inet/tcp.t: WARNING: line 80: 'add rule ip test-ip4 input tcp flags & (syn|fin) == (syn|fin)': 'tcp flags & (fin | syn) == fin | syn' mismatches 'tcp flags ! fin,syn'
 inet/tcp.t: WARNING: line 83: 'add rule ip test-ip4 input tcp flags & (fin | syn | rst | psh | ack | urg) == { fin, ack, psh | ack, fin | psh | ack }': 'tcp flags & (fin | syn | rst | psh | ack | urg) == { fin, ack, psh | ack, fin | psh | ack }' mismatches 'tcp flags ! fin,syn,rst,psh,ack,urg'

This listing is not correct.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 4dd5bdc0787f..81fe4c166499 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2173,6 +2173,7 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *e
 	if (binop->op == OP_AND && (expr->op == OP_NEQ || expr->op == OP_EQ) &&
 	    value->dtype->basetype &&
 	    value->dtype->basetype->type == TYPE_BITMASK &&
+	    value->etype == EXPR_VALUE &&
 	    !mpz_cmp_ui(value->value, 0)) {
 		/* Flag comparison: data & flags != 0
 		 *
-- 
2.20.1

