Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422189;
	b=MgVyFFLwve1eqfAJ6gRb2atNoYRpL/hiPnqpsYUBamJKgNMx/XXBIy0phwmEj4SNZ/fz
	 TWC99Q58uhm9haAEb5mRijECozMpi32kCwVkJNvWc1DWp06vBzyJuYjTm0IMDSM/d3YBQ
	 qe+8w8gbAlDXxQU9muYZm4WhLL3lJV7YKjZ5/TxSvxLwTswwM00uLu+AldnYx61tG1OrZ
	 GcEzMCdRe81/uixS0KQ/0HRQdLT9uw754eg8zIvSeMwiokHA8B2FHLsEmoGMphl/NMib7
	 OnAZCQtcO4m3DweBPXXAozc6aoLvHbciGBew6oAHdfkfIRBMqu6jXqS3Gd09A1ulzOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422189;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=c5/ToZfD4LQ3CMw/UKyWzuZvE6sEZcZAHHntN38m0WA=;
	b=ChlA+FtwRt0iPXV40aZYjAergGEojJT1gfAgylECsHH1tZdz9TSIqZlb2VMEyzqhd7K2
	 hcaT++sTg4vOyw0sxm0cHFo7z+EIOHUn8a7STiOtYUhASHutLLHnFgdwwULNmmKqpGaSC
	 U8XDzmSCsiZ01MEoFEIZ5C8sCTw24ClMRSE6ZvpNUfEZsCWnyu7h5lTRuV+36MBS0kjo3
	 eRbgK6vkxaZwUAIOtnuxo0n23IcG56yFXcduFkmqGttx+E/w6VjAOfRW/7bX8D66b0c2q
	 Vxuk4a+69IXMTvBXJHTHp1Dk59yGDhQMMQNFdyPErR/5lnmbTrIlqm/zVvEznctxnug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="cHon/KjN";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5616C607D355;
	Mon, 19 Oct 2026 15:03:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5616C607D355
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=cHon/KjN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792422186;
	bh=c5/ToZfD4LQ3CMw/UKyWzuZvE6sEZcZAHHntN38m0WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cHon/KjNKCRlfcO6PzWmnwvquPNdLNPJV16BWf5IWyGGaa6cNbsKy05dU5/hrFN4j
	 KLoKa9paVT62GDBqJTrWDddldc5ow4eVa0iYcw3dJ9RAyoYnBuSWcSs7jD/2wq7Tf/
	 7O4eDqfYsoMYPWnXysy/DeI1kCY4Loz1YH0M70wna3HjY/40lpUnIQlrvMjmkf3XO3
	 Hd29zwSSsCEs9MF8RIoeo390zSY3zqQuPlOgXQG6jE+mS+p+okr8lKTeKfWH5/LCol
	 vFHVZpd4rCuvw2r2PXP9lO08DeQ431U8/fFZpTN5g9jA4PGJx0AGROJ7hl4PEUe8T9
	 JYvXPlekaJN3A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0041560076;
	Mon, 19 Oct 2026 17:03:05 +0200 (CEST)
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
Subject: [PATCH net 06/10] netfilter: nf_reject: initialize IPCB at inet ingress
Date: Mon, 19 Oct 2026 17:02:45 +0200
Message-ID: <20261019150249.1879516-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261019150249.1879516-1-pablo@netfilter.org>
References: <20261019150249.1879516-1-pablo@netfilter.org>
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

From: Kyle Zeng <kylebot@openai.com>

The inet ingress hook runs before ip_rcv_core() and ip6_rcv_core(), so
neither IPCB nor IP6CB has been initialized when nft_reject_inet passes
a packet to nf_send_unreach() or nf_send_unreach6(). skb->cb can
therefore retain metadata from an earlier protocol layer.

For IPv4, icmp_send() treats IPCB(skb)->opt as parsed IPv4 options.
Stale option offsets can make __ip_options_echo() copy an
attacker-controlled length into its 40-byte reply option buffer and
overflow the stack. On an unpatched v7.2-rc5 kernel, the IPv4
reproducer produced:

  BUG: KASAN: stack-out-of-bounds in __ip_options_echo()
  Write of size 255

For IPv6, icmpv6_send() consumes IP6CB(skb) as parsed IPv6 metadata. It
always uses iif for source selection and, when MIP6 is enabled, uses
dsthao as an extension-header offset. These fields must not be stale.

For NF_INET_INGRESS, clear the address-family-specific control block and
restore its input interface before constructing the ICMP error.  This
matches similar initialization normally performed by ip_rcv_core() and
ip6_rcv_core().

Fixes: 117ca1f8920c ("netfilter: nft_reject_inet: allow to use reject from inet ingress")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol Codex:gpt-5.5-cyber
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Co-developed-by: David Lee <david.lee@trailofbits.com>
Signed-off-by: David Lee <david.lee@trailofbits.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 5 +++++
 net/ipv6/netfilter/nf_reject_ipv6.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 59ec465a9df9..7cb33af671e2 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -357,6 +357,11 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
 	if (!skb_valid_dst(skb_in) && nf_reject_fill_skb_dst(skb_in) < 0)
 		return;
 
+	if (hook == NF_INET_INGRESS) {
+		memset(IPCB(skb_in), 0, sizeof(*IPCB(skb_in)));
+		IPCB(skb_in)->iif = skb_in->skb_iif;
+	}
+
 	if (skb_csum_unnecessary(skb_in) ||
 	    !nf_reject_verify_csum(skb_in, dataoff, proto)) {
 		icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 07cdaa10da0d..5e08d8529cc8 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -444,6 +444,11 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
 	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
 		skb_in->dev = net->loopback_dev;
 
+	if (hooknum == NF_INET_INGRESS) {
+		memset(IP6CB(skb_in), 0, sizeof(*IP6CB(skb_in)));
+		IP6CB(skb_in)->iif = skb_in->skb_iif;
+	}
+
 	if (!skb_valid_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
 		return;
 
-- 
2.47.3

