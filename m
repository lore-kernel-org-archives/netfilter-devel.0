From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/08]: Lower *tables printk severity
Date: Sat, 14 Jul 2007 17:12:40 +0200 (MEST)
Message-ID: <20070714151156.9829.4970.sendpatchset@localhost.localdomain>
References: <20070714151150.9829.47674.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070714151150.9829.47674.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Lower *tables printk severity

Lower ip6tables, arptables and ebtables printk severity similar to
Dan Aloni's patch for iptables.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f1cdf0338ecef77b6c1999ae177b4fd21134e625
tree e4ae3f9367502508a48d852fe5492da39ed8cc85
parent 28b86df4d02014ae5ce0be0e82c074f15ea0dabf
author Patrick McHardy <kaber@trash.net> Sat, 14 Jul 2007 17:02:23 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 14 Jul 2007 17:02:23 +0200

 net/bridge/netfilter/ebtables.c |    4 ++--
 net/ipv4/netfilter/arp_tables.c |    2 +-
 net/ipv6/netfilter/ip6_tables.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index ac9984f..4169a2a 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1525,14 +1525,14 @@ static int __init ebtables_init(void)
 	if ((ret = nf_register_sockopt(&ebt_sockopts)) < 0)
 		return ret;
 
-	printk(KERN_NOTICE "Ebtables v2.0 registered\n");
+	printk(KERN_INFO "Ebtables v2.0 registered\n");
 	return 0;
 }
 
 static void __exit ebtables_fini(void)
 {
 	nf_unregister_sockopt(&ebt_sockopts);
-	printk(KERN_NOTICE "Ebtables v2.0 unregistered\n");
+	printk(KERN_INFO "Ebtables v2.0 unregistered\n");
 }
 
 EXPORT_SYMBOL(ebt_register_table);
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index e981232..d1149ab 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1184,7 +1184,7 @@ static int __init arp_tables_init(void)
 	if (ret < 0)
 		goto err4;
 
-	printk("arp_tables: (C) 2002 David S. Miller\n");
+	printk(KERN_INFO "arp_tables: (C) 2002 David S. Miller\n");
 	return 0;
 
 err4:
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 254c769..aeda617 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1497,7 +1497,7 @@ static int __init ip6_tables_init(void)
 	if (ret < 0)
 		goto err5;
 
-	printk("ip6_tables: (C) 2000-2006 Netfilter Core Team\n");
+	printk(KERN_INFO "ip6_tables: (C) 2000-2006 Netfilter Core Team\n");
 	return 0;
 
 err5:
