Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1BD30AD15
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Apr 2026 22:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776032886; cv=none; b=cRPOtmHu8XxgTGdzu79BjBF8TSIexn1CBSbPH1TiSnoaJO2y+Ot2Cu2ycJEFoEZXRgTwrd2BFVD8r+yhMZnlJdlntDZ2W3kcv+G0wM6dw64nqn7ZfARNStAY1YXgWqkZfbTSG9YaDfJPqFxwmAMcxoSOcjZsL6CxefjC4SpGM2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776032886; c=relaxed/simple;
	bh=+E7OrLjirfF3etD2wCL8LfLILmHpRwGWXcgXbwUGLjg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MyuHyz29G5AvGwjhzX3vZ77zQtpG0PZtxe+ZR9OQrYdcTFYYRZ4DC+oHyRne8q/m7EAO6s0tp9TFJHeKAsdyk1njdejBe8+812wacH9r4igqfSDaYD94WuyKRsvfAiir9+dXwSTUth1+X2ngQMabFFjRiAs4STfgXHQ6g8yBLsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=codereflect.io; spf=none smtp.mailfrom=codereflect.io; dkim=pass (2048-bit key) header.d=codereflect-io.20251104.gappssmtp.com header.i=@codereflect-io.20251104.gappssmtp.com header.b=yjgE6hUv; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=codereflect.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=codereflect.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codereflect-io.20251104.gappssmtp.com header.i=@codereflect-io.20251104.gappssmtp.com header.b="yjgE6hUv"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48374014a77so53290505e9.3
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Apr 2026 15:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codereflect-io.20251104.gappssmtp.com; s=20251104; t=1776032883; x=1776637683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JymgS9xKzYdXbFenZQ/ZXQb2L7c5DuoUb3it11um76c=;
        b=yjgE6hUvzGUsMQsQ8IXB7avoWdoTEckRAhHNDHGZaRCv+jrXdPpwjJ81i462jfzTJe
         CmaASqL00M+LcSZDFoZSeMRSQNEzXIwHpNKHpFejLQDQv2jN25bAeoja6/mjpySjS59P
         G32Re4syp5J+dK1r788aqAywYSgRdLVSY5Yyms/7QkEF/cbaRLTUbfvni835B/N1xVxo
         OlHAECF/3golbcgPBt/sDKgXJo8ILXDEAggNJL5AkY3s4hA12A5NbEelxrTLM4xzO5cq
         2fXA4w1BR41lMET6wf3H4ZAXtI9na9GGbtHR/D0PekY3C5y/A6tx5G6Ljh2m9eSuY7Ih
         GYvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776032883; x=1776637683;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JymgS9xKzYdXbFenZQ/ZXQb2L7c5DuoUb3it11um76c=;
        b=sB+zRkdOEQ2QtKV7fMGWfdZ7ddb5roe/MukCTDTwzf4KfNRizpfgAxoQJUh488biVT
         tfRYc9TQD8c2hsAqBXVvy3yqnk1kurIiyKGDkBG08fnf/XxDSwZjUJdW2+xXw0RJDoux
         msjgKwvowaU0VMEZjZzvOr3Qce9WaIpFoysv3r6Vg5LyQs5dYTjpQ5APJxdit+ZH39K4
         kEGNUpolCLZKwuEWlG4cr4+7jz79yqBFW/eVyPAMYbHrHbe+W6oMNe7L2fabQcl1xLRN
         Sq2m/qRnvrv4OxPw34qAVp/wsB1sXMnLH0GWsdkJdn/S1dazZXaw2yFE1DRckHaDGSsA
         AKHQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4Y9lzGrik66JRHHgmpn62h0DPp9rfTRk0XjSFTIcKxzcNEKrUO2FGM59yxSICXawrUYPiQ/edJbmNrcKzzOo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDel31nCsxP4kgqbQ6i85IxGalkqa0qgKVpF3Rf2Q+rlKgRZm+
	LW9wO2LbDvbXQb+Mt/t77hJK6d+AFbrFdC1aiu9I0mOZe7YlxiMB/wUWjtUM90FKe4M=
