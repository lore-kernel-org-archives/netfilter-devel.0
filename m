Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492301C3026;
	Tue, 19 Nov 2024 10:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732011565; cv=none; b=DYvDX2QHANyQHuo8KCkg6z8cwsHQH5oiM0KSWE8IuWdlS9tjZNT2szM9hpnBUsdIC8RHYEeUZQnEqYxodebhRD13X2bTOXCvz5dnzKY8UXJiBzzxsGCFeAsuP5elNbYYv+oI+zOfisvcO4L3Js+fuyxyqBhIn8nF6alY0LED6Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732011565; c=relaxed/simple;
	bh=83pWBM1L3wuX+9WaP0J2+M1bEpthmK4o/ZZMjoR1Pug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbWkgrDatAcTONo1QPVH0+7hO9/pWpvg2MbwMyOQfk4jWSqIWz9kMP0LDZYnZ7w9RFlDIhMevFRhWWOVVqBSmnRfmS/xSFLh3IJ5otBAbc48uO3qems6FZBqCau8LDVr7ruN6WrWFvtD8qxZFwtQjQE/sXVEhhnffyH3nsM0N5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MoJl/xvG; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MoJl/xvG"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5cefa22e9d5so928739a12.3;
        Tue, 19 Nov 2024 02:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732011562; x=1732616362; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=33FGTDxVghKRUjvQxe8n+i0NIxSacmlAlP2N6q7e0cg=;
        b=MoJl/xvGfBr2s99uV2RVCaem/wx90dV9YC7wOMfHN0zQQ2Kc1tBtJpi81s3ou74o5Z
         JEeAC4GxYmH74qIYM9Y72gCWFRarjCzks5f5Boa+ncfO/CbLLI8bNPqBPDsjCVlQtp8A
         BZozzZCC7k8nPm5dVhUAcXoHFdxoQWDVB27GGNz9J0JCtD39fWPrI9Ban2LSLPo0PeAX
         f0jRVM4Z3DAhhSp8TO55+Wb76b47mirjzXwb9af/J2w73/GKsX/TQAzeVVaJ1KZsKXrx
         nReI9grLLSv4iWMVU4b/WNUbpFtBo3DFSEf4gWuLt6BI6iEQNiWdI2zhW8E9UkSpmkU1
         27Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732011562; x=1732616362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=33FGTDxVghKRUjvQxe8n+i0NIxSacmlAlP2N6q7e0cg=;
        b=f+9q0g+WocSXduEszgzY0/CcyWjhaSwfODA2er+v1tvaKG0Ey4oZcbff6MtufYo/Ag
         ErsXUifqdaREyO2zxuC5A4nSIFil7nJ10lrZ725RgaE0wb7w+d8jkWlKpWXjwcD94uYu
         vyF4vLtooMHUsZOXRw2oaZHmM6WWnMhrIvsIICX76+R3iTJ0VV+A5elQ92CR5QZOG8od
         G+FCH8aCnZyB06rPAQ/k9xCSrjvKLMIL7gcBslYu5HRRuOiFIdLBeeK9z0FqPT28lbmA
         YkPN+id54fNpnjD3KhlKZbKQV2bfP+y5OaJVnaTa1uH+QVTeVsXNy40hsz5sqb4wWLNr
         4yUw==
X-Forwarded-Encrypted: i=1; AJvYcCXXdUm9G+AFFySGdEhCKxtxFw6qwq6YsTM2GWsDgJrGYwq4FI0uWOD2IZbD939iHT/fyBXc6TYY9DeFTDouFLPG@vger.kernel.org, AJvYcCXjHLj46JI1L5VBHwUbMX4iOxePgwnuQ0VtiQFpGCHORkt2hmX6OhntgqllwYM+b5z0FTRE8oDm0OuEjyw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+DuA8w70FUsm6pPMRBOeyxGmwfT7PBgiEhjD2nFOxmRhhgz05
	1aOPNkpbRa7z3VWwILA0B4ECTFPfNxbXE7GJS9HtwUJiLweGzOd2
X-Google-Smtp-Source: AGHT+IHK3RPvVbNkL0ulMmObg1fv6oLItSdSeQYUnbTgITRiDHxNBFC5utDs26XSVr92XJ7sV7zGaQ==
X-Received: by 2002:a17:907:96ac:b0:a9a:6477:bd03 with SMTP id a640c23a62f3a-aa483525d3dmr1598769866b.38.1732011561338;
        Tue, 19 Nov 2024 02:19:21 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20e081574sm634875566b.179.2024.11.19.02.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 02:19:20 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	David Ahern <dsahern@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Joe Damato <jdamato@fastly.com>,
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
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH RFC v2 net-next 02/14] netfilter: bridge: Add conntrack double vlan and pppoe
Date: Tue, 19 Nov 2024 11:18:54 +0100
Message-ID: <20241119101906.862680-3-ericwouds@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241119101906.862680-1-ericwouds@gmail.com>
References: <20241119101906.862680-1-ericwouds@gmail.com>
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
 net/bridge/netfilter/nf_conntrack_bridge.c | 88 ++++++++++++++++++----
 1 file changed, 75 insertions(+), 13 deletions(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 816bb0fde718..31e2bcd71735 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -241,56 +241,118 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
 				     const struct nf_hook_state *state)
 {
 	struct nf_hook_state bridge_state = *state;
+	__be16 outer_proto, inner_proto;
 	enum ip_conntrack_info ctinfo;
+	int ret, offset = 0;
 	struct nf_conn *ct;
-	u32 len;
-	int ret;
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
+		} *ph = (struct ppp_hdr *)(skb->data);
+
+		data_len = ntohs(ph->hdr.length) - 2;
+		offset = PPPOE_SES_HLEN;
+		outer_proto = skb->protocol;
+		switch (ph->proto) {
+		case htons(PPP_IP):
+			inner_proto = htons(ETH_P_IP);
+			break;
+		case htons(PPP_IPV6):
+			inner_proto = htons(ETH_P_IPV6);
+			break;
+		default:
+			return NF_ACCEPT;
+		}
+		break;
+	}
+	case htons(ETH_P_8021Q): {
+		struct vlan_hdr *vhdr = (struct vlan_hdr *)(skb->data);
+
+		data_len = 0xffffffff;
+		offset = VLAN_HLEN;
+		outer_proto = skb->protocol;
+		inner_proto = vhdr->h_vlan_encapsulated_proto;
+		break;
+	}
+	default:
+		data_len = 0xffffffff;
+		break;
+	}
+
+	if (offset) {
+		switch (inner_proto) {
+		case htons(ETH_P_IP):
+		case htons(ETH_P_IPV6):
+			if (!pskb_may_pull(skb, offset))
+				return NF_ACCEPT;
+			skb_pull_rcsum(skb, offset);
+			skb_reset_network_header(skb);
+			skb->protocol = inner_proto;
+			break;
+		default:
+			return NF_ACCEPT;
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
+		skb_push_rcsum(skb, offset);
+		skb_reset_network_header(skb);
+		skb->protocol = outer_proto;
+	}
+	return ret;
 }
-
 static unsigned int nf_ct_bridge_in(void *priv, struct sk_buff *skb,
 				    const struct nf_hook_state *state)
 {
-- 
2.45.2

