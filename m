Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B7BC31E5B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 20:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BE4221479
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 20:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730350AbfFRUIF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 16:08:05 -0400
Received: from ja.ssi.bg ([178.16.129.10]:49866 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729331AbfFRUIF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 16:08:05 -0400
Received: from ja.home.ssi.bg (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x5IK7p04007573;
        Tue, 18 Jun 2019 23:07:51 +0300
Received: (from root@localhost)
        by ja.home.ssi.bg (8.15.2/8.15.2/Submit) id x5IK7nNT007572;
        Tue, 18 Jun 2019 23:07:49 +0300
From:   Julian Anastasov <ja@ssi.bg>
To:     Simon Horman <horms@verge.net.au>
Cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: [PATCH net] ipvs: fix tinfo memory leak in start_sync_thread
Date:   Tue, 18 Jun 2019 23:07:36 +0300
Message-Id: <20190618200736.7531-1-ja@ssi.bg>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzkaller reports for memory leak in start_sync_thread [1]

As Eric points out, kthread may start and stop before the
threadfn function is called, so there is no chance the
data (tinfo in our case) to be released in thread.

Fix this by releasing tinfo in the controlling code instead.

[1]
BUG: memory leak
unreferenced object 0xffff8881206bf700 (size 32):
 comm "syz-executor761", pid 7268, jiffies 4294943441 (age 20.470s)
 hex dump (first 32 bytes):
   00 40 7c 09 81 88 ff ff 80 45 b8 21 81 88 ff ff  .@|......E.!....
   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 backtrace:
   [<0000000057619e23>] kmemleak_alloc_recursive include/linux/kmemleak.h:55 [inline]
   [<0000000057619e23>] slab_post_alloc_hook mm/slab.h:439 [inline]
   [<0000000057619e23>] slab_alloc mm/slab.c:3326 [inline]
   [<0000000057619e23>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
   [<0000000086ce5479>] kmalloc include/linux/slab.h:547 [inline]
   [<0000000086ce5479>] start_sync_thread+0x5d2/0xe10 net/netfilter/ipvs/ip_vs_sync.c:1862
   [<000000001a9229cc>] do_ip_vs_set_ctl+0x4c5/0x780 net/netfilter/ipvs/ip_vs_ctl.c:2402
   [<00000000ece457c8>] nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
   [<00000000ece457c8>] nf_setsockopt+0x4c/0x80 net/netfilter/nf_sockopt.c:115
   [<00000000942f62d4>] ip_setsockopt net/ipv4/ip_sockglue.c:1258 [inline]
   [<00000000942f62d4>] ip_setsockopt+0x9b/0xb0 net/ipv4/ip_sockglue.c:1238
   [<00000000a56a8ffd>] udp_setsockopt+0x4e/0x90 net/ipv4/udp.c:2616
   [<00000000fa895401>] sock_common_setsockopt+0x38/0x50 net/core/sock.c:3130
   [<0000000095eef4cf>] __sys_setsockopt+0x98/0x120 net/socket.c:2078
   [<000000009747cf88>] __do_sys_setsockopt net/socket.c:2089 [inline]
   [<000000009747cf88>] __se_sys_setsockopt net/socket.c:2086 [inline]
   [<000000009747cf88>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2086
   [<00000000ded8ba80>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:301
   [<00000000893b4ac8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported-by: syzbot+7e2e50c8adfccd2e5041@syzkaller.appspotmail.com
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Fixes: 998e7a76804b ("ipvs: Use kthread_run() instead of doing a double-fork via kernel_thread()")
Signed-off-by: Julian Anastasov <ja@ssi.bg>
---
 include/net/ip_vs.h             |   6 +-
 net/netfilter/ipvs/ip_vs_ctl.c  |   4 -
 net/netfilter/ipvs/ip_vs_sync.c | 134 +++++++++++++++++---------------
 3 files changed, 76 insertions(+), 68 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 2ac40135b576..b36a1df93e7c 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -808,11 +808,12 @@ struct ipvs_master_sync_state {
 	struct ip_vs_sync_buff	*sync_buff;
 	unsigned long		sync_queue_len;
 	unsigned int		sync_queue_delay;
-	struct task_struct	*master_thread;
 	struct delayed_work	master_wakeup_work;
 	struct netns_ipvs	*ipvs;
 };
 
+struct ip_vs_sync_thread_data;
+
 /* How much time to keep dests in trash */
 #define IP_VS_DEST_TRASH_PERIOD		(120 * HZ)
 
@@ -943,7 +944,8 @@ struct netns_ipvs {
 	spinlock_t		sync_lock;
 	struct ipvs_master_sync_state *ms;
 	spinlock_t		sync_buff_lock;
-	struct task_struct	**backup_threads;
+	struct ip_vs_sync_thread_data *master_tinfo;
+	struct ip_vs_sync_thread_data *backup_tinfo;
 	int			threads_mask;
 	volatile int		sync_state;
 	struct mutex		sync_mutex;
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 0e887159425c..bf0cffba9cd8 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2401,9 +2401,7 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 			cfg.syncid = dm->syncid;
 			ret = start_sync_thread(ipvs, &cfg, dm->state);
 		} else {
-			mutex_lock(&ipvs->sync_mutex);
 			ret = stop_sync_thread(ipvs, dm->state);
-			mutex_unlock(&ipvs->sync_mutex);
 		}
 		goto out_dec;
 	}
@@ -3520,10 +3518,8 @@ static int ip_vs_genl_del_daemon(struct netns_ipvs *ipvs, struct nlattr **attrs)
 	if (!attrs[IPVS_DAEMON_ATTR_STATE])
 		return -EINVAL;
 
-	mutex_lock(&ipvs->sync_mutex);
 	ret = stop_sync_thread(ipvs,
 			       nla_get_u32(attrs[IPVS_DAEMON_ATTR_STATE]));
-	mutex_unlock(&ipvs->sync_mutex);
 	return ret;
 }
 
diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 2526be6b3d90..a4a78c4b06de 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -195,6 +195,7 @@ union ip_vs_sync_conn {
 #define IPVS_OPT_F_PARAM	(1 << (IPVS_OPT_PARAM-1))
 
 struct ip_vs_sync_thread_data {
+	struct task_struct *task;
 	struct netns_ipvs *ipvs;
 	struct socket *sock;
 	char *buf;
@@ -374,8 +375,11 @@ static inline void sb_queue_tail(struct netns_ipvs *ipvs,
 					      max(IPVS_SYNC_SEND_DELAY, 1));
 		ms->sync_queue_len++;
 		list_add_tail(&sb->list, &ms->sync_queue);
-		if ((++ms->sync_queue_delay) == IPVS_SYNC_WAKEUP_RATE)
-			wake_up_process(ms->master_thread);
+		if ((++ms->sync_queue_delay) == IPVS_SYNC_WAKEUP_RATE) {
+			int id = (int)(ms - ipvs->ms);
+
+			wake_up_process(ipvs->master_tinfo[id].task);
+		}
 	} else
 		ip_vs_sync_buff_release(sb);
 	spin_unlock(&ipvs->sync_lock);
@@ -1636,8 +1640,10 @@ static void master_wakeup_work_handler(struct work_struct *work)
 	spin_lock_bh(&ipvs->sync_lock);
 	if (ms->sync_queue_len &&
 	    ms->sync_queue_delay < IPVS_SYNC_WAKEUP_RATE) {
+		int id = (int)(ms - ipvs->ms);
+
 		ms->sync_queue_delay = IPVS_SYNC_WAKEUP_RATE;
-		wake_up_process(ms->master_thread);
+		wake_up_process(ipvs->master_tinfo[id].task);
 	}
 	spin_unlock_bh(&ipvs->sync_lock);
 }
@@ -1703,10 +1709,6 @@ static int sync_thread_master(void *data)
 	if (sb)
 		ip_vs_sync_buff_release(sb);
 
-	/* release the sending multicast socket */
-	sock_release(tinfo->sock);
-	kfree(tinfo);
-
 	return 0;
 }
 
@@ -1740,11 +1742,6 @@ static int sync_thread_backup(void *data)
 		}
 	}
 
-	/* release the sending multicast socket */
-	sock_release(tinfo->sock);
-	kfree(tinfo->buf);
-	kfree(tinfo);
-
 	return 0;
 }
 
