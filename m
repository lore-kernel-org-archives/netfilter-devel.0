Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792573660;
	b=pTKnz8C8EPJ2SEo1uPHD8vKwkFhSPasAxKQ4gEO/9qsG3FBb0kLUD2oLVw3IK3esrZOm
	 TdTHzf/ywFzb/R58GmnRwuqU0y/swT4yKXHoDi65SuNFceOwKEVb8CkqhTmIET6z0OupI
	 H5T1/JEYKDRVjN+ZGm9w6ba0uACEsmXklGuTmwO4QOGb5yuod8CSAelYTfm8jkO+/9IiF
	 wamdANMNEjbDserxldU7nrYnGdfsa7un0CpUWPTdW3ejfJLaQpOgpqR6IZ8Hr/8VfGDKp
	 k7S9BX9HywPKNs8lcG4eqJaB16xywr5AaeS4iqgk3i0PMwWD+8vX4JPGWv8aPISyv4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792573660;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=fli47jFOpTMq19O4Eb7tYCgI9FnYAWk67CymlppNLOo=;
	b=veLlEKuh8w/bde5FJNPM4/R11CrJRvsqndDc9AVyEe44y/rX9RnXm/88Zzu4SZy/avpN
	 C4Jj3Ea0yCrW4JviaFnqupaAY5SlIfCmMUGcOqzKk9GZjIIG09uBbcGq6vjc2Y2Vft8OG
	 5VGJVtzPOITFSrR7blK+lHaaFYRq68uE3rnYpGh/Zm+NO2b+ypY9TA0tEVJ3mRoa1buXb
	 BRdE2b6lQpb+GBC1RukjdBPjNe0yoWjumCzRyGt2PDApXT22rNylSZaWFfiHmQJFXm75B
	 ICeWROOEE9JAhkF41uxzpzemmHWyg1JewvuQZnbFsMGj+3FmrmLEzBx327Zw1oScvyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=CgOT2pPf;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BF7606A319
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 09:07:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27BF7606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=CgOT2pPf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792573658;
	bh=fli47jFOpTMq19O4Eb7tYCgI9FnYAWk67CymlppNLOo=;
	h=From:To:Subject:Date:From;
	b=CgOT2pPfF3OPbLVZ7BhAxZ7NFtjjFN20vAHGCBrrXmbCNUCMXcsA1H05x0dJCqE4A
	 +4Me+uqeXbx9t1NgJF4ijF5qcR7t8Plf59a9X8q4JBFk98SwyOv6zXwgwStoxGz42J
	 IpW/ZahRdIIsRHdpb0xsbCarM7a4VlLzWj9DytjLjtQ2VSdC4A64f2gIHjA4Z+e3Ya
	 qIJTLSSRE4U9vopwWwaItGhv2Cz04wYZoOMw05TbzDjgTu7CVsQB5fb5jwzbQqjhWc
	 nu5HfHHTGNKeSnVsk+lu9hn+X1hCrlyu8sggZN6WzD8BwZnzF1YIPgrEqyNOxBL/bH
	 cVd6Kkny9kf0A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4392260052
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 11:07:38 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_reject_ipv6: fix locally generated packet to local address
Date: Wed, 21 Oct 2026 11:07:35 +0200
Message-ID: <20261021090735.1957912-1-pablo@netfilter.org>
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

Set on skb dst before checking if this packet is in the ingress/inet
path. This fixes reject for locally generated packet that are sent to a
local address on ethX arrives through lo, really perform the same
handling as ip6_rcv_core().

Reported by sashiko.

Fixes: 73a73d442f99 ("netfilter: nf_reject: initialize IPCB at inet ingress")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/nf_reject_ipv6.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 5e08d8529cc8..91e16120b654 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -444,14 +444,16 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
 	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
 		skb_in->dev = net->loopback_dev;
 
+	if (!skb_valid_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
+		return;
+
 	if (hooknum == NF_INET_INGRESS) {
 		memset(IP6CB(skb_in), 0, sizeof(*IP6CB(skb_in)));
-		IP6CB(skb_in)->iif = skb_in->skb_iif;
+		IP6CB(skb_in)->iif = skb_valid_dst(skb_in) ?
+					ip6_dst_idev(skb_dst(skb_in))->dev->ifindex :
+					skb_in->skb_iif;
 	}
 
-	if (!skb_valid_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
-		return;
-
 	icmpv6_send(skb_in, ICMPV6_DEST_UNREACH, code, 0);
 }
 EXPORT_SYMBOL_GPL(nf_send_unreach6);
-- 
2.47.3

