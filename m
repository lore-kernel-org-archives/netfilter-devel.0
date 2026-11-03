Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714597;
	b=qh7wJEkRGt0A1pJ5o6xCzW3e2JKAl3LFUKtlSY4grRzquZoGzBTnoTI/Q3vUvoF5t6+e
	 I3AlBtGvdiZbXd3AY8UE9Ozib6uZjMp3hrLHVxPL7yl9s4oH2UVnhSbp+XbWvwDrA3/SJ
	 VhzAKXFVHuInuOjL/IjB1nuqo/6MSb0NYWGwNEGCuYGPGulBKjs6SWWwDexlMtL8Q7aKb
	 giDFt31N/N5RWQzDwwOzDbiFSgm0Zskgu4daK3vYjDX/SEJCy0aNlUkhQqUyFPRiKvb19
	 ufO5QAvAOP58Lqi+qpGzBxPzQouB4BmAEswtMYbCUtx2UZD/RyM3NfIiC6i5lGc4CDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714597;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=fYx82PF450mtCVkFsMXGvGkBMko96dPNczM0QIVlTyM=;
	b=fgLvhvlXA6TuvYM+S+OhcwzqlCiwDwUmNHaMAWYj0AyrILFAPd4ANVvdpHSJynOlJvqE
	 cu0uV5Mc9WHxL1l4Bg2V2NPAArnZwXgqX03iSSlAzZCipBFeWcxmlGibje7ZtYWOhZH2F
	 c8uvDFgSmRglyTUmi2oERtWa6FV+RaEybViiTV7/XqRWndhkIz9rkT52lRAK7zUY04Ufj
	 mYYjRg2+xqv42ln3UkJmGVtJxas4LUjMo3lMcCEFYZiaz/IW6hQFPS8rw0/NK0zSlfPmV
	 0OS4g6I/S5EgGm/MlY/NgmuKnyxYwD6H0L7JzHleUBwKGspZE4Vu+SlA+hAGiarZuKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=O5PotDhX;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28231606D820;
	Tue,  3 Nov 2026 14:03:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28231606D820
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=O5PotDhX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793714595;
	bh=fYx82PF450mtCVkFsMXGvGkBMko96dPNczM0QIVlTyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O5PotDhXXb/AZTPUxSFImY8iOV6okilPDL8RfRqYzLUn+qffqt05fERLJu4wkvuHX
	 GafwSGONshQfZPN+Zq2tAPKRJvyu+VEMNQly0RD+Z83JJ3fkhw8489aSIVywP0V+bx
	 G8cTicp/EprFiCAmdX0IrQTm/j4zAMrAjM/DZf8x1Hk/Vkb+KCGSH5u+fE5QUneZCL
	 m95N9Wb+fgtVZMJuYdUBNBG35oFxYuG+ZcmGSzwED8X/IzXay7uYsD/Ni1LQteF/iu
	 QNF+iWx8ZBOWJ/kh2lpHro7lXpTucmQaDh8eNBuuFPed1zyxwLMeRQQCBK0maUUXsC
	 UEr6UXdEgjBtA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id ADE6B60090;
	Tue,  3 Nov 2026 15:03:14 +0100 (CET)
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
Subject: [PATCH nf-next] netfilter: flowtable: do not scrub as crossing netns
Date: Tue,  3 Nov 2026 15:02:53 +0100
Message-ID: <20261103140308.591690-2-pablo@netfilter.org>
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

IPIP tunneling support does not result in crossing a netns, therefore,
adopt the more conservative variant of skb_scrub_packet() by specifying
!xnet, keep the existing skb mark in place.

Fixes: d30301ba4b07 ("netfilter: flowtable: Add IPIP tx sw acceleration")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Lorenzo: Do you remember the reason why this is scrubbing as crossing netns?
There is a LLM report that is flagging this as an issue when interacting with
other subsystem, eg. packets was marked. At least in the tunnel driver I can
see this is conditional.

 net/netfilter/nf_flow_table_ip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 19cafae748ab..78bba416dd5b 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -630,7 +630,7 @@ static int nf_flow_tunnel_ip_push(struct net *net, struct sk_buff *skb,
 	if (err)
 		return err;
 
-	skb_scrub_packet(skb, true);
+	skb_scrub_packet(skb, false);
 	skb_clear_hash_if_not_l4(skb);
 
 	/* Push down and install the IP header. */
@@ -699,7 +699,7 @@ static int nf_flow_tunnel_ip6_push(struct net *net, struct sk_buff *skb,
 	if (err)
 		return err;
 
-	skb_scrub_packet(skb, true);
+	skb_scrub_packet(skb, false);
 	mtu = dst_mtu(dst) - sizeof(*ip6h);
 	mtu = max(mtu, IPV6_MIN_MTU);
 	skb_dst_update_pmtu_no_confirm(skb, mtu);
-- 
2.47.3

