Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539594;
	b=bCqjUqBtPfsLqIxWMHdlXL0kmebpe9olewT5UnN6AKy35QgINNUOpuFKhHrogaO5luHY
	 HulP1XhXOf7wEXcgi00qnOov+TksW6M0nh6gdv3G56FbYogTTlj2gp9Rt5Mz1RAEbq4+W
	 WMROmQnYpJmbu8R7z5cgbNaHoy+Dl9K2ehGMCxQ9Zq+HCkkb2bQrjnhrajokd7rFibVWu
	 sYHsTz6y3o1fu4x2DyOzI+OghvMfm+MiU1sfa2MBB9/e2aKWbYvkBw6wNDgcWWHWzbvJq
	 0/i0vTBEMYkFi97qtSClUCtuN5esDCYX3F0k00zq/p5lOdkuU1i/alrsN0nRyJlImJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539594;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=orRTKP56HqqLAcK89zHcol773EV7iC+AYKFyW+Mo1rs=;
	b=iAoO2cFQv5wmyn0G+jYxFShAgoMzYM0npQ241bwTGwtSITTHZwl4A5Nu/Sd6FzHDsCa1
	 BZRx++SuUBcRud5rsmiQHTmL8IJ4/u/T/TsKWUmzJxF6lV6DmUyNfYcrWTjLr2q+OvGqg
	 s83HKFWlhufs8uCYlNBK0zbx09W7PBVzog4syjvlY5CfSWWKGOIhfghF390ya2Ir/Wt24
	 TtHbv+/jvxziz5pAwyeY0edwlXCZ7LFfbK6u8b1spw0uqPCuvsaLRQV84TBfOAte7h2G6
	 bR5uMIWqrLfJ3QOdHOTxa6SroZFSOpbO+pvVvLQcCg8vyYeYMrBUPDOYEquA1hMHmzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=kJkRjFQ8;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1883460A263B;
	Fri, 13 Nov 2026 03:13:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1883460A263B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=kJkRjFQ8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794539592;
	bh=orRTKP56HqqLAcK89zHcol773EV7iC+AYKFyW+Mo1rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJkRjFQ8UbzHN9MT9uJ50Ri2Tumx1lhSn7jFl8qZfKbpnup0gSKYtK1u0l1goUsYn
	 y8Z7jUo/R5wpm+O+nSQvQkn4IAUREywXf9SCfRo+JN79A/krOAuDAuzYKvFPPONoTB
	 RS130ghnwhXgnveUYmmMqggQvPS+rtWrRjnYPsAJbrxaGQQ4Z+cPWUiid/vYHVV6vh
	 iETrV40SUNQ5fjmpb9/67EVsHkwowrY6xbJs61dg8QtefVTdrGeLjs1FHzL5ENWwzq
	 MKKzEQ7QeLMVjBuHox1vx0fNNW2mPRC9YxFiGvmiAHkZby9TVNG5aNWX13ibHqucK4
	 m2rsn6W3/+2/w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DE45F60058;
	Fri, 13 Nov 2026 04:13:11 +0100 (CET)
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
Subject: [PATCH net-next 12/15] netfilter: flowtable: tunnel device poisons h_source of fast-path frames
Date: Fri, 13 Nov 2026 04:12:48 +0100
Message-ID: <20261113031251.2437074-13-pablo@netfilter.org>
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

