From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 07/12 net-next,v7] cls_flower: don't expose TC actions to drivers anymore
Date: Sat,  2 Feb 2019 12:50:49 +0100
Message-ID: <20190202115054.4880-8-pablo@netfilter.org>
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

Now that drivers have been converted to use the flow action
infrastructure, remove this field from the tc_cls_flower_offload
structure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
v7: rebase on top of net-next.

 include/net/pkt_cls.h  | 1 -
 net/sched/cls_flower.c | 5 -----
 2 files changed, 6 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index bea1b1c3ea9b..cb8be396a11f 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -766,7 +766,6 @@ struct tc_cls_flower_offload {
 	unsigned long cookie;
 	struct flow_rule *rule;
 	struct flow_stats stats;
-	struct tcf_exts *exts;
 	u32 classid;
 };
 
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 8ec85056aa0d..c5d1db3a3db7 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -391,7 +391,6 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 	cls_flower.rule->match.dissector = &f->mask->dissector;
 	cls_flower.rule->match.mask = &f->mask->key;
 	cls_flower.rule->match.key = &f->mkey;
-	cls_flower.exts = &f->exts;
 	cls_flower.classid = f->res.classid;
 
 	err = tc_setup_flow_action(&cls_flower.rule->action, &f->exts);
@@ -425,7 +424,6 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f)
 	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, NULL);
 	cls_flower.command = TC_CLSFLOWER_STATS;
 	cls_flower.cookie = (unsigned long) f;
-	cls_flower.exts = &f->exts;
 	cls_flower.classid = f->res.classid;
 
 	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false);
@@ -1492,7 +1490,6 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, tc_setup_cb_t *cb,
 			cls_flower.rule->match.dissector = &mask->dissector;
 			cls_flower.rule->match.mask = &mask->key;
 			cls_flower.rule->match.key = &f->mkey;
-			cls_flower.exts = &f->exts;
 
 			err = tc_setup_flow_action(&cls_flower.rule->action,
 						   &f->exts);
@@ -1525,7 +1522,6 @@ static int fl_hw_create_tmplt(struct tcf_chain *chain,
 {
 	struct tc_cls_flower_offload cls_flower = {};
 	struct tcf_block *block = chain->block;
-	struct tcf_exts dummy_exts = { 0, };
 
 	cls_flower.rule = flow_rule_alloc(0);
 	if (!cls_flower.rule)
@@ -1537,7 +1533,6 @@ static int fl_hw_create_tmplt(struct tcf_chain *chain,
 	cls_flower.rule->match.dissector = &tmplt->dissector;
 	cls_flower.rule->match.mask = &tmplt->mask;
 	cls_flower.rule->match.key = &tmplt->dummy_key;
-	cls_flower.exts = &dummy_exts;
 
 	/* We don't care if driver (any of them) fails to handle this
 	 * call. It serves just as a hint for it.
-- 
2.11.0
