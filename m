Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 627AFC43218
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 00:34:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45B07206C1
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 00:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730022AbfDZAeF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 20:34:05 -0400
Received: from mail.us.es ([193.147.175.20]:55234 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729885AbfDZAeD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 20:34:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 145CDB497C
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 02:34:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 03D03DA703
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 02:34:01 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EAA89DA708; Fri, 26 Apr 2019 02:34:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C3B4ADA703;
        Fri, 26 Apr 2019 02:33:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 26 Apr 2019 02:33:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 726CC4265A31;
        Fri, 26 Apr 2019 02:33:58 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@mellanox.com,
        john.hurley@netronome.com, jakub.kicinski@netronome.com,
        ogerlitz@mellanox.com
Subject: [PATCH net-next,RFC 4/9] net: sched: add tcf_block_setup()
Date:   Fri, 26 Apr 2019 02:33:41 +0200
Message-Id: <20190426003348.30745-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190426003348.30745-1-pablo@netfilter.org>
References: <20190426003348.30745-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This new function allows us to handle tcf_block_cb registrations /
unregistrations from the core, in order to remove a dependency with the
tcf_block object and the .reoffload cls_api callback.

This patch adds a global tcf_block_cb_list, to find block objects based
on the block index field that tells what tcf_block owns this
tcf_block_cb object.

The tcf_block_cb_list_add() call places the tcf_block_cb object that has
been set up from the driver in the tc_block_offload->cb_list that is
used to convey this tcf_block_cb object back to the core for
registration / unregistration.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/pkt_cls.h |   4 ++
 net/sched/cls_api.c   | 105 +++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 107 insertions(+), 2 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 565775289b41..d40fcd8c502b 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -74,6 +74,9 @@ static inline struct Qdisc *tcf_block_q(struct tcf_block *block)
 struct tcf_block_cb *tcf_block_cb_alloc(tc_setup_cb_t *cb,
 					void *cb_ident, void *cb_priv);
 void tcf_block_cb_free(struct tcf_block_cb *block_cb);
+void tcf_block_cb_list_add(struct tcf_block_cb *block_cb, struct list_head *cb_list);
+void tcf_block_cb_list_move(struct tcf_block_cb *block_cb, struct list_head *cb_list);
+
 void *tcf_block_cb_priv(struct tcf_block_cb *block_cb);
 struct tcf_block_cb *tcf_block_cb_lookup(struct tcf_block *block,
 					 tc_setup_cb_t *cb, void *cb_ident);
@@ -643,6 +646,7 @@ enum tc_block_command {
 struct tc_block_offload {
 	enum tc_block_command command;
 	enum tcf_block_binder_type binder_type;
+	struct list_head cb_list;
 	struct tcf_block *block;
 	struct netlink_ext_ack *extack;
 };
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 9f61a2c3cf6f..3c16ac802dc4 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -708,6 +708,7 @@ tcf_block_playback_offloads(struct tcf_block *block, tc_setup_cb_t *cb,
 }
 
 struct tcf_block_cb {
+	struct list_head global_list;
 	struct list_head list;
 	tc_setup_cb_t *cb;
 	void *cb_ident;
@@ -726,6 +727,8 @@ void *tcf_block_cb_priv(struct tcf_block_cb *block_cb)
 }
 EXPORT_SYMBOL(tcf_block_cb_priv);
 
+static LIST_HEAD(tcf_block_cb_list);
+
 struct tcf_block_cb *tcf_block_cb_lookup(struct tcf_block *block,
 					 tc_setup_cb_t *cb, void *cb_ident)
 {	struct tcf_block_cb *block_cb;
@@ -772,6 +775,20 @@ void tcf_block_cb_free(struct tcf_block_cb *block_cb)
 }
 EXPORT_SYMBOL(tcf_block_cb_free);
 
+void tcf_block_cb_list_add(struct tcf_block_cb *block_cb,
+			   struct list_head *cb_list)
+{
+	list_add(&block_cb->global_list, cb_list);
+}
+EXPORT_SYMBOL(tcf_block_cb_list_add);
+
+void tcf_block_cb_list_move(struct tcf_block_cb *block_cb,
+			    struct list_head *cb_list)
+{
+	list_move(&block_cb->global_list, cb_list);
+}
+EXPORT_SYMBOL(tcf_block_cb_list_move);
+
 struct tcf_block_cb *__tcf_block_cb_register(struct tcf_block *block,
 					     tc_setup_cb_t *cb, void *cb_ident,
 					     void *cb_priv,
@@ -831,6 +848,78 @@ void tcf_block_cb_unregister(struct tcf_block *block,
 }
 EXPORT_SYMBOL(tcf_block_cb_unregister);
 
+static int tcf_block_bind(struct tcf_block *block, struct tc_block_offload *bo)
+{
+	struct tcf_block_cb *block_cb, *failed_cb;
+	int err, i = 0;
+
+	list_for_each_entry(block_cb, &bo->cb_list, global_list) {
+		err = tcf_block_playback_offloads(block, block_cb->cb,
+						  block_cb->cb_priv, true,
+						  tcf_block_offload_in_use(block),
+						  bo->extack);
+		if (err) {
+			failed_cb = block_cb;
+			goto err_unroll;
+		}
+		list_add(&block_cb->list, &block->cb_list);
+		i++;
+	}
+	list_splice(&bo->cb_list, &tcf_block_cb_list);
+
+	return 0;
+
+err_unroll:
+	list_for_each_entry(block_cb, &bo->cb_list, global_list) {
+		if (i-- > 0) {
+			list_del(&block_cb->list);
+			tcf_block_playback_offloads(block, block_cb->cb,
+						    block_cb->cb_priv, false,
+						    tcf_block_offload_in_use(block),
+						    NULL);
+		}
+		kfree(block_cb);
+	}
+
+	return err;
+}
+
+static void tcf_block_unbind(struct tcf_block *block,
+			     struct tc_block_offload *bo)
+{
+	struct tcf_block_cb *block_cb, *next;
+
+	list_for_each_entry_safe(block_cb, next, &bo->cb_list, global_list) {
+		list_del(&block_cb->global_list);
+		tcf_block_playback_offloads(block, block_cb->cb,
+					    block_cb->cb_priv, false,
+					    tcf_block_offload_in_use(block),
+					    NULL);
+		list_del(&block_cb->list);
+		tcf_block_cb_free(block_cb);
+	}
+}
+
+static int tcf_block_setup(struct tcf_block *block, struct tc_block_offload *bo)
+{
+	int err;
+
+	switch (bo->command) {
+	case TC_BLOCK_BIND:
+		err = tcf_block_bind(block, bo);
+		break;
+	case TC_BLOCK_UNBIND:
+		err = 0;
+		tcf_block_unbind(block, bo);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		err = -EOPNOTSUPP;
+	}
+
+	return err;
+}
+
 static struct rhashtable indr_setup_block_ht;
 
 struct tc_indr_block_dev {
@@ -947,12 +1036,14 @@ static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
 		.binder_type	= TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
 		.block		= indr_dev->block,
 	};
+	INIT_LIST_HEAD(&bo.cb_list);
 
 	if (!indr_dev->block)
 		return;
 
 	indr_block_cb->cb(indr_dev->dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
 			  &bo);
+	tcf_block_setup(indr_dev->block, &bo);
 }
 
 int __tc_indr_block_cb_register(struct net_device *dev, void *cb_priv,
@@ -1036,6 +1127,7 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 		.block		= block,
 		.extack		= extack,
 	};
+	INIT_LIST_HEAD(&bo.cb_list);
 
 	indr_dev = tc_indr_block_dev_lookup(dev);
 	if (!indr_dev)
@@ -1043,9 +1135,11 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 
 	indr_dev->block = command == TC_BLOCK_BIND ? block : NULL;
 
-	list_for_each_entry(indr_block_cb, &indr_dev->cb_list, list)
+	list_for_each_entry(indr_block_cb, &indr_dev->cb_list, list) {
 		indr_block_cb->cb(dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
 				  &bo);
+		tcf_block_setup(block, &bo);
+	}
 }
 
 static int tcf_block_offload_cmd(struct tcf_block *block,
@@ -1055,12 +1149,19 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
 				 struct netlink_ext_ack *extack)
 {
 	struct tc_block_offload bo = {};
+	int err;
 
 	bo.command = command;
 	bo.binder_type = ei->binder_type;
 	bo.block = block;
 	bo.extack = extack;
-	return dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
+	INIT_LIST_HEAD(&bo.cb_list);
+
+	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
+	if (err < 0)
+		return err;
+
+	return tcf_block_setup(block, &bo);
 }
 
 static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
-- 
2.11.0

