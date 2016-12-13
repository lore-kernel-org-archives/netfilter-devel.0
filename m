From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] segtree: wrong prefix expression length on interval_map_decompose()
Date: Tue, 13 Dec 2016 01:42:54 +0100
Message-ID: <1481589775-15168-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: richard.moerbitz@tu-dresden.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36926 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753006AbcLMAnU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Dec 2016 19:43:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6E638D1628
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Dec 2016 01:43:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F481DA801
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Dec 2016 01:43:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0B0E0DA795
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Dec 2016 01:43:14 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

interval_map_decompose() sets expr->len to zero. This causes problems
from expr_to_intervals() that calls range_expr_value_high() and
calculates:

	 expr->len - expr->prefix_len

this operation underflows, then mpz_init_bitmask() allocates a huge
bitmask.

Use expr_value(i)->len given that we already use this to calculate the
prefix length.

Reported-by: Richard Mörbitz <richard.moerbitz@tu-dresden.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/segtree.c b/src/segtree.c
index 32e071f6b5e8..45e5f5b22e2e 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -693,7 +693,8 @@ void interval_map_decompose(struct expr *set)
 			prefix_len = expr_value(i)->len - mpz_scan0(range, 0);
 			prefix = prefix_expr_alloc(&low->location, expr_value(low),
 						   prefix_len);
-			prefix->len = low->len;
+			prefix->len = expr_value(i)->len;
+
 			prefix = set_elem_expr_alloc(&low->location, prefix);
 			if (low->ops->type == EXPR_MAPPING)
 				prefix = mapping_expr_alloc(&low->location, prefix,
-- 
2.1.4

