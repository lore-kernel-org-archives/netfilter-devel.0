Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FB3143C63;
	Thu, 13 Jun 2024 11:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279073; cv=none; b=dRsXzUsdyZuZNbftMVfiJn+8ubAvzLz6618e6S5Y24HLwuFfpfNMaTafGzWfEPIeFSVJUVxPKOvfibVbcdmJPZhABtexEzYvVXncB0yOTGN819PKNEeci6ZAhhOqB17BmqiiCjHGT/IeaUGMNiz2nHunQtQbKk4ur6dkxRTQjRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279073; c=relaxed/simple;
	bh=2/XjpUpoLSVWfe0SOvRSXQyGAFBJJiNFDRFcPoKNWgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTTtuzlXANXZi5GcR79TlbT9j0fwddLDWWKUBwuEdZtIGAvlqpttt8dWQkLs/f9OZN3rU7aNNJOUX27Xc+YNUEnfSOP8NGb5vdQ/Gd7mmyv/AIL/7gHzrB6L7ypGWQRjgTgqWJ0TwVyPgxK1pv4i5DYLPrCljL79lSvSiATlSEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lPzEzpOQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lPzEzpOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D772C2BBFC;
	Thu, 13 Jun 2024 11:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279073;
	bh=2/XjpUpoLSVWfe0SOvRSXQyGAFBJJiNFDRFcPoKNWgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPzEzpOQ6wRXvZCzr7T7fzu2AMU7tqI0WOSRWKylwQS7miy/w9dFPbYyevAkzAsl3
	 1vIq3C5yQ4SBxijC53hSXMVEKjWIAnZfLO+27XlkNKT/s+IdTeAjycdBQYvi37HA15
	 lji3VVSWZRjjeJa368zEo3bKUHhLleW+FT6eGJYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 166/213] netfilter: nft_set_rbtree: fix overlap expiration walk
Date: Thu, 13 Jun 2024 13:33:34 +0200
Message-ID: <20240613113234.387916572@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit f718863aca469a109895cb855e6b81fff4827d71 upstream.

The lazy gc on insert that should remove timed-out entries fails to release
the other half of the interval, if any.

Can be reproduced with tests/shell/testcases/sets/0044interval_overlap_0
in nftables.git and kmemleak enabled kernel.

Second bug is the use of rbe_prev vs. prev pointer.
If rbe_prev() returns NULL after at least one iteration, rbe_prev points
to element that is not an end interval, hence it should not be removed.

Lastly, check the genmask of the end interval if this is active in the
current generation.

Fixes: c9e6978e2725 ("netfilter: nft_set_rbtree: Switch to node list walk for overlap detection")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_rbtree.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -219,29 +219,37 @@ static void *nft_rbtree_get(const struct
 
 static int nft_rbtree_gc_elem(const struct nft_set *__set,
 			      struct nft_rbtree *priv,
-			      struct nft_rbtree_elem *rbe)
+			      struct nft_rbtree_elem *rbe,
+			      u8 genmask)
 {
 	struct nft_set *set = (struct nft_set *)__set;
 	struct rb_node *prev = rb_prev(&rbe->node);
-	struct nft_rbtree_elem *rbe_prev = NULL;
+	struct nft_rbtree_elem *rbe_prev;
 	struct nft_set_gc_batch *gcb;
 
 	gcb = nft_set_gc_batch_check(set, NULL, GFP_ATOMIC);
 	if (!gcb)
 		return -ENOMEM;
 
-	/* search for expired end interval coming before this element. */
+	/* search for end interval coming before this element.
+	 * end intervals don't carry a timeout extension, they
+	 * are coupled with the interval start element.
+	 */
 	while (prev) {
 		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
-		if (nft_rbtree_interval_end(rbe_prev))
+		if (nft_rbtree_interval_end(rbe_prev) &&
+		    nft_set_elem_active(&rbe_prev->ext, genmask))
 			break;
 
 		prev = rb_prev(prev);
 	}
 
-	if (rbe_prev) {
+	if (prev) {
+		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
+
 		rb_erase(&rbe_prev->node, &priv->root);
 		atomic_dec(&set->nelems);
+		nft_set_gc_batch_add(gcb, rbe_prev);
 	}
 
 	rb_erase(&rbe->node, &priv->root);
@@ -323,7 +331,7 @@ static int __nft_rbtree_insert(const str
 
 		/* perform garbage collection to avoid bogus overlap reports. */
 		if (nft_set_elem_expired(&rbe->ext)) {
-			err = nft_rbtree_gc_elem(set, priv, rbe);
+			err = nft_rbtree_gc_elem(set, priv, rbe, genmask);
 			if (err < 0)
 				return err;
 


