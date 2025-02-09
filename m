Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78160192D87;
	Sun,  9 Feb 2025 11:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739099449; cv=none; b=YJIUgKqWItoFK2RU8a1OarpfOpvgVUtc0t16fQEfsmlSiPrVTyyufwRuNe+P17COtn2+7WeC8jzFGYKwmtUb4NesUXkqfmV76bKxWwIM/ithBJkCgg5BNOKvaLTXqXp0CnsjAaux9VdcpYMW3MmZ0WqKuo+7oEHKR+7NbpdoD/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739099449; c=relaxed/simple;
	bh=G4AeYP9zNF3PKma7qNeEx/0jubqtWO3LgYnYYjWH/PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=raKszrtp3slOZrI9p7V4QwlabYX+9zL/L/8zKZe+jtSb7hiip0mz0pZYxH/MVCoEfYRpesiyU3Ev5H14gVFjY4INefDE3XMQqQDJIaVCsLo70vzJJowEEUdMJL3hjjzH0BB3C1cweDtkrT8rrA4ZgeCkZ51jmY8SWIVJcS/1ikQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DRa7BazD; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DRa7BazD"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5de7519e5a7so282257a12.2;
        Sun, 09 Feb 2025 03:10:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739099446; x=1739704246; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h3xV3TA0ockrC7/s5OEcRj/pNoR8pLIoTTKhN2eYQLw=;
        b=DRa7BazDpEgYjDHg9FuhufYxj9dqB7l82v+ujl5fNxdNYnt4xsSrREQL/hnjtJNXYA
         WXS0f/nsje64XPURdcx10FqNuiR/qY3qoAZYUNNR9C+lDZ3aonI+wdyR9BeeeKsPtKw6
         skWjsLVtpIBiyK+m5ZIXlkzDcIP9iOAYDTI7gyxNcQVRFVRle8eIcmGHJSvW1ncG5KeB
         jwMjjnua78FDWWrNT/89S3vTHd0GXAJRd81TrlKstVk6jGntPIY9pVvglm8otgEPaVzR
         xuKJAhlihc0cfVaJJRzfZQIZOHos1aROoqW89hcfyOVvIV6hWYg5hTFiPm7ysFxAu2ls
         iZ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739099446; x=1739704246;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h3xV3TA0ockrC7/s5OEcRj/pNoR8pLIoTTKhN2eYQLw=;
        b=UbsIPtB7bmIn+4gNbx79a+AHXiPoliGilfaG9gf/GQWCgl+94Mb3FohSfRMbb1q4a7
         2QCixNrvYiwKm0c7nQprcFYEphpe6qstJ48qWCSGJbe7FdYzRgTuFbM1R2HH4qX93OZ0
         BBZ3sS7NbaBDoHlrWFbKc0IAaM+Ef+405tCcfX2liK45Spwy3xfoA5Sms68KQDYril2P
         3AMf4Le98QHQ1sU/HzvFo53hZItOPFrr6Y89B4DqPMhKK25pLsLAEfI2PMPVqR+eK/+A
         JgzRheWqoPxXmfdbmOl+xGmB4KLuE2AHH9KcpWJblUoMRnUkf00fw4QdW/KRmPkNudFb
         kw2A==
X-Forwarded-Encrypted: i=1; AJvYcCX/pRTmrmRQ/PjvRxINfeq430vn7AlDP2/XJdKk3pIGgmv87hYkjHl8IORxGCEN8Pi5TFXGPUfbR2/eoX8=@vger.kernel.org, AJvYcCXno3sNvs4Iz7obZqdMfG8PM8EEGgX/ngAn1Gc2IwODTpHFqfog1hfjiy71R4vPTHx89XqzI2cdiesjHyWhALAz@vger.kernel.org
X-Gm-Message-State: AOJu0YwcCMgHWE+NN1M1QN5/bfx5u4/k3M/8T5glbP0WA+ZHgYGPvjG1
	9cRCJnL1f3ilz6bXp0KqTAYfY51JxyKtZKOo2b92fcG5PUhMr5Vb
X-Gm-Gg: ASbGncvbNNIMQoq+IFhPdOA7QIKZef+VbsO8iNuSDm7jwNDOLjN2+0QJ4WUlUKJgx9k
	L5S+Pi9ZaUoLGUOhFAErVtKpZlAa6YLcPyqyo9w0Dgh8l6deXQGnTugzLeoSrG4eCy2nRMCe7I6
	yGThmkIJGAAqUsyJl3lOiYLNBMTMTD2M/wZ9fnWw0IT65nlNoDtSwkpcZvdOdnVZGoX+oPsidE9
	czHtuv5YevMycoVH231j/+07SM8W0BxPERGsdFcSN1ocAqncjfP5c+Ol13J9zt+cCDn0yQhsl3c
	6LAWAmgTFKfK1tO3PG5s7ELqhTb9czBIWPxYenpTerfFBTMMdMaPZR2RtuePGdVoV0N2ZBjYyaQ
	2BmJkCdjwn4Zoi5BR2mMEtqBoZiYDZqZF
X-Google-Smtp-Source: AGHT+IGgn06hMTlVvi9pNiIOCGf289zNj88FfDXoxW/6B8WNNLYcdoNWmCMQN1J0/mTfbfKOoidTdg==
X-Received: by 2002:a17:906:4fd6:b0:aab:d7ef:d44 with SMTP id a640c23a62f3a-ab789aecd06mr902224966b.24.1739099445427;
        Sun, 09 Feb 2025 03:10:45 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab79afc7452sm357516366b.163.2025.02.09.03.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2025 03:10:44 -0800 (PST)
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
Subject: [PATCH v6 net-next 02/14] netfilter: flow: remove hw_outdev, out.hw_ifindex and out.hw_ifidx
Date: Sun,  9 Feb 2025 12:10:22 +0100
Message-ID: <20250209111034.241571-3-ericwouds@gmail.com>
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

