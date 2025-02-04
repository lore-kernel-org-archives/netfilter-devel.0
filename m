Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3609621A436;
	Tue,  4 Feb 2025 19:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738698600; cv=none; b=szQ5i+hq6g1De6nFI0oWf1HbvZ87F3iSkNSxJ7aymL2sN+qSHYkO1VfVtevMdudJPesMvs5jz/N8z2LxCrpvkYY46HxXbVXk52zkm3kuxtjU4cOpspXT5KoFdMiTrnoIqTvU0yU0PrOrrIAtrFlX8cfmnJmK0UsVsq5S/UiVw78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738698600; c=relaxed/simple;
	bh=jB4CLuNpjbTGQnMeQ4Tsv0ptAlvhyNfXsNUxXknTJVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubJv03kOf3dps8X2WpBs/lNYTHuN/2CrFLQaCpnuioEAU6DeTP/kKwaP0ptQw/I0grnrq8vGSsUkKIjbAnyjVBNnHD77H7xxoXj+z+Walca/1VcQhsNIIHL/2Pd0/cTRJ0T/b/7ijuRQCashn6px8ABzhd52XX5f4OEVn7rzpDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fp+pq4bx; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fp+pq4bx"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aaeec07b705so1010160866b.2;
        Tue, 04 Feb 2025 11:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738698596; x=1739303396; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kkGaA4c7zu7TuRSY1s83dH0+lqC3nn6Z4nZphc3xrDs=;
        b=Fp+pq4bxXHsPjusnrfmdJdVEbPhPtyB3gOxsXbLpj9ZsX6K3YVldiBdMzwLKJqtP8i
         Qrb8eYQ+nZ6mAY1berIvRPgtOJyT27fzs0Iy7Tp7Gc+tAe5mSrfkOKHYGERQmkzIEbML
         KDKMlB67tpJqYBZJ0jL9D7rOvhQM72Q6jk6J/mleH6pbnYGGa6F1aKchVR7ix7ZB/Nfz
         KYc6aC9nXRxYEFerlaWpHylzQ/qehL1UMWkj7f8qc7GzhHqWBlFmNej0+weFOfUP6d9t
         Mmi+thopkQT5xyWyN1YAp8Gupt66ovZyHMt2ZiBtFGwq5tuVR/26DdBKsoDYmrSugnpA
         LUiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738698596; x=1739303396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kkGaA4c7zu7TuRSY1s83dH0+lqC3nn6Z4nZphc3xrDs=;
        b=tF63METhZtzqNZSq858Qie431Ev6fwgOxCEob0CN2D7sSV0AilQWH87uMs6uk3XVXN
         CMx1aPaxlzPzUgLUX5A5CHBEBOwg8kOuYZGpFUPY8jzxPlWvCJQfaW0Scg38rAteiV/u
         kv6IKYuZTKxSpv0X3v1rePbocZCvQM4QHHFakwOEjwjio9mIhXhoBeQMT4e+O0ulJKz5
         ZNvJENNEnmIu0zKUnm/bfjyxJOn3IQSLel5Jm86icCE6tjIbDn8hZiJKfN3rmwX/o0SQ
         TtkOq4Aqj3bxdosa8iHpIID1vZhXHbHOhFfzBgEYkj00v1bQ6e+hyBN+ZPGsBxYFgz1m
         8X1w==
X-Forwarded-Encrypted: i=1; AJvYcCW/dZSU+G688+hmiLgiAr+bx0Q9owW0BpRO+62g7SkHzlxELPQa8pv9AY6AUIjBSzZeah3Yu5OTUvli+Ek=@vger.kernel.org, AJvYcCWEOxZoRFjM7K8x0eRiBfivu2bQlT1YwlUoqYa0YhGvMiYdybvoWw1kvNngi1EMggEGKWW0ILb/95FbpduFvj4s@vger.kernel.org
X-Gm-Message-State: AOJu0YwRJ4h4q5fnVuOKfh/uX8O0gewMuVHVgHgABItPHvLGDhrcZUZW
	tp2rZzn+gUaoC58uqz7Vtq6n0nvlEIEhwyjXizWnIWcQZwzHWxUY
X-Gm-Gg: ASbGncumppoOkUjKKD0kS43JOHfXbwLHgwGZSafMRh9Tn8LwAgb2WvjeV1x8M2A+FHq
	DaJE3artKRA4Sy3g/j1uU8O0uVcU/M8lA5FV7bjd2Vei+OAoYzB9i10Y5HaQtRZUucVs9YCwPCU
	ClxU114PmLaklNO64WMkeVOOznuTmiEzwPajStXKefyYkGmUi7oAJHmIc/2EkMClsa4Ji+oIVYh
	cKCyubbNGOeCt3vftgOejk5eronUGNBElDuI0zLn87PNf3BPv5OiHI9SKAKQ4QpqhFvuZAOWQNq
	W8Tpr4ukrOzo8fK1Po8t87WC7ZxvANS615P/r8kGlC2ftXY26/qDfTKMicYLc/UOqNnJx6FFHl7
	kVKljNqz5/nJnWVGzLQEMgtWY7k2gScKo
X-Google-Smtp-Source: AGHT+IGs4CC5gM167ZayoImsZp06NKQRfeGwh8m9DaNw+WB4zUAYvUsoKlU1KSkyxVdKrRT1PS7NMw==
X-Received: by 2002:a17:907:944c:b0:aa6:7220:f12f with SMTP id a640c23a62f3a-ab6cfce5fdfmr2766061766b.18.1738698596201;
        Tue, 04 Feb 2025 11:49:56 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e4a5635bsm964684466b.164.2025.02.04.11.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 11:49:55 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>,
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
Subject: [PATCH v5 net-next 04/14] netfilter: nft_chain_filter: Add bridge double vlan and pppoe
Date: Tue,  4 Feb 2025 20:49:11 +0100
Message-ID: <20250204194921.46692-5-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250204194921.46692-1-ericwouds@gmail.com>
References: <20250204194921.46692-1-ericwouds@gmail.com>
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

