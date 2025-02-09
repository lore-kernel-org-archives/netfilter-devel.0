Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAEB1A9B27;
	Sun,  9 Feb 2025 11:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739099452; cv=none; b=gGYhyX2dpttBKUJdNVX4yC6tO8ALfb3eLeVWCnlUrXlrGEGW+5Hop1aOAD0qi8G9cXHPrhknQkC0Eyz1TxMLFVYZbsPq8/gZuXa9lJwhfj8uu9Gy7P8su7zB6tuBXZo2VZETsH4ubfthZk3RlTHqykMZ7xWq1FxHkXtGXcrCl6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739099452; c=relaxed/simple;
	bh=WOvVk2IW6QUSaxpGvpwW6W6ywpdv9Y60/i896yobQ+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4z7MHhLqiwXkBZ+o2j1aacf3S/P+BA3TURl9p4X+EDLzESIE8sZkxR3Hi9bn78UknP9BiqHwsG+rohLTdsrQ/aEtNVe2d8xDX0WGurEO4LcvFNNXnFGtWtIQRDElrCAuDvdOXBnzNsSYvcVc5VyyiaxW3n0/V2xzQfKHnEKJqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DauT4Krk; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DauT4Krk"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ab77e266c71so471178966b.2;
        Sun, 09 Feb 2025 03:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739099449; x=1739704249; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ukwtTV0ExXBJKM7v4LhbJXSMG6hQJqW8GgzzDxNF23M=;
        b=DauT4KrkVrV6NwHizVLsWVHaeNc1w68DOWSLfoFb064b2HWpgUEc2+O8RQSHtn2FBi
         8zs/B2XvXMjqTxtq5L8shX5xnPo5Ej29VPWNS7LNlZQO/wpazfxtebbMMmrKAmeSkc95
         SwwWgbVHPQeqR4oqKF8m/HmI6/6MzC6NuF3URCPAZR5RiYa/mYNYtZBO6JLLpQFmZZIc
         EPUdIMWPW3Rif/zXMYYMrpN8RRLY7KI2CAd4AIYgvkGda/Zfnm973wHvB62eiirbb+Qg
         sZstbACKlo2lqh0a4uEey3i6nFwXSWP8MTa5Qi9AZ+9F1CvKYWuWuJTAdIftpv2wZX2d
         lysA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739099449; x=1739704249;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ukwtTV0ExXBJKM7v4LhbJXSMG6hQJqW8GgzzDxNF23M=;
        b=TqD4nxwr0WhPnL26y9hfCRmV4T62kWAfGIPRwX8ftFSMSdIy8gCjmYWFKJ9dUfEk9P
         ApMMvVAvu4PHW4tMBobcWvegDYCDRfOFg+Fc37pOIsv4PjBiP7DeKD88I1IQ/wAkaCVs
         xFmRh1ZHnzAmDOXi9eoQv9Si+MAQDMey5LOatLdaqDZwlz1UxADdAiwWOKGJCC2LTRJr
         8bK61zccsOIU5uUsqEjnbIjyn2c8+9mXJpvEf7864G1DPDz5vkS39SHc3Qrxhfz+ZOAv
         KKv2qQZaYYz5MnA2bpZcOTC4YZEFUNViXklca+kQNI/Li9pFeBkPIVmqnBzHocDbHXT0
         rxNA==
X-Forwarded-Encrypted: i=1; AJvYcCVEMTIDn7I4aXIpVKUw+u8JxzDTygHwLTth3sFKJaWHIq26ZxSpK4isA+AHYWHdnvMrG7imTNMTvMd/J712fCcL@vger.kernel.org, AJvYcCXNY9CzV0OznGmyZ9ZRVcCpBdMmWAVOYSzE6Sc/PiiciBeZ4i8a88HtVoowS8crgFo5GwdUlkBIXPjPD2Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZOzI7quRHLhA8MTDTYpNqGPxxz3VfyZ4EJBoPH3Wfq6kmMhJM
	43M3DyrjFEPlwW6nZI4E/miDtGWFr2B4h3KgzE2PG4ftSbyEJSTp
X-Gm-Gg: ASbGncu3PiI+RzH4Z7GF0ZQaVPpOEw1WvVIohjc1q8X/zfFTfTeiDNX+MaGEYYGnBT6
	h6+L+umW+L+imTimKbzUUXLdrXoa2Lmfl1PJMnRm2ujGitGnjA3au0/U7hJcIijf2TCE8oGEnzq
	CVBwVKKu18BLXzYsqzc7++lNc0oBa+xgEfaGz9ZTqczewF7DuzShIKIhj8i4zOI8AdqN6DD6DXn
	8wupLHqKR0h4nEbvQgfwTeOkyZXLsGNbrgwBv1Np60kIopD8OvIJkOKyBn6AGiJahPlGJZUwqUI
	LWzfDlcDTP20m8IwLT5MXzwBauzL8IDkNbK3iR0JYCtK+F3Ks8XYn3XxmXtGjQeUdLpNWWmcSG7
	Lw8S1+Q73X/+ZJ6TPda1EztNE4fxOExWR
X-Google-Smtp-Source: AGHT+IFQ0RozlZVD0Ur8OeqIX9zHHE/nY2BIcLmW4b68G+IKqL2kYQbbZ+HNgEJWAQaRsfBoOg4giA==
X-Received: by 2002:a17:907:7f08:b0:aae:fd36:f511 with SMTP id a640c23a62f3a-ab789d3431bmr1087121966b.47.1739099448924;
        Sun, 09 Feb 2025 03:10:48 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab79afc7452sm357516366b.163.2025.02.09.03.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2025 03:10:48 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Joe Damato <jdamato@fastly.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v6 net-next 04/14] netfilter: nft_chain_filter: Add bridge double vlan and pppoe
Date: Sun,  9 Feb 2025 12:10:24 +0100
Message-ID: <20250209111034.241571-5-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250209111034.241571-1-ericwouds@gmail.com>
References: <20250209111034.241571-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds the capability to evaluate 802.1ad, QinQ, PPPoE and PPPoE-in-Q
packets in the bridge filter chain.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nft_chain_filter.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 19a553550c76..7c7080c1a67d 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -232,11 +232,27 @@ nft_do_chain_bridge(void *priv,
 		    struct sk_buff *skb,
 		    const struct nf_hook_state *state)
 {
+	struct ethhdr *ethh = eth_hdr(skb);
 	struct nft_pktinfo pkt;
+	int thoff;
 
 	nft_set_pktinfo(&pkt, skb, state);
 
-	switch (eth_hdr(skb)->h_proto) {
+	switch (ethh->h_proto) {
+	case htons(ETH_P_PPP_SES):
+		thoff = PPPOE_SES_HLEN;
+		ethh += thoff;
+		break;
+	case htons(ETH_P_8021Q):
+		thoff = VLAN_HLEN;
+		ethh += thoff;
+		break;
+	default:
+		thoff = 0;
+		break;
+	}
+
+	switch (ethh->h_proto) {
 	case htons(ETH_P_IP):
 		nft_set_pktinfo_ipv4_validate(&pkt);
 		break;
@@ -248,6 +264,8 @@ nft_do_chain_bridge(void *priv,
 		break;
 	}
 
+	pkt.thoff += thoff;
+
 	return nft_do_chain(&pkt, priv);
 }
 
-- 
2.47.1