X-Gm-Gg: AeBDiet/+Tekz5le2M1iH1RZSTi6g2oLK3fIc+1QLU955c5BYmI3wZlUQIWC39NCiRD
	OhkGCtk6TqW613wl5qcvYgSN7GJJlo/+wRWC9x4Wj6bApnqzsbROCVzMCaM9tFwDDzyCCbtd0+j
	9XKA7cyHadazHwiPMyiSVuoYiqSN3vnRfRvp7g/KURyNKjMrWWsIC0EOejj/HXuoc0Qk4D0d1ql
	14+YBwXbLiv+Caui4i6E00qCsIgBhq++vI3jTASdeyYsPRWVTw/uinN0IwAPiGdtQNe4GsnVpGe
	ldoIZ0H0qfyGVcmv4fOU7Fqvg/ghB40FgSJomkIEfvw4MEY/rAkyPlvbcNUm4rMBvP8u+FLk20O
	5x6pnlfnLql3ftxhJLjysrlP0Yak23/5SWmGeiB9ZtB/5jfTEh4HYTWHpHdRcoPcd0UZp8cu9vm
	pl6wx7YT4vjlpw2DGz11mjZBp484eyVG5HTC/2WZw7C+5XO7riK68/rR6IcOIkemrB9QRJEIrfj
	/Qgof/rxChjdrsnX7te31QwDw==
X-Received: by 2002:a05:600c:a11c:b0:485:303b:c50a with SMTP id 5b1f17b1804b1-488d6804721mr111550815e9.13.1776032883203;
        Sun, 12 Apr 2026 15:28:03 -0700 (PDT)
Received: from localhost.localdomain (cable-24-135-46-158.dynamic.sbb.rs. [24.135.46.158])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d5888a97sm301980325e9.2.2026.04.12.15.28.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 12 Apr 2026 15:28:02 -0700 (PDT)
From: Marko Jevtic <marko.jevtic@codereflect.io>
To: pablo@netfilter.org,
	fw@strlen.de,
	netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	coreteam@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v3] netfilter: nft_set_rbtree: fix use count leak on transaction abort
Date: Mon, 13 Apr 2026 00:28:01 +0200
Message-ID: <20260412222801.34965-1-marko.jevtic@codereflect.io>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nft_rbtree_abort() does not handle elements moved to the expired list
by inline GC during __nft_rbtree_insert(). When inline GC encounters
expired elements during overlap detection, it calls
nft_rbtree_gc_elem_move() which deactivates element data (decrementing
chain/object use counts), removes the element from the rbtree, and
queues it for deferred freeing. On commit, these elements are freed
via nft_rbtree_gc_queue(). On abort, however, the expired list is
ignored entirely.

This leaves use counts permanently decremented after abort.

This restores transactional semantics by ensuring that inline GC side
effects are fully rolled back on abort:

- Introduce a separate tx_gc list for elements collected during insert
  (transaction-scoped), distinct from the existing expired list used
  by commit-time gc_scan (commit-scoped). This prevents abort from
  touching committed expired elements left over from a prior gc_queue
  OOM.

- On commit: splice tx_gc into expired after publishing the new binary
  search blob, then drain via gc_queue as before.

- On abort: iterate tx_gc, re-activate element data (restoring use
  counts), and re-insert into the rbtree. Elements remain expired and
  will be properly collected on the next successful commit.

- Extract nft_rbtree_node_insert() helper from __nft_rbtree_insert()
  to share the tree insertion logic with the abort restore path.

- Add WARN_ON_ONCE in commit early-return path to catch any violation
  of the invariant that tx_gc is empty when no tree changes occurred.

- Reset start_rbe_cookie on abort so insertion state from a failed
  transaction does not persist.

Fixes: f6c383b8c31a ("netfilter: nf_tables: adapt set backend to use GC transaction API")
Signed-off-by: Marko Jevtic <marko.jevtic@codereflect.io>
---
v3:
- add Fixes tag
- narrow the changelog to the abort-side use-count accounting bug

v2:
- introduce a transaction-scoped tx_gc list for insert-time GC
- restore tx_gc entries on abort and splice them to expired on commit
- export nft_setelem_data_activate() and factor out nft_rbtree_node_insert()

 include/net/netfilter/nf_tables.h |  3 +
 net/netfilter/nf_tables_api.c     |  4 +-
 net/netfilter/nft_set_rbtree.c    | 96 ++++++++++++++++++++++---------
 3 files changed, 74 insertions(+), 29 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index ec8a8ec9c..f8c912332 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1910,6 +1910,9 @@ struct nft_trans_gc *nft_trans_gc_catchall_async(struct nft_trans_gc *gc,
 						 unsigned int gc_seq);
 struct nft_trans_gc *nft_trans_gc_catchall_sync(struct nft_trans_gc *gc);
 
