From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 15/17] netfilter: x_tables: remove obsolete overflow check for compat case too
Date: Fri,  1 Apr 2016 14:17:35 +0200
Message-ID: <1459513057-30652-16-git-send-email-fw@strlen.de>
References: <1459513057-30652-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46486 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754553AbcDAMSK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2016 08:18:10 -0400
In-Reply-To: <1459513057-30652-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 9e67d5a739327c44885adebb4f3a538050be73e4
("[NETFILTER]: x_tables: remove obsolete overflow check") left the
compat parts alone, but we can kill it there as well.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/arp_tables.c | 2 --
 net/ipv4/netfilter/ip_tables.c  | 2 --
 net/ipv6/netfilter/ip6_tables.c | 2 --
 3 files changed, 6 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 705179b..668c5dc 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1436,8 +1436,6 @@ static int compat_do_replace(struct net *net, void __user *user,
 		return -EFAULT;
 
 	/* overflow check */
-	if (tmp.size >= INT_MAX / num_possible_cpus())
-		return -ENOMEM;
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
 	if (tmp.num_counters == 0)
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index c26ccd8..4585aa7 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1706,8 +1706,6 @@ compat_do_replace(struct net *net, void __user *user, unsigned int len)
 		return -EFAULT;
 
 	/* overflow check */
-	if (tmp.size >= INT_MAX / num_possible_cpus())
-		return -ENOMEM;
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
 	if (tmp.num_counters == 0)
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index f5a4eb2..fd06251 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1709,8 +1709,6 @@ compat_do_replace(struct net *net, void __user *user, unsigned int len)
 		return -EFAULT;
 
 	/* overflow check */
-	if (tmp.size >= INT_MAX / num_possible_cpus())
-		return -ENOMEM;
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
 	if (tmp.num_counters == 0)
-- 
2.7.3

