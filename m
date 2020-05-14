Return-Path: <SRS0=bPAQ=64=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8467C433E1
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 May 2020 12:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F3FB206A5
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 May 2020 12:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgENMTX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 May 2020 08:19:23 -0400
Received: from correo.us.es ([193.147.175.20]:54266 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726872AbgENMTW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 May 2020 08:19:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 30D3715AEB3
        for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2020 14:19:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 236B9DA715
        for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2020 14:19:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 225D6DA713; Thu, 14 May 2020 14:19:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1D5E6DA715;
        Thu, 14 May 2020 14:19:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 14 May 2020 14:19:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id ECA8642EF42A;
        Thu, 14 May 2020 14:19:17 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 2/6] netfilter: flowtable: Add pending bit for offload work
Date:   Thu, 14 May 2020 14:19:09 +0200
Message-Id: <20200514121913.24519-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514121913.24519-1-pablo@netfilter.org>
References: <20200514121913.24519-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Gc step can queue offloaded flow del work or stats work.
Those work items can race each other and a flow could be freed
before the stats work is executed and querying it.
To avoid that, add a pending bit that if a work exists for a flow
don't queue another work for it.
This will also avoid adding multiple stats works in case stats work
didn't complete but gc step started again.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h | 1 +
 net/netfilter/nf_flow_table_offload.c | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 6bf69652f57d..c54a7f707e50 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -127,6 +127,7 @@ enum nf_flow_flags {
 	NF_FLOW_HW_DYING,
 	NF_FLOW_HW_DEAD,
 	NF_FLOW_HW_REFRESH,
+	NF_FLOW_HW_PENDING,
 };
 
 enum flow_offload_type {
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index e3b099c14eff..3d4ca62c81f9 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -817,6 +817,7 @@ static void flow_offload_work_handler(struct work_struct *work)
 			WARN_ON_ONCE(1);
 	}
 
+	clear_bit(NF_FLOW_HW_PENDING, &offload->flow->flags);
 	kfree(offload);
 }
 
@@ -831,9 +832,14 @@ nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
 {
 	struct flow_offload_work *offload;
 
+	if (test_and_set_bit(NF_FLOW_HW_PENDING, &flow->flags))
+		return NULL;
+
 	offload = kmalloc(sizeof(struct flow_offload_work), GFP_ATOMIC);
-	if (!offload)
+	if (!offload) {
+		clear_bit(NF_FLOW_HW_PENDING, &flow->flags);
 		return NULL;
+	}
 
 	offload->cmd = cmd;
 	offload->flow = flow;
-- 
2.20.1

