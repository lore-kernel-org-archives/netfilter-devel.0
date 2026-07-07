Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B481338F934
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jul 2026 09:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783415479; cv=none; b=n2v64Fscs7QLcS9z+3KvgInu2Ydy6frk261tDZgVmlQgRrozgRDTHyYAOa6GkfyIF7NZX0Ajv0TmcKsA5vBvLthj2mhdQamJJPjmD4nI5nrgv8qz00uDmqZjhJUTRHJ+cYLUzllR1nPYsGym2YmcoKsrrJvPuvslPvuv0wVKhFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783415479; c=relaxed/simple;
	bh=/L2CYa/L6Hv5Bh5hGEfPIOCpX6+gefXiQPwWix/MMqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ueQ7bgTDiX+rg+LFETai/IOhoQMdmBhywmsHn9wFzCdfepMijNhcJMGXlE8P3gbVKAPVwKQFQXm3glfh52ITq6ocT/lFMmTNc6LhgYwY6P4kvHSs18ejJ5GoUmoNBQwh5AWNNT8FvLMW9c43T8ezkwzQDUA8CiZ0FEJkB/T/tC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gsYlYzwN; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gsYlYzwN"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-698acd36d67so7047716a12.0
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Jul 2026 02:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783415476; x=1784020276; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sm5HNUD7n1DNF0D2zqXw/bbAWgUYwja5myfoUO3KdJU=;
        b=gsYlYzwNbiFLUFoT7nfoaLQRF7SpmI72dubcq47BzbEmCJkepGVRZhK5SvZ+0aQT8E
         uT27FvRLIjF7ahFUDGdlnkSjX1usyPbTQgqHI0oHLyGZpn2xDgtzoSwH2cr1hZ1l12X6
         kc5EPSxKiLwMvzajgdbAykHAa4lkNOWUApxMuwh6WYQ1KB7ziONBMBeJUB4gyUbbcw1G
         zuk1O4tj2DlrIUDuGfUK7/9Vx5EDy8+J16cdJFS6FWiOq/RsxZrG/vAx3nYtzX+DGEgT
         Fb17QXioeYC9nwlN9JAfuSviEodvUIOe2YcKEwiGe25vVd29tKS8mM6GgUuA3hS35wjG
         mtgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783415476; x=1784020276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Sm5HNUD7n1DNF0D2zqXw/bbAWgUYwja5myfoUO3KdJU=;
        b=PUN+TD3UC96yTOng+w7LVYmJZUKhOvu1cP6KsgUrzc1iHyno4G4Kpan1ImhQr8Y/er
         49yg/aUO+in+5EX5rqm1YC21sHF3tY1fYVbxGn4UmCCAejeLJ15bCh34AxO8TnDw/V6D
         v6ergP9IZVktgMX6jTNFyAh9GtzvzZX2hfx+3CbbfMuXR+yqQz3ANmZ8TgjFKJch9pFy
         XOZ37iCRNHi34CxsXeWbzdlYE+wwW0tyGl/DC7ugXOeqmHI9Ss+VN6hNXjHwUfL2OArI
         XO6AupVJb8brROeunRjUTOjvR0ckp3nKSrIKY0RPuR1Cv+W0mYLXOZyMsx2upCNyzyYo
         zIqg==
X-Forwarded-Encrypted: i=1; AHgh+RoLY2wuMyw/JmQadTZCTVSx+KR90TNJlD2THcSo/QEnyv4B5MfjHq8as7AbUcm+BtBg5n7q/+eCFarLdW4b6Zc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlxDwyYHYBk2DuLtVSKnJpNYHQiN0gjsRiZU554x3e2FZg0QQp
	0V10TxV+bQpG1LbXH5E/sw4SfcbMInNsstA6UW4SN9BEf6+eCWTgTzWr
