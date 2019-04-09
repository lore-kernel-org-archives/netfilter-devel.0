Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33A9EC10F0E
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 22:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0993020830
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 22:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfDIW5Z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 18:57:25 -0400
Received: from mail.us.es ([193.147.175.20]:41844 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726627AbfDIW5Z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 18:57:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 80A9912082C
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Apr 2019 00:57:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7775CDA704
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Apr 2019 00:57:23 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6CA09DA709; Wed, 10 Apr 2019 00:57:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 320E1DA706;
        Wed, 10 Apr 2019 00:57:21 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 10 Apr 2019 00:57:21 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0C7BB4265A31;
        Wed, 10 Apr 2019 00:57:21 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     vaclav.zindulka@tlapnet.cz
Subject: [PATCH nft] segtree: fix memleak in interval_map_decompose()
Date:   Wed, 10 Apr 2019 00:57:17 +0200
Message-Id: <20190409225717.2251-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Do not inconditionally hold reference to start interval.

The handling depends on what kind of range expression we need to build,
either no range at all, a prefix or a plain range. Depending on the
case, we need to partially clone what we need from the expression to
avoid use-after-free.

This fixes valgrind reports that look like this, when listing rulesets:

==30018== 2,057,984 (1,028,992 direct, 1,028,992 indirect) bytes in 8,039 blocks are definitely lost in loss record 76 of 83
==30018==    at 0x4C2BBAF: malloc (vg_replace_malloc.c:299)
==30018==    by 0x4E75978: xmalloc (utils.c:36)
==30018==    by 0x4E75A5D: xzalloc (utils.c:65)
==30018==    by 0x4E5CEC0: expr_alloc (expression.c:45)
==30018==    by 0x4E5D610: mapping_expr_alloc (expression.c:985)
==30018==    by 0x4E6A068: netlink_delinearize_setelem (netlink.c:810)
==30018==    by 0x5B51320: nftnl_set_elem_foreach (set_elem.c:673)
==30018==    by 0x4E6A2D5: netlink_list_setelems (netlink.c:864)
==30018==    by 0x4E56C76: cache_init_objects (rule.c:166)
==30018==    by 0x4E56C76: cache_init (rule.c:216)
==30018==    by 0x4E56C76: cache_update (rule.c:243)
==30018==    by 0x4E64530: cmd_evaluate_list (evaluate.c:3503)
==30018==    by 0x4E64530: cmd_evaluate (evaluate.c:3880)
==30018==    by 0x4E7D12F: nft_parse (parser_bison.y:798)
==30018==    by 0x4E7AB56: nft_parse_bison_buffer (libnftables.c:349)
==30018==    by 0x4E7AB56: nft_run_cmd_from_buffer (libnftables.c:394)

Reported-by: Václav Zindulka <vaclav.zindulka@tlapnet.cz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index 6ee655238b7d..4353e85a02c5 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -872,8 +872,7 @@ void interval_map_decompose(struct expr *set)
 				low = i;
 				continue;
 			}
-		} else
-			expr_get(low);
+		}
 
 		mpz_sub(range, expr_value(i)->value, expr_value(low)->value);
 		mpz_sub_ui(range, range, 1);
@@ -881,7 +880,7 @@ void interval_map_decompose(struct expr *set)
 		mpz_and(p, expr_value(low)->value, range);
 
 		if (!mpz_cmp_ui(range, 0))
-			compound_expr_add(set, low);
+			compound_expr_add(set, expr_get(low));
 		else if ((!range_is_prefix(range) ||
 			  !(i->dtype->flags & DTYPE_F_PREFIX)) ||
 			 mpz_cmp_ui(p, 0)) {
@@ -894,7 +893,9 @@ void interval_map_decompose(struct expr *set)
 			mpz_add(range, range, expr_value(low)->value);
 			mpz_set(tmp->value, range);
 
-			tmp = range_expr_alloc(&low->location, expr_value(low), tmp);
+			tmp = range_expr_alloc(&low->location,
+					       expr_clone(expr_value(low)),
+					       tmp);
 			tmp = set_elem_expr_alloc(&low->location, tmp);
 
 			if (low->etype == EXPR_MAPPING) {
@@ -906,7 +907,7 @@ void interval_map_decompose(struct expr *set)
 					tmp->expiration = low->left->expiration;
 
 				tmp = mapping_expr_alloc(&tmp->location, tmp,
-							 low->right);
+							 expr_clone(low->right));
 			} else {
 				if (low->comment)
 					tmp->comment = xstrdup(low->comment);
@@ -922,7 +923,8 @@ void interval_map_decompose(struct expr *set)
 			unsigned int prefix_len;
 
 			prefix_len = expr_value(i)->len - mpz_scan0(range, 0);
-			prefix = prefix_expr_alloc(&low->location, expr_value(low),
+			prefix = prefix_expr_alloc(&low->location,
+						   expr_clone(expr_value(low)),
 						   prefix_len);
 			prefix->len = expr_value(i)->len;
 
@@ -937,7 +939,7 @@ void interval_map_decompose(struct expr *set)
 					prefix->expiration = low->left->expiration;
 
 				prefix = mapping_expr_alloc(&low->location, prefix,
-							    low->right);
+							    expr_clone(low->right));
 			} else {
 				if (low->comment)
 					prefix->comment = xstrdup(low->comment);
-- 
2.11.0

