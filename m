From: Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH 14/14] net: sched: implement delete for all actions
Date: Mon, 14 May 2018 17:27:15 +0300
Message-ID: <1526308035-12484-15-git-send-email-vladbu@mellanox.com>
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

Implement delete function that is required to delete actions without
holding rtnl lock. Use action API function that atomically deletes action
only if it is still in action idr. This implementation prevents concurrent
threads from deleting same action twice.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 net/sched/act_bpf.c        |  8 ++++++++
 net/sched/act_connmark.c   |  8 ++++++++
 net/sched/act_csum.c       |  8 ++++++++
 net/sched/act_gact.c       |  8 ++++++++
 net/sched/act_ife.c        |  8 ++++++++
 net/sched/act_ipt.c        | 16 ++++++++++++++++
 net/sched/act_mirred.c     |  8 ++++++++
 net/sched/act_nat.c        |  8 ++++++++
 net/sched/act_pedit.c      |  8 ++++++++
 net/sched/act_police.c     |  8 ++++++++
 net/sched/act_sample.c     |  8 ++++++++
 net/sched/act_simple.c     |  8 ++++++++
 net/sched/act_skbedit.c    |  8 ++++++++
 net/sched/act_skbmod.c     |  8 ++++++++
 net/sched/act_tunnel_key.c |  8 ++++++++
 net/sched/act_vlan.c       |  8 ++++++++
 16 files changed, 136 insertions(+)

diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index 0bf4ecf..36f7f66 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -394,6 +394,13 @@ static int tcf_bpf_search(struct net *net, struct tc_action **a, u32 index,
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_bpf_delete(struct net *net, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, bpf_net_id);
+
+	return tcf_idr_find_delete(tn, index);
+}
+
 static struct tc_action_ops act_bpf_ops __read_mostly = {
 	.kind		=	"bpf",
 	.type		=	TCA_ACT_BPF,
@@ -404,6 +411,7 @@ static struct tc_action_ops act_bpf_ops __read_mostly = {
 	.init		=	tcf_bpf_init,
 	.walk		=	tcf_bpf_walker,
 	.lookup		=	tcf_bpf_search,
+	.delete		=	tcf_bpf_delete,
 	.size		=	sizeof(struct tcf_bpf),
 };
 
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index a4e9f21..346ede7 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -200,6 +200,13 @@ static int tcf_connmark_search(struct net *net, struct tc_action **a, u32 index,
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_connmark_delete(struct net *net, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, connmark_net_id);
+
+	return tcf_idr_find_delete(tn, index);
+}
+
 static struct tc_action_ops act_connmark_ops = {
 	.kind		=	"connmark",
 	.type		=	TCA_ACT_CONNMARK,
@@ -209,6 +216,7 @@ static struct tc_action_ops act_connmark_ops = {
 	.init		=	tcf_connmark_init,
 	.walk		=	tcf_connmark_walker,
 	.lookup		=	tcf_connmark_search,
+	.delete		=	tcf_connmark_delete,
 	.size		=	sizeof(struct tcf_connmark_info),
 };
 
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index d9836d2..b0a244e 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -655,6 +655,13 @@ static int tcf_csum_search(struct net *net, struct tc_action **a, u32 index,
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_csum_delete(struct net *net, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, csum_net_id);
+
+	return tcf_idr_find_delete(tn, index);
+}
+
 static struct tc_action_ops act_csum_ops = {
 	.kind		= "csum",
 	.type		= TCA_ACT_CSUM,
@@ -665,6 +672,7 @@ static struct tc_action_ops act_csum_ops = {
 	.cleanup	= tcf_csum_cleanup,
 	.walk		= tcf_csum_walker,
 	.lookup		= tcf_csum_search,
+	.delete		= tcf_csum_delete,
 	.size		= sizeof(struct tcf_csum),
 };
 
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index 79266590..f6ff668 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -238,6 +238,13 @@ static size_t tcf_gact_get_fill_size(const struct tc_action *act)
 	return sz;
 }
 
+static int tcf_gact_delete(struct net *net, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, gact_net_id);
+
+	return tcf_idr_find_delete(tn, index);
+}
+
 static struct tc_action_ops act_gact_ops = {
 	.kind		=	"gact",
 	.type		=	TCA_ACT_GACT,
@@ -249,6 +256,7 @@ static struct tc_action_ops act_gact_ops = {
 	.walk		=	tcf_gact_walker,
 	.lookup		=	tcf_gact_search,
 	.get_fill_size	=	tcf_gact_get_fill_size,
+	.delete		=	tcf_gact_delete,
 	.size		=	sizeof(struct tcf_gact),
 };
 
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index 060144e..d627060 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -845,6 +845,13 @@ static int tcf_ife_search(struct net *net, struct tc_action **a, u32 index,
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_ife_delete(struct net *net, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, ife_net_id);
+
+	return tcf_idr_find_delete(tn, index);
+}
+
 static struct tc_action_ops act_ife_ops = {
 	.kind = "ife",
 	.type = TCA_ACT_IFE,
@@ -855,6 +862,7 @@ static struct tc_action_ops act_ife_ops = {
 	.init = tcf_ife_init,
 	.walk = tcf_ife_walker,
 	.lookup = tcf_ife_search,
+	.delete = tcf_ife_delete,
 	.size =	sizeof(struct tcf_ife_info),
 };
 
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index ff8cf9d..d7bad79 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -331,6 +331,13 @@ static int tcf_ipt_search(struct net *net, struct tc_action **a, u32 index,
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_ipt_delete(struct net *net, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, ipt_net_id);
+
+	return tcf_idr_find_delete(tn, index);
+}
+
 static struct tc_action_ops act_ipt_ops = {
 	.kind		=	"ipt",
 	.type		=	TCA_ACT_IPT,
@@ -341,6 +348,7 @@ static struct tc_action_ops act_ipt_ops = {
 	.init		=	tcf_ipt_init,
 	.walk		=	tcf_ipt_walker,
 	.lookup		=	tcf_ipt_search,
+	.delete		=	tcf_ipt_delete,
 	.size		=	sizeof(struct tcf_ipt),
 };
 
@@ -381,6 +389,13 @@ static int tcf_xt_search(struct net *net, struct tc_action **a, u32 index,
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_xt_delete(struct net *net, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, xt_net_id);
+
+	return tcf_idr_find_delete(tn, index);
+}
+
 static struct tc_action_ops act_xt_ops = {
 	.kind		=	"xt",
 	.type		=	TCA_ACT_XT,
@@ -391,6 +406,7 @@ static struct tc_action_ops act_xt_ops = {
 	.init		=	tcf_xt_init,
 	.walk		=	tcf_xt_walker,
 	.lookup		=	tcf_xt_search,
+	.delete		=	tcf_xt_delete,
 	.size		=	sizeof(struct tcf_ipt),
 };
 
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 7ab8d0c..62ac34b 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -327,6 +327,13 @@ static struct net_device *tcf_mirred_get_dev(const struct tc_action *a)
 	return rtnl_dereference(m->tcfm_dev);
 }
 
+static int tcf_mirred_delete(struct net *net, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, mirred_net_id);
+
+	return tcf_idr_find_delete(tn, index);
+}
+
 static struct tc_action_ops act_mirred_ops = {
 	.kind		=	"mirred",
 	.type		=	TCA_ACT_MIRRED,
@@ -340,6 +347,7 @@ static struct tc_action_ops act_mirred_ops = {
 	.lookup		=	tcf_mirred_search,
 	.size		=	sizeof(struct tcf_mirred),
 	.get_dev	=	tcf_mirred_get_dev,
+	.delete		=	tcf_mirred_delete,
 };
 
 static __net_init int mirred_init_net(struct net *net)
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index a15c4a9..acf4064 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -301,6 +301,13 @@ static int tcf_nat_search(struct net *net, struct tc_action **a, u32 index,
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_nat_delete(struct net *net, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, nat_net_id);
+
+	return tcf_idr_find_delete(tn, index);
+}
+
 static struct tc_action_ops act_nat_ops = {
 	.kind		=	"nat",
 	.type		=	TCA_ACT_NAT,
@@ -310,6 +317,7 @@ static struct tc_action_ops act_nat_ops = {
 	.init		=	tcf_nat_init,
 	.walk		=	tcf_nat_walker,
 	.lookup		=	tcf_nat_search,
+	.delete		=	tcf_nat_delete,
 	.size		=	sizeof(struct tcf_nat),
 };
 
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 49034d4..4eb605d 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -443,6 +443,13 @@ static int tcf_pedit_search(struct net *net, struct tc_action **a, u32 index,
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_pedit_delete(struct net *net, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, pedit_net_id);
+
+	return tcf_idr_find_delete(tn, index);
+}
+
 static struct tc_action_ops act_pedit_ops = {
 	.kind		=	"pedit",
 	.type		=	TCA_ACT_PEDIT,
@@ -453,6 +460,7 @@ static struct tc_action_ops act_pedit_ops = {
 	.init		=	tcf_pedit_init,
 	.walk		=	tcf_pedit_walker,
 	.lookup		=	tcf_pedit_search,
+	.delete		=	tcf_pedit_delete,
 	.size		=	sizeof(struct tcf_pedit),
 };
 
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index eb4e458..b9827bb 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -319,6 +319,13 @@ static int tcf_police_search(struct net *net, struct tc_action **a, u32 index,
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_police_delete(struct net *net, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, police_net_id);
+
+	return tcf_idr_find_delete(tn, index);
+}
+
 MODULE_AUTHOR("Alexey Kuznetsov");
 MODULE_DESCRIPTION("Policing actions");
 MODULE_LICENSE("GPL");
@@ -332,6 +339,7 @@ static struct tc_action_ops act_police_ops = {
 	.init		=	tcf_act_police_init,
 	.walk		=	tcf_act_police_walker,
 	.lookup		=	tcf_police_search,
+	.delete		=	tcf_police_delete,
 	.size		=	sizeof(struct tcf_police),
 };
 
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 5a650d4..5843ce6 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -224,6 +224,13 @@ static int tcf_sample_search(struct net *net, struct tc_action **a, u32 index,
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_sample_delete(struct net *net, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, sample_net_id);
+
+	return tcf_idr_find_delete(tn, index);
+}
+
 static struct tc_action_ops act_sample_ops = {
 	.kind	  = "sample",
 	.type	  = TCA_ACT_SAMPLE,
@@ -234,6 +241,7 @@ static struct tc_action_ops act_sample_ops = {
 	.cleanup  = tcf_sample_cleanup,
 	.walk	  = tcf_sample_walker,
 	.lookup	  = tcf_sample_search,
+	.delete	  = tcf_sample_delete,
 	.size	  = sizeof(struct tcf_sample),
 };
 
diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
index 13809e5..c9857b2 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -195,6 +195,13 @@ static int tcf_simp_search(struct net *net, struct tc_action **a, u32 index,
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_simp_delete(struct net *net, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, simp_net_id);
+
+	return tcf_idr_find_delete(tn, index);
+}
+
 static struct tc_action_ops act_simp_ops = {
 	.kind		=	"simple",
 	.type		=	TCA_ACT_SIMP,
@@ -205,6 +212,7 @@ static struct tc_action_ops act_simp_ops = {
 	.init		=	tcf_simp_init,
 	.walk		=	tcf_simp_walker,
 	.lookup		=	tcf_simp_search,
+	.delete		=	tcf_simp_delete,
 	.size		=	sizeof(struct tcf_defact),
 };
 
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index bf87679..ee4c3f5 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -232,6 +232,13 @@ static int tcf_skbedit_search(struct net *net, struct tc_action **a, u32 index,
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_skbedit_delete(struct net *net, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, skbedit_net_id);
+
+	return tcf_idr_find_delete(tn, index);
+}
+
 static struct tc_action_ops act_skbedit_ops = {
 	.kind		=	"skbedit",
 	.type		=	TCA_ACT_SKBEDIT,
@@ -241,6 +248,7 @@ static struct tc_action_ops act_skbedit_ops = {
 	.init		=	tcf_skbedit_init,
 	.walk		=	tcf_skbedit_walker,
 	.lookup		=	tcf_skbedit_search,
+	.delete		=	tcf_skbedit_delete,
 	.size		=	sizeof(struct tcf_skbedit),
 };
 
diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index dc36e6f..a8b31e9 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -254,6 +254,13 @@ static int tcf_skbmod_search(struct net *net, struct tc_action **a, u32 index,
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_skbmod_delete(struct net *net, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, skbmod_net_id);
+
+	return tcf_idr_find_delete(tn, index);
+}
+
 static struct tc_action_ops act_skbmod_ops = {
 	.kind		=	"skbmod",
 	.type		=	TCA_ACT_SKBMOD,
@@ -264,6 +271,7 @@ static struct tc_action_ops act_skbmod_ops = {
 	.cleanup	=	tcf_skbmod_cleanup,
 	.walk		=	tcf_skbmod_walker,
 	.lookup		=	tcf_skbmod_search,
+	.delete		=	tcf_skbmod_delete,
 	.size		=	sizeof(struct tcf_skbmod),
 };
 
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 16926c7..9175580 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -315,6 +315,13 @@ static int tunnel_key_search(struct net *net, struct tc_action **a, u32 index,
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tunnel_key_delete(struct net *net, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, tunnel_key_net_id);
+
+	return tcf_idr_find_delete(tn, index);
+}
+
 static struct tc_action_ops act_tunnel_key_ops = {
 	.kind		=	"tunnel_key",
 	.type		=	TCA_ACT_TUNNEL_KEY,
@@ -325,6 +332,7 @@ static struct tc_action_ops act_tunnel_key_ops = {
 	.cleanup	=	tunnel_key_release,
 	.walk		=	tunnel_key_walker,
 	.lookup		=	tunnel_key_search,
+	.delete		=	tunnel_key_delete,
 	.size		=	sizeof(struct tcf_tunnel_key),
 };
 
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 02fbf76..6116e54 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -290,6 +290,13 @@ static int tcf_vlan_search(struct net *net, struct tc_action **a, u32 index,
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_vlan_delete(struct net *net, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, vlan_net_id);
+
+	return tcf_idr_find_delete(tn, index);
+}
+
 static struct tc_action_ops act_vlan_ops = {
 	.kind		=	"vlan",
 	.type		=	TCA_ACT_VLAN,
@@ -300,6 +307,7 @@ static struct tc_action_ops act_vlan_ops = {
 	.cleanup	=	tcf_vlan_cleanup,
 	.walk		=	tcf_vlan_walker,
 	.lookup		=	tcf_vlan_search,
+	.delete		=	tcf_vlan_delete,
 	.size		=	sizeof(struct tcf_vlan),
 };
 
-- 
2.7.5
