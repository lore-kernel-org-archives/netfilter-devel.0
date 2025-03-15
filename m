Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC3A1A0711;
	Sat, 15 Mar 2025 20:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742068827; cv=none; b=u4swNWEZ2nY2CZqFbT+B0pVLZDYFCgftcGo3/iVIiR24xoFHVNaR6ZPeoBtm9f41UhBC/uXPLPmM+D/2bv91jNdJ1P34bqdt1uTzDEG28u6AGzrs2jTuYj+Gri6ym3BsqsFm4VntsfimiU9yOK502KNtG+ffUjouFZBoZaYd3Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742068827; c=relaxed/simple;
	bh=kIG0P8HyGImNUXKzZWgVKHuCZbqUctcTMTa56zCcvPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZBzwGWaHFIlrjfA4jlbPf2qmgXvaH1ar6fcxr0lxrpMZNHCOf4iTCXv4iz+isXaJ/rh3wx1+cWMa7ANxqyqHbf8eAOhMJv1JaIgsCvPfBl3eYfrfQIwrZU0BYu0r5x56GGqk+wZ5mP+v6LFRT05IER9OfRAUdDZnEyaTvVX27vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aD3cYn2d; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aD3cYn2d"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5e614da8615so6281954a12.1;
        Sat, 15 Mar 2025 13:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742068824; x=1742673624; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JRB9j9uS/mBUM2j7YBryWXdrmvN7j84epQ9bGumQI0o=;
        b=aD3cYn2dfg+bn9VaZahEPqc39Q/Z7P/n7/UnCI4uSRtVeVvcXuRK7wm6Cm5aL1h150
         eLuDEqyTvk7xca8lYczze6YeOddJeb6WcEqz2Jl7EMz3zfsE5gS8lhXIgVUZtu+75sf8
         O/cixguXw6j0AhPLL8/SZ8IpfVpN2xyy3F2SkX02x4cfHwcumvT3552PRrfsJNg0I0ud
         LHEjbfUbJ+2MGjBS34/DO2qoIJGyMTUgSYrNQKkb5g1MzJUWRjH+bhzGI3+pGF3EwR9i
         p/AH4BE3nBn2op4KU3uC9Glh1Uh5ZfdmhEADyA9qizZVr5OF82cnY6Z4HzLZVLA1TsZq
         BBOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742068824; x=1742673624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JRB9j9uS/mBUM2j7YBryWXdrmvN7j84epQ9bGumQI0o=;
        b=QJkgXlFxZUyDESvZ1id0UmgM2cc+hBTrGyqRUV5JRi5CIGeFjzID9Nv4U7UNDf/hEh
         znpesBZBxUiVCBdvV3aOu+rmdxe7zhBafBjew8C/EzLb4WfgkonEbUAktYOSwVNAPtQC
         knUFMm7P8HC663fbp9IrmiaOK7pp+We/s8c5+FY4H9UyuLGfP6VYSlLfY1i0CjaKpms1
         66r193X4W79gnZBGzt0tpdYZmocUCYBjGnvLbkxAraA9nk2T1qTQe7BwTTj2laFcIPPX
         OGp35+NIXTXbtoPxnZAjvnK8KpUR1h1hYqCctvLP83f8VEobdmSi/Cnz1ZrOWWFH+v6W
         2jpw==
X-Forwarded-Encrypted: i=1; AJvYcCUR1iLvXPGlpIMImfT9AS8M2W1IYbEJcynClIEPoIFV1A0be0KQox1QS5RUL8VINTjhQygWhLEM5pZHcExK+aQP@vger.kernel.org, AJvYcCXRg9afZXrGRvdKx7Cj2WUShePTw1ByLCkV0pdkhEu/L7/Cb+tCYUisB9Mm6h62vtHWhaf2Nif1seI7IUf5ZRc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyV0BQqnNEv/KyWB5qh3ZcLs6b/4W+GfmH302AWEMpIlawghYlm
	k8gvwXw9upZ/W3xvMtwDjEAMjT17047ECU1hhN1Nt1UKWnjpdixS
