Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC1B1624FA;
	Tue, 25 Feb 2025 20:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740514592; cv=none; b=CKWbrUwgJf0EKTkuTn5B7dbalMxYejjqDjL6y6hPhEIHkX3rGPdgNC30ZiHLb+sZTTswE9mR4AehpEbij41GxEY3bh3AsYszmvjRTBun1SPjNn3IK6CuJchndh621OW/kYQcM79SXcxrpMBo0lP8V2abF3cXiEOH7GIY4lXW35E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740514592; c=relaxed/simple;
	bh=G4AeYP9zNF3PKma7qNeEx/0jubqtWO3LgYnYYjWH/PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AsF47WFztK+Ons/9YFKAnJU2AnSUjuA7XaOxa1jx5bH4cvgPysISr7GnVdCwN0p9Q45yOG7JWWFK19Tcf7xTe2yDdfrBvZy7nPxbV8/j/8OSJo9XU/N160HmfWUJ7YcoMhx0MnujpHEoDG5rOYEzNFXEc20DFAYOVmBp2QnUAMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EKyHJUhZ; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EKyHJUhZ"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5deb956aa5eso8394872a12.2;
        Tue, 25 Feb 2025 12:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740514588; x=1741119388; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h3xV3TA0ockrC7/s5OEcRj/pNoR8pLIoTTKhN2eYQLw=;
        b=EKyHJUhZcRijeMn5dz8a1wtyHjlUyaiuZ09iHCFz33jTLPqOE4Pz45MARKrZ/EEaRc
         qhRwjlIzr5dDVfhEzBSASZYWebv6epzWTq+Mm0IoXXXg03TSo3y/Cn/ZDWONasJaQcf7
         /v+p4jjwUkKW3cfew4epqbY6bTp0Do+9pi8RGrk/ragy803mqrh0Q5V6CBDlfrakOBok
         lv9LgG6GIyMW7GtJiMSIAJFKZI1MsB4RdjK/9CCIQs6UoTYqn8zS+cu/gwyRDxC+0x28
         6VcHsr4PrG4qJc2+PtEYypKqNJeUfN3kTxzpe70VDN9sUOwBEnD2DOEbAdYLBhuqnE+w
         ID7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740514588; x=1741119388;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h3xV3TA0ockrC7/s5OEcRj/pNoR8pLIoTTKhN2eYQLw=;
        b=eShtgifWqN+Y6cLG46h4kqt+sD3GQktVqz7vyOUBWPCj1FfTeZOSw/Pz5b40uDsRq0
         FIauZwDY/NpU9lWb4XRo5SBag/tS174A/05THlszCjKmT+PVSMLo/CPXWwekrVWGFqLa
         JMBHeBOy0njbnOTKa8xRW4aBXielBBo+vh2sBOXWK0QZ0lo+vTokelONAaNdWJHeCyI3
         UpfubhpJQJuKASND+yrJWjhR80BTi0w4ScL1UDzIduOjnGhBIdel0n3UaKUVxYlb3ZsZ
         QZEgW+sHRwrRH3SptzHDgO8oHm+h8HghwDJMjllQlIskq+QLGlOdWva1xqdEq8Kty705
         cisQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQNbI2jcIZODelqNtd9P/0d6GQzuokI5VU0ZUMvNoV8pDb4Vmuy452RSrDiW+vl6YcLyxNtJsMHPFxZqU=@vger.kernel.org, AJvYcCX0pTXEYJxm8IrGJR8VsBU7gC2cJXjtUq/rlnVtGcXwVkmwndXM2lPAAq+j067wz9Lvgwo36fEJ+xl6XkjeiGMm@vger.kernel.org
X-Gm-Message-State: AOJu0YyouK2nWmzyjs37HMLBw3DDrusOdoY84e+uqgzprIV8vUpum1O8
	gpd1atMtUjxvQePwd3EnFgrqiV10NZ/GTJ4AsTjC30wJovAjFxs7
X-Gm-Gg: ASbGncuqiBvT4nU0yZ2owKVlKAgoydiDY3rsYVo8NAyo9umF8GG5MT85xUYkHji6U5b
	SNdOTyGuq3icicWZ0shSXy8XTk+m70F6lIoI6fG5kMgc8CtdzeyRKcfnIXOy8OhEx3i0U8yhXb8
	N48SEBh/XNAVfscvXcLbFU3VMpS3fPcL2WvFRiGaxDK6kLjDPG7UPx5db8zsWEEwp57luy7wCXz
	6sXlwaULfLtfxM4TUJkIDQZexDztXTiKQ6Loo9xjlqbfQH3JN//M/AvoXR56CGsuVB/044i7Nan
	RuYadpI7zW0dO7I1enHbBtlsWQyCdVM5HiSw6wOqqiztS5TRlr05eK9BpdDT14E9LFdnyopw+OC
	BMlMk6YgIYzq12E2zuRQyn2+TY9d5oxgNCNQmP1zk3TI=
X-Google-Smtp-Source: AGHT+IFi5xh5+qQVymlO946K7Lt3PSU8gs3AiUL8uPpi5lpGCGAduFw1hnHU+RygxLF/r/WZYXOsOg==
X-Received: by 2002:a05:6402:2812:b0:5df:25e8:26d2 with SMTP id 4fb4d7f45d1cf-5e444853ee3mr10719586a12.5.1740514588315;
        Tue, 25 Feb 2025 12:16:28 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed201218fsm194319666b.104.2025.02.25.12.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 12:16:28 -0800 (PST)
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
Subject: [PATCH v7 net-next 02/14] netfilter: flow: remove hw_outdev, out.hw_ifindex and out.hw_ifidx
Date: Tue, 25 Feb 2025 21:16:04 +0100
Message-ID: <20250225201616.21114-3-ericwouds@gmail.com>
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

