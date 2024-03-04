Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87A381756D
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Mar 2024 18:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709575376; cv=none; b=nyHm7eLxO1x3ATe7e5xcGllHKcGj+AJVuCFu6KnzILrBZSiSk08Z+6HWugl2/kHHY+ruBqdebaA1VdNvOh3bDqSmr3dzaNVNG53hU5K7GjGVhNBR5lgcF8bMLCpaovFdLR5I2UJFL5NF9rLCG02r2z4ctRYWHLKvNZl1KgIbs/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709575376; c=relaxed/simple;
	bh=1itpnLEnzg0l/PfYKqzL4opfuk8jWCUlkUaBGnS+0zs=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=siIJ9LeHOT8EVdxRx8UJ66rY+VvPo1q1l2+fbYEpQRiFQKcFsoNCSRBjjkBUJoQqic7hLNWrn4z/2PFRQ9wjrxWfVNVBCPrs5VxZLn7rVyJqad3segHICwyu4XAfjSE50gce/Fa6WfhxSOKyYWU7NBm8jdy/PnueEQtmLthez8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables: mark set as dead when deactivating anonymous set
Date: Mon,  4 Mar 2024 18:53:06 +0100
Message-Id: <20240304175306.145996-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While the rhashtable set gc runs asynchronously, a race allows it to
collect elements from an anonymous set while it is being released from
the abort path. This also seems possible from the rule error path.

Mingi Cho originally reported this issue in a different path in 6.1.x
with a pipapo set with low timeouts which is not possible upstream since
7395dfacfff6 ("netfilter: nf_tables: use timestamp to check for set
element timeout").

Fix this by setting on the dead flag to signal set gc to skip anonymous
sets from prepare_error, abort and commit paths.

Cc: stable@vger.kernel.org
Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Reported-by: Mingi Cho <mgcho.minic@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ca54d4c23123..26d33ce3b682 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5513,6 +5513,7 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
 			list_del_rcu(&binding->list);
 
 		nft_use_dec(&set->use);
+		set->dead = 1;
 		break;
 	case NFT_TRANS_PREPARE:
 		if (nft_set_is_anonymous(set)) {
@@ -5534,6 +5535,7 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
 	default:
 		nf_tables_unbind_set(ctx, set, binding,
 				     phase == NFT_TRANS_COMMIT);
+		set->dead = 1;
 	}
 }
 EXPORT_SYMBOL_GPL(nf_tables_deactivate_set);
-- 
2.30.2

