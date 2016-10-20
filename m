From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: nft_ct: add notrack support
Date: Thu, 20 Oct 2016 18:07:14 +0200
Message-ID: <1476979636-1314-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49692 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933738AbcJTQH3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Oct 2016 12:07:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2E05E80F5
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 18:07:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1A27FBAC22
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 18:07:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7E67FBAC22
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 18:07:23 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds notrack support.

I decided to add a new expression, given that this doesn't fit into the
existing set operation. Notrack doesn't need a source register, and an
hypothetical NFT_CT_NOTRACK key makes no sense since matching the
untracked state is done through NFT_CT_STATE.

I'm placing this new notrack expression into nft_ct.c, I think a single
module is too much.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_ct.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index d7b0d171172a..6837348c8993 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2008-2009 Patrick McHardy <kaber@trash.net>
+ * Copyright (c) 2016 Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -518,15 +519,61 @@ static struct nft_expr_type nft_ct_type __read_mostly = {
 	.owner		= THIS_MODULE,
 };
 
+static void nft_notrack_eval(const struct nft_expr *expr,
+			     struct nft_regs *regs,
+			     const struct nft_pktinfo *pkt)
+{
+	struct sk_buff *skb = pkt->skb;
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+
+	ct = nf_ct_get(pkt->skb, &ctinfo);
+	/* Previously seen (loopback or untracked)?  Ignore. */
+	if (ct)
+		return;
+
+	ct = nf_ct_untracked_get();
+	atomic_inc(&ct->ct_general.use);
+	skb->nfct = &ct->ct_general;
+	skb->nfctinfo = IP_CT_NEW;
+}
+
+static struct nft_expr_type nft_notrack_type;
+static const struct nft_expr_ops nft_notrack_ops = {
+	.type		= &nft_notrack_type,
+	.size		= NFT_EXPR_SIZE(0),
+	.eval		= nft_notrack_eval,
+};
+
+static struct nft_expr_type nft_notrack_type __read_mostly = {
+	.name		= "notrack",
+	.ops		= &nft_notrack_ops,
+	.owner		= THIS_MODULE,
+};
+
 static int __init nft_ct_module_init(void)
 {
+	int err;
+
 	BUILD_BUG_ON(NF_CT_LABELS_MAX_SIZE > NFT_REG_SIZE);
 
-	return nft_register_expr(&nft_ct_type);
+	err = nft_register_expr(&nft_ct_type);
+	if (err < 0)
+		return err;
+
+	err = nft_register_expr(&nft_notrack_type);
+	if (err < 0)
+		goto err1;
+
+	return 0;
+err1:
+	nft_unregister_expr(&nft_ct_type);
+	return err;
 }
 
 static void __exit nft_ct_module_exit(void)
 {
+	nft_unregister_expr(&nft_notrack_type);
 	nft_unregister_expr(&nft_ct_type);
 }
 
@@ -536,3 +583,4 @@ module_exit(nft_ct_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_ALIAS_NFT_EXPR("ct");
+MODULE_ALIAS_NFT_EXPR("notrack");
-- 
2.1.4

