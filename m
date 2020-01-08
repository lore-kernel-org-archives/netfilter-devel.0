Return-Path: <SRS0=uN83=25=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F9BC282DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jan 2020 13:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8350206DB
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jan 2020 13:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbgAHNp1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jan 2020 08:45:27 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:48550 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726186AbgAHNp1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jan 2020 08:45:27 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ipBeG-0003rE-Ud; Wed, 08 Jan 2020 14:45:24 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [RFC nf-next 4/4] netfilter: conntrack: allow insertion of duplicate/clashing entries
Date:   Wed,  8 Jan 2020 14:45:00 +0100
Message-Id: <20200108134500.31727-5-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200108134500.31727-1-fw@strlen.de>
References: <20200108134500.31727-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch further relaxes the need to drop an skb due to a clash with
an existing conntrack entry.

Current clash resolution handles the case where the clash occurs
between two identical entries (distinct nf_conn objects with same
tuples).

Also allow this collision type:
         Original                   Reply
10.2.3.4:42 -> 10.8.8.8:53      10.2.3.4:42 <- 10.0.0.6:5353
10.2.3.4:42 -> 10.8.8.8:53      10.2.3.4:42 <- 10.0.0.7:5353

This frequently happens with DNS resolvers that send A and AAAA queries
back-to-back when NAT rules are present that cause packets to get
different DNAT transformations applied, for example:

-m statistics --mode random ... -j DNAT --dnat-to 10.0.0.6:5353
-m statistics --mode random ... -j DNAT --dnat-to 10.0.0.7:5353

In this case the A or AAAA query is dropped which incurs a costly
delay during name resolution.

This change makes it so that when the 2nd colliding packet is received,
we insert the colliding conntrack anyway, provided the reply direction
is still unique.

The original direction gets inserted after the 'existing' entry, i.e.
it will only be found in the reply case.

Example:

CPU A:						CPU B:
1.  10.2.3.4:42 -> 10.8.8.8:53 (A)
2.                                              10.2.3.4:42 -> 10.8.8.8:53 (AAAA)
3.  Apply DNAT, reply changed to 10.0.0.6
4.                                              10.2.3.4:42 -> 10.8.8.8:53 (AAAA)
5.                                              Apply DNAT, reply changed to 10.0.0.7
6. confirm/commit to conntrack table, no collisions
7.                                              commit clashing entry

Reply comes in:

10.2.3.4:42 <- 10.0.0.6:5353 (A)
 -> Finds a conntrack, DNAT is reversed & packet forwarded to 10.2.3.4:42
10.2.3.4:42 <- 10.0.0.7:5353 (AAAA)
 -> Finds a conntrack, DNAT is reversed & packet forwarded to 10.2.3.4:42

In case of a retransmit from ORIGINAL dir, all further packets will get
the DNAT transformation to 10.0.0.6.

Also, the clashing entry will get a fixed timeout, we want to expire it
early of possible.

Example entries:
udp 29 src=192.168.7.10 dst=10.8.8.8 sport=7843 dport=53 src=127.0.0.1 dst=192.168.7.10 sport=1053 dport=7843 [ASSURED] use=1
udp  2 src=192.168.7.10 dst=10.8.8.8 sport=7843 dport=53 src=127.0.0.1 dst=192.168.7.10 sport=1054 dport=7843 [ASSURED] use=1

The 2nd entry has a fixed timeout and will always expire, even if it
continues to receive data.

I tried to come up with other solutions but this is the only one that
doesn't involve changes to the ruleset (the other solution is to make
sure that all packets from same origin get the same NAT transformation
e.g. via "-m cluster" instead of "-m statistics".

nft has the 'jhash' expression which can be used instead of 'numgen'.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 87 ++++++++++++++++++++++++++++++-
 1 file changed, 85 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 2987b2d72b6b..97c00fdc7ecf 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -940,11 +940,82 @@ static int __nf_ct_resolve_clash(struct sk_buff *skb,
 	return NF_DROP;
 }
 
