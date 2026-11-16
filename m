Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.97
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794867991;
	b=go2aJTH14y/PwwJItBLuOEYX2ugp66DSxmkB1lqdJt9wfuum8QGo1zZyNhJgUcz5Dg9z
	 KTxBXT+cbqOLvCILFXpvtZ0V2m4kB/A1kdZaWMvo3Gn2/fiZtWvdp6IbeGwxYMU2N+w7k
	 btiJKaGkyu1oOo/PxdMVtTTXUUs1yJF8qPZLDK37i8yke6xIiGadp/aomvqPzjWh20yUM
	 HPwH3UiHXETXXf5eFGcRgrdfcvtwjp0oWBA+J6eSR6uMT0L4xY9mj2rCTkOV0QNRxBj9M
	 nd9km9BTwu+bD/bxzNKdoOsnZplE3NE843kwJ/wkZwYWv9P/JSZNcEzYLtN9jgD0e7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794867991;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=SwgKM/LUsmyzVGglaupm2j1ixL7nRDboOcNVB38JNgg=;
	b=lj7NdCapylnFpw/97Tvsd8RQyrPfiEpY6mW2SMRzp6+fXuITzC1G7AhrLyBFVoAb2zQ4
	 90SLeur+WwD0dSSPDkan78FV8TGUBeit/kQXz/xZ/g5W+u6DRlHOlqBRa5NjnSYRmrsIW
	 EHSKyjJrB95N1ylfdgBoVUYqPoba4Wbt2dk/UcPbwo6EkcEkgp/1fJzcIy03u7PTLzH5s
	 3umZwFIsqDbYYqeGVQkv1lV9luWMUJ3PURNqtZxnyEzTu10bvV16pSE9jqzpvS7zgWcBG
	 aWFJwkv8c1NFmUjDD32DNGUhI42QkTXnSimpBmAB6adaPLryFiKBxuJ/ALe/4WPTK4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=ZXVYLoBe;
	arc=none smtp.remote-ip=209.85.216.97
Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8E9606A88F
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 22:26:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A8E9606A88F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=ZXVYLoBe
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-3ada4c06b7bso2136675a91.2
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 14:26:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794867990; x=1795472790;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SwgKM/LUsmyzVGglaupm2j1ixL7nRDboOcNVB38JNgg=;
        b=pK1/3gLC/Gau5UtVcjf7VzZ0FQwroGmp67a+Z41/WlRYRn5LZ5ej1AlnJzQtl5LgbI
         BHXCMERD3CfixB6E/bLJyE5qhqbPeCyhUNHhKpptbR+L8V8GNhdCnoPp5Rvg6N7t71Ro
         9a9NR4dvq2BJswPItIdPj81LOeZeUhWj7O9iG7L63fn6MaF6UworjPt4ozb8LwnvAcq/
         dMg/pfB+N0GXV5Z53k2GVpyjR2PSNSIyXlTkJjK0wFLqRxNljsrxGT3HGdvWfiYTPA3V
         AN+wgYzrSVvcQr7selEPhFvCywLzfS2a7nrC2QWmQlBKhDrdao8OyKFESaYqHGCOjutD
         lywg==
X-Forwarded-Encrypted: i=1; AL+hErHfppS8qzWla2Mx1p0FxV3fc/J7jTkbGLy1wwopBwp1WCofSBhATuwR0g6mnPay5OUI6SSbeMkj8K7iuTQIM2U=@vger.kernel.org
X-Gm-Message-State: APuU4Z+4OvV4HtPKksH6lhRTT6i7fr59tkaMGlmRL/td8/7rR/xxWVuB
	3FkmJMyc2kSEZ2W/PVfqHw21Xl1aPsIM9nPW+ztavtu+7HrbpfOpv34sY5swlKTj7aIE8D0bUA3
	l5QLKFXu6pGExRY4MlfkmYMNxz5i1PaSUX8N0qweraSTj3gYHikxJkagFgPglmpiaU6Y9t5Pt0h
	n+WZoqAIRggmQ98dScMuJheV+sUeLNBWXGqtkywojSdzNwovgoQUyYBH7R5Wmhd8tPB4s6Su3n1
	hwvlbiCgHUAcnCqwHQW61WZmpHR
