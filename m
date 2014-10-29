From: Steven Rostedt <rostedt@goodmis.org>
Subject: [RFA][PATCH 4/8] netfilter: Remove checks of seq_printf() return values
Date: Wed, 29 Oct 2014 17:56:06 -0400
Message-ID: <20141029220107.786969515@goodmis.org>
References: <20141029215602.535533597@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Cc: Ingo Molnar <mingo@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Joe Perches <joe@perches.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	<netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>
To: linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:47858 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756039AbaJ2WBO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:01:14 -0400
Content-Disposition: inline; filename=0004-netfilter-Remove-checks-of-seq_printf-return-values.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

[ REQUEST FOR ACKS ]

The return value of seq_printf() is soon to be removed. Remove the
checks from seq_printf() in favor of seq_has_overflowed().

Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   | 36 ++++++-------
 net/netfilter/nf_conntrack_standalone.c            | 60 +++++++++++-----------
 net/netfilter/nf_log.c                             | 30 ++++++-----
 net/netfilter/nfnetlink_queue_core.c               | 13 ++---
 net/netfilter/x_tables.c                           | 19 ++++---
 net/netfilter/xt_hashlimit.c                       | 36 ++++++-------
 6 files changed, 97 insertions(+), 97 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index d927f9e72130..a460a87e14f8 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -94,7 +94,7 @@ static void ct_seq_stop(struct seq_file *s, void *v)
 }
 
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
-static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
+static void ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 {
 	int ret;
 	u32 len;
@@ -102,17 +102,15 @@ static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 
 	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
 	if (ret)
-		return 0;
+		return;
 
-	ret = seq_printf(s, "secctx=%s ", secctx);
+	seq_printf(s, "secctx=%s ", secctx);
 
 	security_release_secctx(secctx, len);
-	return ret;
 }
 #else
-static inline int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
+static inline void ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 {
-	return 0;
 }
 #endif
 
@@ -141,11 +139,10 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	NF_CT_ASSERT(l4proto);
 
 	ret = -ENOSPC;
-	if (seq_printf(s, "%-8s %u %ld ",
-		      l4proto->name, nf_ct_protonum(ct),
-		      timer_pending(&ct->timeout)
-		      ? (long)(ct->timeout.expires - jiffies)/HZ : 0) != 0)
-		goto release;
+	seq_printf(s, "%-8s %u %ld ",
+		   l4proto->name, nf_ct_protonum(ct),
+		   timer_pending(&ct->timeout)
+		   ? (long)(ct->timeout.expires - jiffies)/HZ : 0);
 
 	if (l4proto->print_conntrack)
 		l4proto->print_conntrack(s, ct);
@@ -163,8 +160,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 		goto release;
 
 	if (!(test_bit(IPS_SEEN_REPLY_BIT, &ct->status)))
-		if (seq_printf(s, "[UNREPLIED] "))
-			goto release;
+		seq_printf(s, "[UNREPLIED] ");
 
 	print_tuple(s, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 		    l3proto, l4proto);
@@ -176,19 +172,19 @@ static int ct_seq_show(struct seq_file *s, void *v)
 		goto release;
 
 	if (test_bit(IPS_ASSURED_BIT, &ct->status))
-		if (seq_printf(s, "[ASSURED] "))
-			goto release;
+		seq_printf(s, "[ASSURED] ");
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if (seq_printf(s, "mark=%u ", ct->mark))
-		goto release;
+	seq_printf(s, "mark=%u ", ct->mark);
 #endif
 
-	if (ct_show_secctx(s, ct))
-		goto release;
+	ct_show_secctx(s, ct);
+
+	seq_printf(s, "use=%u\n", atomic_read(&ct->ct_general.use));
 
-	if (seq_printf(s, "use=%u\n", atomic_read(&ct->ct_general.use)))
+	if (seq_has_overflowed(s))
 		goto release;
