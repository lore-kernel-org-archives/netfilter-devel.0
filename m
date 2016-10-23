From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 16/22] netfilter: ipset: Collapse same condition body to a single one
Date: Sun, 23 Oct 2016 22:37:49 +0200
Message-ID: <1477255075-15255-17-git-send-email-kadlec@blackhole.kfki.hu>
References: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:50909 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756778AbcJWUiH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Oct 2016 16:38:07 -0400
In-Reply-To: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 0082ccf..f4b30b6 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -721,14 +721,8 @@ struct htype {
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

