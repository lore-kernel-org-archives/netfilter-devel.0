Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98ADCC48BE8
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Jun 2021 01:12:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 689306101B
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Jun 2021 01:12:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbhFQBOb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Jun 2021 21:14:31 -0400
Received: from mail.netfilter.org ([217.70.188.207]:47340 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbhFQBOb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Jun 2021 21:14:31 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2CC4F6422B
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Jun 2021 03:11:04 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] netlink_delinearize: memleak in string netlink postprocessing
Date:   Thu, 17 Jun 2021 03:12:15 +0200
Message-Id: <20210617011215.4808-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Listing a matching wilcard string results in a memleak: ifname "dummy*"

Direct leak of 136 byte(s) in 1 object(s) allocated from:
    #0 0x7f27ba52e330 in __interceptor_malloc (/usr/lib/x86_64-linux-gnu/libasan.so.5+0xe9330)
    #1 0x7f27b9e1d434 in xmalloc /home/pablo/devel/scm/git-netfilter/nftables/src/utils.c:36
    #2 0x7f27b9e1d5f3 in xzalloc /home/pablo/devel/scm/git-netfilter/nftables/src/utils.c:75
    #3 0x7f27b9d2e8c6 in expr_alloc /home/pablo/devel/scm/git-netfilter/nftables/src/expression.c:45
    #4 0x7f27b9d326e9 in constant_expr_alloc /home/pablo/devel/scm/git-netfilter/nftables/src/expression.c:419
    #5 0x7f27b9db9318 in netlink_alloc_value /home/pablo/devel/scm/git-netfilter/nftables/src/netlink.c:390
    #6 0x7f27b9de0433 in netlink_parse_cmp /home/pablo/devel/scm/git-netfilter/nftables/src/netlink_delinearize.c:321
    #7 0x7f27b9deb025 in netlink_parse_expr /home/pablo/devel/scm/git-netfilter/nftables/src/netlink_delinearize.c:1764
    #8 0x7f27b9deb0de in netlink_parse_rule_expr /home/pablo/devel/scm/git-netfilter/nftables/src/netlink_delinearize.c:1776
    #9 0x7f27b860af7b in nftnl_expr_foreach /home/pablo/devel/scm/git-netfilter/libnftnl/src/rule.c:690

Direct leak of 8 byte(s) in 1 object(s) allocated from:
    #0 0x7f27ba52e330 in __interceptor_malloc (/usr/lib/x86_64-linux-gnu/libasan.so.5+0xe9330)
    #1 0x7f27b9e1d434 in xmalloc /home/pablo/devel/scm/git-netfilter/nftables/src/utils.c:36
    #2 0x7f27b96975c5 in __gmpz_init2 (/usr/lib/x86_64-linux-gnu/libgmp.so.10+0x1c5c5)

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 5c80397db26c..bf4712e65d2c 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2332,8 +2332,10 @@ static struct expr *expr_postprocess_string(struct expr *expr)
 	mask = constant_expr_alloc(&expr->location, &integer_type,
 				   BYTEORDER_HOST_ENDIAN,
 				   expr->len + BITS_PER_BYTE, NULL);
+	mpz_clear(mask->value);
 	mpz_init_bitmask(mask->value, expr->len);
 	out = string_wildcard_expr_alloc(&expr->location, mask, expr);
+	expr_free(expr);
 	expr_free(mask);
 	return out;
 }
-- 
2.20.1