+
 	ret = 0;
 release:
 	nf_ct_put(ct);
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 23a0dcab21d4..fc823fa5dcf5 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -120,7 +120,7 @@ static void ct_seq_stop(struct seq_file *s, void *v)
 }
 
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
-static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
+static void ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 {
 	int ret;
 	u32 len;
@@ -128,22 +128,20 @@ static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 
 	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
 	if (ret)
-		return 0;
+		return;
 
-	ret = seq_printf(s, "secctx=%s ", secctx);
+	seq_printf(s, "secctx=%s ", secctx);
 
 	security_release_secctx(secctx, len);
-	return ret;
 }
 #else
-static inline int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
+static inline void ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 {
-	return 0;
 }
 #endif
 
 #ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
-static int ct_show_delta_time(struct seq_file *s, const struct nf_conn *ct)
+static void ct_show_delta_time(struct seq_file *s, const struct nf_conn *ct)
 {
 	struct ct_iter_state *st = s->private;
 	struct nf_conn_tstamp *tstamp;
@@ -157,16 +155,15 @@ static int ct_show_delta_time(struct seq_file *s, const struct nf_conn *ct)
 		else
 			delta_time = 0;
 
-		return seq_printf(s, "delta-time=%llu ",
-				  (unsigned long long)delta_time);
+		seq_printf(s, "delta-time=%llu ",
+			   (unsigned long long)delta_time);
 	}
-	return 0;
+	return;
 }
 #else
-static inline int
+static inline void
 ct_show_delta_time(struct seq_file *s, const struct nf_conn *ct)
 {
-	return 0;
 }
 #endif
 
@@ -193,12 +190,11 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	NF_CT_ASSERT(l4proto);
 
 	ret = -ENOSPC;
-	if (seq_printf(s, "%-8s %u %-8s %u %ld ",
-		       l3proto->name, nf_ct_l3num(ct),
-		       l4proto->name, nf_ct_protonum(ct),
-		       timer_pending(&ct->timeout)
-		       ? (long)(ct->timeout.expires - jiffies)/HZ : 0) != 0)
-		goto release;
+	seq_printf(s, "%-8s %u %-8s %u %ld ",
+		   l3proto->name, nf_ct_l3num(ct),
+		   l4proto->name, nf_ct_protonum(ct),
+		   timer_pending(&ct->timeout)
+		   ? (long)(ct->timeout.expires - jiffies)/HZ : 0);
 
 	if (l4proto->print_conntrack)
 		l4proto->print_conntrack(s, ct);
@@ -206,12 +202,14 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	print_tuple(s, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
 		    l3proto, l4proto);
 
+	if (seq_has_overflowed(s))
+		goto release;
+
 	if (seq_print_acct(s, ct, IP_CT_DIR_ORIGINAL))
 		goto release;
 
 	if (!(test_bit(IPS_SEEN_REPLY_BIT, &ct->status)))
-		if (seq_printf(s, "[UNREPLIED] "))
-			goto release;
+		seq_printf(s, "[UNREPLIED] ");
 
 	print_tuple(s, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 		    l3proto, l4proto);
@@ -220,26 +218,26 @@ static int ct_seq_show(struct seq_file *s, void *v)
 		goto release;
 
 	if (test_bit(IPS_ASSURED_BIT, &ct->status))
-		if (seq_printf(s, "[ASSURED] "))
-			goto release;
+		seq_printf(s, "[ASSURED] ");
 
-#if defined(CONFIG_NF_CONNTRACK_MARK)
-	if (seq_printf(s, "mark=%u ", ct->mark))
+	if (seq_has_overflowed(s))
 		goto release;
+
+#if defined(CONFIG_NF_CONNTRACK_MARK)
+	seq_printf(s, "mark=%u ", ct->mark);
 #endif
 
-	if (ct_show_secctx(s, ct))
-		goto release;
+	ct_show_secctx(s, ct);
 
 #ifdef CONFIG_NF_CONNTRACK_ZONES
