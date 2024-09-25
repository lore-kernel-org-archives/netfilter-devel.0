Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75C8183090;
	Wed, 25 Sep 2024 11:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727264304; cv=none; b=ChlXkz9XBxJhT8JTK5HKPMJTf1mw/c0wbMvZWArkeZfeqqS/d/RheS1ae1cutAzvYTlOKjtc4Vmrc3iQ58Txdx/S6NBHZroP8i0ZerZ3yWSMAquWbYQvqAlkRq+MyepbZwFwjVHrVzYJGdUNqRIfI6HSUCNwFCZYrVpwSO/4zmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727264304; c=relaxed/simple;
	bh=DxyhDsY+mD6RFxzE1w0Q+rgTbbD43GElQZDaZIaLLWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7+K1fozgI3Bi329v9GYFB/UYGRvesAXYKSokbn1q0DbSBbTbZDg9P/6NWiC3aEtJthxnrPkzqhr3ZBKHV01i3vbq5l1c2zBYwTlcalDRi+ApxZQMXzwoAzggHTb4ZB9n4O32vVOs8lvpxGEk4H2qhSAZ0I8xZnNrurTtfbZEbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cGb6Y3aS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cGb6Y3aS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DADC4CEC3;
	Wed, 25 Sep 2024 11:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727264304;
	bh=DxyhDsY+mD6RFxzE1w0Q+rgTbbD43GElQZDaZIaLLWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGb6Y3aSU7Z93132pe5//OSuzDA5lomzE3TI67EU4CtBQvjtjARFbYTW9OV8PL9I9
	 MbZUYzG7hzaeWUIbOH0LmGuu0dq2HvYHcSZMbiEU/CVPJ4+n9bTyYFNXPvgAkv4bzb
	 ly6YOFMdJ+o3Nx4O2En5i7pNr8k5REwH6KFYalUGPrIfbeTYaUCSvDV3mTXvk6Z4Mp
	 mkg4DlPkPHhPnRuscBw5gYEPR5+u7bjSuN8545K1LHaeV6TpRvG8ergfomcxp9jLMT
	 8Wc1lej76yn77xWuTrEYTB5q3f0l4QtppCz+vc6TQuci+Wa3g8XFxQQ2EhPQ0AKnt+
	 U9/O9vpmg7ITQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	kadlec@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.11 049/244] netfilter: nf_tables: don't initialize registers in nft_do_chain()
Date: Wed, 25 Sep 2024 07:24:30 -0400
Message-ID: <20240925113641.1297102-49-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240925113641.1297102-1-sashal@kernel.org>
References: <20240925113641.1297102-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit c88baabf16d1ef74ab8832de9761226406af5507 ]

revert commit 4c905f6740a3 ("netfilter: nf_tables: initialize registers in
nft_do_chain()").

Previous patch makes sure that loads from uninitialized registers are
detected from the control plane. in this case rule blob auto-zeroes
registers.  Thus the explicit zeroing is not needed anymore.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index a48d5f0e2f3e1..75598520b0fa0 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -256,7 +256,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 	const struct net *net = nft_net(pkt);
 	const struct nft_expr *expr, *last;
 	const struct nft_rule_dp *rule;
-	struct nft_regs regs = {};
+	struct nft_regs regs;
 	unsigned int stackptr = 0;
 	struct nft_jumpstack jumpstack[NFT_JUMP_STACK_SIZE];
 	bool genbit = READ_ONCE(net->nft.gencursor);
-- 
2.43.0

