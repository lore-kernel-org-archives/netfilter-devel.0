Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539593;
	b=HRf3zHUDMBFlaJvv6sqynlovJzsC98b66EHwjlUC3XnK724cbwfS+DvvWmp65UOhzDHc
	 TolEHq/u6q97pGtKXvwS2Rg2mklY4ebX7EpKpkJiHWKLJszJgElpBACsb2mbq1O/MNBEj
	 2gGCb00i14xIINLBaTpyvX+O5VcztXh2IywSaJNcD+G3u4EN9hBCkbmQj8aKKOTerCfdb
	 Y6qLosovZ3wwlsEO58Azxs6gT8jxxRHQ/lp3vp63KmGyqkholAKDfOxE+MTygN0mVI+L7
	 mWTbZ75gAIVZW61xBfTKHvKYyTtcqcrHSW5b3kHzigZA1d8rUCDtagrDbbaAJ4yy6DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539593;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=9cFznuUQg3/J/kwaHnNpIAUWitOUD5BkKb79yKsxlE8=;
	b=FYsJvrx7GUMi8OAOKwQPV1ht6WtmlFkWunj4R8rFL+jEYZKqpwJRvjvo1+gvGq6Q9fdf
	 ZuUvWRwCrJuZX9P57eUWILUgy4IOayLoPBylM+E0K0jpVsW5VTen1YKDFLGj2pUvmhd4Y
	 6yc7DsVIEn3Pb7+1SBP3GjuB58Sg8HuFSFfonSfs/y3ezjIA61pgeUYOUDEqK3WRXO+V0
	 AOZuS0J04cxsHwjJ1qQ67DuRc92XqaaoYvyAfikTTi4vfRFqK/rJzruFW3Qsj9KW39wQP
	 ylWA2phJAgw8mznFHTLVtnROXmxAByrmzAREpAfXJw3uaClwJjVtzylJBhkf4shxncA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=kRkKZmp5;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B96260A262B;
	Fri, 13 Nov 2026 03:13:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B96260A262B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=kRkKZmp5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794539591;
	bh=9cFznuUQg3/J/kwaHnNpIAUWitOUD5BkKb79yKsxlE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kRkKZmp5rCW7sMugK8xDKWOIMRx4f/uKSfxAOJrAo52i75/ja2Z0X/a7pJ5YEkt5y
	 +/UHOKZi36WrvxyOHv4jRD7HvA3MDljQEzqqx9pPIioo0bdeTfkt0pR/6kmNNVXO2C
	 pc82J4NbWJUvM+AdWhyGBiqvwuOGRI3BmcaQyEQ/45/d8Kn+KlMhRHRvxOWmH3cda7
	 np0V67eGLSlQIU6v3zaMMv+ATkwyQPqhigTcvP0g+vb81XeVxcuj6TzXvq7iojNjtF
	 TpVn4AEsEI6eYMcKo0Ds+j9Bmo2rdNgP/6PA5m5W79pXHPFkPjwC2ArJoBYWCeJQO5
	 Y7nfQpcTNcx4Q==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9678F602A6;
	Fri, 13 Nov 2026 04:13:10 +0100 (CET)
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
Subject: [PATCH net-next 11/15] netfilter: flowtable: do not scrub as crossing netns
Date: Fri, 13 Nov 2026 04:12:47 +0100
Message-ID: <20261113031251.2437074-12-pablo@netfilter.org>
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

IPIP tunneling support does not result in crossing a netns, therefore,
adopt the more conservative variant of skb_scrub_packet() by specifying
!xnet, keep the existing skb mark in place.

Fixes: d30301ba4b07 ("netfilter: flowtable: Add IPIP tx sw acceleration")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 644e70fd6773..001abfae5a1f 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -630,7 +630,7 @@ static int nf_flow_tunnel_ip_push(struct net *net, struct sk_buff *skb,
 	if (err)
 		return err;
 
-	skb_scrub_packet(skb, true);
+	skb_scrub_packet(skb, false);
 	skb_clear_hash_if_not_l4(skb);
 
 	/* Push down and install the IP header. */
@@ -702,7 +702,7 @@ static int nf_flow_tunnel_ip6_push(struct net *net, struct sk_buff *skb,
 	mtu = dst_mtu(dst) - sizeof(*ip6h);
 	mtu = max(mtu, IPV6_MIN_MTU);
 	skb_dst_update_pmtu_no_confirm(skb, mtu);
-	skb_scrub_packet(skb, true);
+	skb_scrub_packet(skb, false);
 
 	skb_push(skb, sizeof(*ip6h));
 	skb_reset_network_header(skb);
-- 
2.47.3

