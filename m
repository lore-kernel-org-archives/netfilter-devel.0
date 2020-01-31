Return-Path: <SRS0=LRZR=3U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA78C33CB7
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 19:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F7702082E
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 19:24:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgAaTYr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 Jan 2020 14:24:47 -0500
Received: from correo.us.es ([193.147.175.20]:36832 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbgAaTYj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 14:24:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A2BBDFC5F6
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jan 2020 20:24:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 88524DA70F
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jan 2020 20:24:37 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7DCE9DA702; Fri, 31 Jan 2020 20:24:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 86BFDDA707;
        Fri, 31 Jan 2020 20:24:35 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 Jan 2020 20:24:35 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5B24342EFB80;
        Fri, 31 Jan 2020 20:24:35 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 4/6] netfilter: flowtable: Fix missing flush hardware on table free
Date:   Fri, 31 Jan 2020 20:24:26 +0100
Message-Id: <20200131192428.167274-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200131192428.167274-1-pablo@netfilter.org>
References: <20200131192428.167274-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

If entries exist when freeing a hardware offload enabled table,
we queue work for hardware while running the gc iteration.

Execute it (flush) after queueing.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 14a069c72bb2..8af28e10b4e6 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -553,6 +553,7 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 	cancel_delayed_work_sync(&flow_table->gc_work);
 	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
 	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, flow_table);
+	nf_flow_table_offload_flush(flow_table);
 	rhashtable_destroy(&flow_table->rhashtable);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
-- 
2.11.0

