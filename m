From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 15/23] netfilter: x_tables: remove obsolete overflow check for compat case too
Date: Fri, 22 Apr 2016 15:39:46 +0200
Message-ID: <1461332394-3994-16-git-send-email-pablo@netfilter.org>
References: <1461332394-3994-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1461332394-3994-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 9e67d5a739327c44885adebb4f3a538050be73e4
("[NETFILTER]: x_tables: remove obsolete overflow check") left the
compat parts alone, but we can kill it there as well.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.1.4
