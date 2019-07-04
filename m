Return-Path: <SRS0=ip/f=VB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 725FFC0650E
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jul 2019 07:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47AFA218A4
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jul 2019 07:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbfGDHWu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Jul 2019 03:22:50 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:35177 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbfGDHWt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Jul 2019 03:22:49 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 2B87341AED;
        Thu,  4 Jul 2019 15:22:38 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, nikolay@cumulusnetworks.com
Cc:     netfilter-devel@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: [PATCH 5/7 nf-next] bridge: add br_vlan_get_proto()
Date:   Thu,  4 Jul 2019 15:22:33 +0800
Message-Id: <1562224955-3979-5-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562224955-3979-1-git-send-email-wenxu@ucloud.cn>
References: <1562224955-3979-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSk1NQkJCQkhNSktIQ0lZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NzI6CBw5KDg5Igk8QhMNPyJJ
        Pg4aCwJVSlVKTk1JSUlPQk5DSE9NVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlNQ0g3Bg++
X-HM-Tid: 0a6bbbdd1b202086kuqy2b87341aed
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This new function allows you to fetch bridge vlan proto.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/linux/if_bridge.h |  6 ++++++
 net/bridge/br_vlan.c      | 10 ++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 950db1d..9e57c44 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -89,6 +89,7 @@ static inline bool br_multicast_router(const struct net_device *dev)
 bool br_vlan_enabled(const struct net_device *dev);
 int br_vlan_get_pvid(const struct net_device *dev, u16 *p_pvid);
 int br_vlan_get_pvid_rcu(const struct net_device *dev, u16 *p_pvid);
+int br_vlan_get_proto(const struct net_device *dev, u16 *p_proto);
 int br_vlan_get_info(const struct net_device *dev, u16 vid,
 		     struct bridge_vlan_info *p_vinfo);
 #else
@@ -102,6 +103,11 @@ static inline int br_vlan_get_pvid(const struct net_device *dev, u16 *p_pvid)
 	return -EINVAL;
 }
 
+static inline int br_vlan_get_proto(const struct net_device *dev, u16 *p_proto)
+{
+	return -EINVAL;
+}
+
 static inline int br_vlan_get_pvid_rcu(const struct net_device *dev, u16 *p_pvid)
 {
 	return -EINVAL;
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 8d97b91..021cc9f66 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -797,6 +797,16 @@ bool br_vlan_enabled(const struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(br_vlan_enabled);
 
+int br_vlan_get_proto(const struct net_device *dev, u16 *p_proto)
+{
+	struct net_bridge *br = netdev_priv(dev);
+
+	*p_proto = ntohs(br->vlan_proto);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(br_vlan_get_proto);
+
 int __br_vlan_set_proto(struct net_bridge *br, __be16 proto)
 {
 	int err = 0;
-- 
1.8.3.1