@@ -1752,8 +1749,8 @@ static int sync_thread_backup(void *data)
 int start_sync_thread(struct netns_ipvs *ipvs, struct ipvs_sync_daemon_cfg *c,
 		      int state)
 {
-	struct ip_vs_sync_thread_data *tinfo = NULL;
-	struct task_struct **array = NULL, *task;
+	struct ip_vs_sync_thread_data *ti = NULL, *tinfo;
+	struct task_struct *task;
 	struct net_device *dev;
 	char *name;
 	int (*threadfn)(void *data);
@@ -1822,7 +1819,7 @@ int start_sync_thread(struct netns_ipvs *ipvs, struct ipvs_sync_daemon_cfg *c,
 		threadfn = sync_thread_master;
 	} else if (state == IP_VS_STATE_BACKUP) {
 		result = -EEXIST;
-		if (ipvs->backup_threads)
+		if (ipvs->backup_tinfo)
 			goto out_early;
 
 		ipvs->bcfg = *c;
@@ -1849,28 +1846,22 @@ int start_sync_thread(struct netns_ipvs *ipvs, struct ipvs_sync_daemon_cfg *c,
 					  master_wakeup_work_handler);
 			ms->ipvs = ipvs;
 		}
-	} else {
-		array = kcalloc(count, sizeof(struct task_struct *),
-				GFP_KERNEL);
-		result = -ENOMEM;
-		if (!array)
-			goto out;
 	}
