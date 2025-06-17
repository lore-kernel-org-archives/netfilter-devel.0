Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3AE28B4EF;
	Tue, 17 Jun 2025 06:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750143536; cv=none; b=d/FArAmuVO5pPTZYQZmClTgTy8mY6vshWvIgzkQVdqT4xsrmI/sfVA7nOeTj41/mOdTubXgYlxRR4zZ0Gp7OXSO/QkNVtbs3oG4mmfLxBnQKVMwfX6XgOYyN0F6Xf9hX7t8UESPY6BJjzz4aQxp5bj7VewizuSSHhSMxqfkXzBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750143536; c=relaxed/simple;
	bh=RWmkJ/7u5G1HzllFN3491RhnCUCphXkvPgUlTLkcvKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbszwugZcdeNID+AH8Uth0EcFhGO4KHti7D8bM5NVYfd+htB2LNqENI4HS+c5XOD61lJ/Rw7ZqNy8ndPxvcqSXAjGfsJTmkyoHd3n5hmsaElyafEPC5G78koxAjTw7hsbphWYqvjn6GfU4C/1NyfbKNlCAa1uUY4QpjPNgZHCoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CfrxhKAk; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CfrxhKAk"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-acb5ec407b1so876164266b.1;
        Mon, 16 Jun 2025 23:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750143533; x=1750748333; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sqk/3oU5AS/JSMdKQuGdEhrPxwTap+QDTjCKKWH0KEQ=;
        b=CfrxhKAknsRRSkUSp+rI5R+IvUMSN+NEC0IXGx99MJa8XmAV8cwecyoRJhbt7XTGdC
         VSWoRHz5Q/OkkR/ne1Rcm0+wjh4QRLm6Orrb+1aWIj15WDsg/9TofcpKi2RQBC9po0gC
         BN1snxcPzkwX9RFckB4hiAw0CiqmsLIwULqzpaeJYas11RcV/XY57XtVqU0lCNcB6DoB
         ZKW4GarQg8dFPIoJrHcyXr1VTOilcEVL9N/KH5/VrmWPBNRzNamn5iQA6seCWXaC8Soc
         werTZx4kpTkCq/80MprjKsfD9NQELbKVeTODqA8dxMVnlTSaqWGkxm4m04IAB1A4fXJk
         G21A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750143533; x=1750748333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sqk/3oU5AS/JSMdKQuGdEhrPxwTap+QDTjCKKWH0KEQ=;
        b=pOhl3c9ANAgwNiUPQ2V1vRw0Fjy2D+TLxs44C78wRvZYUc5Y7pFy/IGM9j+lGrfdA9
         pPw1hJZuizk5lEw0dhiavxfdlyiYKVviIV6XPA18ZRQDek7PrR7xYgcNfaS7PsMaX4mU
         gG73WC59Y9eW0Mu1jjUo+hVJ7fAktkSPG2SkQ+6USZuiW7q6OL4RGDdVF10Ck43VDoPj
         kfW0G9T0HqhMZMtyj6Z8o8qlCxGjsm9IiYiNLGRg/MegPbrzPwwlaGwp6HcWWsJoTMCn
         5IE1EfCvXiWAuWZlIg1yH8CVf4/dj+nj4aPcejLYWejG108o4xgEzBahRS+DW0be80u1
         G85w==
X-Forwarded-Encrypted: i=1; AJvYcCVGfy8s6FCNEvS3CXBwBgitcnF9xZXHvbzgDZ4otV0Oo0aBH3cusI+zcGUImZURjgzK2izDWG0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwY5ywKP8tcwwxrmYVmamYkF+WhVPIv74O/f0ImmstVJ/f/TXu/
	TGGlGVeWGRymuQ366y8wgzJ63IZSrEXGEoNLAto1Cf9bLx8CaTJjiJQN
X-Gm-Gg: ASbGncvxmiiXBxLxlvvB1fdOWYJpkjTyXITy8KWJMhapwVzShH+FEh70yb3R033s7AA
	IK9mFRmVXDVSIZkFHCHnMchZy3+piN8owfT8IuWEwJUoBY2qzSicgUgXvlE1QGjbx6AVWHZ76a6
	4BqtUK13S+PRZf+8R7h4FIUgCeE4ehnbAxEEb94FVw2y2gwvIlQ3wZA0mUif9C+2YggbyrXca45
	x8mTcYAeJSnaNwNxHhaIly/fxt4CNjrh+Z+brq37y1zIYDF5WMmzvPdQ3NszmEqmsyG2/hliPcV
	HVibo/L9oLY4NGnwrasMDtUslBU/8DZiQhPw1LdWTQf8pOvfU0V0J5NMdTUPl3MnJX4pMPvAmFh
	NkO7JIgJZvZSL4uDQkmfHJSf++meJ653S2jWL2S3ioftRdST2zocfcoqlBZKqnz4HZSwYHDlOxC
	pb335BsOeZLkJ3Qro=
X-Google-Smtp-Source: AGHT+IHVq3Jr4g6X4B6ydhVjvr05hSehOxXcoQyHnaOYsqdPbHyQel1QYjNRYThbcmfP5Zxv+EAmbQ==
X-Received: by 2002:a17:907:94c8:b0:ade:32fa:7394 with SMTP id a640c23a62f3a-adfad416c29mr1138271166b.35.1750143532908;
        Mon, 16 Jun 2025 23:58:52 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adec81be674sm811109566b.53.2025.06.16.23.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 23:58:52 -0700 (PDT)
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
Subject: [PATCH v12 nf-next 2/2] netfilter: nft_chain_filter: Add bridge double vlan and pppoe
Date: Tue, 17 Jun 2025 08:58:35 +0200
Message-ID: <20250617065835.23428-3-ericwouds@gmail.com>
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

This adds the capability to evaluate 802.1ad, QinQ, PPPoE and PPPoE-in-Q
packets in the bridge filter chain.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nft_chain_filter.c | 55 +++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 19a553550c76..b9ab1916be94 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -232,11 +232,57 @@ nft_do_chain_bridge(void *priv,
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
+		__skb_pull(skb, offset);
+		skb_reset_network_header(skb);
+		switch (ph->proto) {
+		case htons(PPP_IP):
+			proto = htons(ETH_P_IP);
+			break;
+		case htons(PPP_IPV6):
+			proto = htons(ETH_P_IPV6);
+			break;
+		}
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
+		__skb_pull(skb, offset);
+		skb_reset_network_header(skb);
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
@@ -248,7 +294,14 @@ nft_do_chain_bridge(void *priv,
 		break;
 	}
 
-	return nft_do_chain(&pkt, priv);
+	ret = nft_do_chain(&pkt, priv);
+
+	if (offset) {
+		__skb_push(skb, offset);
+		skb_reset_network_header(skb);
+		skb->protocol = outer_proto;
+	}
+	return ret;
 }
 
 static const struct nft_chain_type nft_chain_filter_bridge = {
-- 
2.47.1

