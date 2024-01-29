Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038C3153BE9;
	Mon, 29 Jan 2024 15:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706542290; cv=none; b=VxbzlHDSeHu7wKpZZqkDTEF0TKi3ykN1jpPfut21KXz+Gtts2tIJ+CnIGduImeewnBd2vyxhGbVQW9+xtEWzR9NgT2VIp08kf87QO3NVbG3qnPim9y7kYQ397nozCbR/8LnZOEOVB2eMAo7Y4Hu5EfKckaAc8Td0mcNacOgvXHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706542290; c=relaxed/simple;
	bh=LBRN5RjKnpPANTwMylVrsyh1S34feeBe8TEBNC37QIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4YRIE6bJAoxwniPmPs+uuqAmzYPhTModB153heKOwX/7+C1DIT9G3aBDKM4i5DKumy0zR6194tvBx798bnlLSymF0yFohA2VCbJ2lPIkqoflw0sber/rPFlouir5MXahsW3ZAPyblFEDf5G3SlrZ2ma7JNqlcAaaiJ7vcaq+mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rUTbV-00020r-Lb; Mon, 29 Jan 2024 16:31:21 +0100
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 4/9] netfilter: nf_tables: pass flags to set backend selection routine
Date: Mon, 29 Jan 2024 15:57:54 +0100
Message-ID: <20240129145807.8773-5-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129145807.8773-1-fw@strlen.de>
References: <20240129145807.8773-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

No need to refetch the flag from the netlink attribute, pass the
existing flags variable which already provide validated flags.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b0e0d039897e..7f25a04e4b81 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4247,23 +4247,18 @@ static bool nft_set_ops_candidate(const struct nft_set_type *type, u32 flags)
  * given, in that case the amount of memory per element is used.
  */
 static const struct nft_set_ops *
-nft_select_set_ops(const struct nft_ctx *ctx,
-		   const struct nlattr * const nla[],
+nft_select_set_ops(const struct nft_ctx *ctx, u32 flags,
 		   const struct nft_set_desc *desc)
 {
 	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
 	const struct nft_set_ops *ops, *bops;
 	struct nft_set_estimate est, best;
 	const struct nft_set_type *type;
-	u32 flags = 0;
 	int i;
 
 	lockdep_assert_held(&nft_net->commit_mutex);
 	lockdep_nfnl_nft_mutex_not_held();
 
-	if (nla[NFTA_SET_FLAGS] != NULL)
-		flags = ntohl(nla_get_be32(nla[NFTA_SET_FLAGS]));
-
 	bops	    = NULL;
 	best.size   = ~0;
 	best.lookup = ~0;
@@ -5149,7 +5144,7 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	if (!(info->nlh->nlmsg_flags & NLM_F_CREATE))
 		return -ENOENT;
 
-	ops = nft_select_set_ops(&ctx, nla, &desc);
+	ops = nft_select_set_ops(&ctx, flags, &desc);
 	if (IS_ERR(ops))
 		return PTR_ERR(ops);
 
-- 
2.43.0

