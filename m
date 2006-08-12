From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/02]: {arp, ip,
	ip6}_tables: proper error recovery in initialization path
Date: Sat, 12 Aug 2006 02:25:36 +0200 (MEST)
Message-ID: <20060812002536.30253.19487.sendpatchset@localhost.localdomain>
References: <20060812002535.30253.73682.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060812002535.30253.73682.sendpatchset@localhost.localdomain>
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

[NETFILTER]: {arp,ip,ip6}_tables: proper error recovery in init path

Neither of {arp,ip,ip6}_tables cleans up behind itself when something goes
wrong during initialization.

Noticed by Rennie deGraaf <degraaf@cpsc.ucalgary.ca>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 85b125c30937bf0ef9fad5f4c3b4eab4588d4580
tree fc1796384ca7e973256f16095339c86b2a808c02
parent afe7e5033e79c86de718cb7fce5961a50b1352d3
author Patrick McHardy <kaber@trash.net> Fri, 11 Aug 2006 18:10:00 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 11 Aug 2006 18:10:00 +0200

 net/ipv4/netfilter/arp_tables.c |   27 ++++++++++++++++++++-------
 net/ipv4/netfilter/ip_tables.c  |   33 +++++++++++++++++++++++++--------
 net/ipv6/netfilter/ip6_tables.c |   34 +++++++++++++++++++++++++---------
 3 files changed, 70 insertions(+), 24 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 80c73ca..df4854c 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1170,21 +1170,34 @@ static int __init arp_tables_init(void)
 {
 	int ret;
 
-	xt_proto_init(NF_ARP);
+	ret = xt_proto_init(NF_ARP);
+	if (ret < 0)
+		goto err1;
 
 	/* Noone else will be downing sem now, so we won't sleep */
-	xt_register_target(&arpt_standard_target);
-	xt_register_target(&arpt_error_target);
+	ret = xt_register_target(&arpt_standard_target);
+	if (ret < 0)
+		goto err2;
+	ret = xt_register_target(&arpt_error_target);
+	if (ret < 0)
+		goto err3;
 
 	/* Register setsockopt */
 	ret = nf_register_sockopt(&arpt_sockopts);
-	if (ret < 0) {
-		duprintf("Unable to register sockopts.\n");
-		return ret;
-	}
+	if (ret < 0)
+		goto err4;
 
 	printk("arp_tables: (C) 2002 David S. Miller\n");
 	return 0;
+
+err4:
+	xt_unregister_target(&arpt_error_target);
+err3:
+	xt_unregister_target(&arpt_standard_target);
+err2:
+	xt_proto_fini(NF_ARP);
+err1:
+	return ret;
 }
 
 static void __exit arp_tables_fini(void)
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index fc5bdd5..f316ff5 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -2239,22 +2239,39 @@ static int __init ip_tables_init(void)
 {
 	int ret;
 
-	xt_proto_init(AF_INET);
+	ret = xt_proto_init(AF_INET);
+	if (ret < 0)
+		goto err1;
 
 	/* Noone else will be downing sem now, so we won't sleep */
-	xt_register_target(&ipt_standard_target);
-	xt_register_target(&ipt_error_target);
-	xt_register_match(&icmp_matchstruct);
+	ret = xt_register_target(&ipt_standard_target);
+	if (ret < 0)
+		goto err2;
+	ret = xt_register_target(&ipt_error_target);
+	if (ret < 0)
+		goto err3;
+	ret = xt_register_match(&icmp_matchstruct);
+	if (ret < 0)
+		goto err4;
 
 	/* Register setsockopt */
 	ret = nf_register_sockopt(&ipt_sockopts);
-	if (ret < 0) {
-		duprintf("Unable to register sockopts.\n");
-		return ret;
-	}
+	if (ret < 0)
+		goto err5;
 
 	printk("ip_tables: (C) 2000-2006 Netfilter Core Team\n");
 	return 0;
+
+err5:
+	xt_unregister_match(&icmp_matchstruct);
+err4:
+	xt_unregister_target(&ipt_error_target);
+err3:
+	xt_unregister_target(&ipt_standard_target);
+err2:
+	xt_proto_fini(AF_INET);
+err1:
+	return ret;
 }
 
 static void __exit ip_tables_fini(void)
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index f26898b..c9d6b23 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1398,23 +1398,39 @@ static int __init ip6_tables_init(void)
 {
 	int ret;
 
-	xt_proto_init(AF_INET6);
+	ret = xt_proto_init(AF_INET6);
+	if (ret < 0)
+		goto err1;
 
 	/* Noone else will be downing sem now, so we won't sleep */
-	xt_register_target(&ip6t_standard_target);
-	xt_register_target(&ip6t_error_target);
-	xt_register_match(&icmp6_matchstruct);
+	ret = xt_register_target(&ip6t_standard_target);
+	if (ret < 0)
+		goto err2;
+	ret = xt_register_target(&ip6t_error_target);
+	if (ret < 0)
+		goto err3;
+	ret = xt_register_match(&icmp6_matchstruct);
+	if (ret < 0)
+		goto err4;
 
 	/* Register setsockopt */
 	ret = nf_register_sockopt(&ip6t_sockopts);
-	if (ret < 0) {
-		duprintf("Unable to register sockopts.\n");
-		xt_proto_fini(AF_INET6);
-		return ret;
-	}
+	if (ret < 0)
+		goto err5;
 
 	printk("ip6_tables: (C) 2000-2006 Netfilter Core Team\n");
 	return 0;
+
+err5:
+	xt_unregister_match(&icmp6_matchstruct);
+err4:
+	xt_unregister_target(&ip6t_error_target);
+err3:
+	xt_unregister_target(&ip6t_standard_target);
+err2:
+	xt_proto_fini(AF_INET6);
+err1:
+	return ret;
 }
 
 static void __exit ip6_tables_fini(void)
