From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 01/11] netfilter: xtables: use NFPROTO_ for xt_proto_init callsites
Date: Fri,  8 May 2009 11:26:31 +0200
Message-ID: <1241774801-2315-2-git-send-email-jengelh@medozas.de>
References: <1241774801-2315-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53345 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbZEHJ0m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 May 2009 05:26:42 -0400
In-Reply-To: <1241774801-2315-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/ip_tables.c  |    4 ++--
 net/ipv6/netfilter/ip6_tables.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 2ec8d72..3051dda 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -2201,12 +2201,12 @@ static struct xt_match icmp_matchstruct __read_mostly = {
 
 static int __net_init ip_tables_net_init(struct net *net)
 {
-	return xt_proto_init(net, AF_INET);
+	return xt_proto_init(net, NFPROTO_IPV4);
 }
 
 static void __net_exit ip_tables_net_exit(struct net *net)
 {
-	xt_proto_fini(net, AF_INET);
+	xt_proto_fini(net, NFPROTO_IPV4);
 }
 
 static struct pernet_operations ip_tables_net_ops = {
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 219e165..41fbc1e 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -2234,12 +2234,12 @@ static struct xt_match icmp6_matchstruct __read_mostly = {
 
 static int __net_init ip6_tables_net_init(struct net *net)
 {
-	return xt_proto_init(net, AF_INET6);
+	return xt_proto_init(net, NFPROTO_IPV6);
 }
 
 static void __net_exit ip6_tables_net_exit(struct net *net)
 {
-	xt_proto_fini(net, AF_INET6);
+	xt_proto_fini(net, NFPROTO_IPV6);
 }
 
 static struct pernet_operations ip6_tables_net_ops = {
-- 
1.6.2.2

