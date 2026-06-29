Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21E33FE66F
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 12:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782736407; cv=none; b=LDMPkJvzVCDkbMdSK2oyH/ltRf51T8dyWvc7EmCOsYipNSM1jOJ+948s9h1ndOaD9AtTqyX4zuRXEn1254XNiVwMeqyu4J9f0K38Lb+2ae5F4939xH1e3j6UOKSzxXzX5OiHW8zpCTrpPCdKidtS3cDeXBVi0EYXvNzkbSbF2v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782736407; c=relaxed/simple;
	bh=ZCRB2ICnhy+yorYHit6z9ApMAWj8ye6ZQlK3b8ptewQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DocIZS++Z/ETYV+5MFaZXRfnG4BvrMC8Vn6zl0B37n2PncgxZp3V2+e+4I83dYAE00QpPsCXUFufN6L1TeVQCgSmOb6E+XKGQ03YB1zqBUdaKms2KzNvXEfv3cZoHzOl9xe7gA3MqNsBr3MuK/KgSZPDm1Ut44ftfqvGaNVyEcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ddI48tiC; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ddI48tiC"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-697de23bd7dso4684435a12.1
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 05:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782736404; x=1783341204; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IyKouin1u5dLTjGH2vHTEIBjw8XShphfnZNY49Ba01Y=;
        b=ddI48tiCl7ou88lkIB81gZTA98HUrMgqYeNqWP/3neEvEmic1t/Axyk9poPZ7YqMdb
         +wxusV0GXhS9zSZRNzqYoWVKyPKBzfjwWmwMA2GGEjykuy/NA8WjWWOLl2VvwUaoG769
         Nt/bqpR4NkXb/c0H3h5q1QsAPZ3Rk8CzI7yomikp1aWXr5xf61gsdnL6n/tX6x2efcmL
         plag1JQhypA+593nD1VsjJEwMxeWeV/jodVcE6V2M+yXOItJCnsBMK7201JrBVR0tsLq
         vVLtdswkJ5dw1Srxpy4gUJQbNX4nfA2de9Dchn0mzYTl6PBagBWgKh4mz+V0RONklyiK
         4wRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782736404; x=1783341204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IyKouin1u5dLTjGH2vHTEIBjw8XShphfnZNY49Ba01Y=;
        b=ggFjeMk9ZYkVBEipadVewlhhptuyWt/1v8xhgiNJXYF8PbhKboCxMo4GihcaFWxTQ6
         1PDK2T78O9aLfqj21kSI8Snidz+VfM3UQxww0te581BxPCns9aSlp7OG19Nv6ZXz6hLD
         otZtWmnfOXPVSwFb+ftQfRdV0JXPvncyQjbH5+b5rmzR/8+/HnJs5zCKvJ1LT4gSaqhh
         CXGHDmqBEK8LXs8RahNxxf39y+3giEtFUFukRQdooLG02zIRGXT+dQxBRpb0aHhlKb0u
         PiaqoGSPyuI62TBKxS7f5R1BvR9xmsyziaP+zFa8JLquK9fxT48JociiAUgrb95a1SVP
         2A8w==
X-Gm-Message-State: AOJu0YxSU5Np0KNFua8Smx8Jtd4jiJVJZcZOd2WnxnMtRWdaWjOJpYYV
	nc7E/TAWemc48xTp35rvmgfpmIIjyW+SBKli8O+P5aAjolY3V8qQJ4LNoMPzUjak
X-Gm-Gg: AfdE7ckYy1cM4R8b71k0PCZes1SI1nlzMRcNiemZjDZGZzIz6zNUGPwv7PMXploH0/H
	C4PzvfWwRhUddLujsB6kMNPwJrPFq7Lm9HE+2vpUrwyNqK6I2Y6N2HnGc4W1bcdKkMAJP0wPGMj
	j1azRAAGzwTTvsgf662wY2UtPWYsqnDWqFSd3K4RyoYLuBCciCWJ5g71ECSSSTtzLVvtBZoQE7E
	EtrqeucbKwMDwPEKYs3K6Epni0hwca03p0sfQPXgsMrdp3h6SbLQch+NFylFpSldx6RQ4SOk2GN
	g6aIFWpx3Dj5htmzA6RaUGUmkcRGULgfSLQ3XBR7un7zQTOlCo/j8iDvsEPKR6vvHrv+AwMKhhH
	zXR//7m1zDjGvD+mp3q/qIc0ijzzmG3wOajyfrSLsrVKLRydH283FUNvmPa2H6kp628xwi26AQV
	QQEgwv6iw=