-	if (seq_printf(s, "zone=%u ", nf_ct_zone(ct)))
-		goto release;
+	seq_printf(s, "zone=%u ", nf_ct_zone(ct));
 #endif
 
-	if (ct_show_delta_time(s, ct))
-		goto release;
+	ct_show_delta_time(s, ct);
+
+	seq_printf(s, "use=%u\n", atomic_read(&ct->ct_general.use));
 
-	if (seq_printf(s, "use=%u\n", atomic_read(&ct->ct_general.use)))
+	if (seq_has_overflowed(s))
 		goto release;
 
 	ret = 0;
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index d7197649dba6..6e3b9117db1f 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -294,19 +294,19 @@ static int seq_show(struct seq_file *s, void *v)
 {
 	loff_t *pos = v;
 	const struct nf_logger *logger;
-	int i, ret;
+	int i;
 	struct net *net = seq_file_net(s);
 
 	logger = rcu_dereference_protected(net->nf.nf_loggers[*pos],
 					   lockdep_is_held(&nf_log_mutex));
 
 	if (!logger)
-		ret = seq_printf(s, "%2lld NONE (", *pos);
+		seq_printf(s, "%2lld NONE (", *pos);
 	else
-		ret = seq_printf(s, "%2lld %s (", *pos, logger->name);
+		seq_printf(s, "%2lld %s (", *pos, logger->name);
 
-	if (ret < 0)
-		return ret;
+	if (seq_has_overflowed(s))
+		return -ENOSPC;
 
 	for (i = 0; i < NF_LOG_TYPE_MAX; i++) {
 		if (loggers[*pos][i] == NULL)
@@ -314,17 +314,19 @@ static int seq_show(struct seq_file *s, void *v)
 
 		logger = rcu_dereference_protected(loggers[*pos][i],
 					   lockdep_is_held(&nf_log_mutex));
-		ret = seq_printf(s, "%s", logger->name);
-		if (ret < 0)
-			return ret;
-		if (i == 0 && loggers[*pos][i + 1] != NULL) {
-			ret = seq_printf(s, ",");
-			if (ret < 0)
-				return ret;
-		}
+		seq_printf(s, "%s", logger->name);
+		if (i == 0 && loggers[*pos][i + 1] != NULL)
+			seq_printf(s, ",");
+
+		if (seq_has_overflowed(s))
+			return -ENOSPC;
 	}
 
-	return seq_printf(s, ")\n");
+	seq_printf(s, ")\n");
+
+	if (seq_has_overflowed(s))
+		return -ENOSPC;
+	return 0;
 }
 
 static const struct seq_operations nflog_seq_ops = {
diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
index a82077d9f59b..f823f1538c4f 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -1242,12 +1242,13 @@ static int seq_show(struct seq_file *s, void *v)
 {
 	const struct nfqnl_instance *inst = v;
 
-	return seq_printf(s, "%5d %6d %5d %1d %5d %5d %5d %8d %2d\n",
-			  inst->queue_num,
-			  inst->peer_portid, inst->queue_total,
-			  inst->copy_mode, inst->copy_range,
-			  inst->queue_dropped, inst->queue_user_dropped,
-			  inst->id_sequence, 1);
+	seq_printf(s, "%5d %6d %5d %1d %5d %5d %5d %8d %2d\n",
+		   inst->queue_num,
+		   inst->peer_portid, inst->queue_total,
+		   inst->copy_mode, inst->copy_range,
+		   inst->queue_dropped, inst->queue_user_dropped,
+		   inst->id_sequence, 1);
+	return seq_has_overflowed(s);
 }
 
 static const struct seq_operations nfqnl_seq_ops = {
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 133eb4772f12..51a459c3c649 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -947,9 +947,10 @@ static int xt_table_seq_show(struct seq_file *seq, void *v)
 {
 	struct xt_table *table = list_entry(v, struct xt_table, list);
 
-	if (strlen(table->name))
-		return seq_printf(seq, "%s\n", table->name);
-	else
+	if (strlen(table->name)) {
+		seq_printf(seq, "%s\n", table->name);
+		return seq_has_overflowed(seq);
+	} else
 		return 0;
 }
 
@@ -1086,8 +1087,10 @@ static int xt_match_seq_show(struct seq_file *seq, void *v)
 		if (trav->curr == trav->head)
 			return 0;
 		match = list_entry(trav->curr, struct xt_match, list);
-		return (*match->name == '\0') ? 0 :
-		       seq_printf(seq, "%s\n", match->name);
+		if (*match->name == '\0')
+			return 0;
+		seq_printf(seq, "%s\n", match->name);
+		return seq_has_overflowed(seq);
 	}
 	return 0;
 }
