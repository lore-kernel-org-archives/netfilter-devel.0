Return-Path: <SRS0=eCuo=7L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C342DC433E1
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 May 2020 00:26:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AADB3207F9
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 May 2020 00:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438104AbgE2AZ6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 May 2020 20:25:58 -0400
Received: from correo.us.es ([193.147.175.20]:44246 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438021AbgE2AZy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 May 2020 20:25:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E4836CF666
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2020 02:25:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D5702DA720
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2020 02:25:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C3E0BDA712; Fri, 29 May 2020 02:25:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 96F82DA70E;
        Fri, 29 May 2020 02:25:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 29 May 2020 02:25:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2BD96426CCB9;
        Fri, 29 May 2020 02:25:50 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, paulb@mellanox.com,
        ozsh@mellanox.com, vladbu@mellanox.com, jiri@resnulli.us,
        kuba@kernel.org, saeedm@mellanox.com, michael.chan@broadcom.com,
        sriharsha.basavapatna@broadcom.com
Subject: [PATCH net-next 1/8] netfilter: nf_flowtable: expose nf_flow_table_gc_cleanup()
Date:   Fri, 29 May 2020 02:25:34 +0200
Message-Id: <20200529002541.19743-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200529002541.19743-1-pablo@netfilter.org>
References: <20200529002541.19743-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This function schedules the flow teardown state and it forces a gc run.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h | 2 ++
 net/netfilter/nf_flow_table_core.c    | 6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index c54a7f707e50..d7338bfd7b0f 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -175,6 +175,8 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 
 struct flow_offload_tuple_rhash *flow_offload_lookup(struct nf_flowtable *flow_table,
 						     struct flow_offload_tuple *tuple);
+void nf_flow_table_gc_cleanup(struct nf_flowtable *flowtable,
+			      struct net_device *dev);
 void nf_flow_table_cleanup(struct net_device *dev);
 
 int nf_flow_table_init(struct nf_flowtable *flow_table);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 42da6e337276..6a3034f84ab6 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -588,8 +588,8 @@ static void nf_flow_table_do_cleanup(struct flow_offload *flow, void *data)
 		flow_offload_teardown(flow);
 }
 
-static void nf_flow_table_iterate_cleanup(struct nf_flowtable *flowtable,
-					  struct net_device *dev)
+void nf_flow_table_gc_cleanup(struct nf_flowtable *flowtable,
+			      struct net_device *dev)
 {
 	nf_flow_table_iterate(flowtable, nf_flow_table_do_cleanup, dev);
 	flush_delayed_work(&flowtable->gc_work);
@@ -602,7 +602,7 @@ void nf_flow_table_cleanup(struct net_device *dev)
 
 	mutex_lock(&flowtable_lock);
 	list_for_each_entry(flowtable, &flowtables, list)
-		nf_flow_table_iterate_cleanup(flowtable, dev);
+		nf_flow_table_gc_cleanup(flowtable, dev);
 	mutex_unlock(&flowtable_lock);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_cleanup);
-- 
2.20.1

