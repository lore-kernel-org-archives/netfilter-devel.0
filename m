From: Xin Long <lucien.xin@gmail.com>
Subject: [PATCH net] netfilter: unlock xt_table earlier in __do_replace
Date: Fri, 16 Feb 2018 18:04:56 +0800
Message-ID: <61f106376f836829d8c283fb4c0cf11567c953bf.1518775496.git.lucien.xin@gmail.com>
Cc: davem@davemloft.net, pablo@netfilter.org, fw@strlen.de
To: network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

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
---
 net/ipv4/netfilter/arp_tables.c | 3 ++-
 net/ipv4/netfilter/ip_tables.c  | 3 ++-
 net/ipv6/netfilter/ip6_tables.c | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 4ffe302..f6c7404 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -921,6 +921,8 @@ static int __do_replace(struct net *net, const char *name,
 	    (newinfo->number <= oldinfo->initial_entries))
 		module_put(t->me);
 
+	xt_table_unlock(t);
+
 	get_old_counters(oldinfo, counters);
 
 	/* Decrease module usage counts and free resource */
@@ -935,7 +937,6 @@ static int __do_replace(struct net *net, const char *name,
 		net_warn_ratelimited("arptables: counters copy to user failed while replacing table\n");
 	}
 	vfree(counters);
-	xt_table_unlock(t);
 	return ret;
 
  put_module:
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 9a71f31..a6517c1 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1082,6 +1082,8 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 	    (newinfo->number <= oldinfo->initial_entries))
 		module_put(t->me);
 
+	xt_table_unlock(t);
+
 	get_old_counters(oldinfo, counters);
 
 	/* Decrease module usage counts and free resource */
@@ -1095,7 +1097,6 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 		net_warn_ratelimited("iptables: counters copy to user failed while replacing table\n");
 	}
 	vfree(counters);
-	xt_table_unlock(t);
 	return ret;
 
  put_module:
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index af4c917..96577c9 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1101,6 +1101,8 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 	    (newinfo->number <= oldinfo->initial_entries))
 		module_put(t->me);
 
+	xt_table_unlock(t);
+
 	get_old_counters(oldinfo, counters);
 
 	/* Decrease module usage counts and free resource */
@@ -1114,7 +1116,6 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 		net_warn_ratelimited("ip6tables: counters copy to user failed while replacing table\n");
 	}
 	vfree(counters);
-	xt_table_unlock(t);
 	return ret;
 
  put_module:
-- 
2.1.0
