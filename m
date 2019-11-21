Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84AF5C43141
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 09:54:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 663232067D
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 09:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbfKUJyX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 04:54:23 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:49234 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726985AbfKUJyW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 04:54:22 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id CC90841CEA;
        Thu, 21 Nov 2019 17:54:17 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v2 2/4] netfilter: nf_flow_table_offload: add indr block setup support
Date:   Thu, 21 Nov 2019 17:54:14 +0800
Message-Id: <1574330056-5377-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574330056-5377-1-git-send-email-wenxu@ucloud.cn>
References: <1574330056-5377-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSk9KS0tLS0hJT0lPQkhZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OAg6Sww6FTg4Fw9IS045CTkt
        L0kaCUlVSlVKTkxPSEhLS05MQk1OVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU5LSEM3Bg++
X-HM-Tid: 0a6e8d6244772086kuqycc90841cea
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Nf flow table support indr-block setup. It makes flow table offload vlan
and tunnel device.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v2: no change

 net/netfilter/nf_flow_table_offload.c | 89 ++++++++++++++++++++++++++++++++++-
 1 file changed, 88 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 2d92043..653866f 100644
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
@@ -834,6 +835,24 @@ static int nf_flow_table_offload_cmd(struct nf_flowtable *flowtable,
 	return nf_flow_table_block_setup(flowtable, &bo, cmd);
 }
 
+static int nf_flow_table_indr_offload_cmd(struct nf_flowtable *flowtable,
+					  struct net_device *dev,
+					  enum flow_block_command cmd)
+{
+	struct netlink_ext_ack extack = {};
+	struct flow_block_offload bo;
+
+	nf_flow_table_block_offload_init(&bo, dev_net(dev), cmd, flowtable,
+					 &extack);
+
+	flow_indr_block_call(dev, &bo, cmd);
+
+	if (list_empty(&bo.cb_list))
+		return -EOPNOTSUPP;
+
+	return nf_flow_table_block_setup(flowtable, &bo, cmd);
+}
+
 int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 				struct net_device *dev,
 				enum flow_block_command cmd)
@@ -846,16 +865,82 @@ int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 	if (dev->netdev_ops->ndo_setup_tc)
 		err = nf_flow_table_offload_cmd(flowtable, dev, cmd);
 	else
-		err = -EOPNOTSUPP;
+		err = nf_flow_table_indr_offload_cmd(flowtable, dev, cmd);
 
 	return err;
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_offload_setup);
 
+static struct nf_flowtable *__nf_flow_table_offload_get(struct net_device *dev)
+{
+	struct nf_flowtable *n_flowtable;
+	struct nft_flowtable *flowtable;
+	struct net *net = dev_net(dev);
+	struct nft_table *table;
+	struct nft_hook *hook;
+
+	list_for_each_entry(table, &net->nft.tables, list) {
+		list_for_each_entry(flowtable, &table->flowtables, list) {
+			list_for_each_entry(hook, &flowtable->hook_list, list) {
+				if (hook->ops.dev != dev)
+					continue;
+
+				n_flowtable = &flowtable->data;
+				return n_flowtable;
+			}
+		}
+	}
+
+	return NULL;
+}
+
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
+	cb(dev, cb_priv, TC_SETUP_BLOCK, &bo);
+
+	nf_flow_table_block_setup(flowtable, &bo, cmd);
+}
+
+static void nf_flow_table_indr_block_cb(struct net_device *dev,
+					flow_indr_block_bind_cb_t *cb,
+					void *cb_priv,
+					enum flow_block_command cmd)
+{
+	struct net *net = dev_net(dev);
+	struct nf_flowtable *flowtable;
+
+	mutex_lock(&net->nft.commit_mutex);
+	flowtable = __nf_flow_table_offload_get(dev);
+	if (flowtable)
+		nf_flow_table_indr_block_ing_cmd(dev, flowtable, cb, cb_priv,
+						 cmd);
+	mutex_unlock(&net->nft.commit_mutex);
+}
+
+static struct flow_indr_block_ing_entry block_ing_entry = {
+	.cb	= nf_flow_table_indr_block_cb,
+	.list	= LIST_HEAD_INIT(block_ing_entry.list),
+};
+
 int nf_flow_table_offload_init(void)
 {
 	INIT_WORK(&nf_flow_offload_work, flow_offload_work_handler);
 
+	flow_indr_add_block_ing_cb(&block_ing_entry);
+
 	return 0;
 }
 
@@ -864,6 +949,8 @@ void nf_flow_table_offload_exit(void)
 	struct flow_offload_work *offload, *next;
 	LIST_HEAD(offload_pending_list);
 
+	flow_indr_del_block_ing_cb(&block_ing_entry);
+
 	cancel_work_sync(&nf_flow_offload_work);
 
 	list_for_each_entry_safe(offload, next, &offload_pending_list, list) {
-- 
1.8.3.1

