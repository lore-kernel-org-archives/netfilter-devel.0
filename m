Return-Path: <SRS0=JGmF=W2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1BDDC3A5A6
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Aug 2019 04:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADFBD21897
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Aug 2019 04:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfH3ER1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Aug 2019 00:17:27 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:42701 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfH3ER1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Aug 2019 00:17:27 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 28D10416B8;
        Fri, 30 Aug 2019 12:17:23 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v7 4/8] bridge: add br_vlan_get_info_rcu()
Date:   Fri, 30 Aug 2019 12:17:18 +0800
Message-Id: <1567138642-11446-5-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567138642-11446-1-git-send-email-wenxu@ucloud.cn>
References: <1567138642-11446-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUlDS0tLS09PQ0lJTUJZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OCo6GCo6ITgzMTISFCMsLzQe
        GiNPCQpVSlVKTk1MSkhDTU9ISUpCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhLTkM3Bg++
X-HM-Tid: 0a6ce0bdfceb2086kuqy28d10416b8
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This new function allows you to fetch vlan info from packet path.

Signed-off-by: wenxu <wenxu@ucloud.cn>
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
v7: no change

 include/linux/if_bridge.h |  7 +++++++
 net/bridge/br_vlan.c      | 25 +++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 9e57c44..5c85608 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -92,6 +92,8 @@ static inline bool br_multicast_router(const struct net_device *dev)
 int br_vlan_get_proto(const struct net_device *dev, u16 *p_proto);
 int br_vlan_get_info(const struct net_device *dev, u16 vid,
 		     struct bridge_vlan_info *p_vinfo);
+int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
+			 struct bridge_vlan_info *p_vinfo);
 #else
 static inline bool br_vlan_enabled(const struct net_device *dev)
 {
@@ -118,6 +120,11 @@ static inline int br_vlan_get_info(const struct net_device *dev, u16 vid,
 {
 	return -EINVAL;
 }
+static inline int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
+				       struct bridge_vlan_info *p_vinfo)
+{
+	return -EINVAL;
+}
 #endif
 
 #if IS_ENABLED(CONFIG_BRIDGE)
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index f5b2aee..dfcf098 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1285,6 +1285,31 @@ int br_vlan_get_info(const struct net_device *dev, u16 vid,
 }
 EXPORT_SYMBOL_GPL(br_vlan_get_info);
 
+int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
+			 struct bridge_vlan_info *p_vinfo)
+{
+	struct net_bridge_vlan_group *vg;
+	struct net_bridge_vlan *v;
+	struct net_bridge_port *p;
+
+	p = br_port_get_check_rcu(dev);
+	if (p)
+		vg = nbp_vlan_group_rcu(p);
+	else if (netif_is_bridge_master(dev))
+		vg = br_vlan_group_rcu(netdev_priv(dev));
+	else
+		return -EINVAL;
+
+	v = br_vlan_find(vg, vid);
+	if (!v)
+		return -ENOENT;
+
+	p_vinfo->vid = vid;
+	p_vinfo->flags = v->flags;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(br_vlan_get_info_rcu);
+
 static int br_vlan_is_bind_vlan_dev(const struct net_device *dev)
 {
 	return is_vlan_dev(dev) &&
-- 
1.8.3.1

