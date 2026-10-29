Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793273654;
	b=5opjl5swa7gbny5F3tk43AwCujNvIzv9ZOo1AR66yp68/G2qfPm6KWQlDTR4XrYTX0sU
	 d3PEEZVgVz34loDKLVjf9J8Dax6GKtF5O5HUs+YpvkjCQtcQ71wOOWl6783Dq+6bWdqLU
	 aWVfyJ32W0+7cMS+Oh2JTEg84FsLwPNtFF7HCtUulZmd/wm0vUJ49lpPnajwUoFbEXSf6
	 VFs6Z6afvuqM7ngGqyDYJlAQNzJUrPKtYqGtjSNzO4uL6XTon5o3C3nYczZufz1KuW049
	 iyeXRASa3rWQ/utQ86Yur1wotvHwmXO/1H1rtcfbwlD/ygOTYLxbE88yPeiWESLgv6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793273654;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=qwvf+GlmcOZeoU+7iX2LBpsHm5m27NU99DfbSiNPx34=;
	b=VL7GZU80nq+jBUkcZAZLVEs2+eHeONR7ARHek0euWcIft+AHvldfohTbNhtY738/45NC
	 wdfnqDSWzJjdnHvJ2URbzIdkaif7hnpiwGU11tXvryQd9phJMaMDPR7zuX2h7zDquL/Ht
	 hBjTSmJQhgETNY/Y8Q6XcFNLvtQyj7yaTeopHiYxp/1OoxwyvklZRQ05m0lgno/NXZrjU
	 LUbILQAvp8aXgqhpGkSXOSBiFwdUD9SvwcwAKMAIIPmkco8588LMmqzn/NK0qpgk8fIov
	 XzJmhfEngsmIV3K68mb8RVyBL/OnGcFzSLC/7tUz0jed3qpCGfXuxURfmkyeYTaUv5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=KqPaErYD;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9677606A31C
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 11:34:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9677606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=KqPaErYD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793273651;
	bh=qwvf+GlmcOZeoU+7iX2LBpsHm5m27NU99DfbSiNPx34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KqPaErYDg0RXzu5AazDiqXCDgCIpgz9a2hkZH/e7gmHlNW6j4HqkScIf5Wq/2vWH0
	 GkPHqznJFEBOcr1kUHtZLliSBCWLB5W1VXCUqyPcIyA2EeUu+Xxu9oRmyv3SqhGX/J
	 dsK93xJ3SEcN588GSJJH4ikUrJgsI4RE71Vehy3Qv5C46A1d7zYPVqU4aoESZmggCG
	 avR932OEwoV4fCa4CFysDMp3YXTyUkyi8TE+P5KP6AwXe2OLHik7iWzFmWwkE4eP+y
	 stqL5xMILKwof0A4dGS5fyK0rgyAbXEiAkBvlVc2zr6oCZc5CAxNfDZ7pCcoRMY8no
	 QB5AjyTfLa1Ug==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9ADA16005C;
	Thu, 29 Oct 2026 12:34:11 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo@kernel.org,
	nbd@nbd.name
Subject: [PATCH nf-next,v2 2/2] net: ethernet: mtk_ppe: update stats on flow deletion
Date: Thu, 29 Oct 2026 12:34:05 +0100
Message-ID: <20261029113405.180889-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261029113405.180889-1-pablo@netfilter.org>
References: <20261029113405.180889-1-pablo@netfilter.org>
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
v2: no changes

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

