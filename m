Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2926230F812
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Dec 2025 12:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765456297; cv=none; b=Eohj2vaBqTi96f8GTJS5RZKkX6MMwy9uJCIgIBIttdLMRl4cAlNeWj5rRVvdKIMOwBH4eUi/jHQUK5/4PTMoeIpApgwzgPnTCARilLSo7LOzWpSdKedstnFGRelFb6kSNXPbcxMJzG1mkzeeZptqd4QYJJ+CWefynreFIao7hPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765456297; c=relaxed/simple;
	bh=+biMBYT20zMcdvozZ8nVga2FaTIFGJ3XFLXM4lCLLNo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ct0cE4dE1gbizwKitjjh4qxXN+SY54fiflIIJBkMsebduK4mbHIgxumoa3NDw95OjYObE8oZmff2U6aDSqbcpU0hwyJHpsXCehoe2c7bzX9L+dO3t8IwMRWhca6npEuv9KnqkyadRoYN09lcfu+gjiZUNdkfmBx0ZKGqcHt/fNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 08C7560332; Thu, 11 Dec 2025 13:31:31 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nf_tables: avoid softlockup warnings in nft_chain_validate
Date: Thu, 11 Dec 2025 13:31:23 +0100
Message-ID: <20251211123126.8759-1-fw@strlen.de>
X-Mailer: git-send-email 2.51.2
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

