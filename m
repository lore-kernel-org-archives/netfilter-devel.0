Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E377F2185BC;
	Tue,  4 Feb 2025 19:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738698597; cv=none; b=F4cnW5SZw6FZBDiLOF4bksNfBRtqlXHdFyQW3lQ967fNuWa6p3YsoZmc9IdobmEKSiWY0xHaTXV+4vMcJ97u5GQ+1CJSEq/h6C7MLCL9OALQxIkdgU5ulzjsLAxpflKy0SZUtx28kkwEIZVK0mmPLIQcHQu2qW5MHT2GvQFCK5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738698597; c=relaxed/simple;
	bh=rTY7nGpwAt/CvtxcIfBc/CESYzTMIKrQGo6gR2WwnRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4CPtYS6NbXTf/hOLatxQX9Df1w+nbVXpnUIP7vubmFwFlwDKlSMUjSI2iaoqHfR7+1svmbA/aHCDDuFikXOCTJDxNV5tTXjSAoHtLdiDIDb/5ufou+FiZORnXLr5y5/dqGH6dK/iZ84FFxUtoXbL76BJycRcce8HNb2utnx0bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gfebafZ6; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gfebafZ6"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ab34a170526so950432866b.0;
        Tue, 04 Feb 2025 11:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738698594; x=1739303394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uYHS436MhCvQPNlHTWPNiRlg7kt4orCDQn4NLGRznHk=;
        b=gfebafZ6XGTXuvDTyxOesfOgCgn5nlUd1oytAPMkh7pJthXWTEzhC9hXbjFbTsIPzB
         d6PB9rJsX2U6X7eKV93n/fxz28ZF31EB+Lnrw3vSfs5Q39GC38p5T1rt7E4n8LdSIDfF
         t+XmLO3xFGeP+/Ts6cbNoqncqmlOsVU6d6zHdFJ/PjElddBolHeVV58X5ScmWLQoEVxl
         +b8ezSWLOpC8UgWcuGnF8AFvBOCp7SimObpIV46BJOm2F9OkBxjoahKEjiMibAz+mtsW
         iTSV40FD13nHXfg8gZUKxKCnQcgzU7jhQvpnYnUqX9G2wRXrQxHehqLb1qtFHYDetZAg
         x8DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738698594; x=1739303394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uYHS436MhCvQPNlHTWPNiRlg7kt4orCDQn4NLGRznHk=;
        b=FIPtyA0LQlO4QtyDtCx4m1h9jHJ5VjhS5jn+EVwIeq+kWjbP5JTtzxujp2oQyqtna0
         DfRJuKkmIqWdotLAJ08/byAb8A5Y6gROJq1KQ8FvsJz31P7mpFgH/2rc1HnhlqLzdj8M
         jiejw8h9ukiu7aj3QwBKRxVAMEmtzY1AEUYJ9I28xAzIcC2a/NvgbSMlrhBckZGi1PKc
         s/fjTrK2tBoj5mCxZRW5zW7pb+cQoc+SYkaKy7GA1w4bHZu2JiXTgr+fPDYmj9WOF3OI
         Q8W8MamF6vLi05OVxD5ZNvlY/8v28tQIgJ0Jyl4uL2hCa7d0d+kwSF2U9vT3Xq4UdIyu
         5jEg==
X-Forwarded-Encrypted: i=1; AJvYcCWPuMjZVVerJhtyXHotC7UQW0oD7hcIg254hYtemQbO8jt0V0PDT7Zvf5h1e/BhBgyzP0hzv352tqn5S3BAIHot@vger.kernel.org, AJvYcCX+zXHYcJ8edXW3vKweHgRA3R4ALUPE59nmrsOZKDg6lWEc96a6A9P6k9k2DNDWQYWop+AZ+itp+iRCFWo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcVKmc3vFLGUNGTsSCSbYUeAaub1t/ixD/X9a87v+yCtsGXo7N
	aoGPkaDFxjyatHIBRum25zOug0MUZ49WIPb1HQCrZlPZ7LtrUo3V
X-Gm-Gg: ASbGncubaa+Bc8VB6IL4tpoIN4rmnt2nqBcXrYt1uaKYPB0jr5Q2puDPCiSrsNqNFfG
	buR1ykHyHdmvt6++jAgR1wdSobt/4d4fQcrNBN+9UTFj2npkKhmyijy0PTUV/L1hTNtpidXe1eB
	WokcUz9dI5cyZx/ZzpbMoSuOe4f2Z7ix8holZA52eJrrIhiFb6aXg8v56q9tm8Rv3XfjAkmGhsI
	O/KkNw/EKJFlUNQg+Zh2AE4sD7i3m5CQX932pncnVPIp1y30vIbTebTCky9bA9TXN4hpwXa0nXP
	lcqzYhREVpAleWljM+k+nLhcwgQurQdWzNYyyI5TYX1iMJEtx8eoftcw9VIJMJAHRoQZXC28rwH
	HpBj91S+itdKb+cvwJOIq6Aq8iY6+qSpT
X-Google-Smtp-Source: AGHT+IFfJwb9MQyefWJ9mzFYp2BV5PmqGkhxPrYjuZLqNPTns6xWOMQoNOZAbpkulbWsZqH9uAZmRw==
X-Received: by 2002:a17:906:1691:b0:ab6:d686:de7 with SMTP id a640c23a62f3a-ab6d6860fc7mr2382446866b.44.1738698593832;
        Tue, 04 Feb 2025 11:49:53 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e4a5635bsm964684466b.164.2025.02.04.11.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 11:49:53 -0800 (PST)
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
Subject: [PATCH v5 net-next 02/14] netfilter: flow: remove hw_outdev, out.hw_ifindex and out.hw_ifidx
Date: Tue,  4 Feb 2025 20:49:09 +0100
Message-ID: <20250204194921.46692-3-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250204194921.46692-1-ericwouds@gmail.com>
References: <20250204194921.46692-1-ericwouds@gmail.com>
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

