Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D8237DAB1;
	Thu, 27 Aug 2026 14:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787840271; cv=none; b=HtRdPr30JWVszsbhz73JKIFWxsMhXMmRdoB5b53uZ+JI0Wlj/LNaK038eoIC0gtMju8lrqDguSPLqih8G956lsPPjYNbkV7oZ/Y3LySGzgexRFscpXNJBc96B1CDsDb97Z+vM8PJUXgXKi0ZmisG2fmA8NVv5bWdwU+h94EMJ+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787840271; c=relaxed/simple;
	bh=gDNZ2SnD1qsurf50Wl0c0HsB97ShN9sIw3W8jZGTD90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRSaJ925OMkrUESGqS5A6ZHvoVv3xi5osYHLULJKHe33eac6ueZXnQ6UQYf/TndTDX/FkHG80oE6wjmr2MUcdYEuN+p6SPJ21EsaDb8zvEufsxP+yGNuRkg8E5tmybTgKDOf8x7o0CDVrrwPhKWSkV91PFMcEgIX2QtYOigeEqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Q55gjLVN; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Q55gjLVN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787840263;
	bh=MOxDNX8BwHegRajTbMJWw1GRyCV9MRFGcDcjtP2dAv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q55gjLVNYwyexBq//+SkaeFzobQh4/plCuADsmDm7/SW4GyD51RTDs90e0O1tpe80
	 pnUO7qeMRyZAhRenQKHfyhp8rbYVEc4Y+KUU9WqHTrY52USTU+HDJKRtLcdioyUb5S
	 S8Xp+7bwybHqSYBonhNDRZBosGV9vfgmTxUWvVuQEvbtQj2ftwuT6ogzPHi468hSOk
	 loJBbRCUVG2LgmY8KalPuncvFxffe5cAuIRSiwXcyU1RTDy1aAlVPPDnz442C7NRmX
	 IgGbR2WKnQV3IU4VQ+YofuYhMzxoWKwe3KuJE5dN2BsfNAIdas52IqRvh+/b0otak4
	 L6v5WI6DG50Lg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8843460081;
	Thu, 27 Aug 2026 16:17:42 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 3/9] netfilter: nf_tables: move hardware offload step after building the chain blob
Date: Thu, 27 Aug 2026 16:17:27 +0200
Message-ID: <20260827141733.423453-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260827141733.423453-1-pablo@netfilter.org>
References: <20260827141733.423453-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allocate the chain blob before the ruleset offload to reduce chances of
entering an inconsistent state where the offloaded ruleset in the nic
and the software ruleset differ.

Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c112ecc4fca3..71f4227d7ac7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10982,10 +10982,6 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		return -EAGAIN;
 	}
 
-	err = nft_flow_rule_offload_commit(net);
-	if (err < 0)
-		return err;
-
 	/* 1.  Allocate space for next generation rules_gen_X[] */
 	list_for_each_entry_safe(trans, next, &nft_net->commit_list, list) {
 		struct nft_table *table = trans->table;
@@ -11010,6 +11006,16 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		}
 	}
 
+	/* must be last, so audit and chain blob set up does not leave hardware
+	 * in consistent state.
+	 */
+	err = nft_flow_rule_offload_commit(net);
+	if (err < 0) {
+		nf_tables_commit_chain_prepare_cancel(net);
+		nf_tables_commit_audit_free(&adl);
+		return err;
+	}
+
 	/* step 2.  Make rules_gen_X visible to packet path */
 	nft_set_commit_update(&ctx, nft_net);
 
-- 
2.47.3

