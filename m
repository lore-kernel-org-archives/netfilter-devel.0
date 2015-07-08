From: Florian Westphal <fw@strlen.de>
Subject: [PATCH RFC -next 4/4] netfilter: xtables: add upper limit on call chain depth
Date: Wed,  8 Jul 2015 23:15:39 +0200
Message-ID: <1436390139-4405-5-git-send-email-fw@strlen.de>
References: <1436390139-4405-1-git-send-email-fw@strlen.de>
Cc: eric.dumazet@gmail.com, Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37545 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758230AbbGHVIh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jul 2015 17:08:37 -0400
In-Reply-To: <1436390139-4405-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

1024 is a very aggressive limit -- it will most likely not break any
real-world ruleset, but it might break certain iptables test scripts out
there.

If we were to use this limit it becomes feasible to allocate jump stack
directly via a percpu allocation (16kbytes needed per cpu in that case).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/x_tables.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 154447e..e043d7d 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -39,6 +39,7 @@ MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("{ip,ip6,arp,eb}_tables backend module");
 
 #define SMP_ALIGN(x) (((x) + SMP_CACHE_BYTES-1) & ~(SMP_CACHE_BYTES-1))
+#define XT_MAX_STACKSIZE 1024
 
 struct compat_delta {
 	unsigned int offset; /* offset in kernel */
@@ -732,6 +733,9 @@ static int xt_jumpstack_alloc(struct xt_table_info *i)
 	unsigned int size;
 	int cpu;
 
+	if (i->stacksize > XT_MAX_STACKSIZE)
+		return -ELOOP;
+
 	size = sizeof(void **) * nr_cpu_ids;
 	if (size > PAGE_SIZE)
 		i->jumpstack = vzalloc(size);
-- 
2.1.0

