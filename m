Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794532499;
	b=ycUE3pccM1f0URjSXvxjUHsMNgJ/4iwadavAodOu81HWpVBa+hGloUrs2zwPxPRDbjBQ
	 EuDbIeTkfYrREzz57K8OllHyj4I2rLwbGKs9vxrcrQXv6WDXuu5TXIO0k0c30DjXzuxI8
	 4ugenR4RWXbI1NTKs5zXuU01zOhx85wnhjImzgbCUVnTcp1vZzuC4EiQpBPpiImurI0da
	 AI5Dl8HPd41HqqkM49m9Jwbsn8j9SftYrWfpwz07BDtBc/2yo2eJRRfJW6tSKjfRp35LT
	 RovTEE8fZ4tfeK1+frFN8UNP2/28iSkDK6zjgOURr/TfShhCzsMP18rhTZe6m2MwyFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794532499;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=v41bCtFzAN8QCeZS7l5n270HMrE/5hpeD/4liMHjCLc=;
	b=eSBxkTzSi7wK6NGipg5OgELxz3Lg/36CjdVT9g5B6iBCIygJFFQSutS9ZciCbxQxcLvG
	 tUW2KYbnqKbvr9tZSaz5OQrB4xfHSSlba4Ek7L9K/0zStoCcARrbnw2L4pYiD77JX+g54
	 rDhdiFlV2bVmK5FHfSC4YLz5VC0PmOEbxuG8+AvWUOzDvqye07lmkQ4WKDqBDn0O2m7lq
	 NPr9tfuJ6CbpR94+BgM/J8/cBc/gS4MpOAnX9qVdNSp6zurC035baAHfhwLIydLcBdJzt
	 p+ZDuMjtiyT0Nli2W7glhUOG3EOIIV4XscjNr0Btahlr76Ecy4KHsUV6SHIB0xgkJZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Bib7dVBb;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E7A606A32D;
	Fri, 13 Nov 2026 01:14:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57E7A606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Bib7dVBb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794532497;
	bh=v41bCtFzAN8QCeZS7l5n270HMrE/5hpeD/4liMHjCLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bib7dVBbtrdTbVqf5l5iCnBHemKa//P/geKMjijFPdMaN9a0ar4FIo2XjxnyKGVDw
	 ux4ePkK3OEo98ZLT1Ff/+9ouQrLauBqwlBVctH44AyWKhINfVT+e/ABPFdp7s9S3yH
	 IQK3nir2sZNOZPC2s5fJ1TEevVzxHJiAuQLG2kCHC6uu+LUoTbBMgYXy2sqZyADvfF
	 7V6Q49QEJkL99G+ig/3hYT4HiKYHZy9sZhbECWniRdu7WWmLJ28illsIEOWGLfraEc
	 upV8gTgme8cCxg/K3YSWt4aSpLLbo1ydMuSeH4q0+ze1jh6aCvJ+yuTr+RWUPumDJ/
	 IIfToUeOBOCCw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E2B286005B;
	Fri, 13 Nov 2026 02:14:56 +0100 (CET)
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
Subject: [PATCH net 01/15] ipvs: avoid out-of-bounds write in ip_vs_nat_icmp_v6
Date: Fri, 13 Nov 2026 02:14:33 +0100
Message-ID: <20261113011447.2357709-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113011447.2357709-1-pablo@netfilter.org>
References: <20261113011447.2357709-1-pablo@netfilter.org>
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

From: Axel Mierczuk <axel.mierczuk@1password.com>

ipv6_find_hdr() does not set the header offset for non-first
fragments, so an ICMPv6 error embedding such an ESP fragment leaves
ip_vs_fill_iph_skb_icmp() with len == off. The NAT paths size
skb_ensure_writable() from len, and ip_vs_nat_icmp_v6() then writes
the embedded addresses after the validated area.

Include the embedded IP header in ciph.len at both ICMPv6 call
sites when parsing stops at a non-first fragment. ESP lookup does
not require a transport header. Non-first TCP, UDP and SCTP fragments
bypass IPVS ICMP handling before connection lookup.

This fix does not depend on patch 2. Stable kernels without commit
342e24a339b9 ("ipvs: do not mangle ICMP replies for non-first fragments")
also need that commit to handle incoming ICMPv6 errors quoting
non-first ESP fragments.

Fixes: 63dca2c0b0e7 ("ipvs: Fix faulty IPv6 extension header handling in IPVS")
Cc: stable@vger.kernel.org
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Axel Mierczuk <axel.mierczuk@1password.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_core.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 8a3c880fdb26..76213159404f 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1206,6 +1206,13 @@ static int ip_vs_out_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
 				     true, &ciph))
 		return NF_ACCEPT; /* The packet looks wrong, ignore */
 
+	/* ipv6_find_hdr() does not include the embedded header for
+	 * non-first fragments, add it so that ESP can pass and the
+	 * NAT writable checks cover the rewritten addresses
+	 */
+	if (ciph.len == ciph.off)
+		ciph.len += sizeof(struct ipv6hdr);
+
 	pp = ip_vs_proto_get(ciph.protocol);
 	if (!pp)
 		return NF_ACCEPT;
@@ -2036,6 +2043,13 @@ static int ip_vs_in_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
 	if (!ip_vs_fill_iph_skb_icmp(AF_INET6, skb, offset, true, &ciph))
 		return NF_ACCEPT;
 
+	/* ipv6_find_hdr() does not include the embedded header for
+	 * non-first fragments, add it so that ESP can pass and the
+	 * NAT writable checks cover the rewritten addresses
+	 */
+	if (ciph.len == ciph.off)
+		ciph.len += sizeof(struct ipv6hdr);
+
 	pd = ip_vs_proto_data_get(ipvs, ciph.protocol);
 	if (!pd)
 		return NF_ACCEPT;
-- 
2.47.3

