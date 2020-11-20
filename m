Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A33C8300E
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 12:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 574E922240
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 12:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgKTMuE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 07:50:04 -0500
Received: from correo.us.es ([193.147.175.20]:38008 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726560AbgKTMtr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 07:49:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E6BB218D006
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2020 13:49:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D889BFC5E5
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2020 13:49:45 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CFEAFFC5ED; Fri, 20 Nov 2020 13:49:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A5700FC5E4;
        Fri, 20 Nov 2020 13:49:43 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Nov 2020 13:49:43 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 59E3E4265A5A;
        Fri, 20 Nov 2020 13:49:43 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        fw@strlen.de, razor@blackwall.org, jeremy@azazel.net,
        tobias@waldekranz.com
Subject: [PATCH net-next,v5 5/9] bridge: resolve forwarding path for bridge devices
Date:   Fri, 20 Nov 2020 13:49:17 +0100
Message-Id: <20201120124921.32172-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201120124921.32172-1-pablo@netfilter.org>
References: <20201120124921.32172-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add .ndo_fill_forward_path for bridge devices.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v5: no changes.

 include/linux/netdevice.h |  1 +
 net/bridge/br_device.c    | 27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index e9690e1a6559..281551c70536 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -836,6 +836,7 @@ typedef u16 (*select_queue_fallback_t)(struct net_device *dev,
 enum net_device_path_type {
 	DEV_PATH_ETHERNET = 0,
 	DEV_PATH_VLAN,
+	DEV_PATH_BRIDGE,
 };
 
 struct net_device_path {
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 77bcc84875af..8fee4db770b3 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -392,6 +392,32 @@ static int br_del_slave(struct net_device *dev, struct net_device *slave_dev)
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
@@ -426,6 +452,7 @@ static const struct net_device_ops br_netdev_ops = {
 	.ndo_bridge_setlink	 = br_setlink,
 	.ndo_bridge_dellink	 = br_dellink,
 	.ndo_features_check	 = passthru_features_check,
+	.ndo_fill_forward_path	 = br_fill_forward_path,
 };
 
 static struct device_type br_type = {
-- 
2.20.1

