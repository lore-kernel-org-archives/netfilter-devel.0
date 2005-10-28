From: Samir Bellabes <sbellabes@mandriva.com>
Subject: [PATCH] NETFILTER nfnetlink: Use kzalloc
Date: Fri, 28 Oct 2005 18:49:55 +0200
Message-ID: <m2ek65powc.fsf@cerbere.dyndns.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
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

Hi Harald,

   Please consider this cleanup patch.

thanks,

Samir

tree 3c6bf70654e1453b5808587f4436f54083de73ba
parent dcab5e1eeccf5e226c771ecc013631cde157435f
author Samir Bellabes <sbellabes@mandriva.com> 1130434537 +0200
committer Samir Bellabes <sbellabes@mandriva.com> 1130434537 +0200

[PATCH] NETFILTER nfnetlink: Use kzalloc

These are cleanup patches, kzalloc can be use here.

Signed-off-by: Samir Bellabes <sbellabes@mandriva.com>

------------------------------------------------------------------------------

 nfnetlink_log.c   |    6 ++----
 nfnetlink_queue.c |    6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)

------------------------------------------------------------------------------

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -146,11 +146,10 @@ instance_create(u_int16_t group_num, int
 		goto out_unlock;
 	}
 
-	inst = kmalloc(sizeof(*inst), GFP_ATOMIC);
+	inst = kzalloc(sizeof(*inst), GFP_ATOMIC);
 	if (!inst)
 		goto out_unlock;
 
-	memset(inst, 0, sizeof(*inst));
 	INIT_HLIST_NODE(&inst->hlist);
 	inst->lock = SPIN_LOCK_UNLOCKED;
 	/* needs to be two, since we _put() after creation */
@@ -962,10 +961,9 @@ static int nful_open(struct inode *inode
 	struct iter_state *is;
 	int ret;
 
-	is = kmalloc(sizeof(*is), GFP_KERNEL);
+	is = kzalloc(sizeof(*is), GFP_KERNEL);
 	if (!is)
 		return -ENOMEM;
-	memset(is, 0, sizeof(*is));
 	ret = seq_open(file, &nful_seq_ops);
 	if (ret < 0)
 		goto out_free;
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -136,11 +136,10 @@ instance_create(u_int16_t queue_num, int
 		goto out_unlock;
 	}
 
-	inst = kmalloc(sizeof(*inst), GFP_ATOMIC);
+	inst = kzalloc(sizeof(*inst), GFP_ATOMIC);
 	if (!inst)
 		goto out_unlock;
 
-	memset(inst, 0, sizeof(*inst));
 	inst->queue_num = queue_num;
 	inst->peer_pid = pid;
 	inst->queue_maxlen = NFQNL_QMAX_DEFAULT;
@@ -1036,10 +1035,9 @@ static int nfqnl_open(struct inode *inod
 	struct iter_state *is;
 	int ret;
 
-	is = kmalloc(sizeof(*is), GFP_KERNEL);
+	is = kzalloc(sizeof(*is), GFP_KERNEL);
 	if (!is)
 		return -ENOMEM;
-	memset(is, 0, sizeof(*is));
 	ret = seq_open(file, &nfqnl_seq_ops);
 	if (ret < 0)
 		goto out_free;
