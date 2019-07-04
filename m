Return-Path: <SRS0=ip/f=VB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8DE9C46495
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jul 2019 23:49:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A75A3216FD
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jul 2019 23:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbfGDXtb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Jul 2019 19:49:31 -0400
Received: from mail.us.es ([193.147.175.20]:33474 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727705AbfGDXta (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Jul 2019 19:49:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 307E981429
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Jul 2019 01:49:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D2DEEA0AC7
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Jul 2019 01:49:25 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C777D115109; Fri,  5 Jul 2019 01:49:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DAF5BDA7B6;
        Fri,  5 Jul 2019 01:49:22 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 05 Jul 2019 01:49:22 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A9C994265A31;
        Fri,  5 Jul 2019 01:49:21 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        peppe.cavallaro@st.com, grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ogerlitz@mellanox.com, Manish.Chopra@cavium.com,
        marcelo.leitner@gmail.com, mkubecek@suse.cz,
        venkatkumar.duvvuru@broadcom.com, maxime.chevallier@bootlin.com,
        cphealy@gmail.com
Subject: [PATCH 09/15 net-next,v2] net: sched: remove tcf_block_cb_{register,unregister}()
Date:   Fri,  5 Jul 2019 01:48:37 +0200
Message-Id: <20190704234843.6601-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190704234843.6601-1-pablo@netfilter.org>
References: <20190704234843.6601-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Now replaced by the tcf_block_setup() core registration, remove this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 include/net/pkt_cls.h | 41 +----------------------------------
 net/sched/cls_api.c   | 59 ---------------------------------------------------
 2 files changed, 1 insertion(+), 99 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index cc64dd45dfc2..52c11e390d9e 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -88,17 +88,7 @@ struct tcf_block_cb *tcf_block_cb_lookup(struct net *net, tc_setup_cb_t *cb,
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
@@ -218,35 +208,6 @@ unsigned int tcf_block_cb_decref(struct tcf_block_cb *block_cb)
 }
 
 static inline
-struct tcf_block_cb *__tcf_block_cb_register(struct tcf_block *block,
-					     tc_setup_cb_t *cb, void *cb_ident,
-					     void *cb_priv,
-					     struct netlink_ext_ack *extack)
-{
-	return NULL;
-}
-
-static inline
-int tcf_block_cb_register(struct tcf_block *block,
-			  tc_setup_cb_t *cb, void *cb_ident,
-			  void *cb_priv, struct netlink_ext_ack *extack)
-{
-	return 0;
-}
-
-static inline
-void __tcf_block_cb_unregister(struct tcf_block *block,
-			       struct tcf_block_cb *block_cb)
-{
-}
-
-static inline
-void tcf_block_cb_unregister(struct tcf_block *block,
-			     tc_setup_cb_t *cb, void *cb_ident)
-{
-}
-
-static inline
 int __tc_indr_block_cb_register(struct net_device *dev, void *cb_priv,
 				tc_indr_block_bind_cb_t *cb, void *cb_ident)
 {
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index e546d56c1a39..aa7ab707c399 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -797,65 +797,6 @@ void tcf_block_cb_remove(struct tcf_block_cb *block_cb,
 }
 EXPORT_SYMBOL(tcf_block_cb_remove);
 
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
-	block_cb = tcf_block_cb_alloc(block->net, cb, cb_ident, cb_priv, NULL);
-	if (IS_ERR(block_cb))
-		return block_cb;
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
-	block_cb = tcf_block_cb_lookup(block->net, cb, cb_ident);
-	if (!block_cb)
-		return;
-	__tcf_block_cb_unregister(block, block_cb);
-}
-EXPORT_SYMBOL(tcf_block_cb_unregister);
-
 static int tcf_block_bind(struct tcf_block *block, struct tc_block_offload *bo)
 {
 	struct tcf_block_cb *block_cb, *next;
-- 
2.11.0

