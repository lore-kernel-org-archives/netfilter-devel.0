Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793741708;
	b=ANo0f/1GTvbFBiIez1ggK9mkGdZjU4AhRP4/qI3gMYQjfDqb/Z45SvCm90CViIbkSO3Z
	 EBTWZk87145c1CFxIUkEoZ7l+OynrW/ezuo83z9hK0zjWwOArQ446P9iOAg9zrh9Gb+Xl
	 rGo58PqduGdiv9+9gOffid2cQMggO0WJ2sUlvKPlz/F5y7BBKbbegub1aBFydVjcqzp4j
	 2jzFfXsphqtCNdCdbCWto1fClK5SFHkWe9A3100SEqFb+kccy0jUfit73QL6mi8veCtrT
	 pmJn8u1tSzMe/ggZ4rIv8kH7604PWqTCDVnPdsLrXwgHLZ6s9fcM1zaZwgFveSOqIvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793741708;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2/Oq2yxr5c36O2jrWUkxKvnaxXC/ugdrj8Dp7ILTXKU=;
	b=MEnDyjIdIYchYGVHlx7w7lW8nKJ4Oo4ynvZD2gXV5Q7XphMGCfHuola5n56BAIEySc3r
	 t/kwrLRgkVZAbz+LjWEBb6Rfm2RFdYDicXWA8JWDbFoVU5fHSygy2Hsh/gV7uRWv8rDwr
	 WaeCVdVH4F52CNt9fn4VpHD/Qa5o3nPRjXtBRNUCi8UdfX+odtfl9NNESH1aIRx54ZOx8
	 62d8KbTPFRp6blI/vZd+j+XNIIgrdzX5ifLF6mwam9bkVWwQb3gsU14UQfPzeKxbpBPhY
	 c/4806GCV0pjHL+gBLmywGo3fUdM1KZyA/6cc61Nr9X1L8qt0yoVWsll2aeHmst+jyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=lysk.ai;
	spf=pass smtp.mailfrom=lysk.ai;
	dkim=pass header.d=lysk.ai header.i=@lysk.ai header.a=rsa-sha256 header.s=google header.b=SujUWrcy;
	arc=none smtp.remote-ip=209.85.218.45
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41B5606A324
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 21:35:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E41B5606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lysk.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lysk.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=lysk.ai header.i=@lysk.ai header.a=rsa-sha256 header.s=google header.b=SujUWrcy
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c423b145922so6619966b.3
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2026 13:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lysk.ai; s=google; t=1793741706; x=1794346506; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2/Oq2yxr5c36O2jrWUkxKvnaxXC/ugdrj8Dp7ILTXKU=;
        b=SujUWrcyDIB78G9Ozq452zDuE/vNNQ0L+EvDHuP97QxnmqaVgqUJxaftfA5bXLdw9V
         jen9UVfmbKSuCXux5S10rKPyWAHWlB3F7cAKcN+WfkyDHzjUdaVHdDNfu34lkljpTr4B
         A8LWur6Q4HbENP4vMYSsW00CI0LprtvhzTnQfMFHu8AO1WVbbTG6625aebOepiggqBvR
         0OT5wublgFG6JLbRrciz+bJwM9/OwpHAn9RIiFIc6utz5ai0IK/dx99fKlvXbNpB4HQm
         4Fj+nK9awyGJMhLQttYxO19my2qLxj7gmXhxJRZfZ5AFsBmtIE7V7xUHCjDhz/ElvPMo
         wMkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793741706; x=1794346506;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2/Oq2yxr5c36O2jrWUkxKvnaxXC/ugdrj8Dp7ILTXKU=;
        b=2cBcwusDbdImx85n0WQOvG9aASpOhteMnMeF7WvMsflNpwox5VGXlKiLynT2bWC1Cy
         HRVsopbnw9eTgLylfBb8M51WVMcZ3RTSYxPRy3mT+FPXBJEc2dRHIx+07SoKJ0XqmeAQ
         wKQ5N2QDVt8ygOQOPbfku3bMFg/JBKkZxbstew5YjfKt6XYZOyRSs6jkrNkXwR1qtfnM
         5wtUdW/jh9gkB3FU5Lkgfp5N34mhPTxBM2dU4UR8apVSwF+Yr0BiNqoP9bXgaKwq8g17
         L/vAAyNjP+1E5KDUrE4RKNRVCEQa7Ks/oxdSm8srgV0BL+ynNvstB9KEVQfeHLGfJogJ
         j8tQ==
