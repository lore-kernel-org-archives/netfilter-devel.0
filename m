Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BA1B1862A;
	Thu, 23 May 2024 16:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716481230; cv=none; b=HogdeWRIBDGcLWbmc5OTA1bebjcgtCk6smd6zQVtdAv3kga8E5O1Yc+Pyd8ZQ89/mIoTu5usugeiS/s32go2zeUvyWQhJGGoRraq4+Aej3Qjc5vSK5da1dXJFGjKhof7n9mX6QC0/9LmwTmtcbYT7FLsKP5wcGKrlcN1tLcoI7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716481230; c=relaxed/simple;
	bh=DTgRKfxj+1zRBu9Atn+nXDKC7uNhiPYbOhZk7jZJh/M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DATnIJpUjuJndue+WilboAFZPSz1jrmJqon8GpZc2FsxZKSqSkKKIVxr3raZ31+2q07WQbEl/JBzkGaMApGw9QuSQl2QCniJyAyQWxTPPVJiUKjQ2mrgtzXzkctrsTTXr75D/47gDKzBtYKAvyyLDro6cq3kVWCFbGD06rO0vlk=
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
Date: Thu, 23 May 2024 18:20:19 +0200
Message-Id: <20240523162019.5035-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240523162019.5035-1-pablo@netfilter.org>
References: <20240523162019.5035-1-pablo@netfilter.org>
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

