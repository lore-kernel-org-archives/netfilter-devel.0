Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD99202996;
	Fri, 28 Feb 2025 20:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740773784; cv=none; b=gxpAnBj4YeYmM+yJOHL+lZ9cwxwH9hQCT4IqNon1DJ8ZNndyNT8HPXS6Zn/PgLbw4D0cBRZY4iYBO+ZYWZxing9BDCUw+qnHnlB0rkhaoaEFMHe3Ns5Jmf1Osc2B7FpfrHOmrVfAr5tooEfSopw1gWqJGk5RK/e4uR0lTBfQD/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740773784; c=relaxed/simple;
	bh=G4AeYP9zNF3PKma7qNeEx/0jubqtWO3LgYnYYjWH/PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcYpqKAjo5U4tSKouR7fFwoU26aVjyHtvmI1i778fGMS5IAzy/y3yqQ7bN0SQ7ryl6WnEJ+Z4MmPqHRl5AUMfI6VCW5hdm8kdOawljXKj2fSwtaetQdsSIKH3DFBrvwSgrHKTkE0onjsERZEw3wX30nYTANzRGpfdCTcdI3589c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HUPqnLx/; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HUPqnLx/"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-abee54ae370so357715566b.3;
        Fri, 28 Feb 2025 12:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740773780; x=1741378580; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h3xV3TA0ockrC7/s5OEcRj/pNoR8pLIoTTKhN2eYQLw=;
        b=HUPqnLx/0+akIo5H1gR7Z0JqANMghphM7LJuD43KSN5iDfcFd47vzDEKlWiLh6NMl8
         27rWNNyoDqsfG3xmZA/cWa7RoPUrnFsI4+FvgswWhWYNpyT/AEpecQvY2rfyODEQTVxg
         Nw9p19wAXnRq72VoP9Pv82EqwJrR7l1338dIPlad1OqR9bCutSx12zV8Ijetr4iyRuq3
         QNOS5H89iQmr/agDN/OVQIved90lFbZ0SGZXxtpcTORQiP9EiQ5l7I5+y9Mbr480W984
         L9r2rHBUWc4P3OlX/3Mgx5KdGCJGZgsMRqAF6QykKCe+XTT7X+E5Wxbg/knM/pICQ6VP
         YAsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740773780; x=1741378580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h3xV3TA0ockrC7/s5OEcRj/pNoR8pLIoTTKhN2eYQLw=;
        b=htETL6pv4ICBRL2IdjJH9Z34FtZk0Qt2BbzfkjwhrfLDTI1SKfAhghxUlPMK3BIG9s
         Dx3EYdLYMWfYoxzEjB4/CQZT8dSP3REP+b/YJZKiTSeHTMzkUuqWDaOUJe9QamB7DJVY
         0pbDMVcEDT8CWJn3xQ2zcNODVa37lxv1frgu55jFA0umwHnqXl6yQBB0ZNlSmvxaSPlN
         Vf2mqF69AqwsDwFO4OVNS5lnuIyCqbf906CSZOvqI9vDWA8j8xf0ThCVZKUCNwxM8OI4
         HsHLhs/t+hxH5HGx73Xjnyj2HJORJYHErsepmdFNx0KHFgsDYnvoA4GoIW0emF4fgnkI
         O7RA==
X-Forwarded-Encrypted: i=1; AJvYcCVIvcwa7s8J3B5wZ2sYF9dqKzZRyRJVOEHDzHJyjhBTJxrso3/rZLSVZ7L0q+Jfm2LqMQI1JZNs2cskNNDm@vger.kernel.org, AJvYcCVbf3nROvHEbQ2f2j5LYIsP2LaapjD6Z7VrZteu7a1YNyrNawLUne8waAFFFRSTr1Fe/3a+dtvP79HA03cb4JM=@vger.kernel.org, AJvYcCX7fMntI+6Vr2eplR3JUbv8ahe4b3Tdw5VGLU9nxcX+xYiuBAT61vd5BVZyXtaJoS7wl0mOvMji5LKyeq1aVNXT@vger.kernel.org
X-Gm-Message-State: AOJu0YyE+uRhEddkQIyImza5rVTznLFhvEBAl7Fum/ImtKxS6bH/8uYY
	v3ABegsgsTnwHbLsOLI2+9tiJM0rhqdBf/KIbDKeRyGZJtD0ycTe
X-Gm-Gg: ASbGncs4RszgcD3X79buu2KSoAWTuALlmcLKZDEb/asyfanj1BmQ/vSTcE19rn35gnF
	TKRPcess50IZv8fiTS2K0P5zKjzNBysvkpPq1x1bttUoAk59NxXbvHjWvOkVTxF6WV/V0nod1fn
	rJIi7fCC74lAOCDhyLt9qPvPGUuQ6rNvd7j5GJxMGcP3F0rZBSAjsU++4Qr34m8+IisCDWfVw1M
	bLySkQ5MwI1Ok9fwUK///Mu91eBMTiwgoAMJv4UH/PF9QZt5UZ+Af5Jncr2Xz8yknAamg/U6M0q
	rEhStHxENECZf0yKHsyE1U5DDDrJowg4hN8RnxteQ99VbJiqP8CMGoFEqj6bfPWs+C9CN8XLVWu
	cLy5nUKjcyLdxJwsNh4qdiMj0jmitYeaPHBo4WSxVUpM=
X-Google-Smtp-Source: AGHT+IEiUtc0XSpuKyIKeLozoVWm4Sd50Qjo2FMlO/4dpvxhs03yVO3P9mswx5jt1Mq2Z2AMyoPXJw==
X-Received: by 2002:a17:907:9408:b0:abf:19ac:76d with SMTP id a640c23a62f3a-abf269b9a91mr541954866b.51.1740773780345;
        Fri, 28 Feb 2025 12:16:20 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c755c66sm340812666b.136.2025.02.28.12.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 12:16:19 -0800 (PST)
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
Subject: [PATCH v8 net-next 03/15] netfilter: flow: remove hw_outdev, out.hw_ifindex and out.hw_ifidx
Date: Fri, 28 Feb 2025 21:15:21 +0100
Message-ID: <20250228201533.23836-4-ericwouds@gmail.com>
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
index e06bc36f49fe..d8f7bfd60ac6 100644
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
index b4baee519e18..5ef2f4ba7ab8 100644
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