+/**
+ * nf_ct_resolve_clash_harder - attempt to insert clashing conntrack entry
+ *
+ * @skb: skb that causes the collision
+ * @hash: hash slot for original direction
+ * @hash_reply: hash slot for reply direction
+ *
+ * Called when origin or reply direction had a clash.
+ * The skb can be handled without packet drop provided the
+ * reply direction has no clash or the clashing and existing entries
+ * have the same tuples in both directions.
+ *
+ * Caller must hold conntrack table locks for both slots to prevent
+ * concurrent updates.
+ *
+ * Returns NF_DROP if the clash could not be handled.
+ */
+static int nf_ct_resolve_clash_harder(struct sk_buff *skb,
+				      u32 hash, u32 reply_hash)
+{
+	struct nf_conn *loser_ct = (struct nf_conn *)skb_nfct(skb);
+	const struct nf_conntrack_zone *zone;
+	struct nf_conntrack_tuple_hash *h;
+	struct hlist_nulls_node *n;
+	unsigned int len;
+	struct net *net;
+
+	zone = nf_ct_zone(loser_ct);
+	net = nf_ct_net(loser_ct);
+
+	/* Reply direction must never result in a clash, unless both origin
+	 * and reply tuples are identical.
+	 */
+	hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[reply_hash], hnnode) {
+		if (nf_ct_key_equal(h,
+				    &loser_ct->tuplehash[IP_CT_DIR_REPLY].tuple,
+				    zone, net)) {
+			/* Clash in reply direction: OK if origin is same too. */
+			return __nf_ct_resolve_clash(skb, h);
+		}
+	}
+
+	/* No clash in reply, so its clashing in original direction
+	 * (else, this function would not have been called).
+	 *
+	 * Also check hash chain length before we allow insertion.
+	 */
+	len = 0;
+	hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[hash], hnnode) {
+		if (len++ > 8u)
+			return NF_DROP;
+	}
+
+	/* We want the clashing entry to go away soon */
+	loser_ct->timeout = nfct_time_stamp + HZ * 3u;
+	loser_ct->status |= IPS_FIXED_TIMEOUT;
+
+	__nf_conntrack_insert_prepare(loser_ct);
+	/* ... use add_tail_rcu for ORIGINAL dir: we want lookups
+	 * to find the entry already in table, not loser_ct.
+	 */
+	hlist_nulls_add_tail_rcu(&loser_ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode,
+				 &nf_conntrack_hash[hash]);
+
+	hlist_nulls_add_head_rcu(&loser_ct->tuplehash[IP_CT_DIR_REPLY].hnnode,
+				 &nf_conntrack_hash[reply_hash]);
+	return NF_ACCEPT;
+}
+
 /**
  * nf_ct_resolve_clash - attempt to handle clash without packet drop
  *
  * @skb: skb that causes the clash
  * @h: tuplehash of the clashing entry already in table
+ * @hash: hash slot for original direction
+ * @hash_reply: hash slot for reply direction
  *
  * A conntrack entry can be inserted to the connection tracking table
  * if there is no existing entry with an identical tuple.
@@ -963,10 +1034,18 @@ static int __nf_ct_resolve_clash(struct sk_buff *skb,
  * exactly the same, only the to-be-confirmed conntrack entry is discarded
  * and @skb is associated with the conntrack entry already in the table.
  *
+ * Failing that, the new, unconfirmed conntrack is still added to the table
+ * provided that the collision only occurs in the ORIGINAL direction.
+ * The new entry will be added after the existing one in the hash list,
+ * so packets in the ORIGINAL direction will continue to match the existing
+ * entry.  The new entry will also have a fixed timeout so it expires --
+ * due to the collision, it will not see bidirectional traffic.
+ *
  * Returns NF_DROP if the clash could not be resolved.
  */
 static __cold noinline int
-nf_ct_resolve_clash(struct sk_buff *skb, struct nf_conntrack_tuple_hash *h)
+nf_ct_resolve_clash(struct sk_buff *skb, struct nf_conntrack_tuple_hash *h,
+		    u32 hash, u32 reply_hash)
 {
 	/* This is the conntrack entry already in hashes that won race. */
 	struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
@@ -987,6 +1066,10 @@ nf_ct_resolve_clash(struct sk_buff *skb, struct nf_conntrack_tuple_hash *h)
 	if (ret == NF_ACCEPT)
 		return ret;
 
+	ret = nf_ct_resolve_clash_harder(skb, hash, reply_hash);
+	if (ret == NF_ACCEPT)
+		return ret;
+
 drop:
 	nf_ct_add_to_dying_list(loser_ct);
 	NF_CT_STAT_INC(net, drop);
@@ -1101,7 +1184,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	return NF_ACCEPT;
 
 out:
-	ret = nf_ct_resolve_clash(skb, h);
+	ret = nf_ct_resolve_clash(skb, h, hash, reply_hash);
 dying:
 	nf_conntrack_double_unlock(hash, reply_hash);
 	local_bh_enable();
-- 
2.24.1

