Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25BBDC4321A
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 00:34:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04A6D206C1
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 00:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730094AbfDZAeO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 20:34:14 -0400
Received: from mail.us.es ([193.147.175.20]:55330 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730013AbfDZAeG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 20:34:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A1B73B499D
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 02:34:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 943DDDA710
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 02:34:04 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 84A2FDA70A; Fri, 26 Apr 2019 02:34:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5EEF5DA713;
        Fri, 26 Apr 2019 02:34:02 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 26 Apr 2019 02:34:02 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0DB684265A31;
        Fri, 26 Apr 2019 02:34:02 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@mellanox.com,
        john.hurley@netronome.com, jakub.kicinski@netronome.com,
        ogerlitz@mellanox.com
Subject: [PATCH net-next,RFC 8/9] net: sched: remove tcf_block_cb_{register,unregister}()
Date:   Fri, 26 Apr 2019 02:33:46 +0200
Message-Id: <20190426003348.30745-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190426003348.30745-1-pablo@netfilter.org>
References: <20190426003348.30745-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Now replaced by the tcf_block_setup() core registration, remove this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/pkt_cls.h | 12 +----------
 net/sched/cls_api.c   | 59 ---------------------------------------------------
 2 files changed, 1 insertion(+), 70 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 8f0486a00d70..b61d0c89ba5b 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -83,17 +83,7 @@ struct tcf_block_cb *tcf_block_cb_lookup(u32 block_index, tc_setup_cb_t *cb,
 					 void *cb_ident);
 void tcf_block_cb_incref(struct tcf_block_cb *block_cb);
 unsigned int tcf_block_cb_decref(struct tcf_block_cb *block_cb);
-struct tcf_block_cb *__tcf_block_cb_register(struct tcf_block *block,
-					     tc_setup_cb_t *cb, void *cb_ident,
-					     void *cb_priv,
-					     struct netlink_ext_ack *extack);
-int tcf_block_cb_register(struct tcf_block *block,
-			  tc_setup_cb_t *cb, void *cb_ident,
-			  void *cb_priv, struct netlink_ext_ack *extack);
-void __tcf_block_cb_unregister(struct tcf_block *block,
-			       struct tcf_block_cb *block_cb);
-void tcf_block_cb_unregister(struct tcf_block *block,
-			     tc_setup_cb_t *cb, void *cb_ident);
+
 int __tc_indr_block_cb_register(struct net_device *dev, void *cb_priv,
 				tc_indr_block_bind_cb_t *cb, void *cb_ident);
 int tc_indr_block_cb_register(struct net_device *dev, void *cb_priv,
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index f7f6f42d58d1..bd8b08f158c0 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -799,65 +799,6 @@ void tcf_block_cb_list_move(struct tcf_block_cb *block_cb,
 }
 EXPORT_SYMBOL(tcf_block_cb_list_move);
 
-struct tcf_block_cb *__tcf_block_cb_register(struct tcf_block *block,
-					     tc_setup_cb_t *cb, void *cb_ident,
-					     void *cb_priv,
-					     struct netlink_ext_ack *extack)
-{
-	struct tcf_block_cb *block_cb;
-	int err;
-
-	/* Replay any already present rules */
-	err = tcf_block_playback_offloads(block, cb, cb_priv, true,
-					  tcf_block_offload_in_use(block),
-					  extack);
-	if (err)
-		return ERR_PTR(err);
-
-	block_cb = tcf_block_cb_alloc(block->index, cb, cb_ident, cb_priv, NULL);
-	if (!block_cb)
-		return ERR_PTR(-ENOMEM);
-
-	list_add(&block_cb->list, &block->cb_list);
-	return block_cb;
-}
-EXPORT_SYMBOL(__tcf_block_cb_register);
-
-int tcf_block_cb_register(struct tcf_block *block,
-			  tc_setup_cb_t *cb, void *cb_ident,
-			  void *cb_priv, struct netlink_ext_ack *extack)
-{
-	struct tcf_block_cb *block_cb;
-
-	block_cb = __tcf_block_cb_register(block, cb, cb_ident, cb_priv,
-					   extack);
-	return PTR_ERR_OR_ZERO(block_cb);
-}
-EXPORT_SYMBOL(tcf_block_cb_register);
-
-void __tcf_block_cb_unregister(struct tcf_block *block,
-			       struct tcf_block_cb *block_cb)
-{
-	tcf_block_playback_offloads(block, block_cb->cb, block_cb->cb_priv,
-				    false, tcf_block_offload_in_use(block),
-				    NULL);
-	list_del(&block_cb->list);
-	kfree(block_cb);
-}
-EXPORT_SYMBOL(__tcf_block_cb_unregister);
-
-void tcf_block_cb_unregister(struct tcf_block *block,
-			     tc_setup_cb_t *cb, void *cb_ident)
-{
-	struct tcf_block_cb *block_cb;
-
-	block_cb = tcf_block_cb_lookup(block->index, cb, cb_ident);
-	if (!block_cb)
-		return;
-	__tcf_block_cb_unregister(block, block_cb);
-}
-EXPORT_SYMBOL(tcf_block_cb_unregister);
-
 static int tcf_block_bind(struct tcf_block *block, struct tc_block_offload *bo)
 {
 	struct tcf_block_cb *block_cb, *failed_cb;
-- 
2.11.0

