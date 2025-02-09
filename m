Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F96A1B415A;
	Sun,  9 Feb 2025 11:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739099454; cv=none; b=n/DJVEXPwtYasHE/yKRiSn5DgX4siBIXm+cBKnsmu158l1UTq/NuW+Te5lkzGIa+pIEA35pGp6DTnVuxsVhaEfQX4GmjqkZsWHNIK4LruPwgEQNrTgnbp6Wxd4+OQSw0bEbPOYPS72VFMBqR+bS/Zl2IVJeKWmm7pUuJ1D4fk3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739099454; c=relaxed/simple;
	bh=oDg0CWzMV9qkL+Ci3hmfiS7ejFTJ/cSsU5uRIUUNHBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFC/flyTOiwez4DpFMknCjYgITbRDXqQc6QO4m6sIn7ju3qQoYxWDuNF9Q/8g5+6Z9poJJdrYaCbPoHdYo7vnCwPj2RAtfUOReqjHcd0WVTBSc03sdO6oJDWcuSmDxZEfrrlp6x6oobfuJu5RdbE23ayxC/O73GRa/t2Xxp2XuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B50+NtBo; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B50+NtBo"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5de4d4adac9so3861348a12.3;
        Sun, 09 Feb 2025 03:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739099451; x=1739704251; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u4xHwXg6EmPjQs4unBR1swhwZyfltEqvFEeKEtV+1dA=;
        b=B50+NtBoBXhjFcHLMWtsUU8JF0S0CjcU/4nVGzARFFE4KF93eK4vzichroI1Je2/nc
         N95hefYqvXDfJ8VBR0MRBC7rDQlzb0m6GhLRbhSLbErVIQVX+/wMpThXBDHitbIHfa2y
         XSSbR62TheVDNVBT6Bj0UW8Omoc9K1qJhPeviC8b44Bz+Ffr568w5x7giixvSG8/yADz
         Hqo9jpqCoN653pJUjtr7woVTQQbrCA4OkpBg8b2cy9kOEhnoo+pmu2fKW4KxMpyVFNpl
         rV0Ay9btgT1CvSMse5u0b7BqDoJHQSijQWikzArSce1n7BTwdivlb4eicIuw/XHOv6zR
         faQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739099451; x=1739704251;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u4xHwXg6EmPjQs4unBR1swhwZyfltEqvFEeKEtV+1dA=;
        b=EmvfJHu71NxF9MHJUIm8tK044nmD+X8Pn5IKGawKy8F/TN3etsxtCV8cVakU0TAWqO
         3dXju6tYI7yCpU/NhWN0OWCpK6wa1VzrZblxzkkfRqK/inPlvSoj9LgS8Qjwkn94uT9u
         sbeCjSWniTkclgCXGDe0IoZusFQ851rOjZX/7dWsyOEhugK/RnsLT1snACDm0SBvsxT/
         vjJGuWgfXTgnEd5uWVzrOenG7d4IS1tFIU3YCVx/xEHGULUQ9yF7OkTaX2+xj7+vwANk
         UzExpFOSlM+gsF25/s7EdzppbgiTWo1xG5nszOVx7zfsOqJL16NHM1f9khIY3jgHYpYu
         GIzg==
X-Forwarded-Encrypted: i=1; AJvYcCUonKZ/Qo1g7ir/rLsM4QTFCE1u6KHDe5ZJJYw4V2CPIBdlsRk0omkVcuJlIYAmA91wbJo9tcQNIRHw/0R9GTvp@vger.kernel.org, AJvYcCVXXR/Qw6unHFfNWOk1BatFaQM+I3WKUxTN1chNGGcLN2c5gpiBf86s8+RMwD1Dd5IGyl6chf4pOWVUdoQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx647BwCU7mdPpAFRT8Cc8iGou4hJ5ptjmP0NMxqn8xOWf2JJvy
	7w5QXnCC5y2ST2fCS/4rHsZ2XfZiIukTnZyCTYSNNoM1x1cPY2Oo
X-Gm-Gg: ASbGnctNUbC3cLR5tKGmNK/08BICIdDEl1hBIuuk0P9WnQ91/tnWJ+AhQ8mM4WoG8gT
	N/sLWGmx6PhrzAeunQUzoE6zCHgfKSw4b7sndCGBYnhy3b0arSrqC4wg0pFS+hNLGFotfqYS01B
	VMwy9O6WK1DRm7xBF3TTX2TMVxBdQ9R9mp5bkhYXMmfzHnGG5YuVdqd6NZWPKxg4BRLmQfvsEMx
	Dd+re3MPRhYEbXuUrSN9jwYQftdb+0hg0xlobBJ/mNC5Jt5bss5mzQYaqdYjuNw8WkrtUVND3E0
	mNITiH0WbO9Kt7xlUSxoW20HWc4fiBhp1z27npkQmeHn8e3CZBgwBV0D785M+ZcLN42bEbBQxoW
	wQkCtA4h8df5Qfdx+TTRJtyy/xAP7fbZb
X-Google-Smtp-Source: AGHT+IGqAcPNkOC3T2w/JTV+drwdUFB600X7DdmAkY02Ru++v+0yQjzJWGShHhhfTBkgM87Q9bKjbw==
X-Received: by 2002:a17:907:3da4:b0:ab7:b422:c075 with SMTP id a640c23a62f3a-ab7b422d13fmr154639366b.23.1739099451247;
        Sun, 09 Feb 2025 03:10:51 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab79afc7452sm357516366b.163.2025.02.09.03.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2025 03:10:50 -0800 (PST)
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
Subject: [PATCH v6 net-next 05/14] bridge: Add filling forward path from port to port
Date: Sun,  9 Feb 2025 12:10:25 +0100
Message-ID: <20250209111034.241571-6-ericwouds@gmail.com>
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

If a port is passed as argument instead of the master, then:

At br_fill_forward_path(): find the master and use it to fill the
forward path.

At br_vlan_fill_forward_path_pvid(): lookup vlan group from port
instead.

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

