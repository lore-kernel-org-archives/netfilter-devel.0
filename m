From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 04/12 net-next,v7] cls_api: add translator to flow_action representation
Date: Sat,  2 Feb 2019 12:50:46 +0100
Message-ID: <20190202115054.4880-5-pablo@netfilter.org>
References: <20190202115054.4880-1-pablo@netfilter.org>
Cc: davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        santosh@chelsio.com, madalin.bucur@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com,
        saeedm@mellanox.com, jiri@mellanox.com, idosch@mellanox.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        julia.lawall@lip6.fr, john.fastabend@gmail.com,
        netfilter-devel@vger.kernel.org, cphealy@gmail.co
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190202115054.4880-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch implements a new function to translate from native TC action
to the new flow_action representation. Moreover, this patch also updates
cls_flower to use this new function.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
v7: rebase on top of net-next.

 include/net/pkt_cls.h  |  2 +
 net/sched/cls_api.c    | 99 ++++++++++++++++++++++++++++++++++++++++++++++++++
 net/sched/cls_flower.c | 14 +++++++
 3 files changed, 115 insertions(+)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 74a7582ad47c..c470c100b926 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -620,6 +620,8 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
 }
 #endif /* CONFIG_NET_CLS_IND */
 
+int tc_setup_flow_action(struct flow_action *flow_action,
+			 const struct tcf_exts *exts);
 int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
 		     void *type_data, bool err_stop);
 unsigned int tcf_exts_num_actions(struct tcf_exts *exts);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 57713c63ac56..02cf6d2fa0e1 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -32,6 +32,13 @@
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_pedit.h>
+#include <net/tc_act/tc_mirred.h>
+#include <net/tc_act/tc_vlan.h>
+#include <net/tc_act/tc_tunnel_key.h>
+#include <net/tc_act/tc_csum.h>
+#include <net/tc_act/tc_gact.h>
+#include <net/tc_act/tc_skbedit.h>
+#include <net/tc_act/tc_mirred.h>
 
 extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
 
@@ -2516,6 +2523,98 @@ int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
 }
 EXPORT_SYMBOL(tc_setup_cb_call);
 
+int tc_setup_flow_action(struct flow_action *flow_action,
+			 const struct tcf_exts *exts)
+{
+	const struct tc_action *act;
+	int i, j, k;
+
+	if (!exts)
+		return 0;
+
+	j = 0;
+	tcf_exts_for_each_action(i, act, exts) {
+		struct flow_action_entry *entry;
+
+		entry = &flow_action->entries[j];
+		if (is_tcf_gact_ok(act)) {
+			entry->id = FLOW_ACTION_ACCEPT;
+		} else if (is_tcf_gact_shot(act)) {
+			entry->id = FLOW_ACTION_DROP;
+		} else if (is_tcf_gact_trap(act)) {
+			entry->id = FLOW_ACTION_TRAP;
+		} else if (is_tcf_gact_goto_chain(act)) {
+			entry->id = FLOW_ACTION_GOTO;
+			entry->chain_index = tcf_gact_goto_chain_index(act);
+		} else if (is_tcf_mirred_egress_redirect(act)) {
+			entry->id = FLOW_ACTION_REDIRECT;
+			entry->dev = tcf_mirred_dev(act);
+		} else if (is_tcf_mirred_egress_mirror(act)) {
+			entry->id = FLOW_ACTION_MIRRED;
+			entry->dev = tcf_mirred_dev(act);
+		} else if (is_tcf_vlan(act)) {
+			switch (tcf_vlan_action(act)) {
+			case TCA_VLAN_ACT_PUSH:
+				entry->id = FLOW_ACTION_VLAN_PUSH;
+				entry->vlan.vid = tcf_vlan_push_vid(act);
+				entry->vlan.proto = tcf_vlan_push_proto(act);
+				entry->vlan.prio = tcf_vlan_push_prio(act);
+				break;
+			case TCA_VLAN_ACT_POP:
+				entry->id = FLOW_ACTION_VLAN_POP;
+				break;
+			case TCA_VLAN_ACT_MODIFY:
+				entry->id = FLOW_ACTION_VLAN_MANGLE;
+				entry->vlan.vid = tcf_vlan_push_vid(act);
+				entry->vlan.proto = tcf_vlan_push_proto(act);
+				entry->vlan.prio = tcf_vlan_push_prio(act);
+				break;
+			default:
+				goto err_out;
+			}
+		} else if (is_tcf_tunnel_set(act)) {
+			entry->id = FLOW_ACTION_TUNNEL_ENCAP;
+			entry->tunnel = tcf_tunnel_info(act);
+		} else if (is_tcf_tunnel_release(act)) {
+			entry->id = FLOW_ACTION_TUNNEL_DECAP;
+			entry->tunnel = tcf_tunnel_info(act);
+		} else if (is_tcf_pedit(act)) {
+			for (k = 0; k < tcf_pedit_nkeys(act); k++) {
+				switch (tcf_pedit_cmd(act, k)) {
+				case TCA_PEDIT_KEY_EX_CMD_SET:
+					entry->id = FLOW_ACTION_MANGLE;
+					break;
+				case TCA_PEDIT_KEY_EX_CMD_ADD:
+					entry->id = FLOW_ACTION_ADD;
+					break;
+				default:
+					goto err_out;
+				}
+				entry->mangle.htype = tcf_pedit_htype(act, k);
+				entry->mangle.mask = tcf_pedit_mask(act, k);
+				entry->mangle.val = tcf_pedit_val(act, k);
+				entry->mangle.offset = tcf_pedit_offset(act, k);
+				entry = &flow_action->entries[++j];
+			}
+		} else if (is_tcf_csum(act)) {
+			entry->id = FLOW_ACTION_CSUM;
+			entry->csum_flags = tcf_csum_update_flags(act);
+		} else if (is_tcf_skbedit_mark(act)) {
+			entry->id = FLOW_ACTION_MARK;
+			entry->mark = tcf_skbedit_mark(act);
+		} else {
+			goto err_out;
+		}
+
+		if (!is_tcf_pedit(act))
+			j++;
+	}
+	return 0;
+err_out:
+	return -EOPNOTSUPP;
+}
+EXPORT_SYMBOL(tc_setup_flow_action);
+
 unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
 {
 	unsigned int num_acts = 0;
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 0062c9133a22..48c54ef52a98 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -394,6 +394,12 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 	cls_flower.exts = &f->exts;
 	cls_flower.classid = f->res.classid;
 
+	err = tc_setup_flow_action(&cls_flower.rule->action, &f->exts);
+	if (err) {
+		kfree(cls_flower.rule);
+		return err;
+	}
+
 	err = tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, skip_sw);
 	kfree(cls_flower.rule);
 
@@ -1483,6 +1489,14 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, tc_setup_cb_t *cb,
 			cls_flower.rule->match.mask = &mask->key;
 			cls_flower.rule->match.key = &f->mkey;
 			cls_flower.exts = &f->exts;
+
+			err = tc_setup_flow_action(&cls_flower.rule->action,
+						   &f->exts);
+			if (err) {
+				kfree(cls_flower.rule);
+				return err;
+			}
+
 			cls_flower.classid = f->res.classid;
 
 			err = cb(TC_SETUP_CLSFLOWER, &cls_flower, cb_priv);
-- 
2.11.0
