Received: from mx.swemel.ru (mx.swemel.ru [95.143.211.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB8838DD1;
	Mon,  2 Jun 2025 12:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.143.211.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748868466; cv=none; b=SIbV+O6pMdKQjmuWlll6rQx2LrWK3POYfFCzrZ+Y/NgCLu06+bbZcNxmW+SR7cRiq/5hrGxejKFcvwEx1ehaRpt7t1edz6ra6qPWD9QG8dyPCO00Rs1wXjfvyZLBV2kLu04M0cUpWVY71XMkiU8tEscz3j5/s30rFRcxy6HMnaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748868466; c=relaxed/simple;
	bh=FJkS0QakWU0n6b1qNi8YVrI4yg158AxwuU8g1LMNaos=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hi16V2fhfKvPA1hvx3A01dGwrv5dY1y2KxKCqQM6zwmbIvJUppP27RAYxlrtgpCSGab3iWshuA6p5d/FGvnFaMj92MuJnA3g/sQcctEeT/sXijLCfoCtnA2jqATY47C8r62lrWE6GJPDh+rQCVf83xF49FS1aU0BGEMVoN1fwPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=swemel.ru; spf=pass smtp.mailfrom=swemel.ru; dkim=pass (1024-bit key) header.d=swemel.ru header.i=@swemel.ru header.b=IdN/EfPC; arc=none smtp.client-ip=95.143.211.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=swemel.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=swemel.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=swemel.ru header.i=@swemel.ru header.b="IdN/EfPC"
From: Denis Arefev <arefev@swemel.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=swemel.ru; s=mail;
	t=1748867988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=G4+VCuBXlY5f39h1spysLYf7MRhFe7y4qDoXMnXq/a4=;
	b=IdN/EfPCMarjWDnEMXf0bJPqxwCiB6yyV+w7CV6x7Rk5PaNMxdSbZaCCx9ShJgJaT+Oy9N
	z6KYriMcnW2HBBEiUtA5B0O6kennx6gxzDYMgn1lJxjCBe38DlODCGDJRqcp4UTqlnavhz
	bA6fG6jk3GTlrOrdaJ1dWZKeMM6pHSw=
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Fernando Fernandez Mancera <ffmancera@riseup.net>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH 5.10] netfilter: nft_socket: fix sk refcount leaks
Date: Mon,  2 Jun 2025 15:39:47 +0300
Message-ID: <20250602123948.40610-1-arefev@swemel.ru>
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
[Denis: minor fix to resolve merge conflict.]  
Signed-off-by: Denis Arefev <arefev@swemel.ru> 
---
Backport fix for CVE-2024-46855
Link: https://nvd.nist.gov/vuln/detail/CVE-2024-46855
---
 net/netfilter/nft_socket.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 826e5f8c78f3..07e73e50b713 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -88,13 +88,13 @@ static void nft_socket_eval(const struct nft_expr *expr,
 			*dest = sk->sk_mark;
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
@@ -103,6 +103,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
 		regs->verdict.code = NFT_BREAK;
 	}
 
+out_put_sk:
 	if (sk != skb->sk)
 		sock_gen_put(sk);
 }
-- 
2.43.0

