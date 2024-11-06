Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0132D1DE4C7;
	Wed,  6 Nov 2024 23:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730936803; cv=none; b=V+eAK4PQhhaAL7Y1BTwxi5DEUL7SxWPYqUkmCVJgvRFNXPki9/gcvzQSPG6REUihoqmg8ubOOdttEw4cgNgzjONc8ybwhHd2sTq0YvFae5iv+soliefNRK+y3mTQTm/qhYwkhToJITXuUjn8rntHqRTY8wWqdCMHkVAMaDdAlck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730936803; c=relaxed/simple;
	bh=kj4opEKkbC23Nkk+DhAR5RFISU84LX1aLJJ3F/yuDog=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TPkf7Cf/gAu+usSr9m93X3VmbQDRvK2tdR2zi4D6+/VbAspdpTsLv5tsFPXfTovj+A4T54oITF6CHpfoqDzl7nDzYADZ78yhZ7hPFN1ghccpiYYxozBPqcRJBKa2ct6lBipVOZJYIhXgm885ZsJI3VVfzIp64qljVHAjkT2c6nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 02/11] netfilter: nf_tables: Fix percpu address space issues in nf_tables_api.c
Date: Thu,  7 Nov 2024 00:46:16 +0100
Message-Id: <20241106234625.168468-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241106234625.168468-1-pablo@netfilter.org>
References: <20241106234625.168468-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Uros Bizjak <ubizjak@gmail.com>

Compiling nf_tables_api.c results in several sparse warnings:

nf_tables_api.c:2077:31: warning: incorrect type in return expression (different address spaces)
nf_tables_api.c:2080:31: warning: incorrect type in return expression (different address spaces)
nf_tables_api.c:2084:31: warning: incorrect type in return expression (different address spaces)

nf_tables_api.c:2740:23: warning: incorrect type in assignment (different address spaces)
nf_tables_api.c:2752:38: warning: incorrect type in assignment (different address spaces)
nf_tables_api.c:2798:21: warning: incorrect type in argument 1 (different address spaces)

Use {ERR_PTR,IS_ERR,PTR_ERR}_PCPU() macros when crossing between generic
and percpu address spaces and add __percpu annotation to *stats pointer
to fix these warnings.

Found by GCC's named address space checks.

There were no changes in the resulting object files.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a24fe62650a7..6552ec616745 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2082,14 +2082,14 @@ static struct nft_stats __percpu *nft_stats_alloc(const struct nlattr *attr)
 	err = nla_parse_nested_deprecated(tb, NFTA_COUNTER_MAX, attr,
 					  nft_counter_policy, NULL);
 	if (err < 0)
-		return ERR_PTR(err);
+		return ERR_PTR_PCPU(err);
 
 	if (!tb[NFTA_COUNTER_BYTES] || !tb[NFTA_COUNTER_PACKETS])
-		return ERR_PTR(-EINVAL);
+		return ERR_PTR_PCPU(-EINVAL);
 
 	newstats = netdev_alloc_pcpu_stats(struct nft_stats);
 	if (newstats == NULL)
-		return ERR_PTR(-ENOMEM);
+		return ERR_PTR_PCPU(-ENOMEM);
 
 	/* Restore old counters on this cpu, no problem. Per-cpu statistics
 	 * are not exposed to userspace.
@@ -2533,10 +2533,10 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 
 		if (nla[NFTA_CHAIN_COUNTERS]) {
 			stats = nft_stats_alloc(nla[NFTA_CHAIN_COUNTERS]);
-			if (IS_ERR(stats)) {
+			if (IS_ERR_PCPU(stats)) {
 				nft_chain_release_hook(&hook);
 				kfree(basechain);
-				return PTR_ERR(stats);
+				return PTR_ERR_PCPU(stats);
 			}
 			rcu_assign_pointer(basechain->stats, stats);
 		}
@@ -2650,7 +2650,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 	struct nft_table *table = ctx->table;
 	struct nft_chain *chain = ctx->chain;
 	struct nft_chain_hook hook = {};
-	struct nft_stats *stats = NULL;
+	struct nft_stats __percpu *stats = NULL;
 	struct nft_hook *h, *next;
 	struct nf_hook_ops *ops;
 	struct nft_trans *trans;
@@ -2746,8 +2746,8 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 		}
 
 		stats = nft_stats_alloc(nla[NFTA_CHAIN_COUNTERS]);
-		if (IS_ERR(stats)) {
-			err = PTR_ERR(stats);
+		if (IS_ERR_PCPU(stats)) {
+			err = PTR_ERR_PCPU(stats);
 			goto err_hooks;
 		}
 	}
-- 
2.30.2

