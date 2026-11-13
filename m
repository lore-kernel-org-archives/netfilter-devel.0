Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539583;
	b=vOvujvB5f2sDW1xosw875bUiJSFVv1wiFyiul36IrR7hfI+0QbhxYFlDp80Bj3Sqbcxm
	 9FIabUVV7Od3l4kSJ01Fo12M0aRHvn9mi+6YevWbdX9RkWFKGQf0WOuhbPJDt8TdZGJhb
	 rzIKHDVmj7TLpDTuAUEp5OEKYG7sgyHs0rHrhuBGAzjUX6fGvdh2XMNXcnzNcqeXOdQOF
	 tfYpqSYW6r4JEefl9TrRBDheYtj6C+e9k/4hnUyGXjSqOXyCxTdvx2gAWdJiDtIc9QdBd
	 kHhGKecsnxwbPN4G1wvy6u78VFDB80OmmkE4jsdXVARhEDP8GI7ILlnfE5XodWMuqmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539583;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=N4QmwFF0fTYQkMkjZz9ylw4Weo7FSTb9Vq2C2H0x2Zg=;
	b=LSpsMFeBuxlOJ84QVlzxL4M0RtYXlgxmEFVe73xdWwoV1uUdnxwGaje6ckpiJJt+N8MZ
	 ydSU9/VXPreyqoVRfxNYJuvmZJ93CpC6MQ7IrdnLSuJGNlbBpvR7p6GduTIeUA6V6tYkG
	 wUuLVsh/LWApsgfNBTmqaZ4G9vR6CjMcbr+RuGTcWkUM1uy/c4cuC2M7ymQheketUJXBJ
	 zxMOtclzcTNDQkw5vpGlMYR/rvZxT2vbZWvhC4a1sVEhLFFgG7ZhVXtGRmR97RUOPj5hS
	 Lzw2ZlmTaacGGpWU/0LlBC1mxSoeLU93Xisq/E8nFxUZm7MzboAG/wgqr2G569UD+4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="kR3vb/W5";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52023606A897;
	Fri, 13 Nov 2026 03:13:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52023606A897
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=kR3vb/W5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794539581;
	bh=N4QmwFF0fTYQkMkjZz9ylw4Weo7FSTb9Vq2C2H0x2Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kR3vb/W50CkRVET68nzhNP5pQlaLyuE2rnChaLQMs2WA07dRQTqVMLw58bsClIxuG
	 NVbl0kiKhmNXdZ3LVxjAYgmMcKHTLw2sfrPFipQ15wVb8lrJLHL971puP/GGrm150s
	 IjjaheNZj6zPVetr1+rnIEwRMfHQ40NjoCo9Orv2BPx7dPZbQhHkQYg7td5W+ORB2f
	 q6H6Dy43mie72fIu9yURFOiD0mFRqdbMfj/9ZuDGkdpkpzSF/vphP4ZKu8uq+yZE/S
	 nLETDh84WExruiuPrneBIxl3mWlf1IwR4iBYAGkBkgcOxCH4aEwlgaR9iYNI13SAPf
	 o/s7CutO6b4xg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 35669602A5;
	Fri, 13 Nov 2026 04:13:01 +0100 (CET)
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
Subject: [PATCH net-next 04/15] net: ethernet: mtk_ppe: update stats on flow deletion
Date: Fri, 13 Nov 2026 04:12:40 +0100
Message-ID: <20261113031251.2437074-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113031251.2437074-1-pablo@netfilter.org>
References: <20261113031251.2437074-1-pablo@netfilter.org>
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

