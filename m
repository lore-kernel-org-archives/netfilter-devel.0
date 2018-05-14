From: Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH 13/14] net: sched: use unique idr insert function in unlocked actions
Date: Mon, 14 May 2018 17:27:14 +0300
Message-ID: <1526308035-12484-14-git-send-email-vladbu@mellanox.com>
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

Substitute calls to action insert function with calls to action insert
unique function that warns if insertion overwrites index in idr.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 net/sched/act_bpf.c        | 2 +-
 net/sched/act_connmark.c   | 2 +-
 net/sched/act_csum.c       | 2 +-
 net/sched/act_gact.c       | 2 +-
 net/sched/act_ife.c        | 2 +-
 net/sched/act_ipt.c        | 2 +-
 net/sched/act_mirred.c     | 2 +-
 net/sched/act_nat.c        | 2 +-
 net/sched/act_pedit.c      | 2 +-
 net/sched/act_police.c     | 2 +-
 net/sched/act_sample.c     | 2 +-
 net/sched/act_simple.c     | 2 +-
 net/sched/act_skbedit.c    | 2 +-
 net/sched/act_skbmod.c     | 2 +-
 net/sched/act_tunnel_key.c | 2 +-
 net/sched/act_vlan.c       | 2 +-
 16 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index 7e20fdc..0bf4ecf 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -354,7 +354,7 @@ static int tcf_bpf_init(struct net *net, struct nlattr *nla,
 	rcu_assign_pointer(prog->filter, cfg.filter);
 
 	if (res == ACT_P_CREATED) {
-		tcf_idr_insert(tn, *act);
+		tcf_idr_insert_unique(tn, *act);
 	} else {
 		/* make sure the program being replaced is no longer executing */
 		synchronize_rcu();
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 6ff45af..a4e9f21 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -135,7 +135,7 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 		ci->net = net;
 		ci->zone = parm->zone;
 
-		tcf_idr_insert(tn, *a);
+		tcf_idr_insert_unique(tn, *a);
 		ret = ACT_P_CREATED;
 	} else {
 		ci = to_connmark(*a);
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index 49d06c3..d9836d2 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -105,7 +105,7 @@ static int tcf_csum_init(struct net *net, struct nlattr *nla,
 		kfree_rcu(params_old, rcu);
 
 	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
+		tcf_idr_insert_unique(tn, *a);
 
 	return ret;
 }
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index 2edefeb..79266590 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -128,7 +128,7 @@ static int tcf_gact_init(struct net *net, struct nlattr *nla,
 	}
 #endif
 	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
+		tcf_idr_insert_unique(tn, *a);
 	return ret;
 }
 
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index 665790f..060144e 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -590,7 +590,7 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 		kfree_rcu(p_old, rcu);
 
 	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
+		tcf_idr_insert_unique(tn, *a);
 
 	return ret;
 }
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 946193e..ff8cf9d 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -188,7 +188,7 @@ static int __tcf_ipt_init(struct net *net, unsigned int id, struct nlattr *nla,
 	ipt->tcfi_hook  = hook;
 	spin_unlock_bh(&ipt->tcf_lock);
 	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
+		tcf_idr_insert_unique(tn, *a);
 	return ret;
 
 err3:
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 4c8bd26..7ab8d0c 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -157,7 +157,7 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 
 	if (ret == ACT_P_CREATED) {
 		list_add(&m->tcfm_list, &mirred_list);
-		tcf_idr_insert(tn, *a);
+		tcf_idr_insert_unique(tn, *a);
 	}
 
 	return ret;
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index a1a1885..a15c4a9 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -89,7 +89,7 @@ static int tcf_nat_init(struct net *net, struct nlattr *nla, struct nlattr *est,
 	spin_unlock_bh(&p->tcf_lock);
 
 	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
+		tcf_idr_insert_unique(tn, *a);
 
 	return ret;
 }
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index e5e93e2..49034d4 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -220,7 +220,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 
 	spin_unlock_bh(&p->tcf_lock);
 	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
+		tcf_idr_insert_unique(tn, *a);
 	return ret;
 }
 
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index ced6b1f..eb4e458 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -194,7 +194,7 @@ static int tcf_act_police_init(struct net *net, struct nlattr *nla,
 		return ret;
 
 	police->tcfp_t_c = ktime_get_ns();
-	tcf_idr_insert(tn, *a);
+	tcf_idr_insert_unique(tn, *a);
 
 	return ret;
 
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 7411805..5a650d4 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -97,7 +97,7 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 	}
 
 	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
+		tcf_idr_insert_unique(tn, *a);
 	return ret;
 }
 
diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
index a4b2aca..13809e5 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -146,7 +146,7 @@ static int tcf_simp_init(struct net *net, struct nlattr *nla,
 	}
 
 	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
+		tcf_idr_insert_unique(tn, *a);
 	return ret;
 }
 
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 7750b77..bf87679 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -169,7 +169,7 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 	spin_unlock_bh(&d->tcf_lock);
 
 	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
+		tcf_idr_insert_unique(tn, *a);
 	return ret;
 }
 
diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index bbc5092..dc36e6f 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -185,7 +185,7 @@ static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
 		kfree_rcu(p_old, rcu);
 
 	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
+		tcf_idr_insert_unique(tn, *a);
 	return ret;
 }
 
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 4367962..16926c7 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -198,7 +198,7 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 		kfree_rcu(params_old, rcu);
 
 	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
+		tcf_idr_insert_unique(tn, *a);
 
 	return ret;
 
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index adc4e6e..02fbf76 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -221,7 +221,7 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 		kfree_rcu(p_old, rcu);
 
 	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
+		tcf_idr_insert_unique(tn, *a);
 	return ret;
 }
 
-- 
2.7.5
