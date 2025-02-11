Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07787236A7C
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Feb 2025 13:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739280754; cv=none; b=tgSPYJZ5L8OXOTqetzvFK27Tx49jYkHoEG4wNGMZFbrpNCjOU09YZiPwWNpneOwokZmdQ7Jy+EEkRFm/yrr/AaQflFbJz+oQKNlIah+4Buf1Xr3mnRSOYtu7T8fZkY5kBX1c8csqBwqpri7sPEs8cWIKKOJzUsbxw6huL3NJ1ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739280754; c=relaxed/simple;
	bh=ih//v6mL88R00Zl8z9xOoTcVurl5bLY+F5jKlIIdISQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EcD18NJwePbR2UG9c9zENpNEFg4cxy+6/LhY9i84HXK640eqzrD4tdKF0NJ1eyQEU5/PpeDHqy/xlGEfKVSbU+RucaPhIwkjhfMqhykRrSEKVng46WNJIrkbNIHHJbVQgTmG8OfXr71of/y/CMuw37H5G+51+/2xBnkShBaA8UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1thqNJ-0003gQ-1S; Tue, 11 Feb 2025 14:32:29 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nf_conntrack: speed up reads from nf_conntrack proc file
Date: Tue, 11 Feb 2025 14:03:06 +0100
Message-ID: <20250211130313.31433-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.3
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

Note that the ctnetlink interface doesn't suffer from this problem.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_standalone.c | 73 +++++++++++++------------
 1 file changed, 38 insertions(+), 35 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 502cf10aab41..2a79e690470a 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -98,51 +98,34 @@ struct ct_iter_state {
 	struct seq_net_private p;
 	struct hlist_nulls_head *hash;
 	unsigned int htable_size;
+	unsigned int skip_elems;
 	unsigned int bucket;
 	u_int64_t time_now;
 };
 
-static struct hlist_nulls_node *ct_get_first(struct seq_file *seq)
+static struct nf_conntrack_tuple_hash *ct_get_next(struct ct_iter_state *st)
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
+		hlist_nulls_for_each_entry(h, n, &st->hash[i], hnnode) {
+			if (skip >= st->skip_elems) {
+				st->bucket = i;
+				return h;
+			}
 
-	head = rcu_dereference(hlist_nulls_next_rcu(head));
-	while (is_a_nulls(head)) {
-		if (likely(get_nulls_value(head) == st->bucket)) {
-			if (++st->bucket >= st->htable_size)
-				return NULL;
+			++skip;
 		}
-		head = rcu_dereference(
-			hlist_nulls_first_rcu(&st->hash[st->bucket]));
-	}
-	return head;
-}
 
-static struct hlist_nulls_node *ct_get_idx(struct seq_file *seq, loff_t pos)
-{
-	struct hlist_nulls_node *head = ct_get_first(seq);
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
@@ -154,13 +137,33 @@ static void *ct_seq_start(struct seq_file *seq, loff_t *pos)
 	rcu_read_lock();
 
 	nf_conntrack_get_ht(&st->hash, &st->htable_size);
-	return ct_get_idx(seq, *pos);
+
+	if (*pos == 0) {
+		st->skip_elems = 0;
+		st->bucket = 0;
+	}
+
+	return ct_get_next(st);
 }
 
 static void *ct_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
+	struct nf_conntrack_tuple_hash *h = v;
+	struct ct_iter_state *st = s->private;
+	struct hlist_nulls_node *n;
+
 	(*pos)++;
-	return ct_get_next(s, v);
+
+	/* more on same hash chain? */
+	n = rcu_dereference(hlist_nulls_next_rcu(&h->hnnode));
+	if (n && !is_a_nulls(n)) {
+		st->skip_elems++;
+		return hlist_nulls_entry(n, struct nf_conntrack_tuple_hash, hnnode);
+	}
+
+	st->skip_elems = 0;
+	st->bucket++;
+	return ct_get_next(st);
 }
 
 static void ct_seq_stop(struct seq_file *s, void *v)
-- 
2.45.3

