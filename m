From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 03/11] netfilter: xtables: use NFPROTO_ in standard targets
Date: Fri,  8 May 2009 11:26:33 +0200
Message-ID: <1241774801-2315-4-git-send-email-jengelh@medozas.de>
References: <1241774801-2315-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53351 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbZEHJ0m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 May 2009 05:26:42 -0400
In-Reply-To: <1241774801-2315-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/ip_tables.c  |    6 +++---
 net/ipv6/netfilter/ip6_tables.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 3051dda..5abc276 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -2158,7 +2158,7 @@ static bool icmp_checkentry(const struct xt_mtchk_param *par)
 static struct xt_target ipt_standard_target __read_mostly = {
 	.name		= IPT_STANDARD_TARGET,
 	.targetsize	= sizeof(int),
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 #ifdef CONFIG_COMPAT
 	.compatsize	= sizeof(compat_int_t),
 	.compat_from_user = compat_standard_from_user,
@@ -2170,7 +2170,7 @@ static struct xt_target ipt_error_target __read_mostly = {
 	.name		= IPT_ERROR_TARGET,
 	.target		= ipt_error,
 	.targetsize	= IPT_FUNCTION_MAXNAMELEN,
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 };
 
 static struct nf_sockopt_ops ipt_sockopts = {
@@ -2196,7 +2196,7 @@ static struct xt_match icmp_matchstruct __read_mostly = {
 	.matchsize	= sizeof(struct ipt_icmp),
 	.checkentry	= icmp_checkentry,
 	.proto		= IPPROTO_ICMP,
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 };
 
 static int __net_init ip_tables_net_init(struct net *net)
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 41fbc1e..37a850e 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -2191,7 +2191,7 @@ static bool icmp6_checkentry(const struct xt_mtchk_param *par)
 static struct xt_target ip6t_standard_target __read_mostly = {
 	.name		= IP6T_STANDARD_TARGET,
 	.targetsize	= sizeof(int),
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 #ifdef CONFIG_COMPAT
 	.compatsize	= sizeof(compat_int_t),
 	.compat_from_user = compat_standard_from_user,
@@ -2203,7 +2203,7 @@ static struct xt_target ip6t_error_target __read_mostly = {
 	.name		= IP6T_ERROR_TARGET,
 	.target		= ip6t_error,
 	.targetsize	= IP6T_FUNCTION_MAXNAMELEN,
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 };
 
 static struct nf_sockopt_ops ip6t_sockopts = {
@@ -2229,7 +2229,7 @@ static struct xt_match icmp6_matchstruct __read_mostly = {
 	.matchsize	= sizeof(struct ip6t_icmp),
 	.checkentry	= icmp6_checkentry,
 	.proto		= IPPROTO_ICMPV6,
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 };
 
 static int __net_init ip6_tables_net_init(struct net *net)
-- 
1.6.2.2