X-Gm-Gg: AZFdTZeDFsduCpjI4btQIL/Enr2fNJkW/9tQZ+7qZmYArVDLTDz9MmxJg1kLN/M6uc7
	TCYzxUXfRBZmoGzNfwNEBnJjr4yqCzudgl57gGYPpsnOfDQVcAF24Sn5xxNg6ILv0vZk8fNlOVE
	Meu8N83Z76u3UgmWTa6dPO34Uwb56oZhA9doawwZsm34AmLOnGkaqX3XCAoD3rG0NjvzNwGBFCW
	9Qwl4+A+KQJsXWAisbBvgzUeLYPgRorZd2jRghBm1BM6ht7W4chFNj/B+TjPtdOIzOI5nQA/HzW
	e8sxhQQ+0/oAdcj7hjHTwEkFge5h2MNSdjPxJb3xRJqts2apHzgI4mjL6p1rAo0pGLAdsBuSpyv
	C6peek9HCU1Uuzjr5lnwygmeSDxeiE2DQ0P3m9xBr+jrF2ux/Z7YoXowszlVdceNz/JGzncd4Hf
	NKQxqJ+16fIPmiqLfywmrI01/8pff2lmgXWHF0UO6L9OM=
X-Received: by 2002:a17:90b:2251:b0:3a0:7261:d58e with SMTP id 98e67ed59e1d1-3b1b0a408bamr12128166a91.22.1794867990103;
        Mon, 16 Nov 2026 14:26:30 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b1b335bdacsm6255663a91.1.2026.11.16.14.26.29
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Nov 2026 14:26:30 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-1b3ae17c536so3344216c88.0
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 14:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794867988; x=1795472788; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SwgKM/LUsmyzVGglaupm2j1ixL7nRDboOcNVB38JNgg=;
        b=ZXVYLoBeyjKuwDQQHfurKC/93+dEugF/FYFfNiIwPyyiWcQZ3lc4Z49np2Y8lLqFJa
         x14+TMrqyNZ6Ljz0yqlI39wpihU5gR1eq+/T7ksrIVVe+S6b2fKwf17Df5d8L9tmqYPA
         sJZUfmYkx53VWsG9RFS0ITZvAs3EWrL8Y36nE=
X-Forwarded-Encrypted: i=1; AL+hErGrANbNINtFaylovstcy4mWf/6Mh4U3/ftPdELqFOIWucbNqt18RzYDJSe+e2aOheWWUVQlHY4rQLgMoHs0QKY=@vger.kernel.org
X-Received: by 2002:a05:7022:7e86:b0:1b3:8814:8383 with SMTP id a92af1059eb24-1b5030e77efmr10964759c88.9.1794867988114;
        Mon, 16 Nov 2026 14:26:28 -0800 (PST)
X-Received: by 2002:a05:7022:7e86:b0:1b3:8814:8383 with SMTP id a92af1059eb24-1b5030e77efmr10964713c88.9.1794867987246;
        Mon, 16 Nov 2026 14:26:27 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379560f5e06sm50176624eec.19.2026.11.16.14.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 14:26:26 -0800 (PST)
From: Florian Fainelli <florian.fainelli@broadcom.com>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS),
	linux-kernel@vger.kernel.org (open list),
	linux-doc@vger.kernel.org (open list:DOCUMENTATION),
	netfilter-devel@vger.kernel.org (open list:NETFILTER),
	coreteam@netfilter.org (open list:NETFILTER)
Subject: [PATCH net-next 2/9] netfilter: flowtable: reject non-host IPv4 packets before lookup
Date: Mon, 16 Nov 2026 14:25:12 -0800
Message-ID: <20261116222519.1416501-3-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261116222519.1416501-1-florian.fainelli@broadcom.com>
References: <20261116222519.1416501-1-florian.fainelli@broadcom.com>
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
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The IPv4 forwarding path rejects frames whose packet type is not
PACKET_HOST, but an installed flowtable tuple bypasses that check. A
packet addressed to an unrelated, broadcast or multicast destination MAC
can therefore be forwarded if its IPv4 transport tuple matches a flow.

Return to the normal stack before the flow lookup for non-host packets.
This preserves the IPv4 input path's forwarding decision.

Reproduced on BCM53012 using an active UDP NAT tuple: classic forwarding
dropped the unrelated unicast destination MAC while software flowtable
forwarding transmitted it. Boundary tests cover TCP/UDP, both NAT
initiators and unicast, broadcast and multicast MACs.

Implementation, tests and changelog prepared with OpenAI Codex assistance.

Fixes: 97add9f0d66d ("netfilter: flow table support for IPv4")

Signed-off-by: FLorian Fainelli <florian.fainelli@broadcom.com>
---
 net/netfilter/nf_flow_table_ip.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 19cafae748ab..98bade1b8299 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -911,6 +911,10 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	};
 	int ret;
 
+	/* The ingress hook runs before IPv4 rejects non-host Ethernet frames. */
+	if (unlikely(skb->pkt_type != PACKET_HOST))
+		return NF_ACCEPT;
+
 	if (!nf_flow_skb_encap_protocol(&ctx, skb))
 		return NF_ACCEPT;
 
-- 
2.53.0

