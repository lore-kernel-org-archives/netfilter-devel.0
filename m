Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8039282D9F
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Feb 2024 17:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708536776; cv=none; b=Jr8J0fJvBNm+rwcCiVHZksLnsd0meUIeAJ54NJ3PlgFqu4BzYYaPtXETfJyB7fIgxVeNw9Om11uBYkiIZPqhcVe4sbtSPQb83R5JEkont07RE5bErC1SAlVtKwLwvIcnWTWKGq4PKsADPLxGtPuHILjvkxw5QVwc+Iqc7SbMmrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708536776; c=relaxed/simple;
	bh=67o+Olb7r4rb0pPOqWTqglQuDVu3a9JoHfjJzKIGCXQ=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kre9F/OKMNLkD7NHsZzDSCFWKY9uz55mhWXtcltlU92mi7hN2EklVQmecFngdstabK72sUWKxiMK0nfrGkgDY2xYuQwEYGssvBCLnesFY7Ne01kZH6GoQC6i79sZMIm1mtlMqHsD0w40ruYxrfpv3b2RYPBzhoI96rz8UISmqQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf 2/2] netfilter: nft_flow_offload: release dst in case direct xmit path is used
Date: Wed, 21 Feb 2024 18:32:41 +0100
Message-Id: <20240221173241.131482-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240221173241.131482-1-pablo@netfilter.org>
References: <20240221173241.131482-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Direct xmit does not use it since it calls dev_queue_xmit() to send
packets, hence it calls dst_release().

kmemleak reports:

unreferenced object 0xffff88814f440900 (size 184):
  comm "softirq", pid 0, jiffies 4294951896
  hex dump (first 32 bytes):
    00 60 5b 04 81 88 ff ff 00 e6 e8 82 ff ff ff ff  .`[.............
    21 0b 50 82 ff ff ff ff 00 00 00 00 00 00 00 00  !.P.............
  backtrace (crc cb2bf5d6):
    [<000000003ee17107>] kmem_cache_alloc+0x286/0x340
    [<0000000021a5de2c>] dst_alloc+0x43/0xb0
    [<00000000f0671159>] rt_dst_alloc+0x2e/0x190
    [<00000000fe5092c9>] __mkroute_output+0x244/0x980
    [<000000005fb96fb0>] ip_route_output_flow+0xc0/0x160
    [<0000000045367433>] nf_ip_route+0xf/0x30
    [<0000000085da1d8e>] nf_route+0x2d/0x60
    [<00000000d1ecd1cb>] nft_flow_route+0x171/0x6a0 [nft_flow_offload]
    [<00000000d9b2fb60>] nft_flow_offload_eval+0x4e8/0x700 [nft_flow_offload]
    [<000000009f447dbb>] expr_call_ops_eval+0x53/0x330 [nf_tables]
    [<00000000072e1be6>] nft_do_chain+0x17c/0x840 [nf_tables]
    [<00000000d0551029>] nft_do_chain_inet+0xa1/0x210 [nf_tables]
    [<0000000097c9d5c6>] nf_hook_slow+0x5b/0x160
    [<0000000005eccab1>] ip_forward+0x8b6/0x9b0
    [<00000000553a269b>] ip_rcv+0x221/0x230
    [<00000000412872e5>] __netif_receive_skb_one_core+0xfe/0x110

Fixes: fa502c865666 ("netfilter: flowtable: simplify route logic")
Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 7502d6d73a60..a0571339239c 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -132,6 +132,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		       ETH_ALEN);
 		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
 		flow_tuple->out.hw_ifidx = route->tuple[dir].out.hw_ifindex;
+		dst_release(dst);
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
 	case FLOW_OFFLOAD_XMIT_NEIGH:
-- 
2.30.2

