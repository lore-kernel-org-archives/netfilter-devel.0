From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2 nf] netfilter: nf_tables: bump set->ndeact on set flush
Date: Fri, 20 Jan 2017 14:22:03 +0100
Message-ID: <1484918523-9198-2-git-send-email-pablo@netfilter.org>
References: <1484918523-9198-1-git-send-email-pablo@netfilter.org>
Cc: elise.lennion@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44020 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752224AbdATNWW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Jan 2017 08:22:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A5AEE3EBA87
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jan 2017 14:22:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 96974DA2D3
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jan 2017 14:22:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7AF049D6A7
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jan 2017 14:22:07 +0100 (CET)
In-Reply-To: <1484918523-9198-1-git-send-email-pablo@netfilter.org>
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

Reported-by: Elise Lennion <elise.lennion@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
This patch depends on 1/2.

 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9bac76e48eb6..eaadc62feb3b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3901,6 +3901,7 @@ static int nft_flush_set(const struct nft_ctx *ctx,
 		err = -ENOENT;
 		goto err1;
 	}
+	set->ndeact++;
 
 	nft_trans_elem_set(trans) = set;
 	nft_trans_elem(trans) = *elem;
-- 
2.1.4

