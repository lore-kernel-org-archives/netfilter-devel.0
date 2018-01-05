From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/3] netfilter: nf_tables: fix potential NULL-ptr deref in nf_tables_dump_obj_done()
Date: Fri,  5 Jan 2018 16:08:25 +0100
Message-ID: <20180105150825.18460-4-pablo@netfilter.org>
References: <20180105150825.18460-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38782 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751624AbeAEPIg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Jan 2018 10:08:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BE412C515C
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Jan 2018 16:08:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AF9DD53CCE
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Jan 2018 16:08:34 +0100 (CET)
In-Reply-To: <20180105150825.18460-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Hangbin Liu <liuhangbin@gmail.com>

If there is no NFTA_OBJ_TABLE and NFTA_OBJ_TYPE, the c.data will be NULL in
nf_tables_getobj(). So before free filter->table in nf_tables_dump_obj_done(),
we need to check if filter is NULL first.

Fixes: e46abbcc05aa ("netfilter: nf_tables: Allow table names of up to 255 chars")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8d4526651661..07bd4138c84e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4665,8 +4665,10 @@ static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 {
 	struct nft_obj_filter *filter = cb->data;
 
-	kfree(filter->table);
-	kfree(filter);
+	if (filter) {
+		kfree(filter->table);
+		kfree(filter);
+	}
 
 	return 0;
 }
-- 
2.11.0

