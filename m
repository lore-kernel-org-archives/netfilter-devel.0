Return-Path: <SRS0=2jko=VQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B771C76196
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 16:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EAF12186A
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 16:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732115AbfGSQqh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Jul 2019 12:46:37 -0400
Received: from mail.us.es ([193.147.175.20]:50248 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732149AbfGSQqe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jul 2019 12:46:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8B1B3BAEE8
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jul 2019 18:46:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7D4DEDA4D1
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jul 2019 18:46:32 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7317D1150B9; Fri, 19 Jul 2019 18:46:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 69DD8FF6CC;
        Fri, 19 Jul 2019 18:46:30 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 19 Jul 2019 18:46:30 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.47.94])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DA17B4265A2F;
        Fri, 19 Jul 2019 18:46:29 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 14/14] netfilter: bridge: make NF_TABLES_BRIDGE tristate
Date:   Fri, 19 Jul 2019 18:46:18 +0200
Message-Id: <20190719164618.29581-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190719164618.29581-1-pablo@netfilter.org>
References: <20190719164618.29581-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The new nft_meta_bridge code fails to link as built-in when NF_TABLES
is a loadable module.

net/bridge/netfilter/nft_meta_bridge.o: In function `nft_meta_bridge_get_eval':
nft_meta_bridge.c:(.text+0x1e8): undefined reference to `nft_meta_get_eval'
net/bridge/netfilter/nft_meta_bridge.o: In function `nft_meta_bridge_get_init':
nft_meta_bridge.c:(.text+0x468): undefined reference to `nft_meta_get_init'
nft_meta_bridge.c:(.text+0x49c): undefined reference to `nft_parse_register'
nft_meta_bridge.c:(.text+0x4cc): undefined reference to `nft_validate_register_store'
net/bridge/netfilter/nft_meta_bridge.o: In function `nft_meta_bridge_module_exit':
nft_meta_bridge.c:(.exit.text+0x14): undefined reference to `nft_unregister_expr'
net/bridge/netfilter/nft_meta_bridge.o: In function `nft_meta_bridge_module_init':
nft_meta_bridge.c:(.init.text+0x14): undefined reference to `nft_register_expr'
net/bridge/netfilter/nft_meta_bridge.o:(.rodata+0x60): undefined reference to `nft_meta_get_dump'
net/bridge/netfilter/nft_meta_bridge.o:(.rodata+0x88): undefined reference to `nft_meta_set_eval'

This can happen because the NF_TABLES_BRIDGE dependency itself is just a
'bool'.  Make the symbol a 'tristate' instead so Kconfig can propagate the
dependencies correctly.

Fixes: 30e103fe24de ("netfilter: nft_meta: move bridge meta keys into nft_meta_bridge")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/Kconfig     | 2 +-
 net/netfilter/nft_chain_filter.c | 2 +-
 net/netfilter/nft_meta.c         | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index 30d8241b426f..5040fe43f4b4 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -6,7 +6,7 @@
 menuconfig NF_TABLES_BRIDGE
 	depends on BRIDGE && NETFILTER && NF_TABLES
 	select NETFILTER_FAMILY_BRIDGE
-	bool "Ethernet Bridge nf_tables support"
+	tristate "Ethernet Bridge nf_tables support"
 
 if NF_TABLES_BRIDGE
 
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 3fd540b2c6ba..b5d5d071d765 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -193,7 +193,7 @@ static inline void nft_chain_filter_inet_init(void) {}
 static inline void nft_chain_filter_inet_fini(void) {}
 #endif /* CONFIG_NF_TABLES_IPV6 */
 
-#ifdef CONFIG_NF_TABLES_BRIDGE
+#if IS_ENABLED(CONFIG_NF_TABLES_BRIDGE)
 static unsigned int
 nft_do_chain_bridge(void *priv,
 		    struct sk_buff *skb,
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 865888933a83..f1b1d948c07b 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -546,7 +546,7 @@ nft_meta_select_ops(const struct nft_ctx *ctx,
 	if (tb[NFTA_META_DREG] && tb[NFTA_META_SREG])
 		return ERR_PTR(-EINVAL);
 
-#if defined(CONFIG_NF_TABLES_BRIDGE) && IS_MODULE(CONFIG_NFT_BRIDGE_META)
+#if IS_ENABLED(CONFIG_NF_TABLES_BRIDGE) && IS_MODULE(CONFIG_NFT_BRIDGE_META)
 	if (ctx->family == NFPROTO_BRIDGE)
 		return ERR_PTR(-EAGAIN);
 #endif
-- 
2.11.0


