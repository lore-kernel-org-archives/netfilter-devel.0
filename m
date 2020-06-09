Return-Path: <SRS0=M6WU=7W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA7CC433DF
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jun 2020 21:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBD7B20734
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jun 2020 21:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbgFIVrx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Jun 2020 17:47:53 -0400
Received: from correo.us.es ([193.147.175.20]:51324 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728076AbgFIVrw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jun 2020 17:47:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0ABEE1A7AA8
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2020 23:47:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F1245DA858
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2020 23:47:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E3984DA84F; Tue,  9 Jun 2020 23:47:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7DD6ADA73D;
        Tue,  9 Jun 2020 23:47:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Jun 2020 23:47:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4D343426CCBA;
        Tue,  9 Jun 2020 23:47:47 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        jacob.e.keller@intel.com
Subject: [PATCH] net: flow_offload: remove indirect flow_block declarations leftover
Date:   Tue,  9 Jun 2020 23:47:44 +0200
Message-Id: <20200609214744.28412-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Remove function declarations that are not available in the tree anymore.

Fixes: 709ffbe19b77 ("net: remove indirect block netdev event registration")
Reported-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/flow_offload.h | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 69e13c8b6b3a..f2c8311a0433 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -542,28 +542,4 @@ int flow_indr_dev_setup_offload(struct net_device *dev,
 				struct flow_block_offload *bo,
 				void (*cleanup)(struct flow_block_cb *block_cb));
 
-typedef void flow_indr_block_cmd_t(struct net_device *dev,
-				   flow_indr_block_bind_cb_t *cb, void *cb_priv,
-				   enum flow_block_command command);
-
-int __flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
-				  flow_indr_block_bind_cb_t *cb,
-				  void *cb_ident);
-
-void __flow_indr_block_cb_unregister(struct net_device *dev,
-				     flow_indr_block_bind_cb_t *cb,
-				     void *cb_ident);
-
-int flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
-				flow_indr_block_bind_cb_t *cb, void *cb_ident);
-
-void flow_indr_block_cb_unregister(struct net_device *dev,
-				   flow_indr_block_bind_cb_t *cb,
-				   void *cb_ident);
-
-void flow_indr_block_call(struct net_device *dev,
-			  struct flow_block_offload *bo,
-			  enum flow_block_command command,
-			  enum tc_setup_type type);
-
 #endif /* _NET_FLOW_OFFLOAD_H */
-- 
2.20.1

