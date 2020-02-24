Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0D58C11D24
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 05:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D199A20661
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 05:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgBXF3g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Feb 2020 00:29:36 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:43321 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgBXF3g (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Feb 2020 00:29:36 -0500
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Feb 2020 00:29:27 EST
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id E4EF55C18AA;
        Mon, 24 Feb 2020 13:22:55 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v5 2/4] netfilter: flowtable: add indr block setup support
Date:   Mon, 24 Feb 2020 13:22:53 +0800
Message-Id: <1582521775-25176-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1582521775-25176-1-git-send-email-wenxu@ucloud.cn>
References: <1582521775-25176-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSkJMS0tLSU1OSklKT01ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NjI6LSo5ETgyHiw6PhoUHUg5
        KDZPCxFVSlVKTkNJTklKTExNS09OVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU5MS0o3Bg++
X-HM-Tid: 0a7075a5f74e2087kuqye4ef55c18aa
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add etfilter flowtable support indr-block setup. It makes flowtable offload
vlan and tunnel device.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v5: make the dev can bind with different flowtable and
check the NF_FLOWTABLE_HW_OFFLOAD flags in  
nf_flow_table_indr_block_cb_cmd. 

 net/netfilter/nf_flow_table_offload.c | 94 +++++++++++++++++++++++++++++++++--
 1 file changed, 90 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index ffeffbe..2240ce5 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -7,6 +7,7 @@
 #include <linux/tc_act/tc_csum.h>
 #include <net/flow_offload.h>
 #include <net/netfilter/nf_flow_table.h>
+#include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
@@ -848,6 +849,22 @@ static void nf_flow_table_block_offload_init(struct flow_block_offload *bo,
 	INIT_LIST_HEAD(&bo->cb_list);
 }
 
+static int nf_flow_table_indr_offload_cmd(struct flow_block_offload *bo,
+					  struct nf_flowtable *flowtable,
+					  struct net_device *dev,
+					  enum flow_block_command cmd,
+					  struct netlink_ext_ack *extack)
+{
+	nf_flow_table_block_offload_init(bo, dev_net(dev), cmd, flowtable,
+					 extack);
+	flow_indr_block_call(dev, bo, cmd);
+
+	if (list_empty(&bo->cb_list))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
 static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
 				     struct nf_flowtable *flowtable,
 				     struct net_device *dev,
@@ -856,9 +873,6 @@ static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
 {
 	int err;
 
-	if (!dev->netdev_ops->ndo_setup_tc)
-		return -EOPNOTSUPP;
-
 	nf_flow_table_block_offload_init(bo, dev_net(dev), cmd, flowtable,
 					 extack);
 	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_FT, bo);
@@ -879,7 +893,12 @@ int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 	if (!nf_flowtable_hw_offload(flowtable))
 		return 0;
 
-	err = nf_flow_table_offload_cmd(&bo, flowtable, dev, cmd, &extack);
+	if (dev->netdev_ops->ndo_setup_tc)
+		err = nf_flow_table_offload_cmd(&bo, flowtable, dev, cmd,
+						&extack);
+	else
+		err = nf_flow_table_indr_offload_cmd(&bo, flowtable, dev, cmd,
+						     &extack);
 	if (err < 0)
 		return err;
 
@@ -887,10 +906,75 @@ int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_offload_setup);
 
+static void nf_flow_table_indr_block_ing_cmd(struct net_device *dev,
+					     struct nf_flowtable *flowtable,
+					     flow_indr_block_bind_cb_t *cb,
+					     void *cb_priv,
+					     enum flow_block_command cmd)
+{
+	struct netlink_ext_ack extack = {};
+	struct flow_block_offload bo;
+
+	if (!flowtable)
+		return;
+
+	nf_flow_table_block_offload_init(&bo, dev_net(dev), cmd, flowtable,
+					 &extack);
+
+	cb(dev, cb_priv, TC_SETUP_FT, &bo);
+
+	nf_flow_table_block_setup(flowtable, &bo, cmd);
+}
+
+static void nf_flow_table_indr_block_cb_cmd(struct nf_flowtable *flowtable,
+					    struct net_device *dev,
+					    flow_indr_block_bind_cb_t *cb,
+					    void *cb_priv,
+					    enum flow_block_command cmd)
+{
+	if (!(flowtable->flags & NF_FLOWTABLE_HW_OFFLOAD))
+		return;
+
+	nf_flow_table_indr_block_ing_cmd(dev, flowtable, cb, cb_priv, cmd);
+}
+
+static void nf_flow_table_indr_block_cb(struct net_device *dev,
+					flow_indr_block_bind_cb_t *cb,
+					void *cb_priv,
+					enum flow_block_command cmd)
+{
+	struct net *net = dev_net(dev);
+	struct nft_flowtable *nft_ft;
+	struct nft_table *table;
+	struct nft_hook *hook;
+
+	mutex_lock(&net->nft.commit_mutex);
+	list_for_each_entry(table, &net->nft.tables, list) {
+		list_for_each_entry(nft_ft, &table->flowtables, list) {
+			list_for_each_entry(hook, &nft_ft->hook_list, list) {
+				if (hook->ops.dev != dev)
+					continue;
+
+				nf_flow_table_indr_block_cb_cmd(&nft_ft->data,
+								dev, cb,
+								cb_priv, cmd);
+			}
+		}
+	}
+	mutex_unlock(&net->nft.commit_mutex);
+}
+
+static struct flow_indr_block_entry block_ing_entry = {
+	.cb	= nf_flow_table_indr_block_cb,
+	.list	= LIST_HEAD_INIT(block_ing_entry.list),
+};
+
 int nf_flow_table_offload_init(void)
 {
 	INIT_WORK(&nf_flow_offload_work, flow_offload_work_handler);
 
+	flow_indr_add_block_cb(&block_ing_entry);
+
 	return 0;
 }
 
@@ -899,6 +983,8 @@ void nf_flow_table_offload_exit(void)
 	struct flow_offload_work *offload, *next;
 	LIST_HEAD(offload_pending_list);
 
+	flow_indr_del_block_cb(&block_ing_entry);
+
 	cancel_work_sync(&nf_flow_offload_work);
 
 	list_for_each_entry_safe(offload, next, &offload_pending_list, list) {
-- 
1.8.3.1

