Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DF8212D67;
	Tue, 10 Dec 2024 09:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733823981; cv=none; b=B04ZClgq/6XKOXzj7R8lW2bdXXFajn6VKgSkhaHLdi4OnRtjb/nwh+uBnGnpJPXDddJivGOpTjDtv2tIV6m021tdjsLCB4zuXkUgR3aon8waEYqc3Uq+JYU3/AO2unr7fAMu8lPu+c5JftykOJz8mxTOFzZN/M/SxONP+lMAsjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733823981; c=relaxed/simple;
	bh=PpWhu6geevy6hVriSMI3jM+oaAQ6lslz7ZRk1SJTcoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBlF5DTee1UD1/QKFBcYon5ro2eWDkWePcSfHSGTP9eYYUXDCZR5yDWktuQp7QIkqxQdXctQdZfxJELL0zDc0sAFsPHEkmu+OPmdbQALC1Ffmb3+ZnziJONjPys0JAG056DlQI8iGVUxgNjBKp1UObRAyKROmXgv4tomYpWf7nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=khkBgGzK; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="khkBgGzK"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5d3e9a88793so4005289a12.1;
        Tue, 10 Dec 2024 01:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733823977; x=1734428777; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BKIHos904u/55jjyV61JBBioSUFkR0jZBzN6/oqpIaY=;
        b=khkBgGzK60LQcRAqBLerUKrKg3TlfLFapSIwTzKdniZ3NmxOIAwwBE9ItUltv/Uk2q
         bXHdJhWf43TfxxHKQy0XmuwgU3ZF8JkYrP9vfwynFN1JDfuO3GcSRECn4ywz03mOfPJ2
         17pSgFgxAHKrygvlOeVq4XLzvqIrqGtotlrGa/YeZXrzMzlv9aqWiYgxH+xej6OOrC1J
         /F609KlpIR7fFfj82xKt86AhY+bgSjYMvSGmpS06YRLfWaI9r4NfTXmgX/CzdujVyJjt
         cHqpRlIBIeMyg3VYIG/nyjB1BfEmQsbYO6Ib0KGR4Q6Lz53nxkBevyq5i/HlBCcxl6i7
         wr8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733823977; x=1734428777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BKIHos904u/55jjyV61JBBioSUFkR0jZBzN6/oqpIaY=;
        b=LNB7cGoDsNrLIfkQAYm3aVHRfgavKt354JUzTyNksEO5xPEuvyQJlLW1RGOttM9f3e
         3f0qTr/E95EzxoI/bNRvkjJ/PdZGMXD5S+sRNBFkWRZALDLxlO+kvqnK6pcnHBeFtNcw
         xP3KDJZDAZkOxXwUXrgQp/aVB+oqyVdVAFAd2YVmlHYH6Wsppdb7huLMpkYrvQJsJtno
         tIPYe1FjuD7UR1KgDrzeQXbh7d8h3rM5TdfjLlKxb/Wwcrgq/TFwr3jGHIRSHYHDiPGz
         gh6p2SfXhmS4kpQrDMpfYqhkEMeTWOtLAWNq19wJIw4i373lHf8jx7dcxvDR2NUGmckl
         Lr/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXIHyeN4UWMqSGDIMX5e31zDaRIjgnVOdoTbwxSevNP6nkZOpHlUaL/g1G8WI4e75guV2N3+lkM7E+kFYQvzjSG@vger.kernel.org, AJvYcCXt6QzrG2TIR0pxe9rPh6VZMe5921c9JxYAhlU7VRvkbeThnItyOqCWJhH8chjMIS/f/QlQddYVesffMDg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzukxwKxqS8wpHOmAaVmpN/ZScAllqpMF2KuLQN27rZ/WG/Bj4p
	+j5k5QIiuvDlsgHc1Du8YXIYFudg+zeSpwGKExJWb3zpZIAdW2GZ
X-Gm-Gg: ASbGncsdDXlBHe2QjGVuiqcyRAdkjYvH8bvSdyMu8ERC+BysUIyBINdJHbFCgTXg5P6
	ujl34vI+OdD2jRMrqDKI6Y71VK+NFs0xegEF5+N/sMjxxNx6KBUvCbgxfmZlYElCG8gZJT1cqcL
	uIPFZUYxislaUrg0UDQtbZDh+XCLsEH5y/n3BhU+alcRcmZ/usj8bX1vtE/LEfQ6QzW6/rMs7UP
	hK5TvmswqXpOfGlCSS5h1ln8Kah2mcRV0WcsdDOWMavSL5fNBWOAQD+cko7aNkD8u7B3C62ltp8
	cQR1WEwQAWlHktA0izSZfev0sGUvbw/295+bAQpOcboZBBvZwomA+pqdodVQPSYDtRhh8Us=
X-Google-Smtp-Source: AGHT+IEEUrkGtJfTGOQCwFkl/sxLKxNiujiQKGJAvLJ8Ua0u8uaifo2lDidZZxTSL8EGmSiw468ajg==
X-Received: by 2002:a05:6402:13d1:b0:5d3:cd5b:64da with SMTP id 4fb4d7f45d1cf-5d4185f81d8mr3897445a12.23.1733823976507;
        Tue, 10 Dec 2024 01:46:16 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d14b609e56sm7313936a12.40.2024.12.10.01.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 01:46:16 -0800 (PST)
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
	David Ahern <dsahern@kernel.org>,
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
Subject: [PATCH RFC v3 net-next 03/13] netfilter: nft_chain_filter: Add bridge double vlan and pppoe
Date: Tue, 10 Dec 2024 10:44:51 +0100
Message-ID: <20241210094501.3069-4-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241210094501.3069-1-ericwouds@gmail.com>
References: <20241210094501.3069-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds the capability to evaluate 802.1ad, QinQ, PPPoE and PPPoE-in-Q
packets in the bridge filter chain.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nft_chain_filter.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 7010541fcca6..91aa3fa43d31 100644
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

