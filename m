Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D37623505E
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 22:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777330177; cv=none; b=UdcJwZnvha8wmFXoeAigGDrg6bq4Mlju6TrLtliDXAfiXRR7gpix/GIvN7oZNVHekrvOkDX/yNqBQmPVR9zwxBcMoQ9roBPVxyaZlf8VAkjtJd0Go0p6eSVqBrpfEboOiAOQK1mlAIE34ZXlY2do6HOIA4L1qL+dvLo2wQdPQVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777330177; c=relaxed/simple;
	bh=zoAbIRrdAKFpOVTrxKdkyEu/qfxQtjayieagMLT+Nh8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUFfsSv81wMsxDFNQ7Wg2rR2Aq6yE6qTBNPz84MqZMSaAPgaEfOBTuVYxDEvi8vx7zajMPpS2QLZu+zALZA+KbjU6u9Ld/kQYYBnhZACNUuiAgnbb6uFHUips26jC6C/A9++TJTvQruQ6/dw7eM4gJyH2hrdvIQHWfOhRGJ9orQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kjBr7p5y; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kjBr7p5y"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D610F6024E
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2026 00:49:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777330174;
	bh=EQCBMVFfc2pT8teCqSidZbSDdheBUZC2P5L7/mhKd7I=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=kjBr7p5yK5uUewaFLfiI1DTjA3/SCQvX9uWnQMYrTqVi88078GDxrfAoeYuZNy89K
	 1GzQPtQiRJCu4D329E/CI3+Wui4UcXa/2lYx3ZtgWMDQ1N9NqVkxOA6FZdQGbXILfG
	 sxQW389X31+1B++3/WnMTJMPea1fZ3tGGLHcSdOQOl9TDcV8r92Lt7MZnAzkk+sezZ
	 Dn6no0AXtrg6oSSjTSnXuBWPviZSe34nv+UDoLWRYDali8vbMZvejceo9LTOL1Furq
	 4AiV1oVHmie3Vq0e3+V4BqO5cL4rCJkZ07ZdMsMHfUqnerpTn6uj+M+AsRfpNo1N4a
	 T/QxAEO4iyKLg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v7 2/3] netfilter: nft_fwd_netdev: add device and headroom validate with neigh forwarding
Date: Tue, 28 Apr 2026 00:49:28 +0200
Message-ID: <20260427224929.29868-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260427224929.29868-1-pablo@netfilter.org>
References: <20260427224929.29868-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ttl field has been decremented already and evaluation of this rule
would proceed, just drop this packet instead if there is no destination
device to forwards this packet. This is exactly what nf_dup already does
in this case.

Moreover, check for headroom and call skb_expand_head() like in the IP
output path to ensure there is sufficient headroom when forwarding this
via neigh_xmit().

Fixes: d32de98ea70f ("netfilter: nft_fwd_netdev: allow to forward packets via neighbour layer")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_fwd_netdev.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 2cc809303ce8..605b1d42abce 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -102,6 +102,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 	struct sk_buff *skb = pkt->skb;
 	int nhoff = skb_network_offset(skb);
 	struct net_device *dev;
+	unsigned int hh_len;
 	int neigh_table;
 
 	switch (priv->nfproto) {
@@ -153,8 +154,19 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 	}
 
 	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
-	if (dev == NULL)
-		return;
+	if (dev == NULL) {
+		verdict = NF_DROP;
+		goto out;
+	}
+
+	hh_len = LL_RESERVED_SPACE(dev);
+	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
+		skb = skb_expand_head(skb, hh_len);
+		if (!skb) {
+			verdict = NF_STOLEN;
+			goto out;
+		}
+	}
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
-- 
2.47.3

