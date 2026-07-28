Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A01D3E638D
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 08:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228017; cv=none; b=CXWVf3La/diEFQhURHiUkWXFk1rev7lrOsm6A2XbbTYT/BweYvHnuQ8kX8vyLwLjLu5u7Ki61N9xv6gyMm+NWwYwF0lG76EyrzL+0g/nT8GL5qjaTJJIaUUH/fIqIyCUGV1kVH00mlWHi8qUMokD841AXIIax7f1ghqtnGVHEgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228017; c=relaxed/simple;
	bh=POXE4c/cfbtvqvG9oEbXbqcvbZgBakvTLpfMuYDTavQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=s9aQshcd164VETKjwSSjkY0Mi5ON3gg/YEF6+AQGB3+mhtIl6jX7EcGDyXqPSoU65oymQjuxB/ospPdg4omeJNaV0fWpvL2v3yvL+gBOgxNl0/zpDz3oRANWOxxlyddMd1kUipSRht04X8Ez2nS4wJWbbhs/0ao+5qFEqufW1T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pGYbyBi9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pGYbyBi9"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 27F0F6018F
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 10:40:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785228011;
	bh=1C41IV2ZQyHOtLGC5rONn0bQrkjIlTfPPz2Hgs/+QM4=;
	h=From:To:Subject:Date:From;
	b=pGYbyBi9Kxe8MDOPcVgu1Wyvg40S3PIYh8pYJLVddX7bT/EotOTDujERmcPuSiCAP
	 qOPkl6XAG7wpfZmujgazeIGAsxKWvqtRiAcx1FtRjniCadAFnnV+O3trkwLyBjYV5b
	 wyZdND0OpViK6qLlIADLhggy1+4sDEKcOcHPydGr/2dN1uJDy6i4ADVXTPOpsgtPMC
	 gvfsFK/HbJEA7iJUKw0mRxg+6jWhXe1DcFq2+LIujJOwFZxNmj7MGUHLSt9tTnxM1k
	 MJcN3lT3lUUh4Ciq1M310SkvNWfbkAJMTrscs3q9p2fnPMvPzV40Mcu9O4+I2ZB5gs
	 PeBzoUOcMZCZQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_tables: call skb_valid_dst() before skb_dst()
Date: Tue, 28 Jul 2026 10:40:06 +0200
Message-ID: <20260728084006.101762-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When fetching the dst_entry from the skb, check if it valid, ie. this is
not a template dst.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_meta.c | 6 ++++--
 net/netfilter/nft_rt.c   | 6 ++++--
 net/netfilter/nft_xfrm.c | 9 ++++++++-
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 0a43e0787a68..01cfbaa36525 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -20,6 +20,7 @@
 #include <net/dst.h>
 #include <net/ip.h>
 #include <net/sock.h>
+#include <net/dst_metadata.h>
 #include <net/tcp_states.h> /* for TCP_TIME_WAIT */
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
@@ -279,11 +280,12 @@ static bool nft_meta_get_eval_ifname(enum nft_meta_keys key, u32 *dest,
 static noinline bool
 nft_meta_get_eval_rtclassid(const struct sk_buff *skb, u32 *dest)
 {
-	const struct dst_entry *dst = skb_dst(skb);
+	const struct dst_entry *dst;
 
-	if (!dst)
+	if (!skb_valid_dst(skb))
 		return false;
 
+	dst = skb_dst(skb);
 	*dest = dst->tclassid;
 	return true;
 }
diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
index aeb0094eafd8..841c863a08db 100644
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -8,6 +8,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/dst.h>
+#include <net/dst_metadata.h>
 #include <net/ip6_route.h>
 #include <net/route.h>
 #include <net/netfilter/nf_tables.h>
@@ -59,10 +60,11 @@ void nft_rt_get_eval(const struct nft_expr *expr,
 	u32 *dest = &regs->data[priv->dreg];
 	const struct dst_entry *dst;
 
-	dst = skb_dst(skb);
-	if (!dst)
+	if (!skb_valid_dst(skb))
 		goto err;
 
+	dst = skb_dst(skb);
+
 	switch (priv->key) {
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	case NFT_RT_CLASSID:
diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
index 8cec43064319..c8bba697f993 100644
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -12,6 +12,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/dst_metadata.h>
 #include <linux/in.h>
 #include <net/xfrm.h>
 
@@ -177,9 +178,15 @@ static void nft_xfrm_get_eval_out(const struct nft_xfrm *priv,
 				  struct nft_regs *regs,
 				  const struct nft_pktinfo *pkt)
 {
-	const struct dst_entry *dst = skb_dst(pkt->skb);
+	const struct dst_entry *dst;
 	int i;
 
+	if (!skb_valid_dst(pkt->skb)) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+
+	dst = skb_dst(pkt->skb);
 	for (i = 0; dst && dst->xfrm;
 	     dst = ((const struct xfrm_dst *)dst)->child, i++) {
 		if (i < priv->spnum)
-- 
2.47.3

