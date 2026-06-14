Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5C6387364;
	Sun, 14 Jun 2026 11:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781437579; cv=none; b=lC8AqdCPs2iZUVtKQ91/bD8/F+yfO/sEKHazBXzQAGHcbeC6qRvowWvRHVOmKlLzGRr1WBf8zPeb58rz3dtMUjKTO88eM6yne8fR3gtK8fIUAKdHqtMGux7X92Jct3+NIsXGX8YuepHZpm+G9wfUqBwlwStFDejX1tgF/4S9aRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781437579; c=relaxed/simple;
	bh=p6HId6urWrXrcA9joyCHn9uqSHh1dpL/6eydXxpxgoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dV4SnMuQXXDAJmvUYwvz0IqDv9+4GCkVcSeftsLuRPeTrNlV2uOEW550OmycnOmoCnPEUL6TYIoCY53Lp2J8BP9kRa+jmZdJWMxjo+FoRreLDyI5EVYLqf0Ma5Ta7SvclWQgfwzb3f6TEZS7Bhaw1aPvCCb9kjY7bOqKLt8rux0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=d0F/gi9L; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="d0F/gi9L"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DBBE06019E;
	Sun, 14 Jun 2026 13:46:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781437576;
	bh=dm5HkFKkbioRPWXHd+iTvx+JucqXAoUAdMJTJ2DU/og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0F/gi9LZxBNrS/mzD9ly3SUEY1sFpWe8HeVYtbMpXjiGT39fd4GeCDaybUQPpjQJ
	 mbtfOksqhEkyz5a1HrHqEKLzL2EiVIAFOSQQz/WhIUqfHTKJeEDw232XuRTbCZc5i5
	 zvltTFFByzW1F4y4qr9hyP9LU8ZsmQHIht5DbiINT6AeOhSGHpWnDPGeVdETKMSU4C
	 qDG11DZORq3+Xa3FO1nUZPZxv0JVhiQUVCvmeKu9yl8Z795DFA2A3lwM71DoyW3mP+
	 SyHGiS3Uz5ww+yK4lAWSq6RbCVeVmaIIJVEvMzvFflqCCvi6U38MM+aFinXdcctfQf
	 mzmm1WxCx6yQw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 05/11] netfilter: nf_conncount: split count_tree_node rbtree walk into helper
Date: Sun, 14 Jun 2026 13:45:59 +0200
Message-ID: <20260614114605.474783-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260614114605.474783-1-pablo@netfilter.org>
References: <20260614114605.474783-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Add find_tree_node() helper that fetches a matching rbtree node.

This is used by followup patch to optionally search the tree again while
preventing concurrent updates via tree lock.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conncount.c | 102 +++++++++++++++++++++--------------
 1 file changed, 62 insertions(+), 40 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index faecc05d34d4..56ac64ecfb75 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -488,6 +488,34 @@ insert_tree(struct net *net,
 	return count;
 }
 
+static struct nf_conncount_rb *
+find_tree_node(struct nf_conncount_root *root, struct nf_conncount_data *data,
+	       const u32 *key)
+{
+	struct rb_node *parent;
+
+	parent = rcu_dereference_check(root->root.rb_node,
+				       lockdep_is_held(&root->lock));
+	while (parent) {
+		struct nf_conncount_rb *rbconn;
+		int diff;
+
+		rbconn = rb_entry(parent, struct nf_conncount_rb, node);
+
+		diff = key_diff(key, rbconn->key, data->keylen);
+		if (diff < 0)
+			parent = rcu_dereference_check(parent->rb_left,
+						       lockdep_is_held(&root->lock));
+		else if (diff > 0)
+			parent = rcu_dereference_check(parent->rb_right,
+						       lockdep_is_held(&root->lock));
+		else
+			return rbconn;
+	}
+
+	return ERR_PTR(-ENOENT);
+}
+
 static unsigned int
 count_tree(struct net *net,
 	   const struct sk_buff *skb,
@@ -496,59 +524,53 @@ count_tree(struct net *net,
 	   const u32 *key)
 {
 	struct nf_conncount_root *root;
-	struct rb_node *parent;
 	struct nf_conncount_rb *rbconn;
 	unsigned int hash;
+	int ret;
 
 	hash = jhash2(key, data->keylen, data->initval) % CONNCOUNT_SLOTS;
 	root = &data->root[hash];
 
-	parent = rcu_dereference(root->root.rb_node);
-	while (parent) {
-		int diff;
-
-		rbconn = rb_entry(parent, struct nf_conncount_rb, node);
+	rbconn = find_tree_node(root, data, key);
+	if (IS_ERR(rbconn)) {
+		if (PTR_ERR(rbconn) == -ENOENT) {
+			if (!skb)
+				return 0;
 
-		diff = key_diff(key, rbconn->key, data->keylen);
-		if (diff < 0) {
-			parent = rcu_dereference(parent->rb_left);
-		} else if (diff > 0) {
-			parent = rcu_dereference(parent->rb_right);
-		} else {
-			int ret;
+			return insert_tree(net, skb, l3num, data, hash, key);
+		}
+		DEBUG_NET_WARN_ON_ONCE(IS_ERR(rbconn));
+	}
 
-			if (!skb) {
-				nf_conncount_gc_list(net, &rbconn->list);
-				return rbconn->list.count;
-			}
+	DEBUG_NET_WARN_ON_ONCE(IS_ERR_OR_NULL(rbconn));
+	if (IS_ERR_OR_NULL(rbconn))
+		return 0;
 
-			spin_lock_bh(&rbconn->list.list_lock);
-			/* Node might be about to be free'd.
-			 * We need to defer to insert_tree() in this case.
-			 */
-			if (rbconn->list.count == 0) {
-				spin_unlock_bh(&rbconn->list.list_lock);
-				break;
-			}
+	if (!skb) {
+		nf_conncount_gc_list(net, &rbconn->list);
+		return rbconn->list.count;
+	}
 
-			/* same source network -> be counted! */
-			ret = __nf_conncount_add(net, skb, l3num, &rbconn->list);
-			spin_unlock_bh(&rbconn->list.list_lock);
-			if (ret && ret != -EEXIST) {
-				return 0; /* hotdrop */
-			} else {
-				/* -EEXIST means add was skipped, update the list */
-				if (ret == -EEXIST)
-					nf_conncount_gc_list(net, &rbconn->list);
-				return rbconn->list.count;
-			}
-		}
+	spin_lock_bh(&rbconn->list.list_lock);
+	/* Node might be about to be free'd.
+	 * We need to defer to insert_tree() in this case.
+	 */
+	if (rbconn->list.count == 0) {
+		spin_unlock_bh(&rbconn->list.list_lock);
+		return insert_tree(net, skb, l3num, data, hash, key);
 	}
 
-	if (!skb)
-		return 0;
+	/* same source network -> be counted! */
+	ret = __nf_conncount_add(net, skb, l3num, &rbconn->list);
+	spin_unlock_bh(&rbconn->list.list_lock);
+
+	if (ret && ret != -EEXIST)
+		return 0; /* hotdrop */
+	/* -EEXIST means add was skipped, update the list */
+	if (ret == -EEXIST)
+		nf_conncount_gc_list(net, &rbconn->list);
 
-	return insert_tree(net, skb, l3num, data, hash, key);
+	return rbconn->list.count;
 }
 
 static void tree_gc_worker(struct work_struct *work)
-- 
2.47.3

