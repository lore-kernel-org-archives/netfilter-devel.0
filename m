Return-Path: <SRS0=knZt=22=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F83C33C8C
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Jan 2020 22:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 683202072C
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Jan 2020 22:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgAEWEt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Jan 2020 17:04:49 -0500
Received: from correo.us.es ([193.147.175.20]:41246 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbgAEWEs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Jan 2020 17:04:48 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6D55712082D
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Jan 2020 23:04:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5D9A5DA702
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Jan 2020 23:04:46 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5358FDA70E; Sun,  5 Jan 2020 23:04:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5381ADA703
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Jan 2020 23:04:44 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 05 Jan 2020 23:04:44 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 40B6841E4800
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Jan 2020 23:04:44 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 1/3] netfilter: flowtable: add nf_flow_offload_work_alloc()
Date:   Sun,  5 Jan 2020 23:04:39 +0100
Message-Id: <20200105220441.276512-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add helper function to allocate and initialize flow offload work and use
it to consolidate existing code.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: move this update at the head of this batch.

 net/netfilter/nf_flow_table_offload.c | 38 ++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 4d1e81e2880f..ebf0b92c0196 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -742,21 +742,35 @@ static void flow_offload_queue_work(struct flow_offload_work *offload)
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
 
@@ -765,15 +779,11 @@ void nf_flow_offload_del(struct nf_flowtable *flowtable,
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
 
@@ -787,14 +797,10 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
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

