Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591B831A07B
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 18:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758825065; cv=none; b=XjF6p5kmZ9Dgl7una5lJaQfE5yrihgW6ujpFNH07SQXLrbZkwz9/eTG0VLAzyZ0JBuHp0pPtoP5FYNZZx2wwg6EfbGiTdXRT46C5jbaOm2Fvl09RO7IhENyZ8fKHo1Df7pSvY2UFgBUTktOd77R+I6ESxmBP9IADJGs8WdRvsNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758825065; c=relaxed/simple;
	bh=l8WqN102Lw5inmuS7NKuYpjmsQngGiA54DeLWZMXAkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcP8EpKamSL2ryFqZFjVyZjuZpUODw83o3FXtpIvIdXZQoSG0hSA2PxTvIAS2dEmxZxuqDwQAo6MlnPEA35QDLyr/5Zdpxb9jWsb7VMgsAAnJTlZjZ1cuaXlUR3sLswi9WH0WFnBcUud/dZRVprRINbRg9ucOASTtHseesrybtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QVrn0uKE; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QVrn0uKE"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-628f29d68ecso2754414a12.3
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 11:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758825062; x=1759429862; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4sfKxL2KrtcwkwgsavqpRxPdbGefQzHoIqXv/DUN+jw=;
        b=QVrn0uKEL42GznTUCO2dCUC8cqz9nxE+nY6kqe8xneN/SyLuQuUMxN8bdiMxFwPksx
         tsFNLuYiAPHBoxD6YdqqqoHz69tD3gTnFodwp6/K9MyF1RNiu1m+PmUOzPU5yVlhsc4v
         sCwDUCoNqvhmxMFsOfF3yYrjXhYP7/UQivSdk6psCW8IhdPJTXTUwhRttwckTh0xPqP0
         5CmHoPABrbsXxv0jpwFP/HdHqau85QZZGnoeZxwEIjX0ElMm0nQBYtnMp8HSrOEJ+gyS
         fvx4POJZ6IygeeiyID/8DGRQUBIHy6z4F3ry7rD6gPN41q4UOHPlXtXWed9SSQEIt/Uh
         7N6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758825062; x=1759429862;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4sfKxL2KrtcwkwgsavqpRxPdbGefQzHoIqXv/DUN+jw=;
        b=No101jMxPr8I5y6hCbazc8lErZDzcyx2ads8ZOumTzFpkBAkpTPe0RPhf6SLC7KyYR
         HV5UA22iDCts/lTJ02LZ6sTBM7ZflKt8DjNtiK4ujWSn2zuFY2hfPxrpWKFnlHlQyyYr
         G4AoMxySvxg3sfmCgaz95NxFW35fUcFZKLzNtEHFpttYyO56B30QeIhjW+522LS5ngWQ
         u65D3LNCcu0JqSKcv01rg6phdjpTLGnTGzc+ykawlC4PQWEzyUtQPnw7lDs610XFSVSJ
         wbPujAYPhV1Ppmm4WnE5nIqXQ9EgNrr3qNDTYJcwITHJgArxEZ2Na7Csaj/NvNUQly8W
         kBbQ==
X-Gm-Message-State: AOJu0YyvwB4W7dn9H6mGud3nUsc5wGgBt5YHYaCO1kZisziUrhrECQNS
	q1/p5hbCmPGm5ss2nAWFezDBHW8qckSUENnV5kou9i0vmXZZAZiajr+M
