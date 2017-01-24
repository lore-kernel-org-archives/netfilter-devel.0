From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf,v2 3/3] netfilter: nf_tables: bump set->ndeact on set flush
Date: Tue, 24 Jan 2017 19:42:59 +0100
Message-ID: <1485283379-9281-3-git-send-email-pablo@netfilter.org>
References: <1485283379-9281-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49612 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750981AbdAXSnO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Jan 2017 13:43:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 00BEC1EC2C7
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 19:43:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E4D8AFF12C
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 19:43:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7972DA7E99
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 19:43:05 +0100 (CET)
In-Reply-To: <1485283379-9281-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add missing set->ndeact update on each deactivated element from the set
flush path. Otherwise, sets with fixed size break after flush since
accounting breaks.

 # nft add set x y { type ipv4_addr\; size 2\; }
 # nft add element x y { 1.1.1.1 }
 # nft add element x y { 1.1.1.2 }
 # nft flush set x y
 # nft add element x y { 1.1.1.1 }
 <cmdline>:1:1-28: Error: Could not process rule: Too many open files in system

Fixes: 8411b6442e59 ("netfilter: nf_tables: support for set flushing")
Reported-by: Elise Lennion <elise.lennion@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes, rebase.

 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5bd0068320fb..1b913760f205 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3906,6 +3906,7 @@ static int nft_flush_set(const struct nft_ctx *ctx,
 		err = -ENOENT;
 		goto err1;
 	}
+	set->ndeact++;
 
 	nft_trans_elem_set(trans) = set;
 	nft_trans_elem(trans) = *elem;
-- 
2.1.4

