From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 61/64]: xt_hashlimit: speedup hash_dst()
Date: Tue, 18 Dec 2007 00:47:36 +0100 (MET)
Message-ID: <20071217234736.23601.98380.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39069 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933345AbXLQXrh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:37 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_hashlimit: speedup hash_dst()

1) Using jhash2() instead of jhash() is a litle bit faster if applicable.

2) Thanks to jhash, hash value uses full 32 bits.
   Instead of returning hash % size (implying a divide)
   we return the high 32 bits of the (hash * size) that will
   give results between [0 and size-1] and same hash distribution.

  On most cpus, a multiply is less expensive than a divide, by an order
  of magnitude.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 990af8a278165f0bf91b6d13d9caa61260633868
tree 3804d1bb66fe40adf69e2cd4ef425079fd007b99
parent 561162888ca9bb1ca4a95c41e7d4e03aae0d79c7
author Eric Dumazet <dada1@cosmosbay.com> Mon, 17 Dec 2007 14:58:57 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:25:00 +0100

 net/netfilter/xt_hashlimit.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 951d4c8..651c1d2 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -105,7 +105,16 @@ static inline bool dst_cmp(const struct dsthash_ent *ent,
 static u_int32_t
 hash_dst(const struct xt_hashlimit_htable *ht, const struct dsthash_dst *dst)
 {
-	return jhash(dst, sizeof(*dst), ht->rnd) % ht->cfg.size;
+	u_int32_t hash = jhash2((const u32 *)dst,
+				sizeof(*dst)/sizeof(u32),
+				ht->rnd);
+	/*
+	 * Instead of returning hash % ht->cfg.size (implying a divide)
+	 * we return the high 32 bits of the (hash * ht->cfg.size) that will
+	 * give results between [0 and cfg.size-1] and same hash distribution,
+	 * but using a multiply, less expensive than a divide
+	 */
+	return ((u64)hash * ht->cfg.size) >> 32;
 }
 
 static struct dsthash_ent *
