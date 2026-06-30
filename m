Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552713769FF
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Jun 2026 06:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782802682; cv=none; b=lVqAQ/zUJqja84KMh4ZrP+xhDXnCoo3T/G3ELg7H+pPGveTHAW07W0lt4/gtI2CnRlQoGGIFBs/Gr5t5Zu9ByZwheQrXIG3nLvV2lB6gGU96C+UyeJ4MJ3+URbWXA/nzJaiOkeDzL7xCSw9NLjPwcf3RgjJapd/Uua9ua5Ek38c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782802682; c=relaxed/simple;
	bh=k2puRy9roCqo1TmJQwz5Au2uDKrjMO7oV6i8D2XzG3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smbYBvUsieLXxU1WA8SwQxoJZL+cS/D7u70tLskVfH6eyb5qQWuJLI35Vf8Efjt99lZb/JEFQbzAeMqsudIDCzfDpsTUcS7iP/jtdXGz3nmnkX/FHQGTyJjokji5CDJuFZP8HbxhNpPbrlM6JrbzIEudf70QOYHGJTSB2ONOobs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K0DirsZL; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K0DirsZL"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-47248615e4dso2375904f8f.2
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 23:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782802680; x=1783407480; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9wpDkwfgHI7sKJsUdxhPlr3RzF4vUZ59JqIq4w/25rI=;
        b=K0DirsZLEMe5g5xU5jhiVMcWPze00GozSu5wITCehrcpclaFalpAKGRxH+qg7v2jmK
         bDDVZdKTvXMaMs7xH81IUm1sbwKLVv/sfq0avkvgLjx2+DNtc6k5EAThe6D+3eo/hovt
         VeooWLJBh3W3sDmIeLkm3AEDfiGIbEoREn4joTM5lxrfGhpUdVNi+Olw1/c7Xka6dq0i
         fGsT3mc487mHO4G46G4jgIvUuxk0qvK0OfYotUCtSaOdBds/TxhcPwcnLAidZcLFHP7k
         xIXLPIMekGvDn1I8BbSUiKVkh5ltOZXyxgFkw7czQdOYCo0F+/bIilZRUxmUIwon7hW6
         i5lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782802680; x=1783407480;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9wpDkwfgHI7sKJsUdxhPlr3RzF4vUZ59JqIq4w/25rI=;
        b=QOyvT68Djx+MhPvZ1/gkLg8TA+Fzed+Os/3jqLTx5+49ErQLPtAJPAS8Skw6vWAMq5
         hDGcrt9h05clOT1f4BHgETzXvpb7ur5mGbCmS6X7MRBVs410rt9pConJx9MZfV2tBeSQ
         0BkzgThcVBykGn1gsfCEWGQ51zAPwSEgXxvp7np53yfl/i8QeSm7f300KLl8kStQDQZ+
         qTxgs5V/cJPnSQYbAQwi7iGfXiNJTIhYXM4YpCQo6QNpQERmSZuA/+SzgwptK+t+/kP+
         qwPr2mMkxpyURj4dhvUYU2hfFYFCKu1lXuKlplqrVoFeUSTRPrsmw7mznkVw3WAf1/r6
         7u+w==
X-Gm-Message-State: AOJu0YwjRsp4GND7KKsm66A4jBNkatzvSsi+nkbls+ougv2dbjEBTyxv
	FIfAuHN+Ra2R0TfHsKlyulGlP0BxudwkyW9Sd9Bf78BN9ezanaoMDux23zrUgZLz
X-Gm-Gg: AfdE7cl63hznfNrijezwjukDyEd0q9qpnK3eTeSZHgLtHDJr06Ms4IlhLxthhS9etcK
	fAfVy7ylVoSydMcRRYbAqoO/B5NSqzjt9qpLdDbyQ3adazN6Mf7LS1OwQk32hRpMz1qOPQB1Qva
	ts+Q8TFHtbkEJQFf4Ch8JNL5fiW2+lKW0vZxLou0AgDWW0y4Pn6z/gQv3W/ml631m2zg/9cR6Wo
	WS+DMV66CyN7JxZOTRbrrMsb/uY+/JHp6RII3XNxjYt9GKU0JJ6onr4jZy+LG3FM31VM8F+8gnt
	aPYpueIJdd7cy9AQ8Cix7Bu6sEwRIOoa/fGw2uMBrTTlXEgaWTGY+8AMwaGghk6AG2r7Tfdyeda
	/bs5NiErNanIbxBFcLETVnARMQmDjGwBTM1KheRm1J7Dit+doiJl0wn9PmlkMxsftKSOY0Vi46/
	1cXNTNZp5l7WLbyE4JOw==
X-Received: by 2002:a5d:5d05:0:b0:474:6a5b:8604 with SMTP id ffacd0b85a97d-475507ddf66mr3025354f8f.11.1782802679649;
        Mon, 29 Jun 2026 23:57:59 -0700 (PDT)
Received: from fedora ([46.205.218.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4756636cf26sm4570949f8f.19.2026.06.29.23.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 23:57:59 -0700 (PDT)
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
Date: Tue, 30 Jun 2026 08:57:32 +0200
Message-ID: <20260630065735.3341614-3-pawlik.dan@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260630065735.3341614-1-pawlik.dan@gmail.com>
References: <20260630065735.3341614-1-pawlik.dan@gmail.com>
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
 include/linux/if_bridge.h | 23 +++++++++++++++++++
 net/bridge/br_fdb.c       | 34 ++++++++++++++++++++++++++++
 net/bridge/br_vlan.c      | 47 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 104 insertions(+)

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
index e4570bbed854..2a65b203274e 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -267,6 +267,40 @@ struct net_bridge_fdb_entry *br_fdb_find_rcu(struct net_bridge *br,
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
+ *
+ * Returns: true if a forwarding entry exists for @addr, false otherwise.
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
index 5560afcaaca3..974e57ea533a 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1559,6 +1559,53 @@ int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
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
+ * to @proto. Single br_port_get_rcu() lookup. Must be called under RCU read
+ * lock.
+ *
+ * Returns: the VLAN id, or 0 when filtering is off or @dev is not a bridge port.
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
+ * Must be called under RCU read lock.
+ *
+ * Returns: true if VLAN filtering is enabled, false otherwise.
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

