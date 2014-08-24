From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 4/4] netfilter: ipset: Fix warn: integer overflows 'sizeof(*map) + size * set->dsize'
Date: Sun, 24 Aug 2014 19:49:43 +0200
Message-ID: <1408902583-22451-5-git-send-email-kadlec@blackhole.kfki.hu>
References: <1408902583-22451-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:49435 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbaHXR4W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Aug 2014 13:56:22 -0400
In-Reply-To: <1408902583-22451-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dan Carpenter reported that the static checker emits the warning

        net/netfilter/ipset/ip_set_list_set.c:600 init_list_set()
        warn: integer overflows 'sizeof(*map) + size * set->dsize'

Limit the maximal number of elements in list type of sets.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set_list.h | 1 +
 net/netfilter/ipset/ip_set_list_set.c       | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/ipset/ip_set_list.h b/include/linux/netfilter/ipset/ip_set_list.h
index 68c2aea..fe2622a 100644
--- a/include/linux/netfilter/ipset/ip_set_list.h
+++ b/include/linux/netfilter/ipset/ip_set_list.h
@@ -6,5 +6,6 @@
 
 #define IP_SET_LIST_DEFAULT_SIZE	8
 #define IP_SET_LIST_MIN_SIZE		4
+#define IP_SET_LIST_MAX_SIZE		65536
 
 #endif /* __IP_SET_LIST_H */
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 3e2317f..f87adba 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -597,7 +597,9 @@ init_list_set(struct net *net, struct ip_set *set, u32 size)
 	struct set_elem *e;
 	u32 i;
 
-	map = kzalloc(sizeof(*map) + size * set->dsize, GFP_KERNEL);
+	map = kzalloc(sizeof(*map) +
+		      min_t(u32, size, IP_SET_LIST_MAX_SIZE) * set->dsize,
+		      GFP_KERNEL);
 	if (!map)
 		return false;
 
-- 
1.8.5.1

