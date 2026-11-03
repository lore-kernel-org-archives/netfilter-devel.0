Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714606;
	b=yN0aPR2H1/ScuOnyvj8jBAniDF//CNeZrNygHYoSLFHI9lHo7IdQ8OBTbMnLym5VSmbU
	 T8apFSpslax4NsCIgllkmtIBpPQ+jnrTYHpedrZGbIJDHCwaIKrR8i19ej86WL22uYwFN
	 WKoU+uMVqmbmaGMkKKHcq3ftYHq6a520sGgSha6lBCtON6lvsZBsBdmUtWbOq+LDHAKR2
	 fdYJ5qzctffhNr7O9QL0wl7gxuVPqgnUfQ6EwYq2tC8wR0zyycs6tCWC9rq7up1ITsTFS
	 gPtyL1vBV/C8c6iI4CORS+j/Vd3o0gpW6nMPYtphWK9hmpakR28eD57J77a2R6PSy3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714606;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=rtTKULpTnN+Nv7hj6YAwU1fNR5t0PXlCdJ7mWoX/Fc0=;
	b=JYId2FZrbkhg5MznFTSYFmw5x0a/ZFR9rEADNngCV01EIkfP/NW+UCJEXIHxo9zc3E6V
	 9DEa86iiRoFwGbQLsaX78jvo+7PKaxlEYb83vJHLRa1A84a3X6lRAM/NJI3QqU2wg91jD
	 1jif48Iy2pBG3/7AfWe5fGPiliVvxOb468TctmFmdeDVZwn3ZFokm7EevCAKquQMNKuV6
	 xV4TUBHrjnoGtxRk3VnTNvL/Dgx0hUvwnpVr9Ww0JP7Bumd4z3XsMQo+9G0Kap0H+dYJn
	 FJ+HqjHQnGEevIVAU48HIf3CPboplJnfNByi9YuqjkVkCf82dzVyInWehOQwaKlJ19w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=U1snme5x;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700296082BF8;
	Tue,  3 Nov 2026 14:03:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 700296082BF8
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=U1snme5x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793714603;
	bh=rtTKULpTnN+Nv7hj6YAwU1fNR5t0PXlCdJ7mWoX/Fc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1snme5x6ljIXy0RP5IdwIGkRBY3p7xYILTE0iCc4xO1Tt10Fg1EcEacglu+LzsIs
	 bTtvM3Hbj5nN2X4wJlrIFXzC1bZUWjuxLAY1sHpCyczvtBMoSO4+mLkA4H44rDmR31
	 /jnmL+B2Dg5NFJf1qswDPzxOMMkscQ40uujrY7mEs5XAmE81b+euPPVFe74wg/Rrjw
	 4UI+6rbF6XPKF+bx0TBajzAScJ9OI5cnguryEJZ8Sl2Ey5MvclOuVJt9rccUIVy4KB
	 d3sSp+3cjUIFihvblQxNAqivec4yBZLYWJ29npHNKZbBFT/O6OVF774tVqyNtJ3MSS
	 hkbXvQ2YaqCPg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D2DCF60085;
	Tue,  3 Nov 2026 15:03:22 +0100 (CET)
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
Subject: [PATCH net 05/15] ipvs: do not create conns from packets with port 0
Date: Tue,  3 Nov 2026 15:02:58 +0100
Message-ID: <20261103140308.591690-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103140308.591690-1-pablo@netfilter.org>
References: <20261103140308.591690-1-pablo@netfilter.org>
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

From: Julian Anastasov <ja@ssi.bg>

We should disallow normal connections with cport 0 to be
created from packets by the scheduler (from clients) or
by ip_vs_new_conn_out (from real servers) because later
such traffic can not hit the connection due to the
NO_CPORT requirement. As result, it can lead to duplicate
connection for every packet. Do the same for vport 0.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260925141115.16126-1-axel.mierczuk%401password.com
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_core.c       | 3 ++-
 net/netfilter/ipvs/ip_vs_proto_sctp.c | 5 +++++
 net/netfilter/ipvs/ip_vs_proto_tcp.c  | 5 +++++
 net/netfilter/ipvs/ip_vs_proto_udp.c  | 4 ++++
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 8a3c880fdb26..f3eb72e95024 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1305,6 +1305,7 @@ static inline bool is_new_conn_expected(const struct ip_vs_conn *cp,
  *    In fwmark-VS actual vaddr and vport are unknown to IPVS
  * 2) Real Server and Virtual Service were NOT configured without port:
  *    This is to allow match of different VS to the same RS ip-addr
+ * 3) Client port is not 0
  */
 struct ip_vs_conn *ip_vs_new_conn_out(struct ip_vs_service *svc,
 				      struct ip_vs_dest *dest,
@@ -1328,7 +1329,7 @@ struct ip_vs_conn *ip_vs_new_conn_out(struct ip_vs_service *svc,
 	/* check pre-requisites are satisfied */
 	if (svc->fwmark)
 		return NULL;
-	if (!vport || !dport)
+	if (!vport || !dport || !cport)
 		return NULL;
 
 	/* for persistent service first create connection template */
diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
index fb8af6b15a39..83d1443ebe01 100644
--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -30,6 +30,7 @@ sctp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
 			sch = skb_header_pointer(skb, iph->len + sizeof(_sctph),
 						 sizeof(_schunkh), &_schunkh);
 			if (sch) {
+				/* Accept packet without scheduling? */
 				if (sch->type == SCTP_CID_ABORT ||
 				    !(sysctl_sloppy_sctp(ipvs) ||
 				      sch->type == SCTP_CID_INIT))
@@ -47,6 +48,10 @@ sctp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
 		return 0;
 	}
 
+	/* Do not create connection for port 0, skip the packet */
+	if (!ports[0] || !ports[1])
+		return 1;
+
 	if (likely(!ip_vs_iph_inverse(iph)))
 		svc = ip_vs_service_find(ipvs, af, skb->mark, iph->protocol,
 					 &iph->daddr, ports[1]);
diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
index fec0e8b47b71..2e55b62445c6 100644
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -48,6 +48,7 @@ tcp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
 	if (likely(!ip_vs_iph_icmp(iph))) {
 		th = skb_header_pointer(skb, iph->len, sizeof(_tcph), &_tcph);
 		if (th) {
+			/* Accept packet without scheduling? */
 			if (th->rst || !(sysctl_sloppy_tcp(ipvs) || th->syn))
 				return 1;
 			ports = &th->source;
@@ -62,6 +63,10 @@ tcp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
 		return 0;
 	}
 
+	/* Do not create connection for port 0, skip the packet */
+	if (!ports[0] || !ports[1])
+		return 1;
+
 	/* No !th->ack check to allow scheduling on SYN+ACK for Active FTP */
 
 	if (likely(!ip_vs_iph_inverse(iph)))
diff --git a/net/netfilter/ipvs/ip_vs_proto_udp.c b/net/netfilter/ipvs/ip_vs_proto_udp.c
index f32785682402..92c0b76c1a02 100644
--- a/net/netfilter/ipvs/ip_vs_proto_udp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_udp.c
@@ -52,6 +52,10 @@ udp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
 		return 0;
 	}
 
+	/* Do not create connection for port 0, skip the packet */
+	if (!ports[0] || !ports[1])
+		return 1;
+
 	if (likely(!ip_vs_iph_inverse(iph)))
 		svc = ip_vs_service_find(ipvs, af, skb->mark, iph->protocol,
 					 &iph->daddr, ports[1]);
-- 
2.47.3