+void nft_setelem_data_activate(const struct net *net,
+				 const struct nft_set *set,
+				 struct nft_elem_priv *elem_priv);
 void nft_setelem_data_deactivate(const struct net *net,
 				 const struct nft_set *set,
 				 struct nft_elem_priv *elem_priv);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8c42247a1..8e783db3f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5837,7 +5837,7 @@ static void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
 	}
 }
 
-static void nft_setelem_data_activate(const struct net *net,
-				      const struct nft_set *set,
-				      struct nft_elem_priv *elem_priv);
+void nft_setelem_data_activate(const struct net *net,
+			       const struct nft_set *set,
+			       struct nft_elem_priv *elem_priv);
 
@@ -7656,7 +7656,7 @@ static int nft_setelem_active_next(const struct net *net,
 	return nft_set_elem_active(ext, genmask);
 }
 
-static void nft_setelem_data_activate(const struct net *net,
-				      const struct nft_set *set,
-				      struct nft_elem_priv *elem_priv)
+void nft_setelem_data_activate(const struct net *net,
+			       const struct nft_set *set,
+			       struct nft_elem_priv *elem_priv)
 {
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 737c339de..e1f76d6ef 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -36,6 +36,7 @@ struct nft_rbtree {
 	unsigned long		start_rbe_cookie;
 	unsigned long		last_gc;
 	struct list_head	expired;
+	struct list_head	tx_gc;
 	u64			last_tstamp;
 };
 
@@ -194,14 +195,14 @@ nft_rbtree_get(const struct net *net, const struct nft_set *set,
 
 static void nft_rbtree_gc_elem_move(struct net *net, struct nft_set *set,
 				    struct nft_rbtree *priv,
-				    struct nft_rbtree_elem *rbe)
+				    struct nft_rbtree_elem *rbe,
+				    struct list_head *target_list)
 {
 	lockdep_assert_held_write(&priv->lock);
 	nft_setelem_data_deactivate(net, set, &rbe->priv);
 	rb_erase(&rbe->node, &priv->root);
 
-	/* collected later on in commit callback */
-	list_add(&rbe->list, &priv->expired);
+	list_add(&rbe->list, target_list);
 }
 
 static const struct nft_rbtree_elem *
@@ -229,10 +230,10 @@ nft_rbtree_gc_elem(const struct nft_set *__set, struct nft_rbtree *priv,
 	rbe_prev = NULL;
 	if (prev) {
 		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
-		nft_rbtree_gc_elem_move(net, set, priv, rbe_prev);
+		nft_rbtree_gc_elem_move(net, set, priv, rbe_prev, &priv->tx_gc);
 	}
 
-	nft_rbtree_gc_elem_move(net, set, priv, rbe);
+	nft_rbtree_gc_elem_move(net, set, priv, rbe, &priv->tx_gc);
 
 	return rbe_prev;
 }
@@ -335,6 +336,35 @@ static bool nft_rbtree_insert_same_interval(const struct net *net,
 	return false;
 }
 
+static void nft_rbtree_node_insert(const struct nft_set *set,
+				   struct nft_rbtree *priv,
+				   struct nft_rbtree_elem *new)
+{
+	struct nft_rbtree_elem *rbe;
+	struct rb_node *parent, **p;
+	int d;
+
+	lockdep_assert_held_write(&priv->lock);
+
+	parent = NULL;
+	p = &priv->root.rb_node;
+	while (*p) {
+		parent = *p;
+		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
+		d = nft_rbtree_cmp(set, rbe, new);
+		if (d < 0)
+			p = &parent->rb_left;
+		else if (d > 0)
+			p = &parent->rb_right;
+		else if (nft_rbtree_interval_end(rbe))
+			p = &parent->rb_left;
+		else
+			p = &parent->rb_right;
+	}
+	rb_link_node_rcu(&new->node, parent, p);
+	rb_insert_color(&new->node, &priv->root);
+}
+
 static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			       struct nft_rbtree_elem *new,
 			       struct nft_elem_priv **elem_priv, u64 tstamp)
@@ -516,25 +546,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		return -ENOTEMPTY;
 
 	/* Accepted element: pick insertion point depending on key value */
