Received: from mail.sgstbr.de (mail.sgstbr.de [94.130.16.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B7535965;
	Mon, 25 Aug 2025 20:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.130.16.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154316; cv=none; b=GGIpGOOi9wT06lmBvnbdPvAM/cD4xhH5ok+uBbhmHcwi4s5bLKSg/MBeBbjD4piPcv6DlQttA5+IpJjj3pgNxWtnALEciR9M4p7LbmywUPDNrqoZ9KI6Mry/h5BDnuPEYXnoReERHZygFqcNVf3jo3gawM0PxATeDHMOzfCmdwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154316; c=relaxed/simple;
	bh=W13+6u4LQTAWAcuSSKawj+MWvwHUUfX5cEqIGcLDZBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZdneqM+YvYx3gWUQTtsZJfthqhaBZLvgTuvw1hfQc/QXquuzIBylsO3hl0YCIDbtC8IQgcDQo3Vy6K7Ses9qbLpN9C/Na5tDFj2KYr4wiXDDYNmZjQg+w+Pk1ZnMOW2j+T5WBjKkQPDQyWokjAGP3e7VkRnZ61f0OLmYpoANusM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=blaese.de; spf=pass smtp.mailfrom=blaese.de; dkim=pass (2048-bit key) header.d=blaese.de header.i=@blaese.de header.b=UeXw7fEV; arc=none smtp.client-ip=94.130.16.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=blaese.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blaese.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blaese.de header.i=@blaese.de header.b="UeXw7fEV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=blaese.de; s=201803;
	t=1756154312; bh=ZS2UruvdxdddcUS6w+USGX/o4ohUJXVdBYJWX+wqSqc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UeXw7fEV2p5aldUqJs9isTusuCqlCcoX0sTpZEeKGwY2QB6KOJ5+HhA7LYxo9GIu6
	 e4TqQ3klRGV2CrUU4LgeK7mVjq0WE6VuiYXtPPg1pDl7/CCrSIyBDQl0sUm5n9X3zG
	 utpqUMKBfmbgRPo5rQDrhyWpP4eGiv4SACryl9u5vDPWnpDLb3DXedgbegDs4TBUgZ
	 XiZpOp2cnnrAo0SH1BTvbrHC1LXNu1ngfsj2kOB4aVLnZtOYL2v6sKYioP/zyIckfM
	 ftB0qAESkFOO28R4Y8716Zu2F80O6OE2Ml3d/a51Dvoo94iWncofYzzNT2Q0+zPsIu
	 cPVT9ADGkIB0A==
Received: from fbl-xps (p200300cd3f1e76004353a7342282dcba.dip0.t-ipconnect.de [IPv6:2003:cd:3f1e:7600:4353:a734:2282:dcba])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: fabian@blaese.de)
	by mail.sgstbr.de (Postfix) with ESMTPSA id B363E24B485;
	Mon, 25 Aug 2025 22:38:31 +0200 (CEST)
From: =?UTF-8?q?Fabian=20Bl=C3=A4se?= <fabian@blaese.de>
To: netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Fabian=20Bl=C3=A4se?= <fabian@blaese.de>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v2] icmp: fix icmp_ndo_send address translation for reply direction
Date: Mon, 25 Aug 2025 22:38:26 +0200
Message-ID: <20250825203826.3231093-1-fabian@blaese.de>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250825201717.3217045-1-fabian@blaese.de>
References: <20250825201717.3217045-1-fabian@blaese.de>
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
Changes v1->v2:
- Implement fix for ICMPv6 as well
---
 net/ipv4/icmp.c     | 14 ++++++++++++--
 net/ipv6/ip6_icmp.c | 14 ++++++++++++--
 2 files changed, 24 insertions(+), 4 deletions(-)

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
diff --git a/net/ipv6/ip6_icmp.c b/net/ipv6/ip6_icmp.c
index 9e3574880cb0..c6078694311c 100644
--- a/net/ipv6/ip6_icmp.c
+++ b/net/ipv6/ip6_icmp.c
@@ -58,7 +58,13 @@ void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
 	struct nf_conn *ct;
 
 	ct = nf_ct_get(skb_in, &ctinfo);
-	if (!ct || !(ct->status & IPS_SRC_NAT)) {
+	if (!ct) {
+		__icmpv6_send(skb_in, type, code, info, &parm);
+		return;
+	}
+
+	if ( !(ct->status & IPS_SRC_NAT && CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
+		&& !(ct->status & IPS_DST_NAT && CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY)) {
 		__icmpv6_send(skb_in, type, code, info, &parm);
 		return;
 	}
@@ -73,7 +79,11 @@ void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
 		goto out;
 
 	orig_ip = ipv6_hdr(skb_in)->saddr;
-	ipv6_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.in6;
+	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
+		ipv6_hdr(skb_in)->saddr = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.in6;
+	} else {
+		ipv6_hdr(skb_in)->saddr = ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.in6;
+	}
 	__icmpv6_send(skb_in, type, code, info, &parm);
 	ipv6_hdr(skb_in)->saddr = orig_ip;
 out:
-- 
2.50.1

