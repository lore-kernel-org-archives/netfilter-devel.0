From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/4] segtree: set expr->len for prefix expression from interval_map_decompose()
Date: Sat, 23 Apr 2016 18:08:37 +0200
Message-ID: <1461427720-4939-2-git-send-email-pablo@netfilter.org>
References: <1461427720-4939-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33748 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbcDWQIx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Apr 2016 12:08:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 18D8B114805
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Apr 2016 18:08:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 098289D0E2
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Apr 2016 18:08:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EDD959D0E2
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Apr 2016 18:08:48 +0200 (CEST)
In-Reply-To: <1461427720-4939-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This field needs to be set for the new interval overlap detection.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/segtree.c b/src/segtree.c
index 668c085..f544704 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -624,6 +624,7 @@ void interval_map_decompose(struct expr *set)
 			prefix_len = expr_value(i)->len - mpz_scan0(range, 0);
 			prefix = prefix_expr_alloc(&low->location, expr_value(low),
 						   prefix_len);
+			prefix->len = low->len;
 			prefix = set_elem_expr_alloc(&low->location, prefix);
 			if (low->ops->type == EXPR_MAPPING)
 				prefix = mapping_expr_alloc(&low->location, prefix,
-- 
2.1.4

