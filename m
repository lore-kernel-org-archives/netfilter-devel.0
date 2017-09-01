From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: xtables: add scheduling opportunity in get_counters
Date: Fri,  1 Sep 2017 22:41:03 +0200
Message-ID: <20170901204103.16129-1-fw@strlen.de>
Cc: edumazet@google.com, Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:47754 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752419AbdIAUkr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Sep 2017 16:40:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There are reports about spurious softlockups during iptables-restore, a
backtrace i saw points at get_counters -- it uses a sequence lock and also
has unbounded restart loop.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/arp_tables.c | 1 +
 net/ipv4/netfilter/ip_tables.c  | 1 +
 net/ipv6/netfilter/ip6_tables.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 9e9d9afd18f7..14b20cf4cfd3 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -629,6 +629,7 @@ static void get_counters(const struct xt_table_info *t,
 
 			ADD_COUNTER(counters[i], bcnt, pcnt);
 			++i;
+			cond_resched();
 		}
 	}
 }
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 622ed2887cd5..92ef5a2ef0c3 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -782,6 +782,7 @@ get_counters(const struct xt_table_info *t,
 
 			ADD_COUNTER(counters[i], bcnt, pcnt);
 			++i; /* macro does multi eval of i */
+			cond_resched();
 		}
 	}
 }
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 1f90644056ac..1e9c775dc3d6 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -801,6 +801,7 @@ get_counters(const struct xt_table_info *t,
 
 			ADD_COUNTER(counters[i], bcnt, pcnt);
 			++i;
+			cond_resched();
 		}
 	}
 }
-- 
2.13.0