X-Gm-Gg: ASbGncuK2qtdmR+rukWv17K0Aqb3q2LDmvu9CQ8uyXiLJVk/W9AjtmTxGgekuxD9V/U
	TJnYuNARInnrYKqAackYzOAACx1dFXCZs4E9rbmU//geQPztrkQDdX4OrCvVP4b8U9YqgBC8I2Z
	B89FSAcx/sD0jhp/Qlv+Oh3k5nnrIqn8Z1+p4cok/nJFCqsEgV7VI970tbmRuxDrc4Rd75BLXbe
	zlyNTxbCcZGlnAxkPs0McSk6vd9MIaNMhOYt4q0ahIn3L1M+hP4YzDYFGOi95B8JMMm6BNpBzIF
	sG+Fzt1OaT0oOWFvFs66tiEbILYe0cRJ8vB0w7pbztU0Ypzw5kK8cCKhDduYi5PaU7XU9H3NxvD
	JzZhjntjxOCEnYH262LnOaPfLvut5KvDgnSP7HMvsyuhbCI59RrO0dOkqAq7QqvaSFLzT4JBVD6
	Z9RGOwQW0kKGs0cBOJPg==
X-Google-Smtp-Source: AGHT+IHtby7hw89di5zdtb7t9pM1jtiFx92okk70oCOH9Ecm7ZWyNfwmWukJyHxtzj/GWmn6xdX11w==
X-Received: by 2002:a17:907:9447:b0:afe:e1e3:36a2 with SMTP id a640c23a62f3a-b34bad22708mr485258466b.31.1758825061549;
        Thu, 25 Sep 2025 11:31:01 -0700 (PDT)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b3545a9c560sm211198666b.107.2025.09.25.11.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 11:31:01 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
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
Subject: [PATCH v15 nf-next 3/3] netfilter: nft_chain_filter: Add bridge double vlan and pppoe
Date: Thu, 25 Sep 2025 20:30:43 +0200
Message-ID: <20250925183043.114660-4-ericwouds@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250925183043.114660-1-ericwouds@gmail.com>
References: <20250925183043.114660-1-ericwouds@gmail.com>
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
 include/net/netfilter/nf_tables.h | 48 +++++++++++++++++++++++++++++++
 net/netfilter/nft_chain_filter.c  | 17 +++++++++--
 2 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index e2128663b160..4a55972881b1 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -10,6 +10,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <linux/u64_stats_sync.h>
 #include <linux/rhashtable.h>
+#include <linux/if_vlan.h>
 #include <net/netfilter/nf_flow_table.h>
 #include <net/netlink.h>
 #include <net/flow_offload.h>
@@ -88,6 +89,53 @@ static inline void nft_set_pktinfo_unspec(struct nft_pktinfo *pkt)
 	pkt->fragoff = 0;
 }
 
+/**
+ * nft_set_bridge_pktinfo - calls nft_set_pktinfo and advances
+ * network_header to the header that follows the pppoe- or vlan-header.
+ */
+static inline int nft_set_bridge_pktinfo(struct nft_pktinfo *pkt,
+					 struct sk_buff *skb,
+					 const struct nf_hook_state *state,
+					 __be16 *proto)
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
 /**
  * 	struct nft_verdict - nf_tables verdict
  *
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index b16185e9a6dd..a5174adb1abc 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -233,10 +233,16 @@ nft_do_chain_bridge(void *priv,
 		    const struct nf_hook_state *state)
 {
 	struct nft_pktinfo pkt;
+	int ret, offset;
+	__be16 proto;
 
-	nft_set_pktinfo(&pkt, skb, state);
+	proto = eth_hdr(skb)->h_proto;
+
+	offset = nft_set_bridge_pktinfo(&pkt, skb, state, &proto);
+	if (offset < 0)
+		return NF_ACCEPT;
 
-	switch (eth_hdr(skb)->h_proto) {
+	switch (proto) {
 	case htons(ETH_P_IP):
 		nft_set_pktinfo_ipv4_validate(&pkt);
 		break;
@@ -248,7 +254,12 @@ nft_do_chain_bridge(void *priv,
 		break;
 	}
 
-	return nft_do_chain(&pkt, priv);
+	ret = nft_do_chain(&pkt, priv);
+
+	if (offset && ret == NF_ACCEPT)
+		skb_reset_network_header(skb);
+
+	return ret;
 }
 
 static const struct nft_chain_type nft_chain_filter_bridge = {
-- 
2.50.0

