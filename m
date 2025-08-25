Received: from mail.sgstbr.de (mail.sgstbr.de [94.130.16.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE515275AF0;
	Mon, 25 Aug 2025 20:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.130.16.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756153423; cv=none; b=bPzvO35weBvgXHrK/kMkG8ahhVGpiE9vLMzYy0Qv5li4FBvX4GlZKYtVO5SWM3BDBVxbRlhZUQUmzV9DvgwMrHngQ3oCJTTzSIKugmzfxkYj9GCODqEpMMdMm1xWZyBfeTyfKCRO9V15I+p5hm4O6OTaWzE8+mfwOJos8tFLOGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756153423; c=relaxed/simple;
	bh=9gF0dd0h2XiWBlQmIm+2msy2NXr1BAnnfR1pZBMu59k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aMJdKikoEtiKWZP/srnQVOtq+3WmkF66OoHX/btq/lToGmdP0fjUERX3NrOKKKZXBbMVEO0Jl3rpvs3wZxopU9Db0Y57uIC6Gf2xqZXVT2kRl200oRnsUViHL/ObMMQPuWrD4sHThyYHOajR0zzTFVeAyQi3Qcg30xVYXBO2Kzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=blaese.de; spf=pass smtp.mailfrom=blaese.de; dkim=pass (2048-bit key) header.d=blaese.de header.i=@blaese.de header.b=twSachDG; arc=none smtp.client-ip=94.130.16.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=blaese.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blaese.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blaese.de header.i=@blaese.de header.b="twSachDG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=blaese.de; s=201803;
	t=1756153104; bh=2dbN+/ubPjTAEansV5KOQruQjh4gtBDJqjkiYUH6VmY=;
	h=From:To:Subject:Date:From;
	b=twSachDGXs/dS1XbwuMpFXiRbU8PnlATvugfGPD5vUbDkhSdKlTcgOUPjSe6tTVu3
	 gnxS81toOkO4wS0DijkzPonGdCoCOMBBqvKH4g0FK1fCuQL2k9RcPMm1B00fTr0lSz
	 6mIyhBz2IPdMge2LUHaifMEI6ObS1pegm/9EZov1/Uvjq40kTXU7lJjaLw/rCx9OeM
	 T2SrqKoUErQzo38uOCwEDhEJvZWDk87QfZ2DwdDNmVDGWNL339CFhhZmVxnon/cMki
	 3t8ksCEJp3l/iolF803G1GwLs4sU2C7xIxhcrMgqTU3g0GUHJHEwBPYjqtnc1s/9OM
	 XR3X22o+5NsVg==
Received: from fbl-xps (p200300cd3f1e76004353a7342282dcba.dip0.t-ipconnect.de [IPv6:2003:cd:3f1e:7600:4353:a734:2282:dcba])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: fabian@blaese.de)
	by mail.sgstbr.de (Postfix) with ESMTPSA id 756B924B485;
	Mon, 25 Aug 2025 22:18:23 +0200 (CEST)
From: =?UTF-8?q?Fabian=20Bl=C3=A4se?= <fabian@blaese.de>
To: netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Fabian=20Bl=C3=A4se?= <fabian@blaese.de>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] icmp: fix icmp_ndo_send address translation for reply direction
Date: Mon, 25 Aug 2025 22:17:17 +0200
Message-ID: <20250825201717.3217045-1-fabian@blaese.de>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The icmp_ndo_send function was originally introduced to ensure proper
rate limiting when icmp_send is called by a network device driver,
where the packet's source address may have already been transformed
by NAT or MASQUERADE.

However, the implementation only considered the IP_CT_DIR_ORIGINAL case
and incorrectly applies the same logic to packets in reply direction.

Therefore, an SNAT rule in the original direction causes icmp_ndo_send to
translate the source IP of reply-direction packets, even though no
translation is required. The source address is translated to the sender
address of the original direction, because the original tuple's source
address is used.

On the other hand, icmp_ndo_send incorrectly misses translating the
source address of packets in reply-direction, leading to incorrect rate
limiting. The generated ICMP error is translated by netfilter at a later
stage, therefore the ICMP error is sent correctly.

Fix this by translating the address based on the connection direction:
- CT_DIR_ORIGINAL: Use the original tuple's source address
  (unchanged from current behavior)
- CT_DIR_REPLY: Use the reply tuple's source address
  (fixing the incorrect translation)

Fixes: 0b41713b6066 ("icmp: introduce helper for nat'd source address in network device context")

Signed-off-by: Fabian Bläse <fabian@blaese.de>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
---
 net/ipv4/icmp.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 2ffe73ea644f..a4fb0bc7c4cf 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -803,7 +803,13 @@ void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
 	__be32 orig_ip;
 
 	ct = nf_ct_get(skb_in, &ctinfo);
-	if (!ct || !(ct->status & IPS_SRC_NAT)) {
+	if (!ct) {
+		__icmp_send(skb_in, type, code, info, &opts);
+		return;
+	}
+
+	if ( !(ct->status & IPS_SRC_NAT && CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
+		&& !(ct->status & IPS_DST_NAT && CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY)) {
 		__icmp_send(skb_in, type, code, info, &opts);
 		return;
 	}
@@ -818,7 +824,11 @@ void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
 		goto out;
 
 	orig_ip = ip_hdr(skb_in)->saddr;
-	ip_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.ip;
+	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
+		ip_hdr(skb_in)->saddr = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.ip;
+	} else {
+		ip_hdr(skb_in)->saddr = ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.ip;
+	}
 	__icmp_send(skb_in, type, code, info, &opts);
 	ip_hdr(skb_in)->saddr = orig_ip;
 out:
-- 
2.50.1

