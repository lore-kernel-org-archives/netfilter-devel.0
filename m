From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 18/22] netfilter: ipset: Collapse same condition body to a single one
Date: Thu, 10 Nov 2016 13:57:52 +0100
Message-ID: <1478782676-9770-19-git-send-email-kadlec@blackhole.kfki.hu>
References: <1478782676-9770-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:49056 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933244AbcKJM6O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Nov 2016 07:58:14 -0500
In-Reply-To: <1478782676-9770-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The set full case (with net_ratelimit()-ed pr_warn()) is already
handled, simply jump there.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index c600f6d..1c9b84e 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -719,14 +719,8 @@ struct htype {
 	key = HKEY(value, h->initval, t->htable_bits);
 	n = __ipset_dereference_protected(hbucket(t, key), 1);
 	if (!n) {
-		if (forceadd) {
-			if (net_ratelimit())
-				pr_warn("Set %s is full, maxelem %u reached\n",
-					set->name, h->maxelem);
-			return -IPSET_ERR_HASH_FULL;
-		} else if (set->elements >= h->maxelem) {
+		if (forceadd || set->elements >= h->maxelem)
 			goto set_full;
-		}
 		old = NULL;
 		n = kzalloc(sizeof(*n) + AHASH_INIT_SIZE * set->dsize,
 			    GFP_ATOMIC);
-- 
1.8.5.1