X-Received: by 2002:a17:907:9452:b0:c12:7e9f:5ae3 with SMTP id a640c23a62f3a-c127e9f5b7bmr43558466b.15.1782736403905;
        Mon, 29 Jun 2026 05:33:23 -0700 (PDT)
Received: from fedora ([46.205.218.111])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c11fbe05c22sm773866566b.39.2026.06.29.05.33.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 05:33:22 -0700 (PDT)
From: Daniel Pawlik <pawlik.dan@gmail.com>
To: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	andrew+netdev@lunn.ch,
	razor@blackwall.org,
	idosch@nvidia.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	bridge@lists.linux.dev,
	coreteam@netfilter.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	rchen14b@gmail.com,
	lorenzo@kernel.org,
	Daniel Pawlik <pawlik.dan@gmail.com>
Subject: [PATCH 2/5] net: bridge: add flow offload helpers
Date: Mon, 29 Jun 2026 14:32:50 +0200
Message-ID: <20260629123253.1912621-3-pawlik.dan@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629123253.1912621-1-pawlik.dan@gmail.com>
References: <20260629123253.1912621-1-pawlik.dan@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add three helpers that expose the bridge state needed by nft_flow_offload
without requiring callers to include net/bridge/br_private.h. Each
performs a single br_port_get_rcu() lookup:

 - br_fdb_has_forwarding_entry_rcu(): resolves the VLAN id for the packet
   (skb tag or PVID when filtering is on, 0 otherwise) then checks whether
   the bridge FDB contains a forwarding entry (dst != NULL, non-local) for
   the resulting MAC/VLAN pair.

 - br_vlan_get_offload_info_rcu(): when VLAN filtering is active, returns
   the VLAN id (skb tag or PVID) and writes the bridge VLAN protocol to
   *proto in a single port lookup. Returns 0 when filtering is off.

 - br_vlan_is_enabled_rcu(): returns true when VLAN filtering is enabled
   on the bridge a port device belongs to.

Based on MediaTek SDK patches by Bo-Cun Chen <bc-bocun.chen@mediatek.com>
and the OpenWrt bridge offload series by Ryan Chen <rchen14b@gmail.com>.
Signed-off-by: Daniel Pawlik <pawlik.dan@gmail.com>
---
 include/linux/if_bridge.h | 23 ++++++++++++++++++++
 net/bridge/br_fdb.c       | 32 ++++++++++++++++++++++++++++
 net/bridge/br_vlan.c      | 45 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 100 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 75673b8bffcb..c1cae54749c5 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -148,6 +148,9 @@ int br_vlan_get_info(const struct net_device *dev, u16 vid,
 		     struct bridge_vlan_info *p_vinfo);
 int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
 			 struct bridge_vlan_info *p_vinfo);
+u16 br_vlan_get_offload_info_rcu(const struct net_device *dev,
+				 const struct sk_buff *skb, __be16 *proto);
+bool br_vlan_is_enabled_rcu(const struct net_device *dev);
 bool br_mst_enabled(const struct net_device *dev);
 int br_mst_get_info(const struct net_device *dev, u16 msti, unsigned long *vids);
 int br_mst_get_state(const struct net_device *dev, u16 msti, u8 *state);
@@ -184,6 +187,17 @@ static inline int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
 	return -EINVAL;
 }
 
