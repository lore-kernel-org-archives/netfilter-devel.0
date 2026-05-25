Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285F2305689
	for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2026 16:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779726273; cv=none; b=TuQrAcGxoofR9h5PH88swtLy2PQr7hEO0Ip7vQG1z1bqiEg1NLo0KMnQjIwZI/e7NSws3enHXClIuVxzE3q/TBQW0PfV8/aPKn5AufuXNR8ueYXk0BUditcpv0TGA0c8Plao8JWn/dt0msSOrTfF51I54v3SZmPJFqZJZTvtxeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779726273; c=relaxed/simple;
	bh=XkMKBuU5V+3BeDo+GJTT4o5X9ZU0iua6PXBxHBn8K9I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xb1GDC4vYu9NajrlKtTZVroqeud+S66Bz3Y2uS6KykjlaHuO+l/yHwA4ocJnqZzJDHh6S06iQ6+A5buslBBQomhFmr71yp4kXtoSQjQW1J45cyD4Ha0mWDZUwg/aDk9oavywSqGsxG4JtHLdOj9KpHrJ79EmG25ggpUvvGpXMFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UH/z8CzJ; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UH/z8CzJ"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3664df30f53so5763035a91.1
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2026 09:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779726271; x=1780331071; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZlpsTDeAuSNftCXZpxo4u072eQxRXT55x77vQlFxgZI=;
        b=UH/z8CzJhqjyChSFwscjLIJbp1tty3KBnArLhWIN+/aOZntCRBNWYlSo20Wdg72sG2
         1wkhT2kT8eBDD/OOFDvKSMaQFCARRTx2SMI8CuuF6qNKAPf1uik6dxNZr67jfPUh6nz5
         boQDqgtlSt7xyCIrKZg2NGSj38OIuIIz1lmxoW61sCB52RH1A8fKzwaE9vqbbuqNfSC3
         LTlsJ8HeAQxpwQdWjFMy34l/7PU/RC6HV0oYd2UjkPWNdDfl/diNipM4QHUW8gcXI4Ru
         YAS+xW1eZTA5fC2A76l50R5gpAVUzcogRYIgngjycInrXvC6dei3ETx+3Ou6ZKiBawr1
         MCbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779726271; x=1780331071;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZlpsTDeAuSNftCXZpxo4u072eQxRXT55x77vQlFxgZI=;
        b=q/+Pz+R6TCfu5uD540hq+G+3fkxqPzii3IuyfnsMkfOPEVwzsw7NPtmrTyuZFy57AU
         ZCm4n42DQgl6b8pCTbuMsrlpIaz7RJVla+M9xyBgFp4HPxQnqlWWboGHlaWnmPjUfQ+M
         fq+7EdesFknGxViYttLEisbjVODG0LcccTx7vZVot60HeSVbn/Bov8fag3rRAj8rzQo7
         VDUdP8DhN6qDe2L0r2bJm+UlVyLw4z4CCAIaoQG3HMsFKrKZrlzhKQhEKa8xLEW54XlN
         lBn7++sgO/vbsY9EkbSYY2GWd/LRK9QGCbvIDt1occ7VNyXI8IZPc/QVliaTboMHU97u
         0xuQ==
X-Forwarded-Encrypted: i=1; AFNElJ9eolYFEqSaWtEsgDQRf1eftIdl4tYZtiqSK2mFo/0jxU5CPq7nNQfpwWNvBj3A0xsB+JAsWW9WQjFEwi/GlW4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmbBQM7208reSW/UJFBW3IsCxzCqpyMilpW015mY+1thRMPVST
	V7rvd0f2H1mC7oWtkzZmIUlkuwkaVxUgthLXdMR6n9pkeTi9DKYPcFu0
X-Gm-Gg: Acq92OEZIPc9WDNmASgWYrBYQ8wm6+giLok46XECd6ceAhosa9c6usGYVpG4Im3nDu6
	fctgTwr6y8/qtH8mmaxR5mQ9RMzOiUMDqejDeoqvJrOmQ9iZsahmEsaHoMikyWCy1k+dcTANNmM
	S/vlN9DW874OHCMAzWn+mKARYn2+v+yt8+8TfiA+GdeU4LYsW/WGxXKDOUeHY7HA4j8cjlACjRv
	EzftWlrwjHfgreo7rbDV3+GT7VEnzH1ypbhw3i0D0TKEbbH+YwYjsPKM9JTGV+7gu2Ie7p/WOKq
	ACXjhw3l/b9VVDgXaGxNPbFNbw008w8h4QWFIBFzZS5gcPXaiEgaB+3BiqpxcLSYsDHIS/4gbBu
	gYGe646cW+WL1MMEG5NRFdp3qucaHAptF1k6zrBcjI70qBfqE0TADrp4//VZ519Bp93b0uGM+YD
	Xx4zfC4MJCp7BCb/Y/nR2z
X-Received: by 2002:a17:90b:2d50:b0:364:e97f:64e7 with SMTP id 98e67ed59e1d1-36a676372f2mr15441005a91.27.1779726271299;
        Mon, 25 May 2026 09:24:31 -0700 (PDT)
