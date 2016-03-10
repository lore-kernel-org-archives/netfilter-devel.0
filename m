From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: x_tables: check for size overflow
Date: Thu, 10 Mar 2016 01:56:23 +0100
Message-ID: <1457571383-25520-1-git-send-email-fw@strlen.de>
Cc: hawkes@google.com, Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42551 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934460AbcCJA4F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Mar 2016 19:56:05 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ben Hawkes says:
 integer overflow in xt_alloc_table_info, which on 32-bit systems can
 lead to small structure allocation and a copy_from_user based heap
 corruption.

Reported-by: Ben Hawkes <hawkes@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/x_tables.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index c8a0b7d..17a9a9f 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -659,6 +659,9 @@ struct xt_table_info *xt_alloc_table_info(unsigned int size)
 	struct xt_table_info *info = NULL;
 	size_t sz = sizeof(*info) + size;
 
+	if (sz < size || sz < sizeof(*info))
+		return NULL;
+
 	/* Pedantry: prevent them from hitting BUG() in vmalloc.c --RR */
 	if ((SMP_ALIGN(size) >> PAGE_SHIFT) + 2 > totalram_pages)
 		return NULL;
-- 
2.4.10

