Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458F631CA60;
	Wed, 20 Aug 2025 14:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755701275; cv=none; b=MfQPW/sCo52XJaTArEEEyuh+tEW6mex7ZOTPmZz/FYSsXoFvufy+K/oTV6qHrLHoFcebmYGvgH1751ZtqkTFoAED6VysoLCB5EY3Ny96LDX0N9sjnmNBWr+xUmz2t4/m05EtKYiuTbxXHMDwNiW6NxOA+H/jSwsc7Do26SgfuA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755701275; c=relaxed/simple;
	bh=4RZ+UxhdjaJpjMTpWJoc9sv9LtN/O5sWwVlCV/ZEoh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sxz8fsaGk8RAjqMuTFTlhnVrR6hNTszLUS42q43/+LznpkUQbvPF0NzXnBXuyT419QTiVvRQFPtJc4sCyozAGUZfej04PwhupzT+873Ki9eb8U/8bTh0PR7i1CPfKhZI8acxo5zCeh3E3ZtK6+mI3S2XUnrxeLmDxa5OwMcRE4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 757196062E; Wed, 20 Aug 2025 16:47:51 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 2/6] netfilter: nft_set_pipapo_avx2: Drop the comment regarding protection
Date: Wed, 20 Aug 2025 16:47:34 +0200
Message-ID: <20250820144738.24250-3-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250820144738.24250-1-fw@strlen.de>
References: <20250820144738.24250-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The comment claims that the kernel_fpu_begin_mask() below protects
access to the scratch map. This is not true because the access is only
protected by local_bh_disable() above.

Remove the misleading comment.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo_avx2.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index 2f090e253caf..fc734a8545b4 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1171,9 +1171,7 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 
 	m = rcu_dereference(priv->match);
 
-	/* This also protects access to all data related to scratch maps.
-	 *
-	 * Note that we don't need a valid MXCSR state for any of the
+	/* Note that we don't need a valid MXCSR state for any of the
 	 * operations we use here, so pass 0 as mask and spare a LDMXCSR
 	 * instruction.
 	 */
-- 
2.49.1

