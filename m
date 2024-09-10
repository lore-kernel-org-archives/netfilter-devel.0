Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA0618EFE6
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Sep 2024 09:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961739; cv=none; b=tg+iiK4CUOCernhbgbZYAeVmbD7Myzje6FyYeRJ9qoWE86Ckx+ex2WAuzmsvj4GXxJf+R/IeGeqn7Yriw7fNpLDdqnOqbiXuKTWHnd03a11Y9heXpKdv7siFT6jw5cwwQ+N8DfLlwFShUwfjX1TcaciqdASGyB9G/BRozQdaBS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961739; c=relaxed/simple;
	bh=rLTrq5pZSZPewLPa3y2sChO89gZ9jNUErr0v/ghN5q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlTrr2Nb8sC3nNggIcQvqWSmNQQyJkSSejKlY4eOAr+nLrYBfZKGVm9mWL0WiVcQvOFt7APts+XEJnRCcfpR29Bs5es9s9v+u7/Qd/9Sq7fSat720q4tNz8RIVO+TLzSFfxwUiwRaCYJsbYpHjFIN9pN01CPUQMS1N0a/sSoPNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1snxUW-0002GA-Bi; Tue, 10 Sep 2024 11:48:56 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/3] netfilter: conntrack: add clash resolution for reverse collisions
Date: Tue, 10 Sep 2024 11:38:15 +0200
Message-ID: <20240910093821.4871-3-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
In-Reply-To: <20240910093821.4871-1-fw@strlen.de>
References: <20240910093821.4871-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Given existing entry:
ORIGIN: a:b -> c:d
REPLY:  c:d -> a:b

And colliding entry:
ORIGIN: c:d -> a:b
REPLY:  a:b -> c:d

The colliding ct (and the associated skb) get dropped on insert.
Permit this by checking if the colliding entry matches the reply
direction.

Happens when both ends send packets at same time, both requests are picked
up as NEW, rather than NEW for the 'first' and 'ESTABLISHED' for the
second packet.

This is an esoteric condition, as ruleset must permit NEW connections
in either direction and both peers must already have a bidirectional
traffic flow at the time conntrack gets enabled.

Allow the 'reverse' skb to pass and assign the existing (clashing)
entry.

While at it, also drop the extra 'dying' check, this is already
tested earlier by the calling function.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 56 ++++++++++++++++++++++++++++---
 1 file changed, 51 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d3cb53b008f5..5f21dc7b8e90 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -988,6 +988,56 @@ static void __nf_conntrack_insert_prepare(struct nf_conn *ct)
 		tstamp->start = ktime_get_real_ns();
 }
 
+/**
+ * nf_ct_match_reverse - check if ct1 and ct2 refer to identical flow
+ * @ct1: conntrack in hash table to check against
+ * @ct2: merge candidate
+ *
+ * returns true if ct1 and ct2 happen to refer to the same flow, but
+ * in opposing directions, i.e.
+ * ct1: a:b -> c:d
+ * ct2: c:d -> a:b
+ * for both directions.  If so, @ct2 should not have been created
+ * as the skb should have been picked up as ESTABLISHED flow.
+ * But ct1 was not yet committed to hash table before skb that created
+ * ct2 had arrived.
+ *
+ * Note we don't compare netns because ct entries in different net
+ * namespace cannot clash to begin with.
+ *
+ * Returns true if ct1 and ct2 are identical when swapping origin/reply.
+ */
+static bool
+nf_ct_match_reverse(const struct nf_conn *ct1, const struct nf_conn *ct2)
+{
+	u16 id1, id2;
+
+	if (!nf_ct_tuple_equal(&ct1->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
+			       &ct2->tuplehash[IP_CT_DIR_REPLY].tuple))
+		return false;
+
+	if (!nf_ct_tuple_equal(&ct1->tuplehash[IP_CT_DIR_REPLY].tuple,
+			       &ct2->tuplehash[IP_CT_DIR_ORIGINAL].tuple))
+		return false;
+
+	id1 = nf_ct_zone_id(nf_ct_zone(ct1), IP_CT_DIR_ORIGINAL);
+	id2 = nf_ct_zone_id(nf_ct_zone(ct2), IP_CT_DIR_REPLY);
+	if (id1 != id2)
+		return false;
+
+	id1 = nf_ct_zone_id(nf_ct_zone(ct1), IP_CT_DIR_REPLY);
+	id2 = nf_ct_zone_id(nf_ct_zone(ct2), IP_CT_DIR_ORIGINAL);
+
+	return id1 == id2;
+}
+
+static int nf_ct_can_merge(const struct nf_conn *ct,
+			   const struct nf_conn *loser_ct)
+{
+	return nf_ct_match(ct, loser_ct) ||
+	       nf_ct_match_reverse(ct, loser_ct);
+}
+
 /* caller must hold locks to prevent concurrent changes */
 static int __nf_ct_resolve_clash(struct sk_buff *skb,
 				 struct nf_conntrack_tuple_hash *h)
@@ -999,11 +1049,7 @@ static int __nf_ct_resolve_clash(struct sk_buff *skb,
 
 	loser_ct = nf_ct_get(skb, &ctinfo);
 
-	if (nf_ct_is_dying(ct))
-		return NF_DROP;
-
-	if (((ct->status & IPS_NAT_DONE_MASK) == 0) ||
-	    nf_ct_match(ct, loser_ct)) {
+	if (nf_ct_can_merge(ct, loser_ct)) {
 		struct net *net = nf_ct_net(ct);
 
 		nf_conntrack_get(&ct->ct_general);
-- 
2.44.2

