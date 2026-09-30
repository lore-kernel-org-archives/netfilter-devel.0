Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3855536C9C2
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Sep 2026 07:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790752527; cv=none; b=mUKQ+tKhTK9avuTbbYOfNpShGWbxg08pl14dsBbM4jRCGNXeI5dKdbX69NfwEAxIbmY5TbcLE0GHYQ+nA55sDghIvcxOVIl3q42ApMxabM9RagyHitr36WenXc4FkWsnG+rBocyJWj9jMrGvL9z+HWTw12ZdHAPCpYO06v87pcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790752527; c=relaxed/simple;
	bh=WIiBr5bXsxi0pX8HHboy6Z61IAOe1DKM67g84NTls3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q74X16mN/U5znGpHcZSuB7UPky6ySMtt5E20x28+Q+ynUoec+irsRYvWgMNqWxgtdL3Gzpcy64uZ/tTpcEEGDPGUVn0Kpk2rvII8IalPqEYmgZ0xMYXA8hKCZYz4dbCPgbkj0R9zASObuG4v1pZVf+9C+V0JZwRay6hb7Gb9cBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org; spf=none smtp.mailfrom=blackwall.org; dkim=pass (2048-bit key) header.d=blackwall.org header.i=@blackwall.org header.b=htqSM99g; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=blackwall.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blackwall.org header.i=@blackwall.org header.b="htqSM99g"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-48434392b02so4316836f8f.3
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Sep 2026 00:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall.org; s=google; t=1790752517; x=1791357317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lIXruVrGG+7vDbzLUe/m+K5H/JkVnzugw/hOkZ38lPA=;
        b=htqSM99giKBwWlRz0gI/1Srb8jObSirmtwsaa+P8wajGEWYdk1LrpU1FXRclXoasMG
         pMnQJpGFM5q1eUdSMMCfMWSaegMQ0MrhegJYpVpshcdgLNizdgj3U+QpyP0/6XK5i5GL
         zBDHLyTlNjqKLhJ3BzF8ctRPUy1VEIYk+cS4d07QrJGLVh9htYn44Zu4gdyAKu65Oyg9
         oH2M0/XevypsS4jNQWTh53IBSD9nIG+BZg9wGof0tZDV6VKIuIq7LdvEJqb83YLq+vB3
         Ow2YMZvXXOX1BudUYcV4My/xCNyFB8qld4k7OGJYbOSUjnzbBox0kYh61WveLNqqPzKO
         Wpkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790752517; x=1791357317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lIXruVrGG+7vDbzLUe/m+K5H/JkVnzugw/hOkZ38lPA=;
        b=uSIv/HioBeiSvR0V06g6QQuSIhWDta2Py+aAVN9fjXx6+kVd9hbOgnN2ZEhvj1i2or
         4XS0JZ6DY5QFKybMVy+pJpP8wzsnUEcAo/Tgbcw+rDDvhNuShg+hgQkTMQlXERf+idrt
         uoOzzQpncO/11L6IsUAqS8SSa3UY2SaJ9Rb2rR//w/gfytewomjX3mX+u3Z/FpA3/c8q
         kjWRNm9BiCg4njUaZ38QVS1nQL2yXfbeeivBdnNjAvbFAQeM3Z2dDWJg2SZPxswiPMnc
         uaYw3x5nLq9/iCt1XLD3i5pN/iReOr4zsV9G3dcb3c3krYOfowVn9QeRAZgDnFqnIjTI
         FB6Q==
X-Forwarded-Encrypted: i=1; AKwUvBwy2PZbbJJbV7bJU+pS4ZNpr/dyOu6m5C3bluNR/LDTuc8JpCjNV8/SAueETpP+U2kUu9Hx8NKE111bNWjFgPs=@vger.kernel.org
X-Gm-Message-State: AFq9FYLZREdi5PiembYP7QCZI1Od/FsgKglewn4x6awsmDepelOUmxoL
	EPdFX48pHxiOz+JGh/npqyeVJo5UOd0yjk1I7lujPPFTb+yT1Ki+NCHXgVBA3DPa9Ww=
