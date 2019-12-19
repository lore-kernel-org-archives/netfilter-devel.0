Return-Path: <SRS0=pcvh=2J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56526C43603
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 13:56:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EB6C218AC
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 13:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfLSN42 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 08:56:28 -0500
Received: from correo.us.es ([193.147.175.20]:50230 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726759AbfLSN42 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 08:56:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 076107FC28
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Dec 2019 14:56:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EAFF1DA70A
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Dec 2019 14:56:25 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E98EFDA701; Thu, 19 Dec 2019 14:56:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 903ACDA70B
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Dec 2019 14:56:22 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 19 Dec 2019 14:56:22 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8066D42EF42C
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Dec 2019 14:56:22 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: flowtable: clean up entries for FLOW_BLOCK_UNBIND
Date:   Thu, 19 Dec 2019 14:56:20 +0100
Message-Id: <20191219135620.350881-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Call nf_flow_table_iterate_cleanup() to remove flowtable entries.
This patch is implicitly handling the NETDEV_UNREGISTER and the
flowtable removal cases (while there are still entries in place).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
This patch supersedes: https://patchwork.ozlabs.org/patch/1213189/

 include/net/netfilter/nf_flow_table.h | 2 ++
 net/netfilter/nf_flow_table_core.c    | 4 ++--
 net/netfilter/nf_flow_table_offload.c | 3 +++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index f0897b3c97fb..09a7bcbd3cd7 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -122,6 +122,8 @@ int flow_offload_route_init(struct flow_offload *flow,
 int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow);
 struct flow_offload_tuple_rhash *flow_offload_lookup(struct nf_flowtable *flow_table,
 						     struct flow_offload_tuple *tuple);
+void nf_flow_table_iterate_cleanup(struct nf_flowtable *flowtable,
+				   struct net_device *dev);
 void nf_flow_table_cleanup(struct net_device *dev);
 
 int nf_flow_table_init(struct nf_flowtable *flow_table);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 9889d52eda82..9a7421e2b039 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -532,8 +532,8 @@ static void nf_flow_table_do_cleanup(struct flow_offload *flow, void *data)
 		flow_offload_dead(flow);
 }
 
-static void nf_flow_table_iterate_cleanup(struct nf_flowtable *flowtable,
-					  struct net_device *dev)
+void nf_flow_table_iterate_cleanup(struct nf_flowtable *flowtable,
+				   struct net_device *dev)
 {
 	nf_flow_table_offload_flush(flowtable);
 	nf_flow_table_iterate(flowtable, nf_flow_table_do_cleanup, dev);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index c54c9a6cc981..506aaaf8151d 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -809,6 +809,9 @@ int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 	struct flow_block_offload bo = {};
 	int err;
 
+	if (cmd == FLOW_BLOCK_UNBIND)
+		nf_flow_table_iterate_cleanup(flowtable, dev);
+
 	if (!(flowtable->flags & NF_FLOWTABLE_HW_OFFLOAD))
 		return 0;
 
-- 
2.11.0

