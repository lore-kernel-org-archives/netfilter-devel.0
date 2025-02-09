Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999B51925AF;
	Sun,  9 Feb 2025 11:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739099448; cv=none; b=R9FpPRVwP1+taAfkfrZYI9glMVM2dMb5PSmdbWc9tJNLxr6L/aM1V3y1U4gHlkH4fxSbWOqzInwJuo0tcfe3ELr+FNnXOpwBqi1iVyorjW9hkhwy5edlYGHMbvLMyB/QJN4feyCunKx5/IhQKIrJilO1yaYn/PBS6dVVwQsFxNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739099448; c=relaxed/simple;
	bh=6qTrGKDXayYgForfimYFbs5dKUPB0f6H2/utl8/7J6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZq3sg4Wyb2k+vltRrlwPahif7ttyynsTfPhkP66UgUs38QnFe1UwhvI5FmHv3MOF8BXqN5brfovZO7zbPoMTAi39i7tdA3qeMD4O15m7PTR5j5CuK5QlKlr1UVUaYEYW3OPyTgUfwGt7Vlu+fx/EQEWdJW23Kk6NjgfXYjwFi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HKYA5EbY; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HKYA5EbY"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-aaeec07b705so564553666b.2;
        Sun, 09 Feb 2025 03:10:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739099445; x=1739704245; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jv+cLmILsq6/Q63wf4VLe/fU0JLiD7L+ZSaxXE2WQYo=;
        b=HKYA5EbYwz6QtPiU+IaVB1HdvUamUIxo4+yYSDxiGE2t6sngoYzstCAa79xqvg5wn7
         HncMS/l3Ue7oB24OOmBLUMgWZa3E5IvnCMEHoiQkV+4X3nOTAyHrRp4Zm54WoFMHEJnw
         PEmIrBrQiwJV56N6D92jZZI/3zIpzeCviqTWsrjbcapVI3GRwMb3FoS0v98++D5EbpUN
         PPNSaa1KiGil4Kdb3gfjIaVI2r8rWE7g62wAe6tP2arYJnGygr72dq3b5b2qKTgIVFYS
         P+ng/I0mkmfURCFG3wwa2867ooMVyfhgo03YR/JvzvCJY6hZvCtk9P8d93ewDAcOLzU0
         6R8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739099445; x=1739704245;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jv+cLmILsq6/Q63wf4VLe/fU0JLiD7L+ZSaxXE2WQYo=;
        b=Bmy7rTGF6quABEMogF5Zain4uWzNn1aiyYD6GFn/T8ubEW2J6HAV9LbHWjb6mu/jd9
         QfPiyZ9gz7/nunyKc5kUVKpk7J/8+8Ulce8wIyhIaaYh6k4s8xwMBv094ygpNoXo6qtC
         mhTp/sN8nJSHDxxCv+ePAuNYjSuCgQBQwbO1uK+IDdQztvIN6AmbQzObcJZqB9LGGVlk
         2jsslc4PZtIRltFNsY8OXrpMPtJvnVoILL4c8g2F0O7k4zfJ6PVPAxod3SGCG/niKLIe
         4I1SI3AtVEw5QGugNH0L518S+cpyQArviAEjNBbILcBka9BF+3Mka6RA+gLsBtafVsZc
         ttYA==
X-Forwarded-Encrypted: i=1; AJvYcCU/6CR2ZVhzGanR9DUfetMAZNLOFfadi14a/ZgvhqyTnMDAvzAauhn8hF1SRERhbtmJutO4qrj4+5a4EOc=@vger.kernel.org, AJvYcCW9DS/gk387SMH2H2TR4lJ2Wzjqf+RtGmKB1kHiU3OEsGH9ZLcyWrgWU3EFqjXOOkSPOvVnQZXQS1txjt3YRB5V@vger.kernel.org
X-Gm-Message-State: AOJu0YwTEJN8Xci6Ry/KhMS3Ic0MVQsE8jmG0kH7Ac8jYndrGYlfCIus
	+H0PH2xH1TVhb5c9ejsxAS8YARPQDtZJaUOSv9QfcpNR39q48mnM
