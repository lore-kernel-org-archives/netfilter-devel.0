Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2661F4CAC;
	Fri,  4 Jul 2025 19:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751656334; cv=none; b=bP1SHNZeZq5LrduigdHZgVj6FFJO63suI/MA84HIM8mNTPOhYCo7a+8RxiuBvO0yi9NXm0Wm+v3vEEbd3tRMExQCBWtJqzwzv3DadU/551ZmM+tSlT80OSt9KTSKLkgcN3wwEzVmMoD8OoV/6YQD7+57E5Nny2TlS7kDlVf1XBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751656334; c=relaxed/simple;
	bh=igXxmnQ60mmeb6eAscn5xBG3t9Y/o2UhtUwwvQihY68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYafKLjqpesF598xyutJa7awG78x5H2bfHLBGrHdUKi99ules8Z2ezdr+lPSlPlTye7wxNeqGE/LfBBaGdwtL7gyVzWsI6qLq9WmuyM8OM+zlC6LlCFcG/ZNQjYY9/3RSUkFVRjMC0Qln+BfDHYgPsy1urfybCDeibp+FpImU28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=euscmM/V; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="euscmM/V"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-607cf70b00aso2277886a12.2;
        Fri, 04 Jul 2025 12:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751656330; x=1752261130; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HHdUFtAdvgJwnXb8RIInEyCi2R2lnW6LihNXT9M7RKI=;
        b=euscmM/V0Kw0YvXq+ckkDKyIYrSZS3i/ei381zNp7rBSZdkTo5wnt38AM1Q8XAwtWt
         vUj2ZaKRY3yvfvXlrKWNnMuDl5Sx6W4ddAF8HgjxnuykjeFMwu/Xt2CHthzblSiSqTkx
         Cu3TPPkoeFgR5EEs1gED3JhhGScriFfQa4tSG9E38MDvx32iHNgkQd/lFaTfqFF9bVOR
         kca7w9H8BiqmRRbLDYxCEAvan5+3rW3CZIRzc6w/acY/YHwAqFYs1zyohXwrX1BtTfbE
         +pMIg0H7YqdTIqz7YXNsN1RR4404tvw8qrdB/kDAxgkxx6Snjx1z2uoPN4Qo/xN7WDAv
         l15g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751656330; x=1752261130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HHdUFtAdvgJwnXb8RIInEyCi2R2lnW6LihNXT9M7RKI=;
        b=l5Wc8JuM16yOE8JnEyIQtojTt4UO2o/2wi7TL+tPfEGCDjDerEPtuIn/PrVVa4XTVH
         qjLJ31x/eMm3hzoSlW8B0hej0QlIl2e04In3VuMS9z0WQP3GYiLZY5TjIRZHuPhgDvzF
         w7ubQ6BwDQK8ybpeD6fY5sgNbM5Z6j6nGNwSOrPKiFfBcre/asnKfLYisP5VeRXm0pZH
         8PVw9aVZcx1NwUhRydQXwGFd8GpkvBR7BQ9wnTP6ZZwZ3CCJEYIPNgjnFQOLmwprFuQS
         mtvDrEyDEx5NGJuwM4mMSk/emvme5PROMR3Lk+/hmDc61zxgrUR4KG054nlkg473yVmh
         j4Sw==
X-Forwarded-Encrypted: i=1; AJvYcCW0Xp+WCHJ7yjMaDoEtZ2UtkIZwFtUG5u/mPMC8ljQ/wA8WHcQdTrqCRIzH7FOSZvOIqJNIpHk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjVKKIoVu4H49DKQGrUG/zDGwD9JQcXUHQoHPL4Gh8+oLkxwVg
	xGmLZiRUHUegiS6aHL4El6L+avOctCGNQt8pLP3LpsDnKDCx1HEIlLO1
