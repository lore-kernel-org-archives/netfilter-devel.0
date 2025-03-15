Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F59198851;
	Sat, 15 Mar 2025 20:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742068825; cv=none; b=AdhJEGfcwgM84aygvUmOvsnlwSjIxyHQImiaFrDQ8B+WrUFmQJ9/8M36cSKkhR1t/AWJK/Dt3XtUg9Z2B38rUfEPe4GGS2LIRiS2bYyWitgslQt7f6Yixs9v+LMatb3cK7PeQB5muv2ijYOKODSlh4fX0TD1RZwz4/wGdVlalpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742068825; c=relaxed/simple;
	bh=kLHX+C7qoec0VsUDsMnahZyr/odnCvcbNv0AKm/Bw0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gx+gwkOIQqgqACsQBZMml4aNkKodMJlBBsKJK+6YfJewVc5fjqQr0byVskdPv/v+xCtWCuAwnCsOzIf2lgBD3e8G4YftR8Q9X/N56gjxDACPtlop29pfB3zcEGvfYpddfCA5zRKmzh+8VPQFh7WI4vJA9GGrehs3A7MJxniZUw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lUmbqeuy; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lUmbqeuy"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5dccaaca646so5568857a12.0;
        Sat, 15 Mar 2025 13:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742068822; x=1742673622; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XXYQeszgzBNN6KX+og9YlBWfn80m9YROTWlB1NVgYFc=;
        b=lUmbqeuy2i8EI+UplzlE3ZOz6fz/zxe1rbV7PbzIOsLV1ON+GVeARKpydDwULTxEmQ
         3hUIhvdbOj/Hj0a6K2b7nKkG80vDf2SRokmfFZnFC8EdkXYHrY8mG2TyJZ62ZdHtPrB2
         hIOUswT9RKMvvzBt/D5axLF9XLra3PQoTpzbgWDigRT89M98JOgMvnuQdWGE1cLOmOZT
         8GH8Ulsm1vqOxxF7PW28jB+FVZHSGnHwV3/TW/kp+sESXtSfkTILIfvCbtdsZzAndzO+
         Z7oy71uIoLboFPxJyn2VbJBg5vl0AORgWImlg/ln871l8nyBsIe5CAU64dpH2sLVtBXd
         uPCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742068822; x=1742673622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XXYQeszgzBNN6KX+og9YlBWfn80m9YROTWlB1NVgYFc=;
        b=fj5fJS7+Mk2OxgSOhKwdhoOesuyWjAscDhYiajowXuj9OgUW0c6ceCiHw7MtaoOvxF
         2/Fz+bgrTjBVLhyLwGHO21A2XoPcC+UAHvQI1cFIGCdL5yLpjh990byMfWyhrU8T2Cd2
         4DCajyX/Akz8AHChmY77NQHCl45z06+9v+5htCERqhlMNXKWeDqeKINGFQ4KOwLynCwb
         iaPxd+tO+Xi6BwggpG+WIi5Q7ZXbT0dydEWQw1zzbbVVODPKLWdZL4Y8TIANOARmLEIt
         VGqsNki8wFHNjDEuESowoHWjbs0mzY3f9BoWbvVw0YBRdyms1d5KStipdoxUOERVfRRU
         P8+w==
X-Forwarded-Encrypted: i=1; AJvYcCV+bQLG/LPpCt/wVactSo51VtjRr15nJ6t6zAJMlaR2YomEoQhgCghX2VSACa5mrfwwE7/6mIt+39mzAceETws=@vger.kernel.org, AJvYcCWAnh/oRXWSKOhAku5OR9yhyjhO1CpZKVStE3O3LqzoeP/o4608Y5SW8ftKQu+AkORRTT/3kdKyn51L6j5pfIED@vger.kernel.org
X-Gm-Message-State: AOJu0YwhIeiVCnyyDFg8wReOGGPA7cr0WejD/0m0i2VDSHLEasJSgg8J
	Giw8hIt2GirJosjDdZdVxCGz0leiUnj+QxrwFrLxpXc1P4kJGHJo
X-Gm-Gg: ASbGncuhBjOdaUEcW0rvaQozO7/Ad9Ah8YHIsdG/Yfo0dNFDmIOYxarmuBq9RFaYCtM
	y6FMEdSJxwRNC9S536M+Y5CcbwhO5z3A4D/MJahbdk+ODvSOf1PNfwnh/a1bdnAOqJqiRNa0RXp
	4EAd5OP/cZyRO3tu303H1SDlwl0NAjhiQevMXIF6oahtlmetQHa/d+b54dB3kdPJVVkUpGVeaNX
	mkNo8UeNsnyq5sVeBPLhArXQ7VQNoW53OGBvq9EzyZnBKyDL3kB8Tvik1285YUvlunxO3dwRh4w
	fjdABkTBH3vbpcPGhE0W1vNaTT8OXfpQcX5O1kt3cXgquhdLotWpwPnS8dCXw7/lmTR+f1JsvQR
	/4QgObHI0OAeVoyKDp+BxcIe4jzfmjclEzzG/J7nqmLuzH+Zps2FI1iGjGfzJesE=
X-Google-Smtp-Source: AGHT+IGvhw34V1mpZ3PAOYWV+wkSI6/8fNQ0Z94V9k80Z20IKiXWtl99U4En5q9wxAbkapNygG7t3A==
X-Received: by 2002:a05:6402:50c7:b0:5e0:4c25:1491 with SMTP id 4fb4d7f45d1cf-5e814deb759mr11114011a12.7.1742068822112;
        Sat, 15 Mar 2025 13:00:22 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e816ad9ca5sm3519503a12.50.2025.03.15.13.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Mar 2025 13:00:20 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Simon Horman <horms@kernel.org>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH v10 nf-next 2/3] netfilter: nf_flow_table_offload: Add nf_flow_encap_push() for xmit direct
Date: Sat, 15 Mar 2025 20:59:09 +0100
Message-ID: <20250315195910.17659-3-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250315195910.17659-1-ericwouds@gmail.com>
References: <20250315195910.17659-1-ericwouds@gmail.com>
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
index 8cd4cf7ae211..d0c3c459c4d2 100644
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
@@ -462,7 +552,8 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 		ret = NF_STOLEN;
 		break;
 	case FLOW_OFFLOAD_XMIT_DIRECT:
-		ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IP);
+		ret = nf_flow_queue_xmit(state->net, skb, tuplehash,
+					 &flow->tuplehash[!dir], ETH_P_IP);
 		if (ret == NF_DROP)
 			flow_offload_teardown(flow);
 		break;
@@ -757,7 +848,8 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
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
index 221d50223018..d320b7f5282e 100644
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