X-Gm-Gg: ASbGnctW+KAr4PZeUe/i0Hy9B3D0qeCp6iFf//GitQGB8kHASOILdKi+s4C3gNja8Ya
	kCNNXxQ1NAYFBZ9/Eievxe09q0ClzPFRdtCT9L045u34sI4q3XkP86by26IvLQkJRV2STKzCDmf
	teFENRuLesw5yz1Xg7lRl6TtzrYZo7VQu7MX5OZ1mPRhdkd5c1TlJCaZ8/LM7Gvn4d881YZylAd
	Ug1GiOf57uwn5YKNLC166TRpSn4sgOxnZ6v7CMZMV5X6F5BOVOFsAAa3O4dZmut2ijMaXfv3+/w
	mLw2ofSo2DElVwkEd/Q35pcjC0ISxKo8FTz9nuNKo1ZqJrbrT4tCfKEyrXqU5dG30OxrduQB+/k
	KQrfwZFYCEPCK1E73CcWE/wvy2rG3042R
X-Google-Smtp-Source: AGHT+IFXYULiROmtF4EyTfGufju+UjViGw3XLxQmSmt9lA2TpOAIjz2H8Xb5sfx3OKtKl9zdly0ehQ==
X-Received: by 2002:a17:906:3586:b0:ab7:97ca:e8f6 with SMTP id a640c23a62f3a-ab797caed01mr570807566b.54.1739099443030;
        Sun, 09 Feb 2025 03:10:43 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab79afc7452sm357516366b.163.2025.02.09.03.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2025 03:10:42 -0800 (PST)
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
	Kuniyuki Iwashima <kuniyu@amazon.com>,
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
Subject: [PATCH v6 net-next 01/14] netfilter: nf_flow_table_offload: Add nf_flow_encap_push() for xmit direct
Date: Sun,  9 Feb 2025 12:10:21 +0100
Message-ID: <20250209111034.241571-2-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250209111034.241571-1-ericwouds@gmail.com>
References: <20250209111034.241571-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Loosely based on wenxu's patches:

"nf_flow_table_offload: offload the vlan/PPPoE encap in the flowtable".

Fixed double vlan and pppoe packets, almost entirely rewriting the patch.

After this patch, it is possible to transmit packets in the fastpath with
outgoing encaps, without using vlan- and/or pppoe-devices.

This makes it possible to use more different kinds of network setups.
For example, when bridge tagging is used to egress vlan tagged
packets using the forward fastpath. Another example is passing 802.1q
tagged packets through a bridge using the bridge fastpath.

This also makes the software fastpath process more similar to the
hardware offloaded fastpath process, where encaps are also pushed.

After applying this patch, always info->outdev = info->hw_outdev,
so the netfilter code can be further cleaned up by removing:
 * hw_outdev from struct nft_forward_info
 * out.hw_ifindex from struct nf_flow_route
 * out.hw_ifidx from struct flow_offload_tuple

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nf_flow_table_ip.c | 96 +++++++++++++++++++++++++++++++-
 net/netfilter/nft_flow_offload.c |  6 +-
 2 files changed, 96 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 97c6eb8847a0..b9292eb40907 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -306,6 +306,92 @@ static bool nf_flow_skb_encap_protocol(struct sk_buff *skb, __be16 proto,
 	return false;
 }
 
