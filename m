Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A165C1C3F0B;
	Tue, 19 Nov 2024 10:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732011566; cv=none; b=MCXXJEYzex/rPhyACORoceO6yTLngY/jouVFe5HmiC+1BkOD0TWoSMXEekxTmwlNXf5Ad3kouFKhHzYR1JOzlp/8/pzRqRyJXttq9/IDvLvprgAY4xeBPs8wQt2y41wEjpKY3rCHMrFNeLx8glP3AtudsaixnzMFT2tjIiLp+74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732011566; c=relaxed/simple;
	bh=poTP47yQdf4khdC+9ijtITarQAaptxBJXapnWT/Y6lA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dscHgIAfBgr3ufql3gvMvVl8abUXh2EV79uk1ywJOw2ofpjL1BFE/Mlfciu/6hwDtEo1eg+RFmiFRazfRvZaScmAsin9tjG7HqfmbhS0o0vLqd20MNa05ya2ZHMr34sKVdrhyFWbKOhYIGY6Ne90FhJ+YP2l9tUR2ka7ghJJD8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JkuZZY8n; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JkuZZY8n"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a9a6acac4c3so124347466b.0;
        Tue, 19 Nov 2024 02:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732011563; x=1732616363; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qi0AlNa47OjnLX+zdNkH8pnYspHiUC9rPn7VlkLtCao=;
        b=JkuZZY8nlkNATi7t4XJcGdcxZjOdl1rcaEX6/cYWt1uHfFPQAT7s0/HTJCm+ZmiSz1
         EYSvz3SyV8sqBlF8x8XhCK0OQVQeg9pDQZ5IJ1GLCvxRLfx7Im2sPU8QL/sG1Sz/vlWg
         7eluH5kAqJw4mr4xQmC/zTAlgssyAcTdNnOiRabQG1DfZuJQ2+v7KWKxB6N0F1BOLfeA
         n7TwKGrVZ0fohvMKC5F8OmltV36jwP0+652uqbBJd0WFjjlVt2cbUIJPY0beWOSnSuky
         9uIw1HBXkL8YXCVuAYkR2fZiJJBKpvOyrOVelUyjHa7Aic2vON9XYj2odg/pFdtLc2T/
         v2tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732011563; x=1732616363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qi0AlNa47OjnLX+zdNkH8pnYspHiUC9rPn7VlkLtCao=;
        b=dkGV4qDs48WrKYjYpwIvd9xzJdOuNdjl0vsaxbfn50g550c/gHFFtE1yWoFuE4+OUY
         NCoRP2BMC9BYNeLeo0KXcJVmkSau+dEJf3Tl6Mh5+oc1GJKz7nup9gpqyx0kmWs46fFW
         QwtqZ9Wd3elwCdOGtdm1CaHXlYZE7HvFIeSpRgKRtZ3rHjP2nD1FOlESl686GfTiR9Z0
         TukEgyug97icpxNi4pVe5S28j4TgpXmD7KhAHr3mhjDLnRc0HFjkGLK2VFsX4C0kqknn
         61wrFMZS6Y/I4sVJ/0gVxjAyluOqaydxWsVOEPmJdTVogmqNhXJ+DJreZVz93sY6QvvE
         4n1Q==
X-Forwarded-Encrypted: i=1; AJvYcCViffyyvCYPI7RN3fiTAwDCmm8RlOV9oComm/815+4FTc6nFP/A4CQ4HfI7zrSShti1MDbClB4YdFnuuSFa1FTV@vger.kernel.org, AJvYcCXbMuDXaIeln1/QgWWLRqsBahbRVm1JEguv326cVTWzd+TzRql7JPPhZVy27h/lkcwo6HXRd0xHLrVVpYA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyolCODXl5zFFLZ6JgVNr5ZKydzjm3btiTh3d8ufrYD4jp2Gv0U
	OMSfb8MkBEtSkoNddbeFYZr/IQgIGYxdKyK4qEuQMlo/NXq9fUjq
X-Google-Smtp-Source: AGHT+IFgtvvx9QxVfYb+i/eHHWDw6v24GqRwyxuBvltZN8tRLFnZjBJN+NHnVp7SFNVLDR7NZlEVpg==
X-Received: by 2002:a17:907:96ab:b0:a99:ec3c:15cd with SMTP id a640c23a62f3a-aa483552e2amr1511647266b.54.1732011562657;
        Tue, 19 Nov 2024 02:19:22 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20e081574sm634875566b.179.2024.11.19.02.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 02:19:22 -0800 (PST)
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
Subject: [PATCH RFC v2 net-next 03/14] netfilter: nft_chain_filter: Add bridge double vlan and pppoe
Date: Tue, 19 Nov 2024 11:18:55 +0100
Message-ID: <20241119101906.862680-4-ericwouds@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241119101906.862680-1-ericwouds@gmail.com>
References: <20241119101906.862680-1-ericwouds@gmail.com>
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
2.45.2

