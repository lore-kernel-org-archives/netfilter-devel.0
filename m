Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBE847884B;
	Thu, 27 Aug 2026 14:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787840282; cv=none; b=g9XAeZgbO3D/6SzOQzcaBGlNergqouJynQug8hUvPU71ED/lHrGA1b3zb8zC3lcU/iHSObp9oeQvsQzt0VUDYgRP6gqHwXzD29bAeftWwVWixmNLZ/EICTjkZp7ki3ZpotnNprobQkXlxmwh0mzmHb51xP8PsqlWKWM/oiRAisE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787840282; c=relaxed/simple;
	bh=Q92MqPIjbXh9+Tv9WNldsQVA02XYb6z0BZCylGVvj8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcBFUnWsQIfjOnP0tvKEK0GgEVtipntk2KVKfrZAobUuH4E5WRiguL6NvUl0nSibq/tUZgGAtszwMN6uN9o5CscmxnLNfYcmmbEi4FybMyM6EpBSUgxKihWxeDH9ewABus3ewoSt+kZ7gYz6UJnkQefCpVJMZYzNB1lSDkvnYR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IcbjFthw; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IcbjFthw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787840272;
	bh=dRBITt3dNh4CoqmJmPa/KBTl8hhlzcue/mVH9vYymSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IcbjFthwPwyb1CLPJ4uaj7DBS+BMFK3kSggLie/bq4ejDR3s7nU9Mdu9inIWVxM8L
	 AMJQIEtpkTOfIcqW5Nagg3rzFNkJjMXv5uq6+noKplfQDowJonB2jmdjFHC+kkTIW7
	 xVj79/ISdwKs6FdoUWsH4i/FdCnnU1+NBQwSm8E7QTqVOaIX7dVVoMbppAATUMknyZ
	 jt83BpdU/OPph32WkmTYM/F9xtYPC1pstQaM5m0yLSWdf9KFKWnGCfOcsOIuhC14VA
	 1FuMEg1/Z7ICW6ba5JCxQdgaKfFrhiQClk7a8VKfYLxV/NXZdXNGAGQ5nFfhr0A1VR
	 kP8W+NDI1PUwQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7DFCC6005B;
	Thu, 27 Aug 2026 16:17:51 +0200 (CEST)
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
Subject: [PATCH net 9/9] netfilter: nf_tables: remove leftover set_update_list
Date: Thu, 27 Aug 2026 16:17:33 +0200
Message-ID: <20260827141733.423453-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260827141733.423453-1-pablo@netfilter.org>
References: <20260827141733.423453-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This list has been moved to per-netns, remove onstack list which is not
used anymore.

Fixes: b343ededb3f9 ("netfilter: nf_tables: move set_update_list to nftables per-netns")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9b776f402d14..765a92fa90d6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11295,7 +11295,6 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_trans *trans, *next;
-	LIST_HEAD(set_update_list);
 	struct nft_trans_elem *te;
 	struct nft_ctx ctx = {
 		.net = net,
-- 
2.47.3

