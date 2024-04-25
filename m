Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA59F84DFC
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Apr 2024 12:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714046945; cv=none; b=jXhSBcmCrITa8JP3/TdnC7gHqqzZ58smOzLxA97CxHnA/Xfw3Mwaxkn/xJI3zamvurMD+OkUgQ805YoYfW+tJM34mVmQ06BFlhHet63f2ep6PSo9098w7EFStlFD5gtUH4MoEXKJ+cF/PoBA/iThnBMz3+7FY5CUD3qPhvi5sxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714046945; c=relaxed/simple;
	bh=BkVwatDBlB/NF7ijNKYzujNFvuGKqzhMrtjLrNfhZrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=So3FgK0ZhiYgvy3fpQyb74FIAgBJ+8a11lP+43DwNNfUcrRr1Yn5C6XUhLTOfXtr+zPlocmP5fVlKW6AUA8u+Z8ZT3WkJ2r4RMxTCAzG5Jhi/q2HCn7Ii/wSDhZzUpnJ3R2x2p+zuLPGN0jZy5vhbrfRFjltijh+ybkzGI53M4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rzxuP-0007nm-HU; Thu, 25 Apr 2024 14:09:01 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 1/8] netfilter: nft_set_pipapo: move prove_locking helper around
Date: Thu, 25 Apr 2024 14:06:40 +0200
Message-ID: <20240425120651.16326-2-fw@strlen.de>
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

Preparation patch, the helper will soon get called from insert
function too.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/netfilter/nft_set_pipapo.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 187138afac45..b8205d961ba4 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1247,6 +1247,17 @@ static int pipapo_realloc_scratch(struct nft_pipapo_match *clone,
 	return 0;
 }
 
+static bool nft_pipapo_transaction_mutex_held(const struct nft_set *set)
+{
+#ifdef CONFIG_PROVE_LOCKING
+	const struct net *net = read_pnet(&set->net);
+
+	return lockdep_is_held(&nft_pernet(net)->commit_mutex);
+#else
+	return true;
+#endif
+}
+
 /**
  * nft_pipapo_insert() - Validate and insert ranged elements
  * @net:	Network namespace
@@ -1799,17 +1810,6 @@ static void nft_pipapo_commit(struct nft_set *set)
 	priv->clone = new_clone;
 }
 
-static bool nft_pipapo_transaction_mutex_held(const struct nft_set *set)
-{
-#ifdef CONFIG_PROVE_LOCKING
-	const struct net *net = read_pnet(&set->net);
-
-	return lockdep_is_held(&nft_pernet(net)->commit_mutex);
-#else
-	return true;
-#endif
-}
-
 static void nft_pipapo_abort(const struct nft_set *set)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
-- 
2.43.2

