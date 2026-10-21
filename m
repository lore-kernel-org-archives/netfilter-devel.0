Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792578162;
	b=tlvlLYTedOcFSlO+WbDLEZhO2H5Car9eOHAPj+XF+n7Aq1vPGfXZ7h7SwiKNyEqzLtpJ
	 siiW1W0Kqd9shj2PXziGR+X0HayPbS4ZPQseoEjEoW01LSK2KdrBkcso7A1LAKjaraZni
	 vwcSIveX90gE4byxIDYvuZ0SIsZmsWuwldBKRw8FV7ECtBJP0PNrahnGzGTh/Pzci18A4
	 SBAuy7i23NRwDOfUaTk723I6W1fBSngV9ugh11n6nUtCeHtlxTEf0mntZ7Hq0e0zAOHKB
	 lkRjGuvMtF4k0XNhSweXlQmMuUn4tSXEfWf4QtMNk5ao60unuhFpM/lfXcnysQWARKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792578162;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=fjmOUTzjnG9WKyz/dz9DMTtRRBqxSQ7bXXS9Ppw6glc=;
	b=LC1pvHqugVDGlVThlmR4457RvvQ8UOcDeVusX/LODRYx5AMDwvKutuALto8h7iVOAA0J
	 qVZEg/rgd7QWNfXmm8mhsLCdfHdecw/vPL9VWC58zkQSTFtaqRUro/HQh+xU/S5b8wUEP
	 OgyqA+LHeiuNJShfLSTPa273E6UApdhKuFdueOnFcU1dvAWdkMTDZ71eQFiAzcTrlYHHP
	 4pNOI0Qg3fJ7NoCbS0dN9Lpoy0Otc5TGkS+mjs4xm0qTReSc4QqZBQ16lpGEuo5hVQikP
	 3ZuDCIISCOaWeDuV+JHcMkjZbkHyVS7iskRxxwDvKdhERhxCOEUsyzZNIh+Rtk3yIAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=TTNVWzcf;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B05606A319
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 10:22:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74B05606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=TTNVWzcf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792578159;
	bh=fjmOUTzjnG9WKyz/dz9DMTtRRBqxSQ7bXXS9Ppw6glc=;
	h=From:To:Subject:Date:From;
	b=TTNVWzcfnbYWyEq5znkX4fO5cS3JXwY/En2P9+59VdD317GWkoNXisiGlnosG0ZOf
	 h6sn2ohF6gSfWq0YrNJSwmRYQnL42NcOAjx/e8/5ZYcRPWiRxonMLiPFn4uU6UZppj
	 gC3beu77sNnTaSrB7AKeJRCaa4hw9TFM0HUMZaJcw6kP6wqQGJTAahJj5nRP0jvKkx
	 dmQ5K3kNzBMt/Dw/2pz+mjeo09JXVbCnFTjXKctrt+UTXmiq6Sw1KIy9YSMOCwAGDW
	 4gfBRzgjsGv4+x+N+IrYcOF1QSBzFKUk8/JWobHvaqAcguRpaNjHylVjl651krBX35
	 mFEz2zSB17aTQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4826560076
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 12:22:39 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2] netfilter: nf_reject_ipv6: fix locally generated packet to local address
Date: Wed, 21 Oct 2026 12:22:36 +0200
Message-ID: <20261021102236.1964881-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
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

Set on skb dst before checking if this packet is in the inet/ingress
path. The inet/ingress hook runs before prerouting, no skb dst should be
found in most cases.

This fixes reject for locally generated packet that are sent to a
local address on ethX arrives through lo, really perform the same
handling as ip6_rcv_core().

Reported by sashiko.

Fixes: 73a73d442f99 ("netfilter: nf_reject: initialize IPCB at inet ingress")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: - clarify that inet/ingress does not have skb dst in most cases
      (LLM gets confused and think that skb dst is always set on in this path ...)
    - be wary and check that does not return NULL.

 net/ipv6/netfilter/nf_reject_ipv6.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 5e08d8529cc8..59a6ec45b529 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -444,14 +444,24 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
 	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
 		skb_in->dev = net->loopback_dev;
 
+	if (!skb_valid_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
+		return;
+
 	if (hooknum == NF_INET_INGRESS) {
 		memset(IP6CB(skb_in), 0, sizeof(*IP6CB(skb_in)));
-		IP6CB(skb_in)->iif = skb_in->skb_iif;
+		if (skb_valid_dst(skb_in)) {
+			const struct inet6_dev *idev;
+
+			idev = ip6_dst_idev(skb_dst(skb_in));
+			if (idev)
+				IP6CB(skb_in)->iif = idev->dev->ifindex;
+			else
+				IP6CB(skb_in)->iif = skb_in->dev->ifindex;
+		} else {
+			IP6CB(skb_in)->iif = skb_in->dev->ifindex;
+		}
 	}
 
-	if (!skb_valid_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
-		return;
-
 	icmpv6_send(skb_in, ICMPV6_DEST_UNREACH, code, 0);
 }
 EXPORT_SYMBOL_GPL(nf_send_unreach6);
-- 
2.47.3