+static inline u16 br_vlan_get_offload_info_rcu(const struct net_device *dev,
+						const struct sk_buff *skb,
+						__be16 *proto)
+{
+	return 0;
+}
+
+static inline bool br_vlan_is_enabled_rcu(const struct net_device *dev)
+{
+	return false;
+}
 static inline bool br_mst_enabled(const struct net_device *dev)
 {
 	return false;
@@ -209,6 +223,8 @@ void br_fdb_clear_offload(const struct net_device *dev, u16 vid);
 bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
 u8 br_port_get_stp_state(const struct net_device *dev);
 clock_t br_get_ageing_time(const struct net_device *br_dev);
+bool br_fdb_has_forwarding_entry_rcu(const struct net_device *dev,
+				     const struct sk_buff *skb, const u8 *addr);
 #else
 static inline struct net_device *
 br_fdb_find_port(const struct net_device *br_dev,
@@ -237,6 +253,13 @@ static inline clock_t br_get_ageing_time(const struct net_device *br_dev)
 {
 	return 0;
 }
+
+static inline bool br_fdb_has_forwarding_entry_rcu(const struct net_device *dev,
+						   const struct sk_buff *skb,
+						   const u8 *addr)
+{
+	return false;
+}
 #endif
 
 #endif
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index e4570bbed854..3161c2689f6a 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -267,6 +267,38 @@ struct net_bridge_fdb_entry *br_fdb_find_rcu(struct net_bridge *br,
 	return fdb_find_rcu(&br->fdb_hash_tbl, addr, vid);
 }
 
+/**
+ * br_fdb_has_forwarding_entry_rcu - check if a MAC can be forwarded by the bridge
+ * @dev: bridge port network device
+ * @skb: packet buffer (used to determine VLAN id)
+ * @addr: destination MAC address
+ *
+ * Resolves the VLAN id for @skb on @dev (skb VLAN tag when present, PVID
+ * when VLAN filtering is enabled, 0 otherwise) then checks whether the bridge
+ * FDB contains a forwarding entry (dst != NULL, not a local/self entry) for
+ * @addr and that VLAN id. Single br_port_get_rcu() lookup.
+ * Must be called under RCU read lock.
+ */
+bool br_fdb_has_forwarding_entry_rcu(const struct net_device *dev,
+				     const struct sk_buff *skb, const u8 *addr)
+{
+	struct net_bridge_port *port = br_port_get_rcu(dev);
+	struct net_bridge_fdb_entry *fdb;
+	u16 vid = 0;
+
+	if (!port)
+		return false;
+	if (br_opt_get(port->br, BROPT_VLAN_ENABLED)) {
+		if (skb_vlan_tag_present(skb))
+			vid = skb_vlan_tag_get_id(skb);
+		else
+			br_vlan_get_pvid_rcu(dev, &vid);
+	}
+	fdb = br_fdb_find_rcu(port->br, addr, vid);
+	return fdb && fdb->dst;
+}
+EXPORT_SYMBOL_GPL(br_fdb_has_forwarding_entry_rcu);
+
 /* When a static FDB entry is added, the mac address from the entry is
  * added to the bridge private HW address list and all required ports
  * are then updated with the new information.
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 5560afcaaca3..0b296362adf7 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1559,6 +1559,51 @@ int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
 }
 EXPORT_SYMBOL_GPL(br_vlan_get_info_rcu);
 
+/**
+ * br_vlan_get_offload_info_rcu - get VLAN id and protocol for bridge flow offload
+ * @dev: bridge port network device
+ * @skb: packet buffer
+ * @proto: output for the bridge VLAN protocol (set only when return value != 0)
+ *
+ * When VLAN filtering is enabled, resolves the VLAN id for flow offload (skb
+ * VLAN tag id if present, PVID otherwise) and writes the bridge VLAN protocol
+ * to @proto. Returns 0 when filtering is off or @dev is not a bridge port.
+ * Single br_port_get_rcu() lookup. Must be called under RCU read lock.
+ */
+u16 br_vlan_get_offload_info_rcu(const struct net_device *dev,
+				 const struct sk_buff *skb, __be16 *proto)
+{
+	struct net_bridge_port *port = br_port_get_rcu(dev);
+	u16 vid = 0;
+
+	if (!port || !br_opt_get(port->br, BROPT_VLAN_ENABLED))
+		return 0;
+	if (skb_vlan_tag_present(skb))
+		vid = skb_vlan_tag_get_id(skb);
+	else
+		br_vlan_get_pvid_rcu(dev, &vid);
+	if (vid)
+		*proto = port->br->vlan_proto;
+	return vid;
+}
+EXPORT_SYMBOL_GPL(br_vlan_get_offload_info_rcu);
+
+/**
+ * br_vlan_is_enabled_rcu - check if VLAN filtering is active on a port's bridge
+ * @dev: bridge port network device
+ *
+ * Returns true if VLAN filtering is enabled on the bridge @dev belongs to.
+ * Returns false when @dev is not a bridge port or filtering is off.
+ * Must be called under RCU read lock.
+ */
+bool br_vlan_is_enabled_rcu(const struct net_device *dev)
+{
+	struct net_bridge_port *port = br_port_get_rcu(dev);
+
+	return port && br_opt_get(port->br, BROPT_VLAN_ENABLED);
+}
+EXPORT_SYMBOL_GPL(br_vlan_is_enabled_rcu);
+
 static int br_vlan_is_bind_vlan_dev(const struct net_device *dev)
 {
 	return is_vlan_dev(dev) &&
-- 
2.54.0

