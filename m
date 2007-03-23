From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/12]: Use setup_timer
Date: Fri, 23 Mar 2007 15:05:11 +0100 (MET)
Message-ID: <20070323140445.22987.86992.sendpatchset@localhost.localdomain>
References: <20070323140433.22987.44867.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070323140433.22987.44867.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: Use setup_timer

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c003010c98cdb0867aa4a5d188063a70af356f01
tree fb21e7a5a104f13e9d19732ae2bbbd9e9952a822
parent 6f67806947ea58fd8bdf2b44dd748bb3fb8752d7
author Patrick McHardy <kaber@trash.net> Thu, 22 Mar 2007 23:03:06 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 23 Mar 2007 11:00:23 +0100

 net/bridge/netfilter/ebt_ulog.c         |    4 +---
 net/ipv4/netfilter/ipt_ULOG.c           |    7 ++-----
 net/ipv6/netfilter/nf_conntrack_reasm.c |    7 ++-----
 net/netfilter/nf_conntrack_core.c       |    5 ++---
 net/netfilter/nf_conntrack_expect.c     |    4 +---
 net/netfilter/nfnetlink_log.c           |    5 +----
 net/netfilter/xt_hashlimit.c            |    4 +---
 7 files changed, 10 insertions(+), 26 deletions(-)

diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 259f5c3..8b84cd4 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -297,9 +297,7 @@ static int __init ebt_ulog_init(void)
 
 	/* initialize ulog_buffers */
 	for (i = 0; i < EBT_ULOG_MAXNLGROUPS; i++) {
-		init_timer(&ulog_buffers[i].timer);
-		ulog_buffers[i].timer.function = ulog_timer;
-		ulog_buffers[i].timer.data = i;
+		setup_timer(&ulog_buffers[i].timer, ulog_timer, i);
 		spin_lock_init(&ulog_buffers[i].lock);
 	}
 
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index e530935..a36bf24 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -375,11 +375,8 @@ static int __init ipt_ulog_init(void)
 	}
 
 	/* initialize ulog_buffers */
-	for (i = 0; i < ULOG_MAXNLGROUPS; i++) {
-		init_timer(&ulog_buffers[i].timer);
-		ulog_buffers[i].timer.function = ulog_timer;
-		ulog_buffers[i].timer.data = i;
-	}
+	for (i = 0; i < ULOG_MAXNLGROUPS; i++)
+		setup_timer(&ulog_buffers[i].timer, ulog_timer, i);
 
 	nflognl = netlink_kernel_create(NETLINK_NFLOG, ULOG_MAXNLGROUPS, NULL,
 					THIS_MODULE);
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 721f02d..347ab76 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -353,9 +353,7 @@ nf_ct_frag6_create(unsigned int hash, __be32 id, struct in6_addr *src,				   str
 	ipv6_addr_copy(&fq->saddr, src);
 	ipv6_addr_copy(&fq->daddr, dst);
 
-	init_timer(&fq->timer);
-	fq->timer.function = nf_ct_frag6_expire;
-	fq->timer.data = (long) fq;
+	setup_timer(&fq->timer, nf_ct_frag6_expire, (unsigned long)fq);
 	spin_lock_init(&fq->lock);
 	atomic_set(&fq->refcnt, 1);
 
@@ -870,8 +868,7 @@ int nf_ct_frag6_init(void)
 	nf_ct_frag6_hash_rnd = (u32) ((num_physpages ^ (num_physpages>>7)) ^
 				   (jiffies ^ (jiffies >> 6)));
 
-	init_timer(&nf_ct_frag6_secret_timer);
-	nf_ct_frag6_secret_timer.function = nf_ct_frag6_secret_rebuild;
+	setup_timer(&nf_ct_frag6_secret_timer, nf_ct_frag6_secret_rebuild, 0);
 	nf_ct_frag6_secret_timer.expires = jiffies
 					   + nf_ct_frag6_secret_interval;
 	add_timer(&nf_ct_frag6_secret_timer);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index a74b205..6f2aac1 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -620,9 +620,8 @@ __nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
 	conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple = *orig;
 	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = *repl;
 	/* Don't set timer yet: wait for confirmation */
-	init_timer(&conntrack->timeout);
-	conntrack->timeout.data = (unsigned long)conntrack;
-	conntrack->timeout.function = death_by_timeout;
+	setup_timer(&conntrack->timeout, death_by_timeout,
+		    (unsigned long)conntrack);
 	read_unlock_bh(&nf_ct_cache_lock);
 
 	return conntrack;
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index ce70a6f..c31af29 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -290,9 +290,7 @@ static void nf_conntrack_expect_insert(struct nf_conntrack_expect *exp)
 	master_help->expecting++;
 	list_add(&exp->list, &nf_conntrack_expect_list);
 
-	init_timer(&exp->timeout);
-	exp->timeout.data = (unsigned long)exp;
-	exp->timeout.function = expectation_timed_out;
+	setup_timer(&exp->timeout, expectation_timed_out, (unsigned long)exp);
 	exp->timeout.expires = jiffies + master_help->helper->timeout * HZ;
 	add_timer(&exp->timeout);
 
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 0ae0656..d2c6aab 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -158,10 +158,7 @@ instance_create(u_int16_t group_num, int pid)
 	/* needs to be two, since we _put() after creation */
 	atomic_set(&inst->use, 2);
 
-	init_timer(&inst->timer);
-	inst->timer.function = nfulnl_timer;
-	inst->timer.data = (unsigned long)inst;
-	/* don't start timer yet. (re)start it  with every packet */
+	setup_timer(&inst->timer, nfulnl_timer, (unsigned long)inst);
 
 	inst->peer_pid = pid;
 	inst->group_num = group_num;
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index eb93291..d3043fa 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -216,10 +216,8 @@ static int htable_create(struct xt_hashlimit_info *minfo, int family)
 	hinfo->pde->proc_fops = &dl_file_ops;
 	hinfo->pde->data = hinfo;
 
-	init_timer(&hinfo->timer);
+	setup_timer(&hinfo->timer, htable_gc, (unsigned long )hinfo);
 	hinfo->timer.expires = jiffies + msecs_to_jiffies(hinfo->cfg.gc_interval);
-	hinfo->timer.data = (unsigned long )hinfo;
-	hinfo->timer.function = htable_gc;
 	add_timer(&hinfo->timer);
 
 	spin_lock_bh(&hashlimit_lock);
