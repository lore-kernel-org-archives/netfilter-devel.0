From: Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH 04/14] net: sched: implement unlocked action init API
Date: Mon, 14 May 2018 17:27:05 +0300
Message-ID: <1526308035-12484-5-git-send-email-vladbu@mellanox.com>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
Cc: davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, pablo@netfilter.org, kadlec@blackhole.kfki.hu,
        fw@strlen.de, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, vladbu@mellanox.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, kliteyn@mellanox.com
To: netdev@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Add additional 'unlocked' argument to act API init functions.
Argument is true when rtnl lock is not taken and false otherwise.
It is required to implement actions that need to release rtnl lock before
loading kernel module and reacquire if afterwards.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 include/net/act_api.h      |  6 ++++--
 net/sched/act_api.c        | 17 ++++++++++-------
 net/sched/act_bpf.c        |  3 ++-
 net/sched/act_connmark.c   |  2 +-
 net/sched/act_csum.c       |  3 ++-
 net/sched/act_gact.c       |  3 ++-
 net/sched/act_ife.c        |  3 ++-
 net/sched/act_ipt.c        |  6 ++++--
 net/sched/act_mirred.c     |  5 +++--
 net/sched/act_nat.c        |  2 +-
 net/sched/act_pedit.c      |  3 ++-
 net/sched/act_police.c     |  2 +-
 net/sched/act_sample.c     |  3 ++-
 net/sched/act_simple.c     |  3 ++-
 net/sched/act_skbedit.c    |  3 ++-
 net/sched/act_skbmod.c     |  3 ++-
 net/sched/act_tunnel_key.c |  3 ++-
 net/sched/act_vlan.c       |  3 ++-
 net/sched/cls_api.c        |  5 +++--
 19 files changed, 49 insertions(+), 29 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 73175a3..a8c8570 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -92,7 +92,8 @@ struct tc_action_ops {
 			  struct netlink_ext_ack *extack);
 	int     (*init)(struct net *net, struct nlattr *nla,
 			struct nlattr *est, struct tc_action **act, int ovr,
-			int bind, struct netlink_ext_ack *extack);
+			int bind, bool unlocked,
+			struct netlink_ext_ack *extack);
 	int     (*walk)(struct net *, struct sk_buff *,
 			struct netlink_callback *, int,
 			const struct tc_action_ops *,
@@ -168,11 +169,12 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 		    int nr_actions, struct tcf_result *res);
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		    struct nlattr *est, char *name, int ovr, int bind,
-		    struct list_head *actions, size_t *attr_size,
+		    struct list_head *actions, size_t *attr_size, bool unlocked,
 		    struct netlink_ext_ack *extack);
 struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				    struct nlattr *nla, struct nlattr *est,
 				    char *name, int ovr, int bind,
+				    bool unlocked,
 				    struct netlink_ext_ack *extack);
 int tcf_action_dump(struct sk_buff *skb, struct list_head *, int, int);
 int tcf_action_dump_old(struct sk_buff *skb, struct tc_action *a, int, int);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 96b0878..1331beb 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -671,6 +671,7 @@ static struct tc_cookie *nla_memdup_cookie(struct nlattr **tb)
 struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				    struct nlattr *nla, struct nlattr *est,
 				    char *name, int ovr, int bind,
