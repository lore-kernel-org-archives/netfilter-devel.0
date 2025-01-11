Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 652FE1BBBD3;
	Sat, 11 Jan 2025 23:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736636891; cv=none; b=lnoJaO1afE1ljeyVRxa1/EkxJWtR0GczEOuhH2MZLobSR02FfvKepdlgxByO9QZZpTxBAIZn0vY8ZhGWtbQj/h28Uo+XWjoH4wPNjXtgU/xpnUGnDfs05m7t31BTQRO9uxIryyvoTJITFpZRzAtnxeboSr2tJxCoZgxNm/JjRJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736636891; c=relaxed/simple;
	bh=5BBujJnzs13bQBzd2BKpJQXOIZnHmbKqBsFueEYWZVk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RffjxKVlu/WQC/+xhUax9qz4QzpH2eqZ99fZMn2LxuuYObJ40v1nfx5hJkogPYOkBC8jjDrhH2Ms7Dui/vMwK0DT57ffYjLbCbH151M6SZLV+xQ+N8uReX2bx0XyhRa6onVA2eaJ1RQxu8o6Re554mp4aySdtCFtFWzGmmW4dWw=
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
	fw@strlen.de,
	kadlec@netfilter.org
Subject: [PATCH net-next 2/4] ipvs: speed up reads from ip_vs_conn proc file
Date: Sun, 12 Jan 2025 00:07:58 +0100
Message-Id: <20250111230800.67349-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250111230800.67349-1-pablo@netfilter.org>
References: <20250111230800.67349-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Reading is very slow because ->start() performs a linear re-scan of the
entire hash table until it finds the successor to the last dumped
element.  The current implementation uses 'pos' as the 'number of
elements to skip, then does linear iteration until it has skipped
'pos' entries.

Store the last bucket and the number of elements to skip in that
bucket instead, so we can resume from bucket b directly.

before this patch, its possible to read ~35k entries in one second, but
each read() gets slower as the number of entries to skip grows:

time timeout 60 cat /proc/net/ip_vs_conn > /tmp/all; wc -l /tmp/all
real    1m0.007s
user    0m0.003s
sys     0m59.956s
140386 /tmp/all

Only ~100k more got read in remaining the remaining 59s, and did not get
nowhere near the 1m entries that are stored at the time.

after this patch, dump completes very quickly:
time cat /proc/net/ip_vs_conn > /tmp/all; wc -l /tmp/all
real    0m2.286s
user    0m0.004s
sys     0m2.281s
1000001 /tmp/all

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_conn.c | 50 ++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 22 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index c0289f83f96d..20a1727e2457 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1046,28 +1046,35 @@ ip_vs_conn_new(const struct ip_vs_conn_param *p, int dest_af,
 #ifdef CONFIG_PROC_FS
 struct ip_vs_iter_state {
 	struct seq_net_private	p;
-	struct hlist_head	*l;
+	unsigned int		bucket;
+	unsigned int		skip_elems;
 };
 
-static void *ip_vs_conn_array(struct seq_file *seq, loff_t pos)
+static void *ip_vs_conn_array(struct ip_vs_iter_state *iter)
 {
 	int idx;
 	struct ip_vs_conn *cp;
-	struct ip_vs_iter_state *iter = seq->private;
 
-	for (idx = 0; idx < ip_vs_conn_tab_size; idx++) {
+	for (idx = iter->bucket; idx < ip_vs_conn_tab_size; idx++) {
+		unsigned int skip = 0;
+
 		hlist_for_each_entry_rcu(cp, &ip_vs_conn_tab[idx], c_list) {
 			/* __ip_vs_conn_get() is not needed by
 			 * ip_vs_conn_seq_show and ip_vs_conn_sync_seq_show
 			 */
-			if (pos-- == 0) {
-				iter->l = &ip_vs_conn_tab[idx];
+			if (skip >= iter->skip_elems) {
+				iter->bucket = idx;
 				return cp;
 			}
+
+			++skip;
 		}
+
+		iter->skip_elems = 0;
 		cond_resched_rcu();
 	}
 
+	iter->bucket = idx;
 	return NULL;
 }
 
@@ -1076,9 +1083,14 @@ static void *ip_vs_conn_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	struct ip_vs_iter_state *iter = seq->private;
 
-	iter->l = NULL;
 	rcu_read_lock();
-	return *pos ? ip_vs_conn_array(seq, *pos - 1) :SEQ_START_TOKEN;
+	if (*pos == 0) {
+		iter->skip_elems = 0;
+		iter->bucket = 0;
+		return SEQ_START_TOKEN;
+	}
+
+	return ip_vs_conn_array(iter);
 }
 
 static void *ip_vs_conn_seq_next(struct seq_file *seq, void *v, loff_t *pos)
@@ -1086,28 +1098,22 @@ static void *ip_vs_conn_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	struct ip_vs_conn *cp = v;
 	struct ip_vs_iter_state *iter = seq->private;
 	struct hlist_node *e;
-	struct hlist_head *l = iter->l;
-	int idx;
 
 	++*pos;
 	if (v == SEQ_START_TOKEN)
-		return ip_vs_conn_array(seq, 0);
+		return ip_vs_conn_array(iter);
 
 	/* more on same hash chain? */
 	e = rcu_dereference(hlist_next_rcu(&cp->c_list));
-	if (e)
+	if (e) {
+		iter->skip_elems++;
 		return hlist_entry(e, struct ip_vs_conn, c_list);
-
-	idx = l - ip_vs_conn_tab;
-	while (++idx < ip_vs_conn_tab_size) {
-		hlist_for_each_entry_rcu(cp, &ip_vs_conn_tab[idx], c_list) {
-			iter->l = &ip_vs_conn_tab[idx];
-			return cp;
-		}
-		cond_resched_rcu();
 	}
-	iter->l = NULL;
-	return NULL;
+
+	iter->skip_elems = 0;
+	iter->bucket++;
+
+	return ip_vs_conn_array(iter);
 }
 
 static void ip_vs_conn_seq_stop(struct seq_file *seq, void *v)
-- 
2.30.2

