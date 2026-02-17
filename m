Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14CA36EA95;
	Tue, 17 Feb 2026 16:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771346006; cv=none; b=LLADzQGFu4A/aJamHe5RwQ5FPbKPhCNCSrQZF3tBqgZmd6EcQgoITx2h6PEB1ICUWaKz5X0cKT5zhYuXSM+Wk3B9XJxLf7T9UzvU1CqN/D2r6tbeNYXVoI0AWaGwXSzRo6HJtGAwyv48bGaucAhzavLzncP2+WFLcHz8q1tcOug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771346006; c=relaxed/simple;
	bh=NVoL6oS2NZpM0kV67jS8xtT75NvtAtIkB18jEHS9UzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFfmmJpTZtUDXfxlJca86UmX5z2r0Cuqqf/PazIQQIAMMngx5WgXwSyCcFtb+vzjCeqP/Nd1xNmhepJZuQ8YVJtCams6er9MOEaMwBgJSa3+Piv7lCik29fsjg1QY50pmH/eedimGaZ8UbHhK2qxAVUmM8w/G3q54SHo1hgLTSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7D07F60CFA; Tue, 17 Feb 2026 17:33:23 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 10/10] netfilter: nf_tables: fix use-after-free in nf_tables_addchain()
Date: Tue, 17 Feb 2026 17:32:33 +0100
Message-ID: <20260217163233.31455-11-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260217163233.31455-1-fw@strlen.de>
References: <20260217163233.31455-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Inseo An <y0un9sa@gmail.com>

nf_tables_addchain() publishes the chain to table->chains via
list_add_tail_rcu() (in nft_chain_add()) before registering hooks.
If nf_tables_register_hook() then fails, the error path calls
nft_chain_del() (list_del_rcu()) followed by nf_tables_chain_destroy()
with no RCU grace period in between.

This creates two use-after-free conditions:

 1) Control-plane: nf_tables_dump_chains() traverses table->chains
    under rcu_read_lock(). A concurrent dump can still be walking
    the chain when the error path frees it.

 2) Packet path: for NFPROTO_INET, nf_register_net_hook() briefly
    installs the IPv4 hook before IPv6 registration fails.  Packets
    entering nft_do_chain() via the transient IPv4 hook can still be
    dereferencing chain->blob_gen_X when the error path frees the
    chain.

Add synchronize_rcu() between nft_chain_del() and the chain destroy
so that all RCU readers -- both dump threads and in-flight packet
evaluation -- have finished before the chain is freed.

Fixes: 91c7b38dc9f0 ("netfilter: nf_tables: use new transaction infrastructure to handle chain")
Signed-off-by: Inseo An <y0un9sa@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 819056ea1ce1..0c5a4855b97d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2823,6 +2823,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 policy,
 
 err_register_hook:
 	nft_chain_del(chain);
+	synchronize_rcu();
 err_chain_add:
 	nft_trans_destroy(trans);
 err_trans:
-- 
2.52.0

