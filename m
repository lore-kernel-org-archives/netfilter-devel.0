Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282BF3FE363
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 12:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782737918; cv=none; b=ss+XeYq7nCUkqW5aJkQl1lhoYzQUXIvqS44m66jmPiEK68PqpMHaRQHVGK+nu1lxj2cXJbOtwmQL2pSRWhaM2raLbeyYC1REZYnLQ3l/MqW+neMWq+tTLJdDN93YEiOqxDNWMIKc5asUxixInm4OOqAB/48KxH27qNPYdlwicgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782737918; c=relaxed/simple;
	bh=/0HDhDCXAwzyrkmLZYhcwEjUun84mUowbuAboleF1QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwertdtsjgXJyEZdGinbhYAwupimzGMHPypPIDf6tBTlWe/Tnh2bg4rudXiYWs3julv091P0aj2/AAZWz4X1WyvJRqSRBFZxsIZjgD1d4li631mJuojwJN3XRgTSw357fkTAQZtQqr6sgrmmi9iFsm1iZv/U7/xaUFrjFfEQemQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 85B7F6032C; Mon, 29 Jun 2026 14:58:35 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 1/3] netfilter: nf_conntrack_helper: do not hash by tuple
Date: Mon, 29 Jun 2026 14:58:21 +0200
Message-ID: <20260629125823.1749-2-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260629125823.1749-1-fw@strlen.de>
References: <20260629125823.1749-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Long time ago helpers were auto-assigned to connections based on
port/protocol match. For this reason, nf_conntrack_helper still contains
a full tuple.

Nowadays the only relevant entries in the tuple are the l3 and l4 protocol
numbers.

Prepare for tuple removal and switch to hashing name and l4 protocol.
l3num cannot be used because helpers can also register for "unspec"
protocol.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: no changes.
 net/netfilter/nf_conntrack_helper.c | 67 +++++++++++++----------------
 1 file changed, 31 insertions(+), 36 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 500509b17663..5ad5429352a7 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -40,12 +40,16 @@ static unsigned int nf_ct_helper_count __read_mostly;
 static DEFINE_MUTEX(nf_ct_nat_helpers_mutex);
 static struct list_head nf_ct_nat_helpers __read_mostly;
 
-/* Stupid hash, but collision free for the default registrations of the
- * helpers currently in the kernel. */
-static unsigned int helper_hash(const struct nf_conntrack_tuple *tuple)
+static unsigned int helper_hash(const char *name, u8 protonum)
 {
-	return (((tuple->src.l3num << 8) | tuple->dst.protonum) ^
-		(__force __u16)tuple->src.u.all) % nf_ct_helper_hsize;
+	static u32 seed;
+	u32 initval;
+
+	get_random_once(&seed, sizeof(seed));
+
+	initval = seed ^ protonum;
+
+	return jhash(name, strlen(name), initval) % nf_ct_helper_hsize;
 }
 
 struct nf_conntrack_helper *
@@ -54,18 +58,21 @@ __nf_conntrack_helper_find(const char *name, u16 l3num, u8 protonum)
 	struct nf_conntrack_helper *h;
 	unsigned int i;
 
-	for (i = 0; i < nf_ct_helper_hsize; i++) {
-		hlist_for_each_entry_rcu(h, &nf_ct_helper_hash[i], hnode) {
-			if (strcmp(h->name, name))
-				continue;
+	if (!nf_ct_helper_hash)
+		return NULL;
 
-			if (h->tuple.src.l3num != NFPROTO_UNSPEC &&
-			    h->tuple.src.l3num != l3num)
-				continue;
+	i = helper_hash(name, protonum);
 
-			if (h->tuple.dst.protonum == protonum)
-				return h;
-		}
+	hlist_for_each_entry_rcu(h, &nf_ct_helper_hash[i], hnode) {
+		if (strcmp(h->name, name))
+			continue;
+
+		if (h->tuple.src.l3num != NFPROTO_UNSPEC &&
+		    h->tuple.src.l3num != l3num)
+			continue;
+
+		if (h->tuple.dst.protonum == protonum)
+			return h;
 	}
 	return NULL;
 }
@@ -363,9 +370,8 @@ EXPORT_SYMBOL_GPL(nf_ct_helper_log);
 
 int __nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 {
-	struct nf_conntrack_tuple_mask mask = { .src.u.all = htons(0xFFFF) };
-	unsigned int h = helper_hash(&me->tuple);
 	struct nf_conntrack_helper *cur;
+	unsigned int h;
 	int ret = 0, i;
 
 	BUG_ON(me->expect_class_max >= NF_CT_MAX_EXPECT_CLASSES);
@@ -382,29 +388,18 @@ int __nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 			return -EINVAL;
 	}
 
+	h = helper_hash(me->name, me->tuple.dst.protonum);
 	mutex_lock(&nf_ct_helper_mutex);
-	for (i = 0; i < nf_ct_helper_hsize; i++) {
-		hlist_for_each_entry(cur, &nf_ct_helper_hash[i], hnode) {
-			if (!strcmp(cur->name, me->name) &&
-			    (cur->tuple.src.l3num == NFPROTO_UNSPEC ||
-			     cur->tuple.src.l3num == me->tuple.src.l3num) &&
-			    cur->tuple.dst.protonum == me->tuple.dst.protonum) {
-				ret = -EBUSY;
-				goto out;
-			}
+	hlist_for_each_entry(cur, &nf_ct_helper_hash[h], hnode) {
+		if (!strcmp(cur->name, me->name) &&
+		    (cur->tuple.src.l3num == NFPROTO_UNSPEC ||
+		     cur->tuple.src.l3num == me->tuple.src.l3num) &&
+		    cur->tuple.dst.protonum == me->tuple.dst.protonum) {
+			ret = -EBUSY;
+			goto out;
 		}
 	}
 
-	/* avoid unpredictable behaviour for auto_assign_helper */
-	if (!(me->flags & NF_CT_HELPER_F_USERSPACE)) {
-		hlist_for_each_entry(cur, &nf_ct_helper_hash[h], hnode) {
-			if (nf_ct_tuple_src_mask_cmp(&cur->tuple, &me->tuple,
-						     &mask)) {
-				ret = -EBUSY;
-				goto out;
-			}
-		}
-	}
 	refcount_set(&me->ct_refcnt, 1);
 	hlist_add_head_rcu(&me->hnode, &nf_ct_helper_hash[h]);
 	nf_ct_helper_count++;
-- 
2.53.0

