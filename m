Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032B514A0B3;
	Sun, 13 Oct 2024 18:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728845737; cv=none; b=eH4m8bbGfj0B2u2IfN7DSLOEL2puRLKrU2wAYU8JnWGDTOMS+0kB1lSSYr7B5u9bfVKf4FYBHM7ChHzHFdO1T5LzW/dleTa8yZJmWQiuAbTEJUR9YicWT9aBcpi0Ia5/iF0ZKVCIox7mqYl+ATHvlB9dCskvCk+2/Wb5rkrwaxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728845737; c=relaxed/simple;
	bh=tuoPy7aZ5VeD2cNXsXFZ+jCXqmclfS0mmV8rllHpiAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScTO7ohkSTxh83KyxuwA9oIEj6DsKtuLSPEgR+KyHysG+TnbQKRV7lzj64pjwT+bfnnZqotm4v/DlRFLuKNUmMDtp9XVJZbz2zFRKUiY0Imc14A1+OVEFmWLQBVYX8wVp1CZb/5WN9EnmgK3qRMobT98BRlrkqODI0Cgbb6p9uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m8PDLA0a; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m8PDLA0a"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a86e9db75b9so540006466b.1;
        Sun, 13 Oct 2024 11:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728845734; x=1729450534; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pfUb9HJ+s1GLLmxcujXBQ1+8qs5ZhQwuVS6uJsoTo/c=;
        b=m8PDLA0ajWErvAvQCtZmTfI3PyuvTMuWWfCyhzxYMJotcq4VAxj3K3+MdiwS4K3L29
         xDSqIkDY6yfwOW/jt+tyivUrgTiTXzskqPe+xoq8yho0NhQeTtUv8XetX4Dz+GC0VOk7
         XCNM+fnRwseuC4phHlyOnJLW8XmRzpHKvPP2vQADiZ5v3bccVPhM0ZhynQqu2nLxz5EP
         OeelKkcZSyblvNpoM0NwMDzr9k0AZwP2xT+eBIy4WiBVP1LszareIzCtyFxJ8uQqe2FM
         JcuHGSaojkFi4Y/T9ayA+t8USOyIpbXGpaqZMuwwFLcnhw7S6MGbGhZ4u8wlTHu/mrLU
         vqiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728845734; x=1729450534;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pfUb9HJ+s1GLLmxcujXBQ1+8qs5ZhQwuVS6uJsoTo/c=;
        b=xPSXGGpAnawdIah/E2YsTNkG2zmkaX4vTytINPI0/18S5iPyraocl+ifYWxCA/6MN4
         dYM9m3nQITcB9mXJOZdtY5fpDR4l+kVAIdhOx3CNtJ5tr4V+Cy1QIMGLX4d1HLopaM+o
         TVbYUaTanrxwefusBNly7R+feOjROkA7pllBFY0YmD4YpUb68SizSgmbhgUWrNl60kt8
         ksZfitszd3l5+XEP9nSkos314QmHDRfvY7S3h9Enfraku8ikFSRrnw6xWb0JptupA3GX
         4ChSIqmmn5MH0F6/s2tAGCWEuWIa2owQAbdhKFiTqBR6rPhw2DX0Bq+vd35lekKierDl
         PNkA==
X-Forwarded-Encrypted: i=1; AJvYcCU3lVGh0Sys7POmNgU0ybzLujoLQ2WH35ucdhj+MnRssGNdMx8WkLLFyEbazfIuzbpuWv70rR6wJU34IYo=@vger.kernel.org, AJvYcCXYs78dT5EcqPcJRnlfdTcY+ng1j9oPG0oSAwHUlhNdHk7aT0/evGgVDwu5vw97KrXysE9KpqrtSC6vLdJ/yGCv@vger.kernel.org
X-Gm-Message-State: AOJu0YyJASiiccZzzJbxLgImuz+w00GuJz+nle3/jkno/kb9xU9jn/N/
	EumhMIiHCrDDIf9fk2xrPrggTypt4uyusFXKuyRnAB5gBFT9Ldac
X-Google-Smtp-Source: AGHT+IH+8DzpaIYRj4WDn5wY606h6B8yn6VPFaENvcSZa4TDlxRT2Jmn8BI4I5TivbHspBA60sKu/Q==
X-Received: by 2002:a17:907:6d14:b0:a8d:5472:b591 with SMTP id a640c23a62f3a-a99b93a86b0mr765431566b.5.1728845734027;
        Sun, 13 Oct 2024 11:55:34 -0700 (PDT)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a12d384b9sm13500866b.172.2024.10.13.11.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2024 11:55:33 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>,
	Eric Woudstra <ericwouds@gmail.com>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH RFC v1 net-next 02/12] netfilter: bridge: Add conntrack double vlan and pppoe
Date: Sun, 13 Oct 2024 20:54:58 +0200
Message-ID: <20241013185509.4430-3-ericwouds@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241013185509.4430-1-ericwouds@gmail.com>
References: <20241013185509.4430-1-ericwouds@gmail.com>
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
 net/bridge/netfilter/nf_conntrack_bridge.c | 86 ++++++++++++++++++----
 1 file changed, 73 insertions(+), 13 deletions(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 816bb0fde718..fb2f79396aa0 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -241,56 +241,116 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
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
+	case htons(ETH_P_PPP_SES):
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
+	case htons(ETH_P_8021Q):
+		struct vlan_hdr *vhdr = (struct vlan_hdr *)(skb->data);
+
+		data_len = 0xffffffff;
+		offset = VLAN_HLEN;
+		outer_proto = skb->protocol;
+		inner_proto = vhdr->h_vlan_encapsulated_proto;
+		break;
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

