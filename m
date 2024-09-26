Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CA4C1AE856;
	Thu, 26 Sep 2024 11:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727348855; cv=none; b=RGv85fez57tB+mgojyLU3wZz6ExcAu0LXqxpHaF1mLaM6H1S8uLmQNg1+4FoKUKa2+rGQF277wHvyn9wJeCKppQUiM6ws9/NQ8RsxTZLprkmr2MmIRcd0WuyUv6LInidiZvFA4usxXLSej6d/M+J0GUrZABve/9UoIgMEQuToFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727348855; c=relaxed/simple;
	bh=0FUDfGQLrg9ZuzXwA7mxN+d4NYgqWE57upUNX6sRdpA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S9Q5DRyjlbg2c0UsaVTDm0p7e0DzveCtdEOoYqzJ1im5/D3fuwZG1C1tb3wVkuLymGybtLq4Sml40xFl6aAmjjCvY/dQTUdItxO13+T99vqpfYv8PWdEy5bBwrm4EhZdi/YI9xk3vt4S6eTHCkyFvzjt1NT8Vpm5GTCPgOFS0oA=
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
Subject: [PATCH net 02/14] netfilter: conntrack: add clash resolution for reverse collisions
Date: Thu, 26 Sep 2024 13:07:05 +0200
Message-Id: <20240926110717.102194-3-pablo@netfilter.org>
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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 56 ++++++++++++++++++++++++++++---
 1 file changed, 51 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d3cb53b008f5..7c63fbfb8c1d 100644
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
+ * @return: true if ct1 and ct2 are identical when swapping origin/reply.
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
2.30.2

