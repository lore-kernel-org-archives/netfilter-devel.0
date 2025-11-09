Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AE724501B
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Nov 2025 19:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762716288; cv=none; b=dYxIKGb6vpqnlesWkZ5cnAojkPgo9z6ISBLjy4UbPs9foc9l7LqH6gZbJ/6IzYlmN45VckA/C4jM3bjeyalfbJJTlQPkco9FINdOdG5WWPiRmQw/PJ8Ro0GfdB16MySYWEb+pYqthmQ9CsL3/4DKQ3FrxhzVksVBi+TOJa+f/7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762716288; c=relaxed/simple;
	bh=fRAY5x0iiQZzMBRRTadDlTASkzjWZctbJeB0EhamTXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKyNlq4zuw0CEZcVNc9s0H/PvkJlKAu8SgF/ITorQgZjkCnNhNeqhjn389xZlkc9GgUDvNQvSm7aTQ57TkiaBNZZPb9UyvPtMNEdUcnJJg9mGAJ/bauek+Gf3IQ3GOt1Jcf+Oo1Jhs/DskfpcWcTdsHtg2Ty2llTqMXWxRoigr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mYJfKU2C; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mYJfKU2C"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-640f4b6836bso4217616a12.3
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Nov 2025 11:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762716285; x=1763321085; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O0KTE+6UkuOljHxLPaa5JqpVN6oPc7OyA2U67mp05fg=;
        b=mYJfKU2C18mrD/WINpTw7+BHH4XYBs4jC1ShcN3aoslG8Il/aackok7+RXr2V+NmT1
         ReOhu4LeJ7iOaHKo3eDOyRJWRlyddtdJcCWaN+iyDMq0SOLdU6OYbKJioPGjl7w0JoTn
         AzCxzoiTM16dxs1WtiwEYTULnJP5YrOF+x7BNDOTxOyDm7YvUNBBdGLqCqIfemTT5pYB
         rd7fErMhFgykBDZoUAzcKMRkWZF1Uu8Qn9Dqd2qQZQ+H7GgedTGB7FNVbPYwtC6DWwr+
         XhNyOz+TMlg4BGltS4kksW0e5a+LEcZSJ9YLrWcwHQtbdnTHsCER6s8d/MZ2uNcZQN++
         EAYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762716285; x=1763321085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O0KTE+6UkuOljHxLPaa5JqpVN6oPc7OyA2U67mp05fg=;
        b=qanM9isGfovq68405MjIOxLC88Nr6r6wAi4S58OxAN/3ClxFoeZ9x+R0PE+jwwOrxP
         3cTUmReUzU0DMqzq4y5SQyrxE8LpKZ4w+3umVp96CwRiAydk8a8yhGM+bCPA0jH3+XkZ
         64PetkwlrB0jUGL6FTu+0jNc+M58KbSVQDGecC5pM5KTQjl6vVyDVXi172QbzJ6C1wHN
         Y16CfXw8d9wLJK+T/skaw43c1AU47xksWrLzggjd9oAfLFahH9h0s7ItD5yBnx4L+yLo
         6YvyYlYRQx/sK/TzqkKhZQhOdH5xXlxn/GoiuO/0g9cdteb8lB7EQ9F5RUvV2+KnLrGl
         EFmg==
X-Gm-Message-State: AOJu0YwtRyvOlJoeOtj+YezvnZYx+DyftXx7JK8fCnGYlT6nLhQykLsn
	IrPsXs+YDV2UiTlkpdIf/D/oVl5AK+qDrTScBFq3mCgTBSSFJp/h4/FC
X-Gm-Gg: ASbGncsNZqte1aj/nKVWqKthBSxR+550aw8MgLhPcCOQtFnVTp5HlIF5yKXQF3yK8/w
	jMbLF3hVSB39Se9Wdhr1kKXkqKmEJn+xgb3ynBTKVvVycny7/5Adfv/mX4BW/z+ZU3o6iMMD4Zo
	pNT+GevYbbRozJ811L8gUzK4lVbQi3cIofH8RktylgZ2RXv8f8mfFFqPgeZMuUmXBVgbLHagbEZ
	c/Il8GEBedPN66lOlgjatTJCuhAAQNOOvdjz3DNWlHIhoWurepLkmeJt+hP/Kfge1mDbVd3H1ge
	Nptm9M9ABwuOl5nG1HR+nH4fZCERlTEkoHqB8aan6tC+qk6qY6OxIK1YF292WuG8k+cAGE5C1Bq
	8GpUlMzOz+3g5rLMMvTMcjQvx7i7NEUeUaYMCMBpHDXtsGH8kcxnhUvPHvf7QUfsqWof27CqR/k
	Lc8gLzhdDbC/jDvX0zCrMV4X6I+JoFkm7w5YsGkAcnjaV4UNKrt6XEKxYmsxQmXkOJg3K3ifUkC
	Od5GUf9yQ==
X-Google-Smtp-Source: AGHT+IHbYcQWGeRNfv+qzW3Tth8V6nuyKNbZz2fBbPX/OXmNJmzUeDKE8mETFfHc/vJK3DShLlkrpg==
X-Received: by 2002:a17:907:869f:b0:b6d:5a24:f124 with SMTP id a640c23a62f3a-b72e03035d6mr502044166b.22.1762716285087;
        Sun, 09 Nov 2025 11:24:45 -0800 (PST)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bf97e447sm919652466b.42.2025.11.09.11.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Nov 2025 11:24:44 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	bridge@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v17 nf-next 4/4] netfilter: nft_chain_filter: Add bridge double vlan and pppoe
Date: Sun,  9 Nov 2025 20:24:27 +0100
Message-ID: <20251109192427.617142-5-ericwouds@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20251109192427.617142-1-ericwouds@gmail.com>
References: <20251109192427.617142-1-ericwouds@gmail.com>
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
offsets.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nft_chain_filter.c | 55 +++++++++++++++++++++++++++++---
 1 file changed, 51 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index d4d5eadaba9c..082b10e9e853 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -227,21 +227,68 @@ static inline void nft_chain_filter_inet_fini(void) {}
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
+		if (!pskb_may_pull(skb, PPPOE_SES_HLEN)) {
+			*proto = 0;
+			return -1;
+		}
+		ph = (struct ppp_hdr *)(skb->data);
+		switch (ph->proto) {
+		case htons(PPP_IP):
+			*proto = htons(ETH_P_IP);
+			return PPPOE_SES_HLEN;
+		case htons(PPP_IPV6):
+			*proto = htons(ETH_P_IPV6);
+			return PPPOE_SES_HLEN;
+		}
+		break;
+	}
+	case htons(ETH_P_8021Q): {
+		struct vlan_hdr *vhdr;
+
+		if (!pskb_may_pull(skb, VLAN_HLEN)) {
+			*proto = 0;
+			return -1;
+		}
+		vhdr = (struct vlan_hdr *)(skb->data);
+		*proto = vhdr->h_vlan_encapsulated_proto;
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
+
+	offset = nft_set_bridge_pktinfo(&pkt, skb, state, &proto);
 
-	switch (eth_hdr(skb)->h_proto) {
+	switch (proto) {
 	case htons(ETH_P_IP):
-		nft_set_pktinfo_ipv4_validate(&pkt, 0);
+		nft_set_pktinfo_ipv4_validate(&pkt, offset);
 		break;
 	case htons(ETH_P_IPV6):
-		nft_set_pktinfo_ipv6_validate(&pkt, 0);
+		nft_set_pktinfo_ipv6_validate(&pkt, offset);
 		break;
 	default:
 		nft_set_pktinfo_unspec(&pkt);
-- 
2.50.0

