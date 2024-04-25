Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B1984E09
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Apr 2024 12:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714046949; cv=none; b=KZHV/UunqiNpzXiS5zfpsAv9CklgTpmvBXbs9pXBHSsCQOL8bGdCOFg1B43qc1cO2ZnWf3MXTotmZTShLr2udG6YejPfEfefwkQ1+tLgB5gMi+2mHEabpJHgFVD/ziqidpwyJm57MTCsNH5AhkQTmMRdC+jjFJb5SvQtwZRIOvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714046949; c=relaxed/simple;
	bh=bGYOzDksD1hYfmnvcPzL3X2TKEUu7BO6O4B0r4IsHKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iY+Uxhw0hpxa8sohveA/38bb0DdfrexkXnDShWIPE8AGROoCAbvv5NoJdjdjrwygSceoLheMH7LAig1WVVkRpHogoONE+4gDnLsH9qAvJW4yOsp9FPpw5qwovL62+glBS4seaUYxUGonCoYZRdvCWuxEV/Udd4vn9MSfrXcIo5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rzxuT-0007ow-L3; Thu, 25 Apr 2024 14:09:05 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 2/8] netfilter: nft_set_pipapo: make pipapo_clone helper return NULL
Date: Thu, 25 Apr 2024 14:06:41 +0200
Message-ID: <20240425120651.16326-3-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240425120651.16326-1-fw@strlen.de>
References: <20240425120651.16326-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
2.43.2

