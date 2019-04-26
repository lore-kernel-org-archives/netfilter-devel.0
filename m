Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4C7EC43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 00:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9ACF206C1
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 00:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbfDZAeE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 20:34:04 -0400
Received: from mail.us.es ([193.147.175.20]:55224 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729953AbfDZAeD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 20:34:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CB8A9B4986
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 02:34:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BBC81DA70F
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 02:34:01 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B17D5DA708; Fri, 26 Apr 2019 02:34:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8CD72DA702;
        Fri, 26 Apr 2019 02:33:59 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 26 Apr 2019 02:33:59 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3E7204265A31;
        Fri, 26 Apr 2019 02:33:59 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@mellanox.com,
        john.hurley@netronome.com, jakub.kicinski@netronome.com,
        ogerlitz@mellanox.com
Subject: [PATCH net-next,RFC 5/9] net: sched: add release callback to struct tcf_block_cb
Date:   Fri, 26 Apr 2019 02:33:42 +0200
Message-Id: <20190426003348.30745-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190426003348.30745-1-pablo@netfilter.org>
References: <20190426003348.30745-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Call it on tcf_block_cb object to release the private area.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/pkt_cls.h |  3 ++-
 net/sched/cls_api.c   | 10 ++++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index d40fcd8c502b..52a6484428ce 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -72,7 +72,8 @@ static inline struct Qdisc *tcf_block_q(struct tcf_block *block)
 }
 
 struct tcf_block_cb *tcf_block_cb_alloc(tc_setup_cb_t *cb,
-					void *cb_ident, void *cb_priv);
+					void *cb_ident, void *cb_priv,
+					void (*release)(void *cb_priv));
 void tcf_block_cb_free(struct tcf_block_cb *block_cb);
 void tcf_block_cb_list_add(struct tcf_block_cb *block_cb, struct list_head *cb_list);
 void tcf_block_cb_list_move(struct tcf_block_cb *block_cb, struct list_head *cb_list);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 3c16ac802dc4..963511ec758d 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -711,6 +711,7 @@ struct tcf_block_cb {
 	struct list_head global_list;
 	struct list_head list;
 	tc_setup_cb_t *cb;
+	void (*release)(void *cb_priv);
 	void *cb_ident;
 	void *cb_priv;
 	unsigned int refcnt;
@@ -753,7 +754,8 @@ unsigned int tcf_block_cb_decref(struct tcf_block_cb *block_cb)
 EXPORT_SYMBOL(tcf_block_cb_decref);
 
 struct tcf_block_cb *tcf_block_cb_alloc(tc_setup_cb_t *cb,
-					void *cb_ident, void *cb_priv)
+					void *cb_ident, void *cb_priv,
+					void (*release)(void *cb_priv))
 {
 	struct tcf_block_cb *block_cb;
 
@@ -763,6 +765,7 @@ struct tcf_block_cb *tcf_block_cb_alloc(tc_setup_cb_t *cb,
 
 	block_cb->cb = cb;
 	block_cb->cb_ident = cb_ident;
+	block_cb->release = release;
 	block_cb->cb_priv = cb_priv;
 
 	return block_cb;
@@ -771,6 +774,9 @@ EXPORT_SYMBOL(tcf_block_cb_alloc);
 
 void tcf_block_cb_free(struct tcf_block_cb *block_cb)
 {
+	if (block_cb->release)
+		block_cb->release(block_cb->cb_priv);
+
 	kfree(block_cb);
 }
 EXPORT_SYMBOL(tcf_block_cb_free);
@@ -804,7 +810,7 @@ struct tcf_block_cb *__tcf_block_cb_register(struct tcf_block *block,
 	if (err)
 		return ERR_PTR(err);
 
-	block_cb = tcf_block_cb_alloc(cb, cb_ident, cb_priv);
+	block_cb = tcf_block_cb_alloc(cb, cb_ident, cb_priv, NULL);
 	if (!block_cb)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.11.0