X-Gm-Gg: ASbGnctIAgRLOg7vIpoOR9QPzmLgAZiaZba/mph+zen1BBuREdlVPHFHNm9gwH7Al81
	VAF6KDwXyzQrFk7YGfNSItqM7H16bYL2nEl1PrnOJNAAwnBIwz9ve9VRBd05+v/j4iKQlluJ0uI
	s3AGNfQmyt7RxEVrChosCmSVUDPaPYBn5HyuWPtBjzbM4LJefcDltmRyjuM72A/VNEk2jFc3ow/
	YF58RZ2TjSGej6jyvPrPqVraoJ3Rkr7ljrUtLd8hoMntrEe0zrqv0JMRP+eOF9G64Jyep5xJJv0
	U1gIjPmMZW1pYnebv1iBWO1uSogNpjY7mtdJFNOsB2fpYTTMI8F2aDOkvX2Lo/thjIEsoZUV5SD
	SithfUQznoZC3DNWU4D65PePGwaALj71QE3sbLZGq2akx16bMWVYdlNauAbz388A=
X-Google-Smtp-Source: AGHT+IHt5qduQuB+UYuxjKyKCPVYkxwY7La0gdIP+6UDs5500pGpm7Qf14tE54AschhN3VrMeyf5Bw==
X-Received: by 2002:a05:6402:34d1:b0:5e4:d27a:d868 with SMTP id 4fb4d7f45d1cf-5e814839ec8mr11968564a12.0.1742068824035;
        Sat, 15 Mar 2025 13:00:24 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e816ad9ca5sm3519503a12.50.2025.03.15.13.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Mar 2025 13:00:22 -0700 (PDT)
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
Subject: [PATCH v10 nf-next 3/3] netfilter: flow: remove hw_outdev, out.hw_ifindex and out.hw_ifidx
Date: Sat, 15 Mar 2025 20:59:10 +0100
Message-ID: <20250315195910.17659-4-ericwouds@gmail.com>
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

Now always info->outdev == info->hw_outdev, so the netfilter code can be
further cleaned up by removing:
 * hw_outdev from struct nft_forward_info
 * out.hw_ifindex from struct nf_flow_route
 * out.hw_ifidx from struct flow_offload_tuple

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 include/net/netfilter/nf_flow_table.h | 2 --
 net/netfilter/nf_flow_table_core.c    | 1 -
 net/netfilter/nf_flow_table_offload.c | 2 +-
 net/netfilter/nft_flow_offload.c      | 4 ----
 4 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index d711642e78b5..4ab32fb61865 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -145,7 +145,6 @@ struct flow_offload_tuple {
 		};
 		struct {
 			u32		ifidx;
-			u32		hw_ifidx;
 			u8		h_source[ETH_ALEN];
 			u8		h_dest[ETH_ALEN];
 		} out;
@@ -211,7 +210,6 @@ struct nf_flow_route {
 		} in;
 		struct {
 			u32			ifindex;
-			u32			hw_ifindex;
 			u8			h_source[ETH_ALEN];
 			u8			h_dest[ETH_ALEN];
 		} out;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 9d8361526f82..1e5d3735c028 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -127,7 +127,6 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		memcpy(flow_tuple->out.h_source, route->tuple[dir].out.h_source,
 		       ETH_ALEN);
 		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
-		flow_tuple->out.hw_ifidx = route->tuple[dir].out.hw_ifindex;
 		dst_release(dst);
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 0ec4abded10d..f642d0426f1c 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -555,7 +555,7 @@ static void flow_offload_redirect(struct net *net,
 	switch (this_tuple->xmit_type) {
 	case FLOW_OFFLOAD_XMIT_DIRECT:
 		this_tuple = &flow->tuplehash[dir].tuple;
-		ifindex = this_tuple->out.hw_ifidx;
+		ifindex = this_tuple->out.ifidx;
 		break;
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		other_tuple = &flow->tuplehash[!dir].tuple;
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index d320b7f5282e..acfdf523bd3b 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -80,7 +80,6 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 struct nft_forward_info {
 	const struct net_device *indev;
 	const struct net_device *outdev;
-	const struct net_device *hw_outdev;
 	struct id {
 		__u16	id;
 		__be16	proto;
@@ -159,8 +158,6 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 	}
 	info->outdev = info->indev;
 
-	info->hw_outdev = info->indev;
-
 	if (nf_flowtable_hw_offload(flowtable) &&
 	    nft_is_valid_ether_device(info->indev))
 		info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
@@ -212,7 +209,6 @@ static void nft_dev_forward_path(struct nf_flow_route *route,
 		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
 		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
 		route->tuple[dir].out.ifindex = info.outdev->ifindex;
-		route->tuple[dir].out.hw_ifindex = info.hw_outdev->ifindex;
 		route->tuple[dir].xmit_type = info.xmit_type;
 	}
 }
-- 
2.47.1

