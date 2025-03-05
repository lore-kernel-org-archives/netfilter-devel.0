Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0C12080EE;
	Wed,  5 Mar 2025 10:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741170611; cv=none; b=l0NlJfwNaTsEgZHX1waTM2Xv34MB6xZIjuCK4Q633m8IcyQtV7ujJdz9i5Id63H3Fb0TY+eoXbaKaM2W9pJ/iZBAuZ4/JXMJcCGy3tjTlFn/5WtJcu+Ng9+fbE5bX5JnzJIQGjiIC32ccWjjEIRXZMhN8Q9GWJylQSMbH8ooYXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741170611; c=relaxed/simple;
	bh=G4AeYP9zNF3PKma7qNeEx/0jubqtWO3LgYnYYjWH/PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZaOCesn9itTCusvv/LvNDu6qyw+eCZy90RoZhdWBOfjhrac8HodV/U6SzDTkNPDJbmnYagFUbAFudQvYmoQZUjywTpYM0+yTyDVMsG0T7E5UinyUJjcapJolXYrPtYeIhZ/G+HI9KZX5EAfatMHghhHZQu6xzf/rRtInwKSA63Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ixfJQfy9; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ixfJQfy9"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ab7430e27b2so1071216466b.3;
        Wed, 05 Mar 2025 02:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741170607; x=1741775407; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h3xV3TA0ockrC7/s5OEcRj/pNoR8pLIoTTKhN2eYQLw=;
        b=ixfJQfy9MJv+7CuxtyIDxjSRuUpsZB/J6ZNgXa30O/cF36GsR1ETl/p10XPK4ZrWOH
         lLxX4tgCzbTCWaE7cbW15qp3rU7tO6SUbWcWxK9JYJd047ul1fLLZpMNJX9pjWRlWGqL
         s+GKQDCFUnHPMbSpp/0iaU21yV0eR7tMTEU90iixfeJdClGqB0IfxaHn0v9hcPErhIC6
         iZcjxjcKSaReXWOKtFq3xk0HaWK1gsWM3RQaHmg9DOfgWQhpD3hkp6f8SRFk+2ud03fL
         TzCgZH/7lMn80gjqwRh5x1Wbey1HR5t+SnxJZbYqgEXr3QmNqxcFyNmiPPYn/hl6nhba
         IndQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741170607; x=1741775407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h3xV3TA0ockrC7/s5OEcRj/pNoR8pLIoTTKhN2eYQLw=;
        b=Hxo4ohn6YlC3nhd/Cyi/xMmhTYPGRFwR9dqjEip+VtSBcAA2Gw+4fMb8sltiYtq9u6
         C87saqR+lMX70wJCv91271QwcC+YL8SbQC911otZYteiE2hYce64wqxdvnfofU5GjyZj
         w5R2tv7qIcCadJBYUhyazWAfvbJwIJq3ah2ekps5QtumgGERfco7zLSlkAwjMGzG64rN
         /l+VxsewXRF6rOYf+VszibtQpAfUttiUnj7I/DrMNjN1f3kt8YRq8bh5fxKmQxHMoZHq
         8rAXTHIzvkWT33VHEe/+gv1mtVMtj0DWisJah0pfuT8C8wF0XPpjxiPzyvQ2qHrdl+YN
         ZSig==
X-Forwarded-Encrypted: i=1; AJvYcCV8rP3dwAkKy+sDYVsVk9S72pM2O8ClOQ0iG1Cwxf6r3uYwsmkq4bp/GDmCwM6drPj2m03UzocaBb/oX4iF@vger.kernel.org, AJvYcCVkXoJ3sKU3Q4peRixOnxE+OhlLBa9UGn3jj2oGRwgwG16vQ9P7zskRlA9M+nDwh4LMNJh24SqSQFUdFQxCVDEM@vger.kernel.org, AJvYcCWfd/mDEuQpAcXY7Ugr6CBB7FSob8ofDgKGM8euAUtEB3J1v7TbcKRttVmMrvOM+ZDS+JugtD4yORU26R5V8jk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzuY7Z41Cce4XZb/X21u6/7zX0g1sKVdMg1hq6h5+wTmSBq9ncZ
	cXZw4y3l6bIb55Lkt0cWUAVlXyFTwd0cYPoA7zuBV5rIK3kfX1XU
X-Gm-Gg: ASbGncskeL2S0Gd2fDv9R9WPR5C6WXxarZJE8lOb0X5XSWSrZVAYI9BPC0Qh3DbhOPi
	xT6VCkIJzok9YPIGYzoNLjqvlO7qF541KeNyb+GWvRqk+TdrY7luNQMRY2zq/22YsKmeqYoIYlR
	USbEV+4+AcSDwCwwxbN4J5bZiopOa00mgfFUbzbFg7Rw7pTtL9HmH106uTgpW/DAvQpYuo2ENe2
	uMqFLdUzgemeOssxDGp9HidS0B7RFEh+r8T1l04biYWWPsHvsxuXRYDsJHeF+AShPmIuDy2DQvp
	pAXYa1NP9R8bik2Jcgzr/rl2rHPdLiavIgYOyAMhLJP5uQW/ii57mldiZb5itzVcoV0fxTz3uis
	s9O2W+W/oC+nQzLuSEac9udACQt1jFnjY7SsDeF8iG0QiGBcf218OJmqpI4PPgg==
X-Google-Smtp-Source: AGHT+IFiJqR8AW9q4B4jV0oBAldSkpb3Cory3PfYPngFhkXoybiZBDs5zVQJdJ8Lft/VnBuwHJUAJQ==
X-Received: by 2002:a17:907:8b97:b0:abf:4892:b6ea with SMTP id a640c23a62f3a-ac20db37c07mr294449866b.25.1741170606779;
        Wed, 05 Mar 2025 02:30:06 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1f7161a4esm247154266b.161.2025.03.05.02.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 02:30:06 -0800 (PST)
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
Subject: [PATCH v9 nf 03/15] netfilter: flow: remove hw_outdev, out.hw_ifindex and out.hw_ifidx
Date: Wed,  5 Mar 2025 11:29:37 +0100
Message-ID: <20250305102949.16370-4-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250305102949.16370-1-ericwouds@gmail.com>
References: <20250305102949.16370-1-ericwouds@gmail.com>
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

