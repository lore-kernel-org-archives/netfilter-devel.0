From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/02]: ulog: fix panic on SMP kernels
Date: Sat, 12 Aug 2006 02:25:38 +0200 (MEST)
Message-ID: <20060812002538.30253.39211.sendpatchset@localhost.localdomain>
References: <20060812002535.30253.73682.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060812002535.30253.73682.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ulog: fix panic on SMP kernels

Fix kernel panic on various SMP machines. The culprit is a null
ub->skb in ulog_send(). If ulog_timer() has already been scheduled on
one CPU and is spinning on the lock, and ipt_ulog_packet() flushes the
queue on another CPU by calling ulog_send() right before it exits,
there will be no skbuff when ulog_timer() acquires the lock and calls
ulog_send(). Cancelling the timer in ulog_send() doesn't help because
it has already been scheduled and is running on the first CPU.

Similar problem exists in ebt_ulog.c and nfnetlink_log.c.

Signed-off-by: Mark Huang <mlhuang@cs.princeton.edu>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 005dbeb54700681d8770c3c76ac452387cabe1e1
tree 1d452a2166403710ed576640b6a4d92456a4b69a
parent 85b125c30937bf0ef9fad5f4c3b4eab4588d4580
author Mark Huang <mlhuang@cs.princeton.edu> Fri, 11 Aug 2006 19:39:00 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 11 Aug 2006 19:39:00 +0200

 net/bridge/netfilter/ebt_ulog.c |    3 +++
 net/ipv4/netfilter/ipt_ULOG.c   |    5 +++++
 net/netfilter/nfnetlink_log.c   |    3 +++
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 02693a2..9f950db 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -74,6 +74,9 @@ static void ulog_send(unsigned int nlgro
 	if (timer_pending(&ub->timer))
 		del_timer(&ub->timer);
 
+	if (!ub->skb)
+		return;
+
 	/* last nlmsg needs NLMSG_DONE */
 	if (ub->qlen > 1)
 		ub->lastnlh->nlmsg_type = NLMSG_DONE;
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index d7dd7fe..d46fd67 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -115,6 +115,11 @@ static void ulog_send(unsigned int nlgro
 		del_timer(&ub->timer);
 	}
 
+	if (!ub->skb) {
+		DEBUGP("ipt_ULOG: ulog_send: nothing to send\n");
+		return;
+	}
+
 	/* last nlmsg needs NLMSG_DONE */
 	if (ub->qlen > 1)
 		ub->lastnlh->nlmsg_type = NLMSG_DONE;
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 61cdda4..b59d3b2 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -366,6 +366,9 @@ __nfulnl_send(struct nfulnl_instance *in
 	if (timer_pending(&inst->timer))
 		del_timer(&inst->timer);
 
+	if (!inst->skb)
+		return 0;
+
 	if (inst->qlen > 1)
 		inst->lastnlh->nlmsg_type = NLMSG_DONE;
 
