Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1C114BFA2
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Apr 2025 13:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745327886; cv=none; b=K8ipbjhwHVYO8nW67U6ksvQUhgXWiyxWkLR35/7fRJKenFiZCiy6DgJrkXNg26/z6aM+zZwyAuLH72cF/KL8leHKT3JGjjROuHl7dVy0U5Hmhb4L1rt5e+QRfwi7c2C8/dR3xo90qWJQC6j2qD2Om5pMHihsEwFT/X4ZUKCB68E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745327886; c=relaxed/simple;
	bh=4BH1Vvj2HywYJ+E9HMZ6mH/hGJIjmLMKoKTAkrkNrfU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c6OjR1K678w/a47f2iZQBlDQhzlN0jsnTX7JXvpfWWH+P1WuoNRjoTqMP18lyPeKAASJ0i9YAFjvZ0l3eiulUnAI3+z1P+CVYMGe1WjhQEaReTrKWYany5/4xmxcjmWXlLtHn0NWMp5WHnGdHmqUw+kTCl2GPVRv9WXdXNqwDj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1u7DVh-0001ml-UD; Tue, 22 Apr 2025 15:18:01 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next] netfilter: nf_conntrack: speed up reads from nf_conntrack proc file
Date: Tue, 22 Apr 2025 15:17:29 +0200
Message-ID: <20250422131732.31043-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Dumping all conntrack entries via proc interface can take hours due to
linear search to skip entries dumped so far in each cycle.

Apply same strategy used to speed up ipvs proc reading done in
commit 178883fd039d ("ipvs: speed up reads from ip_vs_conn proc file")
to nf_conntrack.

Note that the ctnetlink interface doesn't suffer from this problem, but
many scripts depend on the nf_conntrack proc interface.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: rescan if entry was moved to different chain (nulls value
     mismatch).

 net/netfilter/nf_conntrack_standalone.c | 88 +++++++++++++++----------
 1 file changed, 53 insertions(+), 35 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 2f666751c7e7..6c4cff10357d 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -98,69 +98,87 @@ struct ct_iter_state {
 	struct seq_net_private p;
 	struct hlist_nulls_head *hash;
 	unsigned int htable_size;
+	unsigned int skip_elems;
 	unsigned int bucket;
 	u_int64_t time_now;
 };
 
-static struct hlist_nulls_node *ct_get_first(struct seq_file *seq)
+static struct nf_conntrack_tuple_hash *ct_get_next(const struct net *net,
+						   struct ct_iter_state *st)
 {
-	struct ct_iter_state *st = seq->private;
+	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
+	unsigned int i;
 
-	for (st->bucket = 0;
-	     st->bucket < st->htable_size;
-	     st->bucket++) {
-		n = rcu_dereference(
-			hlist_nulls_first_rcu(&st->hash[st->bucket]));
-		if (!is_a_nulls(n))
-			return n;
-	}
-	return NULL;
-}
+	for (i = st->bucket; i < st->htable_size; i++) {
+		unsigned int skip = 0;
 
-static struct hlist_nulls_node *ct_get_next(struct seq_file *seq,
-				      struct hlist_nulls_node *head)
-{
-	struct ct_iter_state *st = seq->private;
+restart:
+		hlist_nulls_for_each_entry_rcu(h, n, &st->hash[i], hnnode) {
+			struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
+			struct hlist_nulls_node *tmp = n;
 
-	head = rcu_dereference(hlist_nulls_next_rcu(head));
-	while (is_a_nulls(head)) {
-		if (likely(get_nulls_value(head) == st->bucket)) {
-			if (++st->bucket >= st->htable_size)
-				return NULL;
+			if (!net_eq(net, nf_ct_net(ct)))
+				continue;
+
+			if (++skip <= st->skip_elems)
+				continue;
+
+			/* h should be returned, skip to nulls marker. */
+			while (!is_a_nulls(tmp))
+				tmp = rcu_dereference(hlist_nulls_next_rcu(tmp));
+
+			/* check if h is still linked to hash[i] */
+			if (get_nulls_value(tmp) != i) {
+				skip = 0;
+				goto restart;
+			}
+
+			st->skip_elems = skip;
+			st->bucket = i;
+			return h;
 		}
-		head = rcu_dereference(
-			hlist_nulls_first_rcu(&st->hash[st->bucket]));
-	}
-	return head;
-}
 
-static struct hlist_nulls_node *ct_get_idx(struct seq_file *seq, loff_t pos)
-{
-	struct hlist_nulls_node *head = ct_get_first(seq);
+		skip = 0;
+		if (get_nulls_value(n) != i)
+			goto restart;
+
+		st->skip_elems = 0;
+	}
 
-	if (head)
-		while (pos && (head = ct_get_next(seq, head)))
-			pos--;
-	return pos ? NULL : head;
+	st->bucket = i;
+	return NULL;
 }
 
 static void *ct_seq_start(struct seq_file *seq, loff_t *pos)
 	__acquires(RCU)
 {
 	struct ct_iter_state *st = seq->private;
+	struct net *net = seq_file_net(seq);
 
 	st->time_now = ktime_get_real_ns();
 	rcu_read_lock();
 
 	nf_conntrack_get_ht(&st->hash, &st->htable_size);
-	return ct_get_idx(seq, *pos);
+
+	if (*pos == 0) {
+		st->skip_elems = 0;
+		st->bucket = 0;
+	} else if (st->skip_elems) {
+		/* resume from last dumped entry */
+		st->skip_elems--;
+	}
+
+	return ct_get_next(net, st);
 }
 
 static void *ct_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
+	struct ct_iter_state *st = s->private;
+	struct net *net = seq_file_net(s);
+
 	(*pos)++;
-	return ct_get_next(s, v);
+	return ct_get_next(net, st);
 }
 
 static void ct_seq_stop(struct seq_file *s, void *v)
-- 
2.49.0

