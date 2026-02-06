Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1827F3A7F46
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Feb 2026 12:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770381240; cv=none; b=dv/XHM6Qac+XqyfrWC2w16PkdtzXY1pPC7AmwXvx+kjcyYsJmneSGW4kyrexx+dsC9sQZRO7IPAP84WSE8MK4+u/oVflmRCFdFANng7mlWlOu6EAv8XeTuCv1cTJ0xrR+Ov/kdrUZFdRea+Ot/zrg4VlRm0UgrZRMCNp3rVZKv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770381240; c=relaxed/simple;
	bh=bdTYJvzuYA6UDyf4olvBOpooH8WWnt8nDwzxzdCkXNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjbcCuajbefGgnDdr0CRPCQa30MAenvmOSQWVXm9aJZKtIMSrDr7ntgIJhfSKCaNeohNhGVPjGMPr7W77IZOUPEvX0ZAB2trz9JzGVu8lv3ujlorwLoA0neg3n8/JZFcxnV3iBqYhNf4Qg0BijwARrVQ/fqWi444B43ViqUq2qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jrf7U83h; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jrf7U83h"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7B19760890;
	Fri,  6 Feb 2026 13:33:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1770381232;
	bh=uek+lLMBaPsFUJvvJCLsJVj2p8X6d4a1ZbYhyqY3iAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrf7U83h2wZlmZ+YrtYLhQ4MZ1b0/opxkFl7JYgXVA+2hnzQZveOim5dpa0GxcW7q
	 Vi89xVfFkHTMbLNZ4iJg9DkoqSGmKKbTHta4JZPkDrXEznUDDJpH2tXqTmQQ6H0Ml7
	 BbqJN4sqCiNi0Kl2XD6FFi241SR93bI0smreyu+ANnOckH3wZlEBI3Boqfo5KOGyK3
	 U7APwaTuPMAG2fp0M1d1oSHBV/fxyKzpRz/hrF/XrOUJZf5hnECn7Ndb0bLL//Yrsb
	 w2BKI7DkGzJJXuC6DNlpdYI+s/RyYJ5YzZbslyMFOUydk9P3bvntLHmoa31ppVmuv4
	 +dUg+YhiTUqxQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next,v3 2/4] netfilter: nft_set_rbtree: check for partial overlaps in anonymous sets
Date: Fri,  6 Feb 2026 13:33:44 +0100
Message-ID: <20260206123346.1529474-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260206123346.1529474-1-pablo@netfilter.org>
References: <20260206123346.1529474-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Userspace provides an optimized representation in case intervals are
adjacent, where the end element is omitted.

The existing partial overlap detection logic skips anonymous set checks
on start elements for this reason.

However, it is possible to add intervals that overlap to this anonymous
where two start elements with the same, eg. A-B, A-C where C < B.

      start     end
	A        B
      start  end
        A     C

Restore the check on overlapping start elements to report an overlap.

Fixes: c9e6978e2725 ("netfilter: nft_set_rbtree: Switch to node list walk for overlap detection")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: - add comment to nft_rbtree_prev_active() to make AI happy.
    - use Fixes: tag preferred by AI.
    - update another comment in the code following suggestion of AI to make it less ambiguous

 net/netfilter/nft_set_rbtree.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 2c240b0ade87..14b4256bb00d 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -251,11 +251,23 @@ static bool nft_rbtree_update_first(const struct nft_set *set,
 	return false;
 }
 
+/* Only for anonymous sets which do not allow updates, all element are active. */
+static struct nft_rbtree_elem *nft_rbtree_prev_active(struct nft_rbtree_elem *rbe)
+{
+	struct rb_node *node;
+
+	node = rb_prev(&rbe->node);
+	if (!node)
+		return NULL;
+
+	return rb_entry(node, struct nft_rbtree_elem, node);
+}
+
 static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			       struct nft_rbtree_elem *new,
 			       struct nft_elem_priv **elem_priv)
 {
-	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL;
+	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL, *rbe_prev;
 	struct rb_node *node, *next, *parent, **p, *first = NULL;
 	struct nft_rbtree *priv = nft_set_priv(set);
 	u8 cur_genmask = nft_genmask_cur(net);
@@ -393,11 +405,19 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	/* - new start element with existing closest, less or equal key value
 	 *   being a start element: partial overlap, reported as -ENOTEMPTY.
 	 *   Anonymous sets allow for two consecutive start element since they
-	 *   are constant, skip them to avoid bogus overlap reports.
+	 *   are constant, but validate that this new start element does not
+	 *   sit in between an existing start and end elements: partial overlap,
+	 *   reported as -ENOTEMPTY.
 	 */
-	if (!nft_set_is_anonymous(set) && rbe_le &&
-	    nft_rbtree_interval_start(rbe_le) && nft_rbtree_interval_start(new))
-		return -ENOTEMPTY;
+	if (rbe_le &&
+	    nft_rbtree_interval_start(rbe_le) && nft_rbtree_interval_start(new)) {
+		if (!nft_set_is_anonymous(set))
+			return -ENOTEMPTY;
+
+		rbe_prev = nft_rbtree_prev_active(rbe_le);
+		if (rbe_prev && nft_rbtree_interval_end(rbe_prev))
+			return -ENOTEMPTY;
+	}
 
 	/* - new end element with existing closest, less or equal key value
 	 *   being a end element: partial overlap, reported as -ENOTEMPTY.
-- 
2.47.3

