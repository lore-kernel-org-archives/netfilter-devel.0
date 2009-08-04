From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 046/103] netfilter: xtables: combine built-in extension structs
Date: Tue,  4 Aug 2009 09:25:30 +0200
Message-ID: <1249370787-17583-47-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56939 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574AbZHDH1X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:23 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Prepare the arrays for use with the multiregister function. The
future layer-3 xt matches can then be easily added to it without
needing more (un)register code.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/arp_tables.c |   41 +++++++++++--------------
 net/ipv4/netfilter/ip_tables.c  |   65 ++++++++++++++++++---------------------
 net/ipv6/netfilter/ip6_tables.c |   64 ++++++++++++++++++--------------------
 3 files changed, 78 insertions(+), 92 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index c5bba1f..81e5b50 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1817,22 +1817,23 @@ void arpt_unregister_table(struct xt_table *table)
 }
 
 /* The built-in targets: standard (NULL) and error. */
-static struct xt_target arpt_standard_target __read_mostly = {
-	.name		= ARPT_STANDARD_TARGET,
-	.targetsize	= sizeof(int),
-	.family		= NFPROTO_ARP,
+static struct xt_target arpt_builtin_tg[] __read_mostly = {
+	{
+		.name             = ARPT_STANDARD_TARGET,
+		.targetsize       = sizeof(int),
+		.family           = NFPROTO_ARP,
 #ifdef CONFIG_COMPAT
-	.compatsize	= sizeof(compat_int_t),
-	.compat_from_user = compat_standard_from_user,
-	.compat_to_user	= compat_standard_to_user,
+		.compatsize       = sizeof(compat_int_t),
+		.compat_from_user = compat_standard_from_user,
+		.compat_to_user   = compat_standard_to_user,
 #endif
-};
-
-static struct xt_target arpt_error_target __read_mostly = {
-	.name		= ARPT_ERROR_TARGET,
-	.target		= arpt_error,
-	.targetsize	= ARPT_FUNCTION_MAXNAMELEN,
-	.family		= NFPROTO_ARP,
+	},
+	{
+		.name             = ARPT_ERROR_TARGET,
+		.target           = arpt_error,
+		.targetsize       = ARPT_FUNCTION_MAXNAMELEN,
+		.family           = NFPROTO_ARP,
+	},
 };
 
 static struct nf_sockopt_ops arpt_sockopts = {
@@ -1876,12 +1877,9 @@ static int __init arp_tables_init(void)
 		goto err1;
 
 	/* Noone else will be downing sem now, so we won't sleep */
-	ret = xt_register_target(&arpt_standard_target);
+	ret = xt_register_targets(arpt_builtin_tg, ARRAY_SIZE(arpt_builtin_tg));
 	if (ret < 0)
 		goto err2;
-	ret = xt_register_target(&arpt_error_target);
-	if (ret < 0)
-		goto err3;
 
 	/* Register setsockopt */
 	ret = nf_register_sockopt(&arpt_sockopts);
@@ -1892,9 +1890,7 @@ static int __init arp_tables_init(void)
 	return 0;
 
 err4:
-	xt_unregister_target(&arpt_error_target);
-err3:
-	xt_unregister_target(&arpt_standard_target);
+	xt_unregister_targets(arpt_builtin_tg, ARRAY_SIZE(arpt_builtin_tg));
 err2:
 	unregister_pernet_subsys(&arp_tables_net_ops);
 err1:
@@ -1904,8 +1900,7 @@ err1:
 static void __exit arp_tables_fini(void)
 {
 	nf_unregister_sockopt(&arpt_sockopts);
-	xt_unregister_target(&arpt_error_target);
-	xt_unregister_target(&arpt_standard_target);
+	xt_unregister_targets(arpt_builtin_tg, ARRAY_SIZE(arpt_builtin_tg));
 	unregister_pernet_subsys(&arp_tables_net_ops);
 }
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 8bc1b65..7192e89 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -2158,23 +2158,23 @@ static bool icmp_checkentry(const struct xt_mtchk_param *par)
 	return !(icmpinfo->invflags & ~IPT_ICMP_INV);
 }
 
-/* The built-in targets: standard (NULL) and error. */
-static struct xt_target ipt_standard_target __read_mostly = {
-	.name		= IPT_STANDARD_TARGET,
-	.targetsize	= sizeof(int),
-	.family		= NFPROTO_IPV4,
+static struct xt_target ipt_builtin_tg[] __read_mostly = {
+	{
+		.name             = IPT_STANDARD_TARGET,
+		.targetsize       = sizeof(int),
+		.family           = NFPROTO_IPV4,
 #ifdef CONFIG_COMPAT
-	.compatsize	= sizeof(compat_int_t),
-	.compat_from_user = compat_standard_from_user,
-	.compat_to_user	= compat_standard_to_user,
+		.compatsize       = sizeof(compat_int_t),
+		.compat_from_user = compat_standard_from_user,
+		.compat_to_user   = compat_standard_to_user,
 #endif
-};
-
-static struct xt_target ipt_error_target __read_mostly = {
-	.name		= IPT_ERROR_TARGET,
-	.target		= ipt_error,
-	.targetsize	= IPT_FUNCTION_MAXNAMELEN,
-	.family		= NFPROTO_IPV4,
+	},
+	{
+		.name             = IPT_ERROR_TARGET,
+		.target           = ipt_error,
+		.targetsize       = IPT_FUNCTION_MAXNAMELEN,
+		.family           = NFPROTO_IPV4,
+	},
 };
 
 static struct nf_sockopt_ops ipt_sockopts = {
@@ -2194,13 +2194,15 @@ static struct nf_sockopt_ops ipt_sockopts = {
 	.owner		= THIS_MODULE,
 };
 
-static struct xt_match icmp_matchstruct __read_mostly = {
-	.name		= "icmp",
-	.match		= icmp_match,
-	.matchsize	= sizeof(struct ipt_icmp),
-	.checkentry	= icmp_checkentry,
-	.proto		= IPPROTO_ICMP,
-	.family		= NFPROTO_IPV4,
+static struct xt_match ipt_builtin_mt[] __read_mostly = {
+	{
+		.name       = "icmp",
+		.match      = icmp_match,
+		.matchsize  = sizeof(struct ipt_icmp),
+		.checkentry = icmp_checkentry,
+		.proto      = IPPROTO_ICMP,
+		.family     = NFPROTO_IPV4,
+	},
 };
 
 static int __net_init ip_tables_net_init(struct net *net)
@@ -2227,13 +2229,10 @@ static int __init ip_tables_init(void)
 		goto err1;
 
 	/* Noone else will be downing sem now, so we won't sleep */
-	ret = xt_register_target(&ipt_standard_target);
+	ret = xt_register_targets(ipt_builtin_tg, ARRAY_SIZE(ipt_builtin_tg));
 	if (ret < 0)
 		goto err2;
-	ret = xt_register_target(&ipt_error_target);
-	if (ret < 0)
-		goto err3;
-	ret = xt_register_match(&icmp_matchstruct);
+	ret = xt_register_matches(ipt_builtin_mt, ARRAY_SIZE(ipt_builtin_mt));
 	if (ret < 0)
 		goto err4;
 
@@ -2246,11 +2245,9 @@ static int __init ip_tables_init(void)
 	return 0;
 
 err5:
-	xt_unregister_match(&icmp_matchstruct);
+	xt_unregister_matches(ipt_builtin_mt, ARRAY_SIZE(ipt_builtin_mt));
 err4:
-	xt_unregister_target(&ipt_error_target);
-err3:
-	xt_unregister_target(&ipt_standard_target);
+	xt_unregister_targets(ipt_builtin_tg, ARRAY_SIZE(ipt_builtin_tg));
 err2:
 	unregister_pernet_subsys(&ip_tables_net_ops);
 err1:
@@ -2261,10 +2258,8 @@ static void __exit ip_tables_fini(void)
 {
 	nf_unregister_sockopt(&ipt_sockopts);
 
-	xt_unregister_match(&icmp_matchstruct);
-	xt_unregister_target(&ipt_error_target);
-	xt_unregister_target(&ipt_standard_target);
-
+	xt_unregister_matches(ipt_builtin_mt, ARRAY_SIZE(ipt_builtin_mt));
+	xt_unregister_targets(ipt_builtin_tg, ARRAY_SIZE(ipt_builtin_tg));
 	unregister_pernet_subsys(&ip_tables_net_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 1b9ba79..a34819b 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -2174,22 +2174,23 @@ static bool icmp6_checkentry(const struct xt_mtchk_param *par)
 }
 
 /* The built-in targets: standard (NULL) and error. */
-static struct xt_target ip6t_standard_target __read_mostly = {
-	.name		= IP6T_STANDARD_TARGET,
-	.targetsize	= sizeof(int),
-	.family		= NFPROTO_IPV6,
+static struct xt_target ip6t_builtin_tg[] __read_mostly = {
+	{
+		.name             = IP6T_STANDARD_TARGET,
+		.targetsize       = sizeof(int),
+		.family           = NFPROTO_IPV6,
 #ifdef CONFIG_COMPAT
-	.compatsize	= sizeof(compat_int_t),
-	.compat_from_user = compat_standard_from_user,
-	.compat_to_user	= compat_standard_to_user,
+		.compatsize       = sizeof(compat_int_t),
+		.compat_from_user = compat_standard_from_user,
+		.compat_to_user   = compat_standard_to_user,
 #endif
-};
-
-static struct xt_target ip6t_error_target __read_mostly = {
-	.name		= IP6T_ERROR_TARGET,
-	.target		= ip6t_error,
-	.targetsize	= IP6T_FUNCTION_MAXNAMELEN,
-	.family		= NFPROTO_IPV6,
+	},
+	{
+		.name             = IP6T_ERROR_TARGET,
+		.target           = ip6t_error,
+		.targetsize       = IP6T_FUNCTION_MAXNAMELEN,
+		.family           = NFPROTO_IPV6,
+	},
 };
 
 static struct nf_sockopt_ops ip6t_sockopts = {
@@ -2209,13 +2210,15 @@ static struct nf_sockopt_ops ip6t_sockopts = {
 	.owner		= THIS_MODULE,
 };
 
-static struct xt_match icmp6_matchstruct __read_mostly = {
-	.name		= "icmp6",
-	.match		= icmp6_match,
-	.matchsize	= sizeof(struct ip6t_icmp),
-	.checkentry	= icmp6_checkentry,
-	.proto		= IPPROTO_ICMPV6,
-	.family		= NFPROTO_IPV6,
+static struct xt_match ip6t_builtin_mt[] __read_mostly = {
+	{
+		.name       = "icmp6",
+		.match      = icmp6_match,
+		.matchsize  = sizeof(struct ip6t_icmp),
+		.checkentry = icmp6_checkentry,
+		.proto      = IPPROTO_ICMPV6,
+		.family     = NFPROTO_IPV6,
+	},
 };
 
 static int __net_init ip6_tables_net_init(struct net *net)
@@ -2242,13 +2245,10 @@ static int __init ip6_tables_init(void)
 		goto err1;
 
 	/* Noone else will be downing sem now, so we won't sleep */
-	ret = xt_register_target(&ip6t_standard_target);
+	ret = xt_register_targets(ip6t_builtin_tg, ARRAY_SIZE(ip6t_builtin_tg));
 	if (ret < 0)
 		goto err2;
-	ret = xt_register_target(&ip6t_error_target);
-	if (ret < 0)
-		goto err3;
-	ret = xt_register_match(&icmp6_matchstruct);
+	ret = xt_register_matches(ip6t_builtin_mt, ARRAY_SIZE(ip6t_builtin_mt));
 	if (ret < 0)
 		goto err4;
 
@@ -2261,11 +2261,9 @@ static int __init ip6_tables_init(void)
 	return 0;
 
 err5:
-	xt_unregister_match(&icmp6_matchstruct);
+	xt_unregister_matches(ip6t_builtin_mt, ARRAY_SIZE(ip6t_builtin_mt));
 err4:
-	xt_unregister_target(&ip6t_error_target);
-err3:
-	xt_unregister_target(&ip6t_standard_target);
+	xt_unregister_targets(ip6t_builtin_tg, ARRAY_SIZE(ip6t_builtin_tg));
 err2:
 	unregister_pernet_subsys(&ip6_tables_net_ops);
 err1:
@@ -2276,10 +2274,8 @@ static void __exit ip6_tables_fini(void)
 {
 	nf_unregister_sockopt(&ip6t_sockopts);
 
-	xt_unregister_match(&icmp6_matchstruct);
-	xt_unregister_target(&ip6t_error_target);
-	xt_unregister_target(&ip6t_standard_target);
-
+	xt_unregister_matches(ip6t_builtin_mt, ARRAY_SIZE(ip6t_builtin_mt));
+	xt_unregister_targets(ip6t_builtin_tg, ARRAY_SIZE(ip6t_builtin_tg));
 	unregister_pernet_subsys(&ip6_tables_net_ops);
 }
 
-- 
1.6.3.3

