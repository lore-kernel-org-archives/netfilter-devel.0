Return-Path: <SRS0=Vh4p=6F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FB7FC54FC9
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Apr 2020 10:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6485D20663
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Apr 2020 10:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgDUKiJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Apr 2020 06:38:09 -0400
Received: from correo.us.es ([193.147.175.20]:50998 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbgDUKiJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 06:38:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ECCE9FB451
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2020 12:38:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DF76FFF6F2
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2020 12:38:06 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D46BEDA736; Tue, 21 Apr 2020 12:38:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F1BD7DA3C4;
        Tue, 21 Apr 2020 12:38:04 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 21 Apr 2020 12:38:04 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C23BE42EF42B;
        Tue, 21 Apr 2020 12:38:04 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/2] netfilter: flowtable: Free block_cb when being deleted
Date:   Tue, 21 Apr 2020 12:37:58 +0200
Message-Id: <20200421103759.959074-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200421103759.959074-1-pablo@netfilter.org>
References: <20200421103759.959074-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

Free block_cb memory when asked to be deleted.

Fixes: 978703f42549 ("netfilter: flowtable: Add API for registering to flow table events")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index c0cb79495c35..4344e572b7f9 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -421,10 +421,12 @@ void nf_flow_table_offload_del_cb(struct nf_flowtable *flow_table,
 
 	down_write(&flow_table->flow_block_lock);
 	block_cb = flow_block_cb_lookup(block, cb, cb_priv);
-	if (block_cb)
+	if (block_cb) {
 		list_del(&block_cb->list);
-	else
+		flow_block_cb_free(block_cb);
+	} else {
 		WARN_ON(true);
+	}
 	up_write(&flow_table->flow_block_lock);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_offload_del_cb);
-- 
2.11.0

