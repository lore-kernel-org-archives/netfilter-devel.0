Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1B343BDC2;
	Mon, 10 Aug 2026 19:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786388808; cv=none; b=qLnzOeTd5aLFqidcBV5gW6l//k33asCBr8t+SrxzFWhcDWNybWCQ3yDZAIQJ4zbHLUlOLMDxyBT/iQjugewpwbjfFVNbSKj82VRagTuIPpj7i/xLLlcsMKvH+bwPh1vaimUEV4VoXURtP/+bGziboznrlU6lhzNHeoLTViK+5Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786388808; c=relaxed/simple;
	bh=X7egvmQOhrK0H5GE0yOQ0pRV/Nvcw0aCufRWITgqqdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUjEma5H+kj0bGT1kFigb3oTin5Xa1z5e37PENjPy23K3KV1YKZUzQCxl7oOEC09lIeTb7d08gvnCu5T2FAVkIpn7tmdi/4gdAiOT0m0PJnttGkatASOEiqyRaN73yHD3JwMfJEFnRXFWHD440gs2gwX1smOltAhUMFVGlaOOHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QWeFh5zK; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QWeFh5zK"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 97140601A2;
	Mon, 10 Aug 2026 21:06:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786388805;
	bh=cYh50l4l7a1UtKivV6jGuwD3q9YyWelEZeUWDE6uiwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QWeFh5zKS3NeMaxPYJJBP2IbxgfOVS4nXWMvoAF+JiBy8EdeHlKJ6WIKQmt6RDDT+
	 3tXZcvJIj6pzDjPwu895/cOQzsHGTPQedWlr/Esax9Dh0hk8jc24b6mKD+SX7raNgC
	 lMp7zglZVthXeY/pwAJ9ZiQPNcu9RytcVGmxTgn16Pys73FnTN9suXND0f/QU7n+c9
	 NZeGfeoaYbIrUzK1jNByBiTP+izyCRp39ShoaYN5uZ363EFpGBFdPsTLibw7l4N2KU
	 yADDFkmavO6Bu/Ot3dZOUKmyV5s0kSjSoBj7YYo9rvEn90FO1b6MitV7uimly+Tjq3
	 UTMP8dVjjhBwg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 08/13] ipvs: clear IPv4 options after rebasing tunnel ICMP errors
Date: Mon, 10 Aug 2026 21:06:16 +0200
Message-ID: <20260810190621.894119-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260810190621.894119-1-pablo@netfilter.org>
References: <20260810190621.894119-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kyle Zeng <kylebot@openai.com>

ip_vs_in_icmp() rebases an skb from the outer ICMP packet to the
quoted original request before passing it to icmp_send(). However,
IPCB(skb)->opt still describes the outer IPv4 header.

A timestamp option in the outer header can therefore leave an offset
that points into the quoted transport header after the rebase.
__ip_options_echo() treats a byte at that stale location as the option
length and copies it into the fixed-size option storage on the
__icmp_send() stack, causing a stack out-of-bounds write.

Clear the stale option metadata after resetting the network header.
Keep the remaining control block fields, including the ingress
interface used by the ICMP response path.

Fixes: f2edb9f7706d ("ipvs: implement passive PMTUD for IPIP packets")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol Codex:gpt-5.5-cyber
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Co-developed-by: David Lee <david.lee@trailofbits.com>
Signed-off-by: David Lee <david.lee@trailofbits.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 95af77b68851..a46e7acdd8e1 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1950,6 +1950,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 		if (pskb_pull(skb, offset2) == NULL)
 			goto ignore_tunnel;
 		skb_reset_network_header(skb);
+		memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 		/* Ensure the IP header is present in headroom */
 		if (!pskb_may_pull(skb, hlen_orig))
 			goto ignore_tunnel;
-- 
2.47.3

