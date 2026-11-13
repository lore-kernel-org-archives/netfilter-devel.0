Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539581;
	b=CXWp/CUvWkWSSvxVGOzehKB8d5lKnNX+oOPQ8tFRmgJn3P49eXitPUAdkRHtcE1Y6JFe
	 akcEexXD9olIuSicbzJIORgiutGDGc9fzcvZGnYGKV7ypXVnoNXRn5RU46KQ5Rr9iM6wS
	 OlQHiGaW+pD/ZkaWvrc3nnwv2RwWUELga5Y+Lm1XBQMdv5kesv9EhlC5J9DJEUaUHcqd7
	 cKgIPJiEjgtbj5D28vMP8RNQ1HguvAz1/45CqtcERH+TujHQE/IHeFokAW6B3ZLyYJuPf
	 q7U42P3MUet/AXmgmXq2opcrSB3grxDzJcDAM8IlggZdS0ZORTOr8F1sxRW7l+AvzQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539581;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=VwXdHxOfjvzzynD1vM7dDHln5nJMoyIHrViPYcVmOAE=;
	b=Dn+2nrFDQKrtiNq9ga8VPS9XghL+cNwxNtGPRO1/jQaUPo8EW4mwabVL67lhil8V3IoH
	 dnToTLcEwnVjbp+Ucf9g3QbVvZzjztcW3jgm2fZhJKjvO1Y8KizVtnGLOP4wRsVI9alNd
	 QI9u+h5mZ+vrLvJZKAdalNRAyGlecwMJ6hmaHhdHoNc5OVDMJ+f2Sdhqnx7FAtEHB7ZHf
	 RVSTZf0rrmnbsKqsZKM299Dmy9NZHdg+KcnOIPwha60wHdE9wooIVNApZnPtApfuIQ2Ak
	 GLUxrpesQHjjrXG9WI2O8/jKtwLojQUv14YM6GWeb2jOEaa6TNOkpO7+ZYPHab7afng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=DIovl3Sk;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5162606A883;
	Fri, 13 Nov 2026 03:13:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5162606A883
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=DIovl3Sk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794539579;
	bh=VwXdHxOfjvzzynD1vM7dDHln5nJMoyIHrViPYcVmOAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DIovl3Sk1UzsB3L2t+V0y09VzZ7e5fvtQYZjyyQwaLVjSXqKopwZRIFk9F8GhuLPy
	 +KGmHhD0Q5q8eqPQwQKyp/h75GHQKBno8JPMbTYWQGgfV9Qclzu2cE6W2aSRPZ8+x4
	 eZaIH8QAU6JpuvdSvzIkUyP2ZN3NNv1npeXihlpvkA1RvPspuZl1AUnGZVFD5qb1bl
	 4ZlYUeMZNNN6tENbr517fda19aW7g25FZfEm4hW0KUG9APtFbwq5je99ZSlAzZLisg
	 PL4AQ6X7Xm4jB6elm8YRjRAWjSMiSCzzSTTZB4k+oCuPtDyM+wvHZqaFwGKTGoZj+B
	 T9IBaGefG35qQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9486E602A6;
	Fri, 13 Nov 2026 04:12:58 +0100 (CET)
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
Subject: [PATCH net-next 02/15] netfilter: flowtable: fix pmtu discovery in nf_flow_tunnel_ip6ip6_push()
Date: Fri, 13 Nov 2026 04:12:38 +0100
Message-ID: <20261113031251.2437074-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113031251.2437074-1-pablo@netfilter.org>
References: <20261113031251.2437074-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

nf_flow_tunnel_ip6ip6_push() invokes skb_scrub_packet() before updating
the PMTU. skb_scrub_packet() drops the skb dst, so
skb_dst_update_pmtu_no_confirm() finds no dst and the PMTU update is
silently lost.

Move the PMTU update before skb_scrub_packet() so the inner route is
updated with the MTU advertised by the tunnel dst, as done in
ip6_tnl_xmit().

Fixes: 93cf357fa797 ("netfilter: flowtable: Add IP6IP6 tx sw acceleration")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 19cafae748ab..644e70fd6773 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -699,10 +699,10 @@ static int nf_flow_tunnel_ip6_push(struct net *net, struct sk_buff *skb,
 	if (err)
 		return err;
 
-	skb_scrub_packet(skb, true);
 	mtu = dst_mtu(dst) - sizeof(*ip6h);
 	mtu = max(mtu, IPV6_MIN_MTU);
 	skb_dst_update_pmtu_no_confirm(skb, mtu);
+	skb_scrub_packet(skb, true);
 
 	skb_push(skb, sizeof(*ip6h));
 	skb_reset_network_header(skb);
-- 
2.47.3

