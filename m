From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 27/38] netfilter: Remove useless param helper of nf_ct_helper_ext_add
Date: Fri, 20 Jul 2018 15:08:55 +0200
Message-ID: <20180720130906.27687-28-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Gao Feng <gfree.wind@vip.163.com>

The param helper of nf_ct_helper_ext_add is useless now, then remove
it now.

Signed-off-by: Gao Feng <gfree.wind@vip.163.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_helper.h | 4 +---
 net/netfilter/nf_conntrack_core.c           | 3 +--
 net/netfilter/nf_conntrack_helper.c         | 5 ++---
 net/netfilter/nf_conntrack_netlink.c        | 2 +-
 net/netfilter/nft_ct.c                      | 2 +-
 net/netfilter/xt_CT.c                       | 2 +-
 net/openvswitch/conntrack.c                 | 2 +-
 7 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 32c2a94a219d..2492120b8097 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -103,9 +103,7 @@ int nf_conntrack_helpers_register(struct nf_conntrack_helper *, unsigned int);
 void nf_conntrack_helpers_unregister(struct nf_conntrack_helper *,
 				     unsigned int);
 
-struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct,
-					  struct nf_conntrack_helper *helper,
-					  gfp_t gfp);
+struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp);
 
 int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 			      gfp_t flags);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 4ced7c7102b6..d97d7e9a9ee7 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1401,8 +1401,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 			/* exp->master safe, refcnt bumped in nf_ct_find_expectation */
 			ct->master = exp->master;
 			if (exp->helper) {
-				help = nf_ct_helper_ext_add(ct, exp->helper,
-							    GFP_ATOMIC);
+				help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
 				if (help)
 					rcu_assign_pointer(help->helper, exp->helper);
 			}
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index a55a58c706a9..d557a425289d 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -192,8 +192,7 @@ void nf_conntrack_helper_put(struct nf_conntrack_helper *helper)
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_put);
 
 struct nf_conn_help *
-nf_ct_helper_ext_add(struct nf_conn *ct,
-		     struct nf_conntrack_helper *helper, gfp_t gfp)
+nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp)
 {
 	struct nf_conn_help *help;
 
@@ -262,7 +261,7 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 	}
 
 	if (help == NULL) {
-		help = nf_ct_helper_ext_add(ct, helper, flags);
+		help = nf_ct_helper_ext_add(ct, flags);
 		if (help == NULL)
 			return -ENOMEM;
 	} else {
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 40152b9ad772..f981bfa8db72 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1947,7 +1947,7 @@ ctnetlink_create_conntrack(struct net *net,
 		} else {
 			struct nf_conn_help *help;
 
-			help = nf_ct_helper_ext_add(ct, helper, GFP_ATOMIC);
+			help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
 			if (help == NULL) {
 				err = -ENOMEM;
 				goto err2;
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 1435ffc5f57e..3bc82ee5464d 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -870,7 +870,7 @@ static void nft_ct_helper_obj_eval(struct nft_object *obj,
 	if (test_bit(IPS_HELPER_BIT, &ct->status))
 		return;
 
-	help = nf_ct_helper_ext_add(ct, to_assign, GFP_ATOMIC);
+	help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
 	if (help) {
 		rcu_assign_pointer(help->helper, to_assign);
 		set_bit(IPS_HELPER_BIT, &ct->status);
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 03b9a50ec93b..7ba454e9e3fa 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -93,7 +93,7 @@ xt_ct_set_helper(struct nf_conn *ct, const char *helper_name,
 		return -ENOENT;
 	}
 
-	help = nf_ct_helper_ext_add(ct, helper, GFP_KERNEL);
+	help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
 	if (help == NULL) {
 		nf_conntrack_helper_put(helper);
 		return -ENOMEM;
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index e05bd3e53f0f..3e33c382367f 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1303,7 +1303,7 @@ static int ovs_ct_add_helper(struct ovs_conntrack_info *info, const char *name,
 		return -EINVAL;
 	}
 
-	help = nf_ct_helper_ext_add(info->ct, helper, GFP_KERNEL);
+	help = nf_ct_helper_ext_add(info->ct, GFP_KERNEL);
 	if (!help) {
 		nf_conntrack_helper_put(helper);
 		return -ENOMEM;
-- 
2.11.0
