Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDB12E093E;
	Tue,  8 Jul 2025 15:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751987551; cv=none; b=A4Op7Std2PBnbTUqWz+5pAnapVMVCgaqKv+eA7neFlYwZsOO8g2JPA3PLiWp+b1Eb3L8Js0vDd9zhn6+pglHcgLvd4OARsOBAP3apyzfjwtnHpVJq8NK6Z+7IATupvWrKxsXaCC6cmV6dLWKxLVvcHLmJVQJlOU79g+BBx2Ujuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751987551; c=relaxed/simple;
	bh=Tp1Bz8yUu3aS2rr8dOstQpb0hyvWmmXi1gc2V+SaRL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATpRlgSD3lLJK3o+Byvmr/F1kDP4QY5fJekR1QnqAKXi2W46bKCXk1EPva3iLknPhs7lBhBEnBn0QJBhXYvMPBV9cWuYjAAVw36JGk/dPPWu76LmlP1WETDdj4G3DYfmzuxMycGp78t34tmpS70mpTENCbMQ+VXvOSPEYrssUJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VffpZKe3; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VffpZKe3"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ae04d3d63e6so752130066b.2;
        Tue, 08 Jul 2025 08:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751987548; x=1752592348; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YAUBR/u+RT3eCuaRQRZ/Ht0agoAR4js0pHVirBrIafo=;
        b=VffpZKe3sIcFw9ZGhoYAGo/gefP06C7zwHA6FZ9U/RTuWaW/80mBBLr2Rr2kY4HbfE
         ZeCh/TogPDMrB0gaSPqaig/88ipiGvvrFMTBWQA/mLhryUzintCpkd7068/Bm+Qt+4ks
         C4XsUtm7r4SomP01OaaNLgqg22CC+PHSNewyySCSQld9Mo/VXN2GMEgJNcZQ6321DvIa
         UcZahslwFdYc6aOcg0zXQz9OZGXWGvgGoVpwaRhgtQBleiscmrLw2rpTbO51cJsW/yxt
         4vzaxSyxZbhWw22stwSSNhDkwjkNSZstSal3GS3D1xPe31jMxXc6nCeSKglte2b345hc
         wN2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751987548; x=1752592348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YAUBR/u+RT3eCuaRQRZ/Ht0agoAR4js0pHVirBrIafo=;
        b=jyjan9MGwhVYpnqhAUjHrGoNb/Y4JPLDHeUy01jBBYTwqPRs9LnbnERuwZ0PqLa895
         26QGsbpoztJ7JAiL+g0veoXWZfCl2t4r34RaF4HZA0ACsCySCpFBbnbsy4SAIOxFxdZ/
         Ddy+u6GyqZLVQVZfrMdlZm9i+/OxIceiLA6mTyNFUT7RTdOwniH52EibIccl6gtT8J4t
         F2m3gViKLBSVcY7y4oUwEq0qh3U0hqGxUPOLe522XsVd7UWhlcjKjo8FUTUb7ScAWTsJ
         JiFTZvRmQfTGw2suVLZ3YS+rz0exkl6ntI2shpSlMS3LxRur7OtejoAlGnivXb8qaWmL
         bsgg==
X-Forwarded-Encrypted: i=1; AJvYcCVluoU9dpQixlb1DZR+xjsiPpc4pynORW5hJQwGFC050VTfBLjELSD48b2g+DDLKH3G6TIwWHg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQxRmslrj2cnrr3kYX4LPjxsJan1MHwlwCy3PkP3KgHaRGlOEv
	Fkmxhqy2J+feau/TrmhAXUZf1yG0a0zxJFPFqyMmwRDTBFr1FClQ0N1c
X-Gm-Gg: ASbGncvBYvhvIRmnv90X86Mo2ds/0FAiWonkpDivofvpxbZGbLUpSirJOW6O8XB0PxE
	QVXDcOtfF3H3Uh6BKyOv2dBnYQq3Dl5riKvhSokrpuFJFUiKH/e2ZCOrji5BaiEORqanMDQca4h
	exUYmXWha8RIltmIh4/xBXitkVogZOWJFXE/rj8kHefFFyjHEY2ucY5q3MSYuxcyi4EFwGwBA7M
	vjgsmzbHuo8vuwpLJuajMPfQKSR1ZIGzKXF37rWHN9TIrJkaBXVepuXED8mnPQMJSzP/mbKtymN
	k6J8K6hEYHLY4P3likKUjlCypCJGw5cj3OfvGMIN0ndSfe4x7f7AS0MT5+JdQFIq7AIa467aijd
	auB6w2PKc1cm/RiLGhKBo1Ts7FYb7o6kKmdjtxP7FWdF7wpVdkIcxScRsIegPLCY6nDCgn6bDjA
	AFOrBf
X-Google-Smtp-Source: AGHT+IEv3oJ4Ui33L0KLof0NPPSG/UhfK4myNPOGcqm1VFqUfy96pX7vQ+1OxM6f0rlFUOuQBD3tVw==
X-Received: by 2002:a17:906:6206:b0:ae3:cf41:b93b with SMTP id a640c23a62f3a-ae3fbd50f83mr1632665766b.41.1751987547316;
        Tue, 08 Jul 2025 08:12:27 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae3f6b02a23sm907596766b.112.2025.07.08.08.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jul 2025 08:12:27 -0700 (PDT)
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
Subject: [PATCH v14 nf-next 3/3] netfilter: nft_chain_filter: Add bridge double vlan and pppoe
Date: Tue,  8 Jul 2025 17:12:09 +0200
Message-ID: <20250708151209.2006140-4-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250708151209.2006140-1-ericwouds@gmail.com>
References: <20250708151209.2006140-1-ericwouds@gmail.com>
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
 net/netfilter/nft_chain_filter.c | 59 +++++++++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 846d48ba8965..1d09015a64d6 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -232,11 +232,62 @@ nft_do_chain_bridge(void *priv,
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
+		ph = (struct ppp_hdr *)(skb->data);
+		switch (ph->proto) {
+		case htons(PPP_IP):
+			offset = PPPOE_SES_HLEN;
+			outer_proto = skb->protocol;
+			proto = htons(ETH_P_IP);
+			skb_set_network_header(skb, offset);
+			skb->protocol = proto;
+			break;
+		case htons(PPP_IPV6):
+			offset = PPPOE_SES_HLEN;
+			outer_proto = skb->protocol;
+			proto = htons(ETH_P_IPV6);
+			skb_set_network_header(skb, offset);
+			skb->protocol = proto;
+			break;
+		default:
+			proto = eth_hdr(skb)->h_proto;
+			break;
+		}
+		break;
+	}
+	case htons(ETH_P_8021Q): {
+		struct vlan_hdr *vhdr;
+
+		if (!pskb_may_pull(skb, VLAN_HLEN))
+			break;
+		vhdr = (struct vlan_hdr *)(skb->data);
+		offset = VLAN_HLEN;
+		outer_proto = skb->protocol;
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
@@ -248,7 +299,13 @@ nft_do_chain_bridge(void *priv,
 		break;
 	}
 
-	return nft_do_chain(&pkt, priv);
+	ret = nft_do_chain(&pkt, priv);
+
+	if (offset && ret == NF_ACCEPT) {
+		skb_reset_network_header(skb);
+		skb->protocol = outer_proto;
+	}
+	return ret;
 }
 
 static const struct nft_chain_type nft_chain_filter_bridge = {
-- 
2.47.1

