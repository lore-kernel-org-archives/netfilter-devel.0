Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C05A20896B;
	Wed,  5 Mar 2025 10:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741170612; cv=none; b=PWbMMjxidrl8ySL3sET6AIqzoWlHO/4rO52TEjw1aWe2DfpikHAp9tg2PiEadPGBSbUzb3DWO/KnYYmLbjDrjcwPz3tUKMLAHchmE4iy5q/bJ1qmrFbWX2Pu8sTWwJsr64R+NS8ZPjYgN9IhD8EaALuunCe9dC3YWt0cGnrTIis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741170612; c=relaxed/simple;
	bh=uRS6L652Q8U04wSm9vVBsJo+AraqGWbdvUpqcrlUEAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ci8gx+ClEmHbutwHTxxH+QX4xcsi3uSZ/37HB86UMD5I3Yrt54Nck9KaTHSXdiQt0l6k4zrcsvUyc0rbsKQ8Aze3nMDqhgT0GeL9+76RIfiD5hcz8R9DSY4tSFQ8wltV38W8yXnAN+Ugf8NiQP41yQPbn5Cl0bxAo+oS4JoLEOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kdsizpV7; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kdsizpV7"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5e549af4927so5418937a12.2;
        Wed, 05 Mar 2025 02:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741170608; x=1741775408; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pWKZKslFax2kV4u5PDGKsv4N0lJQ1f1k8yO/foh+po0=;
        b=kdsizpV79wBAXircupXHOuYWl/UcnfmQjzF2pu1Dj5pbXlHGT+YxrT0D7zww5QNCMa
         2YdJGPvtPL7AR4gDmJ/IdR883Qzwm3NwdKDsTeBs0vm8ZpdSslp1WnpF3X6LvTAur628
         nHnOeRsrsS0Q2At0XDVm/0IWKcBnq1yOyupJuKCMvwzSQbxxlll5EcgDNgbFYR/pOUAK
         i9u9FQH5fC5bzPGBVIzbfqdM41K0GkIMaZqjchc51KZcoI1obaihQBTy62LcslAZAVJv
         wrv+lgcIfIJJOAhcrU1daPsfQdciQ2jnBYgs7xcJ9tVXSoibX0xQbc0XtDj9sNPcNMhx
         fbag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741170608; x=1741775408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pWKZKslFax2kV4u5PDGKsv4N0lJQ1f1k8yO/foh+po0=;
        b=BYeJePdLptiG6+0Z5t6hfrJHdwK4MVgxb+wWb4xqXyEoWi8n3EZJpxrX6S2nJIuamY
         fglif6ojzNY/giOJEB101lOU5eBKpI9Uun1vyEFHd1W1KKRwdekquAHGF7r+smCDPX8z
         aJImA77qUOy/fFKO5h+dnt+bBKeoIbjg5QbHb2AkAGDBJ0zO2Wul2Vq1j8eV2f1U6mgy
         dPO/d4f4D9DGvvzZa8WqwMOHI1LfWgIvJcSRua6oMTcLaxwd0SW2AkwT8gvsxh4ksEwn
         /UL+Yo7Uf+awxPsRB/eoP+ye8usm4PR2oJYRzDvp57pWLsncIeuwS5LIAfGZbNM+qX73
         uxXA==
X-Forwarded-Encrypted: i=1; AJvYcCU457X691oLLFxJjBiD1IgqV1QOpLREI/Q+FDSHmEAGMu3HjAABiCmgPZjv8O6TDkvU+EaPdFoBJDtvA0Yahziu@vger.kernel.org, AJvYcCVrLXokOwijd5SKZkIZ2R5EK/kZjk0HGMBNEOzVlYECbhdCsczv8rOeit2lZlSBdjwP571G+A5gPgv+3tDOJYk=@vger.kernel.org, AJvYcCVwNc9n1KFh1S2QgrEQmcvXuuGQs7+xN2dt1I/9VuHOiXn/mbpyFadXsJXZyjqIl0yJKl/sgU8by1uL+kya@vger.kernel.org
X-Gm-Message-State: AOJu0YwKN/f6Hgmnfej0+j7AS03VVJYod/IqmO/e8khV6NlF8KSmooV5
	uq7c20SZYi0tYq7UAon7l+jmQm9kSfFu/UIbfTAE5nSo48gyT+oB
X-Gm-Gg: ASbGncu34sK9w/c7K/BpGpMvdcywh5CnagpH++abygTZBlhna02Bixp8waLYc4+GpUA
	qJdM6tzhavGAsEiTPHR34ITwLr0Nvh2cWLqGkTm4VuBWfnR3WlHE5dwCd0mlQeVwE+NE1u1Exdv
	zaPIf0NmsWvSnrA7mnxTuVKLgtmGW3FjN6T+m3Z7Cabxz372da2LtaflS44AGr5BTxvLPYhkBqM
	HCeIpMSejL0Z4bD13HF1PpYZx3MYQGG1NHltajfpOC19XTbVWOId0u+7H8eJDhiQKg++3HhOJ1S
	5GDvADntOdFMHE2fdsEsaofQy7EatMxnhWTSu+cbInJOQ/XSWBnvbFOaS8Rqs3z2AHlwR5IAq/2
	pO25eDj1T0QjApdcOtnmjP1PExx8iUnEJ89qJ4sX02dIzYjOsvIRiIBpelz5W8w==
X-Google-Smtp-Source: AGHT+IFexB2RNevlxHvMPAf8/WCLTLQ9IXmSXZbmZFMdhkY06Emnzf/hwS2/XrsP0oxSe3vo0bLssw==
X-Received: by 2002:a17:907:3f15:b0:ac1:509:79b1 with SMTP id a640c23a62f3a-ac20d8bc9a1mr236165766b.20.1741170608493;
        Wed, 05 Mar 2025 02:30:08 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1f7161a4esm247154266b.161.2025.03.05.02.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 02:30:07 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v9 nf 04/15] netfilter: bridge: Add conntrack double vlan and pppoe
Date: Wed,  5 Mar 2025 11:29:38 +0100
Message-ID: <20250305102949.16370-5-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250305102949.16370-1-ericwouds@gmail.com>
References: <20250305102949.16370-1-ericwouds@gmail.com>
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

