From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 4/4] netfilter: ipset: ipset list may return wrong member count for set with timeout
Date: Mon, 11 Sep 2017 21:52:40 +0200
Message-ID: <1505159560-13161-5-git-send-email-kadlec@blackhole.kfki.hu>
References: <1505159560-13161-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:39641 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751618AbdIKTwp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Sep 2017 15:52:45 -0400
In-Reply-To: <1505159560-13161-1-git-send-email-kadlec@blackhole.kfki.hu>
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
---
 net/netfilter/ipset/ip_set_hash_gen.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index f236c0b..51063d9 100644
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

