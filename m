From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 01/15] netfilter: ipset: list:set: fix reference counter update
Date: Tue,  9 Apr 2013 21:09:44 +0200
Message-ID: <1365534598-23877-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1365534598-23877-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:59776 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935487Ab3DITKA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:10:00 -0400
In-Reply-To: <1365534598-23877-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The last element can be replaced or pushed off and in both
cases the reference counter must be updated.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_list_set.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 8371c2b..09c744a 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -174,9 +174,13 @@ list_set_add(struct list_set *map, u32 i, ip_set_id_t id,
 {
 	const struct set_elem *e = list_set_elem(map, i);
 
-	if (i == map->size - 1 && e->id != IPSET_INVALID_ID)
-		/* Last element replaced: e.g. add new,before,last */
-		ip_set_put_byindex(e->id);
+	if (e->id != IPSET_INVALID_ID) {
+		const struct set_elem *x = list_set_elem(map, map->size - 1);
+
+		/* Last element replaced or pushed off */
+		if (x->id != IPSET_INVALID_ID)
+			ip_set_put_byindex(x->id);
+	}
 	if (with_timeout(map->timeout))
 		list_elem_tadd(map, i, id, ip_set_timeout_set(timeout));
 	else
-- 
1.7.0.4

