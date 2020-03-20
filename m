Return-Path: <SRS0=s0US=5F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04A83C4332B
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Mar 2020 13:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDEED2076E
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Mar 2020 13:51:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgCTNvo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Mar 2020 09:51:44 -0400
Received: from correo.us.es ([193.147.175.20]:41534 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726953AbgCTNvo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Mar 2020 09:51:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4CB1D172C91
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2020 14:51:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3D01EDA3C3
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2020 14:51:10 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 32B0DDA3C2; Fri, 20 Mar 2020 14:51:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3AB31DA8E6;
        Fri, 20 Mar 2020 14:51:08 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Mar 2020 14:51:08 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0D7ED42EE38E;
        Fri, 20 Mar 2020 14:51:08 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 3/4] netfilter: flowtable: Fix flushing of offloaded flows on free
Date:   Fri, 20 Mar 2020 14:51:33 +0100
Message-Id: <20200320135134.436907-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200320135134.436907-1-pablo@netfilter.org>
References: <20200320135134.436907-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Freeing a flowtable with offloaded flows, the flow are deleted from
hardware but are not deleted from the flow table, leaking them,
and leaving their offload bit on.

Add a second pass of the disabled gc to delete the these flows from
the flow table before freeing it.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 8af28e10b4e6..70ebebaf5bc1 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -554,6 +554,9 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
 	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, flow_table);
 	nf_flow_table_offload_flush(flow_table);
+	if (nf_flowtable_hw_offload(flow_table))
+		nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step,
+				      flow_table);
 	rhashtable_destroy(&flow_table->rhashtable);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
-- 
2.11.0

