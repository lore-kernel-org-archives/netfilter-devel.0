Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266F01E0E00;
	Tue,  8 Apr 2025 14:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744122398; cv=none; b=U9QM2rzpfYL8HvAXivIrghb0D9Glx5u7rnPXbRsN1zPMTjD1/ZnXd5bX2PY6l779b0r2g+Th7bLIOvT0XtiICQbMAFd3tBKwYOZhY9h2Akc5+R+fE08QjPm2M2dJWoBHuJVjnmI53HYfDiAEmtTkTqYM/wgBuJu3Cn0ZdL8Zt1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744122398; c=relaxed/simple;
	bh=uRS6L652Q8U04wSm9vVBsJo+AraqGWbdvUpqcrlUEAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFm1W9yFP3FQpmtsaf6SEaz2+BjVAewBHsBkKNOaoGWVUyDHZ5QQtaZyjEuFfQnGhzsLB061w7IcGBptuZwns40JYUSG7AdluGH8P/xFFGXJXG4FbDnGEd64qpx2RE4e4k6dyw2Rkwmy43MlMmQG6sSlE77vJz8QBUDXNoa6rc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HF4jYE+x; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HF4jYE+x"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ac7bd86f637so1015933466b.1;
        Tue, 08 Apr 2025 07:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744122393; x=1744727193; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pWKZKslFax2kV4u5PDGKsv4N0lJQ1f1k8yO/foh+po0=;
        b=HF4jYE+x1p7feaZq4EY6/FZUlduBEVnVwuEPmuS5jSYySY4H0KYfy7/3S9Zi0RcNrg
         ajksLTVN2BkE4A+95N+rZV/xF5JkJzGVDBxsCYEDs9XYjS3p2ZDcXGyX4gT/E6et1Nhq
         ntdlSqaZWWQl1bwN/xODJLypD8nwl/cDxjXkaoPPSTrOwYDzi4STQvPfA/K38FNArn7e
         o8q9ifB91cPiOzMxFgZ2RpBy8kmmvwkcMHqdpet/u2aPMsOBb1pS3ZKPiHYXR1JVcvGA
         wFdb7blgzFD9BOYX8NYt0PSS3xWYOfJL4sviyF5TozTaEewX5RiLTgi4DT6Ur1HkvKZI
         62hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744122393; x=1744727193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pWKZKslFax2kV4u5PDGKsv4N0lJQ1f1k8yO/foh+po0=;
        b=JzIXL4ZByJImHPLyJkwmv3klkpU3lvyvgg+uiGYO2G2keXU5Y6maIjlPelE5RWF4et
         RuV6BuVgivL7vSmAh7bSSbSe3BUotCnVptDk/jRDW7SnHU8Nz4KpC+eBwVIUG9f4EHMa
         1aDuLuh2vTfsw+jlLLJ7qQVHiKdLRIgDmCHmYVZL1fqElYLSrxHGwP/iZanOTcYCmxhS
         aq7HKDudwHfG+TjngmNe9LuV6GKbjgJR5HN6s3+DsMN+43rbhEsu5GKnz6KgSdU48Amx
         0IHRLQUDHLqrP86UhVV0wPo8ZwnOY4jB5mMUxO1IDNIPnQijC4IDO52pkPBopBRGI/zO
         zeCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZGQXtDaFSUjPjqPAD5pqjioLOLehSpV8G8030IffUV08c+Vqcuq5/g62bZUaeTSe3XxLddX8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyue1hXwzVkdpmrTfXZ8EvOL2E5shoQGEidTPg6u+f95E8UCBC5
	8CNtJNPgJEOlAyN/tRh0MRjS8QeqprRXdp66OqISfwS2aZQjX72j
