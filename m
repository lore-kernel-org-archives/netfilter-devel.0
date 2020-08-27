Return-Path: <SRS0=Uzq3=CF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED21BC433E1
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Aug 2020 17:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B38B02087C
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Aug 2020 17:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgH0R2y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Aug 2020 13:28:54 -0400
Received: from correo.us.es ([193.147.175.20]:45394 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbgH0R2x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Aug 2020 13:28:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A480218CDC4
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2020 19:28:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 94E5DDA78A
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2020 19:28:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8A905DA73D; Thu, 27 Aug 2020 19:28:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 42E58DA78C;
        Thu, 27 Aug 2020 19:28:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 27 Aug 2020 19:28:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 12B4741E4800;
        Thu, 27 Aug 2020 19:28:46 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, fw@strlen.de, eric@garver.life
Subject: [PATCH] netfilter: nf_tables: coalesce multiple notifications into one skbuff
Date:   Thu, 27 Aug 2020 19:28:42 +0200
Message-Id: <20200827172842.24478-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On x86_64, each notification results in one skbuff allocation which
consumes at least 768 bytes due to the skbuff overhead.

This patch coalesces several notifications into one single skbuff, so
each notification consumes at least ~211 bytes, that ~3.5 times less
memory consumption. As a result, this is reducing the chances to exhaust
the netlink socket receive buffer.

Rule of thumb is that each notification batch only contains netlink
messages whose report flag is the same, nfnetlink_send() requires this
to do appropriately delivery to userspace, either via unicast (echo
mode) or multicast (monitor mode).

The skbuff control buffer is used to annotate the report flag for later
handling at the new coalescing routine.

The batch skbuff notification size is NLMSG_GOODSIZE, using a larger
skbuff would allow for more socket receiver buffer savings (to amortize
the cost of the skbuff even more), however, going over that size might
break userspace applications, so let's be conservative and stick to
NLMSG_GOODSIZE.

Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Phil: I don't know yet where to target this patch to, if this helps
       firewalld's issue, it might be a good option to enqueue this
       for nf.git

As a side note, it should be possible to skip alloc_skb() from _notify()
then memcpy() and kfree_skb(), ie. start batching a bit earlier, but I
leave this for the future in favour of this simplistic approach.

 include/net/netns/nftables.h  |  1 +
 net/netfilter/nf_tables_api.c | 71 ++++++++++++++++++++++++++++-------
 2 files changed, 59 insertions(+), 13 deletions(-)

diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
index a1a8d45adb42..6c0806bd8d1e 100644
--- a/include/net/netns/nftables.h
+++ b/include/net/netns/nftables.h
@@ -8,6 +8,7 @@ struct netns_nftables {
 	struct list_head	tables;
 	struct list_head	commit_list;
 	struct list_head	module_list;
+	struct list_head	notify_list;
 	struct mutex		commit_mutex;
 	unsigned int		base_seq;
 	u8			gencursor;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b7dc1cbf40ea..c77f250ffe8a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -684,6 +684,18 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
 	return -1;
 }
 
+struct nftnl_skb_parms {
+	bool report;
+};
+#define NFT_CB(skb)	(*(struct nftnl_skb_parms*)&((skb)->cb))
+
+static void nft_notify_enqueue(struct sk_buff *skb, bool report,
+			       struct list_head *notify_list)
+{
+	NFT_CB(skb).report = report;
+	list_add_tail(&skb->list, notify_list);
+}
+
 static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
 {
 	struct sk_buff *skb;
@@ -715,8 +727,7 @@ static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
 		goto err;
 	}
 
-	nfnetlink_send(skb, ctx->net, ctx->portid, NFNLGRP_NFTABLES,
-		       ctx->report, GFP_KERNEL);
+	nft_notify_enqueue(skb, ctx->report, &ctx->net->nft.notify_list);
 	return;
 err:
 	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
@@ -1468,8 +1479,7 @@ static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event)
 		goto err;
 	}
 
-	nfnetlink_send(skb, ctx->net, ctx->portid, NFNLGRP_NFTABLES,
-		       ctx->report, GFP_KERNEL);
+	nft_notify_enqueue(skb, ctx->report, &ctx->net->nft.notify_list);
 	return;
 err:
 	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
@@ -2807,8 +2817,7 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 		goto err;
 	}
 
-	nfnetlink_send(skb, ctx->net, ctx->portid, NFNLGRP_NFTABLES,
-		       ctx->report, GFP_KERNEL);
+	nft_notify_enqueue(skb, ctx->report, &ctx->net->nft.notify_list);
 	return;
 err:
 	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