X-Gm-Gg: AYBFou0OmhE5/tv8iO3F25Si/B8LKXCGAT3TDDQN2lHlMd6SBkzKVRpEItL/7KE+YXs
	KS+KJeHHDYkjiqfmlTtiYJ+n52STmGI4sQArsHcA9sb6/eQ7bKinsYwld3BWXyBsxU1m+u/gFwY
	V3vg/v0OTyt97da3Rf8GNKcd4AWt4BuC46Ev1UeYYvW93k0nZJUgEuhdpmv+65W01IlKkt4SPvi
	ykEBOYwCuzRqHl64BJeLD6oMunVkXmQ/OdzjQtOS9HxYV6pPcT4vjCGgVZzcBuuYuPtoF5uUZ/R
	q5utpSpuzhjlZy9Dhoq2x6jC3elALUh/NcSdbbxLgI2R5DI8diNWMVAnxU0qfupgN93ke0TVXIz
	Ks1/zPRS6yxb7IlrdCK33BZIkS2Nx5SM8CXRQiwFxRskh5Mu0eNaO3kJoto5Au09ihzRRm95fpC
	uZYD9PhQpH1y1sy0MzrCdipiRfzkc+FnCWrjoX62W56sgYVM0jBelZFZCMojvbjeyogOnQXZVgO
	8KbLQ==
X-Received: by 2002:a05:6000:40ca:b0:48a:fcd6:f351 with SMTP id ffacd0b85a97d-48b024ea176mr960058f8f.20.1790752516653;
        Wed, 30 Sep 2026 00:15:16 -0700 (PDT)
Received: from localhost (78-154-14-127.ip.btc-net.bg. [78.154.14.127])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-48b02a0d237sm1089481f8f.37.2026.09.30.00.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 00:15:15 -0700 (PDT)
From: Nikolay Aleksandrov <razor@blackwall.org>
To: netdev@vger.kernel.org
Cc: idosch@nvidia.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	bridge@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [PATCH net-next 12/12] net: bridge: fdb: avoid VLAN lookups in unicast forwarding
Date: Wed, 30 Sep 2026 10:14:11 +0300
Message-ID: <20260930071411.2786201-13-razor@blackwall.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260930071411.2786201-1-razor@blackwall.org>
References: <20260930071411.2786201-1-razor@blackwall.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pass the complete fdb destination to br_forward(). The tagged value is
decoded once into br_fwd_dst on entry so all subsequent forwarding checks
use the decoded port and VLAN. A cached port-VLAN is then used to avoid two
VLAN hash lookups in the standard unicast forwarding path. A backup-port
redirect also uses a raw destination because the cached VLAN belongs to the
original port.

