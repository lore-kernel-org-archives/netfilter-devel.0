Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955D125D90D;
	Fri, 28 Feb 2025 20:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740773786; cv=none; b=PepS2MBNlXy84VLKlRVqmC00skNplUfBKrbwEEcUXQXZl5ZdfpDxwfNZwyjfxerGkqbyYSGfo0AofsS/XYy0Wl61ywsN5fYwk0476EAdrzeB/kSM/5uROKU4R5tzKIMZNSfJbprUWVRBcBYUCnSWSH/r49eqJG+9uu842HHREH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740773786; c=relaxed/simple;
	bh=Cv52Ysjt2lko9sBWDja1ONZ3DhITuFZz/l5ensZZgPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0yLnk3G0B8C6qtlesiJsPxFvZMJCFw5OlZP7iQjF6pVh3DDsvw6qPSDu3Le+6Ham8ql5RVfLZ+X7t8ulQ25u/CQQm8MDf2DPSSzOIXNmd0ULoy/hcu0PW32Fa8vdmzbZKiDDFYsF81EPUHeKv7MwiSOVIhWo+d7DN16a6zt7bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z1qIqjdQ; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z1qIqjdQ"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5e4ebc78da5so2016986a12.2;
        Fri, 28 Feb 2025 12:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740773782; x=1741378582; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+rhlCg4/52AHm6e8tJsmpQptNUxepmsLI5spztxpn6c=;
        b=Z1qIqjdQ+Jva57vhx+g61kjhIsuCNK+WSypXwbvfZYPvg2+RyLej/KTmXW6nKzv6jk
         yO+XMHsfJqAmMYyOtexPwsuipAMI6DEmPp9sv4Obti+qcEJ4pZsqdwu1b+XWvtU4ze1o
         E5Eo6Hv30iO50ONP9ftKgWS08a25t76pe3I9Z8m5Rbf6b7zLzc35b2xrfYLS1/Cqr5MN
         ni2iyrteZo5NbDO9bOd/ZBR8IyBf5M6sbVJU4MESliHElkLlcIYGXccYSOpJOY2LV9Re
         W5PNOa8LY8SRIhf0jLNP3rxKNBf544uwgYfgenZRRyjK4qrEdr/xaZnRQjR5Am+tv6Hl
         L0yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740773782; x=1741378582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+rhlCg4/52AHm6e8tJsmpQptNUxepmsLI5spztxpn6c=;
        b=jZDUeD6cFT8UOWBcj8VH6NQEa40yfVmdqfIQ7srlGMvVAZLfRvYy8KOj2PFV0RCDXo
         JWy2Y3PiSNQSYQo4RwtFuimhBZJqB7Ega+3P40osvBr/Yg2fikiOo78/lzeqbA9lKELU
         Eho4jVmobEiK81y2ZBCWEQXxkMjgY6c4QDb1GmBFVxQ3Mlz6VRp3dFRlvvcUD5T6UgHl
         egAFHMRYrQkto+wCiNfiC6DYCizEiNgFU6/yzLjpljk990ex9wIfsbX1HdP/I/Q2xEGM
         4zcEz6YjSOQFfb6Bj3EnKobM37R67B0AlbeCfcOuDW9lk0ed/60GGfIp5c0qcA2qeVAL
         Y3Ag==
X-Forwarded-Encrypted: i=1; AJvYcCUVGEDSKrPmmt/QF4tBvCn8zZuuLqavc/NHs7yW0JvDwDtAhtRrPDMNzAeUqgZQTkK9KQqRCINzbCqy8Bz/RNM=@vger.kernel.org, AJvYcCVLHrc0vxgexcuRpm8VfqscvctV3uBw+bBQQk0oZSMhVgcO0uixc9UyJJTDd8FIAq/jaVAkRIiada+ri45N@vger.kernel.org, AJvYcCWZbFDZlBTG5+kONTvFP6fceVC4KqgnYmov97k+S7a6tCJKkDikquLmboJbdBuUFbaDueulhajOTKhsFATlYfnE@vger.kernel.org
X-Gm-Message-State: AOJu0YwLkCKN4hiLjGd5DOXhO5T4MqnxHYyQ337bilrUTDUlO1qdyp0f
	ZWgQHfkQuHGVKRJrm9WU3wh1IodEy8tHG9NnC7YmoCGhlH1U8scY
X-Gm-Gg: ASbGncvDoXbsTcmrrAaMHhe6pceFeUoeyiQ9zOjpErzBYk8JOdbjEs4zDnN3HQLzSOf
	fvrWk/lcJItr1KUREOnRexXA9ROOPYdzp1sPRwpu8XhTIFu/dO+BP/6MNh5FxHxQhWyC93nOW/g
	5M2c81FL0jpvWl3bn01Mb0II49D3Ezn8D1N4YQUQrc2U/P+z0IYG50S7XUXqRuuPcx5U/sQ3dwJ
	niaVR51wPQWIjgYhorjKe7gKnU0U2qLRtyB4q7aC0SLe8VYAWQwxjGtIzBuKXl8wsLk76sM1oO0
	MD8rYtdYvjHr7E7cFlQmIyeKqhh9DhTgl+fhHaBWN9yBlRj2puSDAsZFyUvp4IgYEUItlflYlQQ
	coJUwAjR7EQ5ccEPWOb+tGHTZRLoD640p3Xv534EFC50=
X-Google-Smtp-Source: AGHT+IGiUhgcy0UU2Q21kNRFUyXsV4EZ5JKfRHYY7rLJLVAwzjlILW+HrVFwXhJC9gDCOjiMIMoAKA==
X-Received: by 2002:a17:907:2d90:b0:ab7:8930:5669 with SMTP id a640c23a62f3a-abf25fbb482mr535437266b.18.1740773781534;
        Fri, 28 Feb 2025 12:16:21 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c755c66sm340812666b.136.2025.02.28.12.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 12:16:21 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
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
Subject: [PATCH v8 net-next 04/15] netfilter: bridge: Add conntrack double vlan and pppoe
Date: Fri, 28 Feb 2025 21:15:22 +0100
Message-ID: <20250228201533.23836-5-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250228201533.23836-1-ericwouds@gmail.com>
References: <20250228201533.23836-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds the capability to conntrack 802.1ad, QinQ, PPPoE and PPPoE-in-Q
packets that are passing a bridge.

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

