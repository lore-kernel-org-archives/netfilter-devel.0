Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B0B1DE885;
	Tue,  8 Apr 2025 14:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744122399; cv=none; b=NkG99bU4NPBJLMMmBGnHaJ7Wqwp8az1bmDrDw9LjJvKUfnUeAQpTKLp2aVzQm3tQQFaS4fybp2YwJchmH14DkYd/9Zltly5/c2VGp7CWymj9DqzFnferZrFz5K+I5lsp4k6PFhS3UDcslfTvE1hHlM2dSWaiew/BNvnf9nqaYA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744122399; c=relaxed/simple;
	bh=9Ed/mFFgQwIS+bKP/piGE8lQYd8/p2Gw39UsY7QGgYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFgbpmZLITioNT+0A7ko5WIsoaR83NzJmW3pAFlPzm7njhBQjkI4Vz8ehWR5sGqjtj3HvsIVyHhCTsqEdNOUrPdryoFIIKQ+a6i2+hrTTp0vcBywTAs/1j/QLwc2Tp5lDkzEO/Dp8yYjROZfjBDjV7YVA7CNeHlCSXCi+13QGQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZXwHOq7o; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZXwHOq7o"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ac6ed4ab410so907553466b.1;
        Tue, 08 Apr 2025 07:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744122396; x=1744727196; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FLc/IUi5wHGsbU8Rvwl+BFmfBN3QPI47jubpT8Zw/U0=;
        b=ZXwHOq7owIBwW/xtjyQtgGdeupazZOZe9ImghZuzBkbGRV5nVn75UK9hsluV8wmjjQ
         T887+VGWeh/ziTQUtCwmcJSOeRj4MVJpH4iHYz+ZBDVzDR6ScNHSpoxMmwkeqy5MFCfb
         iQ53bc2nar04/FAVfezEd3fXvir/ymVKE+dw1YiWV1aSQFA4eYopCtUya9xAbRC6MdAB
         TREWX2a7e2F9CSGmS1WuCSjvV0bJAeC7rLh+cBlPo80smVtRb029gYWplsbdmvJQEaPH
         wySO5N54+vU1B5/lyM/gkDB0wZB8PBSWcEFwIE+eIsBtRcL0BjiNckIYUMgvADis7vBM
         kiDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744122396; x=1744727196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FLc/IUi5wHGsbU8Rvwl+BFmfBN3QPI47jubpT8Zw/U0=;
        b=UCHHdUkWptHSgEkPipMjEdknIRxuWwwQS+Yd/PCqg+FfWhRHt9JYcR0Coh9e+Xwsjo
         G9cF1e5IMBxdz70iO5nbxCEW8ze+2EDLt398hvF+uo2aagrIU4QCdBMAmQiqeVm9rMT6
         YlABoWRQYgBDewOSlx7yddnNCWJWQpu/90e2IiXEuwt44KcyHHzrxC7hxS0Tt+g3QoPx
         BpMXHI7Y5763vfdb9i1fkw3KM2RYNY5TWvbV1u7Y4M4tUxQS6txI/LL++E031Y+axDsG
         Msdtuai13ys9FM/j04oN2mR9n+gwI59dBbMdevIDAO8gxEF84DobTGdFLjEmTLZYoITE
         UJWA==
X-Forwarded-Encrypted: i=1; AJvYcCUUyt2LDYdZEJGZIbyGfCjVweYOb25Lxq7UzWi2UfmqAZlQU3WCVbx8uMo7MJY0+Sb3IaaWy+g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYNKpD7lznmZnjl1+X+dixaRA/G/a3yz3mP5KApFy0F7biwZAa
	TZf/ElJc6Roou3qZuhrE4VrowbEna9gMwxOD9hFJCWaqWKpG9hfz
X-Gm-Gg: ASbGnctBmuyUzUfzNt7SIWXRI6UoLfmqKWl0uw1h5Xkonne6ZZXnwOb8Zst6FQzDhNA
	x52SvdEUGGc+I+qJqay81QaIzqXlfkEM2x6V+b66TV3QJPGwrZDuY6Dl2FfVpKN8V8537wUft6W
	80DWFgT1OPxjhWNf2TH7kY5cR347rzkG95kjnb7dsEv3iQDcyRjH64buTHA9rKMgRxYHX8jTTHO
	Gsp0qe+EatnNTs1RKzBcFrwG29YkG/V/DVtM3d2lzSx5K51jNZ0y183clmwTZKVSMxWeI/3z+py
	zDCv0q8LFCnQeqQUh+X74878Ghl9r366YbQm9O2XpFgQfujhLQt7s0rggbfpvI79Y6AFPmDwAnq
	nwRf9zzjto/Mqi7ONA0K4nspeBR+TW/5+fEGzI2fI2FeWc4MzselcLqsbVp+vhso=
X-Google-Smtp-Source: AGHT+IHGItupR8AZMK4HAYR2nl0ykcSVi8qz4p01Fsmr2z4OTHYOfzOel4yl7D7BbOfRKvQ2GDFGXA==
X-Received: by 2002:a17:907:7e98:b0:ab3:2b85:5d5 with SMTP id a640c23a62f3a-ac7d1c64effmr1570316466b.49.1744122395290;
        Tue, 08 Apr 2025 07:26:35 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7bfee2591sm926664566b.79.2025.04.08.07.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 07:26:33 -0700 (PDT)
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
Subject: [PATCH v11 nf-next 2/2] netfilter: nft_chain_filter: Add bridge double vlan and pppoe
Date: Tue,  8 Apr 2025 16:26:19 +0200
Message-ID: <20250408142619.95619-3-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250408142619.95619-1-ericwouds@gmail.com>
References: <20250408142619.95619-1-ericwouds@gmail.com>
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
 net/netfilter/nft_chain_filter.c | 37 ++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 19a553550c76..fe0b12f748dc 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -233,10 +233,47 @@ nft_do_chain_bridge(void *priv,
 		    const struct nf_hook_state *state)
 {
 	struct nft_pktinfo pkt;
+	__be16 proto;
 
 	nft_set_pktinfo(&pkt, skb, state);
 
 	switch (eth_hdr(skb)->h_proto) {
+	case htons(ETH_P_PPP_SES): {
+		struct ppp_hdr {
+			struct pppoe_hdr hdr;
+			__be16 proto;
+		} *ph = (struct ppp_hdr *)(skb->data);
+
+		skb_set_network_header(skb, PPPOE_SES_HLEN);
+		switch (ph->proto) {
+		case htons(PPP_IP):
+			proto = htons(ETH_P_IP);
+			skb->protocol = proto;
+			break;
+		case htons(PPP_IPV6):
+			proto = htons(ETH_P_IPV6);
+			skb->protocol = proto;
+			break;
+		default:
+			proto = 0;
+			break;
+		}
+		break;
+	}
+	case htons(ETH_P_8021Q): {
+		struct vlan_hdr *vhdr = (struct vlan_hdr *)(skb->data);
+
+		skb_set_network_header(skb, VLAN_HLEN);
+		proto = vhdr->h_vlan_encapsulated_proto;
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
-- 
2.47.1

