Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48CE35C1AC
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Feb 2026 19:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771790349; cv=none; b=l6NOoc1/grSw0IIMYLJaHF5BeD7COR0ERIOaTXuUJ5/QX7GP7c4ED7/ijIi4uM8ubyFY1lvGob3Zs9iKnHZHwlqJTPGw17v02okNti11i7NbxceLtCv3eog5H1xgdSEymX6DWkeusVS14PqxCprs2pzENlYoN7fm1hMpBnYtkhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771790349; c=relaxed/simple;
	bh=otw/sidfsrVAXpxIAPSAHcc1JnUEwkQzo3iMewEEbLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNDt9d04pUP+nHiHBuWBaz3NpRH4voYuYSJytcyFt0qkp3djRWtaIwkn4ySq+4bq7SalvzhbTD3vFgdahFA1qlDWWlyud8k17ylS6YVwSaeE3KlD4s99tU/PhOqZm2UycLKepB+3URQLUlCQixz0WzgDLIoCp2qJX5gzkOIkyPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U4p4TMDV; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U4p4TMDV"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b8f8d80faebso664964666b.1
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Feb 2026 11:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771790346; x=1772395146; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=coP60IDvUwENZ4G8REzPur6qzEmmqfojoUutShryN4c=;
        b=U4p4TMDVXOX8tlyznO4pGpYlq2u/vqSP3x7/wVv1pTs+c47Rv5CCc5/3PWgvh/G6Fg
         cjRR//410wSU0It4WkOcEjzmNtR7v9YEmmCfzW8ajR1eUdXDJZwqDw+YuVeiX1dGylAv
         vJRAW6il44jDmqYbcNDT+gxLMEHiG0LpwoASzgavKYtVNzkevof//eLyITh92sF0sM/g
         l6AesyU4/JtviweOwGQf6KCopBm7ZQCSXXha8hL14FE3Dy1edAfqOIO/LZ6uyEy/YX4w
         go8b38NAMjPEtbTKg4shTOA9TrwPCNU/BKr0OkyQjuzgN0FdrXWW6AQqB2ojJPg01SQr
         tGFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771790346; x=1772395146;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=coP60IDvUwENZ4G8REzPur6qzEmmqfojoUutShryN4c=;
        b=ud1ARLCggNsX3M4jkQ+plRE2u7DvpGJ7GCZ6iRDXgz4GROHV90D2sV627//OqyBWuX
         IVePadbHPahRjlaYX3w/9pictvnUTBsID01zvnti8Rzmudh/oNWjAnENQx8O0ttuC2k6
         I/f0dz3hggB7GMIYx0xbRCXzDvEt3nXJWtHmnNptq5u1l0doq0G04zPrZuSMj5sGpeIi
         5jNk9UcLsdRBkM3Rlh2coItaeJGUSlgDv4ahzM+lB3ia+h7lo4+ZM79VEVr+4xPcKECK
         lKpSYWjczdOJWaQ7pCTzTSCdM/I6YIbzyL+27p616XIWwgCj1ghh8aUwbEZqCzwyhnnV
         LnUQ==
X-Gm-Message-State: AOJu0YxphXdrBxHyjUt5uTI2YUSWi9NuRizE5QdkPrGpFxrFHzk8d9Wj
	pBxe7aFqaSfphFqSOSiAllJR5FXbzd9yEfLkNHsiuNAcVqInSEdBH7Fu
X-Gm-Gg: AZuq6aKVlMAayb0zIrSq97Fncsa7vHPJhVs0J8A2EjMvUP22GJ0vLj0hyx4BDSQ+RDm
	LOXArWnph2o1wpQ7xdoE39erDykIPSdMwDXmeGZsrrBBhFLtN2fNjbvu8b8ehtp1TEAXKdQW6Yz
	EDxvgO9gzuyY4AKlN9vzGGeOh3rx/di6axBPSyLrAZRSgbfbqI3CnaJ9kLZFL8LvJsWjSkRBnG/
	BXA784VgucZEv3nj5fT7tnleiMYLXglGFNsMdk3qWqmPQcJZs0cDim71SIKTd3Lg7pCKgHVCR2U
	5hY/aThV+HeGEkC9a2iMan8xTx8L1cujXUHNCCjuafq2hEgClQeCUj7vVxjgHo98bw9rb5t3pvw
	9fuP5RMrjSIXwfbtLJVpOTusMShy+ZcOxYKyPTOkq/Jvm4nHPBHzgOCZRcHP4Mfjw/cxO4lvzL9
	bn1cUV3zxLK1jqavLhUlPRbKgV1VKbo4jMlUFxRBbTk1nCHb7jJtjh6qczTdxYqA7nwTaUYQj0a
	tWeKC5tsfksm7Ls6pqpshnIwNNjWxvgr3p46V1tlv83+XgToMm+VWc/r35hbolkXQ==
X-Received: by 2002:a17:907:988:b0:b88:1e2:ed49 with SMTP id a640c23a62f3a-b9080f13a76mr405909266b.8.1771790346139;
        Sun, 22 Feb 2026 11:59:06 -0800 (PST)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9084c5c514sm246125466b.5.2026.02.22.11.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 11:59:05 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
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
Subject: [PATCH v18 nf-next 4/4] netfilter: nft_chain_filter: Add bridge double vlan and pppoe
Date: Sun, 22 Feb 2026 20:58:43 +0100
Message-ID: <20260222195845.77880-5-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222195845.77880-1-ericwouds@gmail.com>
References: <20260222195845.77880-1-ericwouds@gmail.com>
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
index d4d5eadaba9c..66ef30c60e56 100644
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
+		} *ph, _ph;
+
+		ph = skb_header_pointer(skb, 0, sizeof(_ph), &_ph);
+		if (!ph) {
+			*proto = 0;
+			return -1;
+		}
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
+		struct vlan_hdr *vhdr, _vhdr;
+
+		vhdr = skb_header_pointer(skb, 0, sizeof(_vhdr), &_vhdr);
+		if (!vhdr) {
+			*proto = 0;
+			return -1;
+		}
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
2.53.0

