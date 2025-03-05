Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127B120ADD6;
	Wed,  5 Mar 2025 10:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741170615; cv=none; b=Ue7D6E9RyQ5PColDmT9FBM/cgpXZjMVgEmCj4d/nXq1d98e2iU1gbleiuZFW8POIzx7EFjriw2LfwKvfYanhEOSiheXMNCnnwjA1ugoZ5eKbNDEdBPelJlLf8OrXAXP6yrqa2nAjyGFLVloiM/qEzeSFQguU13JUBv/4JkOyGz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741170615; c=relaxed/simple;
	bh=xttbzI/pcl6SYlB7PpU+GQoyrB/QS5WPo8yeg4iagTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qh5i6sOxLX/iaohZF83yju0UVpc50JmJ4c9y6O2pt/skuNF54bSRe1Egae7ePEQe/RlEukTltkl7GEP1FbjY4UHhtSKDQVnoONrURkLl2NRMZ9lqdnoIqlECmGteae1pP2QAQ5PG97v/UxHAPeNwmLP5q2e/24CyfKKj8WI024c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TGCIzTYt; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TGCIzTYt"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-abf4cebb04dso136781866b.0;
        Wed, 05 Mar 2025 02:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741170611; x=1741775411; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IM1kXQjhThZXDzCIWTKLQoY0aGhS2pSnBiHrFmA8ll0=;
        b=TGCIzTYtoaxsCbjgmBnyu7JTj0nVY1LIPxobfQ5wQeh/LXSmxC9H8XZQYN/Kdp4eUe
         STJlX0ASxg5XNIZ6wJYRdDUK8fZcEI64Z599Ew7kerRL2HDBimBmvopcnboLRBQqT2+w
         EW+rR0u1HulZ+Vb0ctAO75sCDW/k1VA6FYn+j4spuK0jy30SAG5LGlImFTiPAobEM94U
         ySdUNIKRPlCEKxYMhe1F5QvdW6XZjbKDXul5eRMKwiYb9HYeKghZPRkRzZLzYLVHdqCc
         9VZUlZ7ckPqdDBbnoUgJsVWpUYXK9du0gVK/0CVr/y3Xnl6/N5mN46f+hMkCMFn6UaWK
         AP3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741170611; x=1741775411;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IM1kXQjhThZXDzCIWTKLQoY0aGhS2pSnBiHrFmA8ll0=;
        b=Ua9p9ctDtwtST/tIczuWPMcCP2bRwcZtgQijBsGqEAVeoBE7E9F9Uji9iDN0HLtjQv
         oNytaRjUWcn/rRbOMLSM79qoF/BNfXT3rACOmlEEpZJPVb344+hnW1i6iajlCrmWvGZF
         m2TuO+vcUyVXTFdux0LZIB+ydtL9XHpq3RXGW1uqazUD6Yo/WcP7j+26y3hnjqxMlHlu
         Rgrb2NKPCQiQNinYhYys0gfg6Wr7BbdRCHmUf+4/D/sZqz3MuvZ4WozmDw44omuxAVS9
         Y7Wb5eWO+1IdMZyatzMRLDz2bM4w9vWi0NwPmIAS+Hrxwim4qDHI5RkmIubgajt3QO6M
         EMZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVffYqc5PhXFXmkZAqHgLlIJvEdF86bdslcLaIKROZFdhBqy0YX3RyAhPgVf5xPQWkWb9MNaWeJbKrmkLiK@vger.kernel.org, AJvYcCXdrTHtzZFL0fP99PF2FfgVKLR8lPmLoN9Tj0T967DiVLPMU2PL5dvjr4Z+LRQQ6dK3W8V8IIiBfSAISeD3XMH1@vger.kernel.org, AJvYcCXnvMLXqDhaxV3XigSqoDEuFXiECfCgOz7keIg1Ha9Y840pE/F4VJQugbo1UEyBPDJ5zMQzZIGed9cDy9YVtGI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzM3zHwp1xof6/4LAz2hvD88zG7y6NkTzGBdnl1wpEqQCzhuy46
	RagqjxihIM7bBt7Rdgk8EH6eyaNACaujTKDMYbOOzOOHokhOumuB
X-Gm-Gg: ASbGncvr7vX5GUqneVHH1+CCTS7DhHG4qHDBs5yOAfxM5gaHCIZal+zcQge37JopDzG
	K7NgT5m9bWPUzJkAh71maf0Dkrmioc7NNCCXaj2ga0GQmqh5/9R+WATurFXA4eVAGrDg96I/12L
	055gDO34RaXljQf6Kxu3xGR2b+xaqH5+cX8fHr7WPISos80cCxHIwwl1qGbEGGk15/cneA1C31R
	a7b3PwwnaxuHwRByRuNaEhIBETNqevBRqCEGTOoxBFffROnIYoTZg3LtMWWEdyfkVdJh6G3vfAU
	DbqCO/tT529/WBaFbDHTQWLuV/pe/Yw78zxoVdvKco4kfDue2SxZnfMuvX7OBxiq3Z4OXSN47A7
	sKffwUlTM0S2brMb4Gyqquh3CXkRgtO1QFDBWk4h4HlKa9lStWwq1qBAt28NZ6A==
X-Google-Smtp-Source: AGHT+IGUiR/Ewb64RsvjGNeJXBn0Ed+9S8empXfVW8h4ZmJBkjiI9NUn/Px8AChfgHjCFcCWMHNHpA==
X-Received: by 2002:a17:907:3f9c:b0:ac1:e08c:6ac8 with SMTP id a640c23a62f3a-ac20ecf947emr220727966b.2.1741170610822;
        Wed, 05 Mar 2025 02:30:10 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1f7161a4esm247154266b.161.2025.03.05.02.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 02:30:10 -0800 (PST)
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
Subject: [PATCH v9 nf 06/15] bridge: Add filling forward path from port to port
Date: Wed,  5 Mar 2025 11:29:40 +0100
Message-ID: <20250305102949.16370-7-ericwouds@gmail.com>
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
index 9d8c72ed01ab..02eb23e8aab8 100644
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

