Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE9E2222D7
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Jul 2025 17:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752080736; cv=none; b=KTCfCzUvwJP1higKfOC9+GJeT6Wbh9h6VcH1Wd6JCFpd/eOQD8BTxnPVxWuDWTifz/yGyRChzK2s38MACfPhGgo10XQJLl8JPUcvPUyRYhYtExf5TD1rcBHK4yuf6NXMi2NFmVP32OKQexARWsZCQrLZBgMt9RbfBtCVzoL6IOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752080736; c=relaxed/simple;
	bh=0ngv+7LcODIoFAKNBcad1UcEHgpSIksdTZ+y3w5nF6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HT24K8cxyRCiD0VlGpM402JSPx1vWoenGIzLQGW9riv9bws4fNMNVGNPXNWF5IR7XokwACGwpUTh9gSVJVrADYvXlTiTW4nVfrTpZxWCv/pP++z9d6auOC/ekVy8q2R958gOXwxctUo7SVIQ82dFkkSKrsetNSFvzZ1LAI2bALw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4474560BCB; Wed,  9 Jul 2025 19:05:32 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>
Subject: [PATCH nf-next v2 1/5] netfilter: nft_set_pipapo: remove unused arguments
Date: Wed,  9 Jul 2025 19:05:12 +0200
Message-ID: <20250709170521.11778-2-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250709170521.11778-1-fw@strlen.de>
References: <20250709170521.11778-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

They are not used anymore, so remove them.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
---
 no changes.
 net/netfilter/nft_set_pipapo.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index c5855069bdab..08fb6720673f 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -502,8 +502,6 @@ bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 
 /**
  * pipapo_get() - Get matching element reference given key data
- * @net:	Network namespace
- * @set:	nftables API set representation
  * @m:		storage containing active/existing elements
  * @data:	Key data to be matched against existing elements
  * @genmask:	If set, check that element is active in given genmask
@@ -516,9 +514,7 @@ bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
  *
  * Return: pointer to &struct nft_pipapo_elem on match, error pointer otherwise.
  */
-static struct nft_pipapo_elem *pipapo_get(const struct net *net,
-					  const struct nft_set *set,
-					  const struct nft_pipapo_match *m,
+static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
 					  const u8 *data, u8 genmask,
 					  u64 tstamp, gfp_t gfp)
 {
@@ -615,7 +611,7 @@ nft_pipapo_get(const struct net *net, const struct nft_set *set,
 	struct nft_pipapo_match *m = rcu_dereference(priv->match);
 	struct nft_pipapo_elem *e;
 
-	e = pipapo_get(net, set, m, (const u8 *)elem->key.val.data,
+	e = pipapo_get(m, (const u8 *)elem->key.val.data,
 		       nft_genmask_cur(net), get_jiffies_64(),
 		       GFP_ATOMIC);
 	if (IS_ERR(e))
@@ -1345,7 +1341,7 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	else
 		end = start;
 
-	dup = pipapo_get(net, set, m, start, genmask, tstamp, GFP_KERNEL);
+	dup = pipapo_get(m, start, genmask, tstamp, GFP_KERNEL);
 	if (!IS_ERR(dup)) {
 		/* Check if we already have the same exact entry */
 		const struct nft_data *dup_key, *dup_end;
@@ -1367,7 +1363,7 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 
 	if (PTR_ERR(dup) == -ENOENT) {
 		/* Look for partially overlapping entries */
-		dup = pipapo_get(net, set, m, end, nft_genmask_next(net), tstamp,
+		dup = pipapo_get(m, end, nft_genmask_next(net), tstamp,
 				 GFP_KERNEL);
 	}
 
@@ -1914,7 +1910,7 @@ nft_pipapo_deactivate(const struct net *net, const struct nft_set *set,
 	if (!m)
 		return NULL;
 
-	e = pipapo_get(net, set, m, (const u8 *)elem->key.val.data,
+	e = pipapo_get(m, (const u8 *)elem->key.val.data,
 		       nft_genmask_next(net), nft_net_tstamp(net), GFP_KERNEL);
 	if (IS_ERR(e))
 		return NULL;
-- 
2.49.0

