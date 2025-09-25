Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8B42F9D83
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 18:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758824852; cv=none; b=NxxwauKGRA0uUY43PQDslTrXVbZzl8N6NEASZzJYfTBQQ9SWdU8kfQhtc6l2lAUmVZelpOuoBqqlCk4OJkbEnE6J6ZEy3HudoI5KHJGnEiBp4dyTts4VEjw09ua7wR91+I1a0jhP/eph55ktxjLQvdnMZl2R7Y0+PNNQcQL9YIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758824852; c=relaxed/simple;
	bh=75KsYv7BtyENqAQQa4FaHI1uarpE05MwNpGTXwEeZXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a81THoxU0jhZ8X8OdK6i2e9GiEGfHS8wG0hrhQpy5/5hUW3heoySHjUwQ3vxlldWyOy66iiB+/t2rxIPUvWJ8Q+Jpmf/bp3gQgAP1q6IbAuEBHsHKmpX/5zCJ+wL/1kdX9+z9qBJ6ONWvkKtns+4L9dNEs0Ku98RL32bQSX+Y40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QxYIUFpz; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QxYIUFpz"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-62fc89cd68bso2688832a12.0
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 11:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758824849; x=1759429649; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uFmthaKkdRuO6Ia14S4ylMSVHOARqVNgJmPBWByR8UI=;
        b=QxYIUFpzKeCDeu+ATOLHqLZE4CKTe50FiWN0obkbU5jhZZVeRX4yfDMgetL4rokjed
         eShxMzVTD+ysyl+N/7TkYvx12lpj2b9ecDy9EWtQx+5BQEXw3yLNqoP6of9jkTrbRalr
         byxAg5/S4+JkJO+XE+Of2mgHabHmVRiW0qPycmTI+XoCDTRuYQiHvHeDlPvX6UHrzTyf
         cFLScFQKvIZDHL7y1OoSzrSKi68z2GqcHK/LJ/4llgA3BwBJXTtX1O5IIM4P1pdwuwJX
         /1Kfpkhxg/P08Ge4l7W7KNVSOG43XEdeCwdvws1BwL929G/Hg8pqoeeFF2jYSiCdRFBi
         EYzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758824849; x=1759429649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uFmthaKkdRuO6Ia14S4ylMSVHOARqVNgJmPBWByR8UI=;
        b=vEPMsQxmF5ijBkuH1UsckZiAfa6zLEVp7No/GSvyfPVqwj17WHYmS1qd3GbrGnNkPy
         SixnJ+EEU9+UVN9YRD+xiHwaFgE83o+oQC4jgMIsN72hNAPlxaA69G2OhSMLK8wPQmnS
         3KaHvu8Es5gZaRqsoLwtRzuefAH/tiz+zBti1rAHrgacd8aK3XOcEy1d4GgYAYFfO6hV
         7Hp3BVM3JvlLvGprs3YVPp/Vg0r4m/nb9bHEWH45hgzx/EiE/W8oEmAvP553K1wAkx+m
         0kihB3X4xXaXNjNbVf7e1bCnC7ezo53EBxF+wKTtCCTpCJoIIuV5eTHXbhxt/XzWrWay
         b9Gw==
X-Gm-Message-State: AOJu0Yz5yV+engBeWi2Z9W3Aoki1frHGWVS8YiYFpU64kfDLoje4wjlQ
	oLbHlNlAB0QR+z9VhwvJX3OGO0seCge6GRo5GUyI2rIK9K/Vj7fXjbtv
X-Gm-Gg: ASbGncv+JnMUVM3ggeqvLMaV6gZH1rcJJd4sqgawPUSCtOoFs+co58LhTWslzD396tY
	UWaatv6hJ3OuNhH3g+hdAmJfK+B+I482aJ0oorlGHCkI/f5Xsh6v5Q3R7WKHAqili4DD+P7YZZ9
	lKyxJDyK+3S8nQwsHAoB2CpTdJmLTIM6ar/8Q99Oh1ShwV010q979H0mdqo8ZY0sscWsr/BFZMx
	dMwpFFlERexsnpzKx/8LwRiBg5NOcBWOr0vlP2VftzGf6MphyIvwyBrjNd8gJvd2WQNCV9Ac99Y
	yiRmbAjorLSzdnKqYZtRTvVLR+OHSGewWktNSRPWyHUQWMHqlkDaVNbPWy06F5lETFB4NL8UfQe
	oEHgJMKbr2GOTyWH07LWLTcIP9e1cK4MHMuAKRkCN4eFEaE3QOBh97pv8ihEom7qsfOido0hpMy
	aIgXt2fXESMvCr87DFdw==