-	parent = NULL;
-	p = &priv->root.rb_node;
-	while (*p != NULL) {
-		parent = *p;
-		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
-		d = nft_rbtree_cmp(set, rbe, new);
-
-		if (d < 0)
-			p = &parent->rb_left;
-		else if (d > 0)
-			p = &parent->rb_right;
-		else if (nft_rbtree_interval_end(rbe))
-			p = &parent->rb_left;
-		else
-			p = &parent->rb_right;
-	}
-
-	rb_link_node_rcu(&new->node, parent, p);
-	rb_insert_color(&new->node, &priv->root);
+	nft_rbtree_node_insert(set, priv, new);
 	return 0;
 }
 
@@ -920,11 +932,11 @@ static void nft_rbtree_gc_scan(struct nft_set *set)
 		 */
 		write_lock_bh(&priv->lock);
 		if (rbe_end) {
-			nft_rbtree_gc_elem_move(net, set, priv, rbe_end);
+			nft_rbtree_gc_elem_move(net, set, priv, rbe_end, &priv->expired);
 			rbe_end = NULL;
 		}
 
-		nft_rbtree_gc_elem_move(net, set, priv, rbe);
+		nft_rbtree_gc_elem_move(net, set, priv, rbe, &priv->expired);
 		write_unlock_bh(&priv->lock);
 	}
 
@@ -974,6 +986,7 @@ static int nft_rbtree_init(const struct nft_set *set,
 	rwlock_init(&priv->lock);
 	priv->root = RB_ROOT;
 	INIT_LIST_HEAD(&priv->expired);
+	INIT_LIST_HEAD(&priv->tx_gc);
 
 	priv->array = NULL;
 	priv->array_next = NULL;
@@ -1000,6 +1013,11 @@ static void nft_rbtree_destroy(const struct nft_ctx *ctx,
 		nf_tables_set_elem_destroy(ctx, set, &rbe->priv);
 	}
 
+	list_for_each_entry_safe(rbe, next, &priv->tx_gc, list) {
+		list_del(&rbe->list);
+		nf_tables_set_elem_destroy(ctx, set, &rbe->priv);
+	}
+
 	while ((node = priv->root.rb_node) != NULL) {
 		rb_erase(node, &priv->root);
 		rbe = rb_entry(node, struct nft_rbtree_elem, node);
@@ -1047,8 +1065,10 @@ static void nft_rbtree_commit(struct nft_set *set)
 	struct rb_node *node;
 
 	/* No changes, skip, eg. elements updates only. */
-	if (!priv->array_next)
+	if (!priv->array_next) {
+		WARN_ON_ONCE(!list_empty(&priv->tx_gc));
 		return;
+	}
 
 	/* GC can be performed if the binary search blob is going
 	 * to be rebuilt.  It has to be done in two phases: first
@@ -1116,13 +1136,35 @@ static void nft_rbtree_commit(struct nft_set *set)
 	/* New blob is public, queue collected entries for freeing.
 	 * call_rcu ensures elements stay around until readers are done.
 	 */
+	list_splice_tail_init(&priv->tx_gc, &priv->expired);
 	nft_rbtree_gc_queue(set);
 }
 
 static void nft_rbtree_abort(const struct nft_set *set)
 {
 	struct nft_rbtree *priv = nft_set_priv(set);
+	struct nft_rbtree_elem *rbe, *tmp;
 	struct nft_array *array_next;
+	struct net *net;
+
+	/* Restore elements that inline GC moved to the tx_gc list during
+	 * insert: their data was deactivated (use counts decremented) but
+	 * the transaction was aborted, so re-activate and re-insert to
+	 * undo GC side effects and restore transactional rollback semantics.
+	 */
+	if (!list_empty(&priv->tx_gc)) {
+		net = read_pnet(&set->net);
+
+		write_lock_bh(&priv->lock);
+		list_for_each_entry_safe(rbe, tmp, &priv->tx_gc, list) {
+			list_del_init(&rbe->list);
+			nft_setelem_data_activate(net, set, &rbe->priv);
+			nft_rbtree_node_insert(set, priv, rbe);
+		}
+		write_unlock_bh(&priv->lock);
+	}
+
+	priv->start_rbe_cookie = 0;
 
 	if (!priv->array_next)
 		return;
-- 
2.43.0
