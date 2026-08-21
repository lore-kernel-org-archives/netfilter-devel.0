Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51D1429036;
	Fri, 21 Aug 2026 15:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787326757; cv=none; b=WzAX81eXyN0aliGQ1faV2UOKy9HhW4UF4TAqWhC5ERtmAoUn0kl3g/a65vqHtr586DiMbbz3uoyPiangv1YbMWd+1Yb03/sCNyRdkdIdNfBjnFiTV97fBKKaUomXz3CggEjtC8q2l4uQ4UlOCOpECkBRffiOvhPDi7dtbcVQ84M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787326757; c=relaxed/simple;
	bh=O5lVVY2ez5DfMCjdf9U3tamW1CH3RjYbcUOqTdLZGdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlY+UDsPRnhn181JEPylJWmVL1+LGB7z1Go+h4XNcFN+Qk48m5ltEAUBCPyrwHWKzZJtNencZqGRbaJFo7ngU6GgAMyiHXtNuxn06Fayu0qMFBff2YJEzNWJZZd+g8ocd8gX7dbk5m+6gEWP5WCicSNahZKlJnWjqmLUq2B0cvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FDqlFE6M; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FDqlFE6M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787326753;
	bh=m2OAul4wYx+Ji4sRz9+RoTgI/CuKBjYXbyAEypRFiMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FDqlFE6MdHVMA9tDVkpHKs7iwAQvJ5VT8Vm2Ttfe5EmVZ/3n5iFIZxmfBkwSeo9kG
	 z9fhKfWARPOQHYfqVgHzREuA6qqk5LzY1CRe1N2B1YPYvGAMv/T3FzgS5EM/N26ESc
	 6S2/2TS7gQXSwrAo7x7U8v8XVZpNouGLoCZ34nNFJ7WO9ctvGtfXReLRhPfAucLLGH
	 6LYWNz6ryRdsq5PeMwgffB3gMPJsVbQiiFo70A8eQ0Pfcx3qLU2Qx23UdoVaZphW1B
	 oaA0c1y4YpQk97KQTdGTNQNELW/MB0YDUdThnjtHYhvavUim24S1DoiFnDAr1Jn1dt
	 oMYYJkcll+gIg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8D58C60097;
	Fri, 21 Aug 2026 17:39:12 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 10/10] netfilter: nf_tables: remove leftover set_update_list
Date: Fri, 21 Aug 2026 17:38:33 +0200
Message-ID: <20260821153833.245589-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821153833.245589-1-pablo@netfilter.org>
References: <20260821153833.245589-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This list has been moved to per-netns, remove onstack list which is not
used anymore.

Fixes: b343ededb3f9 netfilter: nf_tables: move set_update_list to nftables per-netns
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4f3be3b10f2f..5cee9e46cca4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11298,7 +11298,6 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_trans *trans, *next;
-	LIST_HEAD(set_update_list);
 	struct nft_trans_elem *te;
 	struct nft_ctx ctx = {
 		.net = net,
-- 
2.47.3

