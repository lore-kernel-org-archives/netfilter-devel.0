Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A31030C1F1;
	Mon,  5 May 2025 23:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746488531; cv=none; b=r/EzE221rFTXSrwhEYpyxjabB0s038wJpY/Kki3JrdtRLKHXbh3+tjr2BsFNOrd2W936ct8cY4sBxddlTvikvp0xN/mOhGj1Mcse6KzIHB5MlT/OE+ZSC0bDa1LjAAE9TZrKiZgxdZJe2yG///PG8bPg/rREzXisODluwjPEc4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746488531; c=relaxed/simple;
	bh=kdd3mQVBwB7++tB5TY+m3Ktr1QzFHuWr1UG2utClnjI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IYwKwczvkXd1uR1njgOFNTvoBt6bbRRi2f7i1+vTouD6bVy+TQmBJtByhoapeU9AE1ArGIT4PeUnmS8uEFK5NNbKt7a3SLFrPIu9a8Xg9S/dtKOFVxY6aGITUMX0/pr/pV+c5YaxbZwJkzgWc/UMML3Zqkq79TAZYNJ3b72JMiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KVeTctyf; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Rhlcb+2T; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KVeTctyf";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Rhlcb+2T"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 09E6C6065C; Tue,  6 May 2025 01:42:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746488527;
	bh=/dUMYkJorBYhwIl8gqxS3G3TNKe7omnKRnv1Di8RrCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVeTctyfIOtAmpE0E7QCkDhzSeFajNVZ532TtbstqRA/YvWEEgXv+c77vHrNAZkyb
	 Zdv2WRI2xTEkH4q85dEG5KEgy2jVuzk9x8uLEiRI1h1D6T91zwHAL2+00dN5YJkkx6
	 dqFgrzUijDGeNnFHSUoV8W3a8SK8H0uu3WtEGAgvA8+V63KM6qqnvoFEm9xd2YZopP
	 45Nv5zVlCUlgwli/9NcHbxSLzA+0XmhullGQU5TmsGXEVf4lwYeyOUg+Vq2mLcRVVr
	 bWGOgmk6RTgSQBUiectGhvhgYkch3D/ZH+b3GoLO8W7ehkcMSMgMpL/9zhHMJr48ej
	 8DUL8/GbTd09A==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EAB5060657;
	Tue,  6 May 2025 01:41:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746488519;
	bh=/dUMYkJorBYhwIl8gqxS3G3TNKe7omnKRnv1Di8RrCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rhlcb+2T/Sw1LX+RxdnmdWDjZu0zfCGyWzvfXiBM85CB5tJ+1EV9psLyNPADU+bPM
	 inpKC/gzmRuzy58Z6LQhColpspQN/ocimEw7pJUENNrLeOV6NBhO3Jq82xzgizDkNj
	 5ViAUdOkuNsCmqoBIugYro98lr5/V501zcbdiYiYNT8ut1LKweOe6kdlrYTue+XMXr
	 lc/q4PBzmE5WKQxvunfXwel7X2rI1xtFYNvx3zYlq2Agr9k5sKc56uOlm2+OlF9+lS
	 Y+knhTxtM681v1/39KH3B7gnC/ERfFeLOPD09Rf9WH22BHjuYK+6DGpYNxOFX9aBSJ
	 x20Rvqhn3zzzw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH nf-next 4/7] netfilter: nf_conntrack: speed up reads from nf_conntrack proc file
Date: Tue,  6 May 2025 01:41:48 +0200
Message-Id: <20250505234151.228057-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250505234151.228057-1-pablo@netfilter.org>
References: <20250505234151.228057-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Dumping all conntrack entries via proc interface can take hours due to
linear search to skip entries dumped so far in each cycle.

Apply same strategy used to speed up ipvs proc reading done in
commit 178883fd039d ("ipvs: speed up reads from ip_vs_conn proc file")
to nf_conntrack.

Note that the ctnetlink interface doesn't suffer from this problem, but
many scripts depend on the nf_conntrack proc interface.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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
2.30.2

