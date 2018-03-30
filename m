From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 06/47] netfilter: unlock xt_table earlier in __do_replace
Date: Fri, 30 Mar 2018 13:36:48 +0200
Message-ID: <20180330113729.18335-7-pablo@netfilter.org>
References: <20180330113729.18335-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330113729.18335-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

Now it's doing cleanup_entry for oldinfo under the xt_table lock,
but it's not really necessary. After the replacement job is done
in xt_replace_table, oldinfo is not used elsewhere any more, and
it can be freed without xt_table lock safely.

The important thing is that rtnl_lock is called in some xt_target
destroy, which means rtnl_lock, a big lock is used in xt_table
lock, a smaller one. It usually could be the reason why a dead
lock may happen.

Besides, all xt_target/match checkentry is called out of xt_table
lock. It's better also to move all cleanup_entry calling out of
xt_table lock, just as do_replace_finish does for ebtables.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/arp_tables.c | 3 ++-
 net/ipv4/netfilter/ip_tables.c  | 3 ++-
 net/ipv6/netfilter/ip6_tables.c | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index c36ffce3c812..a0c7ce76879c 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -925,6 +925,8 @@ static int __do_replace(struct net *net, const char *name,
 	    (newinfo->number <= oldinfo->initial_entries))
 		module_put(t->me);
 
+	xt_table_unlock(t);
+
 	get_old_counters(oldinfo, counters);
 
 	/* Decrease module usage counts and free resource */
@@ -939,7 +941,6 @@ static int __do_replace(struct net *net, const char *name,
 		net_warn_ratelimited("arptables: counters copy to user failed while replacing table\n");
 	}
 	vfree(counters);
-	xt_table_unlock(t);
 	return ret;
 
  put_module:
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index d4f7584d2dbe..4f7153e25e0b 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1087,6 +1087,8 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 	    (newinfo->number <= oldinfo->initial_entries))
 		module_put(t->me);
 
+	xt_table_unlock(t);
+
 	get_old_counters(oldinfo, counters);
 
 	/* Decrease module usage counts and free resource */
@@ -1100,7 +1102,6 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 		net_warn_ratelimited("iptables: counters copy to user failed while replacing table\n");
 	}
 	vfree(counters);
-	xt_table_unlock(t);
 	return ret;
 
  put_module:
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 4de8ac1e5af4..6c44033decab 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1105,6 +1105,8 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 	    (newinfo->number <= oldinfo->initial_entries))
 		module_put(t->me);
 
+	xt_table_unlock(t);
+
 	get_old_counters(oldinfo, counters);
 
 	/* Decrease module usage counts and free resource */
@@ -1118,7 +1120,6 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 		net_warn_ratelimited("ip6tables: counters copy to user failed while replacing table\n");
 	}
 	vfree(counters);
-	xt_table_unlock(t);
 	return ret;
 
  put_module:
-- 
2.11.0
