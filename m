From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/1] netfilter: fix CONFIG_COMPAT support
Date: Sat,  7 Aug 2010 09:50:56 +0200
Message-ID: <1281167456-1163-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46942 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752094Ab0HGHxq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Aug 2010 03:53:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit f3c5c1bfd430858d3a05436f82c51e53104feb6b
(netfilter: xtables: make ip_tables reentrant) forgot to
also compute the jumpstack size in the compat handlers.

Result is that "iptables -I INPUT -j userchain" turns into -j DROP.

Reported by Sebastian Roesner on #netfilter, closes
http://bugzilla.netfilter.org/show_bug.cgi?id=669.

Note: arptables change is compile-tested only.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/arp_tables.c |    3 +++
 net/ipv4/netfilter/ip_tables.c  |    3 +++
 net/ipv6/netfilter/ip6_tables.c |    3 +++
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 6bccba3..4829766 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1418,6 +1418,9 @@ static int translate_compat_table(const char *name,
 		if (ret != 0)
 			break;
 		++i;
+		if (strcmp(arpt_get_target(iter1)->u.user.name,
+		    XT_ERROR_TARGET) == 0)
+			++newinfo->stacksize;
 	}
 	if (ret) {
 		/*
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index c439721..3d3b695 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1749,6 +1749,9 @@ translate_compat_table(struct net *net,
 		if (ret != 0)
 			break;
 		++i;
+		if (strcmp(ipt_get_target(iter1)->u.user.name,
+		    XT_ERROR_TARGET) == 0)
+			++newinfo->stacksize;
 	}
 	if (ret) {
 		/*
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 5359ef4..bad3c7f 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1764,6 +1764,9 @@ translate_compat_table(struct net *net,
 		if (ret != 0)
 			break;
 		++i;
+		if (strcmp(ip6t_get_target(iter1)->u.user.name,
+		    XT_ERROR_TARGET) == 0)
+			++newinfo->stacksize;
 	}
 	if (ret) {
 		/*
-- 
1.7.1

