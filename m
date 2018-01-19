From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: nf_tables: set flowtable priority and hooknum field
Date: Fri, 19 Jan 2018 13:03:07 +0100
Message-ID: <20180119120307.13925-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34610 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754771AbeASMDN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 07:03:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4A46C1BCFC0
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 13:03:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3C962DA855
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 13:03:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 492B6DA855
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 13:03:10 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0C2664265A2F
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 13:03:09 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Otherwise netlink dump sends uninitialized fields to userspace.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1addc401ff7d..f87314c6dcc4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4946,6 +4946,8 @@ static int nf_tables_flowtable_parse_hook(const struct nft_ctx *ctx,
 		goto err1;
 	}
 
+	flowtable->hooknum	= hooknum;
+	flowtable->priority	= priority;
 	flowtable->ops		= ops;
 	flowtable->ops_len	= n;
 
-- 
2.11.0

