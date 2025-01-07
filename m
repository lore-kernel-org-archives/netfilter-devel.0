Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615F11E3DC6;
	Tue,  7 Jan 2025 09:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736240770; cv=none; b=eDDJ+czmzcv04ku/xeZIRF2w8clsegBzvk7YoDh3aAt1E/UZTG5Ogkkh0cDfU3pyJRNbMQiSr8L2bCB1Gb4TFbXQjgs9/tEemlA95L4WMndG8v5QAL4VAiSx5uAlXfXgVGwSgYkInlDBq99qVCGSgsVz6X6j0ePlKCl1v3NlQDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736240770; c=relaxed/simple;
	bh=mCdJorupZbFaQ3ucEHtHHKn4v/RNMnVY9IhyUnZPOss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IR9FeRwH70Z6elSBTVwRJ3EOjIhysKXU4JNCk7/hGMPM+0GbuMl6t8eUTgl0WhoRBlXORNewGAMs031MX2tyhKalzWtwA14JHLlSKpdXfP9CWl2jtyx3KfvivU6AKNZvzWRbyxx6L1IktNANl/KLaipbvz5A3UW4AFSkLZmkH20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dHs5HuCv; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dHs5HuCv"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-aa67333f7d2so2236011266b.0;
        Tue, 07 Jan 2025 01:06:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736240767; x=1736845567; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=inK7YfAKbOx/gvsqH8JrlXFRxeSCmPFOnUoO4T3PkD0=;
        b=dHs5HuCv8s7JFD9zVnl1qkcGjiO0Ks0z2sT/M5EAFcBXt3KqdUk3I8l2lpGJ9Xd2mx
         WwcU0Npu/pXN9Fbjd0c+uupK19vjUJ3nzXQI7+cxbnNxtFql1xzZcTOTh6Ic7q7DXt9b
         3H+avUaSClXMUmaU8NBLAsBakUZOy2qEppANgtZpzrzQOEJ9TKSBKOj/OSzdTkDqAu4a
         di63NxqtauK47iqLa0wUoN/PRrREf6aLjviM5OOkMLU9icVm00nyTlzqMmQ+mjaDfrHc
         +kr0j+8w8ZesSvukQ4rrqhAcohU5XSa7IUwdMoh1NyhTeQwbt30ZetizvPHd7X7P1ISP
         qIVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736240767; x=1736845567;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=inK7YfAKbOx/gvsqH8JrlXFRxeSCmPFOnUoO4T3PkD0=;
        b=Ne3JpDKNEG+5eXn1EpWeeUjgeRe694FHm/McSiImRjx0XDdO5cMaBA++oy5DvJtqWy
         Hd3Vz2Z2bwe+mjRUJDzjbROr3op6GsSH8XLrVBcMWA+KprbGVM6anNE2sP+AqJQxpvn2
         roRiWdK6sHLTfvakWO6IHCXf77sRyWRw0KVmp1XvHYIYt2+PhArl8NgYY6O0mUMqT0LF
         tNIBaEcF0Syv0+kxo9TpbAfTThUmXK1RcDkDTUh7WJTqusyPg3a9lJl/Sy3Rjqf6kENa
         t5CoVuUE1MT+HwzsOz3LjrOjK9iGD6ECnhRDjbw10MZAQQd2Z2n79Jwz0dHT1Y/faYfx
         VyxA==
X-Forwarded-Encrypted: i=1; AJvYcCWm75z7mOAFg8LdvlObk/6WCNHlzDqmR5VNhtlX4KF2blZwVbFhdBNBQ43ja0LTrCAgC15HWEoP/HWRAoc54wNN@vger.kernel.org, AJvYcCXCjsMi6ScHiG+TXrG4MriGGJ3cyrtr0zt70PH3z2DAa654i5HPELSDtSzIW0xw8NArSblZoP1e3r07pWE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlZb9d6uvwkioxmtn0cja2h7DGDGYFBdOB2CJT9rBsB6lYtfAd
	MtwgX5oaSgWzmNLokvMDWcMl2eJwxC0AR3vV1hs8fhbmfMFFySet
X-Gm-Gg: ASbGncv0yiyHFyJ4whjTuEGFq8JlMnW5KnEEoOo/Mt9XcZI4CmmKWCAjNHI70erxbXv
	PTfeFYu0/dJOoz0Y2d4hTb+hzA8wB6R4K4SyLSLeCMGn9FnBdAcWryR4ZrSLJKECqSWmz7ytOgA
	cLBbGP1OO5BB2+loVGnArCNeANy2fbExa9azqfJklO5Z1h1TwSvZ1lf3NqjJQuKqAgRN0YA02GX
	qoDVzKEsXs9E3YpzwD6HcbM+S3+DoeSswjWYs+aGZ9Sr7v2pRQJHKQiZxD8ddGz8eX3chcyz8Wx
	qGOY3LCb2sgoUWewjN+UoAF82kuuTRoYsvtGr3JRqg5iM8UQVKbZlz/Ku+64nhDGTC/R0N0Uog=
	=
X-Google-Smtp-Source: AGHT+IHrdDy9A9gTXFzVem5TTKGvqrwcwaAGIG1kmAOtqGfBDbimoZPMTBSrG7qD5IXkUnDJ5cWKBA==
X-Received: by 2002:a17:907:1c1e:b0:aab:9268:2626 with SMTP id a640c23a62f3a-aac2cf5063fmr6251574966b.25.1736240766425;
        Tue, 07 Jan 2025 01:06:06 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80676f3f9sm24005333a12.23.2025.01.07.01.06.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 01:06:05 -0800 (PST)
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
	David Ahern <dsahern@kernel.org>,
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
Subject: [PATCH v4 net-next 04/13] bridge: Add filling forward path from port to port
Date: Tue,  7 Jan 2025 10:05:21 +0100
Message-ID: <20250107090530.5035-5-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250107090530.5035-1-ericwouds@gmail.com>
References: <20250107090530.5035-1-ericwouds@gmail.com>
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
index 29d6ec45cf41..94603c64fb63 100644
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
index d9a69ec9affe..07dae3655c26 100644
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
+		vg = nbp_vlan_group(p);
+	else
+		vg = br_vlan_group(br);
 
 	if (idx >= 0 &&
 	    ctx->vlan[idx].proto == br->vlan_proto) {
-- 
2.47.1

