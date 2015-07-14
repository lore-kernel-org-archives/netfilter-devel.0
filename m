From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next v2 6/6] netfilter: xtables: add upper limit on call chain depth
Date: Tue, 14 Jul 2015 17:51:11 +0200
Message-ID: <1436889071-3637-7-git-send-email-fw@strlen.de>
References: <1436889071-3637-1-git-send-email-fw@strlen.de>
Cc: eric.dumazet@gmail.com, Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49925 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752744AbbGNPvV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jul 2015 11:51:21 -0400
In-Reply-To: <1436889071-3637-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

1024 is a very aggressive limit -- it will most likely not break any
real-world ruleset, but it might break certain iptables test scripts out
there.

If we were to use this limit it becomes feasible to allocate jump stack
directly via a percpu allocation (16kbytes needed per cpu in that case).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 no changes since v1.

 net/netfilter/x_tables.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 9b42b5e..2be4f8e 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -39,6 +39,7 @@ MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("{ip,ip6,arp,eb}_tables backend module");
 
 #define SMP_ALIGN(x) (((x) + SMP_CACHE_BYTES-1) & ~(SMP_CACHE_BYTES-1))
+#define XT_MAX_STACKSIZE 1024
 
 struct compat_delta {
 	unsigned int offset; /* offset in kernel */
@@ -735,6 +736,9 @@ static int xt_jumpstack_alloc(struct xt_table_info *i)
 	unsigned int size;
 	int cpu;
 
+	if (i->stacksize > XT_MAX_STACKSIZE)
+		return -ELOOP;
+
 	size = sizeof(void **) * nr_cpu_ids;
 	if (size > PAGE_SIZE)
 		i->jumpstack = vzalloc(size);
-- 
2.0.5

