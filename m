Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783A324DCE2
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 01:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769564584; cv=none; b=exq6KyCGb5tgckXbgMKgeLQ30ESY8KefnvlZJFuNDYo1jBFcCI/c3PMBeZ2qurjQIriYBrRpVmzAy8367KrLCPfxm9OwWFOe1BeG5GOpZvveiC2uj8AEVBXa5OpRSU4pAFXarzEtybdEU+nu0uqysyCxfVn7Y2cSEOG/6hj336A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769564584; c=relaxed/simple;
	bh=5FXpzNW9v0pqhNJTjFyt2GqtYdA+56IpafhXzzPdNTs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWt/+Y71wtyd5BhDKnkbs0b2NRf9hUw69CmYN0isXUB/tV5XDc2J0kGf3AlWoajvNFrR9Iv/xjOp9a+QPKqp79y2jTePttmR9XtOocnrp6fLgJsjzxCVVoA+FH6iJSFou4tm2G7Po8ue07LhP8giWL2VDOVOU9YSrHFH6DqeS34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=g0ZVFv21; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="g0ZVFv21"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D0FC16024E
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 02:43:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1769564580;
	bh=S2PeTQHmfd4KeaNCcmvQ/8b5Ehh2xZj+96DqgOCN+/c=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=g0ZVFv21vfB9oHbUAcDDLeYQhk19NcRdHyrYsC6OZn6XxuzE1OmSJO/BdV/Ridq6r
	 2ANaVO3n4tcOdHxuwQI8YJdl/uArdVEFAEbjIZZnbdz6f3TBUdcAAgUvdvcy59za4d
	 6HJq8G0Ng3StVgqWW45buqC0WUQMDEYyQrtud/hwbcIk4/L9ieZ+gQuNOiavZKrgvH
	 mPFWMGRmorZtc2oywwjYPYjeV755QwwcLTNwDkzU+WevToNqnImFbiV+dgXBup9yVY
	 jJQ6YcQvyOEyp7tKWWFxbhbSIVXTKfjmipfrkaSPKe8OHhsY1rW2AGC8yoOhRJDjhC
	 2ls5+Z5P062aA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 2/4] netfilter: nft_set_rbtree: check for partial overlaps in anonymous sets
Date: Wed, 28 Jan 2026 02:42:49 +0100
Message-ID: <20260128014251.754512-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260128014251.754512-1-pablo@netfilter.org>
References: <20260128014251.754512-1-pablo@netfilter.org>
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

Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 345d51dc4a89..0581184cacf9 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -267,11 +267,22 @@ static bool nft_rbtree_update_first(const struct nft_set *set,
 	return false;
 }
 
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
@@ -409,11 +420,19 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	/* - new start element with existing closest, less or equal key value
 	 *   being a start element: partial overlap, reported as -ENOTEMPTY.
 	 *   Anonymous sets allow for two consecutive start element since they
-	 *   are constant, skip them to avoid bogus overlap reports.
+	 *   are constant, but validate that this new start element does not
+	 *   sit in between an existing new and end elements: partial overlap,
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

