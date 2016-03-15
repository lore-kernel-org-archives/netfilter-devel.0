From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/18] netfilter: x_tables: check for size overflow
Date: Tue, 15 Mar 2016 02:27:53 +0100
Message-ID: <1458005282-24665-10-git-send-email-pablo@netfilter.org>
References: <1458005282-24665-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33240 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933346AbcCOB2c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Mar 2016 21:28:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2207A114F5B
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 02:28:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1458ADA385
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 02:28:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A704FDA384
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 02:28:26 +0100 (CET)
In-Reply-To: <1458005282-24665-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

Ben Hawkes says:
 integer overflow in xt_alloc_table_info, which on 32-bit systems can
 lead to small structure allocation and a copy_from_user based heap
 corruption.

Reported-by: Ben Hawkes <hawkes@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/x_tables.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index d0cd2b9..582c9cf 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -659,6 +659,9 @@ struct xt_table_info *xt_alloc_table_info(unsigned int size)
 	struct xt_table_info *info = NULL;
 	size_t sz = sizeof(*info) + size;
 
+	if (sz < sizeof(*info))
+		return NULL;
+
 	/* Pedantry: prevent them from hitting BUG() in vmalloc.c --RR */
 	if ((SMP_ALIGN(size) >> PAGE_SHIFT) + 2 > totalram_pages)
 		return NULL;
-- 
2.1.4

