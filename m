Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA1525B093
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jul 2026 13:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784035145; cv=none; b=qcZvGjiWTzqBw+4fS35LVIPoL6iLqTAiO1p0K+KXRgU8xndmbDSzyMHjlu4Biz1Ypelh5ArD4nLLHaVDydElhUPa+hsdQNqdx+a7eAJJ6qJxhJStBJtfyVLvztdzjC0HZsPG+H7E5iPLr0sKaNBgAfz7O2n/pOn0JBB/rsBXyb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784035145; c=relaxed/simple;
	bh=M/INesFz/63o0bCaeq0ZAYIIK6gAg2cbRb6tMuSZQCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqeFAnhABjWcwa/tS8ytpqlwWMPhYwScO9MOFIiAm/26pFyVgG4lz3IarXALPJnlso1WBR2uowDVUqQnyHPJOfGkKuGogAzYrLoDIemVZpplYpPwbII/OpjNZBRBKadLhxAkjfYsFWRjhqTcu8TR9ejfbt/2/6Eq2oMy/kj6Slw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2E10360503; Tue, 14 Jul 2026 15:19:02 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: kadlec@netfilter.org,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH RFC nf-next 05/12] netfilter: ipset: add and use ip_set_init_comment_slow
Date: Tue, 14 Jul 2026 15:18:21 +0200
Message-ID: <20260714131828.10685-6-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260714131828.10685-1-fw@strlen.de>
References: <20260714131828.10685-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ip_set_init_comment alters set->ext_size, this is racy.
bitmap and list set types serialize on set->lock, but the hash versions
don't do that.

Switch hash to new ip_set_init_comment_slow.
Alternatives would be to avoid set->ext_size altogether or use
atomic_add/sub for this.

Prefer simpler version.  Also add lockdep annotations to document
this.

ip_set_ext_destroy() has the same issue, but this is harder to fix
because there is at least one case where this gets called without
lock where its safe to do so: set is destroyed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/ipset/ip_set.h  | 9 +++++++++
 net/netfilter/ipset/ip_set_bitmap_gen.h | 2 ++
 net/netfilter/ipset/ip_set_core.c       | 3 ++-
 net/netfilter/ipset/ip_set_hash_gen.h   | 2 +-
 net/netfilter/ipset/ip_set_list_set.c   | 4 ++++
 5 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index b98331572ad2..50cd719bc270 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -502,6 +502,15 @@ ip_set_timeout_set(unsigned long *timeout, u32 value)
 void ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
 			 const struct ip_set_ext *ext);
 
+static inline void
+ip_set_init_comment_slow(struct ip_set *set, struct ip_set_comment *comment,
+			 const struct ip_set_ext *ext)
+{
+	spin_lock_bh(&set->lock);
+	ip_set_init_comment(set, comment, ext);
+	spin_unlock_bh(&set->lock);
+}
+
 static inline void
 ip_set_init_counter(struct ip_set_counter *counter,
 		    const struct ip_set_ext *ext)
diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index bb9b5bed10e1..b13cde902c17 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -135,6 +135,8 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	void *x = get_ext(set, map, e->id);
 	int ret = mtype_do_add(e, map, flags, set->dsize);
 
+	lockdep_assert_held(&set->lock);
+
 	if (ret == IPSET_ADD_FAILED) {
 		if (SET_WITH_TIMEOUT(set) &&
 		    ip_set_timeout_expired(ext_timeout(x, set))) {
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 6cfad152d7d1..3d6a78ad93f5 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -346,7 +346,8 @@ void
 ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
 		    const struct ip_set_ext *ext)
 {
-	struct ip_set_comment_rcu *c = rcu_dereference_protected(comment->c, 1);
+	struct ip_set_comment_rcu *c = rcu_dereference_protected(comment->c,
+								 lockdep_is_held(&set->lock));
 	size_t len = ext->comment ? strlen(ext->comment) : 0;
 
 	if (unlikely(c)) {
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 129f06ed85f8..c3dda56d786c 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1065,7 +1065,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	if (SET_WITH_COUNTER(set))
 		ip_set_init_counter(ext_counter(data, set), ext);
 	if (SET_WITH_COMMENT(set))
-		ip_set_init_comment(set, ext_comment(data, set), ext);
+		ip_set_init_comment_slow(set, ext_comment(data, set), ext);
 	if (SET_WITH_SKBINFO(set))
 		ip_set_init_skbinfo(ext_skbinfo(data, set), ext);
 	/* Must come last for the case when timed out entry is reused */
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 1cef84f15e8c..d7ddc57a4eca 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -221,6 +221,8 @@ static void
 list_set_init_extensions(struct ip_set *set, const struct ip_set_ext *ext,
 			 struct set_elem *e)
 {
+	lockdep_assert_held(&set->lock);
+
 	if (SET_WITH_COUNTER(set))
 		ip_set_init_counter(ext_counter(e, set), ext);
 	if (SET_WITH_COMMENT(set))
@@ -241,6 +243,8 @@ list_set_uadd(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	struct set_elem *e, *n, *prev, *next;
 	bool flag_exist = flags & IPSET_FLAG_EXIST;
 
+	lockdep_assert_held(&set->lock);
+
 	/* Find where to add the new entry */
 	n = prev = next = NULL;
 	list_for_each_entry_rcu(e, &map->members, list) {
-- 
2.54.0