X-Gm-Gg: AfdE7cl0djWaVYtVczUFiq1KlZv1QvXXM1doPg9ZrOO0hwYBazMjOJ5UicHuprfcroI
	lSzhASCtFhz2jPr2QU4RMw2fL8Uc9p0yz1UhogvJIpby1qfGVkXpuQflesNS21CRSl5YNshz6GP
	H5bSWQdEBn9tYqnUv60hBXdnZ2hseUD0Iih1PHLbdQD4kqqpaKn36ofXsGoS/iZqOJbUKnlLHtt
	kJF5tWi7Vj5+4zwkUf64moOWXIh5mW1ejvZGbdBB0Jx9VKKnApZXagZel0xIgTE8PZWLGtNxNZs
	qKXPD3uFRVB0cT3+gEEbD2sw0HMxeVcZGA3bjl2F40akcAER0xMhtdEr+bjOFhJO/hB2aux4tdL
	fS1iRvtIVdp5u7lLVWnpi568vbdDUPwQEZ8t0qSEVUewukjz3z8P1GrcIBME0TuTpekYWutv9Ev
	qgsdSQEFHVmaekR7uQTkvzXZLFyPF+KYYi8mALWc/z0/4QggzLxJ3qpu2QmnMeo/gRPd9mnmX9B
	0E+GCOz3XnAdvC/+GgvNbfkOFKmDU/Qi1eoerFgQVBB
X-Received: by 2002:a05:6402:13d0:b0:69a:9fbe:5cbf with SMTP id 4fb4d7f45d1cf-69a9fbe5d6cmr180598a12.6.1783415475927;
        Tue, 07 Jul 2026 02:11:15 -0700 (PDT)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69a19cd87d6sm5297152a12.6.2026.07.07.02.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 02:11:15 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Stanislav Fomichev <sdf.kernel@gmail.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Krishna Kumar <krikku@gmail.com>,
	Martin Karsten <mkarsten@uwaterloo.ca>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v12 nf-next 1/7] bridge: Add filling forward path from port to port
Date: Tue,  7 Jul 2026 11:10:39 +0200
Message-ID: <20260707091045.967678-2-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260707091045.967678-1-ericwouds@gmail.com>
References: <20260707091045.967678-1-ericwouds@gmail.com>
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
index 3b9fc86293fdb..56fc80d2f5215 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -385,16 +385,25 @@ static int br_del_slave(struct net_device *dev, struct net_device *slave_dev)
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
index d55ea9516e3e3..00f5b72ff42de 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1630,6 +1630,7 @@ bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
 			     const struct net_bridge_vlan *range_end);
 
 void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
+				    struct net_bridge_port *p,
 				    struct net_device_path_ctx *ctx,
 				    struct net_device_path *path);
 int br_vlan_fill_forward_path_mode(struct net_bridge *br,
@@ -1799,6 +1800,7 @@ static inline int nbp_get_num_vlan_infos(struct net_bridge_port *p,
 }
 
 static inline void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
+						  struct net_bridge_port *p,
 						  struct net_device_path_ctx *ctx,
 						  struct net_device_path *path)
 {
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index a248ce70f919f..f4a82e107ec7d 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1450,6 +1450,7 @@ int br_vlan_get_pvid_rcu(const struct net_device *dev, u16 *p_pvid)
 EXPORT_SYMBOL_GPL(br_vlan_get_pvid_rcu);
 
 void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
+				    struct net_bridge_port *p,
 				    struct net_device_path_ctx *ctx,
 				    struct net_device_path *path)
 {
@@ -1462,7 +1463,10 @@ void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
 	if (!br_opt_get(br, BROPT_VLAN_ENABLED))
 		return;
 
-	vg = br_vlan_group_rcu(br);
+	if (p)
+		vg = nbp_vlan_group_rcu(p);
+	else
+		vg = br_vlan_group_rcu(br);
 
 	if (idx >= 0 &&
 	    ctx->vlan[idx].proto == br->vlan_proto) {
-- 
2.53.0

