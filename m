Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42D53A4F51;
	Fri, 21 Aug 2026 15:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787326734; cv=none; b=XaFx3BJPyX+hvtnioE/EnvnShnqt24jb6yn73W3bmrPuevR14vTxl6PbL10YHNJkan3a5rYjSErkfYq3AZlybNnxW/e49rjFpsfkuow0ZXq2UA2uNTJ6AIgDrOX3sy8jLAPjgVKU4p8s2KGczmF0qZu5J5t4p7jaw2z0+TP40BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787326734; c=relaxed/simple;
	bh=gDNZ2SnD1qsurf50Wl0c0HsB97ShN9sIw3W8jZGTD90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfKRXO13Y1I6ryywZVJlYdUPJGSERo2zDV6IJL6SWumSc1xFML5llnrDb8UZQzJ9GYskxRKYCGULg0mQDA0ogXIhYC2/bWXevH6YGAC3zKrLh5X0N/6DFTgK82dhhLd1M9tASep361G2ONnhDVu4vGUHR2J+WwiDUa4RWxvGrvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mULQnPUx; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mULQnPUx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787326727;
	bh=MOxDNX8BwHegRajTbMJWw1GRyCV9MRFGcDcjtP2dAv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mULQnPUxIw90NsZFenNelFDvFmyTGqoa9BxGKxCNH2wBThBqBLhalqdfvTfTbU/Sy
	 ssxSyLjE6sg1kyRfWhbms62BER9wlPX6svCLa2PAl+XGIGnEEjTZTY59edy4oEuRwE
	 hVkVmXJDzInTkGdA5dNxhPfhyxGqFdx9uTtJl55cR7DrYhC3C7FkdQZhygFTPpptzY
	 JyD0mNMWuzhGOrKlQFMTyOVxsg7JFG6MprVyahn2hv5UrIDnUBVSjWVVmFiv2SRFLA
	 BJjQtbnRX8SyizpjIFcqR3Mxud+lrSVeh8rafQrvscmu2reD3fYJs4mbXaPsqxww1l
	 TxthzUQRVJR5w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 04C056008E;
	Fri, 21 Aug 2026 17:38:46 +0200 (CEST)
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
Subject: [PATCH net 03/10] netfilter: nf_tables: move hardware offload step after building the chain blob
Date: Fri, 21 Aug 2026 17:38:26 +0200
Message-ID: <20260821153833.245589-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821153833.245589-1-pablo@netfilter.org>
References: <20260821153833.245589-1-pablo@netfilter.org>
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

