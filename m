Return-Path: <SRS0=knZt=22=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97BAEC33C8C
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Jan 2020 21:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6228020848
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Jan 2020 21:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgAEViz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Jan 2020 16:38:55 -0500
Received: from correo.us.es ([193.147.175.20]:36436 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbgAEViz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Jan 2020 16:38:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EAE0A120827
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Jan 2020 22:38:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DCCC8DA702
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Jan 2020 22:38:52 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D24EFDA701; Sun,  5 Jan 2020 22:38:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C82D8DA702
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Jan 2020 22:38:50 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 05 Jan 2020 22:38:50 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id ADB4441E4801
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Jan 2020 22:38:50 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] netfilter: flowtable: fetch stats only if flow is still alive
Date:   Sun,  5 Jan 2020 22:38:48 +0100
Message-Id: <20200105213848.265409-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Do not fetch statistics if flow has expired since it might not in
hardware anymore.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index e33a73cb1f42..9e6de2bbeccb 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -348,9 +348,6 @@ static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
 {
 	struct nf_flowtable *flow_table = data;
 
-	if (flow->flags & FLOW_OFFLOAD_HW)
-		nf_flow_offload_stats(flow_table, flow);
-
 	if (nf_flow_has_expired(flow) || nf_ct_is_dying(flow->ct) ||
 	    (flow->flags & (FLOW_OFFLOAD_DYING | FLOW_OFFLOAD_TEARDOWN))) {
 		if (flow->flags & FLOW_OFFLOAD_HW) {
@@ -361,6 +358,8 @@ static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
 		} else {
 			flow_offload_del(flow_table, flow);
 		}
+	} else if (flow->flags & FLOW_OFFLOAD_HW) {
+		nf_flow_offload_stats(flow_table, flow);
 	}
 }
 
-- 
2.11.0

