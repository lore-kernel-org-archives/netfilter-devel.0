Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4393130EF80
	for <netfilter-devel@vger.kernel.org>; Fri, 22 May 2026 05:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779426114; cv=none; b=a0/ckBqBLGFr0BwadQZ2H3jOAx7A/y2FMgNloaeyoxsqTEzGfwpvsXVDDShTnmrqSpTtAYDDjhlYC+cgA0SXDQEXObuOUY2g6XAahUqYD0FTyHNpABzPJlNkgBmeGPTIp0xryYUaI/O33twkhG/0E7RQ6s9bDI9zSw0yDOTDUSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779426114; c=relaxed/simple;
	bh=GBvHQ1+ek3P7mXQ8OwtYObU+7ptAdBArTT8FNUoF4rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1dRvuR58lW0xIEe47zJuJ+HHNZlJ0Mgpc4gXWgwvD0zdt5LUBAp5P9yhHuURPnWx69ZcrM2p3kvVZQ/eo+4cgjdoM/Tk2egxjlEl6ZiDnQ1xt8/2jU7eytO93PBsbtLYB/0nIM1CyKml9nFFJFXJJYBkSaeLGyYeJTAGyrWPdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7ECD8605BD; Fri, 22 May 2026 07:01:51 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/5] netfilter: nf_conntrack_helper: do not hash by tuple
Date: Fri, 22 May 2026 07:01:30 +0200
Message-ID: <20260522050140.4838-2-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260522050140.4838-1-fw@strlen.de>
References: <20260522050140.4838-1-fw@strlen.de>
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
 net/netfilter/nf_conntrack_helper.c | 65 ++++++++++++-----------------
 1 file changed, 27 insertions(+), 38 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index b594cd244fe1..32f64f600417 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -40,32 +40,34 @@ static unsigned int nf_ct_helper_count __read_mostly;
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
 __nf_conntrack_helper_find(const char *name, u16 l3num, u8 protonum)
 {
+	unsigned int i = helper_hash(name, protonum);
 	struct nf_conntrack_helper *h;
-	unsigned int i;
 
-	for (i = 0; i < nf_ct_helper_hsize; i++) {
-		hlist_for_each_entry_rcu(h, &nf_ct_helper_hash[i], hnode) {
-			if (strcmp(h->name, name))
-				continue;
+	hlist_for_each_entry_rcu(h, &nf_ct_helper_hash[i], hnode) {
+		if (strcmp(h->name, name))
+			continue;
 
-			if (h->tuple.src.l3num != NFPROTO_UNSPEC &&
-			    h->tuple.src.l3num != l3num)
-				continue;
+		if (h->tuple.src.l3num != NFPROTO_UNSPEC &&
+		    h->tuple.src.l3num != l3num)
+			continue;
 
-			if (h->tuple.dst.protonum == protonum)
-				return h;
-		}
+		if (h->tuple.dst.protonum == protonum)
+			return h;
 	}
 	return NULL;
 }
@@ -346,10 +348,9 @@ EXPORT_SYMBOL_GPL(nf_ct_helper_log);
 
 int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 {
-	struct nf_conntrack_tuple_mask mask = { .src.u.all = htons(0xFFFF) };
-	unsigned int h = helper_hash(&me->tuple);
+	unsigned int h = helper_hash(me->name, me->tuple.dst.protonum);
 	struct nf_conntrack_helper *cur;
-	int ret = 0, i;
+	int ret = 0;
 
 	BUG_ON(me->expect_policy == NULL);
 	BUG_ON(me->expect_class_max >= NF_CT_MAX_EXPECT_CLASSES);
@@ -362,28 +363,16 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 		return -EINVAL;
 
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
 	refcount_set(&me->refcnt, 1);
 	hlist_add_head_rcu(&me->hnode, &nf_ct_helper_hash[h]);
 	nf_ct_helper_count++;
-- 
2.53.0

