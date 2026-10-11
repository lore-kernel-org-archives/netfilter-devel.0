Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7041640759B;
	Sun, 11 Oct 2026 22:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791756030; cv=none; b=GriIbPBLZiU0ZzB476t+gIi3imW9gqu9yv7hQZnJOHhffaVwiZbGiJYHvH+TpMexBqq4lBFc0Ih3cQLlxgUpdlPD1eVtWHVhZ68JUyPwHN4WhM0Y+R8mScmlF8JUN74csSydYQB4vtvQg2fGYOBB0Bm1M2XowM5Vo0hBN2GrxQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791756030; c=relaxed/simple;
	bh=279YLB9yTa/sM8/WQYbnx8GXNV7Z6RB187SgWM0xauM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/Q5VHnfzf26KHCfdoVO2Bplu0hjZ9JD8KMenffMc/4om76n9en0KQOeGwP0odlzXAoG0g84WRwBH4EaP8RAQ8ASFdK6wj2GZNkFLESRXi6zB69HkIAY3Vqva6pduLz+hQPaqonq0wRLrwjiLs39IYDp2Wln+o+YALtt0X5W1l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JggmNQm5; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JggmNQm5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791756023;
	bh=qXTguC4FrN5AR5rNSXAFsgyeCYh+9+GI0SJacSdF0LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JggmNQm5Y/pyYY+685ysZ645EZ4qplhARijuZ1IhRe7rFTLlrGq+WwyBwHBADE3cH
	 rOfLcXlI2txEuQX4npobrNx/R40F10kdSn29CkaFv5MZtFZU5HICecGhlygcTru/ry
	 4IIZ1VWyRJ+jDxjJ4/rKHUsd/9d55TJ2wbbiqioZP5Kk5Zev7hwl3p1D9Df3u2FHOn
	 68sQbmMbTw05Ksi4CEW8RSPhSLNMm3ZoAQ30qJmcknd45AOyp8+sN4CJWTq9aZNnWN
	 Jl0yyYu+F9+7jjE26+jzPtSBMymTaJCK8C25ckJ8nuJBNXCTKcT+5kBDjbM5SQd5m0
	 HAUIW6KdSUVsQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 089FB6008B;
	Mon, 12 Oct 2026 00:00:22 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 14/15] netfilter: nft_exthdr: remove redundant op parsing in tcp_set_init
Date: Sun, 11 Oct 2026 23:59:52 +0200
Message-ID: <20261011215953.1334630-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261011215953.1334630-1-pablo@netfilter.org>
References: <20261011215953.1334630-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

The nft_exthdr_tcp_set_init() function is exclusively used for TCP
options. Therefore, parsing the NFTA_EXTHDR_OP attribute from user
space is redundant, as the operation type must always be
NFT_EXTHDR_OP_TCPOPT.

Remove the unnecessary netlink attribute parsing and hardcode priv->op
to NFT_EXTHDR_OP_TCPOPT, which simplifies the code and reduces the
object size.

./scripts/bloat-o-meter exthdr_before.o exthdr_after.o
add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-54 (-54)
Function                                     old     new   delta
nft_exthdr_tcp_set_init                      412     358     -54
Total: Before=6581, After=6527, chg -0.82%

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_exthdr.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 8abf8e8145ce..3492426dccf7 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -551,7 +551,7 @@ static int nft_exthdr_tcp_set_init(const struct nft_ctx *ctx,
 				   const struct nlattr * const tb[])
 {
 	struct nft_exthdr *priv = nft_expr_priv(expr);
-	u32 offset, len, flags = 0, op = NFT_EXTHDR_OP_IPV6;
+	u32 offset, len, flags = 0;
 	int err;
 
 	if (!tb[NFTA_EXTHDR_SREG] ||
@@ -581,15 +581,11 @@ static int nft_exthdr_tcp_set_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
-	err = nft_parse_u32_check(tb[NFTA_EXTHDR_OP], U8_MAX, &op);
-	if (err < 0)
-		return err;
-
 	priv->type   = nla_get_u8(tb[NFTA_EXTHDR_TYPE]);
 	priv->offset = offset;
 	priv->len    = len;
 	priv->flags  = flags;
-	priv->op     = op;
+	priv->op     = NFT_EXTHDR_OP_TCPOPT;
 
 	return nft_parse_register_load(ctx, tb[NFTA_EXTHDR_SREG], &priv->sreg,
 				       priv->len);
-- 
2.47.3

