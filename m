Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9ABC276048;
	Fri, 28 Feb 2025 20:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740773786; cv=none; b=MWLtA07tLKfBGhZXW7+jdr1aHJcGiou1Ibr/LTL67QkCy8xCUpHPanb6R/AA6etMl4c5r+Z3qLuPrI6feYxqqMFCTnJjsvikMbgEmv+I3BP7+GIgEFmioRL98Q8rxJ+fnXU1DdzbwbwW5cji3+Hqu3p/YECODUyugLTS+ZPtAN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740773786; c=relaxed/simple;
	bh=WOvVk2IW6QUSaxpGvpwW6W6ywpdv9Y60/i896yobQ+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fgdGuTqYWflDygh9otcPww5Tas1g0rYnfM9hhI9LGafBBYxeoUxNQvUk1Y5p+lb8cR2v3qo7b15e8r86xtWy6kke1SB26pH8Po0wBcb6JvDjbV40kYx/7LPSSh4cYp1LU+SyUZaq6ovdEQkkd5qh6gd6P2sCvtPzE3NfKOtaowE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PYqtsMwo; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PYqtsMwo"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-aaec61d0f65so517566066b.1;
        Fri, 28 Feb 2025 12:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740773783; x=1741378583; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ukwtTV0ExXBJKM7v4LhbJXSMG6hQJqW8GgzzDxNF23M=;
        b=PYqtsMwo55Ka9ZfioqSdLw4/uGYCkziRwrZX5FK2yf4zB9IqrhSYruMwqQRQNDOBWp
         p+20/FMn85m77XtFL40JPL91kkpuFhDfS6Fk4C3HFEPRX4agudMbO4/nR6XYVRdVojhE
         17kR2VGczg0Cni7SjUdyNzaYH7hDZPXr1YYm+1J+x197bAqz94Icb3M7qPntUuCPg9hl
         BjDaT5TCdPl+zXNBiug6cFcmmEzoaJhP3+rBSOq+VTQmJNVyWGxx8DR7ynkM+3wB4wdR
         0vKg24e9jhR5FNy+CZTj9Vl3+38wZWstwDxlRJ/hL0m4+2FVF1kQmh4gY7sfvUF6qzjn
         urqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740773783; x=1741378583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ukwtTV0ExXBJKM7v4LhbJXSMG6hQJqW8GgzzDxNF23M=;
        b=B+V1xnT3HU++EZDld3UjQQI5BoQgZ8hp/kV81UqRUSwf5M5MA+xwJw1CCPJnibyBcN
         ZGZVaboF4jmNucgRyEJlexdcdP+5EQ9df4pP4uZ3tVGrRALDAFv2hG//7sM4kkTK/0uY
         OmTHX+BclcS+adykKNYw2uvKI6sXtifwb1aWMZiIkl7c/8Bo5/8M9aSS9tlaapNOPX9Q
         oHqlFMn1yoqLvBwR+8MQyO3NNpFbLzm4awm+M4QVLOBR0x1JBJbH31Lo4X6k4Y873X9k
         bespUUZgxsAVQkayS/SQKFKXCIOB7DuIoefKoZ4PPrQfEoiTPb6XnkzlFJBDnEuV5mz7
         RN4Q==
X-Forwarded-Encrypted: i=1; AJvYcCV20N83tC8EBGd8UCm6ArT8mB+znQIjxdA+uAVz6/hU6fTNLE1UhM876hgN/BKYVs/4NhTTOmEsifR/Hwst5wg=@vger.kernel.org, AJvYcCVZc/21MnJ4GxNnhk62EgZ7HSV5iT8vSbQ2e7Oir3vRoG11wNRAEeaTt2ADCGMghJKbs+fYPJjPx0AHHeWJ@vger.kernel.org, AJvYcCXXAI7IFJjZXIOxFqth8gyBVwgBozKLipYXpW9fH7Z50ePziFh/7ZB2hXWjhDVFze2oQ2RNe6jLEylXv5/L5cmv@vger.kernel.org
X-Gm-Message-State: AOJu0YxzC45eccq8EHCUanUKlJ8ov2o3Oyj247WIofyKOsoa+JRQ8c64
	jKpQ4giOHD+jAl9+sDzGOYkzM3EqruyFhPuePeMn1KM4tjPfrLp6
X-Gm-Gg: ASbGncve5hQHYqgxQWqbpftg2vyoJpH4r8cnoiSoU5qaPNYkD9M08gTii9Iqjho5pUN
	nmJoJk+qAtsIIMQd4VYqkxDk5I3woJIGzLaaMiIMwC0qe3Nex/PrmuJiyZYKmFO3NYHwEFWEtWE
	a3leiN0oavP042+uVYLHDSXJKGeExzY9PtOzgjiwERsJuXdk7fKIUdXDOqwSvaIs8azS76wN4MY
	EAeI4ZYcbC1rvWUzC9KbZpNhRHBSLd/6IiI9+AaB/uDF/unfNfauSGP2ydGv1UgAid+w/YMoBnN
	Auax12zDSLRsB8wuQFbDayOQFOg8N4DRWE3s7fNQ/nHaecrLVLS381WaV7NkgUzyFa0mxbrcjFY
	tFOyx4WuDS8J5j8denX0XG8scqS5W6VTSeo8cu2uVM1M=
X-Google-Smtp-Source: AGHT+IFuUzdbgaD/IFSs5QLipx4iHpbTunJtFdHt4pWJCQ/QSyvZEmN8DMfkaEXDfQkozt/2Pfk6qg==
X-Received: by 2002:a17:906:6a05:b0:abf:16f8:5190 with SMTP id a640c23a62f3a-abf26822611mr449155566b.44.1740773782957;
        Fri, 28 Feb 2025 12:16:22 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c755c66sm340812666b.136.2025.02.28.12.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 12:16:22 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
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
	Ahmed Zaki <ahmed.zaki@intel.com>,
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
	linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v8 net-next 05/15] netfilter: nft_chain_filter: Add bridge double vlan and pppoe
Date: Fri, 28 Feb 2025 21:15:23 +0100
Message-ID: <20250228201533.23836-6-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250228201533.23836-1-ericwouds@gmail.com>
References: <20250228201533.23836-1-ericwouds@gmail.com>
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

