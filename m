Return-Path: <SRS0=4AXv=6N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8350AC83003
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Apr 2020 12:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69A6E20731
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Apr 2020 12:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbgD2MNw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Apr 2020 08:13:52 -0400
Received: from correo.us.es ([193.147.175.20]:40278 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbgD2MNw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Apr 2020 08:13:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 165D11878A8
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 14:13:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0659BBAAA1
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 14:13:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 05A57BAAC0; Wed, 29 Apr 2020 14:13:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0952DBAAA1
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 14:13:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 Apr 2020 14:13:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E730242EF9E2
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 14:13:47 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] nat: transform range to prefix expression when possible
Date:   Wed, 29 Apr 2020 14:13:45 +0200
Message-Id: <20200429121345.8918-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch transform a range of IP addresses to prefix when listing the
ruleset.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h      | 1 +
 src/netlink.c             | 4 ++--
 src/netlink_delinearize.c | 6 +++++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 359348275a04..8135a516cf3a 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -452,6 +452,7 @@ extern struct expr *prefix_expr_alloc(const struct location *loc,
 
 extern struct expr *range_expr_alloc(const struct location *loc,
 				     struct expr *low, struct expr *high);
+struct expr *range_expr_to_prefix(struct expr *range);
 
 extern struct expr *compound_expr_alloc(const struct location *loc,
 					enum expr_types etypes);
diff --git a/src/netlink.c b/src/netlink.c
index 10964720f5d4..bb014320ea6c 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -949,7 +949,7 @@ static uint32_t mpz_bitmask_to_prefix(mpz_t bitmask, uint32_t len)
 	return len - mpz_scan0(bitmask, 0);
 }
 
-static struct expr *expr_range_to_prefix(struct expr *range)
+struct expr *range_expr_to_prefix(struct expr *range)
 {
 	struct expr *left = range->left, *right = range->right, *prefix;
 	uint32_t len = left->len, prefix_len;
@@ -989,7 +989,7 @@ static struct expr *netlink_parse_interval_elem(const struct datatype *dtype,
 	range = range_expr_alloc(&expr->location, left, right);
 	expr_free(expr);
 
-	return expr_range_to_prefix(range);
+	return range_expr_to_prefix(range);
 }
 
 static struct expr *netlink_parse_concat_elem(const struct datatype *dtype,
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 772559c838f5..f721d15c330f 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1103,8 +1103,10 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 		else
 			expr_set_type(addr, &ip6addr_type,
 				      BYTEORDER_BIG_ENDIAN);
-		if (stmt->nat.addr != NULL)
+		if (stmt->nat.addr != NULL) {
 			addr = range_expr_alloc(loc, stmt->nat.addr, addr);
+			addr = range_expr_to_prefix(addr);
+		}
 		stmt->nat.addr = addr;
 	}
 
@@ -2296,6 +2298,8 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 	case EXPR_RANGE:
 		expr_postprocess(ctx, &expr->left);
 		expr_postprocess(ctx, &expr->right);
+	case EXPR_PREFIX:
+		expr_postprocess(ctx, &expr->prefix);
 		break;
 	case EXPR_SET_ELEM:
 		expr_postprocess(ctx, &expr->key);
-- 
2.20.1

