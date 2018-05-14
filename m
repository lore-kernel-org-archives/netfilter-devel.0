From: Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH 11/14] net: core: add new/replace rate estimator lock parameter
Date: Mon, 14 May 2018 17:27:12 +0300
Message-ID: <1526308035-12484-12-git-send-email-vladbu@mellanox.com>
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

Extend rate estimator new and replace APIs with additional spinlock
parameter used by lockless actions to protect rate_est pointer from
concurrent modification.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 include/net/gen_stats.h    |  2 ++
 net/core/gen_estimator.c   | 58 +++++++++++++++++++++++++++++++++++-----------
 net/netfilter/xt_RATEEST.c |  2 +-
 net/sched/act_api.c        |  2 +-
 net/sched/act_police.c     |  2 +-
 net/sched/sch_api.c        |  2 ++
 net/sched/sch_cbq.c        |  4 ++--
 net/sched/sch_drr.c        |  4 ++--
 net/sched/sch_hfsc.c       |  4 ++--
 net/sched/sch_htb.c        |  4 ++--
 net/sched/sch_qfq.c        |  4 ++--
 11 files changed, 61 insertions(+), 27 deletions(-)

diff --git a/include/net/gen_stats.h b/include/net/gen_stats.h
index 0304ba2..d1ef63d 100644
--- a/include/net/gen_stats.h
+++ b/include/net/gen_stats.h
@@ -59,12 +59,14 @@ int gnet_stats_finish_copy(struct gnet_dump *d);
 int gen_new_estimator(struct gnet_stats_basic_packed *bstats,
 		      struct gnet_stats_basic_cpu __percpu *cpu_bstats,
 		      struct net_rate_estimator __rcu **rate_est,
+		      spinlock_t *rate_est_lock,
 		      spinlock_t *stats_lock,
 		      seqcount_t *running, struct nlattr *opt);
 void gen_kill_estimator(struct net_rate_estimator __rcu **ptr);
 int gen_replace_estimator(struct gnet_stats_basic_packed *bstats,
 			  struct gnet_stats_basic_cpu __percpu *cpu_bstats,
 			  struct net_rate_estimator __rcu **ptr,
+			  spinlock_t *rate_est_lock,
 			  spinlock_t *stats_lock,
 			  seqcount_t *running, struct nlattr *opt);
 bool gen_estimator_active(struct net_rate_estimator __rcu **ptr);
diff --git a/net/core/gen_estimator.c b/net/core/gen_estimator.c
index 98fd127..3512720 100644
--- a/net/core/gen_estimator.c
+++ b/net/core/gen_estimator.c
@@ -107,11 +107,43 @@ static void est_timer(struct timer_list *t)
 	mod_timer(&est->timer, est->next_jiffies);
 }
 
+static void __replace_estimator(struct net_rate_estimator __rcu **rate_est,
+				struct net_rate_estimator *new)
+{
+	struct net_rate_estimator *old = rcu_dereference_protected(*rate_est,
+								   1);
+
+	if (old) {
+		del_timer_sync(&old->timer);
+		new->avbps = old->avbps;
+		new->avpps = old->avpps;
+	}
+
+	new->next_jiffies = jiffies + ((HZ/4) << new->intvl_log);
+	timer_setup(&new->timer, est_timer, 0);
+	mod_timer(&new->timer, new->next_jiffies);
+
+	rcu_assign_pointer(*rate_est, new);
+
+	if (old)
+		kfree_rcu(old, rcu);
+}
+
+static void replace_estimator(struct net_rate_estimator __rcu **rate_est,
+			      struct net_rate_estimator *new,
+			      spinlock_t *rate_est_lock)
+{
+	spin_lock(rate_est_lock);
+	__replace_estimator(rate_est, new);
+	spin_unlock(rate_est_lock);
+}
+
 /**
  * gen_new_estimator - create a new rate estimator
  * @bstats: basic statistics
  * @cpu_bstats: bstats per cpu
  * @rate_est: rate estimator statistics
+ * @rate_est_lock: rate_est lock (might be NULL)
  * @stats_lock: statistics lock
  * @running: qdisc running seqcount
  * @opt: rate estimator configuration TLV
@@ -128,12 +160,13 @@ static void est_timer(struct timer_list *t)
 int gen_new_estimator(struct gnet_stats_basic_packed *bstats,
 		      struct gnet_stats_basic_cpu __percpu *cpu_bstats,
 		      struct net_rate_estimator __rcu **rate_est,
+		      spinlock_t *rate_est_lock,
 		      spinlock_t *stats_lock,
 		      seqcount_t *running,
 		      struct nlattr *opt)
 {
 	struct gnet_estimator *parm = nla_data(opt);
-	struct net_rate_estimator *old, *est;
+	struct net_rate_estimator *est;
 	struct gnet_stats_basic_packed b;
 	int intvl_log;
 
@@ -167,20 +200,15 @@ int gen_new_estimator(struct gnet_stats_basic_packed *bstats,
 		local_bh_enable();
 	est->last_bytes = b.bytes;
 	est->last_packets = b.packets;
-	old = rcu_dereference_protected(*rate_est, 1);
-	if (old) {
-		del_timer_sync(&old->timer);
-		est->avbps = old->avbps;
-		est->avpps = old->avpps;
-	}
 
-	est->next_jiffies = jiffies + ((HZ/4) << intvl_log);
-	timer_setup(&est->timer, est_timer, 0);
-	mod_timer(&est->timer, est->next_jiffies);
+	if (rate_est_lock)
+		replace_estimator(rate_est, est, rate_est_lock);
+	else
+		/* If no spinlock argument provided,
+		 * then assume that caller is already synchronized.
+		 */
+		__replace_estimator(rate_est, est);
 
