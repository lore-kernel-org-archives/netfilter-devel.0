Return-Path: <SRS0=LRZR=3U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA671C35246
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 19:24:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EED82082E
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 19:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgAaTYi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 Jan 2020 14:24:38 -0500
Received: from correo.us.es ([193.147.175.20]:36818 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgAaTYi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 14:24:38 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EA3FBFC5F2
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jan 2020 20:24:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DC074DA714
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jan 2020 20:24:36 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D1DBBDA712; Fri, 31 Jan 2020 20:24:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DF921DA702;
        Fri, 31 Jan 2020 20:24:34 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 Jan 2020 20:24:34 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B301F42EFB80;
        Fri, 31 Jan 2020 20:24:34 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 3/6] netfilter: flowtable: Fix hardware flush order on nf_flow_table_cleanup
Date:   Fri, 31 Jan 2020 20:24:25 +0100
Message-Id: <20200131192428.167274-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200131192428.167274-1-pablo@netfilter.org>
References: <20200131192428.167274-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

On netdev down event, nf_flow_table_cleanup() is called for the relevant
device and it cleans all the tables that are on that device.
If one of those tables has hardware offload flag,
nf_flow_table_iterate_cleanup flushes hardware and then runs the gc.
But the gc can queue more hardware work, which will take time to execute.

Instead first add the work, then flush it, to execute it now.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 7e91989a1b55..14a069c72bb2 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -529,9 +529,9 @@ static void nf_flow_table_do_cleanup(struct flow_offload *flow, void *data)
 static void nf_flow_table_iterate_cleanup(struct nf_flowtable *flowtable,
 					  struct net_device *dev)
 {
-	nf_flow_table_offload_flush(flowtable);
 	nf_flow_table_iterate(flowtable, nf_flow_table_do_cleanup, dev);
 	flush_delayed_work(&flowtable->gc_work);
+	nf_flow_table_offload_flush(flowtable);
 }
 
 void nf_flow_table_cleanup(struct net_device *dev)
-- 
2.11.0

