Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788221;
	b=1uYayulb7fUhZI0VH30hA39PvC/dnYTBpBRki0qWSaYpaNJeketePH7biiMYnp6wzp/U
	 sY4Dt7JmsmLyfkX2uN4shhxQasZfy2Vzo9q4HXBL6okiue4jMZKia17G4m7YqHI3rJNKo
	 AehltXCivzCBvj5Tmbjc2pTIe77Ka/Obe6DzLB2FKilbkUGzxGtNTluGFa3EiipQO6zwJ
	 MO6AlU1AGvaQyB18CwyQJ0mALzQDvynfDZK02hdN1Y94Wh/YfPJafX+nunugxNO7swMpV
	 5iaEb88DvCppPYJgGWjI0/Y86xvaCw1FCOzQ6RrYw7zgeRdRICKIZ0FYS0jevafcc7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788221;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=amZW8do7IJbbDjZDRAGpAZDrnkRmVJR2FN8Yptby7pI=;
	b=k7RD1q7CJdSTe63uwl1Mo7DmoJK/ajPGAQTeLdUIHOm11in/6Xo3LCLUn0/hKoGwC4Vl
	 pdKmkWtcxdXS2oz5fafnBgqFcDP9C0YAZ9BgY3Im5j8YLXQLekx9DCZ/TX1n01Y+Phi67
	 GUgstM/u7Xtv//jvoXD6hgvbnK4DeTvIjn2CB0ROqw/8PRzasRBiA7l/FpQAveuA1Bpl4
	 a4BforTLtaog8lgjBC5O9CHQYeBXStBGGxLjaoEQHbNWjcIPWJSG3ocSYqHxh3v4IwoCv
	 /MZXVYKHoFJU3XUC9vR+fW652OQzPLdpyFFBT/EAcGWZY1typ3hQSK8myhq6jZ2HLZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Z+gy6t4Y;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B781F606A337;
	Mon, 16 Nov 2026 00:17:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B781F606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Z+gy6t4Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794788219;
	bh=amZW8do7IJbbDjZDRAGpAZDrnkRmVJR2FN8Yptby7pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z+gy6t4YszIrHg66MxqQpgt/Hv1ZmR+rSU9wPIceP1/7Dq+8EnVvR9tSWtZLUZMwU
	 eeCzNC+/5xVuPsyBRvhgrdjT/aA+BBBeSVkUgr4rbRjvHuHroFD3bogxqjRcaYQ/Lx
	 9DN6/YvBXlDfg5qT8Yh8FMaeVXApHWEnDRGsH8mwgpxUeGip4cYlynSUVaD1pbyWR8
	 dNoXAE394CL6TwqjEFYbJKu3PcmQfNiFQ9g4CEK6nb0EnQt+jeA0VGUngtGvixolw7
	 fCfIydGGg9aBkF30sOZP9orRyage77NGjwYEYzDu1qzReqao38h3fVSp6zh6QjSp73
	 J8khKVFHsqVoA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8B9C16008B;
	Mon, 16 Nov 2026 01:16:58 +0100 (CET)
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
Subject: [PATCH net-next 09/13] netfilter: flowtable: do not scrub as crossing netns
Date: Mon, 16 Nov 2026 01:16:08 +0100
Message-ID: <20261116001612.2806263-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116001612.2806263-1-pablo@netfilter.org>
References: <20261116001612.2806263-1-pablo@netfilter.org>
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

IPIP tunneling support does not result in crossing a netns, therefore,
adopt the more conservative variant of skb_scrub_packet() by specifying
!xnet, keep the existing skb mark in place.

Fixes: d30301ba4b07 ("netfilter: flowtable: Add IPIP tx sw acceleration")
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 19cafae748ab..78bba416dd5b 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -630,7 +630,7 @@ static int nf_flow_tunnel_ip_push(struct net *net, struct sk_buff *skb,
 	if (err)
 		return err;
 
-	skb_scrub_packet(skb, true);
+	skb_scrub_packet(skb, false);
 	skb_clear_hash_if_not_l4(skb);
 
 	/* Push down and install the IP header. */
@@ -699,7 +699,7 @@ static int nf_flow_tunnel_ip6_push(struct net *net, struct sk_buff *skb,
 	if (err)
 		return err;
 
-	skb_scrub_packet(skb, true);
+	skb_scrub_packet(skb, false);
 	mtu = dst_mtu(dst) - sizeof(*ip6h);
 	mtu = max(mtu, IPV6_MIN_MTU);
 	skb_dst_update_pmtu_no_confirm(skb, mtu);
-- 
2.47.3

