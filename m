Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A93E8154C08;
	Tue, 11 Jun 2024 22:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718143413; cv=none; b=mL+yhuQ6onEwFh7VlDJH/FADlSyteWOA+7T/npn2qFQazx9CdHRjmrAG3zHHXsgkeJT94fsYmMjCi40P0+H+btG5/LGe/oFcEoxoTJALbQ5QwWf5AZxTYQoPs1akV04V8rZUrbIKi2QnMTL8vJeiNPeFy2bKWvvVfu2f2aoNhXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718143413; c=relaxed/simple;
	bh=cNP+Y6dthe3X5IdvziwLom8FCDhtkugITYyS6HZTm1A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NBxf7JXz3lxS2f0jGWO5TvL/sEA/C6gxweviEta2UA4t2fSl5v8p5I/wNdEgU8A/fANqPj4cNeJFLrngaObklCUEP2CfGMqvbcfMOeMmudlLQm+okEkYns1cxsECCx9QtGTkYCPlnwFR0zxdPSWQLrkxbEK7+F16PrniMX5yzJE=
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
Subject: [PATCH net 3/3] netfilter: Use flowlabel flow key when re-routing mangled packets
Date: Wed, 12 Jun 2024 00:03:23 +0200
Message-Id: <20240611220323.413713-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240611220323.413713-1-pablo@netfilter.org>
References: <20240611220323.413713-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

'ip6 dscp set $v' in an nftables outpute route chain has no effect.
While nftables does detect the dscp change and calls the reroute hook.
But ip6_route_me_harder never sets the dscp/flowlabel:
flowlabel/dsfield routing rules are ignored and no reroute takes place.

Thanks to Yi Chen for an excellent reproducer script that I used
to validate this change.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Yi Chen <yiche@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 53d255838e6a..5d989d803009 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -36,6 +36,7 @@ int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff
 		.flowi6_uid = sock_net_uid(net, sk),
 		.daddr = iph->daddr,
 		.saddr = iph->saddr,
+		.flowlabel = ip6_flowinfo(iph),
 	};
 	int err;
 
-- 
2.30.2

