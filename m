Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0929C22069F;
	Fri,  4 Jul 2025 19:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751656334; cv=none; b=YDeP0cET7i6gi0k1tIziTquG19C58vgHx4JfnWjFozfHboyBU0iswAhOGxnANhJW6b53OSby3Ymp4W5JFSqNRgbem0QbZOPLtQPYf2KcPYH1N5g7TJeJFcHXxNnKxjQ5SiMFTv8s31ZOaMaWUi8IN9wTc4EjTfwb4m39Eb4/Yj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751656334; c=relaxed/simple;
	bh=Q/lrdq2Uikvlke/32oZHP0bIjd+ePE8bpseap/4Mp0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qu+iZR2SX9NvraFMPrYBkWdmxdoxwUztNIAfw0zVK1ihtXMBOX8ofeIxwyWcF7cNxQq9AkyU1rkZlS3pGumwr632BWXnGOjCeM9OppibvH4fO8zurPl8R8UJp9onVe2nVhx6McVbml23GRaz4yCzgFM8uVhbq2QHQV7+JWvNyt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H7DHunoC; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H7DHunoC"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ae0ccfd5ca5so185549366b.3;
        Fri, 04 Jul 2025 12:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751656331; x=1752261131; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OmZsUY7dpf8eao6+4v2lrJjyeF3MwXa41UKxk0tU7Co=;
        b=H7DHunoCvkhMAGTJVSfvLGctbG1Cvi0ts8kagKcXjl1uzOfiBr779nZjmt1r1ANcmB
         tOg4jwrI0Hgvum1EwfUDMcwX7fkqJU0YHBEevp01i0QGZsTnHu1W/dydEo/LJYgc7tBm
         i8TyovPH7+9Wt9qzwWL/NkZm5azE6t0YQ0hympOjvO6RWcfOAlPZBTUjYDA+l7MtQ6K2
         ciMrc37jE+4BZtESgU112PqKC/se9j5gqZhaHGTn+Ib/FKZCwCPXmJSC2W88gDpD+vle
         kATJuhGnxr0SheKbBEQdOyqOgUH7aHxKoQtUBv7qy1ovay9dKkRKs9nHW+66AZgG1IZU
         KxTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751656331; x=1752261131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OmZsUY7dpf8eao6+4v2lrJjyeF3MwXa41UKxk0tU7Co=;
        b=GjmgjeMEDT6d7rSrOob5w5Vw5CsefGKjNJT1uYcLEttA1QfX8GYBN2ynC40AGZ27qm
         cfqP8PszvHm+0I94ylqoOTFgSw6d3R4OhVU4OlGQj6xxcoZXagEv0GijmHSAEq0USIii
         T5Kaa1QauKHc4yFEkuJmxDJvlofT1XXKN228rsjJQdzU86wT3Zn+mmXcTM+DmcKzEYw0
         Pn3VvLfdUih2bSFGyLpkmxx8zjSay5SffxU+KyolF4bP7OJw7L7MOJB+QkSIWOZZY4m3
         3rdFSJmVCJQfxqRiVsjhLo/jPuS7cPWldlq1Q4pe6EOWLjCEsfQ74TYgg3koUFwZqbKj
         De1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVkUQG/4mdg4g1m0bOVxTnL3tXYqkS6BY0hqh6ytFnpXi6076XAzaAzZezlE8AGk6SNlDYRdIg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxehTGofULdVv4fe7x1aPY9ciAHn81cQ2QxSmuZJ0+jXeI3Qsnb
	lFptZh3Q67u4P1C0fuyC4HEBxrcbwCpsD7pxFLpPXeiqIWzjyH6bpkOz
