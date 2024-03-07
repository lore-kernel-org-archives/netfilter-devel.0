Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8D845C15
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 08:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709801192; cv=none; b=rrEwSBhQWNEiBKhtivG8vkPbxl6TO9dG8RtfVod7F9TbaUQ5Ze5TUXUaEPOPcHjju++MERkjtrm8aX4eJlIuojJ2XC84HQwjgNwtK35QFmlrlYN0+rX2sdc710szEkE0Qd25n9Z1kH9C6KhVO5SRgdjOhvuqeFO1PW3M+Sgbfbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709801192; c=relaxed/simple;
	bh=QiEC4CYPfhaNLwWT6fr06mGyrTzAzxoYGp8QdZZCMko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pk8E013FAFqTZibOrnU0x7aWRhdKQeKJehyI1yerN90P811LxjEEpDB7wn9+EzDpBxoEsl9yAd2SXb2tsFgkRafxV6Jkuiu9xz/P8GhKEvseijjr8cmD8lNY5w9ibntTtSeZ3slYoNz6lx6hN/SW8Goau5JbN6HYWGyGhxXwPj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1ri9OW-0005K6-DB; Thu, 07 Mar 2024 09:46:28 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/9] netfilter: nf_tables: warn if set being destroyed is still active
Date: Thu,  7 Mar 2024 09:40:05 +0100
Message-ID: <20240307084018.2219-2-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240307084018.2219-1-fw@strlen.de>
References: <20240307084018.2219-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Control plane should mark a to-be-destroyed set as dead before
the ->destroy function gets called.

This needs to be done while control plane still holds the
transaction mutex.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 3 +++
 net/netfilter/nft_set_hash.c  | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 224e5fb6a916..be8254d31988 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5276,6 +5276,9 @@ static void nft_set_destroy(const struct nft_ctx *ctx, struct nft_set *set)
 	for (i = 0; i < set->num_exprs; i++)
 		nft_expr_destroy(ctx, set->exprs[i]);
 
+	if (WARN_ON_ONCE(!set->dead))
+		set->dead = 1;
+
 	set->ops->destroy(ctx, set);
 	nft_set_catchall_destroy(ctx, set);
 	nft_set_put(set);
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 6968a3b34236..06337a089c34 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -451,6 +451,8 @@ static void nft_rhash_destroy(const struct nft_ctx *ctx,
 		.set	= set,
 	};
 
+	WARN_ON_ONCE(!set->dead);
+
 	cancel_delayed_work_sync(&priv->gc_work);
 	rhashtable_free_and_destroy(&priv->ht, nft_rhash_elem_destroy,
 				    (void *)&rhash_ctx);
-- 
2.43.0

