From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/49]: x_tables: remove obsolete overflow check
Date: Tue,  4 Dec 2007 13:02:02 +0100 (MET)
Message-ID: <20071204120202.2442.26846.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62112 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbXLDMCD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:03 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: x_tables: remove obsolete overflow check

We're not multiplying the size with the number of CPUs anymore, so the
check is obsolete.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f4026219449cce39bca209261cfff7ff9a8febfd
tree 2abbde948409f8975e610a52c727ff337742abab
parent e648b28460f8bcbdb6293ce66b99735efa31a1ee
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:46:57 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:46:57 +0100

 net/ipv4/netfilter/arp_tables.c |    2 --
 net/ipv4/netfilter/ip_tables.c  |    2 --
 net/ipv6/netfilter/ip6_tables.c |    2 --
 3 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index a21722d..d5cae7e 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -811,8 +811,6 @@ static int do_replace(void __user *user, unsigned int len)
 		return -ENOPROTOOPT;
 
 	/* overflow check */
-	if (tmp.size >= INT_MAX / num_possible_cpus())
-		return -ENOMEM;
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 4200fde..0f2614e 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1323,8 +1323,6 @@ do_replace(void __user *user, unsigned int len)
 		return -ENOPROTOOPT;
 
 	/* overflow check */
-	if (tmp.size >= INT_MAX / num_possible_cpus())
-		return -ENOMEM;
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index e60c1b4..d3e884a 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1042,8 +1042,6 @@ do_replace(void __user *user, unsigned int len)
 		return -EFAULT;
 
 	/* overflow check */
-	if (tmp.size >= INT_MAX / num_possible_cpus())
-		return -ENOMEM;
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
 
