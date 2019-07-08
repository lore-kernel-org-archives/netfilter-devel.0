Return-Path: <SRS0=pcH3=VF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 128E0C606A7
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 10:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E090E20656
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 10:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725869AbfGHKcw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jul 2019 06:32:52 -0400
Received: from mail.us.es ([193.147.175.20]:34286 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729455AbfGHKcv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jul 2019 06:32:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 431C6BAE87
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jul 2019 12:32:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 32CC61021A6
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jul 2019 12:32:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 286E96E7C1; Mon,  8 Jul 2019 12:32:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1FF9B5765B;
        Mon,  8 Jul 2019 12:32:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Jul 2019 12:32:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E45BA4265A2F;
        Mon,  8 Jul 2019 12:32:47 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 09/15] bridge: add br_vlan_get_pvid_rcu()
Date:   Mon,  8 Jul 2019 12:32:31 +0200
Message-Id: <20190708103237.28061-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190708103237.28061-1-pablo@netfilter.org>
References: <20190708103237.28061-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This new function allows you to fetch bridge pvid from packet path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 include/linux/if_bridge.h |  6 ++++++
 net/bridge/br_vlan.c      | 19 +++++++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index f3fab5d0ea97..950db1dad830 100644
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
index f47f526b4f19..8d97b91ad503 100644
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
2.11.0

