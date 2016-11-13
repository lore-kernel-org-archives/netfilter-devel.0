From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 33/39] netfilter: ipset: Collapse same condition body to a single one
Date: Sun, 13 Nov 2016 23:25:27 +0100
Message-ID: <1479075933-4491-34-git-send-email-pablo@netfilter.org>
References: <1479075933-4491-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47782 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965159AbcKMW02 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 13 Nov 2016 17:26:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 57FF5C106A
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Nov 2016 23:26:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 42D6CDA861
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Nov 2016 23:26:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 44122DA862
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Nov 2016 23:26:25 +0100 (CET)
In-Reply-To: <1479075933-4491-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

The set full case (with net_ratelimit()-ed pr_warn()) is already
handled, simply jump there.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index c600f6d9f15e..1c9b84e53dcc 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -719,14 +719,8 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
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
2.1.4

