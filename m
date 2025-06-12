Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBBB23D280
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 13:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749735266; cv=none; b=EsYJ6bF4RBowxzbaq6pJsgYYcb9w99+XrQRTe46aFSpR8eufjdWXNXD+055X/ZWK4YmOLd7jRjRMhDq7y1qr5BhjFcD9R01DoZTqhfkRSahx3jKeKQCySgUPaIcTAtQ8LgEQ2oNsso5DwxkL8gYtrsf4zQ4UHJu9B/RVpfrgGRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749735266; c=relaxed/simple;
	bh=FTM+AmkuaWSkncGpM7Qp2pzQWdD9gB1SIoLemY655qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NfHHGWvNujViCNgmz2iKwAMkcLeIhpLhJ/Btyd5Cag773/KP15k+5t0o1DZeZr+niA+E9ggx6SpbW7vLcbxdbuzo82yeRPXDp5UwAuyY0iHCrG0VhAeZRf5QdIISc5ZWFpaUZVw0cX69p9BuY4JGefoOmnif+gXeQOts78XegGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ZCRMm5pw; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZCRMm5pw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ldW506LE5Y/L18MpsHGW07PtB5ZAyTrUVwdYhq7S72w=; b=ZCRMm5pwiFVm2EJtMZCAmG44/s
	1K5Br4/O0Guz77B3fC+jwKN//akzmGmHrL1prkl0PDGDHhklT3jtxvf+kZxnGYDhLVE0WWgyybh4I
	YeG29TGbe6MZHJxcMgA5JE8eqlDKNtcZT0uGJn74ItFKfOWT76yKIS0O9hA0yLMeggp8Y7MhfcTGb
	fJ81NZ7VGGLGDdML8A39kg8K0M+JDKJlvDURZwe4jvpCC7RpWZELz0aKasTGTTmzMC/trRa5GKIII
	5cCiDuOb1UUyhdGyDpEfMRn5wUOLr5ZBMcwcfjB/TSnt4oJj/mVINRgYhOnCwnYEPuRKQAtzCisT2
	gZP2mRcQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uPi4V-000000000sI-1i4K;
	Thu, 12 Jun 2025 15:34:23 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 1/3] netfilter: nf_tables: commit_notify: Support varying groups
Date: Thu, 12 Jun 2025 15:34:14 +0200
Message-ID: <20250612133416.18133-2-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250612133416.18133-1-phil@nwl.cc>
References: <20250612133416.18133-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expect users to enqueue notifications for various groups. The first
message for a new group will flush the existing batch and start a new
one.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 24c71ecb2179..da12a5424e6d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1193,13 +1193,16 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
 
 struct nftnl_skb_parms {
 	bool report;
+	unsigned int group;
 };
 #define NFT_CB(skb)	(*(struct nftnl_skb_parms*)&((skb)->cb))
 
-static void nft_notify_enqueue(struct sk_buff *skb, bool report,
+static void nft_notify_enqueue(struct sk_buff *skb,
+			       bool report, unsigned int group,
 			       struct list_head *notify_list)
 {
 	NFT_CB(skb).report = report;
+	NFT_CB(skb).group = group;
 	list_add_tail(&skb->list, notify_list);
 }
 
@@ -1229,7 +1232,8 @@ static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
 	}
 
 	nft_net = nft_pernet(ctx->net);
-	nft_notify_enqueue(skb, ctx->report, &nft_net->notify_list);
+	nft_notify_enqueue(skb, ctx->report, NFNLGRP_NFTABLES,
+			   &nft_net->notify_list);
 	return;
 err:
 	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
@@ -2100,7 +2104,8 @@ static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event,
 	}
 
 	nft_net = nft_pernet(ctx->net);
-	nft_notify_enqueue(skb, ctx->report, &nft_net->notify_list);
+	nft_notify_enqueue(skb, ctx->report, NFNLGRP_NFTABLES,
+			   &nft_net->notify_list);
 	return;
 err:
 	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
@@ -3714,7 +3719,8 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 		goto err;
 	}
 
-	nft_notify_enqueue(skb, ctx->report, &nft_net->notify_list);
+	nft_notify_enqueue(skb, ctx->report, NFNLGRP_NFTABLES,
+			   &nft_net->notify_list);
 	return;
 err:
 	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
@@ -4971,7 +4977,8 @@ static void nf_tables_set_notify(const struct nft_ctx *ctx,
 		goto err;
 	}
 
-	nft_notify_enqueue(skb, ctx->report, &nft_net->notify_list);
+	nft_notify_enqueue(skb, ctx->report, NFNLGRP_NFTABLES,
+			   &nft_net->notify_list);
 	return;
 err:
 	nfnetlink_set_err(ctx->net, portid, NFNLGRP_NFTABLES, -ENOBUFS);
@@ -6630,7 +6637,8 @@ static void nf_tables_setelem_notify(const struct nft_ctx *ctx,
 	}
 
 	nft_net = nft_pernet(net);
-	nft_notify_enqueue(skb, ctx->report, &nft_net->notify_list);
+	nft_notify_enqueue(skb, ctx->report, NFNLGRP_NFTABLES,
+			   &nft_net->notify_list);
 	return;
 err:
 	nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, -ENOBUFS);
@@ -8702,7 +8710,8 @@ __nft_obj_notify(struct net *net, const struct nft_table *table,
 		goto err;
 	}
 
-	nft_notify_enqueue(skb, report, &nft_net->notify_list);
+	nft_notify_enqueue(skb, report, NFNLGRP_NFTABLES,
+			   &nft_net->notify_list);
 	return;
 err:
 	nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, -ENOBUFS);
@@ -9614,7 +9623,8 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 		goto err;
 	}
 
-	nft_notify_enqueue(skb, ctx->report, &nft_net->notify_list);
+	nft_notify_enqueue(skb, ctx->report, NFNLGRP_NFTABLES,
+			   &nft_net->notify_list);
 	return;
 err:
 	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
@@ -10750,20 +10760,22 @@ static void nft_commit_notify(struct net *net, u32 portid)
 			continue;
 		}
 		len -= skb->len;
-		if (len > 0 && NFT_CB(skb).report == NFT_CB(batch_skb).report) {
+		if (len > 0 &&
+		    NFT_CB(skb).report == NFT_CB(batch_skb).report &&
+		    NFT_CB(skb).group == NFT_CB(batch_skb).group) {
 			data = skb_put(batch_skb, skb->len);
 			memcpy(data, skb->data, skb->len);
 			list_del(&skb->list);
 			kfree_skb(skb);
 			continue;
 		}
-		nfnetlink_send(batch_skb, net, portid, NFNLGRP_NFTABLES,
+		nfnetlink_send(batch_skb, net, portid, NFT_CB(batch_skb).group,
 			       NFT_CB(batch_skb).report, GFP_KERNEL);
 		goto new_batch;
 	}
 
 	if (batch_skb) {
-		nfnetlink_send(batch_skb, net, portid, NFNLGRP_NFTABLES,
+		nfnetlink_send(batch_skb, net, portid, NFT_CB(batch_skb).group,
 			       NFT_CB(batch_skb).report, GFP_KERNEL);
 	}
 
-- 
2.49.0

