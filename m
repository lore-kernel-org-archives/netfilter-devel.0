Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A28282F3A;
	Fri, 10 Jul 2026 14:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783694295; cv=none; b=DdGS7xc9+HcKxaVIat3I4Ms5JndyJq/I315TxacUPX2thaxt8MRkqBSMnp0YhwmJ40rEA0tSZdK/paaEuA3+EIu64fEMbAMSUhM8qVZ/GSlXQuhwIP13XZElL4wc1sTCOqyPv9l8xP/ritP/yCTPetJW9j9rQaDe2VsHDB9GmEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783694295; c=relaxed/simple;
	bh=FVjJ2/1IzScJtzqSslW98q616QWGHhVpDxG++NtETaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tg9isIitZAtMeusERvC09WNEclspMElQUBUXivQfKgbyKNzH+l2uKJ2UJl5dKr+ue9+VD6XpgGLHlsHj9CB7qPmoIY2pD9c6afR4sJiRcZfSqsVVeQXGVnRw2gPl+OCL/A7dVfLLKXDD0wLRrJc5F1z3lqNd1aeqxClOO353Jgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B2D17605E7; Fri, 10 Jul 2026 16:38:12 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 7/9] ipvs: reload ip header after head reallocation
Date: Fri, 10 Jul 2026 16:37:31 +0200
Message-ID: <20260710143733.29741-8-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710143733.29741-1-fw@strlen.de>
References: <20260710143733.29741-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__ip_vs_get_out_rt() calls skb_ensure_writable() which may
reallocate skb->head.

Fixes: 8d8e20e2d7bb ("ipvs: Decrement ttl")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-sonnet-4-6
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipvs/ip_vs_xmit.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index ce542ed4b013..9fef4335da13 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -736,13 +736,11 @@ int
 ip_vs_bypass_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 		  struct ip_vs_protocol *pp, struct ip_vs_iphdr *ipvsh)
 {
-	struct iphdr  *iph = ip_hdr(skb);
-
-	if (__ip_vs_get_out_rt(cp->ipvs, cp->af, skb, NULL, iph->daddr,
+	if (__ip_vs_get_out_rt(cp->ipvs, cp->af, skb, NULL, ip_hdr(skb)->daddr,
 			       IP_VS_RT_MODE_NON_LOCAL, NULL, ipvsh) < 0)
 		goto tx_error;
 
-	ip_send_check(iph);
+	ip_send_check(ip_hdr(skb));
 
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->ignore_df = 1;
-- 
2.54.0

