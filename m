Return-Path: <SRS0=xASF=3C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C7BC33CAF
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jan 2020 18:16:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72EBD207FD
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jan 2020 18:16:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgAMSQK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Jan 2020 13:16:10 -0500
Received: from correo.us.es ([193.147.175.20]:34748 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbgAMSQG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Jan 2020 13:16:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9E3B415AEA2
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2020 19:16:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8F6C8DA702
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2020 19:16:04 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 852ABDA705; Mon, 13 Jan 2020 19:16:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4D06CDA702
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2020 19:16:02 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 13 Jan 2020 19:16:02 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (50.pool85-54-104.dynamic.orange.es [85.54.104.50])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2DBFB42EF52A
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2020 19:16:02 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 6/9] netfilter: flowtable: add nf_flowtable_hw_offload() helper function
Date:   Mon, 13 Jan 2020 19:15:51 +0100
Message-Id: <20200113181554.52612-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200113181554.52612-1-pablo@netfilter.org>
References: <20200113181554.52612-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This function checks for the NF_FLOWTABLE_HW_OFFLOAD flag, meaning that
the flowtable hardware offload is enabled.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h | 5 +++++
 net/netfilter/nf_flow_table_core.c    | 2 +-
 net/netfilter/nf_flow_table_offload.c | 4 ++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 5a10e28c3e40..9ee1eaeaab04 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -47,6 +47,11 @@ struct nf_flowtable {
 	possible_net_t			net;
 };
 
+static inline bool nf_flowtable_hw_offload(struct nf_flowtable *flowtable)
+{
+	return flowtable->flags & NF_FLOWTABLE_HW_OFFLOAD;
+}
+
 enum flow_offload_tuple_dir {
 	FLOW_OFFLOAD_DIR_ORIGINAL = IP_CT_DIR_ORIGINAL,
 	FLOW_OFFLOAD_DIR_REPLY = IP_CT_DIR_REPLY,
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 9f134f44d139..e919bafd68d1 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -243,7 +243,7 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 		return err;
 	}
 
-	if (flow_table->flags & NF_FLOWTABLE_HW_OFFLOAD)
+	if (nf_flowtable_hw_offload(flow_table))
 		nf_flow_offload_add(flow_table, flow);
 
 	return 0;
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 8a1fe391666e..b4c79fbb2d82 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -812,7 +812,7 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 
 void nf_flow_table_offload_flush(struct nf_flowtable *flowtable)
 {
-	if (flowtable->flags & NF_FLOWTABLE_HW_OFFLOAD)
+	if (nf_flowtable_hw_offload(flowtable))
 		flush_work(&nf_flow_offload_work);
 }
 
@@ -849,7 +849,7 @@ int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 	struct flow_block_offload bo = {};
 	int err;
 
-	if (!(flowtable->flags & NF_FLOWTABLE_HW_OFFLOAD))
+	if (!nf_flowtable_hw_offload(flowtable))
 		return 0;
 
 	if (!dev->netdev_ops->ndo_setup_tc)
-- 
2.11.0

