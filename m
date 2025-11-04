Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AC4330B39
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Nov 2025 14:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762268300; cv=none; b=CAmGCoLDdj+yookOKJGfoI7Nne/TiL3yNZPJC+O3sUGNVRA+wyWtlOotYbRt6Mhpt576lSM98fBANLvt2ZytCRtz71C945I2/LgE9D87fIKWFLTmiaAwO+KNvEPph7I0x/7dOrnwnL9ZxUt9gNI0cN4wRV+XjZi4RqpGSTPBiAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762268300; c=relaxed/simple;
	bh=Fy0W9gxzWa5phBf2U5OgVY5Lg4WAKVgwOkuBRbqjIao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRcHe2DTYbV3zCm7lQZqB1yXsqCo9nHX5bv30qpiCYRDt5+LMwUtOxeu04LFCDbXJz60DIfCajA6kf5v5O1SIrfOwVn9I5FSt+5lHFiNGyziX4MxVw15hw2LBSH4ZXVA3tkeElyd3hOpJINCSosFjcHuN5GqugMI/VnKhoa3Bx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bNS+SYPM; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bNS+SYPM"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b3e9d633b78so1318584066b.1
        for <netfilter-devel@vger.kernel.org>; Tue, 04 Nov 2025 06:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762268297; x=1762873097; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mqNOLZew1B/4/qGT1ZskVp7oVfq0YezN6w+W/pCgZf4=;
        b=bNS+SYPMc1sFdMhsh9O04yArQ10uCkepSyzHetTyHQUXDN6T9bt3/WPuopH38VfpYm
         ZimlaXRBkNKe7QOqOsjKUZJ3LMPYu5pJM/HPlK+3z1LftoeuVnBjMv6ruVRToTNAfUCT
         chql+gNbck4hE6ZLHBiUZLJnqQBwLCPC72cCS4x1z7Rm7OasViqxBWp8Rh6uYuV8ap4P
         iG3GcgOnYs5SOvTp6z06lWmZWd8lBGnpbBcvdnuuZD4vw2abWacycXFWTg35W9SyhGss
         ElaEWaJdsChIpd62mXQ9n4ReworutUGJRZHzLJufaKjz4PqRzOg24S2zGL/weNvGZSrX
         6wuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762268297; x=1762873097;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mqNOLZew1B/4/qGT1ZskVp7oVfq0YezN6w+W/pCgZf4=;
        b=stZMAti67r9ID1FtJw61IVRR9Y64kpJvBlfHOZsLrRD9eHcGjKvC4/7TlA+CfLetLF
         YlLvrCIHUdw46kiVgW2PD0y0ayq8ajY+NGlP+C1TZNuKZhdT4Ca7jGX293ku6UJ8Y11F
         kFXgjvwkFiihexB+I33dpsij6pLPhjVw8dtou7ch+Ke0c3C5RKhBY25Lgye1sAd0cvR3
         algR3mezE4pUvv27fZ2KO3wArmmVngxtDIFQtwNACZH+bFzCdALIdGtWH/yj615DqH7K
         mckNGz8Yb2AmkgWdYcqZq2bANkEojSv19MDWbL4hfwZqh4a6SwqZ0Jf3T8D78Qrwu8pn
         6KnQ==
X-Gm-Message-State: AOJu0YwSrRvxRsQmGsNeDD89iOL61Vb727rmrtnAkfUnLdFJav7tPROA
	dvxu+TzWzbHX4hBfhQX6xr/xA2Cf6rGpQyoV9PDtutdXgwmLnH+M2zP+
X-Gm-Gg: ASbGnctBS2h7y+cftsobW0Vds+XMA6X8c4nKOnxrmbPovYiWnCwywY2hvJ5M6IiuA7K
	iWaBf54aDv3Z3wWZRRzv28zthqtQPmdSHvakeeQzoHfiskqMnLZ44jU8uiPsYYEf4WQgt2hBos1
	qYhARXf+9AdHeVEI+WsJqbTPsdU+TCWsc8wdZ0ptlZW4Th06T0pI9+wY6B8gjDvJIwVCKS/I2e7
	oVL5Wdft+GMh718kymL3cypcMIZztIcwru7jZ9ENdeKSMJFklkH9hrQXt/nMGhE6CPWJXF/GK73
	/I9IFLMWkEZhH36ouS2cBo9BuTStysDUlXzkL4fdF9zQVqd9rPADeL2Jq9uZ7ReC5JOm1t4pGDO
	kcgO347JfmgzJrnn7GGatRJBvZmTRfIAwWpsAxMozVq2fPPf498hdEeDQH/rieAkQhOoes4ybJB
	Mp0huxMhy6dCA2F01QDExrOQJ+FNmPRBzYxbDBg1f5yMEsl90mKrajJGkYL4YKy1FYJ7q68Mo=