X-Gm-Gg: ASbGncuMy9KwUadzk6T3wIFaU0LjET7tYMB3+UOaCBct+dmflU+TUWqcA76WbWvAYw+
	XTo+8JgZhq1tUo/9nHH2RhOkUhiCvMYbnNxCAEzbxzXxUzOxcvh/Hb0fq8/crc3bAhAKeq0AL8g
	gX6o0sfKEGUZ8bXUxpTQxZSRH+dyUBR8XiMqhgZbYoT0lsj/ZpsrrQDKOKjMdVGLkE/9Db4nSXy
	GnKjwM3tsCaEciwPARWEptjPFEK0IILGNcKvIBtG0AHthZfxMvKwIcw+Jo3+HhEWBDAxdYuh6w8
	LSqPnULB5lvaSs2chjOg5X7AwAGnMwnBYDYk6H8BtlttdwLPPgfLOkSmrNHbZmkmRcafJvO81+A
	BI0xKVS2PIuo6u/Pu3XmJWogLs1L9uVVpZ7Aj33D9RqHeQ/IonAVmIzG9B4OCcGDzIi53zbAfDg
	==
X-Google-Smtp-Source: AGHT+IE/4xh7JZ8ie6FtQuBeNAOdK9l5F4HHL+F70wOa909hMeu4+jVo1k+aTmmbovneAXWkHDROVg==
X-Received: by 2002:a17:907:1c1d:b0:ac7:31a4:d4f5 with SMTP id a640c23a62f3a-ac81a667c03mr323981166b.18.1744122393113;
        Tue, 08 Apr 2025 07:26:33 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7bfee2591sm926664566b.79.2025.04.08.07.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 07:26:32 -0700 (PDT)
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
Subject: [PATCH v11 nf-next 1/2] netfilter: bridge: Add conntrack double vlan and pppoe
Date: Tue,  8 Apr 2025 16:26:18 +0200
Message-ID: <20250408142619.95619-2-ericwouds@gmail.com>
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

This adds the capability to conntrack 802.1ad, QinQ, PPPoE and PPPoE-in-Q
packets that are passing a bridge.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 83 ++++++++++++++++++----
 1 file changed, 71 insertions(+), 12 deletions(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 816bb0fde718..4b4e3751fb13 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -242,53 +242,112 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
 {
 	struct nf_hook_state bridge_state = *state;
 	enum ip_conntrack_info ctinfo;
+	int ret, offset = 0;
 	struct nf_conn *ct;
-	u32 len;
-	int ret;
+	__be16 outer_proto;
+	u32 len, data_len;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if ((ct && !nf_ct_is_template(ct)) ||
 	    ctinfo == IP_CT_UNTRACKED)
 		return NF_ACCEPT;
 
+	switch (skb->protocol) {
+	case htons(ETH_P_PPP_SES): {
+		struct ppp_hdr {
+			struct pppoe_hdr hdr;
+			__be16 proto;
+		} *ph;
+
+		offset = PPPOE_SES_HLEN;
+		if (!pskb_may_pull(skb, offset))
+			return NF_ACCEPT;
+		outer_proto = skb->protocol;
+		ph = (struct ppp_hdr *)(skb->data);
+		switch (ph->proto) {
+		case htons(PPP_IP):
+			skb->protocol = htons(ETH_P_IP);
+			break;
+		case htons(PPP_IPV6):
+			skb->protocol = htons(ETH_P_IPV6);
+			break;
+		default:
+			nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
+			return NF_ACCEPT;
+		}
+		data_len = ntohs(ph->hdr.length) - 2;
+		skb_pull_rcsum(skb, offset);
+		skb_reset_network_header(skb);
+		break;
+	}
+	case htons(ETH_P_8021Q): {
+		struct vlan_hdr *vhdr;
+
+		offset = VLAN_HLEN;
+		if (!pskb_may_pull(skb, offset))
+			return NF_ACCEPT;
+		outer_proto = skb->protocol;
+		vhdr = (struct vlan_hdr *)(skb->data);
+		skb->protocol = vhdr->h_vlan_encapsulated_proto;
+		data_len = U32_MAX;
+		skb_pull_rcsum(skb, offset);
+		skb_reset_network_header(skb);
+		break;
+	}
+	default:
+		data_len = U32_MAX;
+		break;
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
+		skb_push_rcsum(skb, offset);
+		skb_reset_network_header(skb);
+		skb->protocol = outer_proto;
+	}
+	return ret;
 }
 
 static unsigned int nf_ct_bridge_in(void *priv, struct sk_buff *skb,
-- 
2.47.1