X-Gm-Gg: ASbGncue5dE8DNHMm+wBK3kkxchsdlu6gTjxp7D5IKTl8FEeLbCyrsb7lznfFEcD5MX
	oKHmqrOpJSTpBtI3Q3GB2I9BmuKexJMh6P2KH1lSJY4dPcIl8Y7xeGErCRDQpuDuuExIUgpTaWK
	my9tBQxe77JRJqBK2tlD1EFQ/IUXGWhT2z0O/gP8KB+ioSMao1pG6AMyQAbn/l2a3B3qlaPRUMY
	TUdOmPJTW0mXErEZrvBReGks1PZ2OV6C/AaUDhibntinxaXPf5q9hrETdTgOLBnh3eAwwxHYo4v
	9LshXzp9T3GOOPD57fIEkdOYMntNnYvxFAOYH13xh5KCseeV0OtL/aUR9z9Ij40r64ZtB9CW6eU
	z3MYIvJTb3ROctXR3ZueBKnTpfgQT3QX5Wl7WwBouhax4D+pCQASsIYuv3NrEwOfW9PnWEjxTBp
	ibGIWD
X-Google-Smtp-Source: AGHT+IEeXAJoE2Ma43SXkCEuo3RyDIgqb9kmpp3aaYZZQ/WrcATyFVvyLOOnKU6Am6D5hgzbpWQ0+g==
X-Received: by 2002:a17:907:9485:b0:ae0:ba0f:85af with SMTP id a640c23a62f3a-ae3fe800101mr359646266b.51.1751656331097;
        Fri, 04 Jul 2025 12:12:11 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae3f6ac5fd7sm219476366b.103.2025.07.04.12.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jul 2025 12:12:10 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v13 nf-next 3/3] netfilter: nft_chain_filter: Add bridge double vlan and pppoe
Date: Fri,  4 Jul 2025 21:11:35 +0200
Message-ID: <20250704191135.1815969-4-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250704191135.1815969-1-ericwouds@gmail.com>
References: <20250704191135.1815969-1-ericwouds@gmail.com>
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
 net/netfilter/nft_chain_filter.c | 52 +++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 19a553550c76..8445ddfb9cea 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -232,11 +232,55 @@ nft_do_chain_bridge(void *priv,
 		    struct sk_buff *skb,
 		    const struct nf_hook_state *state)
 {
+	__be16 outer_proto, proto = 0;
 	struct nft_pktinfo pkt;
+	int ret, offset = 0;
 
 	nft_set_pktinfo(&pkt, skb, state);
 
 	switch (eth_hdr(skb)->h_proto) {
+	case htons(ETH_P_PPP_SES): {
+		struct ppp_hdr {
+			struct pppoe_hdr hdr;
+			__be16 proto;
+		} *ph;
+
+		if (!pskb_may_pull(skb, PPPOE_SES_HLEN))
+			break;
+		offset = PPPOE_SES_HLEN;
+		outer_proto = skb->protocol;
+		ph = (struct ppp_hdr *)(skb->data);
+		switch (ph->proto) {
+		case htons(PPP_IP):
+			proto = htons(ETH_P_IP);
+			break;
+		case htons(PPP_IPV6):
+			proto = htons(ETH_P_IPV6);
+			break;
+		}
+		skb_set_network_header(skb, offset);
+		skb->protocol = proto;
+		break;
+	}
+	case htons(ETH_P_8021Q): {
+		struct vlan_hdr *vhdr;
+
+		if (!pskb_may_pull(skb, VLAN_HLEN))
+			break;
+		offset = VLAN_HLEN;
+		outer_proto = skb->protocol;
+		vhdr = (struct vlan_hdr *)(skb->data);
+		proto = vhdr->h_vlan_encapsulated_proto;
+		skb_set_network_header(skb, offset);
+		skb->protocol = proto;
+		break;
+	}
+	default:
+		proto = eth_hdr(skb)->h_proto;
+		break;
+	}
+
+	switch (proto) {
 	case htons(ETH_P_IP):
 		nft_set_pktinfo_ipv4_validate(&pkt);
 		break;
@@ -248,7 +292,13 @@ nft_do_chain_bridge(void *priv,
 		break;
 	}
 
-	return nft_do_chain(&pkt, priv);
+	ret = nft_do_chain(&pkt, priv);
+
+	if (offset) {
+		skb_reset_network_header(skb);
+		skb->protocol = outer_proto;
+	}
+	return ret;
 }
 
 static const struct nft_chain_type nft_chain_filter_bridge = {
-- 
2.47.1

