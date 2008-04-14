From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 16/41]: {ip,ip6,arp}_tables: return EAGAIN for invalid SO_GET_ENTRIES size
Date: Mon, 14 Apr 2008 12:16:40 +0200 (MEST)
Message-ID: <20080414101636.32717.75482.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36278 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbYDNKQl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:16:41 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: {ip,ip6,arp}_tables: return EAGAIN for invalid SO_GET_ENTRIES size

Rule dumping is performed in two steps: first userspace gets the
ruleset size using getsockopt(SO_GET_INFO) and allocates memory,
then it calls getsockopt(SO_GET_ENTRIES) to actually dump the
ruleset. When another process changes the ruleset in between the
sizes from the first getsockopt call doesn't match anymore and
the kernel aborts. Unfortunately it returns EAGAIN, as for multiple
other possible errors, so userspace can't distinguish this case
from real errors.

Return EAGAIN so userspace can retry the operation.

Fixes (with current iptables SVN version) netfilter bugzilla #104.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6a3f3a966df2a3775605dd65fb7ac33f743996c1
tree 1329e3f6748027c7cc302ce586b5bf3e0f380c55
parent 7ced3e6faece20aca754a2497d803f4494f20dd9
author Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:47 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:47 +0200

 net/ipv4/netfilter/arp_tables.c |    4 ++--
 net/ipv4/netfilter/ip_tables.c  |    4 ++--
 net/ipv6/netfilter/ip6_tables.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index d55f3b4..03e83a6 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -937,7 +937,7 @@ static int get_entries(struct net *net, struct arpt_get_entries __user *uptr,
 		else {
 			duprintf("get_entries: I've got %u not %u!\n",
 				 private->size, get.size);
-			ret = -EINVAL;
+			ret = -EAGAIN;
 		}
 		module_put(t->me);
 		xt_table_unlock(t);
@@ -1621,7 +1621,7 @@ static int compat_get_entries(struct net *net,
 		} else if (!ret) {
 			duprintf("compat_get_entries: I've got %u not %u!\n",
 				 private->size, get.size);
-			ret = -EINVAL;
+			ret = -EAGAIN;
 		}
 		xt_compat_flush_offsets(NF_ARP);
 		module_put(t->me);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index aa124b5..4e7c719 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1180,7 +1180,7 @@ get_entries(struct net *net, struct ipt_get_entries __user *uptr, int *len)
 		else {
 			duprintf("get_entries: I've got %u not %u!\n",
 				 private->size, get.size);
-			ret = -EINVAL;
+			ret = -EAGAIN;
 		}
 		module_put(t->me);
 		xt_table_unlock(t);
@@ -1939,7 +1939,7 @@ compat_get_entries(struct net *net, struct compat_ipt_get_entries __user *uptr,
 		} else if (!ret) {
 			duprintf("compat_get_entries: I've got %u not %u!\n",
 				 private->size, get.size);
-			ret = -EINVAL;
+			ret = -EAGAIN;
 		}
 		xt_compat_flush_offsets(AF_INET);
 		module_put(t->me);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 782183f..0b4557e 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1206,7 +1206,7 @@ get_entries(struct net *net, struct ip6t_get_entries __user *uptr, int *len)
 		else {
 			duprintf("get_entries: I've got %u not %u!\n",
 				 private->size, get.size);
-			ret = -EINVAL;
+			ret = -EAGAIN;
 		}
 		module_put(t->me);
 		xt_table_unlock(t);
@@ -1966,7 +1966,7 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
 		} else if (!ret) {
 			duprintf("compat_get_entries: I've got %u not %u!\n",
 				 private->size, get.size);
-			ret = -EINVAL;
+			ret = -EAGAIN;
 		}
 		xt_compat_flush_offsets(AF_INET6);
 		module_put(t->me);
