Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2436A26B77D;
	Fri,  6 Feb 2026 15:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770391898; cv=none; b=FwyQvA7uv6bCQHJU/wPiHYSJKGtgrD+ELY2I2gFdSyRXfiwsGIERAFvWYU2bvM6M1geCSSuXYOYUQlfwa/AN8E/NOSIDFkQs6OkX9Tuz/hkicAFAZTqMYl9tvCJWXwdlUtcdJiAyRkIEGodL45wRBQeVfeCZMm+l/wUjTAl/HPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770391898; c=relaxed/simple;
	bh=C3AtBBqNVM8oeAZ9mhwSqGstU44NHanGJUNdImiI82o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qcHZDSlDjXaWiMnfQgO8C72/ZoHCOme4Z+abGbp+4V8QGkyR/U1m8iOVNwPf9D3ZpJQg7yh8YjIsZx5cTuL4RzmyIByOhFys2ucY4XwnqbyaI3GFfTw3w3WCBojZRNttlf4tHxIaBuyjyqQona9t+6w+2BQhWCyJkdxK4uQGick=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B9EAA6090B; Fri, 06 Feb 2026 16:31:36 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH v2 net-next 09/11] netfilter: nft_set_rbtree: check for partial overlaps in anonymous sets
Date: Fri,  6 Feb 2026 16:30:46 +0100
Message-ID: <20260206153048.17570-10-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260206153048.17570-1-fw@strlen.de>
References: <20260206153048.17570-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

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
Signed-off-by: Florian Westphal <fw@strlen.de>
---
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
2.52.0