[1] 64 byte vlan packets, 4k randomized fdb hits with 4k fdbs, 5 million
    packets passed 5 times for every case
 VIDs  Ports       Mpps                 Gbps             CPU1 cycles/input
                before    after   gain  before   after   before   after  reduction
   64    8/2  2.375486 2.635811  11.0%   1.216   1.350   1724.6  1553.7    9.9%
   64    8/4  2.376731 2.636459  10.9%   1.217   1.350   1714.8  1554.7    9.3%
   64    8/8  2.376621 2.635783  10.9%   1.217   1.350   1722.6  1553.2    9.8%
   64   32/2  2.375876 2.637897  11.0%   1.216   1.351   1726.7  1552.3   10.1%
   64  32/16  2.376442 2.636426  10.9%   1.217   1.350   1721.3  1554.2    9.7%
   64  32/32  2.376763 2.636268  10.9%   1.217   1.350   1726.8  1553.5   10.0%
   64   64/2  2.375678 2.638707  11.1%   1.216   1.351   1725.0  1552.1   10.0%
   64  64/32  2.376681 2.637359  11.0%   1.217   1.350   1725.1  1555.9    9.8%
   64  64/64  2.376787 2.638396  11.0%   1.217   1.351   1722.8  1550.9   10.0%
 1024    8/2  2.263768 2.498881  10.4%   1.159   1.279   1808.5  1637.1    9.5%
 1024    8/4  2.264519 2.499075  10.4%   1.159   1.280   1807.6  1638.8    9.3%
 1024    8/8  2.263551 2.499231  10.4%   1.159   1.280   1812.0  1640.2    9.5%
 1024   32/2  2.263841 2.499120  10.4%   1.159   1.280   1806.8  1639.6    9.3%
 1024  32/16  2.263990 2.499562  10.4%   1.159   1.280   1806.1  1639.2    9.2%
 1024  32/32  2.263719 2.498905  10.4%   1.159   1.279   1807.7  1639.3    9.3%
 1024   64/2  2.263635 2.501889  10.5%   1.159   1.281   1809.4  1635.6    9.6%
 1024  64/32  2.264467 2.500359  10.4%   1.159   1.280   1806.5  1633.0    9.6%
 1024  64/64  2.240494 2.470246  10.3%   1.147   1.265   1810.0  1637.1    9.6%

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
CC: Pablo Neira Ayuso <pablo@netfilter.org>
CC: Florian Westphal <fw@strlen.de>
CC: Phil Sutter <phil@nwl.cc>
CC: netfilter-devel@vger.kernel.org
CC: coreteam@netfilter.org

 net/bridge/br_device.c                   |  2 +-
 net/bridge/br_forward.c                  | 24 +++++++++++++-----------
 net/bridge/br_input.c                    |  2 +-
 net/bridge/br_mrp.c                      |  6 +++---
 net/bridge/br_private.h                  |  2 +-
 net/bridge/netfilter/nft_reject_bridge.c |  8 ++++----
 6 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 2423d69f2498..0a1ce9e59a4d 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -108,7 +108,7 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 		else
 			br_flood(br, vlan, skb, BR_PKT_MULTICAST, false, true);
 	} else if ((dst = br_fdb_find_rcu(br, dest, vid)) != NULL) {
-		br_forward(br_fdb_dst_port(dst), skb, false, true);
+		br_forward(br_fdb_dst_read(dst), skb, false, true);
 	} else {
 		br_flood(br, vlan, skb, BR_PKT_UNICAST, false, true);
 	}
diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index b5eece1ff9e8..82645db32efb 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -17,7 +17,7 @@
 #include "br_private.h"
 
 struct br_fwd_dst {
-	const struct net_bridge_port *port;
+	struct net_bridge_port *port;
 	struct net_bridge_vlan *vlan;
 };
 
