Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1BD2E091A;
	Tue,  8 Jul 2025 15:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751987550; cv=none; b=RuRuHBhfrbwVAq4PVkkMExNMCEnXu70YpLDTOM1TZnpih+qIqc1htDlCqlBJGHARElxNCrKPb07RGW6lHqqAmilUbLS8DJTavvxBNTtEFXJFSAjMXJn+M8PdqNs99KVUzhVGNbjdQij9PAJ/BzJqXyDJRUx8IgF+7kcmxyESXdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751987550; c=relaxed/simple;
	bh=1EGeNMcKEoAS6plzFdAvSLnrC7CBK/RtieKjFgE4p+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhbL0PiEuSO/8U4fZRxcb2mGE1oc0bRkwJ9yASmM7Abat/qEm5JtwdsukEoiFvH9u40NGHZpiuUHC5gEakCkrBaHlndpPVIMWhLCVJVW8BddhgOLzrY6BuAJsgcF8fHMv54Uan4DXa42HIItkoMPcLkm0l8bIUL0MofrKQBjzfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B6sGpwn9; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B6sGpwn9"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ae401ebcbc4so736945366b.1;
        Tue, 08 Jul 2025 08:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751987547; x=1752592347; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tOzzS6CGyYck17Ilz06ZcjMy829mvTI6FpgNABmXetM=;
        b=B6sGpwn9CT6zU01BJkWXt2l8dvAa+071Rc0mO9vjcEmKTxfb2mWqTmANIYYPVUZkVE
         lwQYDk9RZyAXpHVzNkHNODtpLtM+Ep8vCgu2AlDhwIsvGwdktSOA5/jY5GmqhKcSSoRD
         qDq3NCs6im7ddsoL4ZuzzSDiej4qkHKi/tj1XGxz9XztluRi1ExawVAtKEXraQprnVJE
         EaZ4V36LA0LOVDpOWzg8dxUiRvwwDl2+O2WpapqKdMiluf4FNk4yDErViQflCgAIDy4g
         mDSGOLJwqHirlz7LSorO37UwEotRScaIMLeztCjjpADfnOQDavhRB/xWx8j5nifpT9bK
         c7og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751987547; x=1752592347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tOzzS6CGyYck17Ilz06ZcjMy829mvTI6FpgNABmXetM=;
        b=XiD/HBiasf9wNBVJjnDAA6Dk3BoGHFG9d8l+wyZno+VxMprhmGvf0ftzj5RR6IQszd
         n8C8BrLngbFRQcsGPyCOyUiv1fqfhf1AgQO9zXA9NOFOIljae0F2+gF5Nyex7uvgBIv+
         oNDqSVhd3CZ1E6ae4ma8u0ISra1sDlkLT/pPBNrXru8J0W/M9ILucxiYs2kfB1AYo2Tl
         NqXRYH6YZRuGHEI2iERoG/EF7tzUgS1y4GDrX4MQ/yoDQAun+B+P1jstnfSLEUEb7v9m
         edwy4LD4LTVDUxNBiO7W2MxlbnH/ea2S+MKLWnK09dglFOaa8/fgDdjV+mEzCKdlDb83
         7pZg==
X-Forwarded-Encrypted: i=1; AJvYcCWdBoYNSVE7FbKGdJszsgHdLl9qA0BnsJZpn4Fjb7hO0Zwc7YBSsszFEJ8RDNcbB79dVdZLj5U=@vger.kernel.org
X-Gm-Message-State: AOJu0YycTlvP37ro6j0nim2cOSdiIQhe3AbIgHnYw9cLubDxut9cLFJq
	/FFtTJD+GOYzoARQv+VkZCZqIMLs8EweDLbRKKBN2nGdGpoyx7RsGkRc
X-Gm-Gg: ASbGnctWfNehUIdQVlWsa2uV068fYS/mTD6TT9r/rUqDYwzOUWw+cX1uPPcqlWnIr/x
	OxOWU32nwx3RfGfOtHBXQ90gNmNSskF1lth/6Y9wk9pVfpzzHKrVP1RnhtIzH+60ms1pHlXVP5P
	1j6H890cRCY3HR0c99nnVk0DOf4UTFOCcUWMoVYWh1jBtR0tqyEZm+T1TNB5jQ2Qm24YY9J/EjN
	uVT/ZzxaJ78fsl4OEl0FHE1jLtY30oCG89un++z1Mau7dZRS4njALCbWGz0ui8vC34hNHwLK29Z
	XNqognzMOK8uXn8AlKqinACgmT04G6W3PF0mzv4eLcMkhg90cV6zTgDpvu8jU+dcT9xlRTUwudI
	jet8yhSyYfVFJko7sXODbeeolvapT8Mylc44Uesbx2rK3rIQGdA7XGeuUWrt7/iRicyw32JJX6I
	K4bd13
X-Google-Smtp-Source: AGHT+IEJAWtzd09MByxZZBm7YIZpblH/PVFUkia/DbtlWbWHUGuRi5Lu7PnQgzWaBu0x7eNmOZ7RAQ==
X-Received: by 2002:a17:906:28d6:b0:ae3:cd73:efbc with SMTP id a640c23a62f3a-ae6b021b6c3mr325082766b.46.1751987546429;
        Tue, 08 Jul 2025 08:12:26 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae3f6b02a23sm907596766b.112.2025.07.08.08.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jul 2025 08:12:26 -0700 (PDT)
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
Subject: [PATCH v14 nf-next 2/3] netfilter: bridge: Add conntrack double vlan and pppoe
Date: Tue,  8 Jul 2025 17:12:08 +0200
Message-ID: <20250708151209.2006140-3-ericwouds@gmail.com>
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

This adds the capability to conntrack 802.1ad, QinQ, PPPoE and PPPoE-in-Q
packets that are passing a bridge, only when a conntrack zone is set.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 88 ++++++++++++++++++----
 1 file changed, 72 insertions(+), 16 deletions(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 6482de4d8750..ccfe1df5e92e 100644
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
+		if (pskb_trim_rcsum(skb, offset + len))
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
+		if (pskb_trim_rcsum(skb, offset + len))
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

