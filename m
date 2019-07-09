Return-Path: <SRS0=D85U=VG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 725FDC73C5C
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jul 2019 20:56:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5716920861
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jul 2019 20:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbfGIU4b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Jul 2019 16:56:31 -0400
Received: from mail.us.es ([193.147.175.20]:37218 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729862AbfGIU43 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jul 2019 16:56:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 986C228804B4
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jul 2019 22:56:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 66452DA732
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jul 2019 22:56:26 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 52E95115101; Tue,  9 Jul 2019 22:56:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A576E114D70;
        Tue,  9 Jul 2019 22:56:22 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Jul 2019 22:56:22 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.194.134])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8EA7C4265A31;
        Tue,  9 Jul 2019 22:56:20 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
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
        cphealy@gmail.com, phil@nwl.cc, netfilter-devel@vger.kernel.org
Subject: [PATCH net-next,v4 09/12] net: sched: remove tcf block API
Date:   Tue,  9 Jul 2019 22:55:47 +0200
Message-Id: <20190709205550.3160-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190709205550.3160-1-pablo@netfilter.org>
References: <20190709205550.3160-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Unused, now replaced by flow block API.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: no changes.

 include/net/pkt_cls.h | 69 ------------------------------------
 net/sched/cls_api.c   | 98 ---------------------------------------------------
 2 files changed, 167 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 9cf606b88526..17c388090c3c 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -66,22 +66,6 @@ static inline struct Qdisc *tcf_block_q(struct tcf_block *block)
 	return block->q;
 }
 
-void *tcf_block_cb_priv(struct tcf_block_cb *block_cb);
-struct tcf_block_cb *tcf_block_cb_lookup(struct tcf_block *block,
-					 tc_setup_cb_t *cb, void *cb_ident);
-void tcf_block_cb_incref(struct tcf_block_cb *block_cb);
-unsigned int tcf_block_cb_decref(struct tcf_block_cb *block_cb);
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
 int __tc_indr_block_cb_register(struct net_device *dev, void *cb_priv,
 				tc_indr_block_bind_cb_t *cb, void *cb_ident);
 int tc_indr_block_cb_register(struct net_device *dev, void *cb_priv,
@@ -145,59 +129,6 @@ void tc_setup_cb_block_unregister(struct tcf_block *block, tc_setup_cb_t *cb,
 }
 
 static inline
-void *tcf_block_cb_priv(struct tcf_block_cb *block_cb)
-{
-	return NULL;
-}
-
-static inline
-struct tcf_block_cb *tcf_block_cb_lookup(struct tcf_block *block,
-					 tc_setup_cb_t *cb, void *cb_ident)
-{
-	return NULL;
-}
-
-static inline
-void tcf_block_cb_incref(struct tcf_block_cb *block_cb)
-{
-}
-
-static inline
-unsigned int tcf_block_cb_decref(struct tcf_block_cb *block_cb)
-{
-	return 0;
-}
-
-static inline
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
index 2f78b80c8251..0d5c07390267 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1512,43 +1512,6 @@ void tcf_block_put(struct tcf_block *block)
 
 EXPORT_SYMBOL(tcf_block_put);
 
-struct tcf_block_cb {
-	struct list_head list;
-	tc_setup_cb_t *cb;
-	void *cb_ident;
-	void *cb_priv;
-	unsigned int refcnt;
-};
-
-void *tcf_block_cb_priv(struct tcf_block_cb *block_cb)
-{
-	return block_cb->cb_priv;
-}
-EXPORT_SYMBOL(tcf_block_cb_priv);
-
-struct tcf_block_cb *tcf_block_cb_lookup(struct tcf_block *block,
-					 tc_setup_cb_t *cb, void *cb_ident)
-{	struct tcf_block_cb *block_cb;
-
-	list_for_each_entry(block_cb, &block->cb_list, list)
-		if (block_cb->cb == cb && block_cb->cb_ident == cb_ident)
-			return block_cb;
-	return NULL;
-}
-EXPORT_SYMBOL(tcf_block_cb_lookup);
-
-void tcf_block_cb_incref(struct tcf_block_cb *block_cb)
-{
-	block_cb->refcnt++;
-}
-EXPORT_SYMBOL(tcf_block_cb_incref);
-
-unsigned int tcf_block_cb_decref(struct tcf_block_cb *block_cb)
-{
-	return --block_cb->refcnt;
-}
-EXPORT_SYMBOL(tcf_block_cb_decref);
-
 static int
 tcf_block_playback_offloads(struct tcf_block *block, tc_setup_cb_t *cb,
 			    void *cb_priv, bool add, bool offload_in_use,
@@ -1590,67 +1553,6 @@ tcf_block_playback_offloads(struct tcf_block *block, tc_setup_cb_t *cb,
 	return err;
 }
 
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
-	block_cb = kzalloc(sizeof(*block_cb), GFP_KERNEL);
-	if (!block_cb)
-		return ERR_PTR(-ENOMEM);
-	block_cb->cb = cb;
-	block_cb->cb_ident = cb_ident;
-	block_cb->cb_priv = cb_priv;
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
-	block_cb = tcf_block_cb_lookup(block, cb, cb_ident);
-	if (!block_cb)
-		return;
-	__tcf_block_cb_unregister(block, block_cb);
-}
-EXPORT_SYMBOL(tcf_block_cb_unregister);
-
 static int tcf_block_bind(struct tcf_block *block,
 			  struct flow_block_offload *bo)
 {
-- 
2.11.0


