Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9683859F9;
	Fri, 19 Jun 2026 11:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781870117; cv=none; b=nIBViop//2o5w7/hpb2PNC1T6tvbUV8bp1+CQK9FUzvtUpzss/P4B7s2e1P6T10fkn1pG2GVqgYrHdjG2wHX0G2ImzGUWAYdQI32cJgVj8KcM7fX0+uWYNRVl3uMWH0ugOvHqTXRZw6usTSq+z41+e/7P+oxgY5zBBAQC9sKFaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781870117; c=relaxed/simple;
	bh=k0+DmN2Twec3o4nbr0azlmPkFevxgpDWbOC8tWda470=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sLpQz3U9lrWTr7N67e/xV521PZeXU+R5Q0Ak7OOueMxtZG05UgmICxwh3Wm8ZPWhzeSNZ3DtrwEfnLbv/3pZq9r+CWvEOqRkj0uVECezIVNjh4Ulbeo/zfEg2lqYtaixpjQmhZV+YhG/sQRPmeDDNj1ji/egT3ob7TbCJhSxon0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lbj6Fx4O; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lbj6Fx4O"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DE13D60196;
	Fri, 19 Jun 2026 13:55:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781870114;
	bh=bz8ud+BrLrB1cv+fCtki3n0k7zcth4plrPUSLRFy9Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lbj6Fx4OOGsvBlTeDuXByp82D6eD7FmecqvS9I/4lEncBRRdd9nnTB0vHUDtMbyWc
	 Q9qZGw8ICSz5hC50Rfjk6VIZ1h+NH2QaO4hYF3OaxAX844nbsUOmpIqd9YMgjJifm0
	 c80Y31DmTqFtrVzq3q9cmwCflpEx7G4jfdgdOdl1kYm2jk2zp2A8V8ugg5fOlIUDpy
	 nlR799YlH+3wEINvL+SNH/RQCttneKXqvAvs84UO3JovO5DprIzBl8PxS8R2KqtCkn
	 PsoolHxC6oVb/NP+UA/GgHYKJtAukNtpQoxxt11Eqel9R+s6ShSRg5bEhwG8sa3YNQ
	 eRXQynR/uDBkg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 13/16] netfilter: nf_reject: skip iphdr options when looking for icmp header
Date: Fri, 19 Jun 2026 13:54:48 +0200
Message-ID: <20260619115452.93949-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619115452.93949-1-pablo@netfilter.org>
References: <20260619115452.93949-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Not a big deal but this hould have used the real ip header length and not the
base header size.  As-is, if there are options then
nf_skb_is_icmp_unreach() result will be random.

Fixes: db99b2f2b3e2 ("netfilter: nf_reject: don't reply to icmp error messages")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index fecf6621f679..4626dc46808f 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -89,7 +89,7 @@ static bool nf_skb_is_icmp_unreach(const struct sk_buff *skb)
 	if (iph->protocol != IPPROTO_ICMP)
 		return false;
 
-	thoff = skb_network_offset(skb) + sizeof(*iph);
+	thoff = skb_network_offset(skb) + ip_hdrlen(skb);
 
 	tp = skb_header_pointer(skb,
 				thoff + offsetof(struct icmphdr, type),
-- 
2.47.3

