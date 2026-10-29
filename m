Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276876;
	b=g8pS3hItBRfzf4xKCs4WeMYabMKkNuOkAmRoDHANCMu6Xa5kATOB5dDRuAa0htIjJrs1
	 6rUJetaxX98+loZEfcFKlmiZyjMXL2XNOgszicinBfOKoc6ci3Ut0MiFoVlJFwNzHwJwz
	 zjG0Wm6BIhIUu7sP3ojByguhx1BolS+I0nQrpSil0T9aF8gGB568r1zTRfQ1AJ8OTFX0x
	 pE/DNPs4yW1kW2uf2ztBczIa8NnQDoWk8ceaxc6DoQasSyjYc26Q11hZohBfCIMf+pm2R
	 UEvz5yiLLmBl29OLxJeUu/7Q7lmz9qReyULJjOYdheqJ1hCDl9nrSNRehOVuhggbVvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276876;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=lSKN+UM/eg1vZihkA9xb5bIkGTFkm93IObzCkAuzkdw=;
	b=hukdZ+eQnSqDSSDTQRMsyo2YrBcMevj+ReaqENcSSlTW90Kfod3aWQ78K57bdw8aEFkQ
	 2fHsYAykN8pCorpYd01lL5bHR+gNATW5L284I31D9Z7vhO9nlMkzEC7gSAjddLr16fWoJ
	 pbMY0xZdzxqfp73ZGOHDU03kRqnlugASl8GnvAQ6NYw+7VQ6jyj+N8czHfy744YZUG+AG
	 Qu64h8D+I5oeOvsSEPVuCiTx8oibJcDEtKudC/WsuzNcEIDxcZdD44zbL/f3x1jtHVkcV
	 tNJm5VJD/d7KV1veppJ9/ZOhMk+XekfbJnf9tkk5q04CWmVUawsSlDkYdhgR7KAbq6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=o2hSThVl;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4D5606A32A
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 12:27:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB4D5606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=o2hSThVl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793276874;
	bh=lSKN+UM/eg1vZihkA9xb5bIkGTFkm93IObzCkAuzkdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o2hSThVlXZQY+4yBA7KxPl6w3FFTN2i72IEqdMC9rN/XWzAqCvb0XRdCAgXdxF1yi
	 QKpMuGBvWnCmwjbGvatPkrrwePbDtzFPxGuIkLqLXmAw7JB0ilRjG2Ge5Y/MlVr+9N
	 Hc5fcBc9IRpP0DrIdxFTuQ2Z9dWZqpUExYAHET9LuPgRKKuhRHgiuVRWrjbsswYOoA
	 BWM+iKwXR/vdBNKlQRSi0wQl4mkPeVD6Esx60q+wnzKtu8i6A4fEjyla8GXLOvg8Z0
	 a0IoRjfq+O15AFOBNEzqmoAW4VIYulLjTU7NI2LTve2jhz+7VS6u863pGeGLFjxU/F
	 I42f4YolHY/HQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C8C0B60057;
	Thu, 29 Oct 2026 13:27:53 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo@kernel.org,
	nbd@nbd.name
Subject: [PATCH nf-next,v4 2/2] net: ethernet: mtk_ppe: update stats on flow deletion
Date: Thu, 29 Oct 2026 13:27:49 +0100
Message-ID: <20261029122749.196486-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261029122749.196486-1-pablo@netfilter.org>
References: <20261029122749.196486-1-pablo@netfilter.org>
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
v4: no changes

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

