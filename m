From: Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH nf] netfilter: nf_tables: fix potential NULL-ptr deref in nf_tables_dump_obj_done()
Date: Mon, 25 Dec 2017 11:34:54 +0800
Message-ID: <1514172894-8477-1-git-send-email-liuhangbin@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
        Hangbin Liu <liuhangbin@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:44023 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751891AbdLYDfX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Dec 2017 22:35:23 -0500
Received: by mail-pf0-f193.google.com with SMTP id e3so17518022pfi.10
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Dec 2017 19:35:22 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If there is no NFTA_OBJ_TABLE and NFTA_OBJ_TYPE, the c.data will be NULL in
nf_tables_getobj(). So before free filter->table in nf_tables_dump_obj_done(),
we need to check if filter is NULL first.

Fixes: e46abbcc05aa ("netfilter: nf_tables: Allow table names of up to 255 chars")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 10798b3..bfaa320 100644
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
2.5.5

