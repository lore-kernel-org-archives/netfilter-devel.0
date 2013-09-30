From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 23/26] netfilter: ipset: For set:list types, replaced elements must be zeroed out
Date: Mon, 30 Sep 2013 21:50:34 +0200
Message-ID: <1380570637-31235-24-git-send-email-kadlec@blackhole.kfki.hu>
References: <1380570637-31235-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:60605 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756376Ab3I3Tup (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 15:50:45 -0400
In-Reply-To: <1380570637-31235-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The new extensions require zero initialization for the new element
to be added into a slot from where another element was pushed away.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_list_set.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index f9681dc..e23f33c 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -184,6 +184,8 @@ list_set_add(struct ip_set *set, u32 i, struct set_adt_elem *d,
 			}
 			memmove(list_set_elem(set, map, i + 1), e,
 				set->dsize * (map->size - (i + 1)));
+			/* Extensions must be initialized to zero */
+			memset(e, 0, set->dsize);
 		}
 	}
 
@@ -192,7 +194,7 @@ list_set_add(struct ip_set *set, u32 i, struct set_adt_elem *d,
 		ip_set_timeout_set(ext_timeout(e, set), ext->timeout);
 	if (SET_WITH_COUNTER(set))
 		ip_set_init_counter(ext_counter(e, set), ext);
-	if (SET_WITH_COMMENT(set) && ext->comment)
+	if (SET_WITH_COMMENT(set))
 		ip_set_init_comment(ext_comment(e, set), ext);
 	return 0;
 }
-- 
1.7.0.4

