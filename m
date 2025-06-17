Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1419128B513;
	Tue, 17 Jun 2025 06:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750143536; cv=none; b=E5rTu7+jHckHdBJXS3LfTpNDZOOWU2ps80LvfFHmFs+LBlLxJOz+rdOvBnpnVfPrsvKaczSb9i0c/k2J698JGfNeqvovF9qh5x1SiBLOOaAxXCqPu3rZ783KpQjBJRF05hAaskm4DnK7Bea2MQC7P90vLsKeuP1NGuz9kfN5HCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750143536; c=relaxed/simple;
	bh=TxdumPKtcywI6uKQ4pwKxBrxJvq5eX4R5rPP4NvYWC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qi3kjTQqt3YXf/3vHExu8Fc0a80gNoNWisE6G0qvMQ4Mndp+N0gqsIQj3iv+xD8XtZ06BBm9E7Vwbbwr6Ck9sgmlMk3mY4Th3HiUiS5UPPu2e0Cyd6Vyx/X4ue7b9YQFPVHaxN11R/zkCasCdVKkRfag1TOGgd0dRnTCUh/dAWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bkBWx4DC; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bkBWx4DC"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-605b9488c28so10349812a12.2;
        Mon, 16 Jun 2025 23:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750143532; x=1750748332; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DEUA3s1rs6WdBTbpnUZoPmP+efvFUhPuP5B5crs3AeE=;
        b=bkBWx4DCfMIbLMEibN0eJ19+6mq2hQK9eqPzROpkqIy3LIDuJS5U0vre3MZ3Aocuti
         fAzrwd7uA8BDw76UiD/UzsMDA2NILhpoe1WH6gyl5YlUcTVr+mxn2z3Wae3q3itP/THl
         CKFbtHGAkO8hUSYJ1FDSYf2hhcN5xkho2hP7I8/TOnBtjlNkebWv9Jzaq8Truu/C1G5v
         5ozyeOlKif/DrivVGjZ/e14aStZpI85jAdieS3VRU1xhfUCrHcfKVywwSBnUBAWDKcNn
         MPVzNfcfXzC/Tpq+kGg3YY/pIqRvpwY1RCvBCsOh8igpDnBhHMoSI8B+JVKADhGrAk/+
         yGMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750143532; x=1750748332;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DEUA3s1rs6WdBTbpnUZoPmP+efvFUhPuP5B5crs3AeE=;
        b=wv6zcv9AbX9fjjwQ92rUyem0ZiklIZxRvUJGetpjBrRyV0/y4OW7/FAeqkH0pkrm9E
         1yDUxn7V9+yDXRSOQ/hpwfzFTxnG/LsXrsvlnKKRqt/d1ePlPloGOhVEF2mEgejgOuqs
         +kxm16bcJL06KfkmIS8rg3xGsZpi/4K5B4uHmp77xvSI5Q4/NCy7m5/q4OfMsUYYV+T3
         mB92JF5ikOqJTMIi/BoWhiP6k7n1VXwcR6e2riKWoyl0fY0QLtOm/L5nvc81XChY46Do
         L9p2z90xtcA7bg6DIv6Z4A7gSHz9QX1hoVBK0cCbeblchDKQ9iBPRI/Pt43H1wEss/m/
         hgyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZLxgm0ndJOqeOT1keyZGAqqJChTbII8t0uxn/2Z2P5QJRn/RrgW/1Hkr9aL0dAme3BAAY4Ic=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYxCSSncX+zr5CoYG5TN7nqFVgSDr7j6zDPABOn0fWj/D2ZnbQ
	eR01KssW9Ml0CUMjrs1Hv3/HDKksqV95RJ64Oh6UGYp6GbORFCERdgnU
X-Gm-Gg: ASbGnctJdGEZXtZOAc84BhkdYxRqh8lNrzQJgYEBDd1YwIT7P4/SnajAZM61hTSa2+A
	8qXjgHBbTbJlviRWE85Yug40htzTAcuGGbVJEo5SZ4L9RIkYGP2YcY7RVPXqFweUTd5SzisC1ap
	uICbpLxCPQmx8umNE8ShyfWTLp86U6tTBRW/qyveO5v7DuyD2P5u8WztIvOyyjtqvAcrazf7BFK
	Oh3Q1cJL2RPZ/GSc1Bb0qzpuNubNX4YLfHSOYb0bvLtiIrZOhnV9XgYaapjkXGM3s+6PZn6gdFE
	n6bT2iNrf7YfR4ftahIb5u+9vztg1Udng+0bMpqdpO4tNBKoMr6Tzoisl7vw+ddfO4RInDu/sBT
	N2xUdLBbcosQYrVkg41EJu7QdMUle1iH4Yx+XV7/Gyf3P/a2AONKSNb3HQHlKkrZ/LNkS8VsV5L
	HcExoawEmWsA2hXus=
