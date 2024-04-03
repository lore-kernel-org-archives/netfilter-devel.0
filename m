Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F3F56471
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2024 08:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712133744; cv=none; b=dqlHZ0nDyWTAJyl38cO7UrvKyNPWaRaA4vNhcKtXnuo2bmVHwNRhzozz6wcZJ1zGOsQ5Q5GwjeEXO9wFBWv86AuTQWFmKgkmHdAw0pcnUDfOSanwdEsyci8nudMO2a0nrvOxeOifFWYj7iMlJivJyK9s0WiUMuxPdqLC56ngcSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712133744; c=relaxed/simple;
	bh=UGYmTDlyQ0rn6p2xVf8UQutbArjRCWWeL6+2wkcV0Pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PExGST5VTj6oDmz1tk8JMtOmOGIvhVTm6+dggAoc1ebrMHIKSEfitLW5qYzc7sLLaaiHnszrTpnOxRJ7kCBikYuO4dddlNs+vuzB9MDOq7zKmCnmHQs3bjheP8fAZlYI6Epz0zLI2CvNw9ywx4xJJqK2l/N5E3avyFmkF51WmmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rrwCK-0005wg-Uu; Wed, 03 Apr 2024 10:42:20 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/9] netfilter: nft_set_pipapo: move prove_locking helper around
Date: Wed,  3 Apr 2024 10:41:01 +0200
Message-ID: <20240403084113.18823-2-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240403084113.18823-1-fw@strlen.de>
References: <20240403084113.18823-1-fw@strlen.de>
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
---
 net/netfilter/nft_set_pipapo.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index df8de5090246..a05e5d62a78e 100644
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

