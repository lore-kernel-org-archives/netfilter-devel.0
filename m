Return-Path: <SRS0=ip/f=VB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C762BC06514
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jul 2019 07:22:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA83D216E3
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jul 2019 07:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbfGDHWo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Jul 2019 03:22:44 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:35157 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727436AbfGDHWn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Jul 2019 03:22:43 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id B018A41B1B;
        Thu,  4 Jul 2019 15:22:37 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, nikolay@cumulusnetworks.com
Cc:     netfilter-devel@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: [PATCH 3/7 nf-next] bridge: add br_vlan_get_pvid_rcu()
Date:   Thu,  4 Jul 2019 15:22:31 +0800
Message-Id: <1562224955-3979-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562224955-3979-1-git-send-email-wenxu@ucloud.cn>
References: <1562224955-3979-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSk1NQkJCQkhNSktIQ0lZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PQw6Gio5KTg9FAlNHREQPzgJ
        Tk5PCwNVSlVKTk1JSUlPQk5MQ01LVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhPTkw3Bg++
X-HM-Tid: 0a6bbbdd19332086kuqyb018a41b1b
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This new function allows you to fetch bridge pvid from packet path.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/linux/if_bridge.h |  6 ++++++
 net/bridge/br_vlan.c      | 19 +++++++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index f3fab5d..950db1d 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -88,6 +88,7 @@ static inline bool br_multicast_router(const struct net_device *dev)
 #if IS_ENABLED(CONFIG_BRIDGE) && IS_ENABLED(CONFIG_BRIDGE_VLAN_FILTERING)
 bool br_vlan_enabled(const struct net_device *dev);
 int br_vlan_get_pvid(const struct net_device *dev, u16 *p_pvid);
+int br_vlan_get_pvid_rcu(const struct net_device *dev, u16 *p_pvid);
 int br_vlan_get_info(const struct net_device *dev, u16 vid,
 		     struct bridge_vlan_info *p_vinfo);
 #else
@@ -101,6 +102,11 @@ static inline int br_vlan_get_pvid(const struct net_device *dev, u16 *p_pvid)
 	return -EINVAL;
 }
 
+static inline int br_vlan_get_pvid_rcu(const struct net_device *dev, u16 *p_pvid)
+{
+	return -EINVAL;
+}
+
 static inline int br_vlan_get_info(const struct net_device *dev, u16 vid,
 				   struct bridge_vlan_info *p_vinfo)
 {
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index f47f526..8d97b91 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1227,13 +1227,11 @@ void br_vlan_get_stats(const struct net_bridge_vlan *v,
 	}
 }
 
-int br_vlan_get_pvid(const struct net_device *dev, u16 *p_pvid)
+static int __br_vlan_get_pvid(const struct net_device *dev,
+			      struct net_bridge_port *p, u16 *p_pvid)
 {
 	struct net_bridge_vlan_group *vg;
-	struct net_bridge_port *p;
 
-	ASSERT_RTNL();
-	p = br_port_get_check_rtnl(dev);
 	if (p)
 		vg = nbp_vlan_group(p);
 	else if (netif_is_bridge_master(dev))
@@ -1244,8 +1242,21 @@ int br_vlan_get_pvid(const struct net_device *dev, u16 *p_pvid)
 	*p_pvid = br_get_pvid(vg);
 	return 0;
 }
+
+int br_vlan_get_pvid(const struct net_device *dev, u16 *p_pvid)
+{
+	ASSERT_RTNL();
+
+	return __br_vlan_get_pvid(dev, br_port_get_check_rtnl(dev), p_pvid);
+}
 EXPORT_SYMBOL_GPL(br_vlan_get_pvid);
 
+int br_vlan_get_pvid_rcu(const struct net_device *dev, u16 *p_pvid)
+{
+	return __br_vlan_get_pvid(dev, br_port_get_check_rcu(dev), p_pvid);
+}
+EXPORT_SYMBOL_GPL(br_vlan_get_pvid_rcu);
+
 int br_vlan_get_info(const struct net_device *dev, u16 vid,
 		     struct bridge_vlan_info *p_vinfo)
 {
-- 
1.8.3.1

