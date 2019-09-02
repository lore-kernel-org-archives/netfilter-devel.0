Return-Path: <SRS0=j12K=W5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A73AC3A59E
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 21:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7594920870
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 21:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbfIBVLk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 17:11:40 -0400
Received: from correo.us.es ([193.147.175.20]:47164 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbfIBVLk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 17:11:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 36337172C76
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Sep 2019 23:11:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 277DC9D56E
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Sep 2019 23:11:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1D2B0DA72F; Mon,  2 Sep 2019 23:11:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BF218DA8E8;
        Mon,  2 Sep 2019 23:11:33 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 02 Sep 2019 23:11:33 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9BAD64265A5A;
        Mon,  2 Sep 2019 23:11:33 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     wenxu@ucloud.cn
Subject: [PATCH nf-next 1/2] netfilter: nf_tables_offload: move indirect flow_block callback logic to core
Date:   Mon,  2 Sep 2019 23:11:31 +0200
Message-Id: <20190902211132.32200-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add nft_offload_init() and nft_offload_exit() function to deal with the
init and the exit path of the offload infrastructure.

Rename nft_indr_block_get_and_ing_cmd() to nft_indr_block_cb().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_offload.h |  3 +++
 net/netfilter/nf_tables_api.c             | 10 +++-------
 net/netfilter/nf_tables_offload.c         | 22 ++++++++++++++++++----
 3 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index db104665a9e4..643152f4aef7 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -80,4 +80,7 @@ void nft_indr_block_get_and_ing_cmd(struct net_device *dev,
 
 int nft_chain_offload_priority(struct nft_base_chain *basechain);
 
+void nft_offload_init(void);
+void nft_offload_exit(void);
+
 #endif
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6d00bef023c4..5ad60ffe027a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7602,11 +7602,6 @@ static struct pernet_operations nf_tables_net_ops = {
 	.exit	= nf_tables_exit_net,
 };
 
-static struct flow_indr_block_ing_entry block_ing_entry = {
-	.cb = nft_indr_block_get_and_ing_cmd,
-	.list = LIST_HEAD_INIT(block_ing_entry.list),
-};
-
 static int __init nf_tables_module_init(void)
 {
 	int err;
@@ -7638,7 +7633,8 @@ static int __init nf_tables_module_init(void)
 		goto err5;
 
 	nft_chain_route_init();
-	flow_indr_add_block_ing_cb(&block_ing_entry);
+	nft_offload_init();
+
 	return err;
 err5:
 	rhltable_destroy(&nft_objname_ht);
@@ -7655,7 +7651,7 @@ static int __init nf_tables_module_init(void)
 
 static void __exit nf_tables_module_exit(void)
 {
-	flow_indr_del_block_ing_cb(&block_ing_entry);
+	nft_offload_exit();
 	nfnetlink_subsys_unregister(&nf_tables_subsys);
 	unregister_netdevice_notifier(&nf_tables_flowtable_notifier);
 	nft_chain_filter_fini();
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index d7c25c1ff66e..1e69bd7f9fe1 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -352,10 +352,9 @@ int nft_flow_rule_offload_commit(struct net *net)
 	return err;
 }
 
-void nft_indr_block_get_and_ing_cmd(struct net_device *dev,
-				    flow_indr_block_bind_cb_t *cb,
-				    void *cb_priv,
-				    enum flow_block_command command)
+static void nft_indr_block_cb(struct net_device *dev,
+			      flow_indr_block_bind_cb_t *cb, void *cb_priv,
+			      enum flow_block_command command)
 {
 	struct net *net = dev_net(dev);
 	const struct nft_table *table;
@@ -381,3 +380,18 @@ void nft_indr_block_get_and_ing_cmd(struct net_device *dev,
 		}
 	}
 }
+
+static struct flow_indr_block_ing_entry block_ing_entry = {
+	.cb	= nft_indr_block_cb,
+	.list	= LIST_HEAD_INIT(block_ing_entry.list),
+};
+
+void nft_offload_init(void)
+{
+	flow_indr_add_block_ing_cb(&block_ing_entry);
+}
+
+void nft_offload_exit(void)
+{
+	flow_indr_del_block_ing_cb(&block_ing_entry);
+}
-- 
2.11.0

