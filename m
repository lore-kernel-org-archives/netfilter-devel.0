Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D553A3A5E67
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2026 20:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777580755; cv=none; b=PgtBGNSGgFsqKEffWb8pWWNF9YcHzH++J6PhQLfjpmLgn2meF4Lktvwpy1xx8xc0DWf3J3+udamHbwJX2CfWwvWZfWm7vDwMx0aeR0h7c90nFedPrMSHiUkKzH9G0pZFjLgImUO6g09WouigA4ztgXWcIAHH0XLZ6JmMmE2Rxcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777580755; c=relaxed/simple;
	bh=XiaLhc82AWSwA/xbvDKYzddYX2MAEQ5dMhRdEWNzMYE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=pKj5Mc1DVCWkXrarvF3wx6YFMcrswYKPWjnbZDfFJcgoD8yd0yQW2mzQ5o4S1K9a8e6r4f7tUogPHuzaok9tODmDdaNVltfKZ6AQRxEUX6AQOObvs/aePaMpcQcfX37kjzb+58DIZsCbjPk7J/Ytlh4QDhBB8IElpvT3rfv/uqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FR0nSf4K; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FR0nSf4K"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 70C42600B9
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2026 22:25:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777580750;
	bh=R5eYrL/OJys5c/cCDLts4eZUN1k2IbSq4iDqkDEFXac=;
	h=From:To:Subject:Date:From;
	b=FR0nSf4KWBOF6XbWyedke6OlNPhomS6mlNWHGNcfjN6mEPW/AbSKI2P9t6z6Weauk
	 IEGkthM/mTpX2e8/M1q/HG1iiFkgk5U55Bq2ACJjdQUorXZGWNFCbzWYYVEDXEr7hb
	 Nd29dDHKgnBmL7ST9rvXqk4V/FJdS7DOdwm2ieYLDH9j02NUkn1UIYsVh8oWQRd6Bt
	 B9kDaga7nRfg0dFgn1tt6uQ7bwikTP7k5Xu0tny2uBb3peo7Nj9f/QdGBJAV1T1SHZ
	 gMbWyCAAdGbqj7hWQDkwyT1D+I9BBvzqKdiWZAnprgioIeDy1o+ANAvpUSSrhURY3f
	 kHG9/CamVtTmA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v6 1/4] netfilter: flowtable: ensure sufficient headroom in xmit path
Date: Thu, 30 Apr 2026 22:25:44 +0200
Message-ID: <20260430202547.274256-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check for headroom and call skb_expand_head() like in the IP output
path to ensure there is sufficient headroom for the mac header when
forwarding this packet as suggested by sashiko.

Fixes: b5964aac51e0 ("netfilter: flowtable: consolidate xmit path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v6: no changes

 net/netfilter/nf_flow_table_ip.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index dbd7644fdbeb..8d5fb7e940a1 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -471,8 +471,17 @@ struct nf_flow_xmit {
 static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
 				       struct nf_flow_xmit *xmit)
 {
-	skb->dev = xmit->outdev;
-	dev_hard_header(skb, skb->dev, ntohs(skb->protocol),
+	struct net_device *dev = xmit->outdev;
+	unsigned int hh_len = LL_RESERVED_SPACE(dev);
+
+	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
+		skb = skb_expand_head(skb, hh_len);
+		if (!skb)
+			return NF_STOLEN;
+	}
+
+	skb->dev = dev;
+	dev_hard_header(skb, dev, ntohs(skb->protocol),
 			xmit->dest, xmit->source, skb->len);
 	dev_queue_xmit(skb);
 
-- 
2.47.3

