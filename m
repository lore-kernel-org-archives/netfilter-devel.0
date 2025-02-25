Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5410221930C;
	Tue, 25 Feb 2025 20:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740514604; cv=none; b=A7Kcyr0QOz8Wd811tMHrMB5UV4da8hhhdNV3P84xoTn1fcf6zgAakn5MNveA2CyD1stw2Qsuv3M5tDjVGSCZwrViney2l8QHbFxvLsGsY7pO436811dT8zjbrDAhSDJJu9QtOO+GHsE5uRrw5TLiQe+tyJdNEvqKfO/e7BJFIZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740514604; c=relaxed/simple;
	bh=1+de0DPWCMsSJ95CqVzExQJhx0fjAqUotezYoUhDTKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcZQRtqzwz62PfYVbnE4flmJH6D+KCuc1xA+172eV77NsktToB8nr4vNqpQMgJoIMRbo54u0pdYB+z7/n/edShEYemWFhaEZHfqWzRLXS4AUqjqBsFU1Nq82VcSfic1QhWFAC6szyS0kw5g/7zXYUNIXJZWDVgcM0rDgrClkVNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RqU3UFND; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RqU3UFND"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5e02eba02e8so8210121a12.0;
        Tue, 25 Feb 2025 12:16:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740514601; x=1741119401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lqvEEiGjtfCg1O2c4wJsc9rlXi5oFjjuoYnCbbZ/cQM=;
        b=RqU3UFNDlzgBF6orq9BOqDCgb/9HDpL/j79ZlLq8TIPaqAls3yePd7F5n08OQ5hpEy
         ey1zLTZbp6Jyumoy4EJxjsDfZQicdbYAwoKYvmnHTVtM5zbuIg8e7hf4294CJ54j+0li
         TS0tN1N70BpgML4t97aiPvNH6CyTNc+0OoGSHBNFWpeRo5bLXTJQtjbBwMqDXjQJyVgn
         LR5TE6knXOHrJkRRN0SvCdQK4kS/hqZ5gc9rk/mhsDA91LSaQP8YdKn6Z/HFVPlNZ+5r
         DeG435FY1q1URd4O+bs1kmm/MioyTs3NN5X6OTN2D5Ew72xUuXqcpR1TMCdgQ58cMjKl
         myow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740514601; x=1741119401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lqvEEiGjtfCg1O2c4wJsc9rlXi5oFjjuoYnCbbZ/cQM=;
        b=iPcS3EpioOngtwPWjngaf5H7/nDZKi6LcFXiEGt4GJ18hhbAyCdc97+z3gDoJQSGcg
         A4NNAo4HS8a6uFRuzkT6eJMHO1mKR0ndWLjSNBweMcot70u78p9GPtEurIzCUHWX+4As
         nS3IXgNTOsFuSmHIgu4zuAJ6Z87g2B1PUJHsnuOwzhE6vQa8JJi8+1XLNnWFm+/IfAEk
         iBT3bm0XWgZmcAf8tZmT6pKZf0vNY+OwyOtwHge5JtpOGDq8M8WXcenEYryWXrbu5JXO
         vQ0IwmqDc9pIgUrLl9+hxaMJS1CLL8LFT4azg2ezPnCyCsn2CkvKmd88qQmmZuP8cRAe
         wx1g==
X-Forwarded-Encrypted: i=1; AJvYcCWERYQ5a1UtUjFYUbblA9Zf0EsY4Wsw9pnhxzsed+2E+Z2LI+NrGZ1CmwCQtipgAn+iZbDYg1q75LlixmSsaHET@vger.kernel.org, AJvYcCWiMaX3phvQfHSiuQcqhRXqgMCS7D32V5JB4+j87sWeLGKZujtrung21Djgb6LQ9B+GjK+M+rjVYRmYZnM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+kSd9Gm6VjWwSKvKScBl9TjosmSmIlapDWXRauBBvKgr10iYO
	N6eXVi7HG0rqB9KVlVpYq6VaA0XTmXW0PuLNUUDxjBNKb+bL+/2S
X-Gm-Gg: ASbGncvag7bvexTvi+cbftzmB78+BC8hcU5bdiCTJddqgJbJGxpDEA1bNT5QLRF5IDq
	G/flO2b9ftvpULHOtAlJQdDVBzOXFx8SvEo/dVJiYcbpZkOdnB3mzeXr4gS8rUsqjMmGqUY/JBW
	FwDLIsqSE3M2Uf9YMQwxKG5yaID4cmdQVnYFQqRu6BqRdExWMZeBLwYMGd6yXrWFIwEeSByIb+i
	vLEl37KalwZ+CLOxHtcrSTmMXo8B2ilhRPc5R5CWm7ebrrZs0nzHyFxdMZyoQWhCSP38zJjyXSa
	OCovn6ExUtYLFMDNCVMRZaoHBMGwu7WAXekK6+0phqFc4avRpq4A6AXrDnkH3NNKraqHGQUuQnN
	XQ+OQSfm6M385C7DMPBSZHz7isYhhlJXM+11lRL/q2fQ=
