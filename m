From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 014/103] netfilter: xtables: remove unneeded gotos in table error paths
Date: Tue,  4 Aug 2009 09:24:58 +0200
Message-ID: <1249370787-17583-15-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50621 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542AbZHDH0s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:26:48 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/arptable_filter.c   |    6 +-----
 net/ipv4/netfilter/iptable_filter.c    |    6 +-----
 net/ipv4/netfilter/iptable_mangle.c    |    6 +-----
 net/ipv4/netfilter/iptable_raw.c       |    6 +-----
 net/ipv4/netfilter/iptable_security.c  |    6 +-----
 net/ipv6/netfilter/ip6table_filter.c   |    6 +-----
 net/ipv6/netfilter/ip6table_mangle.c   |    6 +-----
 net/ipv6/netfilter/ip6table_raw.c      |    6 +-----
 net/ipv6/netfilter/ip6table_security.c |    6 +-----
 9 files changed, 9 insertions(+), 45 deletions(-)

diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 6ecfdae..87ecd3e 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -127,11 +127,7 @@ static int __init arptable_filter_init(void)
 
 	ret = nf_register_hooks(arpt_ops, ARRAY_SIZE(arpt_ops));
 	if (ret < 0)
-		goto cleanup_table;
-	return ret;
-
-cleanup_table:
-	unregister_pernet_subsys(&arptable_filter_net_ops);
+		unregister_pernet_subsys(&arptable_filter_net_ops);
 	return ret;
 }
 
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 97dbd94..24d39cb 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -165,13 +165,9 @@ static int __init iptable_filter_init(void)
 	/* Register hooks */
 	ret = nf_register_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
 	if (ret < 0)
-		goto cleanup_table;
+		unregister_pernet_subsys(&iptable_filter_net_ops);
 
 	return ret;
-
- cleanup_table:
-	unregister_pernet_subsys(&iptable_filter_net_ops);
-	return ret;
 }
 
 static void __exit iptable_filter_fini(void)
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 28647f1..107baf8 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -227,13 +227,9 @@ static int __init iptable_mangle_init(void)
 	/* Register hooks */
 	ret = nf_register_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
 	if (ret < 0)
-		goto cleanup_table;
+		unregister_pernet_subsys(&iptable_mangle_net_ops);
 
 	return ret;
-
- cleanup_table:
-	unregister_pernet_subsys(&iptable_mangle_net_ops);
-	return ret;
 }
 
 static void __exit iptable_mangle_fini(void)
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 494784c..8864a82 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -119,13 +119,9 @@ static int __init iptable_raw_init(void)
 	/* Register hooks */
 	ret = nf_register_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
 	if (ret < 0)
-		goto cleanup_table;
+		unregister_pernet_subsys(&iptable_raw_net_ops);
 
 	return ret;
-
- cleanup_table:
-	unregister_pernet_subsys(&iptable_raw_net_ops);
-	return ret;
 }
 
 static void __exit iptable_raw_fini(void)
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index 8804e1a..cab3eaa 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -156,13 +156,9 @@ static int __init iptable_security_init(void)
 
 	ret = nf_register_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
 	if (ret < 0)
-		goto cleanup_table;
+		unregister_pernet_subsys(&iptable_security_net_ops);
 
 	return ret;
-
-cleanup_table:
-	unregister_pernet_subsys(&iptable_security_net_ops);
-	return ret;
 }
 
 static void __exit iptable_security_fini(void)
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 0a3ae48..5a81188 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -158,13 +158,9 @@ static int __init ip6table_filter_init(void)
 	/* Register hooks */
 	ret = nf_register_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
 	if (ret < 0)
-		goto cleanup_table;
+		unregister_pernet_subsys(&ip6table_filter_net_ops);
 
 	return ret;
-
- cleanup_table:
-	unregister_pernet_subsys(&ip6table_filter_net_ops);
-	return ret;
 }
 
 static void __exit ip6table_filter_fini(void)
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 0f49e00..db44cef 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -201,13 +201,9 @@ static int __init ip6table_mangle_init(void)
 	/* Register hooks */
 	ret = nf_register_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
 	if (ret < 0)
-		goto cleanup_table;
+		unregister_pernet_subsys(&ip6table_mangle_net_ops);
 
 	return ret;
-
- cleanup_table:
-	unregister_pernet_subsys(&ip6table_mangle_net_ops);
-	return ret;
 }
 
 static void __exit ip6table_mangle_fini(void)
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 679865e..30e4ca5 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -113,13 +113,9 @@ static int __init ip6table_raw_init(void)
 	/* Register hooks */
 	ret = nf_register_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
 	if (ret < 0)
-		goto cleanup_table;
+		unregister_pernet_subsys(&ip6table_raw_net_ops);
 
 	return ret;
-
- cleanup_table:
-	unregister_pernet_subsys(&ip6table_raw_net_ops);
-	return ret;
 }
 
 static void __exit ip6table_raw_fini(void)
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index 822afab..5044521 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -152,13 +152,9 @@ static int __init ip6table_security_init(void)
 
 	ret = nf_register_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
 	if (ret < 0)
-		goto cleanup_table;
+		unregister_pernet_subsys(&ip6table_security_net_ops);
 
 	return ret;
-
-cleanup_table:
-	unregister_pernet_subsys(&ip6table_security_net_ops);
-	return ret;
 }
 
 static void __exit ip6table_security_fini(void)
-- 
1.6.3.3