X-Google-Smtp-Source: AGHT+IFVxavNltv6OT0DR+ikoiqQd1j38ojj7cLxan/xShMoKGlMagjyohBNUH/d8xEtKzERUxNvHg==
X-Received: by 2002:a17:907:60c9:b0:b65:7f88:72d5 with SMTP id a640c23a62f3a-b7216e61f39mr377047266b.28.1762268296988;
        Tue, 04 Nov 2025 06:58:16 -0800 (PST)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b723f6e2560sm232681666b.46.2025.11.04.06.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 06:58:16 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
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
Subject: [PATCH v16 nf-next 3/3] netfilter: nft_chain_filter: Add bridge double vlan and pppoe
Date: Tue,  4 Nov 2025 15:57:28 +0100
Message-ID: <20251104145728.517197-4-ericwouds@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20251104145728.517197-1-ericwouds@gmail.com>
References: <20251104145728.517197-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In nft_do_chain_bridge() pktinfo is only fully populated for plain packets
and packets encapsulated in single 802.1q or 802.1ad.

When implementing the software bridge-fastpath and testing all possible
encapulations, there can be more encapsulations:

The packet could (also) be encapsulated in PPPoE, or the packet could be
encapsulated in an inner 802.1q, combined with an outer 802.1ad or 802.1q
encapsulation.

nft_flow_offload_eval() also examines the L4 header, with the L4 protocol
known from the conntrack-tuplehash. To access the header it uses
nft_thoff(), but for these packets it returns zero.

Introduce nft_set_bridge_pktinfo() to help populate pktinfo with the
offsets, without setting pkt->tprot and the corresponding pkt->flags.

This will not change rule processing, but does make these offsets
available for code that is not checking pkt->flags to use the offsets,
like nft_flow_offload_eval().

Existing behaviour for a rule like "tcp dport 22 accept" is not changed
when, for instance, a PPPoE packet is being matched.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nft_chain_filter.c | 58 ++++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index b16185e9a6dd..1f3ae5687917 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -227,16 +227,64 @@ static inline void nft_chain_filter_inet_fini(void) {}
 #endif /* CONFIG_NF_TABLES_IPV6 */
 
 #if IS_ENABLED(CONFIG_NF_TABLES_BRIDGE)
+static int nft_set_bridge_pktinfo(struct nft_pktinfo *pkt, struct sk_buff *skb,
+				  const struct nf_hook_state *state,
+				  __be16 *proto)
+{
+	nft_set_pktinfo(pkt, skb, state);
+
+	switch (*proto) {
+	case htons(ETH_P_PPP_SES): {
+		struct ppp_hdr {
+			struct pppoe_hdr hdr;
+			__be16 proto;
+		} *ph;
+
+		if (!pskb_may_pull(skb, PPPOE_SES_HLEN))
+			return -1;
+		ph = (struct ppp_hdr *)(skb->data);
+		switch (ph->proto) {
+		case htons(PPP_IP):
+			*proto = htons(ETH_P_IP);
+			skb_set_network_header(skb, PPPOE_SES_HLEN);
+			return PPPOE_SES_HLEN;
+		case htons(PPP_IPV6):
+			*proto = htons(ETH_P_IPV6);
+			skb_set_network_header(skb, PPPOE_SES_HLEN);
+			return PPPOE_SES_HLEN;
+		}
+		break;
+	}
+	case htons(ETH_P_8021Q): {
+		struct vlan_hdr *vhdr;
+
+		if (!pskb_may_pull(skb, VLAN_HLEN))
+			return -1;
+		vhdr = (struct vlan_hdr *)(skb->data);
+		*proto = vhdr->h_vlan_encapsulated_proto;
+		skb_set_network_header(skb, VLAN_HLEN);
+		return VLAN_HLEN;
+	}
+	}
+	return 0;
+}
+
 static unsigned int
 nft_do_chain_bridge(void *priv,
 		    struct sk_buff *skb,
 		    const struct nf_hook_state *state)
 {
 	struct nft_pktinfo pkt;
+	__be16 proto;
+	int offset;
 
-	nft_set_pktinfo(&pkt, skb, state);
+	proto = eth_hdr(skb)->h_proto;
 
-	switch (eth_hdr(skb)->h_proto) {
+	offset = nft_set_bridge_pktinfo(&pkt, skb, state, &proto);
+	if (offset < 0)
+		return NF_ACCEPT;
+
+	switch (proto) {
 	case htons(ETH_P_IP):
 		nft_set_pktinfo_ipv4_validate(&pkt);
 		break;
@@ -248,6 +296,12 @@ nft_do_chain_bridge(void *priv,
 		break;
 	}
 
+	if (offset) {
+		skb_reset_network_header(skb);
+		pkt.flags = 0;
+		pkt.tprot = 0;
+	}
+
 	return nft_do_chain(&pkt, priv);
 }
 
-- 
2.50.0

