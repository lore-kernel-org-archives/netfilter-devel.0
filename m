From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 26/33]: nfnetlink_queue: allow changing queue length
	through netlink
Date: Wed, 29 Nov 2006 03:09:24 +0100 (MET)
Message-ID: <20061129020923.21082.60430.sendpatchset@localhost.localdomain>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink_queue: allow changing queue length through netlink

Signed-off-by: Eric Leblond <eric@inl.fr>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ffbf4d47cf2bcd15709396b97b609346be6cc7fd
tree 76e5aac04f1750ae27b66eac7baadda66776f6d3
parent 29bacca329c6e3b2c1db0dcf5e9af0c25f62e499
author Eric Leblond <eric@inl.fr> Tue, 28 Nov 2006 23:13:09 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 29 Nov 2006 02:32:52 +0100

 include/linux/netfilter/nfnetlink_queue.h |    1 +
 net/netfilter/nfnetlink_queue.c           |    8 ++++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_queue.h b/include/linux/netfilter/nfnetlink_queue.h
index 4beea3d..83e7896 100644
--- a/include/linux/netfilter/nfnetlink_queue.h
+++ b/include/linux/netfilter/nfnetlink_queue.h
@@ -82,6 +82,7 @@ enum nfqnl_attr_config {
 	NFQA_CFG_UNSPEC,
 	NFQA_CFG_CMD,			/* nfqnl_msg_config_cmd */
 	NFQA_CFG_PARAMS,		/* nfqnl_msg_config_params */
+	NFQA_CFG_QUEUE_MAXLEN,		/* u_int32_t */
 	__NFQA_CFG_MAX
 };
 #define NFQA_CFG_MAX (__NFQA_CFG_MAX-1)
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 82e4454..a88a017 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -947,6 +947,14 @@ nfqnl_recv_config(struct sock *ctnl, str
 				ntohl(params->copy_range));
 	}
 
+	if (nfqa[NFQA_CFG_QUEUE_MAXLEN-1]) {
+		__be32 *queue_maxlen;
+		queue_maxlen = NFA_DATA(nfqa[NFQA_CFG_QUEUE_MAXLEN-1]);
+		spin_lock_bh(&queue->lock);
+		queue->queue_maxlen = ntohl(*queue_maxlen);
+		spin_unlock_bh(&queue->lock);
+	}
+
 out_put:
 	instance_put(queue);
 	return ret;