+	result = -ENOMEM;
+	ti = kcalloc(count, sizeof(struct ip_vs_sync_thread_data),
+		     GFP_KERNEL);
+	if (!ti)
+		goto out;
 
 	for (id = 0; id < count; id++) {
-		result = -ENOMEM;
-		tinfo = kmalloc(sizeof(*tinfo), GFP_KERNEL);
-		if (!tinfo)
-			goto out;
+		tinfo = &ti[id];
 		tinfo->ipvs = ipvs;
-		tinfo->sock = NULL;
 		if (state == IP_VS_STATE_BACKUP) {
+			result = -ENOMEM;
 			tinfo->buf = kmalloc(ipvs->bcfg.sync_maxlen,
 					     GFP_KERNEL);
 			if (!tinfo->buf)
 				goto out;
-		} else {
-			tinfo->buf = NULL;
 		}
 		tinfo->id = id;
 		if (state == IP_VS_STATE_MASTER)
@@ -1885,17 +1876,15 @@ int start_sync_thread(struct netns_ipvs *ipvs, struct ipvs_sync_daemon_cfg *c,
 			result = PTR_ERR(task);
 			goto out;
 		}
-		tinfo = NULL;
-		if (state == IP_VS_STATE_MASTER)
-			ipvs->ms[id].master_thread = task;
-		else
-			array[id] = task;
+		tinfo->task = task;
 	}
 
 	/* mark as active */
 
-	if (state == IP_VS_STATE_BACKUP)
-		ipvs->backup_threads = array;
+	if (state == IP_VS_STATE_MASTER)
+		ipvs->master_tinfo = ti;
+	else
+		ipvs->backup_tinfo = ti;
 	spin_lock_bh(&ipvs->sync_buff_lock);
 	ipvs->sync_state |= state;
 	spin_unlock_bh(&ipvs->sync_buff_lock);
