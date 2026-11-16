Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788208;
	b=4PPRwnUpaiLudV5O91ECDQLEQRxysMGwLff7vfqvEHhbT7WcKS/7RkBUJzHnVPZmzV33
	 CQb9VA6BqGo9HSP6/abO+w48llSbmp2w/mZnL8nUOphBLa4GlspXpB/Sut39NXci7u9Do
	 MdWP03cRm8C8C/IuAmZSFsMFHqfgPthbNDGLxp6gbKMIeD1WcoUzi8xjwWAMvQL3Xg9ju
	 3w6sdzLVNMPqPi12CC64C9K05I6NCQ8bDkWpEYFEXuuHl4dc8I4A++l3lJczK7k99RP/3
	 ZJV9knKc6Psli7odhk2/XG04SfTXJQk6TIYwj/KjtEvn3nLhlBNdb81b6+AhqCmCnXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788208;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=aL0i2bOb5Au0I6UYZUML79qPFqmooqvj+Q5kLNFoTH0=;
	b=FocSHlxweJ9wYP0uAS8dNBdBQXRuA6gKPbinJnllSCvN5VvAdNGYP14urLdSoXEt5Lvt
	 ZjwayYb/o1y/PTH+qahEI1NKib+3lBj8URlWxN3weAl+TE2TWJryC9R7NsY77EeBhyX/9
	 soUq6yoqkXqhFZMWKasUMK8DBZvyjx+n0ZHXsKEw4n8NBd5A1Z1rwR4GkE4rhdf2AeYgS
	 ayRavkz5340Kv5pQeMgteX277KpWgOQjLtAW+2uPAziiFl6fDLJP3k+/rUqHiXOjleN4p
	 zxq1b4krfWfM3TMjlam8rBZczOxcwl2cIZscX1UVy9U2YpxiWGS2DG+tYtJ4oVFrU3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=GRowouAx;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50866606A31F;
	Mon, 16 Nov 2026 00:16:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50866606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=GRowouAx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794788196;
	bh=aL0i2bOb5Au0I6UYZUML79qPFqmooqvj+Q5kLNFoTH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GRowouAxsT51Rfq/xZpx+//P0iyZF4E7Tybw3B3p1xIFjrzFMFL0zR88+DMyIr0Oa
	 /aAzOq57aQNTDuFJtaJfxEhV/nFORCYUL8Z8N+iYA0JbQU/wAVLOKMbjEPrUrnweh1
	 LqLsGCeKGV7/SOd9qRz94pGga1sjJVqzjeZMtZhXojDk3fq8mUjJNTWjXvsSfzlaNG
	 NqFhZzCZEOdChi5kDLtHRo+GWzd0YA7hab2WFn1Pui5i1ejrJybADqYJ6mnyF0jPtn
	 ObE25e3da+/hBtIEluU7mJHRTXD8lqib9eaSdMSug67mPh5nQJUuhW5f1NFaS3qb0w
	 WbZ49ZhLAkHXQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6CBF56005E;
	Mon, 16 Nov 2026 01:16:35 +0100 (CET)
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
Subject: [PATCH net-next 06/13] netfilter: nft_flow_offload: do not offload multicast
Date: Mon, 16 Nov 2026 01:16:05 +0100
Message-ID: <20261116001612.2806263-7-pablo@netfilter.org>
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

From: Koral Ilgun <koral.ilgun@adtran.com>

A flow holds one output per direction, which it resolves when it is
added. The outputs of a multicast route change when listeners join
or leave. So a multicast flow in the flowtable continues to send to
the output that it resolved, also after the last listener left, and
the counters of the multicast routing stop.

A ruleset can keep multicast out with a match before the flow
offload statement. Without one, IPv4 multicast stays out of the
flowtable only because the reverse route lookup in nft_flow_route()
refuses a multicast source address. The IPv6 route lookup has no such
check, so IPv6 multicast that ip6mr forwards goes into the flowtable.

Skip a multicast destination for both families in the flow offload
expression itself, so that the result no longer depends on the
ruleset or on the route lookup.

Signed-off-by: Koral Ilgun <koral.ilgun@adtran.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_flow_offload.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index d3c5651dd699..530e20c7fd45 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -10,6 +10,7 @@
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/ip.h>
+#include <net/ipv6.h>
 #include <net/flow.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
@@ -33,6 +34,10 @@ static bool nft_flow_offload_skip(struct sk_buff *skb, int family)
 
 		if (unlikely(opt->optlen))
 			return true;
+
+		return ipv4_is_multicast(ip_hdr(skb)->daddr);
+	} else if (family == NFPROTO_IPV6) {
+		return ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr);
 	}
 
 	return false;
-- 
2.47.3

