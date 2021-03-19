Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC4B0C433DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Mar 2021 01:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA20C64DE4
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Mar 2021 01:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbhCSBGi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Mar 2021 21:06:38 -0400
Received: from mail.netfilter.org ([217.70.188.207]:52618 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbhCSBGW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Mar 2021 21:06:22 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id EAB45630BF;
        Fri, 19 Mar 2021 02:06:16 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 8/9] netfilter: flowtable: Make sure GC works periodically in idle system
Date:   Fri, 19 Mar 2021 02:06:07 +0100
Message-Id: <20210319010608.9758-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210319010608.9758-1-pablo@netfilter.org>
References: <20210319010608.9758-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

Currently flowtable's GC work is initialized as deferrable, which
means GC cannot work on time when system is idle. So the hardware
offloaded flow may be deleted for timeout, since its used time is
not timely updated.

Resolve it by initializing the GC work as delayed work instead of
deferrable.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 5fa657b8e03d..c77ba8690ed8 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -506,7 +506,7 @@ int nf_flow_table_init(struct nf_flowtable *flowtable)
 {
 	int err;
 
-	INIT_DEFERRABLE_WORK(&flowtable->gc_work, nf_flow_offload_work_gc);
+	INIT_DELAYED_WORK(&flowtable->gc_work, nf_flow_offload_work_gc);
 	flow_block_init(&flowtable->flow_block);
 	init_rwsem(&flowtable->flow_block_lock);
 
-- 
2.20.1

