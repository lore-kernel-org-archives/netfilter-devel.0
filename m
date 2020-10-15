Return-Path: <SRS0=46WK=DW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 577AAC43457
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Oct 2020 01:17:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CFBF22257
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Oct 2020 01:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732039AbgJOBRI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Oct 2020 21:17:08 -0400
Received: from correo.us.es ([193.147.175.20]:38762 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731442AbgJOBQr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Oct 2020 21:16:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5CEF2DA7F1
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2020 03:16:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 45BFEDA73F
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2020 03:16:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3B4AFDA722; Thu, 15 Oct 2020 03:16:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 483C1DA72F;
        Thu, 15 Oct 2020 03:16:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 15 Oct 2020 03:16:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 1FEFE41FF201;
        Thu, 15 Oct 2020 03:16:41 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 3/9] net: 8021q: resolve forwarding path for vlan devices
Date:   Thu, 15 Oct 2020 03:16:24 +0200
Message-Id: <20201015011630.2399-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201015011630.2399-1-pablo@netfilter.org>
References: <20201015011630.2399-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add .ndo_fill_forward_path for vlan devices.

For instance, assuming the following topology:

                   IP forwarding
                  /             \
            eth0.100             eth0
            |
            eth0
            .
            .
            .
           ethX
     ab:cd:ef:ab:cd:ef

For packets in the IP forwarding going to eth0.100 whose destination MAC
address is ab:cd:ef:ab:cd:ef, dev_fill_forward_path() provides the
following path:

            eth0.100 -> eth0

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netdevice.h |  7 +++++++
 net/8021q/vlan_dev.c      | 15 +++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b77960621c27..6a3370fafe4b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -835,11 +835,18 @@ typedef u16 (*select_queue_fallback_t)(struct net_device *dev,
 
 enum net_device_path_type {
 	DEV_PATH_ETHERNET = 0,
+	DEV_PATH_VLAN,
 };
 
 struct net_device_path {
 	enum net_device_path_type	type;
 	const struct net_device		*dev;
+	union {
+		struct {
+			__be16		id;
+			__be16		proto;
+		} vlan;
+	};
 };
 
 #define NET_DEVICE_PATH_STACK_MAX	5
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index ec8408d1638f..f06a507557f9 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -767,6 +767,20 @@ static int vlan_dev_get_iflink(const struct net_device *dev)
 	return real_dev->ifindex;
 }
 
+static int vlan_dev_fill_forward_path(struct net_device_path_ctx *ctx,
+				      struct net_device_path *path)
+{
+	struct vlan_dev_priv *vlan = vlan_dev_priv(ctx->dev);
+
+	path->type = DEV_PATH_VLAN;
+	path->vlan.id = vlan->vlan_id;
+	path->vlan.proto = vlan->vlan_proto;
+	path->dev = ctx->dev;
+	ctx->dev = vlan->real_dev;
+
+	return 0;
+}
+
 static const struct ethtool_ops vlan_ethtool_ops = {
 	.get_link_ksettings	= vlan_ethtool_get_link_ksettings,
 	.get_drvinfo	        = vlan_ethtool_get_drvinfo,
@@ -805,6 +819,7 @@ static const struct net_device_ops vlan_netdev_ops = {
 #endif
 	.ndo_fix_features	= vlan_dev_fix_features,
 	.ndo_get_iflink		= vlan_dev_get_iflink,
+	.ndo_fill_forward_path	= vlan_dev_fill_forward_path,
 };
 
 static void vlan_dev_free(struct net_device *dev)
-- 
2.20.1