X-Google-Smtp-Source: AGHT+IHhGusG5BMLrTa3hM8cjvDcEm75Lf8vLAMleB4CleirSzLNiv+mlxD0ehZbqG9bpzWHQ5wVQQ==
X-Received: by 2002:a17:907:3e0d:b0:abb:b209:aba7 with SMTP id a640c23a62f3a-abeeedcf3bbmr43896266b.26.1740514600495;
        Tue, 25 Feb 2025 12:16:40 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed201218fsm194319666b.104.2025.02.25.12.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 12:16:40 -0800 (PST)
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
Subject: [PATCH v7 net-next 13/14] bridge: Introduce DEV_PATH_BR_VLAN_KEEP_HW for bridge-fastpath
Date: Tue, 25 Feb 2025 21:16:15 +0100
Message-ID: <20250225201616.21114-14-ericwouds@gmail.com>
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

This patch introduces DEV_PATH_BR_VLAN_KEEP_HW. It is needed in the
bridge fastpath for switchdevs supporting SWITCHDEV_OBJ_ID_PORT_VLAN.

It is similar to DEV_PATH_BR_VLAN_TAG, with the correcponding bit in
ingress_vlans set.

In the forward fastpath it is not needed.

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 include/linux/netdevice.h        |  1 +
 net/bridge/br_device.c           |  4 ++++
 net/bridge/br_vlan.c             | 18 +++++++++++-------
 net/netfilter/nft_flow_offload.c |  3 +++
 4 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 695445927598..9ac7142ee493 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -869,6 +869,7 @@ struct net_device_path {
 				DEV_PATH_BR_VLAN_TAG,
 				DEV_PATH_BR_VLAN_UNTAG,
 				DEV_PATH_BR_VLAN_UNTAG_HW,
+				DEV_PATH_BR_VLAN_KEEP_HW,
 			}		vlan_mode;
 			u16		vlan_id;
 			__be16		vlan_proto;
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index c7646afc8b96..112fd8556217 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -430,6 +430,10 @@ static int br_fill_forward_path(struct net_device_path_ctx *ctx,
 	case DEV_PATH_BR_VLAN_UNTAG:
 		ctx->num_vlans--;
 		break;
+	case DEV_PATH_BR_VLAN_KEEP_HW:
+		if (!src)
+			path->bridge.vlan_mode = DEV_PATH_BR_VLAN_KEEP;
+		break;
 	case DEV_PATH_BR_VLAN_KEEP:
 		break;
 	}
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index aea94d401a30..114d47d5f90f 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1494,13 +1494,17 @@ int br_vlan_fill_forward_path_mode(struct net_bridge *br,
 	if (!(v->flags & BRIDGE_VLAN_INFO_UNTAGGED))
 		return 0;
 
-	if (path->bridge.vlan_mode == DEV_PATH_BR_VLAN_TAG)
-		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_KEEP;
-	else if (v->priv_flags & BR_VLFLAG_TAGGING_BY_SWITCHDEV)
-		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG_HW;
-	else
-		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG;
-
+	if (path->bridge.vlan_mode == DEV_PATH_BR_VLAN_TAG) {
+		if (v->priv_flags & BR_VLFLAG_TAGGING_BY_SWITCHDEV)
+			path->bridge.vlan_mode = DEV_PATH_BR_VLAN_KEEP_HW;
+		else
+			path->bridge.vlan_mode = DEV_PATH_BR_VLAN_KEEP;
+	} else {
+		if (v->priv_flags & BR_VLFLAG_TAGGING_BY_SWITCHDEV)
+			path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG_HW;
+		else
+			path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG;
+	}
 	return 0;
 }
 
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index c95fad495460..c0c310c569cd 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -148,6 +148,9 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 			case DEV_PATH_BR_VLAN_UNTAG_HW:
 				info->ingress_vlans |= BIT(info->num_encaps - 1);
 				break;
+			case DEV_PATH_BR_VLAN_KEEP_HW:
+				info->ingress_vlans |= BIT(info->num_encaps);
+				fallthrough;
 			case DEV_PATH_BR_VLAN_TAG:
 				info->encap[info->num_encaps].id = path->bridge.vlan_id;
 				info->encap[info->num_encaps].proto = path->bridge.vlan_proto;
-- 
2.47.1