+static int nf_flow_vlan_inner_push(struct sk_buff *skb, __be16 proto, u16 id)
+{
+	struct vlan_hdr *vhdr;
+
+	if (skb_cow_head(skb, VLAN_HLEN))
+		return -1;
+
+	__skb_push(skb, VLAN_HLEN);
+	skb_reset_network_header(skb);
+
+	vhdr = (struct vlan_hdr *)(skb->data);
+	vhdr->h_vlan_TCI = htons(id);
+	vhdr->h_vlan_encapsulated_proto = skb->protocol;
+	skb->protocol = proto;
+
+	return 0;
+}
+
+static int nf_flow_ppoe_push(struct sk_buff *skb, u16 id)
+{
+	struct ppp_hdr {
+		struct pppoe_hdr hdr;
+		__be16 proto;
+	} *ph;
+	int data_len = skb->len + 2;
+	__be16 proto;
+
+	if (skb_cow_head(skb, PPPOE_SES_HLEN))
+		return -1;
+
+	if (skb->protocol == htons(ETH_P_IP))
+		proto = htons(PPP_IP);
+	else if (skb->protocol == htons(ETH_P_IPV6))
+		proto = htons(PPP_IPV6);
+	else
+		return -1;
+
+	__skb_push(skb, PPPOE_SES_HLEN);
+	skb_reset_network_header(skb);
+
+	ph = (struct ppp_hdr *)(skb->data);
+	ph->hdr.ver  = 1;
+	ph->hdr.type = 1;
+	ph->hdr.code = 0;
+	ph->hdr.sid  = htons(id);
+	ph->hdr.length = htons(data_len);
+	ph->proto = proto;
+	skb->protocol = htons(ETH_P_PPP_SES);
+
+	return 0;
+}
+
+static int nf_flow_encap_push(struct sk_buff *skb,
+			      struct flow_offload_tuple_rhash *tuplehash,
+			      unsigned short *type)
+{
+	int i = 0, ret = 0;
+
+	if (!tuplehash->tuple.encap_num)
+		return 0;
+
+	if (tuplehash->tuple.encap[i].proto == htons(ETH_P_8021Q) ||
+	    tuplehash->tuple.encap[i].proto == htons(ETH_P_8021AD)) {
+		__vlan_hwaccel_put_tag(skb, tuplehash->tuple.encap[i].proto,
+				       tuplehash->tuple.encap[i].id);
+		i++;
+		if (i >= tuplehash->tuple.encap_num)
+			return 0;
+	}
+
+	switch (tuplehash->tuple.encap[i].proto) {
+	case htons(ETH_P_8021Q):
+		*type = ETH_P_8021Q;
+		ret = nf_flow_vlan_inner_push(skb,
+					      tuplehash->tuple.encap[i].proto,
+					      tuplehash->tuple.encap[i].id);
+		break;
+	case htons(ETH_P_PPP_SES):
+		*type = ETH_P_PPP_SES;
+		ret = nf_flow_ppoe_push(skb,
+					tuplehash->tuple.encap[i].id);
+		break;
+	}
+	return ret;
+}
+
 static void nf_flow_encap_pop(struct sk_buff *skb,
 			      struct flow_offload_tuple_rhash *tuplehash)
 {
@@ -335,6 +421,7 @@ static void nf_flow_encap_pop(struct sk_buff *skb,
 
 static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
 				       const struct flow_offload_tuple_rhash *tuplehash,
+				       struct flow_offload_tuple_rhash *other_tuplehash,
 				       unsigned short type)
 {
 	struct net_device *outdev;
@@ -343,6 +430,9 @@ static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
 	if (!outdev)
 		return NF_DROP;
 
+	if (nf_flow_encap_push(skb, other_tuplehash, &type) < 0)
+		return NF_DROP;
+
 	skb->dev = outdev;
 	dev_hard_header(skb, skb->dev, type, tuplehash->tuple.out.h_dest,
 			tuplehash->tuple.out.h_source, skb->len);
@@ -464,7 +554,8 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 		ret = NF_STOLEN;
 		break;
 	case FLOW_OFFLOAD_XMIT_DIRECT:
-		ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IP);
+		ret = nf_flow_queue_xmit(state->net, skb, tuplehash,
+					 &flow->tuplehash[!dir], ETH_P_IP);
 		if (ret == NF_DROP)
 			flow_offload_teardown(flow);
 		break;
@@ -761,7 +852,8 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 		ret = NF_STOLEN;
 		break;
 	case FLOW_OFFLOAD_XMIT_DIRECT:
-		ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IPV6);
+		ret = nf_flow_queue_xmit(state->net, skb, tuplehash,
+					 &flow->tuplehash[!dir], ETH_P_IPV6);
 		if (ret == NF_DROP)
 			flow_offload_teardown(flow);
 		break;
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 46a6d280b09c..b4baee519e18 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -124,13 +124,12 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				info->indev = NULL;
 				break;
 			}
-			if (!info->outdev)
-				info->outdev = path->dev;
 			info->encap[info->num_encaps].id = path->encap.id;
 			info->encap[info->num_encaps].proto = path->encap.proto;
 			info->num_encaps++;
 			if (path->type == DEV_PATH_PPPOE)
 				memcpy(info->h_dest, path->encap.h_dest, ETH_ALEN);
+			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 			break;
 		case DEV_PATH_BRIDGE:
 			if (is_zero_ether_addr(info->h_source))
@@ -158,8 +157,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 			break;
 		}
 	}
-	if (!info->outdev)
-		info->outdev = info->indev;
+	info->outdev = info->indev;
 
 	info->hw_outdev = info->indev;
 
-- 
2.47.1

