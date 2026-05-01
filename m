Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB1D39E19A;
	Fri,  1 May 2026 12:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777638179; cv=none; b=CfuiRbGKtUT+aoYqa4TonwD9qmFwvDWSDSbpuDuO23Aa2nNuEKdIuRGZs9+WkiNSOBGUhf2IIRZ87uBkCDEPXki4hf65BlA2EYzWyvc5rWlrjPPBc/3y28yPSTRYwZwZ8f8eYaWieyCv3jN3Kx7WmYnzg/NEap3PGiYy/J01iAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777638179; c=relaxed/simple;
	bh=vw8V2bgEokAN79/9zttZ98KDTtS44QsRqi7No3AoXFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewxYdgi1Or0w0nRoosL0Hz8YyuIVSp4SByirUKOC42X+uUEFGGNEBE99qHXBt8htcnmXT+3XsyaohVUuxNMxYhlBxMz+fqtZ/L1tpMz6MsedBPdy3juVs5AwSRbnJAGOZgVerUGLB7hE9Yg7NqEnBj2Fe+zwVBH+LQcX8dhlAUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FJ7wJpX2; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FJ7wJpX2"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 77E9960253;
	Fri,  1 May 2026 14:22:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777638176;
	bh=mcnUQt9LLvOexCF57nZXeIuY1C0t9ce1MbG6y5d+u/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJ7wJpX2QNoUO2H82eEvYS9QGvwWID2BjUBqInVWp5Q/y0bTQePG7v2iAIhDlkCfg
	 j68Z3SV2XzYCkBvANwyE7MBJhaHLuEjHxW/uCCS2+hdXRskN5UdNzLInMUaEbMD7/X
	 QjedjHwN+g1KIj1LSwczcfWb2qN/bxlM7XDKSBOq4Wk9n2WpQW9XdOxZnyJQKCgXuh
	 Zr3VIqL2VPDmcVYtTb8lu+KpGnG6O49UUZX+BsaMFuZKtcsuaWw896Zdrj9SPaq/Q/
	 Th2NjgmKsfrUDQVnWzzTn2eK1q5VJeH0bl1X5X5uD2zV8RT715hjqgo39NQ2s8Q7aT
	 MAswOYXU/l2tQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 11/14] netfilter: flowtable: ensure sufficient headroom in xmit path
Date: Fri,  1 May 2026 14:22:34 +0200
Message-ID: <20260501122237.296262-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260501122237.296262-1-pablo@netfilter.org>
References: <20260501122237.296262-1-pablo@netfilter.org>
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

