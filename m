Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032F94014AB
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2026 09:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783503110; cv=none; b=B4TPPl6cI72xOgBUlppp0dNbaxaCvKLGu1rhyGklQm36ZVX7OW2zKPgy5zsKljpvx5ahnbXBLmPEX2HlTc0FnqCu02N45NiFd8h0Jc2MwJ4sEzWqNSnPi+vJ39a0ju3nz5KebL1qNzr4FkiGEqb3uVVxYCUvZu2aHMv6aTr7XdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783503110; c=relaxed/simple;
	bh=LimfHNhKbzGj41cNpuGnOzVAlvSDxXYFowW8stUMmGo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Mm27IhVSdFqHI1SmqSgpp4plf1LSa4cnJCjmnZ/t1oj+QLYzpb+S6EHAyupPAnY3MbKPi2KmNbrzR1K7ibOAQLEmgXoPPrv+61oDr91Ghaw6fGY/kyCEIglrd8P78clzcaDc0cHYN6df+wZM5kIkvoXiPUSJJm8V5iZ8R8XFT1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rk+tjEBg; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rk+tjEBg"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3A7B3601BC
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2026 11:31:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783503100;
	bh=0mdV7mm6RiiR4cIHSloM9vWmiJg/yyyRgEBQ1G1DsRY=;
	h=From:To:Subject:Date:From;
	b=rk+tjEBgxwbavA+ZD4zLS8KEBiwJMQ+t1HEipB53G25Rk/YPKIsRVnc/Pws8fc79j
	 M6WZHybk607jP/jX0TbcSnTMlq+C+R4EnlsPch6h7Qv6gjeqk1DEcKZonvL9+dpkYi
	 jNIp+55w5akSrMYLEgMAeHoB0TkMM204/ftu5TBydI3yxbPPfVALfSq79ywk4q8l4M
	 GiV7q8vVahoTGBTALrsgcpriI+Lr550WI9q4mlQ/Whl9vYwrQeCXnoBSdgY5CWe2zO
	 4K9Qs60SrXfE6CdyPG9GVaPyLwvVjgv4Zxd+GEHDYvshgCFGrmIhE6JtOTU5eW1N0o
	 /W16gJFtLQ6Vw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v1 1/4] bridge: Add filling forward path from port to port
Date: Wed,  8 Jul 2026 11:31:32 +0200
Message-ID: <20260708093135.1186934-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Woudstra <ericwouds@gmail.com>

If a port is passed as argument instead of the master, then:

At br_fill_forward_path(): find the master and use it to fill the
forward path.

At br_vlan_fill_forward_path_pvid(): lookup vlan group from port
instead.

Changed call to br_vlan_group() into br_vlan_group_rcu() while at it.

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v1: I took this existing patch for the bridge vlan filtering, but
    bridge vlan filtering is untested at this stage at least for me.

 net/bridge/br_device.c  | 19 ++++++++++++++-----
 net/bridge/br_private.h |  2 ++
 net/bridge/br_vlan.c    |  6 +++++-
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index e7f343ab22d3..89f4525a7279 100644
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
index d55ea9516e3e..00f5b72ff42d 100644
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
index 5560afcaaca3..71531499bc73 100644
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
2.47.3

