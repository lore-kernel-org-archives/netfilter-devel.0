Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD86A403B16;
	Mon, 10 Aug 2026 19:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786388799; cv=none; b=RGAQESSnBzFuEKAHw0tEElNyklKQJH8tL0f/Lv8zocVAuxvY0RyN719tsuZjg58uKmsfCcnPncsevAFC7Zw48CaecNvIbemQcgfxouAGHoy666kpjn5Wjeh6Y5Ag26rKgZiOi7h8UoLR6+jBVsjLM38ns5kFmV5aOTufN9y79XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786388799; c=relaxed/simple;
	bh=TtMm2V1adrk/Fu4dBQ2TxGaGUh+avHJS+EKJ6nQAhIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPR4ie4CJ5T3hIFMQ8cEF97HmlD3g0q8MFtzTAyT9eBpOTQ6urtyZPga05xvlmpfZI18NYQOGEZ/R85Z16SaCELjCBQ6X3xLVhHZqPP81OH6ZQIhM9TafGaRb1xODj+Vs/uCT6ko/BgtCH6SuSOq2rcRQStbHce0Y15kipjKgQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HJTYHut7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HJTYHut7"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6FB846028C;
	Mon, 10 Aug 2026 21:06:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786388795;
	bh=8++R/2iznXdOEmAYkDHQV70losjaBclxOPCCVRm/8iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJTYHut7SF6TGQLIl3IUb4lNCa/eWb3iq1fetXZ23WMnuDL1N+eFXKF92z6OcTNtZ
	 LtKmJz1dQqi+jrR4W/ma+l7O1o2gPQEAVzokgwgF1/OZtEStQrVo37yaSLZPw46jdD
	 EtG6Efm0eXEA+I5bxQKHwlBUdeGMcDQx3BWNmTeMGX3qP7erHx9XGUPE+BCi0F65jS
	 wxKIBVodbt2zkBlUBYLT0jBCIYsD5ZkGuaaAqjY8B8glLb0Od7ydFNvwTwrzT+GPEq
	 B819peuEFWD0rdZr1hnZkQ8a5TaOaHFxE8h7karPX++Ow6v/r6LkuTTr0njraWPeXa
	 SsraEjsQCDCbg==
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
Subject: [PATCH net 02/13] netfilter: bridge: release template ct on non-IP path
Date: Mon, 10 Aug 2026 21:06:10 +0200
Message-ID: <20260810190621.894119-3-pablo@netfilter.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

A bridge nftables ct zone set rule can attach a conntrack template to
an skb before nf_ct_bridge_pre() sees it. For non-IPv4 and non-IPv6
EtherTypes, nf_ct_bridge_pre() currently overwrites skb->_nfct with
IP_CT_UNTRACKED without releasing the existing template reference.

That makes the per-cpu template, and any temporary templates allocated
for concurrent use, unreachable and leaks memory until the host runs out
of slab.

Reset the skb conntrack state before marking the frame untracked so the
existing template reference is dropped on the non-IP path.

Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 58a33d0380b0..7ecb8a26bfa3 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -280,6 +280,7 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
 		ret = nf_ct_br_defrag6(skb, &bridge_state);
 		break;
 	default:
+		nf_reset_ct(skb);
 		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
 		return NF_ACCEPT;
 	}
-- 
2.47.3

