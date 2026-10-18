Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F854308F26;
	Sun, 18 Oct 2026 00:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792285028; cv=none; b=cqHQzioNvov9v081CbqWRyIzVjjZPN63kRA0v+LdpfWuPZhi4bHViTx/VVzQ2yoYX4aOx+SeCmjYJzRzG1U4HHSJmL8KVgbjKXLpkbdgnfsyW0u7ExPNKUM5cCCKmY/2yBYtuUhSHUQ/v3pegpvfHuV0e0kI/R4VP9an1pKiL/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792285028; c=relaxed/simple;
	bh=M8EiWmnZPblM9PRYIkf275JcEMCI/XIBLaF9VyXMPSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uSkVDxuUFN0FVGdGaOu65pnikfAw9fFENaefmLo1VPMJswCVsiLBr4rUcpo6HxiodQd0dyfjnnWKqqDXrOlPYsLJLajHA6zaK45ngl1cUfnFE/RX8MmxzHnHPOMAIWuohPPFg81AK5jOT/IlYaTYVeNFA1pmIVn+H3a5qabwyYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XnAq4c5j; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XnAq4c5j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792285023;
	bh=Br3P5vkq2nYPAa+oveIQfLLzQmD/uC7QmebOvbDBymE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XnAq4c5jm6JC7QWWABpmhHzWb/Dkw/XewCAhkPC3ZO5E1ATMkhUaiu+Sgx0Pw6TKz
	 BatbDwwz+fFeyjqvQsET1J4y2ElZ6Nzz3mzy13CmmbreFdyh4Cyiqui6O6BXKImFZ1
	 0F6Mw/i/bTrq7ALeOFB2Zl46aE377nJ9a/FA2oI/Mz+TKILzODFMuJ7rHNbyT4pPw/
	 sxJAoYADyqCwAEMcJpyHQ5erTXlgKbU5SFis0ZqhaiyFGrKSwNeRwYTp1hROmc3Tqb
	 mqu4IUuNR3ytWo96oZbMW19pXTn2r2NWoJiqiYLKCwJX6e+NSR0xrgvTVb9vFpRG/l
	 sUDRgi7H2skdg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2335260081;
	Sun, 18 Oct 2026 02:57:03 +0200 (CEST)
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
Subject: [PATCH net-next 12/15] netfilter: flowtable: set inner protocol when popping tunnel header
Date: Sun, 18 Oct 2026 02:56:35 +0200
Message-ID: <20261018005638.1776148-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261018005638.1776148-1-pablo@netfilter.org>
References: <20261018005638.1776148-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

Pop the outer tunnel header and set skb->protocol to the inner protocol
derived from ctx->tun.inner_proto in nf_flow_ip_tunnel_pop(), instead of
bailing out unless the tunnel carries IP-in-IP or IPv6-in-IPv6.
This is a preliminary patch to support IPv4 over IPv6 and SIT tunnel
flowtable offload.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index c8c29a9a1684..29d1a9f4a362 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -372,6 +372,11 @@ static void nf_flow_ip_tunnel_pop(struct nf_flowtable_ctx *ctx,
 
 	skb_pull(skb, ctx->tun.hdr_size);
 	skb_reset_network_header(skb);
+
+	if (ctx->tun.inner_proto == IPPROTO_IPIP)
+		skb->protocol = htons(ETH_P_IP);
+	else
+		skb->protocol = htons(ETH_P_IPV6);
 }
 
 static bool nf_flow_skb_encap_protocol(struct nf_flowtable_ctx *ctx,
-- 
2.47.3

