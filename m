Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E6241AE860;
	Thu, 26 Sep 2024 11:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727348855; cv=none; b=cDqssL4JOIBtPv5vdprT7hzpgreM4JNVFl3H7QQMschRI8q3YzLonQjQnwY3cDcQMg9ofxx9QTCHxERFNNh8VUNofihlS7po87DravsmljNKfjvY9ztMV+kcc3qiMxSeICwhOrTiwrAx3r3/d/3oDnaJS/Zy0czHxWeXS5orYwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727348855; c=relaxed/simple;
	bh=uV/MbIxaXk4efGLUuoXzHzTrPCbnJ3qqZ2S42swPUMo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nK3YRrHLk6tr3w+VSQ0aMK9Anc4Ber+G1DCxUmHkx79Al7lwhuROtk5+vwPAFDBKI68bxcBS8rPRSQ48Io+I4cWsno8nua5srSCgiPsEHlpV8lg1dO0Ro4za2BkdRZ35mUkF5rsXwx+RxMvFQtA8CJykKZuztpcUFteyrICXSH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 01/14] netfilter: nf_nat: don't try nat source port reallocation for reverse dir clash
Date: Thu, 26 Sep 2024 13:07:04 +0200
Message-Id: <20240926110717.102194-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240926110717.102194-1-pablo@netfilter.org>
References: <20240926110717.102194-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

A conntrack entry can be inserted to the connection tracking table if there
is no existing entry with an identical tuple in either direction.

Example:
INITIATOR -> NAT/PAT -> RESPONDER

Initiator passes through NAT/PAT ("us") and SNAT is done (saddr rewrite).
Then, later, NAT/PAT machine itself also wants to connect to RESPONDER.

This will not work if the SNAT done earlier has same IP:PORT source pair.

Conntrack table has:
ORIGINAL: $IP_INITATOR:$SPORT -> $IP_RESPONDER:$DPORT
REPLY:    $IP_RESPONDER:$DPORT -> $IP_NAT:$SPORT

and new locally originating connection wants:
ORIGINAL: $IP_NAT:$SPORT -> $IP_RESPONDER:$DPORT
REPLY:    $IP_RESPONDER:$DPORT -> $IP_NAT:$SPORT

This is handled by the NAT engine which will do a source port reallocation
for the locally originating connection that is colliding with an existing
tuple by attempting a source port rewrite.

This is done even if this new connection attempt did not go through a
masquerade/snat rule.

There is a rare race condition with connection-less protocols like UDP,
where we do the port reallocation even though its not needed.

This happens when new packets from the same, pre-existing flow are received
in both directions at the exact same time on different CPUs after the
conntrack table was flushed (or conntrack becomes active for first time).

With strict ordering/single cpu, the first packet creates new ct entry and
second packet is resolved as established reply packet.

With parallel processing, both packets are picked up as new and both get
their own ct entry.

In this case, the 'reply' packet (picked up as ORIGINAL) can be mangled by
NAT engine because a port collision is detected.

This change isn't enough to prevent a packet drop later during
nf_conntrack_confirm(), the existing clash resolution strategy will not
detect such reverse clash case.  This is resolved by a followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_core.c | 120 +++++++++++++++++++++++++++++++++++-
 1 file changed, 118 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 6d8da6dddf99..d9ea2c26f309 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -183,7 +183,35 @@ hash_by_src(const struct net *net,
 	return reciprocal_scale(hash, nf_nat_htable_size);
 }
 
-/* Is this tuple already taken? (not by us) */
+/**
+ * nf_nat_used_tuple - check if proposed nat tuple clashes with existing entry
+ * @tuple: proposed NAT binding
+ * @ignored_conntrack: our (unconfirmed) conntrack entry
+ *
+ * A conntrack entry can be inserted to the connection tracking table
+ * if there is no existing entry with an identical tuple in either direction.
+ *
+ * Example:
+ * INITIATOR -> NAT/PAT -> RESPONDER
+ *
+ * INITIATOR passes through NAT/PAT ("us") and SNAT is done (saddr rewrite).
+ * Then, later, NAT/PAT itself also connects to RESPONDER.
+ *
+ * This will not work if the SNAT done earlier has same IP:PORT source pair.
+ *
+ * Conntrack table has:
+ * ORIGINAL: $IP_INITIATOR:$SPORT -> $IP_RESPONDER:$DPORT
+ * REPLY:    $IP_RESPONDER:$DPORT -> $IP_NAT:$SPORT
+ *
+ * and new locally originating connection wants:
+ * ORIGINAL: $IP_NAT:$SPORT -> $IP_RESPONDER:$DPORT
+ * REPLY:    $IP_RESPONDER:$DPORT -> $IP_NAT:$SPORT
+ *
+ * ... which would mean incoming packets cannot be distinguished between
+ * the existing and the newly added entry (identical IP_CT_DIR_REPLY tuple).
+ *
+ * @return: true if the proposed NAT mapping collides with an existing entry.
+ */
 static int
 nf_nat_used_tuple(const struct nf_conntrack_tuple *tuple,
 		  const struct nf_conn *ignored_conntrack)
