Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823F13B0AEA
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2026 23:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777591566; cv=none; b=EvN66PW2CS6xY4vEVCjGmAgkDhhUYnA1muQkPHG0nWFZGSFFQll3bHop5ev1sOw1vVZct52jDEmQMgSOxyzRcWxvY0OFoBsq+8wGgaqr5Jb0q81DrMIrAAnmsbELLFNHgY0rrcpQswyZPkxI67bocDWu3Bw8/wEkxay5aqnm5Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777591566; c=relaxed/simple;
	bh=lyhsb6VvxTcZtvsIlJEqA+nA1nIKPhbkXEEeL11ci6o=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=SSur+lJVflhHZ4EacUV6DyZLrjnnIQtS8kxrRl0DCS5OTPGDCYLmM3dNzVDCTMoyasQ8wgiLzVYIXB80erTf0coLA1ymyWUZzYmcOfk9pDcSqldmcqfPbX4rcmh4CS/iW/1PEnsObLnABghU5A2OBt/+l9mmn6gLcFsU5cJQVgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IzxzGW1E; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IzxzGW1E"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 31B06600B9
	for <netfilter-devel@vger.kernel.org>; Fri,  1 May 2026 01:26:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777591562;
	bh=Q6LQrWmQaS6LV2G0oUDbQ9jxXfYTKREsg1L4OPxs++A=;
	h=From:To:Subject:Date:From;
	b=IzxzGW1Eb+LV1Rip5lNHFhP5n2UYKQkQHok3GCOgL60zPF94PUYR2SXW2coKTejdv
	 JJvnR8bWx96APO+Y6jMkkv7Jns5lx31Gb8UKAw4ZXZ7DBipwBRF+kPOYOFFH+260if
	 i2pFzSDXL4pg916SVe46dG6paCfBbISi1imiBqzmjdwvgzOI06Ccrf3BNZ32ep8VBB
	 40vgIOEVw2tsYB7AYenNJga7CcBqobxwP1Qe+E/M0QQiUgkxT8jZrQrbJwT+a5k3do
	 JBZVLfu2Ts6WdYCA7u1dOLjKicjVdnsxOp/ynZO0OJoqEh0kmit3YGGicagZ8ZLtwV
	 Ek7AcSOVxobWA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v7 1/4] netfilter: flowtable: ensure sufficient headroom in xmit path
Date: Fri,  1 May 2026 01:25:55 +0200
Message-ID: <20260430232559.285492-1-pablo@netfilter.org>
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
v7: no changes

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

