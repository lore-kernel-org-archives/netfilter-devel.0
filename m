Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6674320F08F;
	Tue, 25 Feb 2025 20:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740514593; cv=none; b=L6jQWw8dI+KH0vuZHj0Y9Ot1CFjog9FuznPQtgU1+BIIUBlBvyHGtjggbhkcpeZeLcGDT+tW2MtZLvG9dVeEq2oAgHpaPLmgNLnbWOEgLJA9xpv7RKEazHbeNsDxeYo94mI5Fp3ICgEL9D6pfQgNNLo1y/tZ1Z+nRPruz5hYViM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740514593; c=relaxed/simple;
	bh=Cv52Ysjt2lko9sBWDja1ONZ3DhITuFZz/l5ensZZgPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNbPI4tLMX/Bv7dumReqnmU0joSwe5UyL7uAJ9lgtVtu1uUAG1M2ryOHk7y2Kmn0qR1/KYOVeIum55B68XAkABJWB+IMuTeWKPNEGkmTlhsbg0mUJh1wZfBBMydu/E9NaUxpfp3vaE9WcWc8h27/7CzWaKHYW1ETbG6oGQhPJkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=irGhNR9d; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="irGhNR9d"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ab771575040so31020166b.1;
        Tue, 25 Feb 2025 12:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740514590; x=1741119390; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+rhlCg4/52AHm6e8tJsmpQptNUxepmsLI5spztxpn6c=;
        b=irGhNR9dLR4WQMiaKS0Zkp+iRxzVhhLr7z6HGdsfPlxa0kvV4q3/MDpUbkDCVTSz4p
         OpEGHmmlCQ2NVxC9/QAkiUmSsMnEDdHIWVjWNAB9S03d1xfkj1y3zn1tfvegaYVNVx+5
         Mh+myZ2MXf2wJ4NXSjrrFqUyTYcwxVqmOgZLfhF/4j/z6gEwiE7H16Qx5LH1xKMbYzqj
         euPlHoJxVjbw9i6glE8u/PD4LQZaKM/4sUYKtcEJiKYODst6MhwPgVsvh6Ckq/q9hSlN
         MJFTNZbal8jWvn4U5oOdyxtc8MMJV4vZtcrxxV61PkmzuDMDzS7iZPHkb+rfm31yCrXp
         6rrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740514590; x=1741119390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+rhlCg4/52AHm6e8tJsmpQptNUxepmsLI5spztxpn6c=;
        b=Qe72ei3puMsm2VinRIfqehsT75EONw6iPlQuWbZlNoeQrG4SktfXje9flIiST6RHxu
         uEv4Yn/qBYVXE37pSqSd+0UMHyC7PSbdsVbgqkXey2Y3B3vuHTq22q8hL/1a2CVJkFKO
         le4BA2kSD1Yw5zXhd76vqJWrXVjSOZPjkKeeLU2iXw7kdGdZEVGlVU8D7e0XsYc8/k4b
         3ZLf5M3kTaYZcVarNqR6jKzluQnUsQsUQqVIAOdCjWGJZF1ZjnWanNPopOs8Cq61db7q
         RzzZHAwj7GeCuyEgFy0Oq9yZAQBfERcS36spFJBA2X10DX26NPS8YrVQ1mDSV2ovy8Li
         NOEg==
X-Forwarded-Encrypted: i=1; AJvYcCUZzQx1HuT3RBPgwG2W8qb/mTaDozFt/riJ4EBisRUPykKLnBMrSA1P5sOwMOIYxnk2x0ei57H99+XWqYUJdTFh@vger.kernel.org, AJvYcCVfB//yu4eKoylk3fqzVqXDFmsqkfJvmkHybTTL8RvJtVsvJtQiccXGKAtEbJyIWty42EGw4jcrG/r837c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2np7mtXPEBWAqHB2Dy2/GBew0bR89QpuyuNL6H4VyNhCXeyn/
	MysVxQXtt8azdcx1gd3OH6ljj6yzykymJdOaVChOTu9OMz+MJa5d
X-Gm-Gg: ASbGncvW3ZXLCPmplHf9I9S2vKjp/9pXCFIeSqb2CujAGwt9jhVtEp8SEP0EWVB11Is
	vMzrbjQ3PCm2wD3w0TY8IZqwA6NnuT3ZT6ESTIu3NYV2hZ4K6ZliOj5tQjvqF9wiIFR36q+ax0J
	CjmxWQH7+2muXamc7xX0SipOlDOmb/j2BZHD5w5Y18hyHpy3WSDowDU9hT7dtDblVTjvH83dZTh
	9iWNIPEkKk7s+GR6KTNToBQdgT+73EJuUZQTXT/kDjYnyBuHytUg/ElGACgZ0PD3CGIHqUbHTWQ
	sYednT1KIfgPf34c1gWqm7sYa0Z1FX1cFX/qCLvo5H9YkQLuepTiWQzYmxZVJ1NUEzS+w+iAvp7
	JQixEVWme/KKAgik/f2gUer0OSIokegALYdv/U4lf3e4=
X-Google-Smtp-Source: AGHT+IGjYzWXLvnzGLyEXex+ETYVw5Q0C/1jRBzHoDa33wNIkf6eiEa2/vyA43CLHzQ2U9WVtqxm+Q==
X-Received: by 2002:a17:907:780e:b0:ab7:798:e16e with SMTP id a640c23a62f3a-abc0ae91168mr1674875466b.15.1740514589399;
        Tue, 25 Feb 2025 12:16:29 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed201218fsm194319666b.104.2025.02.25.12.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 12:16:29 -0800 (PST)
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
Subject: [PATCH v7 net-next 03/14] netfilter: bridge: Add conntrack double vlan and pppoe
Date: Tue, 25 Feb 2025 21:16:05 +0100
Message-ID: <20250225201616.21114-4-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250225201616.21114-1-ericwouds@gmail.com>
References: <20250225201616.21114-1-ericwouds@gmail.com>
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

