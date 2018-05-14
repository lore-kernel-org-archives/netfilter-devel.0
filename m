From: Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH 09/14] net: sched: don't release reference on action overwrite
Date: Mon, 14 May 2018 17:27:10 +0300
Message-ID: <1526308035-12484-10-git-send-email-vladbu@mellanox.com>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
Cc: davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, pablo@netfilter.org, kadlec@blackhole.kfki.hu,
        fw@strlen.de, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, vladbu@mellanox.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, kliteyn@mellanox.com
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Return from action init function with reference to action taken,
even when overwriting existing action.

Action init API initializes its fourth argument (pointer to pointer to
tc action) to either existing action with same index or newly created
action. In case of existing index(and bind argument is zero), init
function returns without incrementing action reference counter. Caller
of action init then proceeds working with action without actually
holding reference to it. This means that action could be deleted
concurrently. To prevent such scenario this patch changes action init
behavior to always take reference to action before returning
successfully.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 net/sched/act_bpf.c        |  8 ++++----
 net/sched/act_connmark.c   |  5 +++--
 net/sched/act_csum.c       |  8 ++++----
 net/sched/act_gact.c       |  5 +++--
 net/sched/act_ife.c        | 12 +++++-------
 net/sched/act_ipt.c        |  5 +++--
 net/sched/act_mirred.c     |  5 ++---
 net/sched/act_nat.c        |  5 +++--
 net/sched/act_pedit.c      |  5 +++--
 net/sched/act_police.c     |  8 +++-----
 net/sched/act_sample.c     |  8 +++-----
 net/sched/act_simple.c     |  5 +++--
 net/sched/act_skbedit.c    |  5 +++--
 net/sched/act_skbmod.c     |  8 +++-----
 net/sched/act_tunnel_key.c |  8 +++-----
 net/sched/act_vlan.c       |  8 +++-----
 16 files changed, 51 insertions(+), 57 deletions(-)

diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index 5d95c43..5554bf7 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -311,9 +311,10 @@ static int tcf_bpf_init(struct net *net, struct nlattr *nla,
 		if (bind)
 			return 0;
 
-		tcf_idr_release(*act, bind);
-		if (!replace)
+		if (!replace) {
+			tcf_idr_release(*act, bind);
 			return -EEXIST;
+		}
 	}
 
 	is_bpf = tb[TCA_ACT_BPF_OPS_LEN] && tb[TCA_ACT_BPF_OPS];
@@ -356,8 +357,7 @@ static int tcf_bpf_init(struct net *net, struct nlattr *nla,
 
 	return res;
 out:
-	if (res == ACT_P_CREATED)
-		tcf_idr_release(*act, bind);
+	tcf_idr_release(*act, bind);
 
 	return ret;
 }
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index ff6444e..2a4c3da 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -135,9 +135,10 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 		ci = to_connmark(*a);
 		if (bind)
 			return 0;
-		tcf_idr_release(*a, bind);
-		if (!ovr)
+		if (!ovr) {
+			tcf_idr_release(*a, bind);
 			return -EEXIST;
+		}
 		/* replacing action and zone */
 		ci->tcf_action = parm->action;
 		ci->zone = parm->zone;
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index a692ac1..74f5dce 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -76,9 +76,10 @@ static int tcf_csum_init(struct net *net, struct nlattr *nla,
 	} else {
 		if (bind)/* dont override defaults */
 			return 0;
-		tcf_idr_release(*a, bind);
-		if (!ovr)
+		if (!ovr) {
+			tcf_idr_release(*a, bind);
 			return -EEXIST;
+		}
 	}
 
 	p = to_tcf_csum(*a);
