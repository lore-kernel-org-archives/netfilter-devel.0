From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/07]: ip6_tables: remove broken comefrom debugging
Date: Fri, 21 Apr 2006 03:06:55 +0200 (MEST)
Message-ID: <20060421010655.8466.87312.sendpatchset@localhost.localdomain>
References: <20060421010648.8466.94593.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060421010648.8466.94593.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: ip6_tables: remove broken comefrom debugging

The introduction of x_tables broke comefrom debugging, remove it from
ip6_tables as well (ip_tables already got removed).

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1d7a13058df694ded6411b12931f3dd42f8193a4
tree c1f64b340b6adc83cec030d6a5d365521cd14003
parent 81d5f60a185910989bc5778e3ea7ee03bda7f36d
author Patrick McHardy <kaber@trash.net> Fri, 21 Apr 2006 01:25:26 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 21 Apr 2006 01:25:26 +0200

 net/ipv6/netfilter/ip6_tables.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 642b4b1..0a67303 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -288,19 +288,6 @@ ip6t_do_table(struct sk_buff **pskb,
 	table_base = (void *)private->entries[smp_processor_id()];
 	e = get_entry(table_base, private->hook_entry[hook]);
 
-#ifdef CONFIG_NETFILTER_DEBUG
-	/* Check noone else using our table */
-	if (((struct ip6t_entry *)table_base)->comefrom != 0xdead57ac
-	    && ((struct ip6t_entry *)table_base)->comefrom != 0xeeeeeeec) {
-		printk("ASSERT: CPU #%u, %s comefrom(%p) = %X\n",
-		       smp_processor_id(),
-		       table->name,
-		       &((struct ip6t_entry *)table_base)->comefrom,
-		       ((struct ip6t_entry *)table_base)->comefrom);
-	}
-	((struct ip6t_entry *)table_base)->comefrom = 0x57acc001;
-#endif
-
 	/* For return from builtin chain */
 	back = get_entry(table_base, private->underflow[hook]);
 
