Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FB9C1CDFA7;
	Fri, 15 Nov 2024 13:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731677545; cv=none; b=N+5bUDrBUZwO9rE8kyKshZfCue8nRlYAKd0OZrZ6hToVU4pxedTisEZZDBIdkSv6OxCEY/LDTjWuBbHBEkw+1uWdMKcS6x5u9mQ4lbOr+MdXALRCJppsMu44MwyE3top4VM3Pt1qmir2nugMTr7jMN3FswGvV8zUiac4T631+GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731677545; c=relaxed/simple;
	bh=7uBqf67SeioPJz1VvKa6qO8Sl4V/NzjQnnj2ZTT+p0s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fdBbStcOYaEDs/ytB/Ejd49l0bDDjjPJtMkNWwBNoyjSkv6VMpDBOxidyuLRBJs7ICfqGqgQlIB2SBuhiCk0mlPT9vgqrPGME7CvtfKxioXTptZX9KcR5YmquPgayjqE/4z2nESEwU60v2tLmii5GHMyDWujwr+BYVvQ9cOfJ28=
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
Subject: [PATCH net-next 11/14] netfilter: nft_fib: Convert nft_fib4_eval() to dscp_t.
Date: Fri, 15 Nov 2024 14:32:04 +0100
Message-Id: <20241115133207.8907-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241115133207.8907-1-pablo@netfilter.org>
References: <20241115133207.8907-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guillaume Nault <gnault@redhat.com>

Use ip4h_dscp() instead of reading iph->tos directly.

ip4h_dscp() returns a dscp_t value which is temporarily converted back
to __u8 with inet_dscp_to_dsfield(). When converting ->flowi4_tos to
dscp_t in the future, we'll only have to remove that
inet_dscp_to_dsfield() call.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nft_fib_ipv4.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 09fff5d424ef..625adbc42037 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -11,6 +11,7 @@
 #include <net/netfilter/nft_fib.h>
 
 #include <net/inet_dscp.h>
+#include <net/ip.h>
 #include <net/ip_fib.h>
 #include <net/route.h>
 
@@ -107,7 +108,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	if (priv->flags & NFTA_FIB_F_MARK)
 		fl4.flowi4_mark = pkt->skb->mark;
 
-	fl4.flowi4_tos = iph->tos & INET_DSCP_MASK;
+	fl4.flowi4_tos = inet_dscp_to_dsfield(ip4h_dscp(iph));
 
 	if (priv->flags & NFTA_FIB_F_DADDR) {
 		fl4.daddr = iph->daddr;
-- 
2.30.2