@@ -86,8 +87,7 @@ static int tcf_csum_init(struct net *net, struct nlattr *nla,
 
 	params_new = kzalloc(sizeof(*params_new), GFP_KERNEL);
 	if (unlikely(!params_new)) {
-		if (ret == ACT_P_CREATED)
-			tcf_idr_release(*a, bind);
+		tcf_idr_release(*a, bind);
 		return -ENOMEM;
 	}
 	params_old = rtnl_dereference(p->params);
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index 0c536cd..9d7d000 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -100,9 +100,10 @@ static int tcf_gact_init(struct net *net, struct nlattr *nla,
 	} else {
 		if (bind)/* dont override defaults */
 			return 0;
-		tcf_idr_release(*a, bind);
-		if (!ovr)
+		if (!ovr) {
+			tcf_idr_release(*a, bind);
 			return -EEXIST;
+		}
 	}
 
 	gact = to_gact(*a);
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index cb155cd..b57c5ba 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -497,12 +497,10 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 			return ret;
 		}
 		ret = ACT_P_CREATED;
-	} else {
+	} else if (!ovr) {
 		tcf_idr_release(*a, bind);
-		if (!ovr) {
-			kfree(p);
-			return -EEXIST;
-		}
+		kfree(p);
+		return -EEXIST;
 	}
 
 	ife = to_ife(*a);
@@ -544,13 +542,13 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 				       NULL, NULL);
 		if (err) {
 metadata_parse_err:
-			if (exists)
-				tcf_idr_release(*a, bind);
 			if (ret == ACT_P_CREATED)
 				_tcf_ife_cleanup(*a);
 
 			if (exists)
 				spin_unlock_bh(&ife->tcf_lock);
+			tcf_idr_release(*a, bind);
+
 			kfree(p);
 			return err;
 		}
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 0acf784..7c26ce1 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -145,10 +145,11 @@ static int __tcf_ipt_init(struct net *net, unsigned int id, struct nlattr *nla,
 	} else {
 		if (bind)/* dont override defaults */
 			return 0;
-		tcf_idr_release(*a, bind);
 
-		if (!ovr)
+		if (!ovr) {
+			tcf_idr_release(*a, bind);
 			return -EEXIST;
+		}
 	}
 	hook = nla_get_u32(tb[TCA_IPT_HOOK]);
 
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 607da4b..b9b7b96 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -132,10 +132,9 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 		if (ret)
 			return ret;
 		ret = ACT_P_CREATED;
-	} else {
+	} else if (!ovr) {
 		tcf_idr_release(*a, bind);
-		if (!ovr)
-			return -EEXIST;
+		return -EEXIST;
 	}
 	m = to_mirred(*a);
 
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index 2f2f045..77badb2 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -66,9 +66,10 @@ static int tcf_nat_init(struct net *net, struct nlattr *nla, struct nlattr *est,
 	} else {
 		if (bind)
 			return 0;
-		tcf_idr_release(*a, bind);
-		if (!ovr)
+		if (!ovr) {
+			tcf_idr_release(*a, bind);
 			return -EEXIST;
+		}
 	}
 	p = to_tcf_nat(*a);
 
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 117e486..8c39adc 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -185,9 +185,10 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	} else {
 		if (bind)
 			return 0;
-		tcf_idr_release(*a, bind);
-		if (!ovr)
+		if (!ovr) {
+			tcf_idr_release(*a, bind);
 			return -EEXIST;
+		}
 		p = to_pedit(*a);
 		if (p->tcfp_nkeys && p->tcfp_nkeys != parm->nkeys) {
 			keys = kmalloc(ksize, GFP_KERNEL);
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 2971ba3..86d9417 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -111,10 +111,9 @@ static int tcf_act_police_init(struct net *net, struct nlattr *nla,
 		if (ret)
 			return ret;
 		ret = ACT_P_CREATED;
-	} else {
+	} else if (!ovr) {
 		tcf_idr_release(*a, bind);
-		if (!ovr)
-			return -EEXIST;
+		return -EEXIST;
 	}
 
 	police = to_police(*a);
@@ -195,8 +194,7 @@ static int tcf_act_police_init(struct net *net, struct nlattr *nla,
 failure:
 	qdisc_put_rtab(P_tab);
 	qdisc_put_rtab(R_tab);
-	if (ret == ACT_P_CREATED)
-		tcf_idr_release(*a, bind);
+	tcf_idr_release(*a, bind);
 	return err;
 }
 
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 9bbd8e9..d2b0394 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -69,10 +69,9 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 		if (ret)
 			return ret;
 		ret = ACT_P_CREATED;
-	} else {
+	} else if (!ovr) {
 		tcf_idr_release(*a, bind);
-		if (!ovr)
-			return -EEXIST;
+		return -EEXIST;
 	}
 	s = to_sample(*a);
 
@@ -81,8 +80,7 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 	s->psample_group_num = nla_get_u32(tb[TCA_SAMPLE_PSAMPLE_GROUP]);
 	psample_group = psample_group_get(net, s->psample_group_num);
 	if (!psample_group) {
-		if (ret == ACT_P_CREATED)
-			tcf_idr_release(*a, bind);
+		tcf_idr_release(*a, bind);
 		return -ENOMEM;
 	}
 	RCU_INIT_POINTER(s->psample_group, psample_group);
diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
index 162f091..26eb153 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -130,9 +130,10 @@ static int tcf_simp_init(struct net *net, struct nlattr *nla,
 	} else {
 		d = to_defact(*a);
 
-		tcf_idr_release(*a, bind);
-		if (!ovr)
+		if (!ovr) {
+			tcf_idr_release(*a, bind);
 			return -EEXIST;
+		}
 
 		reset_policy(d, defdata, parm);
 	}
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 4b9d616..bb416b7 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -136,9 +136,10 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 		ret = ACT_P_CREATED;
 	} else {
 		d = to_skbedit(*a);
-		tcf_idr_release(*a, bind);
-		if (!ovr)
+		if (!ovr) {
+			tcf_idr_release(*a, bind);
 			return -EEXIST;
+		}
 	}
 
 	spin_lock_bh(&d->tcf_lock);
diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index c1f9eda..e1c2e1c 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -142,10 +142,9 @@ static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
 			return ret;
 
 		ret = ACT_P_CREATED;
-	} else {
+	} else if (!ovr) {
 		tcf_idr_release(*a, bind);
-		if (!ovr)
-			return -EEXIST;
+		return -EEXIST;
 	}
 
 	d = to_skbmod(*a);
@@ -153,8 +152,7 @@ static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
 	ASSERT_RTNL();
 	p = kzalloc(sizeof(struct tcf_skbmod_params), GFP_KERNEL);
 	if (unlikely(!p)) {
-		if (ret == ACT_P_CREATED)
-			tcf_idr_release(*a, bind);
+		tcf_idr_release(*a, bind);
 		return -ENOMEM;
 	}
 
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index e4f9718..d88c151 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -165,10 +165,9 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 			return ret;
 
 		ret = ACT_P_CREATED;
-	} else {
+	} else if (!ovr) {
 		tcf_idr_release(*a, bind);
-		if (!ovr)
-			return -EEXIST;
+		return -EEXIST;
 	}
 
 	t = to_tunnel_key(*a);
@@ -176,8 +175,7 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 	ASSERT_RTNL();
 	params_new = kzalloc(sizeof(*params_new), GFP_KERNEL);
 	if (unlikely(!params_new)) {
-		if (ret == ACT_P_CREATED)
-			tcf_idr_release(*a, bind);
+		tcf_idr_release(*a, bind);
 		return -ENOMEM;
 	}
 
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 6a949f5..f747fb6 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -185,10 +185,9 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 			return ret;
 
 		ret = ACT_P_CREATED;
-	} else {
+	} else if (!ovr) {
 		tcf_idr_release(*a, bind);
-		if (!ovr)
-			return -EEXIST;
+		return -EEXIST;
 	}
 
 	v = to_vlan(*a);
@@ -196,8 +195,7 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 	ASSERT_RTNL();
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p) {
-		if (ret == ACT_P_CREATED)
-			tcf_idr_release(*a, bind);
+		tcf_idr_release(*a, bind);
 		return -ENOMEM;
 	}
 
-- 
2.7.5
