Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EC82116E6;
	Tue, 25 Feb 2025 20:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740514594; cv=none; b=Gj8V5yEJUmvasbL5O7RBrIcpZcbE1yspnXPCpY6ExgqHl3PnFQym5h6XaZwAwnIW2zFugqpvKcWgP85v/F/OgP3wQm9z/tIvIHjY+AwTKujYNv+YME9eKFEInFxoVrUQ2fRGofSb0PzCmnyMlclDtzeNZOv+fM43zH/OyT7Ej6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740514594; c=relaxed/simple;
	bh=WOvVk2IW6QUSaxpGvpwW6W6ywpdv9Y60/i896yobQ+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqYAuQLUiJhvsSedNmQDS4i/ksRNFbIq7wlUjXmsNwm6z9psqEqW7mGQIODYmxfdZb9/TemEs5AtTqCoOHdKu+9a7ENPLZVyxQZmgNmvqfci9dLgMyIoSymD2jruNKJ6LmTy5M4oOAGpmfvwQFWKVE4ADoddxK7nMtR33zANXEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bmWT4eXz; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bmWT4eXz"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-abb999658fbso748648866b.3;
        Tue, 25 Feb 2025 12:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740514591; x=1741119391; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ukwtTV0ExXBJKM7v4LhbJXSMG6hQJqW8GgzzDxNF23M=;
        b=bmWT4eXz0R2eU4sxb5KkIKVawwEnWHx2DbMBGTKI78E/6EOU5tnKv7lDybJtCbawGU
         g5CYrFv5xLAfNDyyplr4KzE0auV0O2bL9iS1fqCrTOw+lcz+QurhW9ruqq1xLMn0RbnK
         6zVsof32aTd1Rdkx9Kl/1oBecZJSN3g5m24PbKjGmezUeByF4FUvq0GJtaN+ZZsZo4BA
         VIFtXcwGdgViAVBPHIF1+7ayPWX3tk4MmBd3dOwZMmzkgzNWi1DtICGjWrYNUR3SEbyO
         734b7McrjFIH/VHG7Yo/J/4yIBkzk2/lawTKjmBRXVfa6u++H1H/OdxQrKxNlJi1Zr/2
         YcRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740514591; x=1741119391;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ukwtTV0ExXBJKM7v4LhbJXSMG6hQJqW8GgzzDxNF23M=;
        b=sHpKtGiYeDrHdNUEryceD9U0UjxtWGPRCHg6J2d1PSC6007ASYtgC+5WnpTHB9iFHA
         2Fl0/EnLIoaKSTFXMDGoRdMeSIWOyZBgbvSdXpQPIVUuubhYH5PAeF7L67CqT2pp4muo
         kYVsG3dLSRs4O5jrsOdafQYtsh0nmFqSWdgxTdqxgbRWjQSCN7CqVFhOFNl7Ks9J5u4n
         P9GvPzYCSaale03abDKkVdTqRyH9T6ySRD1Defr1mO2UzngqYPdPIrcTKmWux8nm0hZY
         NYMZ90nkC7eJ0VTHjIUn0VPOJvUnnrDtJ5EPYXgTjRZZNUzvdGWK9HZbjozgM3MptJuY
         sX5g==
X-Forwarded-Encrypted: i=1; AJvYcCXLjN0qdfL4kB7QB0KVw/m09ovmKtafWmAS+q0HWmGdtnKAwGq+Pzg01VUE6zPhu3RT03X+lwIQ51RB1woReUBM@vger.kernel.org, AJvYcCXwAiw7LKMtKJ5WNwfLWxHTHpAYgp1gCwys3pbbX7jd5sqdkTBUjjZ3X4s+Jxc+NTND0hXauSWU8eIQNvE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCQmTR77gj1GVJZCkqJ1oB3tBNS7/8rXzlatBLp5YHyLn5UQdD
	YefC+cnSyocfX3NqY1vMWbelcATQMpyufNucd2ZYh9uATIckOBqZ
X-Gm-Gg: ASbGncssC4CMSpS3Z+FULz4UBdwgRGwkDbutJp3mOlcg7XGKN3yOtUeiJ747+VLonEP
	lt/iIdEknjWbiEN+dvXgzunC/J/GtvN/Fi9GcdS/W6JIo61ty/fMadVmv8S1u9ljlfxHpsXhNVQ
	pdQA4PFOW5LZYsoEllVLxzJ6A/YVXo5bCCPSfmPGnbNeSmtXT40C6rPokXreD9oempPXCNARM0r
	W4aQe12jc8IKJkT0u65DGQ+t2vvCppJcuY6ZlTsGaGW8uz1hISt2BsxlLkDhRZOlPtv9M2fKTJi
	hKtJ70NgoK19VaWURrJkadVwc3xjR7BHmqFLiL1ExxMybcVyVGH/mkOFDlrJSaOFvP4uwYs4dao
	SHKUPvYLiXZqI5ZXdC6Pk4K4N5PRA1t6MQrVdMWRMGto=
X-Google-Smtp-Source: AGHT+IFELKJeBL47E24AYBhFNQB8kxvH4OvNCfLa7OLiE5g3zAvMls9N3TtS1GIRuC8kJEKI8Wmk4Q==
X-Received: by 2002:a05:6402:210d:b0:5df:6a:54ea with SMTP id 4fb4d7f45d1cf-5e4457abbc9mr11921566a12.11.1740514590457;
        Tue, 25 Feb 2025 12:16:30 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed201218fsm194319666b.104.2025.02.25.12.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 12:16:30 -0800 (PST)
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
Subject: [PATCH v7 net-next 04/14] netfilter: nft_chain_filter: Add bridge double vlan and pppoe
Date: Tue, 25 Feb 2025 21:16:06 +0100
Message-ID: <20250225201616.21114-5-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250225201616.21114-1-ericwouds@gmail.com>
References: <20250225201616.21114-1-ericwouds@gmail.com>
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

