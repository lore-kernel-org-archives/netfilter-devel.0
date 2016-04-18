From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/7] segtree: clone full expression from interval_map_decompose()
Date: Mon, 18 Apr 2016 20:14:30 +0200
Message-ID: <1461003275-2330-3-git-send-email-pablo@netfilter.org>
References: <1461003275-2330-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35438 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbcDRSOz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Apr 2016 14:14:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0E3BDC1084
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:14:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DDC6B9D0FE
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:14:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 98BCF9D0F8
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:14:50 +0200 (CEST)
In-Reply-To: <1461003275-2330-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of cloning just its value, expr_value() expects a set element or
mapping.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/segtree.c b/src/segtree.c
index 5b69ffb..75f02b9 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -520,7 +520,7 @@ void interval_map_decompose(struct expr *set)
 		if (i->flags & EXPR_F_INTERVAL_END)
 			interval = false;
 		else if (interval) {
-			end = expr_clone(expr_value(i));
+			end = expr_clone(i);
 			end->flags |= EXPR_F_INTERVAL_END;
 			ranges[n++] = end;
 		} else
-- 
2.1.4

