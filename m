Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7654423E320
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Nov 2025 19:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762716287; cv=none; b=h4Ktou1PV9YwM4eZ7qGojHRP51iwRZSveUhQFq6Aj3G5rihYKlyZuC+/F6oB5cwtY+/M4hU/hq0VswThuRVmdhyErl28P575U655nHfJ2xGlTgwfwbN6DNlqKm5BeeDXw9KXRfbG1LYeGS7Y4aDfJPQv4wb50ZwBsWccP5oLGF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762716287; c=relaxed/simple;
	bh=NfMwE8dlBybLdyHrMU5tp+2O3dmiRVolCqKrdaLCBmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBM9qqRpByLqpiiz2LuTDOJLJ/iI9QT7jnk1fQtUNH9A9Ohk6zDWanKKyMlj/uwag/19P4lUDsnXS8M0n2Tx9/CD+f4xfgMBwNZ7HCBjINlKyrVZIh/R6yQs2i1GZ+f/mgUDOFceI1LklL3u7rnSdu8X+GWfmiafb6bqOYWYiEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iQ8XSr45; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iQ8XSr45"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6417313bddaso1255400a12.3
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Nov 2025 11:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762716283; x=1763321083; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hS4vmMYkkCMh57/80KWcAsjRY0+LD1ZQh8tlkeNEwTE=;
        b=iQ8XSr45lcd5q2cmM3YTKlkFTa+HRSCKeA2+UqVSo01JwYn68dOG/D/XoiiCfetjo/
         EvRgIeMFNiZE2/Ye+FoyVxul3Cp3pHdpo0PdAolTGDaxt7cIhxSIBG9TGhD8FIBwAaJr
         XU+Md22NNkWq07PHsl3lWR/ermDiEKiGCHO8iucFdZ6LyQEM4BPQ1tU9Vjt1gVE/wtFt
         zpjRVgG+eUAfs+XQF/g9lJvzyF24P1C2LYjgXJexP8LLwgXfyYbjLemRJh0qZ3w9PHHx
         ObhChDzl/m2YW2pvaoTJ2t5ANHmLBn8LLbxxhGDfSxP4iioMSo1aEX/rOA0T/LD8/AGE
         kgrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762716283; x=1763321083;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hS4vmMYkkCMh57/80KWcAsjRY0+LD1ZQh8tlkeNEwTE=;
        b=jxd+j72dsvuR4w17mnjAN4drDvjBYP/6nU+zULZrdxlH6OkgQX5aGnRTw1J14l0deU
         Sj/xnpXdt1zak/FSt1/8gjjpKFU1QC9F1EXUdUcdBee7C+WdNNNZ/Bi2HjC1pHBMAa1A
         ms+cZO6poKXU6FNp+JlvPdzIcJQFLhrQBKJogQ70mZXsgufRV8d+BXaLHXNc/I+Ck41x
         dWQ8Q8kpg35e46IAb7ILWU4oolw/acyb3lnZG7+aUnZQ1to+36b4ZvwfT+t38RanwT4s
         /LrCN+jeWBDjD29kY8BbrfzEB9ZeIblkGl50kpL5/bHUglvuod4UPJkju3ZxUn8JTg+a
         nVhw==
X-Gm-Message-State: AOJu0YwfulbfVMeQzWiNlWLt0SxIk3yrbW3qEvaHslRuc3KO0XmDCMzK
	TEYHEltSw4sgcSIFyDouNSJ6G0sWdJpXoEtT/FD5uSevkMaVq6kGJBWW
X-Gm-Gg: ASbGncscs2AtadFNl85CWx0C0ZZDkbgUD/r9QyaJ5Fj0EDKCuDWXz2/GL6FoXLqdb/9
	hlAURh385JJb5h+IOYA7NnsGMBYd1PJFGMk6H/Q8cnkWonSLb38nFcUOc47wIwf2HdAmzgniSmq
	/jwdVqTtnJw5vqKXZ7qz3gseJBb54iZ13hyvqvOtszlvM2Sa6dthtINH/cHWBukdE/NfsEHY3Xu
	/RY7LSXGAbzV6WYPddIkQRR40G9vgq9ZJMJlUGYJn47b1m/Jxy9OGyFG0Wo/i97The0psYmH/60
	o4mFtdCNYTOuWTiz2mpjONdQR07QL9G2Pnfwqs1+5qA38fQ2BTG/FWJG5M283dx/RAL7r75dZSY
	Sj/tDsE8dOg3IBZDSAVrCis4uxFo5dLbrrbXY6R+W+7TIKgSd36L/k2Zh+5PdU2PLjR2QKHNPTJ
	DXxvQKL405UE19aAZB37oa6CSzBsjp2pGkH8McZTLJhEeWRqNKHpRvgoNdAW0jVw0dfXpxOREOB
	mlsJEx23w==
