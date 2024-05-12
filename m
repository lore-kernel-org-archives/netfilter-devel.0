Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAAAC4CB2E;
	Sun, 12 May 2024 16:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715530493; cv=none; b=CMIta9XKDtHbtv7lVxJwyqxcGMzmDv8KuQy5FkIKkyAG1KNK+/z67/p/fnmyj0cAudh4rAJ0ymr2CXcl3xjvvi9ZYKwBre0JQDZKb71exslJXQ85slYEEsMhFUhV5xSqg9lisvPco7wW9Fv1HP7VynDnRAOaTAA906JSwUhM7Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715530493; c=relaxed/simple;
	bh=VPcBv78REJ4fCKTC6eQUOsBDrBaXz6pje7ybvlJM3bc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NmzFGF4C58Zy8seNNIudTI3HJyzy1iRGL9qfXDX/X+SqIxJoWTa3ZiL8sB+B8fQtQyvC1hPs6R7M1uta5dMnccM2PPpm3DL4I4DQJMNlnCxOY+oFH3Nr6amquN+2Me83xmvh/Y13DjPRfLfuhqm0snZZgFX+n/j4vJe1neG57Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 09/17] netfilter: nft_set_pipapo: make pipapo_clone helper return NULL
Date: Sun, 12 May 2024 18:14:28 +0200
Message-Id: <20240512161436.168973-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240512161436.168973-1-pablo@netfilter.org>
References: <20240512161436.168973-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Currently it returns an error pointer, but the only possible failure
is ENOMEM.

After a followup patch, we'd need to discard the errno code, i.e.

x = pipapo_clone()
if (IS_ERR(x))
	return NULL

or make more changes to fix up callers to expect IS_ERR() code
from set->ops->deactivate().

So simplify this and make it return ptr-or-null.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index b8205d961ba4..7b6d5d2d0d54 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1395,7 +1395,7 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
  * pipapo_clone() - Clone matching data to create new working copy
  * @old:	Existing matching data
  *
- * Return: copy of matching data passed as 'old', error pointer on failure
+ * Return: copy of matching data passed as 'old' or NULL.
  */
 static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 {
@@ -1405,7 +1405,7 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 
 	new = kmalloc(struct_size(new, f, old->field_count), GFP_KERNEL);
 	if (!new)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	new->field_count = old->field_count;
 	new->bsize_max = old->bsize_max;
@@ -1477,7 +1477,7 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 	free_percpu(new->scratch);
 	kfree(new);
 
-	return ERR_PTR(-ENOMEM);
+	return NULL;
 }
 
 /**
@@ -1797,7 +1797,7 @@ static void nft_pipapo_commit(struct nft_set *set)
 		return;
 
 	new_clone = pipapo_clone(priv->clone);
-	if (IS_ERR(new_clone))
+	if (!new_clone)
 		return;
 
 	priv->dirty = false;
@@ -1821,7 +1821,7 @@ static void nft_pipapo_abort(const struct nft_set *set)
 	m = rcu_dereference_protected(priv->match, nft_pipapo_transaction_mutex_held(set));
 
 	new_clone = pipapo_clone(m);
-	if (IS_ERR(new_clone))
+	if (!new_clone)
 		return;
 
 	priv->dirty = false;
@@ -2269,8 +2269,8 @@ static int nft_pipapo_init(const struct nft_set *set,
 
 	/* Create an initial clone of matching data for next insertion */
 	priv->clone = pipapo_clone(m);
-	if (IS_ERR(priv->clone)) {
-		err = PTR_ERR(priv->clone);
+	if (!priv->clone) {
+		err = -ENOMEM;
 		goto out_free;
 	}
 
-- 
2.30.2