X-Gm-Gg: ASbGnctSJazZK2by4pukwDFV0it7zA/7kkkLoDvLpURkCB+X7t5kNifcoR2IvWtBnXe
	vkqqCCFwAhrmWuf4ejMQZupSaboeK8H6MIsw1R8+oPnLvKItYHFGLmt4S3BCpY4HuVkCiW9qPg5
	wbeigxOoRFDoxfhMS8t77lSXnL17esQpRySnpVBVv+33ceCEB5mt5jo1LyksCFCo8qpewfNYtlF
	HzLvVCpoZqKDzQkwoyCaLJczzT5as4JhMVbYLqaEitl8Lx4vGU/xx/tvytoRz/p6AkxUBF3etKr
	DpUiujQMKIN0oN9BKG/M6hUP/qI9ymQ3XsBOXBnsVwm3PufVb3HqRgv8ll3/ykRgwRqupouWl0X
	jJsEwHoIYJIVGhqIVMcPSn3A8LY9twbIPQdlsyyfV77AKG47EBO3DA86O4gPn58g1v5jfjG/wqY
	NyE922
X-Google-Smtp-Source: AGHT+IG28dLEipCl99gk1JhC/6x8fkRr4Ob5eBBDcI3fOD2kfCfsHMZ8G4wUVRKRnRh8VQOftWJa6A==
X-Received: by 2002:a17:907:394b:b0:ae0:a245:d940 with SMTP id a640c23a62f3a-ae3fbd809b3mr405229966b.51.1751656330251;
        Fri, 04 Jul 2025 12:12:10 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae3f6ac5fd7sm219476366b.103.2025.07.04.12.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jul 2025 12:12:09 -0700 (PDT)
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
Subject: [PATCH v13 nf-next 2/3] netfilter: bridge: Add conntrack double vlan and pppoe
Date: Fri,  4 Jul 2025 21:11:34 +0200
Message-ID: <20250704191135.1815969-3-ericwouds@gmail.com>
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

This adds the capability to conntrack 802.1ad, QinQ, PPPoE and PPPoE-in-Q
packets that are passing a bridge, only when a conntrack zone is set.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 88 ++++++++++++++++++----
 1 file changed, 72 insertions(+), 16 deletions(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 6482de4d8750..5fcb1bdf2e31 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -242,53 +242,109 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
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
+			skb_set_network_header(skb, offset);
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
+			skb_set_network_header(skb, offset);
+			break;
+		}
+		}
+	}
+
+	ret = NF_ACCEPT;
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
-		if (!pskb_may_pull(skb, sizeof(struct iphdr)))
-			return NF_ACCEPT;
+		if (!pskb_may_pull(skb, offset + sizeof(struct iphdr)))
+			goto do_not_track;
 
 		len = skb_ip_totlen(skb);
-		if (pskb_trim_rcsum(skb, len))
-			return NF_ACCEPT;
+		if (data_len < len)
+			len = data_len;
+		if (pskb_trim_rcsum(skb, len + offset))
+			goto do_not_track;
 
 		if (nf_ct_br_ip_check(skb))
-			return NF_ACCEPT;
+			goto do_not_track;
 
 		bridge_state.pf = NFPROTO_IPV4;
 		ret = nf_ct_br_defrag4(skb, &bridge_state);
 		break;
 	case htons(ETH_P_IPV6):
-		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
-			return NF_ACCEPT;
+		if (!pskb_may_pull(skb, offset + sizeof(struct ipv6hdr)))
+			goto do_not_track;
 
 		len = sizeof(struct ipv6hdr) + ntohs(ipv6_hdr(skb)->payload_len);
-		if (pskb_trim_rcsum(skb, len))
-			return NF_ACCEPT;
+		if (data_len < len)
+			len = data_len;
+		if (pskb_trim_rcsum(skb, len + offset))
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
+		skb_reset_network_header(skb);
+		skb->protocol = outer_proto;
+	}
+	return ret;
 }
 
 static unsigned int nf_ct_bridge_in(void *priv, struct sk_buff *skb,
-- 
2.47.1

