Return-Path: <SRS0=kOBD=7V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BDC0C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jun 2020 19:01:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6579D2074B
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jun 2020 19:01:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jylfLgv6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgFHTBL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jun 2020 15:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbgFHTBI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jun 2020 15:01:08 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD64C08C5C2
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2020 12:01:07 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id dr13so364416ejc.3
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Jun 2020 12:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=U73+JNjqEmxwfVu68d0hg93K2xjZ9nGBZs2ooaCEQYo=;
        b=jylfLgv6QMg/IzEz6Dj0tbpqS/zPq8TCSk23HnPxi7E3fJBLXftOWhqshNiBbyF5GZ
         QNGsGV7TsVOm2pp/XXeo3Bl17TJ+F5cLdW92E3qT07PX4M65lPAxz91C6Ef1RMa6NkSY
         +6xBqGDXYvDMLNpd/DhfRy8RNZf322gyw1OvBZxsJ3zNecYRCPHcBw5UQPTgmlPPJF7p
         qO/ewrvQkwq7DzQuvPNAzEjHii2ID2Tx7JviNgPgHZ2hJUR+tN7INMR6cJVUL8t2L+wx
         m4fXNEOUKKtF+m0ZV0/YgFrDJo+HvNA0HqF0eHm1a+PH/RCu+EjkSVEkZ0niiV9GK+hJ
         IgGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=U73+JNjqEmxwfVu68d0hg93K2xjZ9nGBZs2ooaCEQYo=;
        b=QLEvVmW+Pdfd+7SZePGcytGXRn4SFkIIl/6JIBd2tnczOR40pYw6Xtkg0jLiCxqFgi
         AdwN/652Zqgw+tMrd8fI4HxFOkgzcHklFW0IJgObfPD1glIZ9hF6AmO3dDUStzja860I
         QDah0ST2Nv3HFOfonVps3D5AlrTC+ROvhrbGcSqOqxj6HdQ1XJ3xQhz+c4PN49kUezco
         +HTKMqoG4ZvsCrH3USMDWLStnuw76VnBUmO9nkLUbqK7nd4MqgMX7reVqN4szykJ1P1f
         Arwm+I0RIfibNmcU91IJ0ire+eJAofvoGRXxtlivD3NuZ8eQ0FqAWaTEtg5kxzbYXPiH
         oUVw==
X-Gm-Message-State: AOAM530GABZxzNbccpJyr5tmpzWjasOQK4Z6RqHqIuGjRYRgabPgXUrY
        XUNwTeYzzrWGul2Uc9T6Z7rjHghslfA=
X-Google-Smtp-Source: ABdhPJxXQH7EtVFeLNedZpfeTYMo3+7QNri1c1YHWhlceD9Vj+Cj1hs/wJE+RiAWX7LHNhDvFFpetw==
X-Received: by 2002:a17:906:4c42:: with SMTP id d2mr22637621ejw.474.1591642866203;
        Mon, 08 Jun 2020 12:01:06 -0700 (PDT)
Received: from nevthink ([91.126.71.247])
        by smtp.gmail.com with ESMTPSA id i21sm13359269edr.68.2020.06.08.12.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 12:01:05 -0700 (PDT)
Date:   Mon, 8 Jun 2020 21:01:03 +0200
From:   Laura Garcia Liebana <nevola@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, devel@zevenet.com
Subject: [PATCH nf-next 2/2] netfilter: nft: add support of reject verdict
 from ingress
Message-ID: <20200608190103.GA23207@nevthink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds the REJECT support from ingress for both stacks
ipv4 and ipv6, but also, both types ICMP and TCP RESET.

This ability is required in devices that need to REJECT legitimate
clients which traffic are forwarded from the ingress hook.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 net/netfilter/Kconfig             | 10 +++++
 net/netfilter/Makefile            |  1 +
 net/netfilter/nft_reject_netdev.c | 65 +++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+)
 create mode 100644 net/netfilter/nft_reject_netdev.c

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 468fea1aebba..25200f249778 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -681,6 +681,16 @@ config NFT_FIB_NETDEV
 	  The lookup will be delegated to the IPv4 or IPv6 FIB depending
 	  on the protocol of the packet.
 
+config NFT_REJECT_NETDEV
+	depends on NFT_REJECT_IPV4
+	depends on NFT_REJECT_IPV6
+	tristate "Netfilter nf_tables netdev REJECT support"
+	help
+	  This option enables the REJECT support from the netdev table.
+	  The return packet generation will be delegated to the IPv4
+	  or IPv6 ICMP or TCP RST implementation depending on the
+	  protocol of the packet.
+
 endif # NF_TABLES_NETDEV
 
 endif # NF_TABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 0e0ded87e27b..33da7bf1b68e 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -101,6 +101,7 @@ obj-$(CONFIG_NFT_QUEUE)		+= nft_queue.o
 obj-$(CONFIG_NFT_QUOTA)		+= nft_quota.o
 obj-$(CONFIG_NFT_REJECT) 	+= nft_reject.o
 obj-$(CONFIG_NFT_REJECT_INET)	+= nft_reject_inet.o
+obj-$(CONFIG_NFT_REJECT_NETDEV)	+= nft_reject_netdev.o
 obj-$(CONFIG_NFT_TUNNEL)	+= nft_tunnel.o
 obj-$(CONFIG_NFT_COUNTER)	+= nft_counter.o
 obj-$(CONFIG_NFT_LOG)		+= nft_log.o
diff --git a/net/netfilter/nft_reject_netdev.c b/net/netfilter/nft_reject_netdev.c
new file mode 100644
index 000000000000..64123d80210d
--- /dev/null
+++ b/net/netfilter/nft_reject_netdev.c
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2020 Laura Garcia Liebana <nevola@gmail.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nft_reject.h>
+#include <net/netfilter/ipv4/nft_reject_ipv4.h>
+#include <net/netfilter/ipv6/nft_reject_ipv6.h>
+
+static void nft_reject_netdev_eval(const struct nft_expr *expr,
+				   struct nft_regs *regs,
+				   const struct nft_pktinfo *pkt)
+{
+	switch (ntohs(pkt->skb->protocol)) {
+	case ETH_P_IP:
+		nft_reject_ipv4_eval(expr, regs, pkt);
+		break;
+	case ETH_P_IPV6:
+		nft_reject_ipv6_eval(expr, regs, pkt);
+		break;
+	}
+}
+
+static struct nft_expr_type nft_reject_netdev_type;
+static const struct nft_expr_ops nft_reject_netdev_ops = {
+	.type		= &nft_reject_netdev_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_reject)),
+	.eval		= nft_reject_netdev_eval,
+	.init		= nft_reject_init,
+	.dump		= nft_reject_dump,
+	.validate	= nft_reject_generic_validate,
+};
+
+static struct nft_expr_type nft_reject_netdev_type __read_mostly = {
+	.family		= NFPROTO_NETDEV,
+	.name		= "reject",
+	.ops		= &nft_reject_netdev_ops,
+	.policy		= nft_reject_policy,
+	.maxattr	= NFTA_REJECT_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_reject_netdev_module_init(void)
+{
+	return nft_register_expr(&nft_reject_netdev_type);
+}
+
+static void __exit nft_reject_netdev_module_exit(void)
+{
+	nft_unregister_expr(&nft_reject_netdev_type);
+}
+
+module_init(nft_reject_netdev_module_init);
+module_exit(nft_reject_netdev_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Laura Garcia Liebana <nevola@gmail.com>");
+MODULE_ALIAS_NFT_AF_EXPR(5, "reject");
-- 
2.20.1

