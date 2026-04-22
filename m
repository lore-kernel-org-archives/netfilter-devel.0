Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84C022F767
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Apr 2026 18:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776882884; cv=none; b=rr/MfHye8OrQkv+YfTN+/M8aQQF/tpTDbmCnnYzRyXdbg9b6/OBs0S4OeLsBB5sN3Be4iMy0/8OyqnhcpgYENlIQNfgVjW6ZqCEnSq6CSnWnNvD7pzoF58/+fIsBNRdEDQDICAU1w2xQRbjnMYRXIGcgIkddc7i8UVl7DleAtGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776882884; c=relaxed/simple;
	bh=hGzP2lYMCo4QvpN2I8esGTeVwX6Ek1wZGvPJAQ7Ekq4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=GKYj3mTJab4H/fcaxUhzusf1O8hXhzaAxm4j8kMi66LT653qUxyg2rBBpe8a5Sd6BlBadcqZjM+UGbLMwSAosvp/CLHEakn76AClG+Y12QYBf/2eEqqkLlwwy+a49CAv6GWxyDJw3NmNGG0FCg+xlemNF6LC5kDPPjmsPyOxQZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Lohe2ZoE; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Lohe2ZoE"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9B35F60178
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Apr 2026 20:34:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776882872;
	bh=sV7tBI/ddYEK6pE0N5GS5pxvGpHY18e1WFFc43aQcmw=;
	h=From:To:Subject:Date:From;
	b=Lohe2ZoEEi2K3o80t9749+hxqAIJlVtZaSGcrS3ARMUMJNRs+ECEY63vD6v3x+sC6
	 h/+aFxMMfCAumIAwdmbm/j6eodjQni7GQOLlMw7UBOqpStLq/HOegv5iiamcA+bjF+
	 dEO4PR7juo5LUeN5oyUVV5DIDjUUzZ9oSpepsRsggugnols1LVwNz+CNUA9fRdAhhR
	 7wyPFulevd6bQ7C4ABcj9Fa5UQFMZP4B7S7eP5meIRfd1FjwZZzoGpTuYLKaztHZHD
	 bV9QNfmJcXkFyIQyrBGUGzS/7Rb41oyHdHXFiPtEbzR9H2lBPqAxaKK/Mrnmdx9K7B
	 ZErwzL7ldpEOA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v3 1/3] netfilter: replace skb_try_make_writable() by skb_ensure_writable()
Date: Wed, 22 Apr 2026 20:34:27 +0200
Message-ID: <20260422183429.240452-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

skb_try_make_writable() only works on clones and uncloned packets might
have their network header in paged fragments.

nft_fwd needs to work for the ingress and egress hooks, but the egress
hook where skb->data points to the mac header, use skb_network_offset()
to include the mac header. The flowtable is fine since it already uses
the transport offset.

Fixes: d32de98ea70f ("netfilter: nft_fwd_netdev: allow to forward packets via neighbour layer")
Fixes: 7d2086871762 ("netfilter: nf_flow_table: move ipv4 offload hook code to nf_flow_table")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: apparently I posted a patch version which does not compile.

 net/netfilter/nf_flow_table_ip.c | 4 ++--
 net/netfilter/nft_fwd_netdev.c   | 5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index fd56d663cb5b..dbd7644fdbeb 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -524,7 +524,7 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 		return 0;
 	}
 
-	if (skb_try_make_writable(skb, thoff + ctx->hdrsize))
+	if (skb_ensure_writable(skb, thoff + ctx->hdrsize))
 		return -1;
 
 	flow_offload_refresh(flow_table, flow, false);
@@ -1037,7 +1037,7 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 		return 0;
 	}
 
-	if (skb_try_make_writable(skb, thoff + ctx->hdrsize))
+	if (skb_ensure_writable(skb, thoff + ctx->hdrsize))
 		return -1;
 
 	flow_offload_refresh(flow_table, flow, false);
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 4bce36c3a6a0..2cc809303ce8 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -100,6 +100,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 	int oif = regs->data[priv->sreg_dev];
 	unsigned int verdict = NF_STOLEN;
 	struct sk_buff *skb = pkt->skb;
+	int nhoff = skb_network_offset(skb);
 	struct net_device *dev;
 	int neigh_table;
 
@@ -111,7 +112,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 			verdict = NFT_BREAK;
 			goto out;
 		}
-		if (skb_try_make_writable(skb, sizeof(*iph))) {
+		if (skb_ensure_writable(skb, nhoff + sizeof(*iph))) {
 			verdict = NF_DROP;
 			goto out;
 		}
@@ -132,7 +133,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 			verdict = NFT_BREAK;
 			goto out;
 		}
-		if (skb_try_make_writable(skb, sizeof(*ip6h))) {
+		if (skb_ensure_writable(skb, nhoff + sizeof(*ip6h))) {
 			verdict = NF_DROP;
 			goto out;
 		}
-- 
2.47.3

