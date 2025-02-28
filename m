Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2775E277026;
	Fri, 28 Feb 2025 20:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740773788; cv=none; b=qXpHTRMSxKc3oGXqiRI/NapjXmblRwrx3RMVq+w8V/AF9n1/ZMyPNyy4vK7a6ojJ0sEngOFPQDH7ZwFlRKHgpdUxqqDVihGKKIAe0s6dE2vUGzNhnMHMHBmTUZkqt7+j1z0zq78XSb1/3WlaacDA6h7qGi8uR0gOJOCrDvmDJCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740773788; c=relaxed/simple;
	bh=sq5lC5Lgg2lgUcbphMYliAhopUKVFEXA0PcFARtTXys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GcOQw4UhrFMPYGvqn34YUimzMTIcvO7LawHzOimEqqgHNjuODZRHSB1H/jl/8KaEPLBIz9cg+CCra1hrolTE3fh1bBEifgOKtn44mk7TUdkD2QJES68TXqlIF3O31yl+nh+8ZB0C0kd6Zb/c3sOcDxvMLErlG4kq5aqnz1unwww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IRtzfacz; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IRtzfacz"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aaecf50578eso481652466b.2;
        Fri, 28 Feb 2025 12:16:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740773784; x=1741378584; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=glD7coNk2GO9/l1adKLN+uo1Xfh2D3YWudU7CjoMsSA=;
        b=IRtzfacz46VJ374t78G6uz7RnBuIICVMduand3LL9qAgeOPeXoAetvBwuBVoy/q19a
         oDuzTEOKUtxQfoRUVHOWaRvGTjRwNgzb2WJk4C65pTxFFHR8VjiLQ/nxtTAvofLLZfo1
         qDYN8BKh5AE9xkB2PuQPPaoORWhDCG2KXGywXHLJPHyY7uYZFe49hYwLXDv6Z+tl4Cax
         BjZZb9V6K29UqaxCd7PG0KV1OlWBJXkiQLgxuvlY2qir7EH27qPNFaBqlmV3/ZUG8LhK
         n3HDC11p1rSicMf50PzJ9Ghyv+krddPUJL0M8wNsj/DOSqmotzgdUzldLxCheOxJNZ5e
         k0Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740773784; x=1741378584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=glD7coNk2GO9/l1adKLN+uo1Xfh2D3YWudU7CjoMsSA=;
        b=CVkAydH63KgBsxtKONOgQ4DOkEor2xT8MUh8buA6YEeEtdR2/Ue5x59Cebm4TxQ4GR
         Sh0TaFGtXv6NgYl96pH499GVlwL/1OSbN/Gs+nLuS8PuOfIF45c/D31iLh2pFsyqIg2c
         /VD30DK5LtrPlqs6ueoHc+eKugBwLOhxtESitq1LU5nO+xYE+Qz9+Qr29TC+WAN00DW1
         DJPfKzNKavYMCZ3sDKXftKM1mhfG/1+vbQ3oJD2MaotnjNSkeTFdX4VliZEz6WPxApUW
         GbKX2q/JpuPXBlKKUuhEGS9MvQvp+yU4QB7J7uxDGsUTCJCasTdyB3l+3bLUICUKxX93
         9mSg==
X-Forwarded-Encrypted: i=1; AJvYcCUI8yPreoMsYwWvIDqmA4Pl2HL19BRKOJLCiocuz2UysLWp7B41PAlwKBJVyVJSCceMa9w/I/bUSZPMbY2m@vger.kernel.org, AJvYcCVONUFe2g5BXPNfOiHrfhiOJ0QONtkByviLyCvTen9zwh1BHTnffIRK79x2QxwaxWWeS5tSX9daRmN9ocofFY8X@vger.kernel.org, AJvYcCX/pE+GPQR1wcfS+zCHIaRwJuiLxQ9RZAR828zwMZMcn/GoS9x1G9LnVCMBqswjkudXnxna/w1KEGLJr6q785M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjtnvIYy/0/cU4T1/Yt0OPwut8g3s6Di25dndgrA4A2ReJg5Di
	YMuNUKGC8doZ75s8DoSeL9OsoAeA14blMZzYn4YiiDno7QSpJaFS
