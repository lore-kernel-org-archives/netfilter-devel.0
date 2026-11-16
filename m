Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788223;
	b=h8RIc9KFK3Ql0YgFHg8NZ5TEzcWSI0mCQP8qDY2gyPBwo2zAGqh6/NISuLC7w9U8v+04
	 3bEiqzo9KKZDB/WYcNReIW8wFuAnNLK/Vbb1uUaMpOmvHAI2XxcjMraHShCP59ETa86qd
	 ai8/CXGLseoNgtIE5EZ+oKnJYT5C97fuJwPIVu9q572zl2LzR7U8FLlQFoEWNx4ZJSNXR
	 mQM+OuLr2z8R6OsN/u1xyURSx84gGvs3r+JM9BwzmD5XUpy6fmZYJk2IYQUMhCgmWk9Co
	 CV0iNXu9bQfvQmmD3ObbVGfpPiVJg+6QoUieqecmWhL87DUcxnnz2TjQIkD1xISaIsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788223;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=orRTKP56HqqLAcK89zHcol773EV7iC+AYKFyW+Mo1rs=;
	b=iq5ixAyfUYg1FmqK+qvtRiAPAz1FEClCIOf5wDY/k7lnViULqkdvNMMebl/oUeWulugW
	 uqWt8WNz2H1RJ4ZhtichDnUKeGWJbM38D77gJs9osrgSu+/J4p/y+zQOkf2WQFf1VXj+y
	 bRtCKxcCfcAspFxxqEo5gN2CWQwjAf6MOukF4E2DdB7LJq9UIr2OGjpp3A8zuCGUIfH6S
	 yEpKshvV3bbbmqXoldWVFVgSqUXJVkVjxfgq0xqoX0g9iD21eIfuKfcT19aV/90QrgJBn
	 jBD0WFUqVNfHqPbwfnyg7GZKkTvaE3WuWzaUKnfruK/BHykSXCrFGONVkOsTZTfnzTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=IMQ84b17;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5531606A339;
	Mon, 16 Nov 2026 00:17:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5531606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=IMQ84b17
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794788220;
	bh=orRTKP56HqqLAcK89zHcol773EV7iC+AYKFyW+Mo1rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IMQ84b17y+9cduAbpOihKdvTCBVLXIxwY7tsuQ58zLujTtZG7m+ZXPaF8s9EPsTo0
	 szdgjrEzA+ityFcaRVasd620gLtZRH4D1YI9QlEPul2SBl7tBG8IY0nr4vLbl5FvYf
	 lyR/4OcZm163KgRU5Pb4rh2+ASsp0X5Y5pSkVC1aA+kuVO3XwPdsrB/Iwba745QyZw
	 u2y+BKn7VbiAHugHM3fFmiP6QUl6IC+uxhtY4t0JlmrtJaFHuuC9IFwWkE7Y4eAlKQ
	 HsiNmeykKaz9eZHswyWgAjNJS9C+FDdVLcgixU7aOHWTbGHlYapCTVt1m6eFUhAqlw
	 5fuRqo7GIIjGg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E98B56008C;
	Mon, 16 Nov 2026 01:16:59 +0100 (CET)
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
Subject: [PATCH net-next 10/13] netfilter: flowtable: tunnel device poisons h_source of fast-path frames
Date: Mon, 16 Nov 2026 01:16:09 +0100
Message-ID: <20261116001612.2806263-11-pablo@netfilter.org>
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

From: Marek Majkowski <marek@lysk.ai>

When a flow enters an IP tunnel, the forward path discovered by
dev_fill_forward_path() starts with a DEV_PATH_TUN entry for the tunnel
device, followed by whatever carries the outer packet.
nft_dev_path_info() handles DEV_PATH_TUN in the same switch case as the
Ethernet-like path types and copies path->dev->dev_addr into
info->h_source if it is still unset. For a tunnel device dev_addr is not
an Ethernet address: ip6_tunnel stores the 16-byte local IPv6 there and
ip_tunnel the 4-byte local IPv4. The tunnel entry is the first one on
the path, so its "address" wins and poisons h_source: every fast-path
frame is transmitted with the first bytes of the tunnel local IP address
as the Ethernet source MAC.

Seen on a DS-Lite setup, LAN -> ip6tnl (IPv4 inside IPv6) -> PPPoE ->
802.1Q VLAN -> Ethernet, with conntrack flows offloaded through an
nftables flowtable ('flow add @ft'). The first packets of a flow, still
on the slow path, and the fast-path packets of the same flow differ only
in the Ethernet source address:

  slow path:  d8:58:d7:00:2e:bd > 80:ac:ac:39:ef:c2, 802.1Q vlan 35,
              PPPoE [ses 0x454] IP6 2a01:110f:4328:c400::1 >
              2a01:1000:0:1::2216 next-header IPIP, 192.0.0.2.40010 >
              1.1.1.1.53
  fast path:  2a:01:11:0f:43:28 > 80:ac:ac:39:ef:c2, same frame otherwise

As you can see 2a:01:11:0f:43:28 is the start of 2a01:110f:4328:c400::1,
the tunnel local address. The PPPoE endpoint binds the session to the
subscriber MAC and silently drops the frames, the effect is that every
TCP/UDP flow dies the moment it is offloaded, while ICMP, which is never
offloaded, keeps working. Received traffic is unaffected.

Do not let DEV_PATH_TUN poison h_source: skip the assignment for it. The
real link-layer device appears later on the same path and provides the
correct address; for a path with no Ethernet device the address stays
zero as before.

Fixes: ab427db17885 ("netfilter: flowtable: Add IPIP rx sw acceleration")
Signed-off-by: Marek Majkowski <marek@lysk.ai>
Reviewed-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_path.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 841f099434d9..4ca6e09c7f8e 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -121,7 +121,12 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
 		case DEV_PATH_PPPOE:
 		case DEV_PATH_TUN:
 			info->dev = path->dev;
-			if (is_zero_ether_addr(info->h_source))
+			/* A tunnel device has no Ethernet address: its dev_addr
+			 * is the tunnel local IP address. Take h_source from the
+			 * real link-layer device further down the path.
+			 */
+			if (path->type != DEV_PATH_TUN &&
+			    is_zero_ether_addr(info->h_source))
 				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
 
 			if (path->type == DEV_PATH_ETHERNET ||
-- 
2.47.3

