From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2] segtree: don't trigger error on exact overlaps
Date: Tue, 13 Dec 2016 01:42:55 +0100
Message-ID: <1481589775-15168-2-git-send-email-pablo@netfilter.org>
References: <1481589775-15168-1-git-send-email-pablo@netfilter.org>
Cc: richard.moerbitz@tu-dresden.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36928 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752963AbcLMAnU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Dec 2016 19:43:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D432AD162F
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Dec 2016 01:43:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BC863DA804
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Dec 2016 01:43:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7B6C0DA7F6
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Dec 2016 01:43:16 +0100 (CET)
In-Reply-To: <1481589775-15168-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So adding the same element doesn't trigger any error:

 # nft add element filter bogons { 3.3.3.123/24 }
 # nft add element filter bogons { 3.3.3.123/24 }

Still kernel reports an error if we use create instead:

 # nft create element filter bogons { 3.3.3.123/24 }
 <cmdline>:1:1-46: Error: Could not process rule: File exists
 create element filter bogons { 3.3.3.123/24 }
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/segtree.c b/src/segtree.c
index 45e5f5b22e2e..5b6cdd1d770d 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -336,6 +336,10 @@ static unsigned int expr_to_intervals(const struct expr *set,
 static bool interval_overlap(const struct elementary_interval *e1,
 			     const struct elementary_interval *e2)
 {
+	if (mpz_cmp(e1->left, e2->left) == 0 &&
+	    mpz_cmp(e1->right, e2->right) == 0)
+		return false;
+
 	return (mpz_cmp(e1->left, e2->left) >= 0 &&
 	        mpz_cmp(e1->left, e2->right) <= 0) ||
 	       (mpz_cmp(e1->right, e2->left) >= 0 &&
-- 
2.1.4