-	rcu_assign_pointer(*rate_est, est);
-	if (old)
-		kfree_rcu(old, rcu);
 	return 0;
 }
 EXPORT_SYMBOL(gen_new_estimator);
@@ -209,6 +237,7 @@ EXPORT_SYMBOL(gen_kill_estimator);
  * @bstats: basic statistics
  * @cpu_bstats: bstats per cpu
  * @rate_est: rate estimator statistics
+ * @rate_est_lock: rate_est lock (might be NULL)
  * @stats_lock: statistics lock
  * @running: qdisc running seqcount (might be NULL)
  * @opt: rate estimator configuration TLV
@@ -221,10 +250,11 @@ EXPORT_SYMBOL(gen_kill_estimator);
 int gen_replace_estimator(struct gnet_stats_basic_packed *bstats,
 			  struct gnet_stats_basic_cpu __percpu *cpu_bstats,
 			  struct net_rate_estimator __rcu **rate_est,
+			  spinlock_t *rate_est_lock,
 			  spinlock_t *stats_lock,
 			  seqcount_t *running, struct nlattr *opt)
 {
-	return gen_new_estimator(bstats, cpu_bstats, rate_est,
+	return gen_new_estimator(bstats, cpu_bstats, rate_est, rate_est_lock,
 				 stats_lock, running, opt);
 }
 EXPORT_SYMBOL(gen_replace_estimator);
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index dec843c..8e79bd5 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -154,7 +154,7 @@ static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 	cfg.est.interval	= info->interval;
 	cfg.est.ewma_log	= info->ewma_log;
 
-	ret = gen_new_estimator(&est->bstats, NULL, &est->rate_est,
+	ret = gen_new_estimator(&est->bstats, NULL, &est->rate_est, NULL,
 				&est->lock, NULL, &cfg.opt);
 	if (ret < 0)
 		goto err2;
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index a5193dc..1dc092e 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -409,7 +409,7 @@ int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
 	p->tcfa_tm.firstuse = 0;
 	if (est) {
 		err = gen_new_estimator(&p->tcfa_bstats, p->cpu_bstats,
-					&p->tcfa_rate_est,
+					&p->tcfa_rate_est, NULL,
 					&p->tcfa_lock, NULL, est);
 		if (err)
 			goto err4;
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 86d9417..c480d68 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -133,7 +133,7 @@ static int tcf_act_police_init(struct net *net, struct nlattr *nla,
 
 	if (est) {
 		err = gen_replace_estimator(&police->tcf_bstats, NULL,
-					    &police->tcf_rate_est,
+					    &police->tcf_rate_est, NULL,
 					    &police->tcf_lock,
 					    NULL, est);
 		if (err)
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 106dae7e..de6a297 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1178,6 +1178,7 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 					sch->cpu_bstats,
 					&sch->rate_est,
 					NULL,
+					NULL,
 					running,
 					tca[TCA_RATE]);
 		if (err) {
@@ -1253,6 +1254,7 @@ static int qdisc_change(struct Qdisc *sch, struct nlattr **tca,
 				      sch->cpu_bstats,
 				      &sch->rate_est,
 				      NULL,
+				      NULL,
 				      qdisc_root_sleeping_running(sch),
 				      tca[TCA_RATE]);
 	}
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index f42025d..2a7ff53 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -1503,7 +1503,7 @@ cbq_change_class(struct Qdisc *sch, u32 classid, u32 parentid, struct nlattr **t
 
 		if (tca[TCA_RATE]) {
 			err = gen_replace_estimator(&cl->bstats, NULL,
-						    &cl->rate_est,
+						    &cl->rate_est, NULL,
 						    NULL,
 						    qdisc_root_sleeping_running(sch),
 						    tca[TCA_RATE]);
@@ -1605,7 +1605,7 @@ cbq_change_class(struct Qdisc *sch, u32 classid, u32 parentid, struct nlattr **t
 
 	if (tca[TCA_RATE]) {
 		err = gen_new_estimator(&cl->bstats, NULL, &cl->rate_est,
-					NULL,
+					NULL, NULL,
 					qdisc_root_sleeping_running(sch),
 					tca[TCA_RATE]);
 		if (err) {
diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index e0b0cf8..0896e23 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -95,7 +95,7 @@ static int drr_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	if (cl != NULL) {
 		if (tca[TCA_RATE]) {
 			err = gen_replace_estimator(&cl->bstats, NULL,
-						    &cl->rate_est,
+						    &cl->rate_est, NULL,
 						    NULL,
 						    qdisc_root_sleeping_running(sch),
 						    tca[TCA_RATE]);
@@ -129,7 +129,7 @@ static int drr_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 
 	if (tca[TCA_RATE]) {
 		err = gen_replace_estimator(&cl->bstats, NULL, &cl->rate_est,
-					    NULL,
+					    NULL, NULL,
 					    qdisc_root_sleeping_running(sch),
 					    tca[TCA_RATE]);
 		if (err) {
diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index 3ae9877..f341324 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -972,7 +972,7 @@ hfsc_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 
 		if (tca[TCA_RATE]) {
 			err = gen_replace_estimator(&cl->bstats, NULL,
-						    &cl->rate_est,
+						    &cl->rate_est, NULL,
 						    NULL,
 						    qdisc_root_sleeping_running(sch),
 						    tca[TCA_RATE]);
@@ -1042,7 +1042,7 @@ hfsc_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 
 	if (tca[TCA_RATE]) {
 		err = gen_new_estimator(&cl->bstats, NULL, &cl->rate_est,
-					NULL,
+					NULL, NULL,
 					qdisc_root_sleeping_running(sch),
 					tca[TCA_RATE]);
 		if (err) {
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 2a4ab7c..acc0355 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1407,7 +1407,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 		if (htb_rate_est || tca[TCA_RATE]) {
 			err = gen_new_estimator(&cl->bstats, NULL,
 						&cl->rate_est,
-						NULL,
+						NULL, NULL,
 						qdisc_root_sleeping_running(sch),
 						tca[TCA_RATE] ? : &est.nla);
 			if (err) {
@@ -1473,7 +1473,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 	} else {
 		if (tca[TCA_RATE]) {
 			err = gen_replace_estimator(&cl->bstats, NULL,
-						    &cl->rate_est,
+						    &cl->rate_est, NULL,
 						    NULL,
 						    qdisc_root_sleeping_running(sch),
 						    tca[TCA_RATE]);
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index bb1a9c1..8026c1e 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -461,7 +461,7 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	if (cl != NULL) { /* modify existing class */
 		if (tca[TCA_RATE]) {
 			err = gen_replace_estimator(&cl->bstats, NULL,
-						    &cl->rate_est,
+						    &cl->rate_est, NULL,
 						    NULL,
 						    qdisc_root_sleeping_running(sch),
 						    tca[TCA_RATE]);
@@ -488,7 +488,7 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	if (tca[TCA_RATE]) {
 		err = gen_new_estimator(&cl->bstats, NULL,
 					&cl->rate_est,
-					NULL,
+					NULL, NULL,
 					qdisc_root_sleeping_running(sch),
 					tca[TCA_RATE]);
 		if (err)
-- 
2.7.5