@@ -1910,29 +1899,31 @@ int start_sync_thread(struct netns_ipvs *ipvs, struct ipvs_sync_daemon_cfg *c,
 
 out:
 	/* We do not need RTNL lock anymore, release it here so that
-	 * sock_release below and in the kthreads can use rtnl_lock
-	 * to leave the mcast group.
+	 * sock_release below can use rtnl_lock to leave the mcast group.
 	 */
 	rtnl_unlock();
-	count = id;
-	while (count-- > 0) {
-		if (state == IP_VS_STATE_MASTER)
-			kthread_stop(ipvs->ms[count].master_thread);
-		else
-			kthread_stop(array[count]);
+	id = min(id, count - 1);
+	if (ti) {
+		for (tinfo = ti + id; tinfo >= ti; tinfo--) {
+			if (tinfo->task)
+				kthread_stop(tinfo->task);
+		}
 	}
 	if (!(ipvs->sync_state & IP_VS_STATE_MASTER)) {
 		kfree(ipvs->ms);
 		ipvs->ms = NULL;
 	}
 	mutex_unlock(&ipvs->sync_mutex);
-	if (tinfo) {
-		if (tinfo->sock)
-			sock_release(tinfo->sock);
-		kfree(tinfo->buf);
-		kfree(tinfo);
+
+	/* No more mutexes, release socks */
+	if (ti) {
+		for (tinfo = ti + id; tinfo >= ti; tinfo--) {
+			if (tinfo->sock)
+				sock_release(tinfo->sock);
+			kfree(tinfo->buf);
+		}
+		kfree(ti);
 	}
-	kfree(array);
 	return result;
 
 out_early:
@@ -1944,15 +1935,18 @@ int start_sync_thread(struct netns_ipvs *ipvs, struct ipvs_sync_daemon_cfg *c,
 
 int stop_sync_thread(struct netns_ipvs *ipvs, int state)
 {
-	struct task_struct **array;
+	struct ip_vs_sync_thread_data *ti, *tinfo;
 	int id;
 	int retc = -EINVAL;
 
 	IP_VS_DBG(7, "%s(): pid %d\n", __func__, task_pid_nr(current));
 
+	mutex_lock(&ipvs->sync_mutex);
 	if (state == IP_VS_STATE_MASTER) {
+		retc = -ESRCH;
 		if (!ipvs->ms)
-			return -ESRCH;
+			goto err;
+		ti = ipvs->master_tinfo;
 
 		/*
 		 * The lock synchronizes with sb_queue_tail(), so that we don't
@@ -1971,38 +1965,56 @@ int stop_sync_thread(struct netns_ipvs *ipvs, int state)
 			struct ipvs_master_sync_state *ms = &ipvs->ms[id];
 			int ret;
 
+			tinfo = &ti[id];
 			pr_info("stopping master sync thread %d ...\n",
-				task_pid_nr(ms->master_thread));
+				task_pid_nr(tinfo->task));
 			cancel_delayed_work_sync(&ms->master_wakeup_work);
-			ret = kthread_stop(ms->master_thread);
+			ret = kthread_stop(tinfo->task);
 			if (retc >= 0)
 				retc = ret;
 		}
 		kfree(ipvs->ms);
 		ipvs->ms = NULL;
+		ipvs->master_tinfo = NULL;
 	} else if (state == IP_VS_STATE_BACKUP) {
-		if (!ipvs->backup_threads)
-			return -ESRCH;
+		retc = -ESRCH;
+		if (!ipvs->backup_tinfo)
+			goto err;
+		ti = ipvs->backup_tinfo;
 
 		ipvs->sync_state &= ~IP_VS_STATE_BACKUP;
-		array = ipvs->backup_threads;
 		retc = 0;
 		for (id = ipvs->threads_mask; id >= 0; id--) {
 			int ret;
 
+			tinfo = &ti[id];
 			pr_info("stopping backup sync thread %d ...\n",
-				task_pid_nr(array[id]));
-			ret = kthread_stop(array[id]);
+				task_pid_nr(tinfo->task));
+			ret = kthread_stop(tinfo->task);
 			if (retc >= 0)
 				retc = ret;
 		}
-		kfree(array);
-		ipvs->backup_threads = NULL;
+		ipvs->backup_tinfo = NULL;
+	} else {
+		goto err;
 	}
+	id = ipvs->threads_mask;
+	mutex_unlock(&ipvs->sync_mutex);
+
+	/* No more mutexes, release socks */
+	for (tinfo = ti + id; tinfo >= ti; tinfo--) {
+		if (tinfo->sock)
+			sock_release(tinfo->sock);
+		kfree(tinfo->buf);
+	}
+	kfree(ti);
 
 	/* decrease the module use count */
 	ip_vs_use_count_dec();
+	return retc;
 
+err:
+	mutex_unlock(&ipvs->sync_mutex);
 	return retc;
 }
 
@@ -2021,7 +2033,6 @@ void ip_vs_sync_net_cleanup(struct netns_ipvs *ipvs)
 {
 	int retc;
 
-	mutex_lock(&ipvs->sync_mutex);
 	retc = stop_sync_thread(ipvs, IP_VS_STATE_MASTER);
 	if (retc && retc != -ESRCH)
 		pr_err("Failed to stop Master Daemon\n");
@@ -2029,5 +2040,4 @@ void ip_vs_sync_net_cleanup(struct netns_ipvs *ipvs)
 	retc = stop_sync_thread(ipvs, IP_VS_STATE_BACKUP);
 	if (retc && retc != -ESRCH)
 		pr_err("Failed to stop Backup Daemon\n");
-	mutex_unlock(&ipvs->sync_mutex);
 }
-- 
2.21.0