@@ -1139,8 +1142,10 @@ static int xt_target_seq_show(struct seq_file *seq, void *v)
 		if (trav->curr == trav->head)
 			return 0;
 		target = list_entry(trav->curr, struct xt_target, list);
-		return (*target->name == '\0') ? 0 :
-		       seq_printf(seq, "%s\n", target->name);
+		if (*target->name == '\0')
+			return 0;
+		seq_printf(seq, "%s\n", target->name);
+		return seq_has_overflowed(seq);
 	}
 	return 0;
 }
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 05fbc2a0be46..178696852bde 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -789,7 +789,6 @@ static void dl_seq_stop(struct seq_file *s, void *v)
 static int dl_seq_real_show(struct dsthash_ent *ent, u_int8_t family,
 				   struct seq_file *s)
 {
-	int res;
 	const struct xt_hashlimit_htable *ht = s->private;
 
 	spin_lock(&ent->lock);
@@ -798,33 +797,32 @@ static int dl_seq_real_show(struct dsthash_ent *ent, u_int8_t family,
 
 	switch (family) {
 	case NFPROTO_IPV4:
-		res = seq_printf(s, "%ld %pI4:%u->%pI4:%u %u %u %u\n",
-				 (long)(ent->expires - jiffies)/HZ,
-				 &ent->dst.ip.src,
-				 ntohs(ent->dst.src_port),
-				 &ent->dst.ip.dst,
-				 ntohs(ent->dst.dst_port),
-				 ent->rateinfo.credit, ent->rateinfo.credit_cap,
-				 ent->rateinfo.cost);
+		seq_printf(s, "%ld %pI4:%u->%pI4:%u %u %u %u\n",
+			   (long)(ent->expires - jiffies)/HZ,
+			   &ent->dst.ip.src,
+			   ntohs(ent->dst.src_port),
+			   &ent->dst.ip.dst,
+			   ntohs(ent->dst.dst_port),
+			   ent->rateinfo.credit, ent->rateinfo.credit_cap,
+			   ent->rateinfo.cost);
 		break;
 #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 	case NFPROTO_IPV6:
-		res = seq_printf(s, "%ld %pI6:%u->%pI6:%u %u %u %u\n",
-				 (long)(ent->expires - jiffies)/HZ,
-				 &ent->dst.ip6.src,
-				 ntohs(ent->dst.src_port),
-				 &ent->dst.ip6.dst,
-				 ntohs(ent->dst.dst_port),
-				 ent->rateinfo.credit, ent->rateinfo.credit_cap,
-				 ent->rateinfo.cost);
+		seq_printf(s, "%ld %pI6:%u->%pI6:%u %u %u %u\n",
+			   (long)(ent->expires - jiffies)/HZ,
+			   &ent->dst.ip6.src,
+			   ntohs(ent->dst.src_port),
+			   &ent->dst.ip6.dst,
+			   ntohs(ent->dst.dst_port),
+			   ent->rateinfo.credit, ent->rateinfo.credit_cap,
+			   ent->rateinfo.cost);
 		break;
 #endif
 	default:
 		BUG();
-		res = 0;
 	}
 	spin_unlock(&ent->lock);
-	return res;
+	return seq_has_overflowed(s);
 }
 
 static int dl_seq_show(struct seq_file *s, void *v)
-- 
2.1.1


