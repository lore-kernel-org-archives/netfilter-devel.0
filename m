Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E2A45D933;
	Wed,  9 Sep 2026 22:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788992351; cv=none; b=h/wqBsJWxVydV3RwerJt8fLt3xEZi1ZY8571oSFi6r3vPG7t/PYeTYsD6x7MTD+7ys7BANrTPcl21hMNo7sOVOjESw0tl1lWCuGUyDD/0BP/ou8kA4fCevza90NXpwfH7wfvaP7Zy20W8SErwpBa2tQQEGaSeF+UqgHagr2hNG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788992351; c=relaxed/simple;
	bh=dbMp5G6zi4otv+ki216pRBLPb+wKh6Lx4L60NlmzNLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4ZT180R+63/BMb9Hi1MTi0JLl146oMwRPnOloW9K9Htm+ewfHzwYB7LqTLOfB+/ItkFlNvAdwG5eWzT9V6SlEEsRbG4J+jIuABh/lXQBkTPKa4L5oOuBJEt3DCo4wmiNusFhpsgiLMCEO6bUXsuNdMpTl7IdQJpn0br137Civc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MOdeqhog; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MOdeqhog"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788992333;
	bh=OzqrpMnBXYJfJXg8qZsdbT2muYOCCqTwy3cm6hsjrXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MOdeqhog7+CHAtagfE2XEu/OuRykjZEJOmFk9tMGkK9zLnlBAcEjkeTwISSTO2FGn
	 lxIk2QQ+NjMHsuUW6fZYO5XIceFxbnCZdLLEyYVSZNDbV5WWMd7mPz9XQLDLbClJ03
	 WWBFocSqnCB2CPTaVIFbEvaa4We5YxbvtOkPwdZa39XP3vHq+9hM3IhYrBmRaj/o1d
	 g4jTEMm2+amN9GQ9o/S+Z97XeLzEAKk0DOm28nIwFpW0JHt0qx85g0jYRXOdmrge/D
	 OtBLpahaTVKGugLtmnvU+owb7lhZB1MlnLQcdgeUBbuvNC38gG4yJeXYnIzQL58VVW
	 w+NVlJsw59HbA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 19BD1607C0;
	Thu, 10 Sep 2026 00:18:53 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 2/7] netfilter: nf_tables: fix device name and prefix match in hook lookup
Date: Thu, 10 Sep 2026 00:18:39 +0200
Message-ID: <20260909221844.1650275-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260909221844.1650275-1-pablo@netfilter.org>
References: <20260909221844.1650275-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

Currently, a netdev chain or flowtable hooked to a device prefix can be
unintentionally deleted by a control-plane request targeting an exact
device name or even a shorter one due to the usage of min() to calculate
the length to match.

Fix this by making sure an exact device match never matches a prefix and
that both the target and the candidate have the same length during
delete operation. The add and update paths retain the existing overlap
matching to prevent a single device from matching multiple hooks.

Reported-by: Wei Fang <void0red@gmail.com>
Closes: https://lore.kernel.org/netfilter-devel/CANE+tVrDeNCHQVmsqkV2ozeBqyE3GtRDMhZgsg1bhw10yGNTRQ@mail.gmail.com/
Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 765a92fa90d6..3ab478ea7acb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2440,11 +2440,14 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 }
 
 static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
-					   const struct nft_hook *this)
+					   const struct nft_hook *this,
+					   bool strict)
 {
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, hook_list, list) {
+		if (strict && hook->ifnamelen != this->ifnamelen)
+			continue;
 		if (!strncmp(hook->ifname, this->ifname,
 			     min(hook->ifnamelen, this->ifnamelen))) {
 			if (hook->flags & NFT_HOOK_REMOVE)
@@ -2486,7 +2489,7 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
 			err = PTR_ERR(hook);
 			goto err_hook;
 		}
-		if (nft_hook_list_find(hook_list, hook)) {
+		if (nft_hook_list_find(hook_list, hook, false)) {
 			NL_SET_BAD_ATTR(extack, tmp);
 			nft_netdev_hook_free(hook);
 			err = -EEXIST;
@@ -2943,7 +2946,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 					ops->hook	= basechain->ops.hook;
 				}
 
-				if (nft_hook_list_find(&basechain->hook_list, h)) {
+				if (nft_hook_list_find(&basechain->hook_list, h, false)) {
 					list_del(&h->list);
 					nft_netdev_hook_free(h);
 					continue;
@@ -2956,7 +2959,8 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 					    !nft_trans_chain_update(trans))
 						continue;
 
-					if (nft_hook_list_find(&nft_trans_chain_hooks(trans), h)) {
+					if (nft_hook_list_find(&nft_trans_chain_hooks(trans),
+							       h, false)) {
 						nft_chain_release_hook(&hook);
 						return -EEXIST;
 					}
@@ -3257,7 +3261,7 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
 		return err;
 
 	list_for_each_entry(this, &chain_hook.list, list) {
-		hook = nft_hook_list_find(&basechain->hook_list, this);
+		hook = nft_hook_list_find(&basechain->hook_list, this, true);
 		if (!hook) {
 			err = -ENOENT;
 			goto err_chain_del_hook;
@@ -9053,7 +9057,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 			if (!nft_is_active_next(net, ft))
 				continue;
 
-			if (nft_hook_list_find(&ft->hook_list, hook)) {
+			if (nft_hook_list_find(&ft->hook_list, hook, false)) {
 				err = -EEXIST;
 				goto err_unregister_net_hooks;
 			}
@@ -9130,7 +9134,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 		return err;
 
 	list_for_each_entry_safe(hook, next, &flowtable_hook.list, list) {
-		if (nft_hook_list_find(&flowtable->hook_list, hook)) {
+		if (nft_hook_list_find(&flowtable->hook_list, hook, false)) {
 			list_del(&hook->list);
 			nft_netdev_hook_free(hook);
 			continue;
@@ -9143,7 +9147,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 			    !nft_trans_flowtable_update(trans))
 				continue;
 
-			if (nft_hook_list_find(&nft_trans_flowtable_hooks(trans), hook)) {
+			if (nft_hook_list_find(&nft_trans_flowtable_hooks(trans), hook, false)) {
 				err = -EEXIST;
 				goto err_flowtable_update_hook;
 			}
@@ -9363,7 +9367,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 		return err;
 
 	list_for_each_entry(this, &flowtable_hook.list, list) {
-		hook = nft_hook_list_find(&flowtable->hook_list, this);
+		hook = nft_hook_list_find(&flowtable->hook_list, this, true);
 		if (!hook) {
 			err = -ENOENT;
 			goto err_flowtable_del_hook;
-- 
2.47.3

