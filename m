From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/5 nft] segtree: when checks when qsorting from interval_map_decompose()
Date: Tue, 19 Jan 2016 18:52:54 +0100
Message-ID: <1453225976-23749-3-git-send-email-pablo@netfilter.org>
References: <1453225976-23749-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, ast@fiberby.dk
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56877 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932738AbcASRxX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2016 12:53:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E1E39231673
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2016 18:53:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CE709DA80B
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2016 18:53:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D5C9ADA803
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2016 18:53:16 +0100 (CET)
In-Reply-To: <1453225976-23749-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If we have two elements with the same key, check the interval flag so we
make sure that the one with the end flag set (ie. closing interval)
comes before the one that starts it.

This is required to decompose adjacent ranges the right way when listing
sets from userspace.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/src/segtree.c b/src/segtree.c
index 060951c..86c37b4 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -483,8 +483,15 @@ static int expr_value_cmp(const void *p1, const void *p2)
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

