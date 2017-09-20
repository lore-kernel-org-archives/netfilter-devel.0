From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2] netfilter: ipset: ipset list may return wrong member count for set with timeout
Date: Wed, 20 Sep 2017 12:49:03 +0200
Message-ID: <1505904543-10004-3-git-send-email-pablo@netfilter.org>
References: <1505904543-10004-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57052 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751607AbdITKtO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2017 06:49:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B66FB20A521
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2017 12:49:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A43AF4FA0D
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2017 12:49:12 +0200 (CEST)
In-Reply-To: <1505904543-10004-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Vishwanath Pai <vpai@akamai.com>

Simple testcase:

$ ipset create test hash:ip timeout 5
$ ipset add test 1.2.3.4
$ ipset add test 1.2.2.2
$ sleep 5

$ ipset l
Name: test
Type: hash:ip
Revision: 5
Header: family inet hashsize 1024 maxelem 65536 timeout 5
Size in memory: 296
References: 0
Number of entries: 2
Members:

We return "Number of entries: 2" but no members are listed. That is
because mtype_list runs "ip_set_timeout_expired" and does not list the
expired entries, but set->elements is never upated (until mtype_gc
cleans it up later).

Reviewed-by: Joshua Hunt <johunt@akamai.com>
Signed-off-by: Vishwanath Pai <vpai@akamai.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index f236c0bc7b3f..51063d9ed0f7 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1041,12 +1041,24 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 static int
 mtype_head(struct ip_set *set, struct sk_buff *skb)
 {
-	const struct htype *h = set->data;
+	struct htype *h = set->data;
 	const struct htable *t;
 	struct nlattr *nested;
 	size_t memsize;
 	u8 htable_bits;
 
+	/* If any members have expired, set->elements will be wrong
+	 * mytype_expire function will update it with the right count.
+	 * we do not hold set->lock here, so grab it first.
+	 * set->elements can still be incorrect in the case of a huge set,
+	 * because elements might time out during the listing.
+	 */
+	if (SET_WITH_TIMEOUT(set)) {
+		spin_lock_bh(&set->lock);
+		mtype_expire(set, h);
+		spin_unlock_bh(&set->lock);
+	}
+
 	rcu_read_lock_bh();
 	t = rcu_dereference_bh_nfnl(h->table);
 	memsize = mtype_ahash_memsize(h, t) + set->ext_size;
-- 
2.1.4

