Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0221DDC08;
	Wed,  4 Jun 2025 23:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749079711; cv=none; b=WOEyEM5TKhrT5MtPUjpJWcZE6d3VbnV/DS0jyvAOoTWjPb8kzBvAXjBaaAi1jbiJax5u7lTWJ9W1Ur05C9bu8tPLaEHR/h3FDjh1+bWn3ZPIDxd4VSG9i+6TNfKqcsaKJFp/oLyWpPWiFujaIKX+fmxvnBcj4Nnb2JavDS40Aag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749079711; c=relaxed/simple;
	bh=4S7KkOLOEEtlLZqNrnwPPOhzLH1u6v6bvAwPx0ifg2A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=elcCOT0auZONRcA2dxD1SyIrfhKCCtGoG/IUGPeJ9S1n8ZDdtqhC8UIDDKocdVZhlmhsS1g4gtX2CXWq/EXlvV0rxnxKvT9o7FqGQ7/ZYzRqyudjl/BCUEDFJByPbzxueFic/J7EMli4N/6zBkSTWYg0G8lpw7zh223ApOdRwsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=eBwr00EL; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=eBwr00EL; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="eBwr00EL";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="eBwr00EL"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E41996074D; Thu,  5 Jun 2025 01:28:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749079706;
	bh=/BI0tfwekrXF62MaM5csUzCe39xGW8JjAIzzeZlwYKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eBwr00ELPPAyxyoCGNcOFtLoCNAgNn1ToLQMWyg9mMyijzVcpLDW6p1tfVuASJg6A
	 bTKGNeHdsx/cwd7B7jJWw/BYXe23vVI70Tqtg/I1wTgPuIaxrPlP7H5mqJ59aR0KXd
	 rP67a03KhT8H4ver3HdxKmbS1JxR22kNl4k+G11o6wooG3RAzOCcmNfRqI2dzYMOFO
	 ktwv8lkYrPuyaQXlt81zqwEPGTgR/XZtkc/fF54HFJx4XLOhKUdQEjb1PqmLtONIt4
	 1i+DHZ+Pq+Gs5QcoY0IcN76VEEtDpS9uWYZBmp1x6hhbE/k6q3LbonAHy0465ggAVt
	 vkJ6A7AE99tOw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1D7D160744;
	Thu,  5 Jun 2025 01:28:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749079706;
	bh=/BI0tfwekrXF62MaM5csUzCe39xGW8JjAIzzeZlwYKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eBwr00ELPPAyxyoCGNcOFtLoCNAgNn1ToLQMWyg9mMyijzVcpLDW6p1tfVuASJg6A
	 bTKGNeHdsx/cwd7B7jJWw/BYXe23vVI70Tqtg/I1wTgPuIaxrPlP7H5mqJ59aR0KXd
	 rP67a03KhT8H4ver3HdxKmbS1JxR22kNl4k+G11o6wooG3RAzOCcmNfRqI2dzYMOFO
	 ktwv8lkYrPuyaQXlt81zqwEPGTgR/XZtkc/fF54HFJx4XLOhKUdQEjb1PqmLtONIt4
	 1i+DHZ+Pq+Gs5QcoY0IcN76VEEtDpS9uWYZBmp1x6hhbE/k6q3LbonAHy0465ggAVt
	 vkJ6A7AE99tOw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.4 1/1] netfilter: nft_socket: fix sk refcount leaks
Date: Thu,  5 Jun 2025 01:28:17 +0200
Message-Id: <20250604232817.46601-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250604232817.46601-1-pablo@netfilter.org>
References: <20250604232817.46601-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

commit 8b26ff7af8c32cb4148b3e147c52f9e4c695209c upstream.

We must put 'sk' reference before returning.

Fixes: 039b1f4f24ec ("netfilter: nft_socket: fix erroneous socket assignment")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_socket.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index c7b78e4ef459..46d11f943795 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -69,7 +69,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
 			*dest = sk->sk_mark;
 		} else {
 			regs->verdict.code = NFT_BREAK;
-			return;
+			goto out_put_sk;
 		}
 		break;
 	default:
@@ -77,6 +77,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
 		regs->verdict.code = NFT_BREAK;
 	}
 
+out_put_sk:
 	if (sk != skb->sk)
 		sock_gen_put(sk);
 }
-- 
2.30.2

