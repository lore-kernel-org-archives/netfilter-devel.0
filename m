Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5D2351C1F;
	Sat, 20 Jun 2026 22:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781994485; cv=none; b=P3hthRsqGAsQtnauy82/Hk4ZDvJdAlrUQQUEe5QBS8UPvy8Va7EbrHQUqfduX15nUg0S+6bxVqnkNQ01CQ2cucYEqXxdo2BAF8uS6Yn5sTWeXcnMSWK8W0ZUTtFwVDw97Qz1pzHK+m6AOxkXR8W7s0B+kl7RvjXuUxlN1GauHVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781994485; c=relaxed/simple;
	bh=k0+DmN2Twec3o4nbr0azlmPkFevxgpDWbOC8tWda470=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjtnXcJVbFZwvwn95vrinXLu75TVtZske81ZYU4bNVxXok+BO7iXKHjs378xki5dYsFzUAZX3MlsJcXsPdp+ZDzLKw6lfEVveQo5w8PxE6qd6uqdnu+IxKXILf/X6PCqc3sq00ZjzOGsPa1ENSSzSpUaH+k8Jw4taOa18NxNWOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NNwXCp7x; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NNwXCp7x"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 037B16019B;
	Sun, 21 Jun 2026 00:27:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781994476;
	bh=bz8ud+BrLrB1cv+fCtki3n0k7zcth4plrPUSLRFy9Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NNwXCp7xPERuKXkgJP3p77iWJ/49tca/r1/nVR0EIm0+EZhKRrjHpBaCHJF+SLnOB
	 bCubu2cDmKBSNOY5MVDYE1KKp116UPJYA417DEvILHzdsIuN0wLhOpQF529YOaMiz+
	 v2Y/65xBlM1UQGTkeRBuUu1GcyH3HUXAAa/81Yr257YQMf5UtXR0tEkgOYI2GJwoBn
	 XuFcUI6frcP1pyK/JVj0PiDAsvv8g4GO11YwFORU92kYi+v/afG5mgS90EcGsLDCUX
	 77SRlVUZzhkPAu8mEbWu9J30WEXlAucnFewqS6BlVqSrf20ZbNfjAFXqI84/fYEH0f
	 tb7zB+/H7Mcdg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 12/14] netfilter: nf_reject: skip iphdr options when looking for icmp header
Date: Sun, 21 Jun 2026 00:27:36 +0200
Message-ID: <20260620222738.112506-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260620222738.112506-1-pablo@netfilter.org>
References: <20260620222738.112506-1-pablo@netfilter.org>
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

