From: "tip-bot for Paul E. McKenney" <tipbot@zytor.com>
Subject: [tip:core/rcu] netfilter: Remove now-redundant
 smp_read_barrier_depends()
Date: Wed, 3 Jan 2018 08:05:18 -0800
Message-ID: <tip-4be2b04e43fd3d8164d7aeb1808e47fbeb0c0de0@git.kernel.org>
Reply-To: mingo@kernel.org, pablo@netfilter.org, netdev@vger.kernel.org,
          hpa@zytor.com, paulmck@linux.vnet.ibm.com,
          linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
          davem@davemloft.net, coreteam@netfilter.org, tglx@linutronix.de,
          kadlec@blackhole.kfki.hu, fw@strlen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, kadlec@blackhole.kfki.hu,
        tglx@linutronix.de, fw@strlen.de, mingo@kernel.org, hpa@zytor.com,
        netdev@vger.kernel.org, pablo@netfilter.org,
        paulmck@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Commit-ID:  4be2b04e43fd3d8164d7aeb1808e47fbeb0c0de0
Gitweb:     https://git.kernel.org/tip/4be2b04e43fd3d8164d7aeb1808e47fbeb0c0de0
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 9 Oct 2017 12:09:04 -0700
Committer:  Paul E. McKenney <paulmck@linux.vnet.ibm.com>
CommitDate: Mon, 4 Dec 2017 10:52:57 -0800

netfilter: Remove now-redundant smp_read_barrier_depends()

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
index f88221a..d242c2d 100644
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
index 4cbe5e8..46866cc 100644
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
index f06e250..ac1db84 100644
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
