Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3253E19470;
	Wed, 22 May 2024 23:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716419652; cv=none; b=go6dFxx9dfvgydvrUaPCbyvC4HPRy0MuxY2GLQDEaFKysyn8RHTdRwvTjeV0vegtioRBvp+pZEitBVMMaoMve4bvHcb80Uk4JxB6kgX6OUzWw62BcxPotk3gjiXL+VpEe5fM+WVgYO3VQRR79oApi7IfDY52rBFX0/mRoBaMRUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716419652; c=relaxed/simple;
	bh=DTgRKfxj+1zRBu9Atn+nXDKC7uNhiPYbOhZk7jZJh/M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CF1mgFegl4XPZFay8evy+oCMoo+kPfI5ewF00t0VRUfF/MS0FhEoH7Uqa0hn34RRCdxEHN2Y58CBubUubbvwiMe0nQDdMS+xB75UM5K+CJzP4Ern/CigNaISsRw3cK8jNwbuFSfig/VSPMmpyLVZ08uUourNCYjyl8jt2stu2Zw=
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
Subject: [PATCH net 6/6] netfilter: nft_fib: allow from forward/input without iif selector
Date: Thu, 23 May 2024 01:13:55 +0200
Message-Id: <20240522231355.9802-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240522231355.9802-1-pablo@netfilter.org>
References: <20240522231355.9802-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Garver <eric@garver.life>

This removes the restriction of needing iif selector in the
forward/input hooks for fib lookups when requested result is
oif/oifname.

Removing this restriction allows "loose" lookups from the forward hooks.

Fixes: be8be04e5ddb ("netfilter: nft_fib: reverse path filter for policy-based routing on iif")
Signed-off-by: Eric Garver <eric@garver.life>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_fib.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index 37cfe6dd712d..b58f62195ff3 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -35,11 +35,9 @@ int nft_fib_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	switch (priv->result) {
 	case NFT_FIB_RESULT_OIF:
 	case NFT_FIB_RESULT_OIFNAME:
-		hooks = (1 << NF_INET_PRE_ROUTING);
-		if (priv->flags & NFTA_FIB_F_IIF) {
-			hooks |= (1 << NF_INET_LOCAL_IN) |
-				 (1 << NF_INET_FORWARD);
-		}
+		hooks = (1 << NF_INET_PRE_ROUTING) |
+			(1 << NF_INET_LOCAL_IN) |
+			(1 << NF_INET_FORWARD);
 		break;
 	case NFT_FIB_RESULT_ADDRTYPE:
 		if (priv->flags & NFTA_FIB_F_IIF)
-- 
2.30.2

