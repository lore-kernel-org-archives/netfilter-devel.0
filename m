From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/3] segtree: reset element size counter before adding intervals to set
Date: Wed, 24 May 2017 11:53:17 +0200
Message-ID: <1495619598-22759-2-git-send-email-pablo@netfilter.org>
References: <1495619598-22759-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42638 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936744AbdEXJxf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2017 05:53:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6C55D1EC2C1
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 11:53:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5C5C5100A46
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 11:53:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 41406FF6F9
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 11:53:25 +0200 (CEST)
In-Reply-To: <1495619598-22759-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Otherwise we get double the real size in terms of set elements during
the interval expansion to individual elements.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/segtree.c b/src/segtree.c
index 8df82a801ae4..15e8849cd684 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -552,6 +552,7 @@ int set_to_intervals(struct list_head *errs, struct set *set,
 		return -1;
 	segtree_linearize(&list, set, init, &tree, add);
 
+	init->size = 0;
 	list_for_each_entry_safe(ei, next, &list, list) {
 		if (segtree_debug()) {
 			pr_gmp_debug("list: [%.*Zx %.*Zx]\n",
@@ -566,6 +567,7 @@ int set_to_intervals(struct list_head *errs, struct set *set,
 		expr_print(init);
 		pr_gmp_debug("\n");
 	}
+
 	return 0;
 }
 
-- 
2.1.4

