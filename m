Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.227.203
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795762520;
	b=DJ/5yuMkxcK4W9gRxkGGSKYw43heUN/zx1WZSZ2zOzx9DOhRD7D9hJdjCj7nDhtBqmFA
	 e+itgjVJz5HNjEPoW9ODMN1vAnzfBErcEVSe+0VpQKS6AGlmqNKy8gzlMqZD3nvVDNsal
	 LDvNpFnIvrhBCkf0bsdlpgWEl+8+OhbmqEJjTb3dEW1TFKdRit0YA2MtSs34pWRlcuU2p
	 dKnReLqI6lYs7ny/vN8wBjuh7NqFVkBvqKhcrZsaq5GqdM76JvpHus4C0rsLedOTE+FC+
	 tQVHvs/5PXeeoQGVvnM/Ojn/DrCw2SO8zTJRkGAhg+nKsEz3D5xndLGorxxqcdlfUww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795762520;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=erNRx/pa4ybfvht61Cy5QMsfcLY/xQhwXhQlf25RgsI=;
	b=oNz/kmjF8OXQC60OOoW0rcu52LmakzJrzA2lWkk4hi8nxFLCzzGCnxELD6wPFBIyvAl9
	 38CePuDYC3TuJb990a5O5xXaPiJXiQ74SjLR0dw1oXR/rxNDUpWf1s3qXS04qhxjFKuMu
	 xiA0r0jDvYurjKS7/tgDoWnWyAADY2HHPnGcNh7M8h2fH9EmBPVDZd6u3lwiK+5O6LBz+
	 iYuiD3b6hxT7PjLGPTX8qWDE1iXsXZM4wVp42KlknIzO1LEhiPkUCXFOga8r+3AEVe35+
	 URxUOYG/G/XgD8oiOFAsmOy7nE1JnI4YXy9kN5rdUvMEJXGBvEEU/wAvJUSls7k90Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Xw6a4Wdb;
	arc=none smtp.remote-ip=74.125.227.203
Received: from mail-pi2-f11.google.com (mail-pi2-f11.google.com [74.125.227.203])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6A7606A31E
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Nov 2026 06:55:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B6A7606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Xw6a4Wdb
Received: by mail-pi2-f11.google.com with SMTP id 41be03b00d2f7-cdde34e1e0aso3506377a12.0
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2026 22:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795762519; x=1796367319; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=erNRx/pa4ybfvht61Cy5QMsfcLY/xQhwXhQlf25RgsI=;
        b=Xw6a4WdbBuEohq4yjyZKoO3Y1qKNC6rBR2ZO+XR5X6FRoZhnMgDRDKVx1a+BQp4RHj
         Yy9SJixfy91qcMTmAQVIZTKHvG5A72rknRFllvO5+Zdi3rHQmLcbQciJE9CzpU1AJ0hO
         dyun41/ut8Njp4vByLSGE6fE+8sNxKbOnJgwcffLCkUqIdbc5ENGp2sFWI0L1KUjO+w3
         QBbNqQuHP1GTIL90KSnMaJ4PEkWcbWusKPqxvuCxI0taO/uWECcDfIq20lJ5guSi/muP
         iwwaJiQDPH5AolyhtfATtNPfkFASCQ2ROi9XRq1vgAlKkJLL8tkCMmAIM7JG2nFuvVUT
         fjFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795762519; x=1796367319;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=erNRx/pa4ybfvht61Cy5QMsfcLY/xQhwXhQlf25RgsI=;
        b=zGGgndR7mAjpE1a1fKn/6XjYzk4KJT7qQiN4qHey7f0ZI57iQ8eRMvqCEZOxGXsXcr
         GdYVcrBsVrqQ3rQqyHhaOOfsbgFryK/6jYfjkD5ErhhTlUh9l17PXTC+SJfCFybmWPG3
         ij63BnFlZO747lMBqjmqCHtEc17jhSqXEn8A6ZYEivjdszFAX5Rdptd4jqsE8XcQW4nT
         fNfUFS4xAoYDtkd4zp3JJVi03knU0pWKldLbysBs7S7ULWMnBSOzuVmt9DuuinRGQ+Y/
         1mFAEUOABTMFRblotidhq5bJ/D+47oou8mP7ARU/LrjHzAd2LI8Rj8pCMDiKRd+Zh8A0
         HAjw==
X-Gm-Message-State: APuU4Z8j2sRA7bUhKSu6IC2L01cHYH6kDTi5RRTg9q09uqCyDO0nnO9T
	9lRVQ89uhi6BEJunctiP/0KcNO9897njpScfNXU/G4Sh8PTAP/+gZMb4
