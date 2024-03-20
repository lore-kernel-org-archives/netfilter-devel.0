Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D432638DD4
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 08:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924603; cv=none; b=jeNOe1ng+Aa5fP3T3VlyAFIA93miQ9IVNkj8GCxjtnktKKMJWlV+ApDtKDAXkHjz2q3k+bZJC5vpwO2xbqnDgKSKdlPP3w15z8LXNYXeDkOqDODdDlDfmyjXIcD4cEyPWlpZOE/6h22+7n5kVzkM5uNtMGVk+qlzY/PAE0vPdsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924603; c=relaxed/simple;
	bh=4pnHHUmLBVVoK/z5dYnU/5uz8w71B9oEX1c3f7FndEY=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=SwcQG97fB8I/adiRBtpVE8SZAMEw130fuSCKoD8h6rmmk51QVXWcRTbrx9SfPB6oEugg2wikImmwc/emGJROvp2jE0w3RBH89013ZxHSFs5Wjqrf5tBQMtqkepKulftAOLY8+d6pjCgXGpew5Nb7PHmse+yFPv6CLalVhmlzu38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_set_pipapo: release elements in clone only from destroy path
Date: Wed, 20 Mar 2024 09:49:52 +0100
Message-Id: <20240320084952.797227-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clone already always provides a current view of the lookup table, use it
to destroy the set, otherwise it is possible to destroy elements twice.

This fix requires:

 212ed75dc5fb ("netfilter: nf_tables: integrate pipapo into commit protocol")

which came after:

 9827a0e6e23b ("netfilter: nft_set_pipapo: release elements in clone from abort path").

Fixes: 9827a0e6e23b ("netfilter: nft_set_pipapo: release elements in clone from abort path")
Reported-by: lonial con <kongln9170@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index aa1d9e93a9a0..b3b282de802d 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2244,8 +2244,6 @@ static void nft_pipapo_destroy(const struct nft_ctx *ctx,
 	if (m) {
 		rcu_barrier();
 
-		nft_set_pipapo_match_destroy(ctx, set, m);
-
 		for_each_possible_cpu(cpu)
 			pipapo_free_scratch(m, cpu);
 		free_percpu(m->scratch);
@@ -2257,8 +2255,7 @@ static void nft_pipapo_destroy(const struct nft_ctx *ctx,
 	if (priv->clone) {
 		m = priv->clone;
 
-		if (priv->dirty)
-			nft_set_pipapo_match_destroy(ctx, set, m);
+		nft_set_pipapo_match_destroy(ctx, set, m);
 
 		for_each_possible_cpu(cpu)
 			pipapo_free_scratch(priv->clone, cpu);
-- 
2.30.2

