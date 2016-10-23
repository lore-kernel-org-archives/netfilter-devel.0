From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 06/22] netfilter: ipset: Separate memsize calculation code into dedicated function
Date: Sun, 23 Oct 2016 22:37:39 +0200
Message-ID: <1477255075-15255-7-git-send-email-kadlec@blackhole.kfki.hu>
References: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:52277 "EHLO smtp1.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756738AbcJWUiD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Oct 2016 16:38:03 -0400
In-Reply-To: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hash types already has it's memsize calculation code in separate
functions. Do the same for *bitmap* and *list* sets.

Ported from a patch proposed by Sergey Popovich <popovich_sergei@mail.ua>.

Suggested-by: Sergey Popovich <popovich_sergei@mail.ua>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_bitmap_gen.h | 13 ++++++++++++-
 net/netfilter/ipset/ip_set_list_set.c   | 23 +++++++++++++++++------
 2 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 2e8e7e5..c22cdde 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -22,6 +22,7 @@
 #define mtype_kadt		IPSET_TOKEN(MTYPE, _kadt)
 #define mtype_uadt		IPSET_TOKEN(MTYPE, _uadt)
 #define mtype_destroy		IPSET_TOKEN(MTYPE, _destroy)
+#define mtype_memsize		IPSET_TOKEN(MTYPE, _memsize)
 #define mtype_flush		IPSET_TOKEN(MTYPE, _flush)
 #define mtype_head		IPSET_TOKEN(MTYPE, _head)
 #define mtype_same_set		IPSET_TOKEN(MTYPE, _same_set)
@@ -84,12 +85,22 @@
 	memset(map->members, 0, map->memsize);
 }
 
+/* Calculate the actual memory size of the set data */
+static size_t
+mtype_memsize(const struct mtype *map, size_t dsize)
+{
+	size_t memsize = sizeof(*map) +
+			 map->memsize +
+			 map->elements * dsize;
+	return memsize;
+}
+
 static int
 mtype_head(struct ip_set *set, struct sk_buff *skb)
 {
 	const struct mtype *map = set->data;
 	struct nlattr *nested;
-	size_t memsize = sizeof(*map) + map->memsize;
+	size_t memsize = mtype_memsize(map, set->dsize);
 
 	nested = ipset_nest_start(skb, IPSET_ATTR_DATA);
 	if (!nested)
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index a2a89e4..462b0b1 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -441,12 +441,12 @@ struct list_set {
 	set->data = NULL;
 }
 
-static int
-list_set_head(struct ip_set *set, struct sk_buff *skb)
+/* Calculate the actual memory size of the set data */
+static size_t
+list_set_memsize(const struct list_set *map, size_t dsize)
 {
-	const struct list_set *map = set->data;
-	struct nlattr *nested;
 	struct set_elem *e;
+	size_t memsize;
 	u32 n = 0;
 
 	rcu_read_lock();
@@ -454,13 +454,24 @@ struct list_set {
 		n++;
 	rcu_read_unlock();
 
+	memsize = sizeof(*map) + n * dsize;
+
+	return memsize;
+}
+
+static int
+list_set_head(struct ip_set *set, struct sk_buff *skb)
+{
+	const struct list_set *map = set->data;
+	struct nlattr *nested;
+	size_t memsize = list_set_memsize(map, set->dsize);
+
 	nested = ipset_nest_start(skb, IPSET_ATTR_DATA);
 	if (!nested)
 		goto nla_put_failure;
 	if (nla_put_net32(skb, IPSET_ATTR_SIZE, htonl(map->size)) ||
 	    nla_put_net32(skb, IPSET_ATTR_REFERENCES, htonl(set->ref)) ||
-	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE,
-			  htonl(sizeof(*map) + n * set->dsize)))
+	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)))
 		goto nla_put_failure;
 	if (unlikely(ip_set_put_flags(skb, set)))
 		goto nla_put_failure;
-- 
1.8.5.1