X-Google-Smtp-Source: AGHT+IEWvjSrTL6JNZv0ulgiz9/dYB+sJXThEPdkJZ1iROYdLX6684t6uUA2M9bAMVjS6TGmH9H79Q==
X-Received: by 2002:a17:907:97d4:b0:ad2:3fa9:7511 with SMTP id a640c23a62f3a-adfad4513e4mr1214994766b.41.1750143532099;
        Mon, 16 Jun 2025 23:58:52 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adec81be674sm811109566b.53.2025.06.16.23.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 23:58:51 -0700 (PDT)
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
Subject: [PATCH v12 nf-next 1/2] netfilter: bridge: Add conntrack double vlan and pppoe
Date: Tue, 17 Jun 2025 08:58:34 +0200
Message-ID: <20250617065835.23428-2-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250617065835.23428-1-ericwouds@gmail.com>
References: <20250617065835.23428-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds the capability to conntrack 802.1ad, QinQ, PPPoE and PPPoE-in-Q
packets that are passing a bridge, only when a conntrack zone is set.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 83 ++++++++++++++++++----
 1 file changed, 71 insertions(+), 12 deletions(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 6482de4d8750..6a17bd81038e 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -242,53 +242,112 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
 {
 	struct nf_hook_state bridge_state = *state;
 	enum ip_conntrack_info ctinfo;
+	u32 len, data_len = U32_MAX;
+	int ret, offset = 0;
 	struct nf_conn *ct;
-	u32 len;
-	int ret;
+	__be16 outer_proto;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if ((ct && !nf_ct_is_template(ct)) ||
 	    ctinfo == IP_CT_UNTRACKED)
 		return NF_ACCEPT;
 
+	if (ct && nf_ct_zone_id(nf_ct_zone(ct), CTINFO2DIR(ctinfo)) !=
+			NF_CT_DEFAULT_ZONE_ID) {
+		switch (skb->protocol) {
+		case htons(ETH_P_PPP_SES): {
+			struct ppp_hdr {
+				struct pppoe_hdr hdr;
+				__be16 proto;
+			} *ph;
+
+			offset = PPPOE_SES_HLEN;
+			if (!pskb_may_pull(skb, offset))
+				return NF_ACCEPT;
+			outer_proto = skb->protocol;
+			ph = (struct ppp_hdr *)(skb->data);
+			switch (ph->proto) {
+			case htons(PPP_IP):
+				skb->protocol = htons(ETH_P_IP);
+				break;
+			case htons(PPP_IPV6):
+				skb->protocol = htons(ETH_P_IPV6);
+				break;
+			default:
+				nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
+				return NF_ACCEPT;
+			}
+			data_len = ntohs(ph->hdr.length) - 2;
+			__skb_pull(skb, offset);
+			skb_reset_network_header(skb);
+			break;
+		}
+		case htons(ETH_P_8021Q): {
+			struct vlan_hdr *vhdr;
+
+			offset = VLAN_HLEN;
+			if (!pskb_may_pull(skb, offset))
+				return NF_ACCEPT;
+			outer_proto = skb->protocol;
+			vhdr = (struct vlan_hdr *)(skb->data);
+			skb->protocol = vhdr->h_vlan_encapsulated_proto;
+			data_len = U32_MAX;
+			__skb_pull(skb, offset);
+			skb_reset_network_header(skb);
+			break;
+		}
+		}
+	}
+
+	ret = NF_ACCEPT;
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
 		if (!pskb_may_pull(skb, sizeof(struct iphdr)))
-			return NF_ACCEPT;
+			goto do_not_track;
 
 		len = skb_ip_totlen(skb);
+		if (data_len < len)
+			len = data_len;
 		if (pskb_trim_rcsum(skb, len))
-			return NF_ACCEPT;
+			goto do_not_track;
 
 		if (nf_ct_br_ip_check(skb))
-			return NF_ACCEPT;
+			goto do_not_track;
 
 		bridge_state.pf = NFPROTO_IPV4;
 		ret = nf_ct_br_defrag4(skb, &bridge_state);
 		break;
 	case htons(ETH_P_IPV6):
 		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
-			return NF_ACCEPT;
+			goto do_not_track;
 
 		len = sizeof(struct ipv6hdr) + ntohs(ipv6_hdr(skb)->payload_len);
+		if (data_len < len)
+			len = data_len;
 		if (pskb_trim_rcsum(skb, len))
-			return NF_ACCEPT;
+			goto do_not_track;
 
 		if (nf_ct_br_ipv6_check(skb))
-			return NF_ACCEPT;
+			goto do_not_track;
 
 		bridge_state.pf = NFPROTO_IPV6;
 		ret = nf_ct_br_defrag6(skb, &bridge_state);
 		break;
 	default:
 		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
-		return NF_ACCEPT;
+		goto do_not_track;
 	}
 
-	if (ret != NF_ACCEPT)
-		return ret;
+	if (ret == NF_ACCEPT)
+		ret = nf_conntrack_in(skb, &bridge_state);
 
-	return nf_conntrack_in(skb, &bridge_state);
+do_not_track:
+	if (offset) {
+		__skb_push(skb, offset);
+		skb_reset_network_header(skb);
+		skb->protocol = outer_proto;
+	}
+	return ret;
 }
 
 static unsigned int nf_ct_bridge_in(void *priv, struct sk_buff *skb,
-- 
2.47.1

