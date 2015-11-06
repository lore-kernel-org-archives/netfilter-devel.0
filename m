From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH nf-next 2/3] netfilter: nfnetlink_queue: validate
 dependencies to avoid breaking atomicity
Date: Fri, 6 Nov 2015 09:56:06 +0900
Message-ID: <20151106005606.GC11266@gmail.com>
References: <20151005024454.GA14637@gmail.com>
 <20151005025046.GE14637@gmail.com>
 <20151005152315.GA11562@salvia>
 <20151006021001.GA30037@gmail.com>
 <20151006021246.GB30037@gmail.com>
 <20151006100728.GA2429@salvia>
 <20151007042016.GA23203@gmail.com>
 <20151007042550.GC23203@gmail.com>
 <20151016170532.GA18148@salvia>
 <20151106004640.GA11266@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33571 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932868AbbKFA4L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Nov 2015 19:56:11 -0500
Received: by pabfh17 with SMTP id fh17so103521419pab.0
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Nov 2015 16:56:10 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20151106004640.GA11266@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Check that dependencies are fulfilled before updating the queue
instance, otherwise we can leave things in intermediate state on errors
in nfqnl_recv_config(). This patch also fixes unknown and destroy
command handling.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 net/netfilter/nfnetlink_queue.c |   74 +++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 42 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index f85a3d3..98c9edc 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1118,8 +1118,30 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 	struct nfqnl_instance *queue;
 	struct net *net = sock_net(ctnl);
 	struct nfnl_queue_net *q = nfnl_queue_pernet(net);
+	__u32 flags, mask;
 	int ret = 0;
 
+	/* Check if we support these flags in first place, dependencies should
+	 * be there too not to break atomicity.
+	 */
+	if (nfqa[NFQA_CFG_FLAGS]) {
+		if (!nfqa[NFQA_CFG_MASK])
+			/* A mask is needed to specify which flags are being
+			 * changed.
+			 */
+			return -EINVAL;
+
+		flags = ntohl(nla_get_be32(nfqa[NFQA_CFG_FLAGS]));
+		mask = ntohl(nla_get_be32(nfqa[NFQA_CFG_MASK]));
+
+		if (flags >= NFQA_CFG_F_MAX)
+			return -EOPNOTSUPP;
+#if !IS_ENABLED(CONFIG_NETWORK_SECMARK)
+		if (flags & mask & NFQA_CFG_F_SECCTX)
+			return -EOPNOTSUPP;
+#endif
+	}
+
 	rcu_read_lock();
 	queue = instance_lookup(q, queue_num);
 	if (queue && queue->peer_portid != NETLINK_CB(skb).portid) {
@@ -1149,71 +1171,39 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 				goto err_out_unlock;
 			}
 			instance_destroy(q, queue);
-			break;
+			goto err_out_unlock;
 		case NFQNL_CFG_CMD_PF_BIND:
 		case NFQNL_CFG_CMD_PF_UNBIND:
 			/* Obsolete commands without queue context */
 			goto err_out_unlock;
 		default:
 			ret = -ENOTSUPP;
-			break;
+			goto err_out_unlock;
 		}
 	}
 
+	if (!queue) {
+		ret = -ENODEV;
+		goto err_out_unlock;
+	}
+
 	if (nfqa[NFQA_CFG_PARAMS]) {
-		struct nfqnl_msg_config_params *params;
+		struct nfqnl_msg_config_params *params
+			= nla_data(nfqa[NFQA_CFG_PARAMS]);
 
-		if (!queue) {
-			ret = -ENODEV;
-			goto err_out_unlock;
-		}
-		params = nla_data(nfqa[NFQA_CFG_PARAMS]);
 		nfqnl_set_mode(queue, params->copy_mode,
 				ntohl(params->copy_range));
 	}
 
 	if (nfqa[NFQA_CFG_QUEUE_MAXLEN]) {
-		__be32 *queue_maxlen;
+		__be32 *queue_maxlen = nla_data(nfqa[NFQA_CFG_QUEUE_MAXLEN]);
 
-		if (!queue) {
-			ret = -ENODEV;
-			goto err_out_unlock;
-		}
-		queue_maxlen = nla_data(nfqa[NFQA_CFG_QUEUE_MAXLEN]);
 		spin_lock_bh(&queue->lock);
 		queue->queue_maxlen = ntohl(*queue_maxlen);
 		spin_unlock_bh(&queue->lock);
 	}
 
 	if (nfqa[NFQA_CFG_FLAGS]) {
-		__u32 flags, mask;
-
-		if (!queue) {
-			ret = -ENODEV;
-			goto err_out_unlock;
-		}
-
-		if (!nfqa[NFQA_CFG_MASK]) {
-			/* A mask is needed to specify which flags are being
-			 * changed.
-			 */
-			ret = -EINVAL;
-			goto err_out_unlock;
-		}
-
-		flags = ntohl(nla_get_be32(nfqa[NFQA_CFG_FLAGS]));
-		mask = ntohl(nla_get_be32(nfqa[NFQA_CFG_MASK]));
-
-		if (flags >= NFQA_CFG_F_MAX) {
-			ret = -EOPNOTSUPP;
-			goto err_out_unlock;
-		}
-#if !IS_ENABLED(CONFIG_NETWORK_SECMARK)
-		if (flags & mask & NFQA_CFG_F_SECCTX) {
-			ret = -EOPNOTSUPP;
-			goto err_out_unlock;
-		}
-#endif
 		spin_lock_bh(&queue->lock);
 		queue->flags &= ~mask;
 		queue->flags |= flags & mask;
-- 
1.7.10.4

