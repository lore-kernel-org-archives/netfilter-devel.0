Return-Path: <SRS0=CFkq=5P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39B4AC2D0E7
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Mar 2020 00:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AB5920780
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Mar 2020 00:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbgC3Ahr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 29 Mar 2020 20:37:47 -0400
Received: from correo.us.es ([193.147.175.20]:57198 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727984AbgC3AhZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Mar 2020 20:37:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 65FC1EF430
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2020 02:37:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5548A100A52
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2020 02:37:23 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4AF71100A4B; Mon, 30 Mar 2020 02:37:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4EE05DA736;
        Mon, 30 Mar 2020 02:37:21 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 02:37:21 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 23FA542EF42A;
        Mon, 30 Mar 2020 02:37:21 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 16/26] netfilter: flowtable: Use work entry per offload command
Date:   Mon, 30 Mar 2020 02:36:58 +0200
Message-Id: <20200330003708.54017-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200330003708.54017-1-pablo@netfilter.org>
References: <20200330003708.54017-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

To allow offload commands to execute in parallel, create workqueue
for flow table offload, and use a work entry per offload command.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 46 ++++++++++++-----------------------
 1 file changed, 15 insertions(+), 31 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index b96db831b4ca..a9b3b88bd0f1 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -12,9 +12,7 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 
-static struct work_struct nf_flow_offload_work;
-static DEFINE_SPINLOCK(flow_offload_pending_list_lock);
-static LIST_HEAD(flow_offload_pending_list);
+static struct workqueue_struct *nf_flow_offload_wq;
 
 struct flow_offload_work {
 	struct list_head	list;
@@ -22,6 +20,7 @@ struct flow_offload_work {
 	int			priority;
 	struct nf_flowtable	*flowtable;
 	struct flow_offload	*flow;
+	struct work_struct	work;
 };
 
 #define NF_FLOW_DISSECTOR(__match, __type, __field)	\
@@ -788,15 +787,10 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
 
 static void flow_offload_work_handler(struct work_struct *work)
 {
-	struct flow_offload_work *offload, *next;
-	LIST_HEAD(offload_pending_list);
-
-	spin_lock_bh(&flow_offload_pending_list_lock);
-	list_replace_init(&flow_offload_pending_list, &offload_pending_list);
-	spin_unlock_bh(&flow_offload_pending_list_lock);
+	struct flow_offload_work *offload;
 
-	list_for_each_entry_safe(offload, next, &offload_pending_list, list) {
-		switch (offload->cmd) {
+	offload = container_of(work, struct flow_offload_work, work);
+	switch (offload->cmd) {
 		case FLOW_CLS_REPLACE:
 			flow_offload_work_add(offload);
 			break;
@@ -808,19 +802,14 @@ static void flow_offload_work_handler(struct work_struct *work)
 			break;
 		default:
 			WARN_ON_ONCE(1);
-		}
-		list_del(&offload->list);
-		kfree(offload);
 	}
+
+	kfree(offload);
 }
 
 static void flow_offload_queue_work(struct flow_offload_work *offload)
 {
-	spin_lock_bh(&flow_offload_pending_list_lock);
-	list_add_tail(&offload->list, &flow_offload_pending_list);
-	spin_unlock_bh(&flow_offload_pending_list_lock);
-
-	schedule_work(&nf_flow_offload_work);
+	queue_work(nf_flow_offload_wq, &offload->work);
 }
 
 static struct flow_offload_work *
@@ -837,6 +826,7 @@ nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
 	offload->flow = flow;
 	offload->priority = flowtable->priority;
 	offload->flowtable = flowtable;
+	INIT_WORK(&offload->work, flow_offload_work_handler);
 
 	return offload;
 }
@@ -887,7 +877,7 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 void nf_flow_table_offload_flush(struct nf_flowtable *flowtable)
 {
 	if (nf_flowtable_hw_offload(flowtable))
-		flush_work(&nf_flow_offload_work);
+		flush_workqueue(nf_flow_offload_wq);
 }
 
 static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
@@ -1052,7 +1042,10 @@ static struct flow_indr_block_entry block_ing_entry = {
 
 int nf_flow_table_offload_init(void)
 {
-	INIT_WORK(&nf_flow_offload_work, flow_offload_work_handler);
+	nf_flow_offload_wq  = alloc_workqueue("nf_flow_table_offload",
+					      WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
+	if (!nf_flow_offload_wq)
+		return -ENOMEM;
 
 	flow_indr_add_block_cb(&block_ing_entry);
 
@@ -1061,15 +1054,6 @@ int nf_flow_table_offload_init(void)
 
 void nf_flow_table_offload_exit(void)
 {
-	struct flow_offload_work *offload, *next;
-	LIST_HEAD(offload_pending_list);
-
 	flow_indr_del_block_cb(&block_ing_entry);
-
-	cancel_work_sync(&nf_flow_offload_work);
-
-	list_for_each_entry_safe(offload, next, &offload_pending_list, list) {
-		list_del(&offload->list);
-		kfree(offload);
-	}
+	destroy_workqueue(nf_flow_offload_wq);
 }
-- 
2.11.0