@@ -200,6 +228,94 @@ nf_nat_used_tuple(const struct nf_conntrack_tuple *tuple,
 	return nf_conntrack_tuple_taken(&reply, ignored_conntrack);
 }
 
+static bool nf_nat_allow_clash(const struct nf_conn *ct)
+{
+	return nf_ct_l4proto_find(nf_ct_protonum(ct))->allow_clash;
+}
+
+/**
+ * nf_nat_used_tuple_new - check if to-be-inserted conntrack collides with existing entry
+ * @tuple: proposed NAT binding
+ * @ignored_ct: our (unconfirmed) conntrack entry
+ *
+ * Same as nf_nat_used_tuple, but also check for rare clash in reverse
+ * direction. Should be called only when @tuple has not been altered, i.e.
+ * @ignored_conntrack will not be subject to NAT.
+ *
+ * @return: true if the proposed NAT mapping collides with existing entry.
+ */
+static noinline bool
+nf_nat_used_tuple_new(const struct nf_conntrack_tuple *tuple,
+		      const struct nf_conn *ignored_ct)
+{
+	static const unsigned long uses_nat = IPS_NAT_MASK | IPS_SEQ_ADJUST_BIT;
+	const struct nf_conntrack_tuple_hash *thash;
+	const struct nf_conntrack_zone *zone;
+	struct nf_conn *ct;
+	bool taken = true;
+	struct net *net;
+
+	if (!nf_nat_used_tuple(tuple, ignored_ct))
+		return false;
+
+	if (!nf_nat_allow_clash(ignored_ct))
+		return true;
+
+	/* Initial choice clashes with existing conntrack.
+	 * Check for (rare) reverse collision.
+	 *
+	 * This can happen when new packets are received in both directions
+	 * at the exact same time on different CPUs.
+	 *
+	 * Without SMP, first packet creates new conntrack entry and second
+	 * packet is resolved as established reply packet.
+	 *
+	 * With parallel processing, both packets could be picked up as
+	 * new and both get their own ct entry allocated.
+	 *
+	 * If ignored_conntrack and colliding ct are not subject to NAT then
+	 * pretend the tuple is available and let later clash resolution
+	 * handle this at insertion time.
+	 *
+	 * Without it, the 'reply' packet has its source port rewritten
+	 * by nat engine.
+	 */
+	if (READ_ONCE(ignored_ct->status) & uses_nat)
+		return true;
+
+	net = nf_ct_net(ignored_ct);
+	zone = nf_ct_zone(ignored_ct);
+
+	thash = nf_conntrack_find_get(net, zone, tuple);
+	if (unlikely(!thash)) /* clashing entry went away */
+		return false;
+
+	ct = nf_ct_tuplehash_to_ctrack(thash);
+
+	/* NB: IP_CT_DIR_ORIGINAL should be impossible because
+	 * nf_nat_used_tuple() handles origin collisions.
+	 *
+	 * Handle remote chance other CPU confirmed its ct right after.
+	 */
+	if (thash->tuple.dst.dir != IP_CT_DIR_REPLY)
+		goto out;
+
+	/* clashing connection subject to NAT? Retry with new tuple. */
+	if (READ_ONCE(ct->status) & uses_nat)
+		goto out;
+
+	if (nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
+			      &ignored_ct->tuplehash[IP_CT_DIR_REPLY].tuple) &&
+	    nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_REPLY].tuple,
+			      &ignored_ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple)) {
+		taken = false;
+		goto out;
+	}
+out:
+	nf_ct_put(ct);
+	return taken;
+}
+
 static bool nf_nat_may_kill(struct nf_conn *ct, unsigned long flags)
 {
 	static const unsigned long flags_refuse = IPS_FIXED_TIMEOUT |
@@ -611,7 +727,7 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 	    !(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL)) {
 		/* try the original tuple first */
 		if (nf_in_range(orig_tuple, range)) {
-			if (!nf_nat_used_tuple(orig_tuple, ct)) {
+			if (!nf_nat_used_tuple_new(orig_tuple, ct)) {
 				*tuple = *orig_tuple;
 				return;
 			}
-- 
2.30.2

