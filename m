Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10B9291863;
	Fri, 23 May 2025 13:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748006866; cv=none; b=iyzbxzE6MPZ5348rBttB9GfFdSXVcsV6S99rS1z8ihPQRMbe9xPTdMl3Y6TkVURugu5OfuGWhnaJWeiLChDcgm049WMody+P8rgbRXLb3+x7xoxST59pGzMEMVcJ5ziEIKL3Wmu4yMToFs/baSCBYYJpqouNjftMfGjxYd37PZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748006866; c=relaxed/simple;
	bh=OZVt19+GDnKFoxUykjSkh5UJFFPRYsWRcwwFy4AA3iw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KOQMir+KNbvI5b/OoLMq8xY4uavABKX+rTVMbu6aszK+GtwTqmFpoYbKqMc/YXvZUlZI0jYdhICnJtfkgyBzvxUy0zVbRRCeCx9Nbnovclzyid7fv0wRX2W6+owtaSIhkISqg2qsG/w1fyLy90I4vgd2GZ2pPMl2g6/kbxd4mdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=p0Qo+Uzv; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RI3kSd3i; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="p0Qo+Uzv";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RI3kSd3i"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 7B41960783; Fri, 23 May 2025 15:27:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006863;
	bh=vlEYGqW/LZ5w+PrTbmxs1+ViNcKPPojF+yahjfEFJnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p0Qo+Uzvnbp1DKs6YMIMl03iR1yg86KMcsGSthVT5yO03VnHoBeMAXO5eXGbYKfSv
	 Kl+FfsJKE0iz4S0Hd0Q8WKv95qJAYYyQApmaSmL/LfQhgIqNwRXFWa0WpprTIL5qwp
	 IzDabQ8gg2ldMQANzpxA6bupU6Ae/indNqgaate6BKxsId+X8VJh+32O/VJGXqLKGf
	 BvOXIEggufm9Ai+2B7gYmlNsQM9k2WmkUU2YbmCA8wtGgWGT1iO7FM3vs7IM9NbrAj
	 XxgIyx7GrvMWRkIiYnsIDivmXg9XBYIb0Mb26PQxMtjXA1i2dlbjM3NqlZedcMk0s6
	 gIatB1IMGDq8A==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 348EE60773;
	Fri, 23 May 2025 15:27:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006845;
	bh=vlEYGqW/LZ5w+PrTbmxs1+ViNcKPPojF+yahjfEFJnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RI3kSd3ip9BnOb8NdaPY16ofEPRZHoscgB4BnfYpO7cyV4LdZ6nD6SC/FvBgWDWMi
	 d7MTBRsKKFQxFipgEfPr9UkUXaZbSGW+29I6WqDIgC7HPkDDmZuUvNzZJpPBvesAtw
	 2dGwII+eDu8S7ZslwjgQveWtedmhoFhZRsk4aVfnbtKuHshk1JvrQPrVwwPNm4KRxX
	 wyjZVRvu778V3ctctL9oNGlyO74rDJ5G/tmoF8A0pZOoxL5TqHydDKtj0FZ33DqUeH
	 yQPmu+LzWp8HKTxuF6gQrn4KtaI4Ujsm2oSuMwAC11eumA5urTWlpQ6qNGczQYGrOp
	 W9WdyqDyaaLtw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 08/26] netfilter: nft_tunnel: fix geneve_opt dump
Date: Fri, 23 May 2025 15:26:54 +0200
Message-Id: <20250523132712.458507-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250523132712.458507-1-pablo@netfilter.org>
References: <20250523132712.458507-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

When dumping a nft_tunnel with more than one geneve_opt configured the
netlink attribute hierarchy should be as follow:

 NFTA_TUNNEL_KEY_OPTS
 |
 |--NFTA_TUNNEL_KEY_OPTS_GENEVE
 |  |
 |  |--NFTA_TUNNEL_KEY_GENEVE_CLASS
 |  |--NFTA_TUNNEL_KEY_GENEVE_TYPE
 |  |--NFTA_TUNNEL_KEY_GENEVE_DATA
 |
 |--NFTA_TUNNEL_KEY_OPTS_GENEVE
 |  |
 |  |--NFTA_TUNNEL_KEY_GENEVE_CLASS
 |  |--NFTA_TUNNEL_KEY_GENEVE_TYPE
 |  |--NFTA_TUNNEL_KEY_GENEVE_DATA
 |
 |--NFTA_TUNNEL_KEY_OPTS_GENEVE
 ...

Otherwise, userspace tools won't be able to fetch the geneve options
configured correctly.

Fixes: 925d844696d9 ("netfilter: nft_tunnel: add support for geneve opts")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_tunnel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 0c63d1367cf7..a12486ae089d 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -621,10 +621,10 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 		struct geneve_opt *opt;
 		int offset = 0;
 
-		inner = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS_GENEVE);
-		if (!inner)
-			goto failure;
 		while (opts->len > offset) {
+			inner = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS_GENEVE);
+			if (!inner)
+				goto failure;
 			opt = (struct geneve_opt *)(opts->u.data + offset);
 			if (nla_put_be16(skb, NFTA_TUNNEL_KEY_GENEVE_CLASS,
 					 opt->opt_class) ||
@@ -634,8 +634,8 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 				    opt->length * 4, opt->opt_data))
 				goto inner_failure;
 			offset += sizeof(*opt) + opt->length * 4;
+			nla_nest_end(skb, inner);
 		}
-		nla_nest_end(skb, inner);
 	}
 	nla_nest_end(skb, nest);
 	return 0;
-- 
2.30.2

