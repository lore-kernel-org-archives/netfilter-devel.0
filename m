Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04666C7EE37
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jun 2023 20:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237218AbjFFU7m (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jun 2023 16:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbjFFU7l (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2023 16:59:41 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DF41717
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2023 13:59:39 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1q6dmD-0001lD-ME; Tue, 06 Jun 2023 22:59:37 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2] netfilter: snat: evict closing tcp entries on reply tuple collision
Date:   Tue,  6 Jun 2023 22:59:30 +0200
Message-Id: <20230606205930.14762-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When all tried source tuples are in use, the connection request (skb)
and the new conntrack will be dropped in nf_confirm() due to the
non-recoverable clash.

Make it so that the last 32 attempts are allowed to evict a colliding
entry if this connection is already closing and the new sequence number
has advanced past the old one.

Such "all tuples taken" secenario can happen with tcp-rpc workloads where
same dst:dport gets queried repeatedly.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: fix uaf, gcc doesn't catch this for some reason. Will
 switch from gcc to clang for future work.

 net/netfilter/nf_nat_core.c | 92 +++++++++++++++++++++++++++++++++++--
 1 file changed, 88 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index ce829d434f13..fadbd4ed3dc0 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -27,6 +27,9 @@
 
 #include "nf_internals.h"
 
+#define NF_NAT_MAX_ATTEMPTS	128
+#define NF_NAT_HARDER_THRESH	(NF_NAT_MAX_ATTEMPTS / 4)
+
 static spinlock_t nf_nat_locks[CONNTRACK_LOCKS];
 
 static DEFINE_MUTEX(nf_nat_proto_mutex);
@@ -197,6 +200,88 @@ nf_nat_used_tuple(const struct nf_conntrack_tuple *tuple,
 	return nf_conntrack_tuple_taken(&reply, ignored_conntrack);
 }
 
+static bool nf_nat_may_kill(struct nf_conn *ct, unsigned long flags)
+{
+	static const unsigned long flags_refuse = IPS_FIXED_TIMEOUT |
+						  IPS_DYING;
+	static const unsigned long flags_needed = IPS_SRC_NAT;
+	enum tcp_conntrack old_state;
+
+	old_state = READ_ONCE(ct->proto.tcp.state);
+	if (old_state < TCP_CONNTRACK_TIME_WAIT)
+		return false;
+
+	if (flags & flags_refuse)
+		return false;
+
+	return (flags & flags_needed) == flags_needed;
+}
+
+/* reverse direction will send packets to new source, so
+ * make sure such packets are invalid.
+ */
+static bool nf_seq_has_advanced(const struct nf_conn *old, const struct nf_conn *new)
+{
+	return (__s32)(new->proto.tcp.seen[0].td_end -
+		       old->proto.tcp.seen[0].td_end) > 0;
+}
+
+static int
+nf_nat_used_tuple_harder(const struct nf_conntrack_tuple *tuple,
+			 const struct nf_conn *ignored_conntrack,
+			 unsigned int attempts_left)
+{
+	static const unsigned long flags_offload = IPS_OFFLOAD | IPS_HW_OFFLOAD;
+	struct nf_conntrack_tuple_hash *thash;
+	const struct nf_conntrack_zone *zone;
+	struct nf_conntrack_tuple reply;
+	unsigned long flags;
+	struct nf_conn *ct;
+	bool taken = true;
+	struct net *net;
+
+	nf_ct_invert_tuple(&reply, tuple);
+
+	if (attempts_left > NF_NAT_HARDER_THRESH ||
+	    tuple->dst.protonum != IPPROTO_TCP ||
+	    ignored_conntrack->proto.tcp.state != TCP_CONNTRACK_SYN_SENT)
+		return nf_conntrack_tuple_taken(&reply, ignored_conntrack);
+
+	/* :ast few attempts to find a free tcp port. Destructive
+	 * action: evict colliding if its in timewait state and the
+	 * tcp sequence number has advanced past the one used by the
+	 * old entry.
+	 */
+	net = nf_ct_net(ignored_conntrack);
+	zone = nf_ct_zone(ignored_conntrack);
+
+	thash = nf_conntrack_find_get(net, zone, &reply);
+	if (!thash)
+		return false;
+
+	ct = nf_ct_tuplehash_to_ctrack(thash);
+
+	if (thash->tuple.dst.dir == IP_CT_DIR_ORIGINAL)
+		goto out;
+
+	if (WARN_ON_ONCE(ct == ignored_conntrack))
+		goto out;
+
+	flags = READ_ONCE(ct->status);
+	if (!nf_nat_may_kill(ct, flags))
+		goto out;
+
+	if (!nf_seq_has_advanced(ct, ignored_conntrack))
+		goto out;
+
+	/* Even if we can evict do not reuse if entry is offloaded. */
+	if (nf_ct_kill(ct))
+		taken = flags & flags_offload;
+out:
+	nf_ct_put(ct);
+	return taken;
+}
+
 static bool nf_nat_inet_in_range(const struct nf_conntrack_tuple *t,
 				 const struct nf_nat_range2 *range)
 {
@@ -385,7 +470,6 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 	unsigned int range_size, min, max, i, attempts;
 	__be16 *keyptr;
 	u16 off;
-	static const unsigned int max_attempts = 128;
 
 	switch (tuple->dst.protonum) {
 	case IPPROTO_ICMP:
@@ -471,8 +555,8 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 		off = get_random_u16();
 
 	attempts = range_size;
-	if (attempts > max_attempts)
-		attempts = max_attempts;
+	if (attempts > NF_NAT_MAX_ATTEMPTS)
+		attempts = NF_NAT_MAX_ATTEMPTS;
 
 	/* We are in softirq; doing a search of the entire range risks
 	 * soft lockup when all tuples are already used.
@@ -483,7 +567,7 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 another_round:
 	for (i = 0; i < attempts; i++, off++) {
 		*keyptr = htons(min + off % range_size);
-		if (!nf_nat_used_tuple(tuple, ct))
+		if (!nf_nat_used_tuple_harder(tuple, ct, attempts - i))
 			return;
 	}
 
-- 
2.39.3

