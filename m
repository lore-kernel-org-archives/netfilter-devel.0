Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793272488;
	b=LGn3orXIFX4MHo+4JA5WT6FMHvZZsUM9eOuwOUQgi4k3WHPMesTeGcz3raDS5jRXK5Pd
	 c/dDt3mTWsCAmHwtPbJwXXKZBFhrhuOW/kw5zIQMv0F4tJlRK3PDSSwUxR4I7pCd/uFoy
	 BgTrlwBN4+x21Sgm00i1EuPjChRxckCgrY4L7zkxyHAU5FFe7pwSVrh4ylxhPUETZxAtW
	 ASrywVQqNooGrhfWPvsgE8mt0BfSQBsDPcxBfOGi4XgIKY/sgFfMuOWPSerIXgEgrjCiH
	 x6vBgCoZ5mnoKcNxY59yyGJsS80IJ5VX56njimp/NCb9aWHmj+3C2UfsG7WLBdldCFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793272488;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=ADCvotNvkLGQ7IcTOKybBZc1HaNDb20xFtVuO8QsBJ8=;
	b=LrgZdIMFIwLuLIuGbm1NF3w7zBO1cUs3jlzu6FT1a4OAsHHVlA3JqeEWpbtULsEwwctG
	 3M4+fAyHoyLXEKZ6eov+SiP0sfgMNW4KdmDD/jv9L7HyiHtgckIqZm6UpEuRDM8v7Q8rT
	 cX60jxml+GkE1v+IDDUCaFzthsL8ZSsIbETJJP2bobT6om7nqmobRWAVnxUlXordks+gN
	 IrFXwcfqSbqqyDBpkwc1VU4of3mgZCvM9oFK+ocQEu794/lDj3wbAnzDw9anNEAdYpEpF
	 T9bFU7zeT4LToWl0f+Rn8e43jZ4GC9wEEenum+pZzMVhxOPqcPdzy84x8sB24GTjgwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=m60y9nw+;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E42606A31C
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 11:14:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96E42606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=m60y9nw+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793272479;
	bh=ADCvotNvkLGQ7IcTOKybBZc1HaNDb20xFtVuO8QsBJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m60y9nw+Oy6H87fOFL23sqgkR/a6sr/XSAQPOppZ+GvpIX1gir4vFlpCQdlgdy0yq
	 yt4HTo9wAS/9dfkctpuu9NDM0BtC98Hgv9tYDhMghDyRxWfdkcfbJCfGIXocGVdNt0
	 QAQaGpd0pKnsA2jjRUeF/IBYF2fnHgsyzJcUPVYMWryuyMgobvD2xk4LQbgMJDIasl
	 wlj+FZaR3S4jarRGCRLfOBjwRx4brXplYU4NZ583lhEuR4XJAE6l5dl212k9fzJA9a
	 hjRvczcNe8vN+fOy59A2FsoEjQchde/OfQ575uOo945KyW41JxzC/a/oBCD/ukB9kl
	 8Y1ZFq0KHdxCg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E7BB46007B;
	Thu, 29 Oct 2026 12:14:38 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo@kernel.org,
	nbd@nbd.name
Subject: [PATCH nf-next 2/2] net: ethernet: mtk_ppe: update stats on flow deletion
Date: Thu, 29 Oct 2026 12:14:31 +0100
Message-ID: <20261029111431.179813-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261029111431.179813-1-pablo@netfilter.org>
References: <20261029111431.179813-1-pablo@netfilter.org>
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

