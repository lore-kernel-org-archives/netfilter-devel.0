Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF503164DF
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 18:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758825064; cv=none; b=qtR5KEQctxTFSBjrnEsFCzDq0gg9s5lvydXf2Xoc5qHmZIiP27ARW8bFDKBbDRQ5iNN33fGHtvjss4OyJtRQ4+unr1s82j7R7wW8A3873cE+I6Fow8IuS7ZEZaC9CReYRlmLyllG+U7ZXhSZCrpuBQi/jq04akK7csqaHXwQLD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758825064; c=relaxed/simple;
	bh=ovH7NLxlzzSK9WVYC0PhEMqPjPiuDuf7OAcH4fUbX94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXg0zruVc++T9pu2CjheIztLCWBWlgduI5Opcy/WNGWJy4yJSJfau2frFYoa8T+46CvYIA6PIyqpIFYHxiWD1cMHGAZA2bWJAM0wEhdoiRo7nfRdF7xIOYRkGXAFxAalWKseKB04Cqdxl8fW8w1FpCl2RkjsoFOiqXcKLcCMsRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ETSmPDXJ; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ETSmPDXJ"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b3331adeadbso340477166b.1
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 11:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758825061; x=1759429861; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G4i+bCQ5MlHbYcO9KO5Yge1iebjxDWaZWFM7hLHP88c=;
        b=ETSmPDXJW13GXtpQeg2tt13VmcgunpPIRGW0sfpUT6Un8ozYAUY9fKwgE4QPNV9q/Z
         JatTnvQDvUK+OU6qNdqtCSABrbWBC0s16TzbCI2VM3dgOY9zfId+iIE9FLFfDJqPzDLG
         9n8jQEVTQTTLkGal9WmY0ndz5c6amPMvaWEexIx5JLLkrI8k/8eJ5xQIwHo2JMcfcAww
         fSRD09rmGtTzUZP28X7ehiBKUsAXp3OznY32IFou3N4XfkSVeBZWSW+6EV4zHQiykvON
         o/mCL5d4vye9cPMVF1zJJW6SR8fs5Hc+AYzYgK8fXCA2Q/6kqY+jXDxMG5wooPnPTolf
         qg9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758825061; x=1759429861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G4i+bCQ5MlHbYcO9KO5Yge1iebjxDWaZWFM7hLHP88c=;
        b=CuOX8NNhRs6V7YSXndugnpBu918Z0/HwC9jibRaqfmFuWmGvUjmU2K4ANAMI5uRbuN
         ib0peQ1Zt4Fzqr80p7aqdp7g+g/gnYZENFiYt7MlirzaVbOfAwbakGX3ZnsopVWtG2Nq
         ZlWG990nG23dfhpyxeCf6xumK6LwokDCphnvK+UFk/Ve/7P57CkP2+qQv3CnkTkpZBSZ
         ReUzrERzxKtkVHMdDsNXRA4XOfzws9RnaXKDb7vbNO1kO/hDjbWMMBAMNQG37r/vISuW
         Wpdnf2tv3Nfehj65aC+hchOYKERHQU6SDgJkfwl4HqOdR7FcCO1vSageP/duCQbgvom8
         zWOQ==
X-Gm-Message-State: AOJu0Yxmh7T59aXWhpcosf14UJWFZ8ZS14J4oRKETUTab28/3BjkC35L
	EXRtpov9hs7GIyqm6a+zpwc9Q8zXM+ZxFPvo61e/9I1MWhefAtYxYc+4
X-Gm-Gg: ASbGnct+SrHutkiRVttlO3LCkELmPACZwjU0c/sW09VQBY4jrS7dvtWc9uwSDm5a09a
	eLJQvwApUknSpfCE0M2mUvPzBa1orrL5IScsAfTztPInkjDKGTttd2WIQsNJhCwJ357/M3MeHnw
	V4/vgOskTJB8miC30GGfgHI34AUe6J0JwR9GKA2BzoB1ZrNYLDQTOrHV9dyE5usCEJ5RZJT0L2c
	I+CE6KhHJzKl/jj1i6DepKwm7Mosk2ztxovz4JzQ01WY1FlRFgP6xud4Bqyjs7rHB4BBbXVu9S1
	VIEbRqHnrQGFb/eW2J1ZCtqpW7AbmP6vV0Yb/531ocbloKOsXjxobZN6SCFKQ3mrFEZzoSxHETP
	xMnasYbSiXgbnau0dNvi2TGLWuLOZEepLLUdQS5wxB2LS5tsnhoYcqGIPxFZMG7QzvPbRZNbw+4
	AXGvy166JVlPVqYp0U+g==
X-Google-Smtp-Source: AGHT+IFPe/dbeDF6Im7/W1h15NLhKANyKOEKqP6yxsuAyUtLh3wQ4f95Oj+7V/uEOpOQCqQ3G+kRuA==
X-Received: by 2002:a17:907:7f8a:b0:af9:8739:10ca with SMTP id a640c23a62f3a-b354e31bbacmr390106366b.28.1758825060520;
        Thu, 25 Sep 2025 11:31:00 -0700 (PDT)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b3545a9c560sm211198666b.107.2025.09.25.11.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 11:31:00 -0700 (PDT)
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
Subject: [PATCH v15 nf-next 2/3] netfilter: bridge: Add conntrack double vlan and pppoe
Date: Thu, 25 Sep 2025 20:30:42 +0200
Message-ID: <20250925183043.114660-3-ericwouds@gmail.com>
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

This adds the capability to conntrack 802.1ad, QinQ, PPPoE and PPPoE-in-Q
packets that are passing a bridge, only when a conntrack zone is set.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 97 ++++++++++++++++++----
 1 file changed, 80 insertions(+), 17 deletions(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 6482de4d8750..d3745af60f3a 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -237,58 +237,121 @@ static int nf_ct_br_ipv6_check(const struct sk_buff *skb)
 	return 0;
 }
 
+/**
+ * nf_ct_bridge_pre_inner - advances network_header to the header that follows
+ * the pppoe- or vlan-header.
+ */
+
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

