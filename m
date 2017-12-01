From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 14/21] netfilter: Remove now-redundant smp_read_barrier_depends()
Date: Fri,  1 Dec 2017 11:51:09 -0800
Message-ID: <1512157876-24665-14-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20171201195053.GA23494@linux.vnet.ibm.com>
Cc: mingo@kernel.org, jiangshanlai@gmail.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        fweisbec@gmail.com, oleg@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>
To: linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41068 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752232AbdLATv2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Dec 2017 14:51:28 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vB1JoYhk113955
        for <netfilter-devel@vger.kernel.org>; Fri, 1 Dec 2017 14:51:28 -0500
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ekd5e96s8-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Dec 2017 14:51:27 -0500
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netfilter-devel@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Fri, 1 Dec 2017 14:51:25 -0500
In-Reply-To: <20171201195053.GA23494@linux.vnet.ibm.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

READ_ONCE() now implies smp_read_barrier_depends(), which means that
the instances in arpt_do_table(), ipt_do_table(), and ip6t_do_table()
are now redundant.  This commit removes them and adjusts the comments.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Florian Westphal <fw@strlen.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <netfilter-devel@vger.kernel.org>
Cc: <coreteam@netfilter.org>
Cc: <netdev@vger.kernel.org>
---
 net/ipv4/netfilter/arp_tables.c | 7 +------
 net/ipv4/netfilter/ip_tables.c  | 7 +------
 net/ipv6/netfilter/ip6_tables.c | 7 +------
 3 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index f88221aebc9d..d242c2d29161 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -202,13 +202,8 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 
 	local_bh_disable();
 	addend = xt_write_recseq_begin();
-	private = table->private;
+	private = READ_ONCE(table->private); /* Address dependency. */
 	cpu     = smp_processor_id();
-	/*
-	 * Ensure we load private-> members after we've fetched the base
-	 * pointer.
-	 */
-	smp_read_barrier_depends();
 	table_base = private->entries;
 	jumpstack  = (struct arpt_entry **)private->jumpstack[cpu];
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 4cbe5e80f3bf..46866cc24a84 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -260,13 +260,8 @@ ipt_do_table(struct sk_buff *skb,
 	WARN_ON(!(table->valid_hooks & (1 << hook)));
 	local_bh_disable();
 	addend = xt_write_recseq_begin();
-	private = table->private;
+	private = READ_ONCE(table->private); /* Address dependency. */
 	cpu        = smp_processor_id();
-	/*
-	 * Ensure we load private-> members after we've fetched the base
-	 * pointer.
-	 */
-	smp_read_barrier_depends();
 	table_base = private->entries;
 	jumpstack  = (struct ipt_entry **)private->jumpstack[cpu];
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index f06e25065a34..ac1db84722a7 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -282,12 +282,7 @@ ip6t_do_table(struct sk_buff *skb,
 
 	local_bh_disable();
 	addend = xt_write_recseq_begin();
-	private = table->private;
-	/*
-	 * Ensure we load private-> members after we've fetched the base
-	 * pointer.
-	 */
-	smp_read_barrier_depends();
+	private = READ_ONCE(table->private); /* Address dependency. */
 	cpu        = smp_processor_id();
 	table_base = private->entries;
 	jumpstack  = (struct ip6t_entry **)private->jumpstack[cpu];
-- 
2.5.2

