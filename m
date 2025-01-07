Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8451E3769;
	Tue,  7 Jan 2025 09:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736240769; cv=none; b=lITbBMWIdy4k5ZDQLd79I4G36IrmbGG/0cuI5RJ76/PbNXur5y+ZqfeAH0PmwVtsXMC/M6EgovV3G00YNQLOHs3a+bNUbViMiC6A6oCguZt7Ifk8HMOESgA8QZ49sJ12oWss/Hb16y5m+FLQuUz9hVyiMYiqr4TcqWHYR4waNXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736240769; c=relaxed/simple;
	bh=PpWhu6geevy6hVriSMI3jM+oaAQ6lslz7ZRk1SJTcoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddzneO4vh0m2VEmJXvOy3576gUcqRhMw4S1gKgU/Mhy3IpGr5dMY9Hmo9a5jxMzr/D+TcTQogavlrRZZEpHlqw4SETG8KRy20it/LcrZobffzUJPWnsTDnzA6Avh1aistwwjcwVEGYhrjasTInzPH6k9rPM7Z/rjRsJLTVuzEaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kfNtifoa; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kfNtifoa"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5d414b8af7bso30380410a12.0;
        Tue, 07 Jan 2025 01:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736240765; x=1736845565; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BKIHos904u/55jjyV61JBBioSUFkR0jZBzN6/oqpIaY=;
        b=kfNtifoacDI6ToHAH302yyPrGKL6dvpFSYyLEojyhB9uIkvP8mHTlYgcKyuS/f2Xqq
         hWlr+arNHIJztz8SrMgh5WowzOTPR3dIGAUSoEn5T/xKuv2gNvhLMEGUrQReEk8aSxoc
         jIw/TB6bqFGZQdazY5rBRpzIxMKcX5D9oUq8FU0omDGVFW8mNJhNhrzb8lQMzos/IbPi
         Zp0cqaLEMzbbymPSjOMG+b5zBQHyFK8YrqLSonjTaF1wz9szD/8OtCr/lKANVldKPnAK
         Vqr7DPEL3afTxdSh9hSoFOTNDmZ43rBDpDqzZWRIKIaQG74cL0VlhgNtclIZp32+ffWy
         rMCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736240765; x=1736845565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BKIHos904u/55jjyV61JBBioSUFkR0jZBzN6/oqpIaY=;
        b=s889h8GeVaZXj+rnY4csTy8YveRsNWWJcPYsWzXy2NDDaVBZL/vRlHUP/+gneuSjCL
         3IuvVFU/oPALp/ZGxlMRAYb251LYm2BK6K/Gg6oenDZI6opZ88+v461PiJnD8iGhw4DH
         b71wU47dd8i67dyAS7AOZtf/2Y1FFfIqiTjh0XR3dyJNyVMw1XtmhkcLMVq1Tm7ai6+F
         2q8uQbQ1VomGw83LrRnOQbHQrgepkCBqXuXZX80B7em6w75VBWjgtDTmxRzHsDxyFcVB
         cARai1qw3xjcu0oe7vawnq6LI3BsHQcTWk50YJyM+EBS/O/FyRv/RuWOiAoU8zITGl1S
         JnUw==
X-Forwarded-Encrypted: i=1; AJvYcCXDh08hlW+5Gb0vwEt0g1vZAQEhwOW21m6XZ8LkBZjEx/w9fJ3ZvPjBgeNWt0QLD6EXd0X1Gi0VJlQIRdk=@vger.kernel.org, AJvYcCXQKBSX0IwOIVvOQVEa0nabqvbsrBivtLSSd5kokDva9vdUf7dzb/c+pYkTKluexcsfFG/7PBGiq5WytfeW5uRW@vger.kernel.org
X-Gm-Message-State: AOJu0Yyyg42p7CDErDtMGMZ3eX9hcYF9KsOa0+Q93DJ1LpMtyfESnPgV
	HgJSbFFC4hmRuKI7oPFtCV0vW1IT9XI2lNQ5wQCPNqFG1hJu3yR8
X-Gm-Gg: ASbGncvNpaIJRdboJA5x8fT1Vlk1gXBoKVw4hfQivGT1QaG1/IgWf9fAg54/styIynw
	oUNjVMAEnGPK/YBdPHbUEpiLK8D5YXAIpTeV+mOn2JmmZCP8gLbDxRTPjwQPN3VyVMA+M8/RsOy
	d/xcUC594NScf7qbaPL8iHmFy2IAJeQ2Uac9hQXXPi9aGyQ76ICsDUsuHwHddGfQa9k7UJ5GXPJ
	F6f4Kxh0rXU4X98qgmyH57zvwSdnBb01X5seAup++sc8G9atGDE04zMo9xmdVCyvcBgpSOmWNTg
	XkF45leH9Pm48uvop9D2LmXi76e1p9yhp03EozFCtmSfeyGWnH+i1I3hYZD8AtqtL1tCMiZahQ=
	=
X-Google-Smtp-Source: AGHT+IF9Q6hAjeuuV+Dr+SGY25DZC7a14teg1xdkg9BFE9rkMwMad+u2nsuZglYNPKcORNXEsZ1PbA==
X-Received: by 2002:a05:6402:2315:b0:5d4:320:ee66 with SMTP id 4fb4d7f45d1cf-5d81de5d419mr44287641a12.31.1736240765137;
        Tue, 07 Jan 2025 01:06:05 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80676f3f9sm24005333a12.23.2025.01.07.01.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 01:06:04 -0800 (PST)
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
Subject: [PATCH v4 net-next 03/13] netfilter: nft_chain_filter: Add bridge double vlan and pppoe
Date: Tue,  7 Jan 2025 10:05:20 +0100
Message-ID: <20250107090530.5035-4-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250107090530.5035-1-ericwouds@gmail.com>
References: <20250107090530.5035-1-ericwouds@gmail.com>
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

