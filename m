Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863FF312811
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Feb 2026 21:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770067603; cv=none; b=RSD+UXEuanC0eQxRpBSqcrUUM703jM1wLMvgL7FgOaDjDumNW6tGnLGyOaIxKP7CcBQ53/yTHU3pOt8z3mDzxoEjavJsm6a6LyOwOwY6oHFUdTcwYnE69IGVeqSrKXmEpC2gC4Ar31wgBixkmNrl4gbxCyimTNuW6Y0zqomJHCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770067603; c=relaxed/simple;
	bh=B/HjiZUXbX45/3VX0cHpPVVvFeswY2HXQBaNsLCwfF8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBpqsNHyN50nIzAcPpVsa+BU3uxNnh3RySwiplsrQLp8N89zB6up4snOR3usC71UvDYttz8a+puZewapUuMJD9WvCo2rmoQD5TcYW8lkhNETNIsgRKO6wqshQGmBZwc+gs0xK7pPh09DP1lIkjexnnIO9cicwFWmC1urEYnVppc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SXqMfb5O; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SXqMfb5O"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 30434605C0
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Feb 2026 22:26:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1770067594;
	bh=3mPmcNsDp0U8YyOUogdsFOkqm3vNfB5In4CX88b+cuA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=SXqMfb5OGpDaq1FQHQdbG/ERCghX0VE7ZHUCv1v/JC/R7CteLA10gwvrbzyaQ90gx
	 fC+267F9ik/zPNzov9pp6Q7iOh5PL9JcAkosjLf5OY4npGn7hCZ1knrXONR0776sb5
	 O5Jg0MYWJJ/N0d4voqLeI1ll5Kr5Vo7eUdgYSY0+RUmRa7O/YDDYzMBeI87cMpw0jN
	 IAJboqG63GBe3NWKbXf0Ye3Bc4Cm/hUdB8Wx9mBxENs8p4j4D7ib5BBJPEc1c5HGWD
	 vFtP4/FkHBLFbdsdCkk3INcos8YcjjWEE9BrLwneZq2pZIf4W5qotUCWz9M2ekiKVj
	 mTBZT1rA7bltA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 2/4] netfilter: nft_set_rbtree: check for partial overlaps in anonymous sets
Date: Mon,  2 Feb 2026 22:26:25 +0100
Message-ID: <20260202212627.946625-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202212627.946625-1-pablo@netfilter.org>
References: <20260202212627.946625-1-pablo@netfilter.org>
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
v2: no changes

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

