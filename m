Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9E81D131E;
	Wed, 25 Sep 2024 11:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727265592; cv=none; b=K7jmi/FJrgc9SMUu2oZWxY3mPDmD1kXcoXorZmhWYYQRa3wKELi8G9bRrM3yGua8r+RYqxcDRVdREpvuFuNT0x4tKyKgpavx6VsJyG4j/k0YtU7STdKNKvAcN7c569fWVtCra8kGut3au5nK9iakGCbduAFX5VHrtqMnylrfeZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727265592; c=relaxed/simple;
	bh=DxyhDsY+mD6RFxzE1w0Q+rgTbbD43GElQZDaZIaLLWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQ8/sneghSUR76q8bRz6NgBbCB5i8NnztKdKNEOkgH/D/xj41kxT8ck4J8v7/flDNggcuPibWWZ0WGp6Ta7XrH7uIIfCyfAJea7+jCbgPVhWn1Mg8FAmTA2zJBy143m6JnYIy29C3dNU4hUruHMR2vdnK6RT0VmiPX72DOakR1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RCwrSL6s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RCwrSL6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C732C4CEC3;
	Wed, 25 Sep 2024 11:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727265592;
	bh=DxyhDsY+mD6RFxzE1w0Q+rgTbbD43GElQZDaZIaLLWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCwrSL6sTLJXLDUK64eO4z2YjJdyUmcQmZs71sakPzjpz3/T0VLC4aJEqYuonTyHb
	 lXLu/yqii9eOFyNw2+THhdeto1pHZkamCeJvH199b54UY1E/OElrjyxiD51KhyHDSJ
	 KBjqpv7VTuFL8gKkEahqMtn+4j5LIy1znV6P1McMnmMOWk98qSg4PqNaOSlcGCuTgx
	 gt9bElkKWM3RdWRX8iyYVOH99O/lqX5fOctVhfHj6GzCjiQVNYvJtnmcDbf/qYZbRV
	 uOsTLWbYbUlKFAmsF1IqU4iSm5EGbm4Gv9iILIfKfTZfeNkrfRQ94bD3aHiNI4zQRa
	 Slnl0XqE/6TvA==
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
Subject: [PATCH AUTOSEL 6.10 040/197] netfilter: nf_tables: don't initialize registers in nft_do_chain()
Date: Wed, 25 Sep 2024 07:50:59 -0400
Message-ID: <20240925115823.1303019-40-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240925115823.1303019-1-sashal@kernel.org>
References: <20240925115823.1303019-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.10.11
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

