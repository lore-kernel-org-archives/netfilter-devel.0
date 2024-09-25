Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965581D0F5B;
	Wed, 25 Sep 2024 12:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727266377; cv=none; b=UV2el92p8D4nKXvsET7tlV8kzHy9Qc4BoPOzOQxoYBEkMtAcaR2XbUOyJIm549XHtFkp/8sLXUmzz6Xh1sl/WwV7b6KNXjUta8piVnRUob4WN1QjNJVayANbakc5B6C8ObkVQCEf7wRJbqG5kq2b9phKAVsDYqNSpiDa8ROKgks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727266377; c=relaxed/simple;
	bh=9SJN0SgPf+AkuIT/R5MeKY9JII9J8ldz2TPbpr0c1RE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MvSL0LHYW7V/HZqoy+xtJN8kk0K4rr9Eo/LASjAtPW1lgkp6J5zgvrzt1ZdYsXXDRmOFUDtxkt2JLiVBWl54Ab10HHqEjjczdqk8BwPgjzJ88842U5L6lW0wwTJr24/AIy502dnm1VVGQ5yxw3yGgQxL63XYM6VFQoqE6iF0a7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QL0G51iQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QL0G51iQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F61C4CECD;
	Wed, 25 Sep 2024 12:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727266377;
	bh=9SJN0SgPf+AkuIT/R5MeKY9JII9J8ldz2TPbpr0c1RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QL0G51iQYyQvhvIusn2n6XaVW7JEaWhIznaO2RGagMxXLeuM73DKG5uS3XkPC2hyq
	 V+9QEEHyIXfqbAfjJfy5dNL0Xjc8c4TemydKKkrJMzpHlwJlPAfvpXIlHjMeRdp8Ua
	 0eRx3UMJ6dM01Cq72wTrj8vhV+1dfexLop9m8rHw3tuVYD/ZKr0AoXb59I5H6gyXww
	 lLybrcehVIRxeXvPpyKt9ws5ofLmRqnVpr50VRBrgVydR5f1ux1JuYZgz3e19y4VIF
	 d0qk/t4l/VKxipuntpLnnYOUFj3mx6GBFFN3xRLuD9I/P5PPIS8pUfLk2LhbGzgCED
	 utR8uF8ovlyRQ==
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
Subject: [PATCH AUTOSEL 6.6 038/139] netfilter: nf_tables: don't initialize registers in nft_do_chain()
Date: Wed, 25 Sep 2024 08:07:38 -0400
Message-ID: <20240925121137.1307574-38-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240925121137.1307574-1-sashal@kernel.org>
References: <20240925121137.1307574-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.52
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
index 711c22ab701dd..3b0b6c28cca5e 100644
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

