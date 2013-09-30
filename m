From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 15/26] netfilter: ipset: list:set: make sure all elements are checked by the gc
Date: Mon, 30 Sep 2013 21:50:26 +0200
Message-ID: <1380570637-31235-16-git-send-email-kadlec@blackhole.kfki.hu>
References: <1380570637-31235-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:60588 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756316Ab3I3Tul (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 15:50:41 -0400
In-Reply-To: <1380570637-31235-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When an element timed out, the next one was skipped by the garbage
collector, fixed.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_list_set.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index e44986a..30bf1dd 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -218,13 +218,16 @@ set_cleanup_entries(struct ip_set *set)
 {
 	struct list_set *map = set->data;
 	struct set_elem *e;
-	u32 i;
+	u32 i = 0;
 
-	for (i = 0; i < map->size; i++) {
+	while (i < map->size) {
 		e = list_set_elem(set, map, i);
 		if (e->id != IPSET_INVALID_ID &&
 		    ip_set_timeout_expired(ext_timeout(e, set)))
 			list_set_del(set, i);
+			/* Check element moved to position i in next loop */
+		else
+			i++;
 	}
 }
 
-- 
1.7.0.4