X-Google-Smtp-Source: AGHT+IH97I/DBz8O1O1cNdMC5n7mLspwOnl2jq3tWIZKwko84qxwSv/wHhaodHGaDoHLoE9ZfnxFIw==
X-Received: by 2002:a17:907:7ea4:b0:b70:b5ce:e66e with SMTP id a640c23a62f3a-b72e02db993mr614713566b.21.1762716283159;
        Sun, 09 Nov 2025 11:24:43 -0800 (PST)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bf97e447sm919652466b.42.2025.11.09.11.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Nov 2025 11:24:42 -0800 (PST)
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
Subject: [PATCH v17 nf-next 2/4] netfilter: bridge: Add conntrack double vlan and pppoe
Date: Sun,  9 Nov 2025 20:24:25 +0100
Message-ID: <20251109192427.617142-3-ericwouds@gmail.com>
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

In a bridge, until now, it is possible to track connections of plain
ip(v6) and ip(v6) encapsulated in single 802.1q or 802.1ad.

This patch adds the capability to track connections when the connection
is (also) encapsulated in PPPoE. It also adds the capability to track
connections that are encapsulated in an inner 802.1q, combined with an
outer 802.1ad or 802.1q encapsulation.

To prevent mixing connections that are tagged differently in the L2
encapsulations, one should separate them using conntrack zones.
Using a conntrack zone is a hard requirement for the newly added
encapsulations of the tracking capability inside a bridge.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 92 ++++++++++++++++++----
 1 file changed, 75 insertions(+), 17 deletions(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 6482de4d8750..39e844b3d3c4 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -237,58 +237,116 @@ static int nf_ct_br_ipv6_check(const struct sk_buff *skb)
 	return 0;
 }
 
+static int nf_ct_bridge_pre_inner(struct sk_buff *skb, __be16 *proto, u32 *len)
+{
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
+			*len = ntohs(ph->hdr.length) - 2;
+			skb_set_network_header(skb, PPPOE_SES_HLEN);
+			return PPPOE_SES_HLEN;
+		case htons(PPP_IPV6):
+			*proto = htons(ETH_P_IPV6);
+			*len = ntohs(ph->hdr.length) - 2;
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
 static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
 				     const struct nf_hook_state *state)
 {
 	struct nf_hook_state bridge_state = *state;
+	int ret = NF_ACCEPT, offset = 0;
 	enum ip_conntrack_info ctinfo;
+	u32 len, pppoe_len = 0;
 	struct nf_conn *ct;
-	u32 len;
-	int ret;
+	__be16 proto;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if ((ct && !nf_ct_is_template(ct)) ||
 	    ctinfo == IP_CT_UNTRACKED)
 		return NF_ACCEPT;
 
-	switch (skb->protocol) {
-	case htons(ETH_P_IP):
-		if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+	proto = skb->protocol;
+
+	if (ct && nf_ct_zone_id(nf_ct_zone(ct), CTINFO2DIR(ctinfo)) !=
+			NF_CT_DEFAULT_ZONE_ID) {
+		offset = nf_ct_bridge_pre_inner(skb, &proto, &pppoe_len);
+		if (offset < 0)
 			return NF_ACCEPT;
+	}
+
+	switch (proto) {
+	case htons(ETH_P_IP):
+		if (!pskb_may_pull(skb, offset + sizeof(struct iphdr)))
+			goto do_not_track;
 
 		len = skb_ip_totlen(skb);
-		if (pskb_trim_rcsum(skb, len))
-			return NF_ACCEPT;
+		if (pppoe_len && pppoe_len != len)
+			goto do_not_track;
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
+		if (pppoe_len && pppoe_len != len)
+			goto do_not_track;
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
+
+do_not_track:
+	if (offset && ret == NF_ACCEPT)
+		skb_reset_network_header(skb);
 
-	return nf_conntrack_in(skb, &bridge_state);
+	return ret;
 }
 
 static unsigned int nf_ct_bridge_in(void *priv, struct sk_buff *skb,
-- 
2.50.0

