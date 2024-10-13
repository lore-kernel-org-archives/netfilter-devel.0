Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3FE14AD3F;
	Sun, 13 Oct 2024 18:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728845739; cv=none; b=ne6jFRoKKJWhusdDAcHHvuxoMGVTKcbjnfErq0C+yoTyG/djIJt8+0x0gqQCzGcPuotGZAfqFllkfJyUB1bdt95g2OEy2geXb1Gsh3Elb6XTIMzzvarOEH/OE56xK+QNP9bVr8FzyfbdlVGXel26iOlbPwCi4y1/UZV8HkUFJFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728845739; c=relaxed/simple;
	bh=poTP47yQdf4khdC+9ijtITarQAaptxBJXapnWT/Y6lA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXyeqWVDHFV9FLeldpfFGj69BOcFgqqfAq0obENCYLZqULue7ZtS7iMUJ42yTmXKvDRgWN1qD/87vEflSW08xKoifssbMJOSnr3LSFw7j0Y11U7p7gaB2W6CLqVYCJmiofA1OIAMkGBwmnEQmsngHylmuiGgjuLmG8anqsZsw/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZNImXk6Y; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZNImXk6Y"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a9932aa108cso542354866b.2;
        Sun, 13 Oct 2024 11:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728845736; x=1729450536; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qi0AlNa47OjnLX+zdNkH8pnYspHiUC9rPn7VlkLtCao=;
        b=ZNImXk6YLOUjbeTnlT1br32nTOF1c+igCXMlAems6OON3h83g+zYXbgXGG468KasOL
         hjJD+eidBm2Zuyg5MRo0z+EwWvgSWRRlBUik+Pr3MlTtGzRBSe8ZTmsghazHxEzRqxng
         466FCeW71ADeTdv/USiKh6NON+wXdIVAhk5DeFMmMNH2CVHGGy/+eLESaKf5gu+zn+kB
         GwBFj9tNzdUJeAqga6485yJImYgCASge86iKEIlgJiVAef+CuLNr4H53pr5ppnnncW+Z
         vNb7p35YvaR5s8lFw5FDwbTszPauDXugpqcn2dH7yA4gy8Ayt1bAaNTkGUJibcbqgILP
         eAtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728845736; x=1729450536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qi0AlNa47OjnLX+zdNkH8pnYspHiUC9rPn7VlkLtCao=;
        b=wMijnk0oIOTnj50YWPuxI27IWlzTtgrGjIw3/9vv1QDMZGe0lijK+k8YjwRtXeERgA
         VJvZ7oScSwoO8XfDYFZG9wyk5NG0Sq2gqBm1PwK5J9dIR4oxkvNo8YtQuwqRcsEjXjHQ
         sPMcU2HIYj9y/6kY2bQIO/y33UXfC6SVmp6zmkBvdwz+79SKZ6g5AK/eZuuW4MHxMYB4
         9MoOal015P/RNns/nLIAUu29uw4IOsRRWqxqba1tZgGsv2IEJ8qTCd+vrZOPkEa+xH6l
         a5EyzoQWfsct2dX156YmsJKJL29d/Fz3qd8Ma1+r7hHv/pDvCM+q0GsRaJvCi6Ly5Qxa
         6l3A==
X-Forwarded-Encrypted: i=1; AJvYcCWGiKFaNkdL4O8sSxNPeUmE6AndOhUWVtlrGfdUYFiLnbe3V6fzsTR3WmmX8iR9sGmdFWADsAMuoRMqshU=@vger.kernel.org, AJvYcCWrtSVm8+ocs8VSFZM/1sJQViNkRgcIEXlBhI5jv2u1k0eKHT40We1tpVqPh3tJoL9aEysb7uQNwv95r8vWdpNx@vger.kernel.org
X-Gm-Message-State: AOJu0YywHVJBOFivmPp3WIwtaIOdXggS7R2mHocfX40lEtJd8/KptrqT
	W6pgbVsy6Hdg9muapSmw03lelfk9/rVoadCPUzTqaxTkrzDE6oV5
X-Google-Smtp-Source: AGHT+IHVDWLkh2asCKPkqAFL6v1zfW7f+2znEwYnsBE2sJ/tzUwV2TxOCxBYdSzOWLcdLwlQKhvF3w==
X-Received: by 2002:a17:907:2da4:b0:a99:ffb5:1db6 with SMTP id a640c23a62f3a-a99ffb55507mr289530366b.24.1728845735564;
        Sun, 13 Oct 2024 11:55:35 -0700 (PDT)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a12d384b9sm13500866b.172.2024.10.13.11.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2024 11:55:35 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>,
	Eric Woudstra <ericwouds@gmail.com>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH RFC v1 net-next 03/12] netfilter: nft_chain_filter: Add bridge double vlan and pppoe
Date: Sun, 13 Oct 2024 20:54:59 +0200
Message-ID: <20241013185509.4430-4-ericwouds@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241013185509.4430-1-ericwouds@gmail.com>
References: <20241013185509.4430-1-ericwouds@gmail.com>
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

