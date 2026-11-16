Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788187;
	b=YMt6QnbUqM/jj82FfLE92CGqlCRJmq6jIkPLkY/r+q8OdZyQGc14PUMqGliaxg4yC/wH
	 hVfFptG8JsVqbl8gZWa3VgnHn6nWn31rk9CWdwXCIAXS+1LMIBeIs2fBrUdA6RUPHVr3x
	 IJyHws+mHZ8a/1z5A8wz12KgxARMztIky66IaSv6ud2M2r9bMZMnczpEq22DvOFutnOHe
	 aUTos+d4rXjmWFkM5nPxiLwvCADfOZTvydk1kSupVUK5x7zYZe43gVmEnwdLS28GEP+jx
	 kBPSFFJZVGYLnjgWu25kvAy/ArsXoAw36aOsH3b07igVpDvI0BPuNzMoP1/RnnKh7tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788187;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=N4QmwFF0fTYQkMkjZz9ylw4Weo7FSTb9Vq2C2H0x2Zg=;
	b=AgmyV9CNogBAPRsrDM0TamHY2GfL2ytS4yokyyu9b0lXsgdiXqB5TARmKPuasCUObeON
	 3KqiJJVOpouG5ld1MCdlAtpv1qybDL/VKd326pJIWrHsN6I3a/BRH3niEklK49udn1OVf
	 Lj3YxhZWY5mAzEtGjzbtzRUvNVDxmiI9ECRX0nuOv0oZa0spCtGNqrgIafz6zWucn2U02
	 pLm2wxb56gufNecJjR7ktTUOg2secoCAoKFru/jdUo3p4+WwQ6heJNYeiMIXoWIqPzTee
	 4ZirKe9NWRqbI0XOh2lvcyiYhEbw3A/sqPRDvgubIrnajz3KHpco7XrJQHDjJTQ1LjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="RYlJD81/";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38A1606A337;
	Mon, 16 Nov 2026 00:16:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A38A1606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=RYlJD81/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794788184;
	bh=N4QmwFF0fTYQkMkjZz9ylw4Weo7FSTb9Vq2C2H0x2Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RYlJD81/DTd0WzQzIEtr84kQe7hQS1AHrT/0IO0+BRm6HzyZBYhgEhvgvAcy4quRK
	 68A3PlqYz8x0rwDn6cZ7JgfvgAukdC8c7R9or51vn/zFpH5mOSpG0k3EgG301UGua5
	 USedupw9pFfHBjImFaPVyL3JcLf6p/mCqWzQ+5FkNl0jKcaYaB6w5b1DVIZKgCjexT
	 A+YbrbLvouDPAwBTkSuTIZrsGxY3VFNs94j/8ejqTMnLwbDjCQddnlaV+ppUFxuVcL
	 peCG5ApBNhbMa0iTTUpEgaLwEtVpMem+W7+sHsH7Zx74MAOcnOAgr2lbY/yRML0qqr
	 wkU9kOvABg6lA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 860ED6005C;
	Mon, 16 Nov 2026 01:16:23 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 03/13] net: ethernet: mtk_ppe: update stats on flow deletion
Date: Mon, 16 Nov 2026 01:16:02 +0100
Message-ID: <20261116001612.2806263-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116001612.2806263-1-pablo@netfilter.org>
References: <20261116001612.2806263-1-pablo@netfilter.org>
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