X-Google-Smtp-Source: AGHT+IExIcGrCo7xdVZgfjD/gWQ++tf7y1kOVCVrC2R7tQkGQdQHzY+422ZK9hGlUWIHAsdsCiye6Q==
X-Received: by 2002:aa7:cd67:0:b0:633:d0b7:d6c3 with SMTP id 4fb4d7f45d1cf-6349f9cab40mr3139172a12.5.1758824848942;
        Thu, 25 Sep 2025 11:27:28 -0700 (PDT)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-634a3650969sm1572902a12.19.2025.09.25.11.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 11:27:27 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v4 nf-next 1/2] netfilter: flow: Add bridge_vid member
Date: Thu, 25 Sep 2025 20:26:22 +0200
Message-ID: <20250925182623.114045-2-ericwouds@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250925182623.114045-1-ericwouds@gmail.com>
References: <20250925182623.114045-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Store the vid used on the bridge in the flow_offload_tuple, so it can be
used later to identify fdb entries that relate to the tuple.

The bridge_vid member is added to the structures nft_forward_info,
nf_flow_route and flow_offload_tuple. It can now be passed from
net_device_path->bridge.vlan_id to flow_offload_tuple->out.bridge_vid.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 include/net/netfilter/nf_flow_table.h | 2 ++
 net/netfilter/nf_flow_table_core.c    | 1 +
 net/netfilter/nft_flow_offload.c      | 3 +++
 3 files changed, 6 insertions(+)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index c003cd194fa2..bac3b0e9e3a1 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -146,6 +146,7 @@ struct flow_offload_tuple {
 		struct {
 			u32		ifidx;
 			u32		hw_ifidx;
+			u16		bridge_vid;
 			u8		h_source[ETH_ALEN];
 			u8		h_dest[ETH_ALEN];
 		} out;
@@ -212,6 +213,7 @@ struct nf_flow_route {
 		struct {
 			u32			ifindex;
 			u32			hw_ifindex;
+			u16			bridge_vid;
 			u8			h_source[ETH_ALEN];
 			u8			h_dest[ETH_ALEN];
 		} out;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 9441ac3d8c1a..992958db4a19 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -128,6 +128,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		       ETH_ALEN);
 		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
 		flow_tuple->out.hw_ifidx = route->tuple[dir].out.hw_ifindex;
+		flow_tuple->out.bridge_vid = route->tuple[dir].out.bridge_vid;
 		dst_release(dst);
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 2148c4cde9e4..788bffbfac78 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -85,6 +85,7 @@ struct nft_forward_info {
 		__u16	id;
 		__be16	proto;
 	} encap[NF_FLOW_TABLE_ENCAP_MAX];
+	u16 bridge_vid;
 	u8 num_encaps;
 	u8 ingress_vlans;
 	u8 h_source[ETH_ALEN];
@@ -159,6 +160,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 			case DEV_PATH_BR_VLAN_KEEP:
 				break;
 			}
+			info->bridge_vid = path->bridge.vlan_id;
 			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 			break;
 		default:
@@ -223,6 +225,7 @@ static void nft_dev_forward_path(struct nf_flow_route *route,
 		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
 		route->tuple[dir].out.ifindex = info.outdev->ifindex;
 		route->tuple[dir].out.hw_ifindex = info.hw_outdev->ifindex;
+		route->tuple[dir].out.bridge_vid = info.bridge_vid;
 		route->tuple[dir].xmit_type = info.xmit_type;
 	}
 }
-- 
2.50.0

