Return-Path: <SRS0=S009=3H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 234DEC33CB6
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 20:15:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0230624683
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 20:15:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgARUO2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 Jan 2020 15:14:28 -0500
Received: from correo.us.es ([193.147.175.20]:48414 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbgARUO1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 Jan 2020 15:14:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2B06B2EFEA6
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Jan 2020 21:14:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1DD41DA710
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Jan 2020 21:14:26 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 136DCDA709; Sat, 18 Jan 2020 21:14:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 10B6DDA703;
        Sat, 18 Jan 2020 21:14:24 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 18 Jan 2020 21:14:24 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DE24441E4800;
        Sat, 18 Jan 2020 21:14:23 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 04/21] netfilter: flowtable: add nf_flow_offload_work_alloc()
Date:   Sat, 18 Jan 2020 21:14:00 +0100
Message-Id: <20200118201417.334111-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200118201417.334111-1-pablo@netfilter.org>
References: <20200118201417.334111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add helper function to allocate and initialize flow offload work and use
it to consolidate existing code.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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

