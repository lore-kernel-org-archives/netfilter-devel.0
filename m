Return-Path: <SRS0=xASF=3C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E75F4C33CAF
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jan 2020 18:16:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C43F4207E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jan 2020 18:16:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbgAMSQF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Jan 2020 13:16:05 -0500
Received: from correo.us.es ([193.147.175.20]:34714 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726878AbgAMSQE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Jan 2020 13:16:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 195EA15AEA8
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2020 19:16:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 04BFBDA714
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2020 19:16:03 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EBC12DA705; Mon, 13 Jan 2020 19:16:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9F6ABDA712
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2020 19:16:00 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 13 Jan 2020 19:16:00 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (50.pool85-54-104.dynamic.orange.es [85.54.104.50])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7F83D42EF532
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2020 19:16:00 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 3/9] netfilter: flowtable: add nf_flow_offload_work_alloc()
Date:   Mon, 13 Jan 2020 19:15:48 +0100
Message-Id: <20200113181554.52612-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200113181554.52612-1-pablo@netfilter.org>
References: <20200113181554.52612-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add helper function to allocate and initialize flow offload work and use
it to consolidate existing code.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: rebase on top of nf-next.

 net/netfilter/nf_flow_table_offload.c | 38 ++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index b879e673953f..d161623107a1 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -748,21 +748,35 @@ static void flow_offload_queue_work(struct flow_offload_work *offload)
 	schedule_work(&nf_flow_offload_work);
 }
 
-void nf_flow_offload_add(struct nf_flowtable *flowtable,
-			 struct flow_offload *flow)
+static struct flow_offload_work *
+nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
+			   struct flow_offload *flow, unsigned int cmd)
 {
 	struct flow_offload_work *offload;
 
 	offload = kmalloc(sizeof(struct flow_offload_work), GFP_ATOMIC);
 	if (!offload)
-		return;
+		return NULL;
 
-	offload->cmd = FLOW_CLS_REPLACE;
+	offload->cmd = cmd;
 	offload->flow = flow;
 	offload->priority = flowtable->priority;
 	offload->flowtable = flowtable;
-	flow->flags |= FLOW_OFFLOAD_HW;
 
+	return offload;
+}
+
+
+void nf_flow_offload_add(struct nf_flowtable *flowtable,
+			 struct flow_offload *flow)
+{
+	struct flow_offload_work *offload;
+
+	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_REPLACE);
+	if (!offload)
+		return;
+
+	flow->flags |= FLOW_OFFLOAD_HW;
 	flow_offload_queue_work(offload);
 }
 
@@ -771,15 +785,11 @@ void nf_flow_offload_del(struct nf_flowtable *flowtable,
 {
 	struct flow_offload_work *offload;
 
-	offload = kzalloc(sizeof(struct flow_offload_work), GFP_ATOMIC);
+	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_DESTROY);
 	if (!offload)
 		return;
 
-	offload->cmd = FLOW_CLS_DESTROY;
-	offload->flow = flow;
-	offload->flow->flags |= FLOW_OFFLOAD_HW_DYING;
-	offload->flowtable = flowtable;
-
+	flow->flags |= FLOW_OFFLOAD_HW_DYING;
 	flow_offload_queue_work(offload);
 }
 
@@ -793,14 +803,10 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 	if ((delta >= (9 * NF_FLOW_TIMEOUT) / 10))
 		return;
 
-	offload = kzalloc(sizeof(struct flow_offload_work), GFP_ATOMIC);
+	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_STATS);
 	if (!offload)
 		return;
 
-	offload->cmd = FLOW_CLS_STATS;
-	offload->flow = flow;
-	offload->flowtable = flowtable;
-
 	flow_offload_queue_work(offload);
 }
 
-- 
2.11.0