X-Gm-Gg: ASbGncvFFYESp6HUbfi6fpiapRcZjick2Qa3O+zmUOoyBn/gbtqqgSFqV1wA2E5QNL6
	CRQsDGytF/zRlG41kgNhsBRRYTPHbSc9Qx2C6kr74J9hN8jZiaBBh7zb0Yd2Aj3OyWA7L0VONxc
	gAqQOqJkodogxqQievc5WqYnNX8Wpb2VmV3vFxM1/p4lbx7mL8xhd9+u6ZoGABzDhzuA/yyyuWp
	nhu8zoGUcW2ouXY6OaBXyLrDpiS96TvW/CsH+H6JYkXjp3jPbBvGdtd97a5FxLQ8KtcVQpzJzXS
	lLWSkfRSufw2yjZ+01k4w44tb8oP8el0/S/r9uX+FbWn6kkIE+czv8iAYZ0tlL0ZXm8/tDUFGui
	EiG8GH7hwEHmfS0S0HB+pAwXS6XWWBFHwGoNCW2XuHWQ=
X-Google-Smtp-Source: AGHT+IEkD4+S63CdkvFhMcDqcuwDe3gQEzkaBi0DoNz6EL4MylQGJKFnzY2Wc6+ZXTl1u9JBQtGaYA==
X-Received: by 2002:a17:907:7f27:b0:abe:fa17:12e0 with SMTP id a640c23a62f3a-abf25f8dd1dmr472704766b.11.1740773784160;
        Fri, 28 Feb 2025 12:16:24 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c755c66sm340812666b.136.2025.02.28.12.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 12:16:23 -0800 (PST)
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
Subject: [PATCH v8 net-next 06/15] bridge: Add filling forward path from port to port
Date: Fri, 28 Feb 2025 21:15:24 +0100
Message-ID: <20250228201533.23836-7-ericwouds@gmail.com>
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

If a port is passed as argument instead of the master, then:

At br_fill_forward_path(): find the master and use it to fill the
forward path.

At br_vlan_fill_forward_path_pvid(): lookup vlan group from port
instead.

Changed call to br_vlan_group() into br_vlan_group_rcu() while at it.

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/bridge/br_device.c  | 19 ++++++++++++++-----
 net/bridge/br_private.h |  2 ++
 net/bridge/br_vlan.c    |  6 +++++-
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 0ab4613aa07a..c7646afc8b96 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -383,16 +383,25 @@ static int br_del_slave(struct net_device *dev, struct net_device *slave_dev)
 static int br_fill_forward_path(struct net_device_path_ctx *ctx,
 				struct net_device_path *path)
 {
+	struct net_bridge_port *src, *dst;
 	struct net_bridge_fdb_entry *f;
-	struct net_bridge_port *dst;
 	struct net_bridge *br;
 
-	if (netif_is_bridge_port(ctx->dev))
-		return -1;
+	if (netif_is_bridge_port(ctx->dev)) {
+		struct net_device *br_dev;
+
+		br_dev = netdev_master_upper_dev_get_rcu((struct net_device *)ctx->dev);
+		if (!br_dev)
+			return -1;
 
-	br = netdev_priv(ctx->dev);
+		src = br_port_get_rcu(ctx->dev);
+		br = netdev_priv(br_dev);
+	} else {
+		src = NULL;
+		br = netdev_priv(ctx->dev);
+	}
 
-	br_vlan_fill_forward_path_pvid(br, ctx, path);
+	br_vlan_fill_forward_path_pvid(br, src, ctx, path);
 
 	f = br_fdb_find_rcu(br, ctx->daddr, path->bridge.vlan_id);
 	if (!f)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 1054b8a88edc..a0b950390a16 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1584,6 +1584,7 @@ bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
 			     const struct net_bridge_vlan *range_end);
 
 void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
+				    struct net_bridge_port *p,
 				    struct net_device_path_ctx *ctx,
 				    struct net_device_path *path);
 int br_vlan_fill_forward_path_mode(struct net_bridge *br,
@@ -1753,6 +1754,7 @@ static inline int nbp_get_num_vlan_infos(struct net_bridge_port *p,
 }
 
 static inline void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
+						  struct net_bridge_port *p,
 						  struct net_device_path_ctx *ctx,
 						  struct net_device_path *path)
 {
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index d9a69ec9affe..a18c7da12ebd 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1441,6 +1441,7 @@ int br_vlan_get_pvid_rcu(const struct net_device *dev, u16 *p_pvid)
 EXPORT_SYMBOL_GPL(br_vlan_get_pvid_rcu);
 
 void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
+				    struct net_bridge_port *p,
 				    struct net_device_path_ctx *ctx,
 				    struct net_device_path *path)
 {
@@ -1453,7 +1454,10 @@ void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
 	if (!br_opt_get(br, BROPT_VLAN_ENABLED))
 		return;
 
-	vg = br_vlan_group(br);
+	if (p)
+		vg = nbp_vlan_group_rcu(p);
+	else
+		vg = br_vlan_group_rcu(br);
 
 	if (idx >= 0 &&
 	    ctx->vlan[idx].proto == br->vlan_proto) {
-- 
2.47.1

