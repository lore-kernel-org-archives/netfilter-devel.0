From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.18 17/59] netfilter: ipset: Fix calling ip_set() macro at dumping
Date: Wed, 14 Nov 2018 17:22:49 -0500
Message-ID: <20181114222335.99339-17-sashal@kernel.org>
References: <20181114222335.99339-1-sashal@kernel.org>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181114222335.99339-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

[ Upstream commit 8a02bdd50b2ecb6d62121d2958d3ea186cc88ce7 ]

The ip_set() macro is called when either ip_set_ref_lock held only
or no lock/nfnl mutex is held at dumping. Take this into account
properly. Also, use Pablo's suggestion to use rcu_dereference_raw(),
the ref_netlink protects the set.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_core.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 68db946df151..1577f2f76060 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -55,11 +55,15 @@ MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
 MODULE_DESCRIPTION("core IP set support");
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_IPSET);
 
-/* When the nfnl mutex is held: */
+/* When the nfnl mutex or ip_set_ref_lock is held: */
 #define ip_set_dereference(p)		\
-	rcu_dereference_protected(p, lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET))
+	rcu_dereference_protected(p,	\
+		lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET) || \
+		lockdep_is_held(&ip_set_ref_lock))
 #define ip_set(inst, id)		\
 	ip_set_dereference((inst)->ip_set_list)[id]
+#define ip_set_ref_netlink(inst,id)	\
+	rcu_dereference_raw((inst)->ip_set_list)[id]
 
 /* The set types are implemented in modules and registered set types
  * can be found in ip_set_type_list. Adding/deleting types is
@@ -1251,7 +1255,7 @@ ip_set_dump_done(struct netlink_callback *cb)
 		struct ip_set_net *inst =
 			(struct ip_set_net *)cb->args[IPSET_CB_NET];
 		ip_set_id_t index = (ip_set_id_t)cb->args[IPSET_CB_INDEX];
-		struct ip_set *set = ip_set(inst, index);
+		struct ip_set *set = ip_set_ref_netlink(inst, index);
 
 		if (set->variant->uref)
 			set->variant->uref(set, cb, false);
@@ -1440,7 +1444,7 @@ ip_set_dump_start(struct sk_buff *skb, struct netlink_callback *cb)
 release_refcount:
 	/* If there was an error or set is done, release set */
 	if (ret || !cb->args[IPSET_CB_ARG0]) {
-		set = ip_set(inst, index);
+		set = ip_set_ref_netlink(inst, index);
 		if (set->variant->uref)
 			set->variant->uref(set, cb, false);
 		pr_debug("release set %s\n", set->name);
-- 
2.17.1