Received: from mincom1 ([119.214.48.8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36a6f0baca7sm5744357a91.2.2026.05.25.09.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 09:24:30 -0700 (PDT)
From: Jihong Min <hurryman2212@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jihong Min <hurryman2212@gmail.com>
Subject: [PATCH] netfilter: flowtable: resolve LAG slave for direct HW offload
Date: Tue, 26 May 2026 01:24:17 +0900
Message-ID: <20260525162417.366556-1-hurryman2212@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

FLOW_OFFLOAD_XMIT_DIRECT path discovery can stop at a LAG master because
the real egress port is selected later through ndo_get_xmit_slave().
Hardware flow offload drivers that program per-port redirects need the
selected lower device, while software forwarding must still transmit
through the LAG master.

Keep the route tuple software egress ifindex on the LAG master and carry
a separate hardware redirect ifindex. When the direct egress device is a
LAG master, resolve the selected slave with netdev_get_xmit_slave(),
verify that it belongs to the flowtable, and store it as the hardware
redirect device.

Signed-off-by: Jihong Min <hurryman2212@gmail.com>
---
 include/net/netfilter/nf_flow_table.h |  1 +
 net/netfilter/nf_flow_table_core.c    |  1 +
 net/netfilter/nf_flow_table_offload.c |  2 +-
 net/netfilter/nf_flow_table_path.c    | 34 ++++++++++++++++++++++++++-
 4 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 7b23b245a5a8..ada9db7e5c38 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -163,6 +163,7 @@ struct flow_offload_tuple {
 		};
 		struct {
 			u32		ifidx;
+			u32		hw_ifidx;
 			u8		h_source[ETH_ALEN];
 			u8		h_dest[ETH_ALEN];
 		} out;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 785d8c244a77..bc329420f882 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -132,6 +132,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		memcpy(flow_tuple->out.h_source, route->tuple[dir].out.h_source,
 		       ETH_ALEN);
 		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
+		flow_tuple->out.hw_ifidx = route->tuple[dir].out.hw_ifindex;
 		dst_release(dst);
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 002ec15d988b..7c46baa1546d 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -596,7 +596,7 @@ static int flow_offload_redirect(struct net *net,
 	switch (this_tuple->xmit_type) {
 	case FLOW_OFFLOAD_XMIT_DIRECT:
 		this_tuple = &flow->tuplehash[dir].tuple;
-		ifindex = this_tuple->out.ifidx;
+		ifindex = this_tuple->out.hw_ifidx;
 		break;
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		other_tuple = &flow->tuplehash[!dir].tuple;
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 9e88ea6a2eef..10f38ca27a6f 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -5,6 +5,7 @@
 #include <linux/etherdevice.h>
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
+#include <linux/netdevice.h>
 #include <linux/spinlock.h>
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/nf_tables.h>
@@ -76,6 +77,7 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 struct nft_forward_info {
 	const struct net_device *indev;
 	const struct net_device *outdev;
+	const struct net_device *hw_outdev;
 	struct id {
 		__u16	id;
 		__be16	proto;
@@ -179,6 +181,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 		}
 	}
 	info->outdev = info->indev;
+	info->hw_outdev = info->indev;
 
 	if (nf_flowtable_hw_offload(flowtable) &&
 	    nft_is_valid_ether_device(info->indev))
@@ -250,6 +253,7 @@ static void nft_dev_forward_path(const struct nft_pktinfo *pkt,
 	struct net_device_path_stack stack;
 	struct nft_forward_info info = {};
 	unsigned char ha[ETH_ALEN];
+	struct net_device *lag_slave = NULL;
 	int i;
 
 	if (nft_dev_fill_forward_path(route, dst, ct, dir, ha, &stack) >= 0)
@@ -258,9 +262,34 @@ static void nft_dev_forward_path(const struct nft_pktinfo *pkt,
 	if (info.outdev)
 		route->tuple[dir].out.ifindex = info.outdev->ifindex;
 
-	if (!info.indev || !nft_flowtable_find_dev(info.indev, ft))
+	if (!info.indev)
 		return;
 
+	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT &&
+	    netif_is_lag_master(info.hw_outdev)) {
+		rcu_read_lock();
+		lag_slave = netdev_get_xmit_slave((struct net_device *)info.hw_outdev,
+						  pkt->skb, false);
+		if (lag_slave)
+			dev_hold(lag_slave);
+		rcu_read_unlock();
+
+		if (!lag_slave)
+			return;
+
+		if (!nft_is_valid_ether_device(lag_slave)) {
+			dev_put(lag_slave);
+			return;
+		}
+
+		info.hw_outdev = lag_slave;
+	}
+
+	if (!nft_flowtable_find_dev(info.hw_outdev, ft)) {
+		dev_put(lag_slave);
+		return;
+	}
+
 	route->tuple[!dir].in.ifindex = info.indev->ifindex;
 	for (i = 0; i < info.num_encaps; i++) {
 		route->tuple[!dir].in.encap[i].id = info.encap[i].id;
@@ -281,9 +310,12 @@ static void nft_dev_forward_path(const struct nft_pktinfo *pkt,
 	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
 		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
 		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
+		route->tuple[dir].out.hw_ifindex = info.hw_outdev->ifindex;
 		route->tuple[dir].xmit_type = info.xmit_type;
 	}
 	route->tuple[dir].out.needs_gso_segment = info.needs_gso_segment;
+
+	dev_put(lag_slave);
 }
 
 int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
