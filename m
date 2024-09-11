Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFBFB1B29BA;
	Wed, 11 Sep 2024 22:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726093534; cv=none; b=B3dmMDjgj6LCRS1kg317SboM/PcOKuoo4Z/5fPlxaxOCwgshH8WZL/bom7xRiqqVW7BjTGJUO1YMo8yjjlH0GfhJLgKiA4qP36PtT4jj6+Duulu1b8hby8OYLk4cpX+Sa5W2RkLncQwAc3BUNSIV04HarxyAp6PNeB6jKC776Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726093534; c=relaxed/simple;
	bh=x8YG39c46kJmXfXVJT7hZ54SF/qD7hvSrmd+H9Ft/ok=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MWEoNrzfCCVgwT9ugduUcy0/2lY6C1DzZhJb5unVXnbe9Xj54HsFcVBI8VwZF3CUYC8t7PP4uR6YcdMEWiGdFrLjaNhKnnW2MwM7pj0m5QPFPDaASwQQ7SC1Cz4xN/IYN3xkorcpNN5Ex5QA0iFCAI3RegKysQCR32i/2+jhcm0=
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
Subject: [PATCH net 1/2] netfilter: nft_socket: fix sk refcount leaks
Date: Thu, 12 Sep 2024 00:25:19 +0200
Message-Id: <20240911222520.3606-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240911222520.3606-1-pablo@netfilter.org>
References: <20240911222520.3606-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

We must put 'sk' reference before returning.

Fixes: 039b1f4f24ec ("netfilter: nft_socket: fix erroneous socket assignment")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_socket.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index f30163e2ca62..765ffd6e06bc 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -110,13 +110,13 @@ static void nft_socket_eval(const struct nft_expr *expr,
 			*dest = READ_ONCE(sk->sk_mark);
 		} else {
 			regs->verdict.code = NFT_BREAK;
-			return;
+			goto out_put_sk;
 		}
 		break;
 	case NFT_SOCKET_WILDCARD:
 		if (!sk_fullsock(sk)) {
 			regs->verdict.code = NFT_BREAK;
-			return;
+			goto out_put_sk;
 		}
 		nft_socket_wildcard(pkt, regs, sk, dest);
 		break;
@@ -124,7 +124,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
 	case NFT_SOCKET_CGROUPV2:
 		if (!nft_sock_get_eval_cgroupv2(dest, sk, pkt, priv->level)) {
 			regs->verdict.code = NFT_BREAK;
-			return;
+			goto out_put_sk;
 		}
 		break;
 #endif
@@ -133,6 +133,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
 		regs->verdict.code = NFT_BREAK;
 	}
 
+out_put_sk:
 	if (sk != skb->sk)
 		sock_gen_put(sk);
 }
-- 
2.30.2

