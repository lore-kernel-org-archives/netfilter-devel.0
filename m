Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275142;
	b=VUU2foTF2tY53EeuuV18jwzRZ/HGVBKwrP1VgUWTLmAbaMOEbjmJA5+ZPrPJUWVM9rus
	 esVetqmKnjDPnh0Dc9s7XqenygCO5HB4SoBhzJdgEThltlsVXKFyAgTbN3obD/xPa4HR2
	 iDAUySTwTRIgQ2u6XwXQUyDbxzrSJqcW1khSTNA4cjQw8z2BBBcI8Wr5sMsVKW0KdwOXJ
	 a2GW4tltVjrKDPZkC+kFLf26yDI3zo9yF0TgG/LaVW17DvOBvNpC40lUkJX2q1C36TbHY
	 CiqqhFLW7VJKBxn8kAvHdcD9e3XozejxubCZxrc/zv8QM2ycK00OHxylg9kYG2lCqOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275142;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=N4QmwFF0fTYQkMkjZz9ylw4Weo7FSTb9Vq2C2H0x2Zg=;
	b=J4pOsQek0Jo0oE5whUUafSmD2nFR3VVleBIgN1GB0TAuQc8u3QhErlb0rpMorrLITZDG
	 gHV8TdlMO8rfsUjxNCgttHG/sYvSEBNUQz55b5Vixlim+CJ37KxPs+sAVtsK7GXNq/+Pt
	 1N+IaakM9g55OYpo7Agdnvp6mVrcq3tgaDUK1Qx0xc3be++sAOHfSGlus5kHPvbx5s6ME
	 h2Ug1Zt5ah7OXaL70/FVC2UU/L7VJFHQjyYyxnKxe+wpxzaekQHBgBcCIuCsSI1a2uGj0
	 an+CwM9HNsSTybG6kcHkPEYPVjCa43qESJQiUyHuhHUfyod9uAasuJZgksTh1PGSU/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Hlw+AcC4;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22948606A320
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 11:59:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22948606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Hlw+AcC4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793275140;
	bh=N4QmwFF0fTYQkMkjZz9ylw4Weo7FSTb9Vq2C2H0x2Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hlw+AcC45oVlTwkQQ19dYv4YZ3sutD5docJlJDksrMLN2JstUphx5HJrfKCuIKXDp
	 itbIYOrjvfTVMsaEHzfBqruqcQ423yCEuEmZc9KTv7J27Y6q2l649kt/aDqwej6/fw
	 n4ohUnU5YZKurW5+/Vr/xwJms8Q+CuA7x5FEy3Baqr8vGNW3+VMcC24k8KdOUQLFLk
	 F8IuwMeKxmgEBjGb0DIgCzhstW4o3o4uMMcuPUYsWMkdWszWCoNBDomtSqkjGeVWM3
	 6j4SEMYuJ6QSeBa7aaeKoulqzsd2jDrauk+OdiglvtSnBhV9wGMp9/opOY+nF9/WbB
	 1gXbFVnlCNiGQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4DD276005F;
	Thu, 29 Oct 2026 12:59:00 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo@kernel.org,
	nbd@nbd.name
Subject: [PATCH nf-next,v3 2/2] net: ethernet: mtk_ppe: update stats on flow deletion
Date: Thu, 29 Oct 2026 12:58:54 +0100
Message-ID: <20261029115855.188023-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261029115855.188023-1-pablo@netfilter.org>
References: <20261029115855.188023-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update this driver to use the new approach to fetch stats on flow
deletion, introduced by ("netfilter: flowtable: retrieve stats on flow
deletion").

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../net/ethernet/mediatek/mtk_ppe_offload.c   | 32 ++++++++++++-------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 99b28aaa7cc4..8ca694bb5e1b 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -526,6 +526,24 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f,
 	return err;
 }
 
+static void
+mtk_flow_offload_update_stats(struct mtk_eth *eth, struct flow_cls_offload *f,
+			      struct mtk_flow_entry *entry)
+{
+	struct mtk_foe_accounting diff;
+	u32 idle;
+
+	idle = mtk_foe_entry_idle_time(eth->ppe[entry->ppe_index], entry);
+	f->stats.lastused = jiffies - idle * HZ;
+
+	if (entry->hash != 0xFFFF &&
+	    mtk_foe_entry_get_mib(eth->ppe[entry->ppe_index], entry->hash,
+				  &diff)) {
+		f->stats.pkts += diff.packets;
+		f->stats.bytes += diff.bytes;
+	}
+}
+
 static int
 mtk_flow_offload_destroy(struct mtk_eth *eth, struct flow_cls_offload *f)
 {
@@ -536,6 +554,8 @@ mtk_flow_offload_destroy(struct mtk_eth *eth, struct flow_cls_offload *f)
 	if (!entry)
 		return -ENOENT;
 
+	mtk_flow_offload_update_stats(eth, f, entry);
+
 	mtk_foe_entry_clear(eth->ppe[entry->ppe_index], entry);
 	rhashtable_remove_fast(&eth->flow_table, &entry->node,
 			       mtk_flow_ht_params);
@@ -550,23 +570,13 @@ static int
 mtk_flow_offload_stats(struct mtk_eth *eth, struct flow_cls_offload *f)
 {
 	struct mtk_flow_entry *entry;
-	struct mtk_foe_accounting diff;
-	u32 idle;
 
 	entry = rhashtable_lookup(&eth->flow_table, &f->cookie,
 				  mtk_flow_ht_params);
 	if (!entry)
 		return -ENOENT;
 
-	idle = mtk_foe_entry_idle_time(eth->ppe[entry->ppe_index], entry);
-	f->stats.lastused = jiffies - idle * HZ;
-
-	if (entry->hash != 0xFFFF &&
-	    mtk_foe_entry_get_mib(eth->ppe[entry->ppe_index], entry->hash,
-				  &diff)) {
-		f->stats.pkts += diff.packets;
-		f->stats.bytes += diff.bytes;
-	}
+	mtk_flow_offload_update_stats(eth, f, entry);
 
 	return 0;
 }
-- 
2.47.3

