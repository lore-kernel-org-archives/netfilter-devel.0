Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1097227FD4B;
	Tue, 16 Dec 2025 19:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765912173; cv=none; b=ep1tfBQqlYRxQgiQfHXjxAqtm09Z7URYpD2/Pb5ekDO0o14+MnPbCw50KgEk9CY6eUVao9RfiNupNAL9YqiUnrQn+sHCjMpArwFw5QGxD82B2DGDgFVHcayN2hhJ7S6f78omuotz8ma0zblXPB9JBeonYT4GEt1NOsrn2XKzAgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765912173; c=relaxed/simple;
	bh=+biMBYT20zMcdvozZ8nVga2FaTIFGJ3XFLXM4lCLLNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/3q/33mx7XH5vIowmahZqA76sLVfmS1VUYwr2pUzs4EMqi1kP++QMsUqPgoopFX7tuyKyMVeziOWD5R2LIrPHbncTHEhxgBG/14omfJAs6j3arqzxo1DN8dUPX0le3/O3cH3Blh3VvCOY1Mo2GqJbMKT4D+ozhF4MMFU74BpLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 91E4C6024F; Tue, 16 Dec 2025 20:09:30 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 5/6] netfilter: nf_tables: avoid softlockup warnings in nft_chain_validate
Date: Tue, 16 Dec 2025 20:09:03 +0100
Message-ID: <20251216190904.14507-6-fw@strlen.de>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251216190904.14507-1-fw@strlen.de>
References: <20251216190904.14507-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit
314c82841602 ("netfilter: nf_tables: can't schedule in nft_chain_validate"):
Since commit a60a5abe19d6 ("netfilter: nf_tables: allow iter callbacks to sleep")
the iterator callback is invoked without rcu read lock held, so this
cond_resched() is now valid.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a9f6babcc781..618af6e90773 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4171,6 +4171,8 @@ int nft_chain_validate(const struct nft_ctx *ctx, struct nft_chain *chain)
 			if (err < 0)
 				return err;
 		}
+
+		cond_resched();
 	}
 
 	nft_chain_vstate_update(ctx, chain);
@@ -4195,8 +4197,6 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 		err = nft_chain_validate(&ctx, chain);
 		if (err < 0)
 			goto err;
-
-		cond_resched();
 	}
 
 err:
-- 
2.51.2