X-Forwarded-Encrypted: i=1; AKwUvBy2t5jTph4pmvYXYaLYib+zuiWic16nyrpwUi6xhQX3oNWTIh+zLUsrGXyoKHhF71VqCmcY9aNCLb6+bIhXkoE=@vger.kernel.org
X-Gm-Message-State: APuU4Z9W1BdXgBrsjkXEGU3PhP9J8rRDsuNQDhAtadrLQlsQla/yImIt
	nd/MqJBiFKaDaa1lVBfDQXGEu3MKGwfVuWoqAzE5gB/b41Ut18i6pBcWsbpBZ0ApoaF2PvjPISa
	wxsf+36RJGxPgxQ==
X-Gm-Gg: AYBFou0EvmrHd5rLqmg8THGhalcVJO2JMcPD3qgmf9dC7vbV911z+YY+U9j3/sI2B7K
	guNteiBDsTUmvWQ2QNfcAu3OveBk1ui5Lk+RDZY2DmLAHROucqccOROir/2Hp0w3K+xRayEY6Go
	PRTAOYfs+Vtv8/0t/InmkeAWOb4jGKuRHcs6SThZEZDaSr4Wohl0Cgaw4l4NlEC4y2FqKsh2ryA
	zT3IXCdA5xNZhBJYA7Nlslrqhf4IotBX+2peYvonAXHorZfBqOeLTbt8fpuxXqBlcqOU2ZPOuCo
	mMWYiXMi4UdSB7zsdo+N/zvGpc21nNS/B6tm4Zex1KLwNtpkd71gxKzsICmjtrJ2rPQwJ8OeNjj
	y7ASMTJ22jlCDU001fOGEfbCTYQPGc168KTGvCCLHWKj+qZPd4+9c6EoMOKbUK2A/tCeZcMXNLC
	tnLZsP3cubo+zB+GUnbu9UO/dGqRJ92q1IbcSOXigVStJxoB5qaPZRV1fX/oZ1YXkqBYMmZugMJ
	wpNhPegpBPzc441ZAV2+Vc3HUu8H3iKLQN/Z5KXFViLL5f6RvyjqqZSsiPLspQVwFiZMmt6+An1
	VFAqPgeC45/2fQEYRz4lKJRg6DW/NB6DSYigbtRKl4ifZvIR3Br9gqLGNG3qkv09jSMFff82gT4
	NGNCCywD9k9pRb/H9cbfFqLKAF5yZzbTELDUXGlaBlrilJvB3YIfcH3SImehxF4vR1ZYqMxztgk
	3b5jhf8WKKK9R++3PoGZzcGRgxfXqYftJ4uOLqJmKzQ1GaPWHJSi+ceVlOsYYtgwPdeOWWiqKiI
	htS+czrzGpufMXoJBgglFtJrr6GuRUPG/HjDg==
X-Received: by 2002:a17:907:724a:b0:c46:645f:cee1 with SMTP id a640c23a62f3a-c4ca7ae41ebmr1308021766b.42.1793741706083;
        Tue, 03 Nov 2026 13:35:06 -0800 (PST)
Received: from turris.internal.popcount.org (2a01-110f-4328-c400-0000-0000-0000-0001.aa.ipv6.supernova.orange.pl. [2a01:110f:4328:c400::1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d0e46a465sm2548766b.58.2026.11.03.13.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 13:35:05 -0800 (PST)
From: Marek Majkowski <marek@lysk.ai>
To: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Marek Majkowski <marek@lysk.ai>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf-next] netfilter: flowtable: tunnel device poisons h_source of fast-path frames
Date: Tue,  3 Nov 2026 21:34:29 +0000
Message-ID: <20261103213430.2850-1-marek@lysk.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261101-flowtable-sw-accel-ip6ip-sit-v2-0-c6c282cab5cb@oss.qualcomm.com>
References: <20261101-flowtable-sw-accel-ip6ip-sit-v2-0-c6c282cab5cb@oss.qualcomm.com>
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
---
Found while testing this series on a Turris Omnia (Debian, armhf) behind
a DS-Lite ISP: with the series applied, IPv4 flows through the ip6tnl
were offloaded but no fast-path frame ever got past the PPPoE
concentrator. The problem is in the existing DEV_PATH_TUN handling, so
it applies to net-next with or without this series; with the fix the
series works here (tested: UDP flows with a fixed source port, TCP, bulk
downloads through the tunnel). Without the series the same wrong MAC
should affect ipip and ip6ip6 tunnels in front of PPPoE.

 net/netfilter/nf_flow_table_path.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 841f09943..4ca6e09c7 100644
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
2.39.5

