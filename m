Return-Path: <SRS0=ghWo=UD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B39C282CE
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Jun 2019 12:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16BD9218CD
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Jun 2019 12:15:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfFDMPt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Jun 2019 08:15:49 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49170 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726994AbfFDMPt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Jun 2019 08:15:49 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hY8Lz-0006N0-2W; Tue, 04 Jun 2019 14:15:47 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: conntrack: small conntrack lookup optimization
Date:   Tue,  4 Jun 2019 14:14:04 +0200
Message-Id: <20190604121404.30351-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

____nf_conntrack_find() performs checks on the conntrack objects in
this order:

1. if (nf_ct_is_expired(ct))

This fetches ct->timeout, in third cache line.

The hnnode that is used to store the list pointers resides in the first
(origin) or second (reply tuple) cache lines.

This test rarely passes, but its necessary to reap obsolete entries.

2. if (nf_ct_is_dying(ct))

This fetches ct->status, also in third cache line.

The test is useless, and can be removed:
  Consider:
     cpu0                                           cpu1
    ct = ____nf_conntrack_find()
    atomic_inc_not_zero(ct) -> ok
    nf_ct_key_equal -> ok
    is_dying -> DYING bit not set, ok
                                                    set_bit(ct, DYING);
						    ... unhash ... etc.
    return ct
    -> returning a ct with dying bit set, despite
    having a test for it.

This (unlikely) case is fine - refcount prevents ct from getting free'd.

3. if (nf_ct_key_equal(h, tuple, zone, net))

nf_ct_key_equal checks in following order:

1. Tuple equal (first or second cacheline)
2. Zone equal (third cacheline)
3. confirmed bit set (->status, third cacheline)
4. net namespace match (third cacheline).

Swapping "timeout" and "cpu" places timeout in the first cacheline.
This has two advantages:

1. For a conntrack that won't even match the original tuple,
   we will now only fetch the first and maybe the second cacheline
   instead of always accessing the 3rd one as well.

2.  in case of TCP ct->timeout changes frequently because we
    reduce/increase it when there are packets outstanding in the network.

The first cacheline contains both the reference count and the ct spinlock,
i.e. moving timeout there avoids writes to 3rd cacheline.

The restart sequence in __nf_conntrack_find() is removed, if we found a
candidate, but then fail to increment the refcount or discover the tuple
has changed (object recycling), just pretend we did not find an entry.

A second lookup won't find anything until another CPU adds a new conntrack
with identical tuple into the hash table, which is very unlikely.

We have the confirmation-time checks (when we hold hash lock) that deal
with identical entries and even perform clash resolution in some cases.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack.h |  7 +++----
 net/netfilter/nf_conntrack_core.c    | 25 +++++++++++++------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 5cb19ce454d1..c86657d99630 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -70,7 +70,8 @@ struct nf_conn {
 	struct nf_conntrack ct_general;
 
 	spinlock_t	lock;
-	u16		cpu;
+	/* jiffies32 when this ct is considered dead */
+	u32 timeout;
 
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	struct nf_conntrack_zone zone;
@@ -82,9 +83,7 @@ struct nf_conn {
 	/* Have we seen traffic both ways yet? (bitset) */
 	unsigned long status;
 
-	/* jiffies32 when this ct is considered dead */
-	u32 timeout;
-
+	u16		cpu;
 	possible_net_t ct_net;
 
 #if IS_ENABLED(CONFIG_NF_NAT)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 98f8262f84d2..83143bccb2e7 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -752,9 +752,6 @@ ____nf_conntrack_find(struct net *net, const struct nf_conntrack_zone *zone,
 			continue;
 		}
 
-		if (nf_ct_is_dying(ct))
-			continue;
-
 		if (nf_ct_key_equal(h, tuple, zone, net))
 			return h;
 	}
@@ -780,20 +777,24 @@ __nf_conntrack_find_get(struct net *net, const struct nf_conntrack_zone *zone,
 	struct nf_conn *ct;
 
 	rcu_read_lock();
-begin:
+
 	h = ____nf_conntrack_find(net, zone, tuple, hash);
 	if (h) {
+		/* We have a candidate that matches the tuple we're interested
+		 * in, try to obtain a reference and re-check tuple
+		 */
 		ct = nf_ct_tuplehash_to_ctrack(h);
-		if (unlikely(nf_ct_is_dying(ct) ||
-			     !atomic_inc_not_zero(&ct->ct_general.use)))
-			h = NULL;
-		else {
-			if (unlikely(!nf_ct_key_equal(h, tuple, zone, net))) {
-				nf_ct_put(ct);
-				goto begin;
-			}
+		if (likely(atomic_inc_not_zero(&ct->ct_general.use))) {
+			if (likely(nf_ct_key_equal(h, tuple, zone, net)))
+				goto found;
+
+			/* TYPESAFE_BY_RCU recycled the candidate */
+			nf_ct_put(ct);
 		}
+
+		h = NULL;
 	}
+found:
 	rcu_read_unlock();
 
 	return h;
-- 
2.21.0

