Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50242194A61
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Sep 2024 10:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725533905; cv=none; b=d8yZ9PnTW72I/rhFqizfthcbXDdT88H8V0ZogwCBWtJHJJIR8Crw7xRYhQUMRJ4oWYlMHU/+lCBQz0Dim2KYVhYlsatJc3x2+d1mYXpMkB6Vl8OTANwUeDaPeIJ+XM3/EMHwplhs+YT3COvl1EL7hn2PTrqryG2YliCA9p9d5ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725533905; c=relaxed/simple;
	bh=TaEm3I/BI1cVI96rvmOrB6dBmhhnej5s/5CMI16znxk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g5xAI8gIyU8yw/ko3+hsSkbNzf8YP9WUwUMRPFyz5n4WISIXOkVmgoGiWJ99gDCwQ76O1Y3rYueyDbLbaXnkOWGDqn72KpUyPRY6VgvIjlcqsX8MWpinygvbI0t1VLa5/TMn2oXygi3mRJf7nQAe0NL9gRsgS5cP2r7yBnOcIG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1smABw-0004tg-Te; Thu, 05 Sep 2024 12:58:20 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 1/2] netfilter: nft_socket: fix sk refcount leaks
Date: Thu,  5 Sep 2024 12:54:46 +0200
Message-ID: <20240905105451.28857-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We must put 'sk' reference before returning.

Fixes: 039b1f4f24ec ("netfilter: nft_socket: fix erroneous socket assignment")
Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.44.2

