From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 3/7] segtree: handle adjacent interval nodes from expr_value_cmp()
Date: Mon, 18 Apr 2016 20:14:31 +0200
Message-ID: <1461003275-2330-4-git-send-email-pablo@netfilter.org>
References: <1461003275-2330-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35443 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbcDRSOz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Apr 2016 14:14:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 8FB2EC1068
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:14:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 794A59D10D
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:14:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2209E9D106
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:14:51 +0200 (CEST)
In-Reply-To: <1461003275-2330-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Named sets may contain adjacent interval nodes, when equal in key, look
at the flags. Those with EXPR_F_INTERVAL_END should come in first place.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/src/segtree.c b/src/segtree.c
index 75f02b9..d8f98fa 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -487,8 +487,15 @@ static int expr_value_cmp(const void *p1, const void *p2)
 {
 	struct expr *e1 = *(void * const *)p1;
 	struct expr *e2 = *(void * const *)p2;
+	int ret;
 
-	return mpz_cmp(expr_value(e1)->value, expr_value(e2)->value);
+	ret = mpz_cmp(expr_value(e1)->value, expr_value(e2)->value);
+	if (ret == 0 && (e1->flags & EXPR_F_INTERVAL_END))
+		return -1;
+	else
+		return 1;
+
+	return ret;
 }
 
 void interval_map_decompose(struct expr *set)
-- 
2.1.4

