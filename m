Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFBB1C4332D
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 00:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7BC064FBA
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 00:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhCKAgn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 Mar 2021 19:36:43 -0500
Received: from correo.us.es ([193.147.175.20]:50036 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229712AbhCKAgP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Mar 2021 19:36:15 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E3A6112E82F
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Mar 2021 01:36:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D6319DA789
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Mar 2021 01:36:14 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CB49FDA704; Thu, 11 Mar 2021 01:36:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C578DA722;
        Thu, 11 Mar 2021 01:36:12 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Mar 2021 01:36:12 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 5447F42DC6E2;
        Thu, 11 Mar 2021 01:36:12 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH net-next 03/23] net: bridge: resolve forwarding path for bridge devices
Date:   Thu, 11 Mar 2021 01:35:44 +0100
Message-Id: <20210311003604.22199-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210311003604.22199-1-pablo@netfilter.org>
References: <20210311003604.22199-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add .ndo_fill_forward_path for bridge devices.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netdevice.h |  1 +
 net/bridge/br_device.c    | 27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d78155aba3fa..4d8b8dc20018 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -834,6 +834,7 @@ typedef u16 (*select_queue_fallback_t)(struct net_device *dev,
 enum net_device_path_type {
 	DEV_PATH_ETHERNET = 0,
 	DEV_PATH_VLAN,
+	DEV_PATH_BRIDGE,
 };
 
 struct net_device_path {
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 3f2f06b4dd27..c241719013f4 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -385,6 +385,32 @@ static int br_del_slave(struct net_device *dev, struct net_device *slave_dev)
 	return br_del_if(br, slave_dev);
 }
 
+static int br_fill_forward_path(struct net_device_path_ctx *ctx,
+				struct net_device_path *path)
+{
+	struct net_bridge_fdb_entry *f;
+	struct net_bridge_port *dst;
+	struct net_bridge *br;
+
+	if (netif_is_bridge_port(ctx->dev))
+		return -1;
+
+	br = netdev_priv(ctx->dev);
+	f = br_fdb_find_rcu(br, ctx->daddr, 0);
+	if (!f || !f->dst)
+		return -1;
+
+	dst = READ_ONCE(f->dst);
+	if (!dst)
+		return -1;
+
+	path->type = DEV_PATH_BRIDGE;
+	path->dev = dst->br->dev;
+	ctx->dev = dst->dev;
+
+	return 0;
+}
+
 static const struct ethtool_ops br_ethtool_ops = {
 	.get_drvinfo		 = br_getinfo,
 	.get_link		 = ethtool_op_get_link,
@@ -419,6 +445,7 @@ static const struct net_device_ops br_netdev_ops = {
 	.ndo_bridge_setlink	 = br_setlink,
 	.ndo_bridge_dellink	 = br_dellink,
 	.ndo_features_check	 = passthru_features_check,
+	.ndo_fill_forward_path	 = br_fill_forward_path,
 };
 
 static struct device_type br_type = {
-- 
2.20.1

