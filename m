From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 1/4] netfilter: ipset: Compress return logic
Date: Mon, 11 Sep 2017 21:52:37 +0200
Message-ID: <1505159560-13161-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1505159560-13161-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:39626 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751615AbdIKTwn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Sep 2017 15:52:43 -0400
In-Reply-To: <1505159560-13161-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: simran singhal <singhalsimran0@gmail.com>

Simplify function returns by merging assignment and return into one
command line.

Signed-off-by: simran singhal <singhalsimran0@gmail.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_list_set.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 178d4eb..2fff6b5 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -453,7 +453,6 @@ static size_t
 list_set_memsize(const struct list_set *map, size_t dsize)
 {
 	struct set_elem *e;
-	size_t memsize;
 	u32 n = 0;
 
 	rcu_read_lock();
@@ -461,9 +460,7 @@ list_set_memsize(const struct list_set *map, size_t dsize)
 		n++;
 	rcu_read_unlock();
 
-	memsize = sizeof(*map) + n * dsize;
-
-	return memsize;
+	return (sizeof(*map) + n * dsize);
 }
 
 static int
-- 
2.1.4