@@ -3837,8 +3846,7 @@ static void nf_tables_set_notify(const struct nft_ctx *ctx,
 		goto err;
 	}
 
-	nfnetlink_send(skb, ctx->net, portid, NFNLGRP_NFTABLES, ctx->report,
-		       gfp_flags);
+	nft_notify_enqueue(skb, ctx->report, &ctx->net->nft.notify_list);
 	return;
 err:
 	nfnetlink_set_err(ctx->net, portid, NFNLGRP_NFTABLES, -ENOBUFS);
@@ -4959,8 +4967,7 @@ static void nf_tables_setelem_notify(const struct nft_ctx *ctx,
 		goto err;
 	}
 
-	nfnetlink_send(skb, net, portid, NFNLGRP_NFTABLES, ctx->report,
-		       GFP_KERNEL);
+	nft_notify_enqueue(skb, ctx->report, &ctx->net->nft.notify_list);
 	return;
 err:
 	nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, -ENOBUFS);
@@ -6275,7 +6282,7 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
 		goto err;
 	}
 
-	nfnetlink_send(skb, net, portid, NFNLGRP_NFTABLES, report, gfp);
+	nft_notify_enqueue(skb, report, &net->nft.notify_list);
 	return;
 err:
 	nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, -ENOBUFS);
@@ -7085,8 +7092,7 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 		goto err;
 	}
 
-	nfnetlink_send(skb, ctx->net, ctx->portid, NFNLGRP_NFTABLES,
-		       ctx->report, GFP_KERNEL);
+	nft_notify_enqueue(skb, ctx->report, &ctx->net->nft.notify_list);
 	return;
 err:
 	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
@@ -7695,6 +7701,42 @@ static void nf_tables_commit_release(struct net *net)
 	mutex_unlock(&net->nft.commit_mutex);
 }
 
+static void nft_commit_notify(struct net *net, u32 portid)
+{
+	struct sk_buff *batch_skb = NULL, *nskb, *skb;
+	unsigned char *data;
+	int len;
+
+	list_for_each_entry_safe(skb, nskb, &net->nft.notify_list, list) {
+		if (!batch_skb) {
+new_batch:
+			batch_skb = skb;
+			NFT_CB(batch_skb).report = NFT_CB(skb).report;
+			len = NLMSG_GOODSIZE;
+			list_del(&skb->list);
+			continue;
+		}
+		len -= skb->len;
+		if (len > 0 && NFT_CB(skb).report == NFT_CB(batch_skb).report) {
+			data = skb_put(batch_skb, skb->len);
+			memcpy(data, skb->data, skb->len);
+			list_del(&skb->list);
+			kfree_skb(skb);
+			continue;
+		}
+		nfnetlink_send(batch_skb, net, portid, NFNLGRP_NFTABLES,
+			       NFT_CB(batch_skb).report, GFP_KERNEL);
+		goto new_batch;
+	}
+
+	if (batch_skb) {
+		nfnetlink_send(batch_skb, net, portid, NFNLGRP_NFTABLES,
+			       NFT_CB(batch_skb).report, GFP_KERNEL);
+	}
+
+	WARN_ON_ONCE(!list_empty(&net->nft.notify_list));
+}
+
 static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 {
 	struct nft_trans *trans, *next;
@@ -7897,6 +7939,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		}
 	}
 
+	nft_commit_notify(net, NETLINK_CB(skb).portid);
 	nf_tables_gen_notify(net, skb, NFT_MSG_NEWGEN);
 	nf_tables_commit_release(net);
 
@@ -8721,6 +8764,7 @@ static int __net_init nf_tables_init_net(struct net *net)
 	INIT_LIST_HEAD(&net->nft.tables);
 	INIT_LIST_HEAD(&net->nft.commit_list);
 	INIT_LIST_HEAD(&net->nft.module_list);
+	INIT_LIST_HEAD(&net->nft.notify_list);
 	mutex_init(&net->nft.commit_mutex);
 	net->nft.base_seq = 1;
 	net->nft.validate_state = NFT_VALIDATE_SKIP;
@@ -8737,6 +8781,7 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 	mutex_unlock(&net->nft.commit_mutex);
 	WARN_ON_ONCE(!list_empty(&net->nft.tables));
 	WARN_ON_ONCE(!list_empty(&net->nft.module_list));
+	WARN_ON_ONCE(!list_empty(&net->nft.notify_list));
 }
 
 static struct pernet_operations nf_tables_net_ops = {
-- 
2.20.1