X-Gm-Gg: AZFdTZcXEHS9SraE7TD3ikLFnAmvzNcSsRu8TZRhoXnlp9Xv/d6uhR0siKAxIi8xGdS
	RQPJd6JqKDHTMZWb7uDU2+MQwKWJzQwHYNfdzZFUDinWiX/dih6LBlTRTwuJfbV9mzRXn/YcZO+
	UZ/Tut1QGfaqgx4jtTjbUJpNd9W7G93g7mIyQYbH/cTMIm6S5Mds8eeY+NRFwg0Gib0e2nsGo9h
	R0hQ0fj4xBqvZgZSBzP3lzEYmA6oivoCM7NGumkBCZqaXgOw93GferDuHMJg/15xk5yeG2dawc7
	zw5k2jjeibs01HKyPfEvkicjHg1wakqfeREbFY3ZiNQtjHsJnAvF5k3NA8l9bNas5DUMmJqA803
	y4YEUj4LRahbAD3gwHHZU39lrUoIPzX1vnrPGzvD5jf9mKaKbV84AgyqOveQvO4nPVCIBCqwQD5
	v5JfS2a6BT3GdVWrvTCglelR1i6bZnyuPYf6i14/GU/Q+wAdkXWunszT4pP1Voj6QNfuzZD0aQ+
	AX8ZYc/YIFOdTX+v4wfUbMP9wkOaRqHOQDqGXx+2zSEAPiW2CbbX/OUcCpaAi1Tb/vxz1MqRSgR
	yBlmaUoqTZID6lmlF4arnJ9Iqi1WobRkCDSi1d3SjWxE3TI18qY+an1LoRAI0tocBPo4Ku7KDnD
	p
X-Received: by 2002:a05:6a21:32a6:b0:3fb:3a56:e41b with SMTP id adf61e73a8af0-4014db62821mr29894274637.48.1795762518648;
        Thu, 26 Nov 2026 22:55:18 -0800 (PST)
Received: from BSDHENRYMA-PC1.localdomain ([43.132.141.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87353b333sm11793302b3a.40.2026.11.26.22.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 22:55:18 -0800 (PST)
From: Henry Martin <bsdhenrymartin@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Patrick McHardy <kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Henry Martin <bsdhenrymartin@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_nat_h323: fix UDP mangle offset in set_addr()
Date: Fri, 27 Nov 2026 14:55:09 +0800
Message-ID: <20261127065509.2925843-1-bsdhenrymartin@gmail.com>
X-Mailer: git-send-email 2.53.0
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

set_addr() unconditionally adds dataoff to the embedded-address offset
before mangling the packet.  That is correct for TCP, where
nf_nat_mangle_tcp_packet() counts match_offset from the TCP header and
dataoff carries the TPKT header length.  For UDP,
nf_nat_mangle_udp_packet() already counts from the UDP payload, which
is where the decoded H.245 data starts, so the extra dataoff shifts the
write past the address.  When the decoded address sits at the end of
the payload, the shifted match_end runs past the skb tail and the
memmove() length in mangle_contents() underflows, turning into a huge
copy that runs off the mapped pages:

e.g. on mainline v7.4-rc4 (KASAN build):

 BUG: unable to handle page fault for address: ffff888140000000
 CPU: 1 UID: 1000 PID: 82 Comm: poc Tainted: G O 7.4.0-rc4 #2
 RIP: 0010:memmove+0x91/0x1c0
 RDX: fffffffffffffffe RSI: ffff88813ffffffe RDI: ffff88813ffffffe
 Call Trace:
  nf_nat_mangle_udp_packet+0x13f/0x420
  set_addr+0x18a/0x830
  nat_rtp_rtcp+0x50e/0x910
  h245_help+0x1eb/0x240
  nf_confirm+0x481/0x8c0
  raw_sendmsg+0x203d/0x2630

Only add dataoff on the TCP path.

This issue was discovered by Tencent CodeBuddy Security.

Cc: stable@vger.kernel.org
Fixes: f587de0e2feb ("[NETFILTER]: nf_conntrack/nf_nat: add H.323 helper port")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
---
 net/ipv4/netfilter/nf_nat_h323.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index 6bcd6734769b5..764bfc89027f6 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -35,9 +35,16 @@ static int set_addr(struct sk_buff *skb, unsigned int protoff,
 
 	buf.ip = ip;
 	buf.port = port;
-	addroff += dataoff;
 
 	if (ip_hdr(skb)->protocol == IPPROTO_TCP) {
+		/* nf_nat_mangle_tcp_packet() counts match_offset from the
+		 * TCP header, so move the offset past the TPKT header.
+		 * nf_nat_mangle_udp_packet() already counts from the UDP
+		 * payload, where the decoded data starts; adding dataoff
+		 * there writes past the address and can underflow the
+		 * memmove() length in mangle_contents().
+		 */
+		addroff += dataoff;
 		if (!nf_nat_mangle_tcp_packet(skb, ct, ctinfo,
 					      protoff, addroff, sizeof(buf),
 					      (char *) &buf, sizeof(buf))) {
-- 
2.39.5