+				    bool unlocked,
 				    struct netlink_ext_ack *extack)
 {
 	struct tc_action *a;
@@ -721,9 +722,11 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	a_o = tc_lookup_action_n(act_name);
 	if (a_o == NULL) {
 #ifdef CONFIG_MODULES
-		rtnl_unlock();
+		if (!unlocked)
+			rtnl_unlock();
 		request_module("act_%s", act_name);
-		rtnl_lock();
+		if (!unlocked)
+			rtnl_lock();
 
 		a_o = tc_lookup_action_n(act_name);
 
@@ -746,9 +749,9 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	/* backward compatibility for policer */
 	if (name == NULL)
 		err = a_o->init(net, tb[TCA_ACT_OPTIONS], est, &a, ovr, bind,
-				extack);
+				unlocked, extack);
 	else
-		err = a_o->init(net, nla, est, &a, ovr, bind, extack);
+		err = a_o->init(net, nla, est, &a, ovr, bind, unlocked, extack);
 	if (err < 0)
 		goto err_mod;
 
@@ -799,7 +802,7 @@ static void cleanup_a(struct list_head *actions, int ovr)
 
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		    struct nlattr *est, char *name, int ovr, int bind,
-		    struct list_head *actions, size_t *attr_size,
+		    struct list_head *actions, size_t *attr_size, bool unlocked,
 		    struct netlink_ext_ack *extack)
 {
 	struct nlattr *tb[TCA_ACT_MAX_PRIO + 1];
@@ -814,7 +817,7 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 
 	for (i = 1; i <= TCA_ACT_MAX_PRIO && tb[i]; i++) {
 		act = tcf_action_init_1(net, tp, tb[i], est, name, ovr, bind,
-					extack);
+					unlocked, extack);
 		if (IS_ERR(act)) {
 			err = PTR_ERR(act);
 			goto err;
@@ -1173,7 +1176,7 @@ static int tcf_action_add(struct net *net, struct nlattr *nla,
 	LIST_HEAD(actions);
 
 	ret = tcf_action_init(net, NULL, nla, NULL, NULL, ovr, 0, &actions,
-			      &attr_size, extack);
+			      &attr_size, false, extack);
 	if (ret)
 		return ret;
 
diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index 15a2a53..5d95c43 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -276,7 +276,8 @@ static void tcf_bpf_prog_fill_cfg(const struct tcf_bpf *prog,
 
 static int tcf_bpf_init(struct net *net, struct nlattr *nla,
 			struct nlattr *est, struct tc_action **act,
-			int replace, int bind, struct netlink_ext_ack *extack)
+			int replace, int bind, bool unlocked,
+			struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, bpf_net_id);
 	struct nlattr *tb[TCA_ACT_BPF_MAX + 1];
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 1888650..ff6444e 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -96,7 +96,7 @@ static const struct nla_policy connmark_policy[TCA_CONNMARK_MAX + 1] = {
 
 static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 			     struct nlattr *est, struct tc_action **a,
-			     int ovr, int bind,
+			     int ovr, int bind, bool unlocked,
 			     struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, connmark_net_id);
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index 0572682..a692ac1 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -46,7 +46,8 @@ static struct tc_action_ops act_csum_ops;
 
 static int tcf_csum_init(struct net *net, struct nlattr *nla,
 			 struct nlattr *est, struct tc_action **a, int ovr,
-			 int bind, struct netlink_ext_ack *extack)
+			 int bind, bool unlocked,
+			 struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, csum_net_id);
 	struct tcf_csum_params *params_old, *params_new;
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index ca83deb..0c536cd 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -56,7 +56,8 @@ static const struct nla_policy gact_policy[TCA_GACT_MAX + 1] = {
 
 static int tcf_gact_init(struct net *net, struct nlattr *nla,
 			 struct nlattr *est, struct tc_action **a,
-			 int ovr, int bind, struct netlink_ext_ack *extack)
+			 int ovr, int bind, bool unlocked,
+			 struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, gact_net_id);
 	struct nlattr *tb[TCA_GACT_MAX + 1];
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index 689f63e..cb155cd 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -447,7 +447,8 @@ static int populate_metalist(struct tcf_ife_info *ife, struct nlattr **tb,
 
 static int tcf_ife_init(struct net *net, struct nlattr *nla,
 			struct nlattr *est, struct tc_action **a,
-			int ovr, int bind, struct netlink_ext_ack *extack)
+			int ovr, int bind, bool unlocked,
+			struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, ife_net_id);
 	struct nlattr *tb[TCA_IFE_MAX + 1];
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 7bce88d..0acf784 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -196,7 +196,8 @@ static int __tcf_ipt_init(struct net *net, unsigned int id, struct nlattr *nla,
 
 static int tcf_ipt_init(struct net *net, struct nlattr *nla,
 			struct nlattr *est, struct tc_action **a, int ovr,
-			int bind, struct netlink_ext_ack *extack)
+			int bind, bool unlocked,
+			struct netlink_ext_ack *extack)
 {
 	return __tcf_ipt_init(net, ipt_net_id, nla, est, a, &act_ipt_ops, ovr,
 			      bind);
@@ -204,7 +205,8 @@ static int tcf_ipt_init(struct net *net, struct nlattr *nla,
 
 static int tcf_xt_init(struct net *net, struct nlattr *nla,
 		       struct nlattr *est, struct tc_action **a, int ovr,
-		       int bind, struct netlink_ext_ack *extack)
+		       int bind, bool unlocked,
+		       struct netlink_ext_ack *extack)
 {
 	return __tcf_ipt_init(net, xt_net_id, nla, est, a, &act_xt_ops, ovr,
 			      bind);
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 82a8bdd..607da4b 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -68,8 +68,9 @@ static unsigned int mirred_net_id;
 static struct tc_action_ops act_mirred_ops;
 
 static int tcf_mirred_init(struct net *net, struct nlattr *nla,
-			   struct nlattr *est, struct tc_action **a, int ovr,
-			   int bind, struct netlink_ext_ack *extack)
+			   struct nlattr *est, struct tc_action **a,
+			   int ovr, int bind, bool unlocked,
+			   struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, mirred_net_id);
 	struct nlattr *tb[TCA_MIRRED_MAX + 1];
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index 457c2ae..2f2f045 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -37,7 +37,7 @@ static const struct nla_policy nat_policy[TCA_NAT_MAX + 1] = {
 };
 
 static int tcf_nat_init(struct net *net, struct nlattr *nla, struct nlattr *est,
-			struct tc_action **a, int ovr, int bind,
+			struct tc_action **a, int ovr, int bind, bool unlocked,
 			struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, nat_net_id);
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 0102b29..117e486 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -132,7 +132,8 @@ static int tcf_pedit_key_ex_dump(struct sk_buff *skb,
 
 static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 			  struct nlattr *est, struct tc_action **a,
-			  int ovr, int bind, struct netlink_ext_ack *extack)
+			  int ovr, int bind, bool unlocked,
+			  struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, pedit_net_id);
 	struct nlattr *tb[TCA_PEDIT_MAX + 1];
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index a789b80..2971ba3 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -75,7 +75,7 @@ static const struct nla_policy police_policy[TCA_POLICE_MAX + 1] = {
 
 static int tcf_act_police_init(struct net *net, struct nlattr *nla,
 			       struct nlattr *est, struct tc_action **a,
-			       int ovr, int bind,
+			       int ovr, int bind, bool unlocked,
 			       struct netlink_ext_ack *extack)
 {
 	int ret = 0, err;
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 4a46978..9bbd8e9 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -37,7 +37,8 @@ static const struct nla_policy sample_policy[TCA_SAMPLE_MAX + 1] = {
 
 static int tcf_sample_init(struct net *net, struct nlattr *nla,
 			   struct nlattr *est, struct tc_action **a, int ovr,
-			   int bind, struct netlink_ext_ack *extack)
+			   int bind,  bool unlocked,
+			   struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, sample_net_id);
 	struct nlattr *tb[TCA_SAMPLE_MAX + 1];
diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
index 95d5985..162f091 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -79,7 +79,8 @@ static const struct nla_policy simple_policy[TCA_DEF_MAX + 1] = {
 
 static int tcf_simp_init(struct net *net, struct nlattr *nla,
 			 struct nlattr *est, struct tc_action **a,
-			 int ovr, int bind, struct netlink_ext_ack *extack)
+			 int ovr, int bind, bool unlocked,
+			 struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, simp_net_id);
 	struct nlattr *tb[TCA_DEF_MAX + 1];
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index adf0a72..4b9d616 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -66,7 +66,8 @@ static const struct nla_policy skbedit_policy[TCA_SKBEDIT_MAX + 1] = {
 
 static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 			    struct nlattr *est, struct tc_action **a,
-			    int ovr, int bind, struct netlink_ext_ack *extack)
+			    int ovr, int bind, bool unlocked,
+			    struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, skbedit_net_id);
 	struct nlattr *tb[TCA_SKBEDIT_MAX + 1];
diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index a0d9abb..c1f9eda 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -84,7 +84,8 @@ static const struct nla_policy skbmod_policy[TCA_SKBMOD_MAX + 1] = {
 
 static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
 			   struct nlattr *est, struct tc_action **a,
-			   int ovr, int bind, struct netlink_ext_ack *extack)
+			   int ovr, int bind, bool unlocked,
+			   struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, skbmod_net_id);
 	struct nlattr *tb[TCA_SKBMOD_MAX + 1];
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index c6e5069..e4f9718 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -70,7 +70,8 @@ static const struct nla_policy tunnel_key_policy[TCA_TUNNEL_KEY_MAX + 1] = {
 
 static int tunnel_key_init(struct net *net, struct nlattr *nla,
 			   struct nlattr *est, struct tc_action **a,
-			   int ovr, int bind, struct netlink_ext_ack *extack)
+			   int ovr, int bind, bool unlocked,
+			   struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, tunnel_key_net_id);
 	struct nlattr *tb[TCA_TUNNEL_KEY_MAX + 1];
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 8dda784..6a949f5 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -109,7 +109,8 @@ static const struct nla_policy vlan_policy[TCA_VLAN_MAX + 1] = {
 
 static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 			 struct nlattr *est, struct tc_action **a,
-			 int ovr, int bind, struct netlink_ext_ack *extack)
+			 int ovr, int bind, bool unlocked,
+			 struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, vlan_net_id);
 	struct nlattr *tb[TCA_VLAN_MAX + 1];
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index b66754f..bcba94b 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1438,7 +1438,7 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
 		if (exts->police && tb[exts->police]) {
 			act = tcf_action_init_1(net, tp, tb[exts->police],
 						rate_tlv, "police", ovr,
-						TCA_ACT_BIND, extack);
+						TCA_ACT_BIND, false, extack);
 			if (IS_ERR(act))
 				return PTR_ERR(act);
 
@@ -1451,7 +1451,8 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
 
 			err = tcf_action_init(net, tp, tb[exts->action],
 					      rate_tlv, NULL, ovr, TCA_ACT_BIND,
-					      &actions, &attr_size, extack);
+					      &actions, &attr_size, false,
+					      extack);
 			if (err)
 				return err;
 			list_for_each_entry(act, &actions, list)
-- 
2.7.5
