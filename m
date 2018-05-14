From: Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH 12/14] net: sched: retry action check-insert on concurrent modification
Date: Mon, 14 May 2018 17:27:13 +0300
Message-ID: <1526308035-12484-13-git-send-email-vladbu@mellanox.com>
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

Retry check-insert sequence in action init functions if action with same
index was inserted concurrently.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 net/sched/act_bpf.c        | 8 +++++++-
 net/sched/act_connmark.c   | 8 +++++++-
 net/sched/act_csum.c       | 8 +++++++-
 net/sched/act_gact.c       | 8 +++++++-
 net/sched/act_ife.c        | 8 +++++++-
 net/sched/act_ipt.c        | 8 +++++++-
 net/sched/act_mirred.c     | 8 +++++++-
 net/sched/act_nat.c        | 8 +++++++-
 net/sched/act_pedit.c      | 8 +++++++-
 net/sched/act_police.c     | 9 ++++++++-
 net/sched/act_sample.c     | 8 +++++++-
 net/sched/act_simple.c     | 9 ++++++++-
 net/sched/act_skbedit.c    | 8 +++++++-
 net/sched/act_skbmod.c     | 8 +++++++-
 net/sched/act_tunnel_key.c | 9 ++++++++-
 net/sched/act_vlan.c       | 9 ++++++++-
 16 files changed, 116 insertions(+), 16 deletions(-)

diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index 5554bf7..7e20fdc 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -299,10 +299,16 @@ static int tcf_bpf_init(struct net *net, struct nlattr *nla,
 
 	parm = nla_data(tb[TCA_ACT_BPF_PARMS]);
 
+replay:
 	if (!tcf_idr_check(tn, parm->index, act, bind)) {
 		ret = tcf_idr_create(tn, parm->index, est, act,
 				     &act_bpf_ops, bind, true);
-		if (ret < 0)
+		/* Action with specified index was created concurrently.
+		 * Check again.
+		 */
+		if (parm->index && ret == -ENOSPC)
+			goto replay;
+		else if (ret)
 			return ret;
 
 		res = ACT_P_CREATED;
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 2a4c3da..6ff45af 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -118,10 +118,16 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 
 	parm = nla_data(tb[TCA_CONNMARK_PARMS]);
 
+replay:
 	if (!tcf_idr_check(tn, parm->index, a, bind)) {
 		ret = tcf_idr_create(tn, parm->index, est, a,
 				     &act_connmark_ops, bind, false);
-		if (ret)
+		/* Action with specified index was created concurrently.
+		 * Check again.
+		 */
+		if (parm->index && ret == -ENOSPC)
+			goto replay;
+		else if (ret)
 			return ret;
 
 		ci = to_connmark(*a);
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index 74f5dce..49d06c3 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -67,10 +67,16 @@ static int tcf_csum_init(struct net *net, struct nlattr *nla,
 		return -EINVAL;
 	parm = nla_data(tb[TCA_CSUM_PARMS]);
 
+replay:
 	if (!tcf_idr_check(tn, parm->index, a, bind)) {
 		ret = tcf_idr_create(tn, parm->index, est, a,
 				     &act_csum_ops, bind, true);
-		if (ret)
+		/* Action with specified index was created concurrently.
+		 * Check again.
+		 */
+		if (parm->index && ret == -ENOSPC)
+			goto replay;
+		else if (ret)
 			return ret;
 		ret = ACT_P_CREATED;
 	} else {
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index 9d7d000..2edefeb 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -91,10 +91,16 @@ static int tcf_gact_init(struct net *net, struct nlattr *nla,
 	}
 #endif
 
+replay:
 	if (!tcf_idr_check(tn, parm->index, a, bind)) {
 		ret = tcf_idr_create(tn, parm->index, est, a,
 				     &act_gact_ops, bind, true);
-		if (ret)
+		/* Action with specified index was created concurrently.
+		 * Check again.
+		 */
+		if (parm->index && ret == -ENOSPC)
+			goto replay;
+		else if (ret)
 			return ret;
 		ret = ACT_P_CREATED;
 	} else {
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index b57c5ba..665790f 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -483,6 +483,7 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 	if (!p)
 		return -ENOMEM;
 
+replay:
 	exists = tcf_idr_check(tn, parm->index, a, bind);
 	if (exists && bind) {
 		kfree(p);
@@ -492,7 +493,12 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 	if (!exists) {
 		ret = tcf_idr_create(tn, parm->index, est, a, &act_ife_ops,
 				     bind, true);
-		if (ret) {
+		/* Action with specified index was created concurrently.
+		 * Check again.
+		 */
+		if (parm->index && ret == -ENOSPC) {
+			goto replay;
+		} else if (ret) {
 			kfree(p);
 			return ret;
 		}
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 7c26ce1..946193e 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -119,6 +119,7 @@ static int __tcf_ipt_init(struct net *net, unsigned int id, struct nlattr *nla,
 	if (tb[TCA_IPT_INDEX] != NULL)
 		index = nla_get_u32(tb[TCA_IPT_INDEX]);
 
+replay:
 	exists = tcf_idr_check(tn, index, a, bind);
 	if (exists && bind)
 		return 0;
@@ -139,7 +140,12 @@ static int __tcf_ipt_init(struct net *net, unsigned int id, struct nlattr *nla,
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a, ops, bind,
 				     false);
-		if (ret)
+		/* Action with specified index was created concurrently.
+		 * Check again.
+		 */
+		if (index && ret == -ENOSPC)
+			goto replay;
+		else if (ret)
 			return ret;
 		ret = ACT_P_CREATED;
 	} else {
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index b9b7b96..4c8bd26 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -94,6 +94,7 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 	}
 	parm = nla_data(tb[TCA_MIRRED_PARMS]);
 
+replay:
 	exists = tcf_idr_check(tn, parm->index, a, bind);
 	if (exists && bind)
 		return 0;
@@ -129,7 +130,12 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 		}
 		ret = tcf_idr_create(tn, parm->index, est, a,
 				     &act_mirred_ops, bind, true);
-		if (ret)
+		/* Action with specified index was created concurrently.
+		 * Check again.
+		 */
+		if (parm->index && ret == -ENOSPC)
+			goto replay;
+		else if (ret)
 			return ret;
 		ret = ACT_P_CREATED;
 	} else if (!ovr) {
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index 77badb2..a1a1885 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -57,10 +57,16 @@ static int tcf_nat_init(struct net *net, struct nlattr *nla, struct nlattr *est,
 		return -EINVAL;
 	parm = nla_data(tb[TCA_NAT_PARMS]);
 
+replay:
 	if (!tcf_idr_check(tn, parm->index, a, bind)) {
 		ret = tcf_idr_create(tn, parm->index, est, a,
 				     &act_nat_ops, bind, false);
-		if (ret)
+		/* Action with specified index was created concurrently.
+		 * Check again.
+		 */
+		if (parm->index && ret == -ENOSPC)
+			goto replay;
+		else if (ret)
 			return ret;
 		ret = ACT_P_CREATED;
 	} else {
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 8c39adc..e5e93e2 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -167,12 +167,18 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	if (IS_ERR(keys_ex))
 		return PTR_ERR(keys_ex);
 
+replay:
 	if (!tcf_idr_check(tn, parm->index, a, bind)) {
 		if (!parm->nkeys)
 			return -EINVAL;
 		ret = tcf_idr_create(tn, parm->index, est, a,
 				     &act_pedit_ops, bind, false);
-		if (ret)
+		/* Action with specified index was created concurrently.
+		 * Check again.
+		 */
+		if (parm->index && ret == -ENOSPC)
+			goto replay;
+		else if (ret)
 			return ret;
 		p = to_pedit(*a);
 		keys = kmalloc(ksize, GFP_KERNEL);
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index c480d68..ced6b1f 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -101,6 +101,8 @@ static int tcf_act_police_init(struct net *net, struct nlattr *nla,
 		return -EINVAL;
 
 	parm = nla_data(tb[TCA_POLICE_TBF]);
+
+replay:
 	exists = tcf_idr_check(tn, parm->index, a, bind);
 	if (exists && bind)
 		return 0;
@@ -108,7 +110,12 @@ static int tcf_act_police_init(struct net *net, struct nlattr *nla,
 	if (!exists) {
 		ret = tcf_idr_create(tn, parm->index, NULL, a,
 				     &act_police_ops, bind, false);
-		if (ret)
+		/* Action with specified index was created concurrently.
+		 * Check again.
+		 */
+		if (parm->index && ret == -ENOSPC)
+			goto replay;
+		else if (ret)
 			return ret;
 		ret = ACT_P_CREATED;
 	} else if (!ovr) {
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index d2b0394..7411805 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -59,6 +59,7 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 
 	parm = nla_data(tb[TCA_SAMPLE_PARMS]);
 
+replay:
 	exists = tcf_idr_check(tn, parm->index, a, bind);
 	if (exists && bind)
 		return 0;
@@ -66,7 +67,12 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 	if (!exists) {
 		ret = tcf_idr_create(tn, parm->index, est, a,
 				     &act_sample_ops, bind, false);
-		if (ret)
+		/* Action with specified index was created concurrently.
+		 * Check again.
+		 */
+		if (parm->index && ret == -ENOSPC)
+			goto replay;
+		else if (ret)
 			return ret;
 		ret = ACT_P_CREATED;
 	} else if (!ovr) {
diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
index 26eb153..a4b2aca 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -101,6 +101,8 @@ static int tcf_simp_init(struct net *net, struct nlattr *nla,
 		return -EINVAL;
 
 	parm = nla_data(tb[TCA_DEF_PARMS]);
+
+replay:
 	exists = tcf_idr_check(tn, parm->index, a, bind);
 	if (exists && bind)
 		return 0;
@@ -116,7 +118,12 @@ static int tcf_simp_init(struct net *net, struct nlattr *nla,
 	if (!exists) {
 		ret = tcf_idr_create(tn, parm->index, est, a,
 				     &act_simp_ops, bind, false);
-		if (ret)
+		/* Action with specified index was created concurrently.
+		 * Check again.
+		 */
+		if (parm->index && ret == -ENOSPC)
+			goto replay;
+		else if (ret)
 			return ret;
 
 		d = to_defact(*a);
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index bb416b7..7750b77 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -117,6 +117,7 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 
 	parm = nla_data(tb[TCA_SKBEDIT_PARMS]);
 
+replay:
 	exists = tcf_idr_check(tn, parm->index, a, bind);
 	if (exists && bind)
 		return 0;
@@ -129,7 +130,12 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 	if (!exists) {
 		ret = tcf_idr_create(tn, parm->index, est, a,
 				     &act_skbedit_ops, bind, false);
-		if (ret)
+		/* Action with specified index was created concurrently.
+		 * Check again.
+		 */
+		if (parm->index && ret == -ENOSPC)
+			goto replay;
+		else if (ret)
 			return ret;
 
 		d = to_skbedit(*a);
diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index e1c2e1c..bbc5092 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -128,6 +128,7 @@ static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
 	if (parm->flags & SKBMOD_F_SWAPMAC)
 		lflags = SKBMOD_F_SWAPMAC;
 
+replay:
 	exists = tcf_idr_check(tn, parm->index, a, bind);
 	if (exists && bind)
 		return 0;
@@ -138,7 +139,12 @@ static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
 	if (!exists) {
 		ret = tcf_idr_create(tn, parm->index, est, a,
 				     &act_skbmod_ops, bind, true);
-		if (ret)
+		/* Action with specified index was created concurrently.
+		 * Check again.
+		 */
+		if (parm->index && ret == -ENOSPC)
+			goto replay;
+		else if (ret)
 			return ret;
 
 		ret = ACT_P_CREATED;
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index d88c151..4367962 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -99,6 +99,8 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 		return -EINVAL;
 
 	parm = nla_data(tb[TCA_TUNNEL_KEY_PARMS]);
+
+replay:
 	exists = tcf_idr_check(tn, parm->index, a, bind);
 	if (exists && bind)
 		return 0;
@@ -161,7 +163,12 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 	if (!exists) {
 		ret = tcf_idr_create(tn, parm->index, est, a,
 				     &act_tunnel_key_ops, bind, true);
-		if (ret)
+		/* Action with specified index was created concurrently.
+		 * Check again.
+		 */
+		if (parm->index && ret == -ENOSPC)
+			goto replay;
+		else if (ret)
 			return ret;
 
 		ret = ACT_P_CREATED;
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index f747fb6..adc4e6e 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -134,6 +134,8 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 	if (!tb[TCA_VLAN_PARMS])
 		return -EINVAL;
 	parm = nla_data(tb[TCA_VLAN_PARMS]);
+
+replay:
 	exists = tcf_idr_check(tn, parm->index, a, bind);
 	if (exists && bind)
 		return 0;
@@ -181,7 +183,12 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 	if (!exists) {
 		ret = tcf_idr_create(tn, parm->index, est, a,
 				     &act_vlan_ops, bind, true);
-		if (ret)
+		/* Action with specified index was created concurrently.
+		 * Check again.
+		 */
+		if (parm->index && ret == -ENOSPC)
+			goto replay;
+		else if (ret)
 			return ret;
 
 		ret = ACT_P_CREATED;
-- 
2.7.5