@@ -149,35 +149,37 @@ static int deliver_clone(const struct br_fwd_dst *fwd,
 
 /**
  * br_forward - forward a packet to a specific port
- * @to: destination port
+ * @dst: bridge destination
  * @skb: packet being forwarded
  * @local_rcv: packet will be received locally after forwarding
  * @local_orig: packet is locally originated
  *
  * Should be called with rcu_read_lock.
  */
-void br_forward(const struct net_bridge_port *to,
+void br_forward(struct net_bridge_dst dst,
 		struct sk_buff *skb, bool local_rcv, bool local_orig)
 {
 	struct br_fwd_dst fwd;
 
-	if (unlikely(!to))
+	br_dst_decode(dst, &fwd.port, &fwd.vlan);
+
+	if (unlikely(!fwd.port))
 		goto out;
 
 	/* redirect to backup link if the destination port is down */
-	if (rcu_access_pointer(to->backup_port) &&
-	    (!netif_carrier_ok(to->dev) || !netif_running(to->dev))) {
+	if (rcu_access_pointer(fwd.port->backup_port) &&
+	    (!netif_carrier_ok(fwd.port->dev) ||
+	     !netif_running(fwd.port->dev))) {
 		struct net_bridge_port *backup_port;
 
-		backup_port = rcu_dereference(to->backup_port);
+		backup_port = rcu_dereference(fwd.port->backup_port);
 		if (unlikely(!backup_port))
 			goto out;
-		BR_INPUT_SKB_CB(skb)->backup_nhid = READ_ONCE(to->backup_nhid);
-		to = backup_port;
+		BR_INPUT_SKB_CB(skb)->backup_nhid = READ_ONCE(fwd.port->backup_nhid);
+		fwd.port = backup_port;
+		fwd.vlan = NULL;
 	}
 
-	fwd.port = to;
-	fwd.vlan = NULL;
 	if (should_deliver(&fwd, skb)) {
 		if (local_rcv)
 			deliver_clone(&fwd, skb, local_orig);
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 44a217d65e7f..fc2e381c4fe0 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -225,7 +225,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 
 		if (now != READ_ONCE(dst->used))
 			WRITE_ONCE(dst->used, now);
-		br_forward(br_fdb_dst_port(dst), skb, local_rcv, false);
+		br_forward(br_fdb_dst_read(dst), skb, local_rcv, false);
 	} else {
 		if (!mcast_hit)
 			br_flood(br, vlan, skb, pkt_type, local_rcv, false);
diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
index dce6efa96c4c..c8cd5b4f3af8 100644
--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -1219,11 +1219,11 @@ static int br_mrp_rcv(struct net_bridge_port *p,
 
 forward:
 	if (p_dst)
-		br_forward(p_dst, skb, true, false);
+		br_forward(br_port_to_dst(p_dst), skb, true, false);
 	if (s_dst)
-		br_forward(s_dst, skb, true, false);
+		br_forward(br_port_to_dst(s_dst), skb, true, false);
 	if (i_dst)
-		br_forward(i_dst, skb, true, false);
+		br_forward(br_port_to_dst(i_dst), skb, true, false);
 
 no_forward:
 	return 1;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index a1c5b1abc1ef..05921192ebda 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1045,7 +1045,7 @@ enum br_pkt_type {
 	BR_PKT_BROADCAST
 };
 int br_dev_queue_push_xmit(struct net *net, struct sock *sk, struct sk_buff *skb);
-void br_forward(const struct net_bridge_port *to, struct sk_buff *skb,
+void br_forward(struct net_bridge_dst dst, struct sk_buff *skb,
 		bool local_rcv, bool local_orig);
 int br_forward_finish(struct net *net, struct sock *sk, struct sk_buff *skb);
 void br_flood(struct net_bridge *br, struct net_bridge_vlan *v,
diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index cd2b04236a99..92b488793914 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -55,7 +55,7 @@ static void nft_reject_br_send_v4_tcp_reset(struct net *net,
 
 	nft_reject_br_push_etherhdr(oldskb, nskb);
 
-	br_forward(br_port_get_rcu(dev), nskb, false, true);
+	br_forward(br_port_to_dst(br_port_get_rcu(dev)), nskb, false, true);
 }
 
 static void nft_reject_br_send_v4_unreach(struct net *net,
@@ -71,7 +71,7 @@ static void nft_reject_br_send_v4_unreach(struct net *net,
 
 	nft_reject_br_push_etherhdr(oldskb, nskb);
 
-	br_forward(br_port_get_rcu(dev), nskb, false, true);
+	br_forward(br_port_to_dst(br_port_get_rcu(dev)), nskb, false, true);
 }
 
 static void nft_reject_br_send_v6_tcp_reset(struct net *net,
@@ -87,7 +87,7 @@ static void nft_reject_br_send_v6_tcp_reset(struct net *net,
 
 	nft_reject_br_push_etherhdr(oldskb, nskb);
 
-	br_forward(br_port_get_rcu(dev), nskb, false, true);
+	br_forward(br_port_to_dst(br_port_get_rcu(dev)), nskb, false, true);
 }
 
 
@@ -104,7 +104,7 @@ static void nft_reject_br_send_v6_unreach(struct net *net,
 
 	nft_reject_br_push_etherhdr(oldskb, nskb);
 
-	br_forward(br_port_get_rcu(dev), nskb, false, true);
+	br_forward(br_port_to_dst(br_port_get_rcu(dev)), nskb, false, true);
 }
 
 static void nft_reject_bridge_eval(const struct nft_expr *expr,
-- 
2.47.3

